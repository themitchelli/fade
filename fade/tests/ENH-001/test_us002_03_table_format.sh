#!/bin/bash
# Test: verify architecture.md entry follows existing table format in prompt.md
# AC: Follows existing table format

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILE="$REPO_ROOT/fade/prompt.md"

if [[ ! -f "$FILE" ]]; then
    echo "FAIL: prompt.md does not exist"
    exit 1
fi

CONTENT=$(cat "$FILE")

# Check that the standards table exists with proper markdown format
# Look for table header pattern: | Work Type | Standard to Read |
if ! echo "$CONTENT" | grep -q "| Work Type | Standard"; then
    echo "FAIL: Standards table header not found"
    echo "Expected: Table with '| Work Type | Standard to Read |' header"
    exit 1
fi

# Check that architecture.md row follows pipe format
ARCH_LINE=$(echo "$CONTENT" | grep "architecture.md")

if [[ -z "$ARCH_LINE" ]]; then
    echo "FAIL: architecture.md not found in prompt.md"
    exit 1
fi

# Verify it's in a table row (starts with |)
if ! echo "$ARCH_LINE" | grep -q "^|"; then
    echo "FAIL: architecture.md entry is not in table format"
    echo "Expected: Row starting with | (pipe)"
    echo "Actual: $ARCH_LINE"
    exit 1
fi

# Verify row ends with | (proper table format)
if ! echo "$ARCH_LINE" | grep -q "|$"; then
    echo "FAIL: architecture.md row doesn't end with pipe"
    echo "Expected: Row ending with |"
    echo "Actual: $ARCH_LINE"
    exit 1
fi

echo "PASS: architecture.md entry follows table format"
exit 0
