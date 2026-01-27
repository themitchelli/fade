#!/bin/bash
# log-outcome.sh - Log actual PRD outcome to model-selection-history.json
# Usage: log-outcome.sh PRD_ID [MODEL_USED] [ESCALATED_TO]
#
# Logs actual outcomes (sessions, model success, errors) when PRD completes
# so the history database grows and the system learns without manual entry.
#
# Parameters:
#   PRD_ID: PRD identifier (e.g., 'ENH-015')
#   MODEL_USED: Actual model used (haiku/sonnet/opus, optional)
#   ESCALATED_TO: Model escalated to if applicable (optional)
#
# Returns: 0 on success, 1 on error
# Outputs: count of PRDs in history.json

set -o pipefail

PRD_ID="${1}"
MODEL_USED="${2:-sonnet}"  # Default to sonnet if not provided
ESCALATED_TO="${3:-}"

if [[ -z "$PRD_ID" ]]; then
    echo "Usage: log-outcome.sh PRD_ID [MODEL_USED] [ESCALATED_TO]" >&2
    exit 1
fi

# Determine paths - support both contained and legacy structures
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -d "$SCRIPT_DIR/fade" ]]; then
    PROGRESS_MD="$SCRIPT_DIR/fade/progress.md"
    HISTORY_JSON="$SCRIPT_DIR/fade/model-selection-history.json"
    PRDS_DIR="$SCRIPT_DIR/fade/prds"
    PRIORITY_PRD="$SCRIPT_DIR/fade/prd.json"
else
    PROGRESS_MD="$SCRIPT_DIR/progress.md"
    HISTORY_JSON="$SCRIPT_DIR/model-selection-history.json"
    PRDS_DIR="$SCRIPT_DIR/prds"
    PRIORITY_PRD="$SCRIPT_DIR/prd.json"
fi

# Find the PRD file
PRD_JSON=""
if [[ -f "$PRIORITY_PRD" ]]; then
    # Check if priority PRD matches our ID
    prd_id=$(grep -o '"id"\s*:\s*"[^"]*"' "$PRIORITY_PRD" 2>/dev/null | head -1 | sed 's/.*"\([^"]*\)".*/\1/')
    if [[ "$prd_id" == "$PRD_ID" ]]; then
        PRD_JSON="$PRIORITY_PRD"
    fi
fi

# If not found in priority, search prds folder
if [[ -z "$PRD_JSON" ]]; then
    PRD_JSON=$(find "$PRDS_DIR" -name "*$PRD_ID*.json" -type f 2>/dev/null | head -1)
fi

# If still not found, try with assumed filename pattern
if [[ -z "$PRD_JSON" || ! -f "$PRD_JSON" ]]; then
    # Try common patterns
    for pattern in "$PRDS_DIR/$PRD_ID*.json" "$PRDS_DIR/*-$PRD_ID-*.json"; do
        if [[ -f "$pattern" ]]; then
            PRD_JSON="$pattern"
            break
        fi
    done
fi

if [[ ! -f "$PRD_JSON" ]]; then
    echo "Warning: Could not find PRD file for $PRD_ID" >&2
    PRD_JSON=""
fi

# Initialize history file if it doesn't exist
if [[ ! -f "$HISTORY_JSON" ]]; then
    cat > "$HISTORY_JSON" << 'EOF'
{
  "version": "1.0",
  "prds": [],
  "learnedHeuristics": {}
}
EOF
fi

# Get session count using detect-sessions.sh
DETECT_SESSIONS_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"
if [[ ! -f "$DETECT_SESSIONS_SCRIPT" ]]; then
    # Try parent directory
    DETECT_SESSIONS_SCRIPT="$(dirname "$SCRIPT_DIR")/lib/detect-sessions.sh"
fi

if [[ -f "$DETECT_SESSIONS_SCRIPT" ]]; then
    sessions_required=$(bash "$DETECT_SESSIONS_SCRIPT" "$PRD_ID" "$PROGRESS_MD" "$PRD_JSON" 2>/dev/null | tail -1)
else
    echo "Warning: detect-sessions.sh not found, using default sessions=1" >&2
    sessions_required=1
fi

# Default values
sessions_required=${sessions_required:-1}
[[ ! "$sessions_required" =~ ^[0-9]+$ ]] && sessions_required=1

# Extract features from PRD if available
features=""
if [[ -n "$PRD_JSON" && -f "$PRD_JSON" ]]; then
    # Try to use extract-features.py if available
    EXTRACT_FEATURES_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"
    if [[ ! -f "$EXTRACT_FEATURES_SCRIPT" ]]; then
        # Try parent directory
        EXTRACT_FEATURES_SCRIPT="$(dirname "$SCRIPT_DIR")/lib/extract-features.py"
    fi

    if command -v python3 &>/dev/null && [[ -f "$EXTRACT_FEATURES_SCRIPT" ]]; then
        features=$(python3 "$EXTRACT_FEATURES_SCRIPT" "$PRD_JSON" 2>/dev/null)
    else
        # Fallback: minimal feature extraction
        story_count=$(grep -o '"id"\s*:\s*"US-' "$PRD_JSON" 2>/dev/null | wc -l | tr -d '[:space:]')
        ac_count=$(grep -o '"acceptanceCriteria"' "$PRD_JSON" 2>/dev/null | wc -l | tr -d '[:space:]')
        prd_type=$(grep -o '"type"\s*:\s*"[^"]*"' "$PRD_JSON" 2>/dev/null | head -1 | sed 's/.*"\([^"]*\)".*/\1/')

        story_count=${story_count:-0}
        ac_count=${ac_count:-0}
        prd_type=${prd_type:-feature}

        features="{\"storyCount\": $story_count, \"acCount\": $ac_count, \"type\": \"$prd_type\", \"integrationSurface\": 3, \"hasKeywords\": {}}"
    fi
else
    echo "Warning: Could not extract features for $PRD_ID" >&2
    features="{\"storyCount\": 0, \"acCount\": 0, \"type\": \"unknown\", \"integrationSurface\": 3, \"hasKeywords\": {}}"
fi

# Determine escalation status
escalation_needed=false
escalation_point=""

if [[ -n "$ESCALATED_TO" ]]; then
    escalation_needed=true
    escalation_point="escalated from $MODEL_USED to $ESCALATED_TO"
    MODEL_USED="$ESCALATED_TO"
elif [[ "$sessions_required" -gt 1 ]]; then
    # Multiple sessions might indicate escalation was needed
    escalation_needed=true
    escalation_point="multiple sessions required (sessions: $sessions_required)"
fi

# Extract errors from progress.md if multiple sessions
errors="[]"
if [[ "$sessions_required" -gt 1 ]]; then
    # Look for BLOCKED or test failure indicators in progress.md
    blocked_count=$(grep -c "- BLOCKED$" "$PROGRESS_MD" 2>/dev/null || echo 0)
    test_failures=$(grep -c "test.*fail" "$PROGRESS_MD" 2>/dev/null || echo 0)

    errors_list=()
    [[ "$blocked_count" -gt 0 ]] && errors_list+=("\"blocked\"")
    [[ "$test_failures" -gt 0 ]] && errors_list+=("\"test_failure\"")

    if [[ ${#errors_list[@]} -gt 0 ]]; then
        errors="[$(IFS=, ; echo "${errors_list[*]}")]"
    fi
fi

# Get current timestamp in ISO 8601 format
current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Build the outcome object
cat > /tmp/new_prd_entry_$$.json << EOF
{
  "id": "$PRD_ID",
  "date": "$current_date",
  "features": $features,
  "actualOutcome": {
    "sessionsRequired": $sessions_required,
    "modelRecommended": "sonnet",
    "modelSucceeded": "$(echo "$MODEL_USED" | tr '[:upper:]' '[:lower:]')",
    "escalationNeeded": $([[ "$escalation_needed" == "true" ]] && echo "true" || echo "false"),
    "escalationPoint": $([[ -n "$escalation_point" ]] && echo "\"$escalation_point\"" || echo "null"),
    "errors": $errors,
    "recommendation": "Learning from actual outcome"
  }
}
EOF

# Check if PRD already exists in history (avoid duplicates)
existing_count=$(grep -c "\"id\"\s*:\s*\"$PRD_ID\"" "$HISTORY_JSON" 2>/dev/null || echo 0)

if [[ "$existing_count" -gt 0 ]]; then
    # Update existing entry
    # For now, we'll just skip it (could implement update logic)
    echo "Warning: $PRD_ID already in history, skipping duplicate" >&2
    rm -f /tmp/new_prd_entry_$$.json
    # Count current PRDs in history
    prd_count=$(grep -o '"id"\s*:\s*"' "$HISTORY_JSON" 2>/dev/null | wc -l | tr -d '[:space:]')
    echo "$prd_count"
    exit 0
fi

# Use jq to append new entry if available, otherwise use manual insertion
if command -v jq &>/dev/null; then
    # Read history, add new entry, write back
    new_entry=$(cat /tmp/new_prd_entry_$$.json)
    temp_history="/tmp/history_temp_$$.json"

    # Add new PRD entry
    jq ".prds += [$new_entry]" "$HISTORY_JSON" > "$temp_history"

    if [[ -f "$temp_history" ]]; then
        mv "$temp_history" "$HISTORY_JSON"
        echo "Successfully logged $PRD_ID" >&2
    else
        echo "Error: Failed to update history file" >&2
        rm -f /tmp/new_prd_entry_$$.json
        exit 1
    fi
else
    # Fallback: manual JSON insertion (careful with quoting)
    # Find the last "}" and insert before it
    # This is fragile but works for simple cases

    # Create temp file
    temp_history="/tmp/history_temp_$$.json"

    # Remove last character (the closing brace)
    head -c -2 "$HISTORY_JSON" > "$temp_history"

    # Add comma and new entry
    echo "," >> "$temp_history"
    cat /tmp/new_prd_entry_$$.json >> "$temp_history"
    echo "" >> "$temp_history"
    echo "}" >> "$temp_history"

    # Validate the result is valid JSON
    if command -v python3 &>/dev/null; then
        if python3 -m json.tool < "$temp_history" > /dev/null 2>&1; then
            mv "$temp_history" "$HISTORY_JSON"
            echo "Successfully logged $PRD_ID" >&2
        else
            echo "Error: Generated invalid JSON" >&2
            rm -f "$temp_history"
            rm -f /tmp/new_prd_entry_$$.json
            exit 1
        fi
    else
        # Just trust it
        mv "$temp_history" "$HISTORY_JSON"
        echo "Successfully logged $PRD_ID" >&2
    fi
fi

# Clean up temp files
rm -f /tmp/new_prd_entry_$$.json

# Output count of PRDs in history for feedback
prd_count=$(grep -o '"id"\s*:\s*"' "$HISTORY_JSON" 2>/dev/null | wc -l | tr -d '[:space:]')
echo "$prd_count"
exit 0
