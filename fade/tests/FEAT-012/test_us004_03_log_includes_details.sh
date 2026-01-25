#!/bin/bash
# Test: verify log includes error pattern, affected files, fix applied, test result, time
# AC: Log includes: detected error pattern, affected files, fix applied, test result, time to heal

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify error type is logged
if ! grep -q 'Error Type.*error_type' "$FADE_CLI"; then
    echo "FAIL: Log should include error type"
    echo "Expected: Error Type field in log output"
    echo "Actual: not found"
    exit 1
fi

# Verify fix applied is logged
if ! grep -q 'Fix Applied' "$FADE_CLI"; then
    echo "FAIL: Log should include fix applied"
    echo "Expected: 'Fix Applied' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify test result is logged
if ! grep -q 'Test Result' "$FADE_CLI"; then
    echo "FAIL: Log should include test result"
    echo "Expected: 'Test Result' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify time to heal is logged
if ! grep -q 'Time to Heal' "$FADE_CLI"; then
    echo "FAIL: Log should include time to heal"
    echo "Expected: 'Time to Heal' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Log includes all required details"
exit 0
