#!/bin/bash
# Test: PRD marked as draft for human review
# AC: PRD marked as draft for human review before activation

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for draft field in PRD template
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Search within PRD generation context for draft field
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -q '"draft".*:.*true\|draft.*true'; then
    echo "FAIL: PRD template missing draft: true"
    echo "Expected: PRD template includes '\"draft\": true'"
    echo "Actual: 'draft: true' not found"
    exit 1
fi

# Check for human review guidance
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -qi "human review\|review before"; then
    echo "FAIL: No guidance about human review"
    echo "Expected: mention of human review before activation"
    echo "Actual: human review guidance not found"
    exit 1
fi

echo "PASS: PRD marked as draft for human review"
exit 0
