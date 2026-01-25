#!/bin/bash
# Test: verify detection of 'tail: illegal offset' errors
# AC: Detect 'tail: illegal offset' errors

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the tail: illegal offset pattern is detected
if ! grep -q 'tail: illegal offset' "$FADE_CLI"; then
    echo "FAIL: Code should detect 'tail: illegal offset' pattern"
    echo "Expected: 'tail: illegal offset' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify error_type is set correctly for this pattern
if ! grep -q 'error_type=tail_illegal_offset' "$FADE_CLI"; then
    echo "FAIL: error_type should be 'tail_illegal_offset'"
    echo "Expected: 'error_type=tail_illegal_offset' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: 'tail: illegal offset' errors are detected"
exit 0
