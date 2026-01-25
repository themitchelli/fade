#!/bin/bash
# Test: verify simple keywords trigger simple classification
# AC: Heuristic rules: Check for keywords ('typo', 'fix', 'update docs', 'add test' -> simple)

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD with simple keyword (typo)
cat > fade/prds/BUG-001-test.json << 'EOF'
{
  "type": "bug",
  "project": "test",
  "id": "BUG-001",
  "name": "Fix typo in README",
  "description": "Simple fix for typo",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Fix the typo",
      "description": "Fix simple typo",
      "acceptanceCriteria": ["Typo fixed"],
      "priority": 1,
      "passes": false
    }
  ]
}
EOF

# Run fade classify to see suggestion
OUTPUT=$(fade classify 2>&1 <<< "n" || true)

# Cleanup
rm -rf "$TEST_DIR"

# Check if simple keywords are detected or result is simple
if echo "$OUTPUT" | grep -qi "simple keyword\|Suggested complexity:.*simple"; then
    echo "PASS: Simple keywords trigger simple classification"
    exit 0
fi

echo "FAIL: Simple keywords should trigger simple classification"
echo "Output: $OUTPUT"
exit 1
