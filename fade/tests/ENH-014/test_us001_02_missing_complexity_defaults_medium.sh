#!/bin/bash
# Test: verify missing complexity defaults to 'medium' behavior
# AC: If missing, defaults to 'medium' (current behavior preserved)

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD WITHOUT complexity field
cat > fade/prds/FEAT-001-test.json << 'EOF'
{
  "type": "feature",
  "project": "test",
  "id": "FEAT-001",
  "name": "Test Feature",
  "description": "Test description",
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

# Run fade status --json to get work queue info
STATUS_OUTPUT=$(fade status --json 2>/dev/null)

# Extract complexity from JSON output (should default to medium)
COMPLEXITY=$(echo "$STATUS_OUTPUT" | grep -o '"complexity"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"complexity"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Cleanup
rm -rf "$TEST_DIR"

# Assert - queue should show complexity as medium (default)
if [[ "$COMPLEXITY" != "medium" ]]; then
    echo "FAIL: Missing complexity should default to 'medium'"
    echo "Expected: medium"
    echo "Actual: $COMPLEXITY"
    exit 1
fi

echo "PASS: Missing complexity defaults to 'medium'"
exit 0
