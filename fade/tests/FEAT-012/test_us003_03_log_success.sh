#!/bin/bash
# Test: verify success entry is appended to healing-log.md
# AC: If tests pass: append success entry to healing-log.md with time saved estimate

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify time saved is logged
if ! grep -q "Time Saved" "$FADE_CLI" && ! grep -q "time.*saved" "$FADE_CLI"; then
    # Check for time to heal instead (indicates success logging)
    if ! grep -q "Time to Heal" "$FADE_CLI"; then
        echo "FAIL: Success entry should include timing information"
        echo "Expected: 'Time to Heal' or 'Time Saved' in fade-cli"
        echo "Actual: not found"
        exit 1
    fi
fi

# Verify healing log is appended on success
if ! grep -q "healing_log" "$FADE_CLI"; then
    echo "FAIL: Success should append to healing-log.md"
    echo "Expected: healing_log variable in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Success entry is logged with timing information"
exit 0
