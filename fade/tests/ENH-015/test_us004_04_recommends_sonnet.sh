#!/bin/bash
# Test: verify recommend-model.py recommends SONNET for moderate PRDs
# AC: Else if storyCount <= 9 AND hasKeywords.integrate AND integrationSurface <= 2 -> Recommend SONNET

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Setup: create temp moderate PRD with integration keywords
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-MODERATE-001",
  "type": "feature",
  "description": "Create an API endpoint to integrate with service",
  "userStories": [
    {"id": "US-001", "acceptanceCriteria": ["AC1", "AC2", "AC3", "AC4", "AC5"]},
    {"id": "US-002", "acceptanceCriteria": ["AC6", "AC7", "AC8", "AC9", "AC10"]},
    {"id": "US-003", "acceptanceCriteria": ["AC11", "AC12", "AC13", "AC14", "AC15"]},
    {"id": "US-004", "acceptanceCriteria": ["AC16", "AC17", "AC18", "AC19", "AC20"]},
    {"id": "US-005", "acceptanceCriteria": ["AC21", "AC22", "AC23", "AC24", "AC25"]}
  ]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "TEST-MODERATE-001" "$TEST_DIR/prd.json" "$HISTORY_FILE" 2>/dev/null)
model=$(echo "$output" | grep "^Recommend:" | awk '{print $NF}')

# Assert: SONNET for moderate complexity with integrate keyword
if [[ "$model" != "SONNET" ]]; then
    echo "FAIL: Expected SONNET for moderate PRD with integrate keywords"
    echo "Expected: SONNET"
    echo "Actual: $model"
    echo "Full output: $output"
    exit 1
fi

echo "PASS: recommend-model.py recommends SONNET for moderate PRDs"
exit 0
