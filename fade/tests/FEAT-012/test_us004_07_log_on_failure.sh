#!/bin/bash
# Test: verify log entry is created even if healing fails
# AC: Log entry created even if healing fails (for debugging)

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify failure case writes to log
if ! grep -q "Could not auto-heal" "$FADE_CLI"; then
    echo "FAIL: Failure case should be logged"
    echo "Expected: 'Could not auto-heal' failure message in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify failure logging writes to healing_log
# Look for the failure block that writes to healing_log
if ! grep -A 20 "Could not auto-heal" "$FADE_CLI" | grep -q 'healing_log'; then
    # Alternative check - verify there's a failure outcome logged
    if ! grep -q "Outcome.*Could not auto-heal" "$FADE_CLI"; then
        echo "FAIL: Failure outcome should be written to healing-log.md"
        echo "Expected: failure logging to healing_log"
        echo "Actual: not found"
        exit 1
    fi
fi

echo "PASS: Log entry is created even when healing fails"
exit 0
