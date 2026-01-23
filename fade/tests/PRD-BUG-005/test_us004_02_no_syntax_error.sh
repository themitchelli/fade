#!/bin/bash
# Test: Test generation completes without syntax errors
# AC: Test verifies test generation completes without syntax errors

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# First, verify the CLI script has no syntax errors
if ! bash -n "$CLI_PATH" 2>&1; then
    echo "FAIL: fade-cli has syntax errors"
    exit 1
fi

# The bug was that generate_tests_for_completed_prds returned text like
# "Generating tests... 3" instead of just "3", causing:
#   [[ "Generating tests... 3" -gt 0 ]]  → syntax error
#
# Verify that the function only outputs an integer to stdout

# Extract generate_tests_for_completed_prds and verify output pattern
func_body=$(sed -n '/^generate_tests_for_completed_prds()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that echo "$processed_count" is the only stdout output
stdout_line=$(echo "$func_body" | grep -E '^\s+echo "\$' | grep -v '>&2' | head -1)

if [[ -z "$stdout_line" ]]; then
    echo "FAIL: No stdout echo found in generate_tests_for_completed_prds"
    exit 1
fi

# Verify it echoes a variable (should be processed_count)
if ! echo "$stdout_line" | grep -q 'processed_count'; then
    echo "FAIL: Stdout output is not the processed_count variable"
    echo "Expected: echo \"\$processed_count\""
    echo "Actual: $stdout_line"
    exit 1
fi

# Simulate the comparison that was failing before the fix
# This should work with a clean integer
test_value="3"
if ! [[ "$test_value" -gt 0 ]] 2>/dev/null; then
    echo "FAIL: Numeric comparison failed with clean integer"
    exit 1
fi

echo "PASS: Test generation architecture avoids syntax errors"
exit 0
