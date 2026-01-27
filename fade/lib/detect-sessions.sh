#!/bin/bash
# detect-sessions.sh - Count distinct work sessions for a PRD
# Usage: detect-sessions.sh PRD_ID progress_md_path prd_json_path
#
# Counts terminal conditions in progress.md (ALL_COMPLETE, BLOCKED)
# and checks for incomplete stories in PRD JSON.
#
# Returns: integer >= 1 (number of sessions)
# Exit code: 0 on success, 1 if critical files missing

# Note: not using 'set -e' because grep -q exits 1 on no match
# Strict mode
set -o pipefail

PRD_ID="${1}"
PROGRESS_MD="${2}"
PRD_JSON="${3}"

if [[ -z "$PRD_ID" || -z "$PROGRESS_MD" || -z "$PRD_JSON" ]]; then
    echo "Usage: detect-sessions.sh PRD_ID progress_md_path prd_json_path" >&2
    exit 1
fi

# Initialize counters
completed_sessions=0
blocked_sessions=0
total_sessions=0

# Count ALL_COMPLETE signals for this PRD in progress.md
completed_sessions=0
if [[ -f "$PROGRESS_MD" ]]; then
    # Pattern: ## YYYY-MM-DD HH:MM - US-XXX: ... ($PRD_ID) - COMPLETE
    # Or:     ## YYYY-MM-DD - US-XXX: ... ($PRD_ID) - COMPLETE
    completed_sessions=$(grep "($PRD_ID).*- COMPLETE" "$PROGRESS_MD" 2>/dev/null | wc -l | tr -d '[:space:]')
fi

# Count BLOCKED signals for this PRD
# Pattern: ## YYYY-MM-DD HH:MM - US-XXX: ... ($PRD_ID) - BLOCKED
blocked_sessions=0
if [[ -f "$PROGRESS_MD" ]]; then
    blocked_sessions=$(grep "($PRD_ID).*- BLOCKED" "$PROGRESS_MD" 2>/dev/null | wc -l | tr -d '[:space:]')
fi

# Check for incomplete stories in PRD JSON
has_incomplete=false
if [[ -f "$PRD_JSON" ]]; then
    # Check if PRD has any story with passes != true
    # Use grep to find "passes": false entries (use || true to handle no matches)
    if grep -q '"passes"\s*:\s*false' "$PRD_JSON" 2>/dev/null || false; then
        has_incomplete=true
    fi
fi

# Calculate total sessions using formula:
# - If has incomplete work: sessions = (completed + blocked) + 1 (current ongoing session)
# - Else: sessions = completed + blocked (but at least 1 for ongoing PRD)
if [[ "$has_incomplete" == "true" ]]; then
    total_sessions=$((completed_sessions + blocked_sessions + 1))
else
    total_sessions=$((completed_sessions + blocked_sessions))
fi

# Ensure at least 1 session (ongoing PRD)
if [[ $total_sessions -eq 0 ]]; then
    total_sessions=1
fi

# Log reasoning to stderr
echo "$PRD_ID: $completed_sessions ALL_COMPLETE + $blocked_sessions BLOCKED + $([ "$has_incomplete" = "true" ] && echo "1" || echo "0") incomplete = $total_sessions session(s)" >&2

# Output the result
echo "$total_sessions"
exit 0
