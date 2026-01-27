#!/bin/bash
# Test: verify recommend-model.py recommends HAIKU for simple PRDs
# AC: If storyCount < 7 AND acCount < 50 AND NOT hasKeywords.architecture -> Recommend HAIKU

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Setup: create temp simple PRD (should recommend HAIKU per decision tree)
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Very simple PRD: 2 stories, 6 ACs, no architecture keywords
cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-SIMPLE-001",
  "type": "bug",
  "description": "Fix a small display issue",
  "userStories": [
    {"id": "US-001", "acceptanceCriteria": ["AC1", "AC2", "AC3"]},
    {"id": "US-002", "acceptanceCriteria": ["AC4", "AC5", "AC6"]}
  ]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "TEST-SIMPLE-001" "$TEST_DIR/prd.json" "$HISTORY_FILE" 2>/dev/null)

# Assert: output contains "Recommend:" line
if [[ "$output" != *"Recommend:"* ]]; then
    echo "FAIL: Output should contain 'Recommend:' line"
    echo "Output: $output"
    exit 1
fi

# Extract model recommendation
model=$(echo "$output" | grep "^Recommend:" | awk '{print $NF}')

# For very simple PRD (storyCount < 7 AND acCount < 50 AND NOT architecture)
# Decision tree should recommend HAIKU
# But if storyCount <= 3 (we have 2) then should be HAIKU per line 152-156 of recommend-model.py
if [[ "$model" != "HAIKU" ]]; then
    echo "FAIL: Expected HAIKU for simple PRD (2 stories, 6 ACs, no architecture)"
    echo "Expected: HAIKU"
    echo "Actual: $model"
    echo "Full output: $output"
    exit 1
fi

echo "PASS: recommend-model.py recommends HAIKU for simple PRDs"
exit 0
