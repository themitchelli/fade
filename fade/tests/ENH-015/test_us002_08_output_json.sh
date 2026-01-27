#!/bin/bash
# Test: verify extract-features.py outputs valid JSON
# AC: Output JSON structure: {storyCount, acCount, type, integrationSurface, hasKeywords: {architecture, integrate, migrate, ui, stateful}}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

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
output=$(python3 "$TARGET_SCRIPT" "$TEST_DIR/prd.json" 2>/dev/null)

# Assert: output is valid JSON
if ! echo "$output" | python3 -m json.tool >/dev/null 2>&1; then
    echo "FAIL: Output is not valid JSON"
    echo "Output: $output"
    exit 1
fi

# Assert: has required fields
required_fields=("storyCount" "acCount" "type" "integrationSurface" "hasKeywords")
for field in "${required_fields[@]}"; do
    if ! echo "$output" | python3 -c "import sys, json; d=json.load(sys.stdin); assert '$field' in d" 2>/dev/null; then
        echo "FAIL: Missing required field: $field"
        echo "Output: $output"
        exit 1
    fi
done

# Assert: hasKeywords has all keyword types
keyword_fields=("architecture" "integrate" "migrate" "ui" "stateful")
for field in "${keyword_fields[@]}"; do
    if ! echo "$output" | python3 -c "import sys, json; d=json.load(sys.stdin); assert '$field' in d['hasKeywords']" 2>/dev/null; then
        echo "FAIL: Missing keyword field: $field"
        echo "Output: $output"
        exit 1
    fi
done

echo "PASS: extract-features.py outputs valid JSON with all required fields"
exit 0
