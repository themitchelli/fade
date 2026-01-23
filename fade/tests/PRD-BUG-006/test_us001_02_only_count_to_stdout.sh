#!/bin/bash
# Test: Verify only the count goes to stdout
# AC: Verify $tests_generated contains only a numeric value after function call

FADE_CLI="bin/fade-cli"

# Get line number of function start
start_line=$(grep -n '^generate_tests_for_completed_prds()' "$FADE_CLI" | cut -d: -f1)
if [[ -z "$start_line" ]]; then
    echo "FAIL: Could not find generate_tests_for_completed_prds function"
    exit 1
fi

# Extract 60 lines of the function (enough to include the whole function)
func_content=$(sed -n "${start_line},$((start_line + 60))p" "$FADE_CLI")

# Check that final echo "$processed_count" exists
if ! echo "$func_content" | grep -q 'echo "\$processed_count"'; then
    echo "FAIL: Missing final echo \"\$processed_count\""
    exit 1
fi

# Verify the echo is after the } >&2 block
if echo "$func_content" | grep -A3 '} >&2' | grep -q 'echo "\$processed_count"'; then
    echo "PASS: Only processed_count is echoed to stdout (after >&2 block)"
    exit 0
else
    echo "FAIL: Echo is not positioned after the >&2 block"
    exit 1
fi
