#!/bin/bash
# Test: generate_tests_for_completed_prds only outputs the count to stdout
# AC: generate_tests_for_completed_prds only outputs the count to stdout

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract generate_tests_for_completed_prds function body
func_body=$(sed -n '/^generate_tests_for_completed_prds()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that the function has only one echo to stdout at the end (the count)
stdout_echoes=$(echo "$func_body" | grep -E '^\s+echo' | grep -v '>&2' | grep -v '^\s*#' || true)
stdout_count=$(echo "$stdout_echoes" | grep -c 'echo' 2>/dev/null || echo "0")

# Should have exactly one echo to stdout: the processed_count
if [[ "$stdout_count" -ne 1 ]]; then
    echo "FAIL: generate_tests_for_completed_prds has wrong number of stdout outputs"
    echo "Expected: Exactly 1 echo to stdout (the count)"
    echo "Actual: $stdout_count echo statements to stdout"
    echo "Stdout echoes found:"
    echo "$stdout_echoes"
    exit 1
fi

# Verify it echoes the processed_count
if ! echo "$stdout_echoes" | grep -q 'processed_count'; then
    echo "FAIL: generate_tests_for_completed_prds stdout is not the count"
    echo "Expected: echo \"\$processed_count\""
    echo "Actual: $stdout_echoes"
    exit 1
fi

echo "PASS: generate_tests_for_completed_prds outputs only the count to stdout"
exit 0
