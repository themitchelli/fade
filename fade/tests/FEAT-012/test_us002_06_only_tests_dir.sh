#!/bin/bash
# Test: verify fixes only apply to files in fade/tests/ directory
# AC: Apply fixes only to files in fade/tests/ directory

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the safety constraint exists in the code
if ! grep -q "SAFETY ERROR: Blocked healing attempt outside tests directory" "$FADE_CLI"; then
    echo "FAIL: Safety constraint for tests directory should exist in code"
    echo "Expected: 'SAFETY ERROR: Blocked healing attempt outside tests directory' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify the safety check path constraint
if ! grep -q 'tests_realpath' "$FADE_CLI"; then
    echo "FAIL: Code should check files are within tests directory"
    echo "Expected: tests_realpath check in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Fixes are restricted to fade/tests/ directory"
exit 0
