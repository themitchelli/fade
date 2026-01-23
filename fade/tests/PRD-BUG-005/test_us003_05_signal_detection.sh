#!/bin/bash
# Test: TESTS_GENERATED signal is reliably detected
# AC: TESTS_GENERATED signal is reliably detected

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract run_test_generation function body
func_body=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that the function captures output to a file for signal detection
if ! echo "$func_body" | grep -q 'output_file.*mktemp\|tee.*output_file'; then
    echo "FAIL: run_test_generation does not capture output for signal detection"
    echo "Expected: Output captured to temp file for reliable signal detection"
    exit 1
fi

# Check that it looks for TESTS_GENERATED signal
if ! echo "$func_body" | grep -q 'TESTS_GENERATED'; then
    echo "FAIL: run_test_generation does not look for TESTS_GENERATED signal"
    echo "Expected: grep for TESTS_GENERATED in output"
    exit 1
fi

# Check the signal extraction pattern
if ! echo "$func_body" | grep -q 'TESTS_GENERATED.*PRD'; then
    # Check alternate pattern
    if ! echo "$func_body" | grep -qE 'grep.*TESTS_GENERATED'; then
        echo "FAIL: TESTS_GENERATED signal extraction not implemented"
        exit 1
    fi
fi

# Verify cleanup of temp file
if ! echo "$func_body" | grep -q 'rm.*output_file'; then
    echo "FAIL: Temp file not cleaned up"
    echo "Expected: rm -f \"\$output_file\""
    exit 1
fi

echo "PASS: TESTS_GENERATED signal is reliably detected"
exit 0
