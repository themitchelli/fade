#!/bin/bash
# Test: verify estimatedEffort field affects complexity (>1 week = complex)
# AC: Heuristic rules: Check estimatedEffort field ('>1 week' -> complex, '<4 hours' -> simple)

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD with high estimated effort
cat > fade/prds/FEAT-001-test.json << 'EOF'
{
  "type": "feature",
  "project": "test",
  "id": "FEAT-001",
  "name": "Standard Feature",
  "description": "A feature with high effort estimate",
  "estimatedEffort": ">1 week",
  "dependsOn": [],
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

# Check if effort >1 week is detected
if echo "$OUTPUT" | grep -qi "effort.*1 week\|complex"; then
    echo "PASS: EstimatedEffort >1 week triggers complex classification"
    exit 0
fi

echo "FAIL: EstimatedEffort >1 week should affect complexity"
echo "Output: $OUTPUT"
exit 1
