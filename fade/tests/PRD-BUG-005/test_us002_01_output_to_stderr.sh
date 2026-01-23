#!/bin/bash
# Test: Test generation outputs display text to stderr, not stdout
# AC: run_test_generation outputs display text to stderr (>&2) not stdout

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract the run_test_generation function and check that echo statements use >&2
# This ensures display output goes to stderr, keeping stdout clean for the count

# Count echo statements in run_test_generation that output to stderr
stderr_echoes=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH" | grep -c '>&2' || true)

# Count total echo statements in run_test_generation (excluding comments and the function that follows)
total_echoes=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH" | grep -E '^\s+echo' | grep -v '^#' | wc -l | tr -d ' ')

if [[ "$stderr_echoes" -lt 10 ]]; then
    echo "FAIL: run_test_generation has too few echo statements redirected to stderr"
    echo "Expected: Most echo statements should use >&2"
    echo "Actual: Only $stderr_echoes statements redirect to stderr"
    exit 1
fi

# Check that the function comment mentions stderr/stdout separation
if ! sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH" | grep -q 'stderr'; then
    echo "FAIL: run_test_generation should document stderr usage"
    echo "Expected: Comment explaining stdout/stderr separation"
    exit 1
fi

echo "PASS: run_test_generation correctly redirects display output to stderr"
exit 0
