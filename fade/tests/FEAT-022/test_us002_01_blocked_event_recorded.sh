#!/bin/bash
# Test: verify FADE detects BLOCKED signals and records a blocked event
# AC: FADE detects BLOCKED signals and records a `blocked` event with reason.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify emit_event is called with "blocked" event type
if ! grep -q 'emit_event.*"blocked"' "$FADE_CLI"; then
    echo "FAIL: FADE should emit blocked event on BLOCKED signal"
    echo "Expected: emit_event call with 'blocked' event type"
    exit 1
fi

# Test 2: Verify blocked event includes the reason
if ! grep 'emit_event.*blocked' "$FADE_CLI" | grep -q 'reason'; then
    echo "FAIL: blocked event should include reason in data"
    echo "Expected: reason field in blocked event data"
    exit 1
fi

# Test 3: Verify BLOCKED signal is detected correctly (pattern matching)
if ! grep -q "'^BLOCKED: '" "$FADE_CLI" || ! grep -q 'grep.*BLOCKED' "$FADE_CLI"; then
    echo "FAIL: BLOCKED signal should be detected with proper pattern"
    echo "Expected: Pattern matching for '^BLOCKED: ' signal"
    exit 1
fi

# Test 4: Verify blocked_reason is extracted from the signal
if ! grep -qE 'blocked_reason.*grep.*BLOCKED|BLOCKED.*blocked_reason' "$FADE_CLI"; then
    echo "FAIL: blocked_reason should be extracted from BLOCKED signal"
    echo "Expected: Extraction of reason text after 'BLOCKED: '"
    exit 1
fi

echo "PASS: FADE detects BLOCKED signals and records blocked event with reason"
exit 0
