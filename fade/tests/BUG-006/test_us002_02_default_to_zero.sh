#!/bin/bash
# Test: verify non-numeric values default to 0 with warning
# AC: If not numeric, default to 0 and log warning to stderr

# This test verifies that when tests_generated is not numeric,
# the code defaults it to 0 and logs a warning to stderr.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Find the validation block - should have if/then structure
# Pattern: if ! [[ numeric check ]]; then ... tests_generated=0 ... fi
validation_block=$(grep -A 5 'tests_generated.*=~' "$FADE_CLI" | head -6)

if [[ -z "$validation_block" ]]; then
    echo "FAIL: Could not find validation block"
    exit 1
fi

# Check that tests_generated=0 is the fallback
if ! echo "$validation_block" | grep -q 'tests_generated=0'; then
    echo "FAIL: No default to 0 when validation fails"
    echo "Expected: tests_generated=0"
    echo "Found block:"
    echo "$validation_block"
    exit 1
fi

# Check that warning is logged to stderr
if ! echo "$validation_block" | grep -q '>&2'; then
    echo "FAIL: Warning message not redirected to stderr"
    echo "Expected: Warning with >&2 redirect"
    echo "Found block:"
    echo "$validation_block"
    exit 1
fi

# Verify the warning message mentions non-numeric
if ! echo "$validation_block" | grep -qi 'non-numeric\|warning'; then
    echo "FAIL: Warning message should indicate non-numeric value issue"
    echo "Expected: Message containing 'non-numeric' or 'Warning'"
    exit 1
fi

echo "PASS: Non-numeric values default to 0 with stderr warning"
exit 0
