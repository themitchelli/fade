#!/bin/bash
# Test: verify documentation covers portable alternatives for common operations
# AC: Document portable alternatives for common operations

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORTABILITY_DOC="$FADE_ROOT/fade/standards/shell-portability.md"

# Assert: documents portable alternatives (check for a section/table)
if ! grep -qi "portable" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should mention portable alternatives"
    echo "Expected: 'portable' mentioned in documentation"
    echo "Actual: not found"
    exit 1
fi

# Assert: documents alternative patterns (table or list)
if ! grep -q "|" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should include a reference table"
    echo "Expected: table format (|) in documentation"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Portable alternatives are documented"
exit 0
