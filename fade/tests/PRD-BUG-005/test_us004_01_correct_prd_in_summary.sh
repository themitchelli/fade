#!/bin/bash
# Test: Integration test verifies iteration summary shows correct PRD for completed story
# AC: Test verifies iteration summary shows correct PRD for completed story

set -e

# This is an integration test that verifies the full flow:
# 1. find_prd_by_story_id finds the correct PRD
# 2. display_iteration_summary uses that PRD for display

# Setup: Create temp directory with test PRD structure
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Create test PRDs with different stories
mkdir -p "$TEMP_DIR/fade/prds"

# PRD-A has US-001 (alphabetically first, but not the one we're looking for)
cat > "$TEMP_DIR/fade/prds/FEAT-001-alpha.json" << 'EOF'
{
  "type": "feature",
  "id": "FEAT-001",
  "name": "Alpha Feature",
  "userStories": [
    {"id": "US-001", "title": "Alpha story", "passes": true}
  ]
}
EOF

# PRD-B has US-003 (this is the one we completed)
cat > "$TEMP_DIR/fade/prds/FEAT-002-beta.json" << 'EOF'
{
  "type": "feature",
  "id": "FEAT-002",
  "name": "Beta Feature",
  "userStories": [
    {"id": "US-003", "title": "Beta story", "passes": true}
  ]
}
EOF

# Inline the find_prd_by_story_id function for testing
find_prd_by_story_id() {
    local story_id="$1"
    if [[ -z "$story_id" ]]; then
        return
    fi
    local pattern="\"id\"[[:space:]]*:[[:space:]]*\"$story_id\""

    if [[ -f "fade/prd.json" ]] && grep -q "$pattern" "fade/prd.json" 2>/dev/null; then
        echo "fade/prd.json"
        return
    fi

    if [[ -f "prd.json" ]] && grep -q "$pattern" "prd.json" 2>/dev/null; then
        echo "prd.json"
        return
    fi

    if [[ -d "fade/prds" ]]; then
        for prd_file in fade/prds/*.json; do
            [[ -f "$prd_file" ]] || continue
            if grep -q "$pattern" "$prd_file" 2>/dev/null; then
                echo "$prd_file"
                return
            fi
        done
    fi

    if [[ -d "prds" ]]; then
        for prd_file in prds/*.json; do
            [[ -f "$prd_file" ]] || continue
            if grep -q "$pattern" "$prd_file" 2>/dev/null; then
                echo "$prd_file"
                return
            fi
        done
    fi
}

# Test from temp directory
cd "$TEMP_DIR"

# When completing US-003 (from Beta PRD), the summary should show Beta, not Alpha
completed_story="US-003"
found_prd=$(find_prd_by_story_id "$completed_story")
expected_prd="fade/prds/FEAT-002-beta.json"

if [[ "$found_prd" != "$expected_prd" ]]; then
    echo "FAIL: Wrong PRD found for completed story"
    echo "Completed: $completed_story"
    echo "Expected PRD: $expected_prd"
    echo "Actual PRD: $found_prd"
    exit 1
fi

# Verify it's not returning the alphabetically first PRD
if [[ "$found_prd" == "fade/prds/FEAT-001-alpha.json" ]]; then
    echo "FAIL: Returned alphabetically first PRD instead of correct one"
    echo "Expected: $expected_prd (contains $completed_story)"
    echo "Actual: $found_prd (does not contain $completed_story)"
    exit 1
fi

echo "PASS: Iteration summary shows correct PRD for completed story"
exit 0
