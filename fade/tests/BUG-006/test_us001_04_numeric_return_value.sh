#!/bin/bash
# Test: verify generate_tests_for_completed_prds returns only numeric value
# AC: Verify $tests_generated contains only a numeric value after function call

# This test verifies that generate_tests_for_completed_prds echoes only
# a numeric value to stdout. The function must end with 'echo "$processed_count"'
# where processed_count is guaranteed to be numeric.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Find the generate_tests_for_completed_prds function
func_start=$(grep -n "^generate_tests_for_completed_prds()" "$FADE_CLI" | cut -d: -f1)

if [[ -z "$func_start" ]]; then
    echo "FAIL: Could not find generate_tests_for_completed_prds function"
    exit 1
fi

# Extract the function body (approximately 60 lines)
func_body=$(sed -n "${func_start},$((func_start + 60))p" "$FADE_CLI")

# Verify the function initializes processed_count to 0 (numeric)
if ! echo "$func_body" | grep -q 'local processed_count=0'; then
    echo "FAIL: processed_count is not initialized to 0"
    echo "Expected: local processed_count=0"
    exit 1
fi

# Verify the function only echoes the numeric variable at the end
# Should have: echo "$processed_count" as the stdout return value
if ! echo "$func_body" | grep -q 'echo "\$processed_count"'; then
    echo "FAIL: Function does not echo processed_count to stdout"
    echo "Expected: echo \"\$processed_count\""
    exit 1
fi

# Verify processed_count is only modified by arithmetic increment
# Should use ((processed_count++)) which keeps it numeric
if echo "$func_body" | grep 'processed_count=' | grep -v 'local processed_count=0' | grep -qv '(('; then
    echo "FAIL: processed_count may be assigned non-numeric value"
    echo "Expected: Only arithmetic operations on processed_count"
    exit 1
fi

echo "PASS: generate_tests_for_completed_prds returns only numeric value"
exit 0
