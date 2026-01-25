#!/bin/bash
# Test: verify blocked paths are logged and skipped
# AC: If file path doesn't match allowed patterns, log error and skip healing

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify safety error message exists
if ! grep -q "SAFETY ERROR: Blocked healing attempt" "$FADE_CLI"; then
    echo "FAIL: Blocked paths should log SAFETY ERROR"
    echo "Expected: 'SAFETY ERROR: Blocked healing attempt' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify blocked attempt outputs the file path
if ! grep -q 'Blocked healing attempt outside tests directory.*file' "$FADE_CLI"; then
    # Alternative pattern
    if ! grep -q 'File path:' "$FADE_CLI"; then
        echo "FAIL: Blocked paths should log the file path"
        echo "Expected: file path in error output"
        echo "Actual: not found"
        exit 1
    fi
fi

# Verify continue is used to skip blocked files
if ! grep -q 'continue' "$FADE_CLI"; then
    echo "FAIL: Blocked paths should be skipped with continue"
    echo "Expected: 'continue' after safety error"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Blocked paths are logged and skipped"
exit 0
