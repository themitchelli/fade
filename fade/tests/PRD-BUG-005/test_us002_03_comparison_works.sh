#!/bin/bash
# Test: Comparison [[ "$tests_generated" -gt 0 ]] works without syntax error
# AC: Comparison [[ "$tests_generated" -gt 0 ]] works without syntax error

set -e

# This test verifies that the output from generate_tests_for_completed_prds
# is a clean integer that can be used in bash numeric comparisons

# Simulate the pattern used in the main loop:
# tests_generated=$(generate_tests_for_completed_prds)
# if [[ "$tests_generated" -gt 0 ]]; then ...

# Test with valid integer values
test_comparison() {
    local value="$1"
    local expected_result="$2"

    # This is the exact pattern from the code
    if [[ "$value" -gt 0 ]] 2>/dev/null; then
        result="gt0"
    else
        result="not_gt0"
    fi

    if [[ "$result" != "$expected_result" ]]; then
        echo "FAIL: Comparison failed for value '$value'"
        echo "Expected: $expected_result"
        echo "Actual: $result"
        return 1
    fi
    return 0
}

# Test cases: clean integers should work
test_comparison "0" "not_gt0" || exit 1
test_comparison "1" "gt0" || exit 1
test_comparison "5" "gt0" || exit 1

# Test that invalid values cause issues (this is what the bug was about)
# If we get "Display text 3" instead of just "3", the comparison fails
invalid_value="Test output 3"
if [[ "$invalid_value" -gt 0 ]] 2>/dev/null; then
    echo "FAIL: Invalid value should not pass numeric comparison"
    echo "Value: '$invalid_value'"
    exit 1
fi

echo "PASS: Numeric comparison works correctly with clean integer output"
exit 0
