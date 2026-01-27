#!/bin/bash
# Test: verify STORY_DONE detection is checked before BLOCKED in the source code
# AC: Move STORY_DONE detection check before BLOCKED detection check in the if-elseif chain

# This test verifies the order of detection in fade-cli source code

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

# Find line numbers for STORY_DONE and BLOCKED detection
story_done_line=$(grep -n "grep -q '\^STORY_DONE: '" "$FADE_CLI" | head -1 | cut -d: -f1)
blocked_line=$(grep -n "grep -q '\^BLOCKED: '" "$FADE_CLI" | head -1 | cut -d: -f1)

if [[ -z "$story_done_line" ]]; then
    echo "FAIL: Could not find STORY_DONE detection pattern in source"
    exit 1
fi

if [[ -z "$blocked_line" ]]; then
    echo "FAIL: Could not find BLOCKED detection pattern in source"
    exit 1
fi

if [[ "$story_done_line" -ge "$blocked_line" ]]; then
    echo "FAIL: STORY_DONE detection should come BEFORE BLOCKED detection"
    echo "Expected: STORY_DONE line < BLOCKED line"
    echo "Actual: STORY_DONE at line $story_done_line, BLOCKED at line $blocked_line"
    exit 1
fi

echo "PASS: STORY_DONE detection (line $story_done_line) comes before BLOCKED detection (line $blocked_line)"
exit 0
