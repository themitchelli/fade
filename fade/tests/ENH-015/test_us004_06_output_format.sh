#!/bin/bash
# Test: verify recommend-model.py output format
# AC: Output format: 'Recommend: {MODEL}' + confidence % + reasoning line + citation of similar PRD

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Setup: create temp PRD
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "type": "feature",
  "userStories": [
    {"id": "US-001", "acceptanceCriteria": ["AC1", "AC2", "AC3", "AC4", "AC5"]}
  ]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/prd.json" "$HISTORY_FILE" 2>/dev/null)

# Assert: has "Recommend:" line
if [[ "$output" != *"Recommend:"* ]]; then
    echo "FAIL: Output should contain 'Recommend:' line"
    echo "Output: $output"
    exit 1
fi

# Assert: has "Confidence:" line
if [[ "$output" != *"Confidence:"* ]]; then
    echo "FAIL: Output should contain 'Confidence:' line"
    echo "Output: $output"
    exit 1
fi

# Assert: has "Reasoning:" line
if [[ "$output" != *"Reasoning:"* ]]; then
    echo "FAIL: Output should contain 'Reasoning:' line"
    echo "Output: $output"
    exit 1
fi

echo "PASS: recommend-model.py has correct output format"
exit 0
