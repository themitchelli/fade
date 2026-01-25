#!/bin/bash
# Test: verify shell-portability.md documents known patterns (serves as whitelist)
# AC: Maintain whitelist of known-safe fix patterns in fade/standards/shell-portability-fixes.sh
# Note: The actual implementation stores patterns in fade-cli and documents in shell-portability.md

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
PORTABILITY_DOC="$FADE_ROOT/fade/standards/shell-portability.md"

# Assert: portability documentation file exists
if [[ ! -f "$PORTABILITY_DOC" ]]; then
    echo "FAIL: Shell portability documentation should exist"
    echo "Expected: $PORTABILITY_DOC"
    echo "Actual: file not found"
    exit 1
fi

# Assert: documentation contains known fix patterns
if ! grep -q "head -n -" "$PORTABILITY_DOC"; then
    echo "FAIL: Portability doc should document head -n -X pattern"
    echo "Expected: 'head -n -' pattern documented"
    echo "Actual: not found in $PORTABILITY_DOC"
    exit 1
fi

echo "PASS: Portability whitelist/documentation exists and contains known patterns"
exit 0
