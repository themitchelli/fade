#!/bin/bash
# Test: verify shell-portability.md exists in standards
# AC: Create/update fade/standards/shell-portability.md

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORTABILITY_DOC="$FADE_ROOT/fade/standards/shell-portability.md"

# Assert: shell-portability.md exists
if [[ ! -f "$PORTABILITY_DOC" ]]; then
    echo "FAIL: shell-portability.md should exist"
    echo "Expected: $PORTABILITY_DOC"
    echo "Actual: file not found"
    exit 1
fi

# Assert: file is not empty
if [[ ! -s "$PORTABILITY_DOC" ]]; then
    echo "FAIL: shell-portability.md should not be empty"
    echo "Expected: non-empty file"
    echo "Actual: empty file"
    exit 1
fi

echo "PASS: shell-portability.md exists in standards"
exit 0
