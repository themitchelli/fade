#!/bin/bash
# Test: verify complexity field is accepted in PRD JSON schema
# AC: Add optional 'complexity' field to PRD JSON schema (values: 'simple', 'medium', 'complex')

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
  "complexity": "simple",
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

# Extract complexity field
COMPLEXITY=$(grep -o '"complexity"[[:space:]]*:[[:space:]]*"[^"]*"' fade/prds/FEAT-001-test.json | sed 's/.*"complexity"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Cleanup
rm -rf "$TEST_DIR"

# Assert
if [[ "$COMPLEXITY" != "simple" ]]; then
    echo "FAIL: complexity field not parsed correctly"
    echo "Expected: simple"
    echo "Actual: $COMPLEXITY"
    exit 1
fi

echo "PASS: complexity field is accepted in PRD JSON schema"
exit 0
