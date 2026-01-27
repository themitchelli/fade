#!/bin/bash
# Test: Feature extraction correctly extracts basic metrics
# AC: Extract storyCount, acCount, type from PRD JSON

set -e

# Create minimal PRD
temp_prd=$(mktemp)
trap "rm -f $temp_prd" EXIT

cat > "$temp_prd" <<'EOF'
{
  "type": "feature",
  "id": "FEAT-001",
  "name": "Test Feature",
  "userStories": [
    {
      "id": "US-001",
      "title": "First",
      "acceptanceCriteria": ["AC1", "AC2", "AC3"]
    },
    {
      "id": "US-002",
      "title": "Second",
      "acceptanceCriteria": ["AC1", "AC2"]
    }
  ]
}
EOF

# Test: Should extract 2 stories, 5 ACs total
result=$(python3 fade/lib/extract-features.py "$temp_prd")

# Check storyCount
story_count=$(echo "$result" | grep '"storyCount"' | grep -o '[0-9]*')
if [[ "$story_count" == "2" ]]; then
    echo "✓ Story count correct: 2"
else
    echo "✗ Story count wrong: expected 2, got $story_count"
    exit 1
fi

# Check acCount
ac_count=$(echo "$result" | grep '"acCount"' | grep -o '[0-9]*')
if [[ "$ac_count" == "5" ]]; then
    echo "✓ AC count correct: 5"
else
    echo "✗ AC count wrong: expected 5, got $ac_count"
    exit 1
fi

# Check type
type_value=$(echo "$result" | grep '"type"' | grep -o ': "[^"]*"' | grep -o '"[^"]*"' | tr -d '"')
if [[ "$type_value" == "feature" ]]; then
    echo "PASS: All metrics extracted correctly"
    exit 0
else
    echo "✗ Type wrong: expected feature, got $type_value"
    exit 1
fi
