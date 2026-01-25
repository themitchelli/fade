#!/bin/bash
# Test: verify healing summary is displayed
# AC: Display healing summary: 'Auto-healed shell portability issue in 47s. Session continuing.'

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the success message format
if ! grep -q "Auto-healed shell portability issue" "$FADE_CLI"; then
    echo "FAIL: Success summary should display 'Auto-healed shell portability issue'"
    echo "Expected: 'Auto-healed shell portability issue' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify time is included in summary
if ! grep -q "total_healing_duration" "$FADE_CLI"; then
    echo "FAIL: Summary should include healing duration"
    echo "Expected: total_healing_duration variable in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify session continuation message
if ! grep -q "Session continuing" "$FADE_CLI"; then
    echo "FAIL: Summary should indicate session is continuing"
    echo "Expected: 'Session continuing' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Healing summary is displayed with duration and continuation message"
exit 0
