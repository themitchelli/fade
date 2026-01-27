#!/bin/bash
# Test: verify extract-features.py extracts acCount
# AC: Extract basic metrics: acCount (sum acceptanceCriteria across all stories)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

# Setup: create temp PRD
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "type": "feature",
  "userStories": [
    {"id": "US-001", "acceptanceCriteria": ["AC1", "AC2"]},
    {"id": "US-002", "acceptanceCriteria": ["AC3"]},
    {"id": "US-003", "acceptanceCriteria": ["AC4", "AC5", "AC6"]}
  ]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "$TEST_DIR/prd.json" 2>/dev/null)
ac_count=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['acCount'])" 2>/dev/null)

# Assert: 2 + 1 + 3 = 6 acceptance criteria
if [[ "$ac_count" != "6" ]]; then
    echo "FAIL: Expected acCount = 6"
    echo "Expected: 6"
    echo "Actual: $ac_count"
    echo "Output: $output"
    exit 1
fi

echo "PASS: extract-features.py correctly counts acceptance criteria"
exit 0
