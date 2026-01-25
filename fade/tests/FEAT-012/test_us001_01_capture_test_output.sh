#!/bin/bash
# Test: verify detect_shell_portability_error reads from test output file
# AC: Capture test output to temporary file when tests fail

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the detection function accepts file path argument
if ! grep -q 'detect_shell_portability_error()' "$FADE_CLI"; then
    echo "FAIL: detect_shell_portability_error function should exist"
    echo "Expected: detect_shell_portability_error() in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify the function reads from file
if ! grep -A 10 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'output_file'; then
    echo "FAIL: Function should accept output file parameter"
    echo "Expected: output_file parameter in function"
    echo "Actual: not found"
    exit 1
fi

# Verify test output is captured to temporary file
if ! grep -q 'test_output_file=' "$FADE_CLI"; then
    echo "FAIL: Test output should be captured to temporary file"
    echo "Expected: test_output_file variable in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Test output is captured and read by detection function"
exit 0
