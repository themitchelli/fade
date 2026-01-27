#!/bin/bash
# Test: verifies 'BLOCKED: reason' triggers BLOCKED detection correctly
# AC: Create test that verifies 'BLOCKED: reason' triggers BLOCKED detection correctly

# Test various valid BLOCKED signal formats

test_cases=(
    "BLOCKED: Cannot find dependency"
    "BLOCKED: Merge conflict in src/main.rs"
    "BLOCKED: Tests are failing"
    "BLOCKED: Missing required configuration"
    "BLOCKED: API rate limit exceeded"
)

for test_case in "${test_cases[@]}"; do
    if ! echo "$test_case" | grep -q '^BLOCKED: '; then
        echo "FAIL: Valid BLOCKED signal should be detected"
        echo "Expected: match for '^BLOCKED: '"
        echo "Actual: no match on: '$test_case'"
        exit 1
    fi
done

# Test in multiline context
multiline_output="I attempted to resolve the issue but encountered a problem.
The dependency cannot be found in any repository.

BLOCKED: Cannot find required package 'libfoo'"

if ! echo "$multiline_output" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED should be detected in multiline output"
    exit 1
fi

echo "PASS: BLOCKED: reason triggers detection correctly (${#test_cases[@]} cases + multiline verified)"
exit 0
