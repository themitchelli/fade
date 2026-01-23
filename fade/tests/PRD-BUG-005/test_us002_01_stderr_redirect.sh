#!/bin/bash
# Test: run_test_generation outputs display text to stderr (>&2) not stdout
# AC: run_test_generation outputs display text to stderr (>&2) not stdout

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract run_test_generation function body
func_body=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Count echo statements that go to stderr (>&2)
stderr_count=$(echo "$func_body" | grep -E '^\s+echo' | grep -c '>&2' || true)

# Count total echo statements (excluding comments)
total_count=$(echo "$func_body" | grep -E '^\s+echo' | grep -v '^\s*#' | wc -l | tr -d ' ')

# Most display echoes should go to stderr
# The function should have at least 10 stderr redirects based on the code review
if [[ "$stderr_count" -lt 10 ]]; then
    echo "FAIL: run_test_generation has insufficient stderr redirects"
    echo "Expected: At least 10 echo statements redirected to stderr"
    echo "Actual: Only $stderr_count of $total_count echo statements use >&2"
    exit 1
fi

echo "PASS: run_test_generation outputs display text to stderr ($stderr_count statements)"
exit 0
