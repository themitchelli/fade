#!/bin/bash
# Test: verify documentation covers sed -i differences
# AC: Document 'sed -i' differences between BSD/GNU

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORTABILITY_DOC="$FADE_ROOT/fade/standards/shell-portability.md"

# Assert: documents sed -i differences
if ! grep -q "sed -i" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should cover sed -i"
    echo "Expected: 'sed -i' in documentation"
    echo "Actual: not found"
    exit 1
fi

# Assert: documents the backup extension solution
if ! grep -q "sed -i.bak" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should cover sed -i.bak solution"
    echo "Expected: 'sed -i.bak' in documentation"
    echo "Actual: not found"
    exit 1
fi

# Assert: mentions BSD/GNU difference context
if ! grep -qi "bsd" "$PORTABILITY_DOC" || ! grep -qi "gnu" "$PORTABILITY_DOC"; then
    echo "FAIL: Document should mention BSD and GNU differences"
    echo "Expected: BSD and GNU mentioned"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: sed -i differences between BSD/GNU are documented"
exit 0
