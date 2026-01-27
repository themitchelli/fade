#!/bin/bash
# Test: Signal detection works when signal is at EOF (no trailing newline)
# AC: Run all 6 BUG-007 tests and confirm they pass + Add 2 additional edge case tests

# This test verifies that signal detection works when the signal
# is the last line of output with no trailing newline after it

# Test STORY_DONE at EOF
output_story_done="Some output here
Working on task...
STORY_DONE: US-001"

if ! echo -n "$output_story_done" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE not detected at EOF"
    echo "Expected: Signal detected"
    echo "Actual: Signal not found"
    exit 1
fi

# Test ALL_COMPLETE at EOF
output_all_complete="Some output here
Working on task...
ALL_COMPLETE"

if ! echo -n "$output_all_complete" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: ALL_COMPLETE not detected at EOF"
    echo "Expected: Signal detected"
    echo "Actual: Signal not found"
    exit 1
fi

# Test BLOCKED at EOF
output_blocked="Some output here
Working on task...
BLOCKED: Missing dependency"

if ! echo -n "$output_blocked" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED not detected at EOF"
    echo "Expected: Signal detected"
    echo "Actual: Signal not found"
    exit 1
fi

echo "PASS: All signals detected correctly at EOF"
exit 0
