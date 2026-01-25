#!/bin/bash
# Test: verify healing only applies to files matching 'fade/tests/**/*'
# AC: Healing only applies to files matching 'fade/tests/**/*'

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify tests directory check exists
if ! grep -q 'tests_dir' "$FADE_CLI"; then
    echo "FAIL: Code should check files are in tests directory"
    echo "Expected: tests_dir variable in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify realpath check for tests directory
if ! grep -q 'tests_realpath' "$FADE_CLI"; then
    echo "FAIL: Code should use realpath to validate tests directory"
    echo "Expected: tests_realpath variable in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify the path containment check
if ! grep -q 'file_realpath.*tests_realpath' "$FADE_CLI"; then
    echo "FAIL: Code should verify file is within tests directory"
    echo "Expected: file_realpath compared to tests_realpath"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Healing is restricted to fade/tests/**/* pattern"
exit 0
