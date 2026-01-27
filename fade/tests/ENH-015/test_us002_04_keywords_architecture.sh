#!/bin/bash
# Test: verify extract-features.py detects architecture keywords
# AC: Detect keywords via regex: architecture: /architecture|bus|protocol|dag|pipeline|distributed|sync|lock|race|multi-threaded/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

# Setup: create temp PRD with architecture keywords
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "type": "feature",
  "description": "Build a distributed system with message bus architecture",
  "userStories": [{"id": "US-001", "acceptanceCriteria": ["AC1"]}]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "$TEST_DIR/prd.json" 2>/dev/null)
has_arch=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['hasKeywords']['architecture'])" 2>/dev/null)

# Assert: architecture keyword detected
if [[ "$has_arch" != "True" ]]; then
    echo "FAIL: Expected architecture keyword to be detected"
    echo "Expected: True"
    echo "Actual: $has_arch"
    exit 1
fi

echo "PASS: extract-features.py detects architecture keywords"
exit 0
