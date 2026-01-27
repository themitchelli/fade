#!/bin/bash
# Test: verify get_test_results function exists in fade-cli
# AC: Per-repo expanded view shows: Regression test results (pass/fail counts, last run time)

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found"
    exit 1
fi

# Check for get_test_results function
if ! grep -q 'get_test_results()' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have get_test_results function"
    echo "Expected: get_test_results() function"
    exit 1
fi

echo "PASS: get_test_results function exists"
exit 0
