#!/bin/bash
# Test: verify maximum 5 minutes for all healing attempts
# AC: Maximum 5 minutes total for all healing attempts

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify 5-minute timeout (300 seconds) is set
if ! grep -q "timeout_seconds=300" "$FADE_CLI"; then
    echo "FAIL: Test timeout should be 300 seconds (5 minutes)"
    echo "Expected: timeout_seconds=300 in fade-cli"
    echo "Actual: $(grep "timeout_seconds" "$FADE_CLI" || echo "not found")"
    exit 1
fi

# Verify timeout is used in test execution
if ! grep -q "timeout.*timeout_seconds" "$FADE_CLI" || ! grep -q "gtimeout.*timeout_seconds" "$FADE_CLI"; then
    # Check for any timeout usage
    if ! grep -qE "(timeout|gtimeout).*\\\$timeout_seconds" "$FADE_CLI"; then
        # Alternative check for the variable being used
        if ! grep -q 'timeout "$timeout_seconds"' "$FADE_CLI" && ! grep -q 'gtimeout "$timeout_seconds"' "$FADE_CLI"; then
            echo "FAIL: Timeout should be applied to test execution"
            echo "Expected: timeout command using timeout_seconds variable"
            echo "Actual: not found"
            exit 1
        fi
    fi
fi

echo "PASS: Maximum 5 minutes timeout is enforced"
exit 0
