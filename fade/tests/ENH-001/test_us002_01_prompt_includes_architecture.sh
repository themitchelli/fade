#!/bin/bash
# Test: verify prompt.md 'When to Read Standards' table includes architecture.md
# AC: prompt.md 'When to Read Standards' table includes architecture.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/prompt.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: prompt.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check that architecture.md is referenced in the standards table
if ! echo "$CONTENT" | grep -q "architecture.md"; then
    echo "FAIL: architecture.md not referenced in prompt.md"
    echo "Expected: Reference to standards/architecture.md in the standards table"
    echo "Actual: Not found"
    exit 1
fi

echo "PASS: prompt.md includes architecture.md reference"
exit 0
