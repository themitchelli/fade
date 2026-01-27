#!/bin/bash
# Test: verify extract-features.py extracts storyCount
# AC: Extract basic metrics: storyCount (count userStories)

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
story_count=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['storyCount'])" 2>/dev/null)

# Assert: 3 stories
if [[ "$story_count" != "3" ]]; then
    echo "FAIL: Expected storyCount = 3"
    echo "Expected: 3"
    echo "Actual: $story_count"
    echo "Output: $output"
    exit 1
fi

echo "PASS: extract-features.py correctly counts stories"
exit 0
