#!/bin/bash
# Test: verify AC count > 15 triggers complex classification
# AC: Heuristic rules: Count acceptance criteria (AC count > 15 = complex, < 5 = simple)

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD with 20 acceptance criteria (> 15 = complex)
cat > fade/prds/FEAT-001-test.json << 'EOF'
{
  "type": "feature",
  "project": "test",
  "id": "FEAT-001",
  "name": "Big Feature",
  "description": "Test with many ACs",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Story 1",
      "description": "Test",
      "acceptanceCriteria": ["AC1", "AC2", "AC3", "AC4", "AC5"],
      "priority": 1,
      "passes": false
    },
    {
      "id": "US-002",
      "title": "Story 2",
      "description": "Test",
      "acceptanceCriteria": ["AC6", "AC7", "AC8", "AC9", "AC10"],
      "priority": 1,
      "passes": false
    },
    {
      "id": "US-003",
      "title": "Story 3",
      "description": "Test",
      "acceptanceCriteria": ["AC11", "AC12", "AC13", "AC14", "AC15"],
      "priority": 1,
      "passes": false
    },
    {
      "id": "US-004",
      "title": "Story 4",
      "description": "Test",
      "acceptanceCriteria": ["AC16", "AC17", "AC18", "AC19", "AC20"],
      "priority": 1,
      "passes": false
    }
  ]
}
EOF

# Run fade classify in non-interactive mode to get suggestion
# Capture the suggested complexity from output
OUTPUT=$(fade classify 2>&1 <<< "n" || true)

# Cleanup
rm -rf "$TEST_DIR"

# Check if complex was suggested (score should include AC count > 15)
if echo "$OUTPUT" | grep -qi "complex"; then
    echo "PASS: AC count > 15 triggers complex classification"
    exit 0
fi

echo "FAIL: AC count > 15 should trigger complex classification"
echo "Output: $OUTPUT"
exit 1
