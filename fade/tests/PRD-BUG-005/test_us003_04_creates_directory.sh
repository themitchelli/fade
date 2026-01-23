#!/bin/bash
# Test: Test directory is created for PRD before test generation
# AC: Test files are actually created after ALL_COMPLETE

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CLI_PATH="$SCRIPT_DIR/../bin/fade-cli"

if [[ ! -f "$CLI_PATH" ]]; then
    echo "FAIL: Cannot find fade-cli at $CLI_PATH"
    exit 1
fi

# Extract run_test_generation function body
func_body=$(sed -n '/^run_test_generation()/,/^[a-z_]*().*{$/p' "$CLI_PATH")

# Check that the function creates the PRD tests directory
if ! echo "$func_body" | grep -q 'mkdir.*prd_tests_dir'; then
    echo "FAIL: run_test_generation does not create test directory"
    echo "Expected: mkdir -p \"\$prd_tests_dir\""
    exit 1
fi

# Check that it copies the PRD to the test folder for traceability
if ! echo "$func_body" | grep -q 'cp.*prd_file.*prd_tests_dir'; then
    echo "FAIL: run_test_generation does not copy PRD to test folder"
    echo "Expected: cp of prd_file to prd_tests_dir"
    exit 1
fi

# Check that test files are made executable after generation
if ! echo "$func_body" | grep -q 'chmod +x'; then
    echo "FAIL: run_test_generation does not make test files executable"
    echo "Expected: chmod +x on test files"
    exit 1
fi

echo "PASS: Test generation creates directory and makes files executable"
exit 0
