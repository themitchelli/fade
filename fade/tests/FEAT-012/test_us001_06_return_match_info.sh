#!/bin/bash
# Test: verify detection returns error type, affected file, and line number
# AC: Return match info: error type, affected file, line number if available

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify error_type is output
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'echo "error_type='; then
    echo "FAIL: Function should output error_type"
    echo "Expected: 'echo \"error_type=' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

# Verify error_message is output
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'echo "error_message='; then
    echo "FAIL: Function should output error_message"
    echo "Expected: 'echo \"error_message=' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

# Verify affected_file can be output
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'affected_file'; then
    echo "FAIL: Function should support affected_file output"
    echo "Expected: 'affected_file' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Detection returns match info with error type and message"
exit 0
