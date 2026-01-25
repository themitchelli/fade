#!/bin/bash
# Test: verify documentation covers head -n -X issue and sed alternative
# AC: Document 'head -n -X' issue and sed alternative

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORTABILITY_DOC="$FADE_ROOT/fade/standards/shell-portability.md"

# Assert: documents the head -n -X issue
if ! grep -q "head -n -" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should cover head -n -X pattern"
    echo "Expected: 'head -n -' in documentation"
    echo "Actual: not found"
    exit 1
fi

# Assert: documents the sed alternative
if ! grep -q 'sed.*\$d' "$PORTABILITY_DOC"; then
    echo "FAIL: Document should cover sed '\$d' alternative"
    echo "Expected: sed '\$d' pattern in documentation"
    echo "Actual: not found"
    exit 1
fi

# Assert: mentions illegal line count error
if ! grep -q "illegal line count" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should mention 'illegal line count' error"
    echo "Expected: 'illegal line count' in documentation"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: head -n -X issue and sed alternative are documented"
exit 0
