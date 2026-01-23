#!/bin/bash
# Test: verify 'When to Read This Standard' section exists
# AC: Includes 'When to Read This Standard' section

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/standards/architecture.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: architecture.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check for "When to Read" section (allowing slight variations)
if ! echo "$CONTENT" | grep -qi "When to Read"; then
    echo "FAIL: Missing 'When to Read This Standard' section"
    echo "Expected: Section titled 'When to Read This Standard' or similar"
    echo "Actual: Section not found"
    exit 1
fi

echo "PASS: 'When to Read This Standard' section exists"
exit 0
