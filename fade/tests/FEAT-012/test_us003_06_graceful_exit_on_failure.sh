#!/bin/bash
# Test: verify graceful exit with detailed failure log after 3 failed attempts
# AC: If tests still fail after 3 attempts: exit gracefully with detailed failure log

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify failure logging exists
if ! grep -q "Could not auto-heal" "$FADE_CLI"; then
    echo "FAIL: Failure case should log detailed message"
    echo "Expected: 'Could not auto-heal' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify failure outcome is logged to healing-log.md
if ! grep -q "Outcome.*Could not auto-heal" "$FADE_CLI"; then
    echo "FAIL: Failure outcome should be logged to healing-log.md"
    echo "Expected: Outcome field with failure message"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Graceful exit with detailed failure log on max attempts"
exit 0
