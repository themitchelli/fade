#!/bin/bash
# Test: verify extract-features.py validates numeric fields > 0
# AC: Validate all numeric fields > 0

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

# Setup: create temp PRD with no stories (edge case)
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "type": "feature",
  "userStories": []
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "$TEST_DIR/prd.json" 2>/dev/null)
story_count=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['storyCount'])" 2>/dev/null)
surface=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['integrationSurface'])" 2>/dev/null)

# Assert: storyCount >= 1 (validated to at least 1)
if [[ "$story_count" -lt 1 ]]; then
    echo "FAIL: storyCount should be >= 1 even for empty PRD"
    echo "Expected: >= 1"
    echo "Actual: $story_count"
    exit 1
fi

# Assert: integrationSurface >= 1
if [[ "$surface" -lt 1 ]]; then
    echo "FAIL: integrationSurface should be >= 1"
    echo "Expected: >= 1"
    echo "Actual: $surface"
    exit 1
fi

echo "PASS: extract-features.py validates numeric fields >= 1"
exit 0
