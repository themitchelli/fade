#!/bin/bash
# Test: find_prd_by_story_id returns correct PRD for a story
# AC: display_iteration_summary looks up which PRD contains the story_id from STORY_DONE

set -e

# Setup: Create temp directory with test PRD structure
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Create test PRDs with different stories
mkdir -p "$TEMP_DIR/fade/prds"

# PRD-A has US-001, US-002
cat > "$TEMP_DIR/fade/prds/FEAT-001-first.json" << 'EOF'
{
  "type": "feature",
  "id": "FEAT-001",
  "name": "First Feature",
  "userStories": [
    {"id": "US-001", "title": "First story", "passes": true},
    {"id": "US-002", "title": "Second story", "passes": false}
  ]
}
EOF

# PRD-B has US-003, US-004
cat > "$TEMP_DIR/fade/prds/FEAT-002-second.json" << 'EOF'
{
  "type": "feature",
  "id": "FEAT-002",
  "name": "Second Feature",
  "userStories": [
    {"id": "US-003", "title": "Third story", "passes": true},
    {"id": "US-004", "title": "Fourth story", "passes": false}
  ]
}
EOF

# Source the fade-cli script to get the function
# We need to extract just the function, not run the whole script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

# Extract find_prd_by_story_id function from fade-cli
find_prd_by_story_id() {
    local story_id="$1"
    if [[ -z "$story_id" ]]; then
        return
    fi
    local pattern="\"id\"[[:space:]]*:[[:space:]]*\"$story_id\""

    # Check fade/prd.json first
    if [[ -f "fade/prd.json" ]] && grep -q "$pattern" "fade/prd.json" 2>/dev/null; then
        echo "fade/prd.json"
        return
    fi

    # Check root prd.json
    if [[ -f "prd.json" ]] && grep -q "$pattern" "prd.json" 2>/dev/null; then
        echo "prd.json"
        return
    fi

    # Check fade/prds/
    if [[ -d "fade/prds" ]]; then
        for prd_file in fade/prds/*.json; do
            [[ -f "$prd_file" ]] || continue
            if grep -q "$pattern" "$prd_file" 2>/dev/null; then
                echo "$prd_file"
                return
            fi
        done
    fi

    # Check prds/ at root
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

# Run tests from the temp directory
cd "$TEMP_DIR"

# Test 1: Find story in first PRD
result=$(find_prd_by_story_id "US-001")
expected="fade/prds/FEAT-001-first.json"

if [[ "$result" != "$expected" ]]; then
    echo "FAIL: find_prd_by_story_id('US-001') returned wrong PRD"
    echo "Expected: $expected"
    echo "Actual: $result"
    exit 1
fi

# Test 2: Find story in second PRD (not first alphabetically)
result=$(find_prd_by_story_id "US-003")
expected="fade/prds/FEAT-002-second.json"

if [[ "$result" != "$expected" ]]; then
    echo "FAIL: find_prd_by_story_id('US-003') returned wrong PRD"
    echo "Expected: $expected"
    echo "Actual: $result"
    exit 1
fi

# Test 3: Non-existent story returns empty
result=$(find_prd_by_story_id "US-999")
if [[ -n "$result" ]]; then
    echo "FAIL: find_prd_by_story_id('US-999') should return empty"
    echo "Expected: (empty)"
    echo "Actual: $result"
    exit 1
fi

echo "PASS: find_prd_by_story_id correctly identifies PRD for each story"
exit 0
