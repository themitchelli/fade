#!/bin/bash
# Test: verify extract-features.py estimates integrationSurface
# AC: Estimate integrationSurface: 1-2 (light - single subsystem), 3-5 (moderate - 2-3 subsystems), 6+ (heavy - 4+ subsystems)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

# Setup: create temp PRD with multiple subsystem mentions
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "type": "feature",
  "description": "Update the API, database storage, cache layer, and auth system",
  "userStories": [{"id": "US-001", "acceptanceCriteria": ["AC1"]}]
}
EOF

# Act
output=$(python3 "$TARGET_SCRIPT" "$TEST_DIR/prd.json" 2>/dev/null)
surface=$(echo "$output" | python3 -c "import sys, json; print(json.load(sys.stdin)['integrationSurface'])" 2>/dev/null)

# Assert: integration surface is numeric and within valid range
if ! [[ "$surface" =~ ^[1-9][0-9]*$ ]]; then
    echo "FAIL: Expected integrationSurface to be a positive integer"
    echo "Expected: positive integer"
    echo "Actual: $surface"
    exit 1
fi

echo "PASS: extract-features.py estimates integrationSurface"
exit 0
