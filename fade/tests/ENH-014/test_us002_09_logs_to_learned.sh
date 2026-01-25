#!/bin/bash
# Test: verify heuristic reasoning is logged to learned.md
# AC: Log heuristic reasoning to learned.md for review

set -e

# Setup test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Initialize FADE structure
fade init > /dev/null 2>&1
mkdir -p fade/prds

# Create PRD without complexity that fade classify will analyze
cat > fade/prds/FEAT-001-test.json << 'EOF'
{
  "type": "feature",
  "project": "test",
  "id": "FEAT-001",
  "name": "Architecture refactor",
  "description": "Major architecture work",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Refactor",
      "description": "Test",
      "acceptanceCriteria": ["AC1"],
      "priority": 1,
      "passes": false
    }
  ]
}
EOF

# Capture learned.md state before
LEARNED_BEFORE=""
if [[ -f "fade/learned.md" ]]; then
    LEARNED_BEFORE=$(cat fade/learned.md)
fi

# Run fade classify and accept the suggestion
fade classify 2>&1 <<< "y" > /dev/null || true

# Check learned.md for classification log
LEARNED_AFTER=""
if [[ -f "fade/learned.md" ]]; then
    LEARNED_AFTER=$(cat fade/learned.md)
fi

# Cleanup
rm -rf "$TEST_DIR"

# Assert - learned.md should have new content about classification
if [[ "$LEARNED_AFTER" != "$LEARNED_BEFORE" ]] && echo "$LEARNED_AFTER" | grep -qi "classif"; then
    echo "PASS: Heuristic reasoning logged to learned.md"
    exit 0
fi

echo "FAIL: Heuristic reasoning should be logged to learned.md"
echo "learned.md content: $LEARNED_AFTER"
exit 1
