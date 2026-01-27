#!/bin/bash
# Test: fade prd new command exists and shows usage when no feature name provided
# AC: Command `fade prd new` launches an interview flow that asks clarifying questions before writing a PRD.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Act: Run prd new without arguments to see usage
output=$("$FADE_CLI" prd new 2>&1)
exit_code=$?

# Assert: Command should fail with usage info (exit 1 for missing feature name)
if [[ $exit_code -ne 1 ]]; then
    echo "FAIL: prd new without args should exit with code 1"
    echo "Expected: exit code 1 (missing feature name)"
    echo "Actual: exit code $exit_code"
    exit 1
fi

# Assert: Output should contain usage information with 'fade prd new'
if ! echo "$output" | grep -q "fade prd new"; then
    echo "FAIL: prd new should show usage info"
    echo "Expected: output contains 'fade prd new'"
    echo "Actual: $output"
    exit 1
fi

# Assert: Output should mention feature name requirement
if ! echo "$output" | grep -qi "feature name"; then
    echo "FAIL: prd new should mention feature name requirement"
    echo "Expected: output contains 'feature name'"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: fade prd new command exists and shows proper usage"
exit 0
