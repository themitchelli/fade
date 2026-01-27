#!/bin/bash
# Test: verify extract-features.py extracts type
# AC: Extract type: feature/bug/chore/spike/docs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

# Setup: create temp PRD
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "type": "bug",
  "userStories": [{"id": "US-001", "acceptanceCriteria": ["AC1"]}]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "$TEST_DIR/prd.json" 2>/dev/null)
prd_type=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['type'])" 2>/dev/null)

# Assert: type is bug
if [[ "$prd_type" != "bug" ]]; then
    echo "FAIL: Expected type = 'bug'"
    echo "Expected: bug"
    echo "Actual: $prd_type"
    exit 1
fi

echo "PASS: extract-features.py extracts PRD type"
exit 0
