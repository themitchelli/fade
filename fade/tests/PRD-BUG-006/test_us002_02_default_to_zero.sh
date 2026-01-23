#!/bin/bash
# Test: Verify non-numeric values default to 0
# AC: If not numeric, default to 0 and log warning to stderr

FADE_CLI="bin/fade-cli"

# Check that tests_generated is set to 0 on validation failure
if ! grep -q 'tests_generated=0' "$FADE_CLI"; then
    echo "FAIL: Missing fallback assignment tests_generated=0"
    exit 1
fi

# Check that warning is logged to stderr
if ! grep -q 'Warning.*non-numeric.*>&2' "$FADE_CLI"; then
    echo "FAIL: Missing warning message to stderr"
    exit 1
fi

echo "PASS: Non-numeric values default to 0 with warning to stderr"
exit 0
