#!/bin/bash
# Test: verify maximum 3 healing cycles before giving up
# AC: If tests fail again: attempt up to 3 total healing cycles

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the max attempts limit is 3
if ! grep -q "max_healing_attempts=3" "$FADE_CLI"; then
    echo "FAIL: Maximum healing attempts should be 3"
    echo "Expected: max_healing_attempts=3 in fade-cli"
    echo "Actual: $(grep "max_healing_attempts" "$FADE_CLI" || echo "not found")"
    exit 1
fi

# Verify the loop uses this limit
if ! grep -q "healing_attempt.*max_healing_attempts" "$FADE_CLI"; then
    echo "FAIL: Healing loop should respect max attempts"
    echo "Expected: healing_attempt comparison with max_healing_attempts"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Maximum 3 healing cycles are attempted"
exit 0
