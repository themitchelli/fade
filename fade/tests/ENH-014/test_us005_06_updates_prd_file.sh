#!/bin/bash
# Test: verify fade classify updates PRD file with complexity field when user accepts
# AC: If yes: update PRD JSON file with complexity field

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

# Run fade classify and accept the suggestion
fade classify 2>&1 <<< "y" > /dev/null || true

# Check if complexity field was added
if grep -q '"complexity"' fade/prds/FEAT-001-test.json; then
    rm -rf "$TEST_DIR"
    echo "PASS: fade classify updates PRD file with complexity field"
    exit 0
fi

rm -rf "$TEST_DIR"
echo "FAIL: fade classify should update PRD file with complexity field when user accepts"
exit 1
