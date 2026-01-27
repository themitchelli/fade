#!/bin/bash
# Test: Signal detection handles trailing whitespace correctly
# AC: Add 2 additional edge case tests: signal at EOF, signal with trailing whitespace

# This test verifies that signal detection works when the signal line
# has trailing spaces or tabs (common in copy-paste scenarios)

# Test STORY_DONE with trailing spaces
output_story_done_spaces="Some output here
STORY_DONE: US-001
More output"

if ! echo "$output_story_done_spaces" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE with trailing spaces not detected"
    echo "Expected: Signal detected despite trailing spaces"
    echo "Actual: Signal not found"
    exit 1
fi

# Test ALL_COMPLETE with trailing tab
output_all_complete_tab="Some output here
ALL_COMPLETE
More output"

if ! echo "$output_all_complete_tab" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: ALL_COMPLETE with trailing tab not detected"
    echo "Expected: Signal detected despite trailing tab"
    echo "Actual: Signal not found"
    exit 1
fi

# Test BLOCKED with trailing whitespace mix
output_blocked_mixed="Some output here
BLOCKED: Test failed
More output"

if ! echo "$output_blocked_mixed" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED with trailing whitespace not detected"
    echo "Expected: Signal detected despite trailing whitespace"
    echo "Actual: Signal not found"
    exit 1
fi

echo "PASS: All signals detected correctly with trailing whitespace"
exit 0
