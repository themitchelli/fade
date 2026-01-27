#!/bin/bash
# Test: verify recommend-model.py cites similar PRD from history
# AC: citation of similar PRD + 'Based on: PRD-LC-003 succeeded on Sonnet in 1 session'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Check if history has PRDs
prd_count=$(python3 -c "import json; print(len(json.load(open('$HISTORY_FILE')).get('prds', [])))" 2>/dev/null)
if [[ "$prd_count" -lt 1 ]]; then
    echo "SKIP: No PRDs in history to cite"
    exit 0
fi

# Setup: create temp PRD similar to ones in history
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-SIMILAR-001",
  "type": "feature",
  "description": "Simple feature update",
  "userStories": [
    {"id": "US-001", "acceptanceCriteria": ["AC1", "AC2", "AC3", "AC4", "AC5"]},
    {"id": "US-002", "acceptanceCriteria": ["AC6", "AC7", "AC8", "AC9", "AC10"]},
    {"id": "US-003", "acceptanceCriteria": ["AC11", "AC12", "AC13", "AC14", "AC15"]},
    {"id": "US-004", "acceptanceCriteria": ["AC16", "AC17", "AC18", "AC19", "AC20"]}
  ]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "TEST-SIMILAR-001" "$TEST_DIR/prd.json" "$HISTORY_FILE" 2>/dev/null)

# Assert: output contains "Based on:" line with PRD citation
if [[ "$output" != *"Based on:"* ]]; then
    echo "FAIL: Output should contain 'Based on:' line citing similar PRD"
    echo "Output: $output"
    exit 1
fi

echo "PASS: recommend-model.py cites similar PRD from history"
exit 0
