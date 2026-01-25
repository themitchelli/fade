#!/bin/bash
# Test: verify fade status displays complexity in output
# AC: Display complexity in fade status output: '[simple] ENH-014' vs '[complex] FEAT-012'

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD with complexity field
cat > fade/prds/FEAT-001-test.json << 'EOF'
{
  "type": "feature",
  "project": "test",
  "id": "FEAT-001",
  "name": "Test Feature",
  "description": "Test description",
  "complexity": "complex",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Test story",
      "description": "Test",
      "acceptanceCriteria": ["Test AC"],
      "priority": 1,
      "passes": false
    }
  ]
}
EOF

# Run fade status and capture output
STATUS_OUTPUT=$(fade status 2>&1)

# Cleanup
rm -rf "$TEST_DIR"

# Assert - check for [complex] in output
if echo "$STATUS_OUTPUT" | grep -q "\[complex\]"; then
    echo "PASS: fade status displays complexity in output"
    exit 0
fi

echo "FAIL: Complexity not displayed in fade status output"
echo "Expected: [complex] to appear in output"
echo "Actual output:"
echo "$STATUS_OUTPUT"
exit 1
