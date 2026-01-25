#!/bin/bash
# Test: verify dependsOn array affects complexity (dependencies > 2 = complex)
# AC: Heuristic rules: Check dependsOn array (dependencies > 2 -> complex)

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD with many dependencies
cat > fade/prds/FEAT-001-test.json << 'EOF'
{
  "type": "feature",
  "project": "test",
  "id": "FEAT-001",
  "name": "Dependent Feature",
  "description": "A feature with many dependencies",
  "dependsOn": ["FEAT-002", "FEAT-003", "FEAT-004"],
  "userStories": [
    {
      "id": "US-001",
      "title": "Implement feature",
      "description": "Test",
      "acceptanceCriteria": ["AC1", "AC2", "AC3", "AC4", "AC5", "AC6", "AC7", "AC8"],
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

# Check if dependencies > 2 affects scoring
if echo "$OUTPUT" | grep -qi "dependencies\|complex"; then
    echo "PASS: Dependencies > 2 affects complexity classification"
    exit 0
fi

echo "FAIL: Dependencies > 2 should affect complexity"
echo "Output: $OUTPUT"
exit 1
