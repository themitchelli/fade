#!/bin/bash
# Test: verify recommend-model.py exits 0 on success
# AC: Exit code 0 on success

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
  "userStories": [{"id": "US-001", "acceptanceCriteria": ["AC1"]}]
}
EOF

# Act
python3 "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/prd.json" "$HISTORY_FILE" >/dev/null 2>&1
exit_code=$?

# Assert
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: Expected exit code 0 on success"
    echo "Expected: 0"
    echo "Actual: $exit_code"
    exit 1
fi

echo "PASS: recommend-model.py exits 0 on success"
exit 0
