#!/bin/bash
# Test: verify generate_tests_for_completed_prds only outputs numeric value to stdout
# AC: Redirect ALL display output to stderr (>&2) in the test generation flow

# This test verifies that the generate_tests_for_completed_prds function
# returns ONLY a numeric value on stdout. All display messages (banners,
# status, etc.) must go to stderr.

# Setup - find the fade-cli script
FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Extract the generate_tests_for_completed_prds function and its stdout behavior
# The function body should wrap all display output in >&2 redirect
# Specifically check that the block starting with { and ending with } >&2 exists

# Check that the main logic block redirects to stderr
if ! grep -A 50 "^generate_tests_for_completed_prds()" "$FADE_CLI" | grep -q '} >&2'; then
    echo "FAIL: generate_tests_for_completed_prds does not redirect block output to stderr"
    echo "Expected: Block ending with '} >&2' to redirect all display output"
    echo "Actual: No block stderr redirect found"
    exit 1
fi

# Check that all echo statements in run_test_generation redirect to stderr
# This is the critical fix - run_test_generation echos must use >&2
run_test_gen_start=$(grep -n "^run_test_generation()" "$FADE_CLI" | cut -d: -f1)

if [[ -z "$run_test_gen_start" ]]; then
    echo "FAIL: Could not find run_test_generation function"
    exit 1
fi

# Extract the function body (approximately 100 lines)
run_test_gen_body=$(sed -n "${run_test_gen_start},$((run_test_gen_start + 100))p" "$FADE_CLI")

# Count echo statements that DON'T redirect to stderr (should be 0)
# Look for echo that isn't followed by >&2
non_stderr_echoes=$(echo "$run_test_gen_body" | grep -E '^\s+echo' | grep -v '>&2' | grep -v '| tee' || true)

if [[ -n "$non_stderr_echoes" ]]; then
    echo "FAIL: Found echo statements in run_test_generation not redirecting to stderr"
    echo "Expected: All echo statements should have >&2"
    echo "Actual non-redirected echo statements:"
    echo "$non_stderr_echoes"
    exit 1
fi

echo "PASS: All display output in test generation flow redirects to stderr"
exit 0
