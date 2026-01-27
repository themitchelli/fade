#!/bin/bash
# Test: verify recommend-model.py recommends OPUS for complex PRDs
# AC: Else if hasKeywords.architecture OR (hasKeywords.integrate AND integrationSurface >= 3) -> Recommend OPUS

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Setup: create temp complex PRD with architecture keywords
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-COMPLEX-001",
  "type": "feature",
  "description": "Build distributed architecture with message bus and pipeline for sync across multiple subsystems",
  "userStories": [
    {"id": "US-001", "acceptanceCriteria": ["AC1", "AC2", "AC3", "AC4", "AC5", "AC6", "AC7", "AC8", "AC9", "AC10"]},
    {"id": "US-002", "acceptanceCriteria": ["AC11", "AC12", "AC13", "AC14", "AC15", "AC16", "AC17", "AC18", "AC19", "AC20"]},
    {"id": "US-003", "acceptanceCriteria": ["AC21", "AC22", "AC23", "AC24", "AC25", "AC26", "AC27", "AC28", "AC29", "AC30"]},
    {"id": "US-004", "acceptanceCriteria": ["AC31", "AC32", "AC33", "AC34", "AC35", "AC36", "AC37", "AC38", "AC39", "AC40"]},
    {"id": "US-005", "acceptanceCriteria": ["AC41", "AC42", "AC43", "AC44", "AC45", "AC46", "AC47", "AC48", "AC49", "AC50"]},
    {"id": "US-006", "acceptanceCriteria": ["AC51", "AC52", "AC53", "AC54", "AC55", "AC56", "AC57", "AC58", "AC59", "AC60"]}
  ]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "TEST-COMPLEX-001" "$TEST_DIR/prd.json" "$HISTORY_FILE" 2>/dev/null)
model=$(echo "$output" | grep "^Recommend:" | awk '{print $NF}')

# Assert: OPUS for complex architecture work
if [[ "$model" != "OPUS" ]]; then
    echo "FAIL: Expected OPUS for complex PRD with architecture keywords"
    echo "Expected: OPUS"
    echo "Actual: $model"
    echo "Full output: $output"
    exit 1
fi

echo "PASS: recommend-model.py recommends OPUS for complex PRDs"
exit 0
