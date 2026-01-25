#!/bin/bash
# Test: verify detection of 'sed: -i needs an argument' errors
# AC: Detect 'sed: -i needs an argument' errors

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify sed -i pattern detection (multiple possible error messages)
if ! grep -qE 'sed:.*-i.*(may not|needs|requires|argument)' "$FADE_CLI"; then
    echo "FAIL: Code should detect sed -i argument errors"
    echo "Expected: sed -i argument detection pattern in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify error_type is set correctly for this pattern
if ! grep -q 'error_type=sed_i_needs_argument' "$FADE_CLI"; then
    echo "FAIL: error_type should be 'sed_i_needs_argument'"
    echo "Expected: 'error_type=sed_i_needs_argument' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: 'sed: -i needs argument' errors are detected"
exit 0
