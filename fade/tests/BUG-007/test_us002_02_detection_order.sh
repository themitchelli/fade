#!/bin/bash
# Test: verify detection order is 1. ALL_COMPLETE, 2. STORY_DONE, 3. BLOCKED
# AC: Detection order should be: 1. ALL_COMPLETE, 2. STORY_DONE, 3. BLOCKED

# This test verifies the order of all three signal detections in fade-cli

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

# Find line numbers for each detection pattern
all_complete_line=$(grep -n "grep -qx \"ALL_COMPLETE\"" "$FADE_CLI" | head -1 | cut -d: -f1)
story_done_line=$(grep -n "grep -q '\^STORY_DONE: '" "$FADE_CLI" | head -1 | cut -d: -f1)
blocked_line=$(grep -n "grep -q '\^BLOCKED: '" "$FADE_CLI" | head -1 | cut -d: -f1)

# Verify all patterns are found
if [[ -z "$all_complete_line" ]]; then
    echo "FAIL: Could not find ALL_COMPLETE detection pattern"
    exit 1
fi

if [[ -z "$story_done_line" ]]; then
    echo "FAIL: Could not find STORY_DONE detection pattern"
    exit 1
fi

if [[ -z "$blocked_line" ]]; then
    echo "FAIL: Could not find BLOCKED detection pattern"
    exit 1
fi

# Verify order: ALL_COMPLETE < STORY_DONE < BLOCKED
if [[ "$all_complete_line" -ge "$story_done_line" ]]; then
    echo "FAIL: ALL_COMPLETE should come before STORY_DONE"
    echo "Expected: ALL_COMPLETE < STORY_DONE"
    echo "Actual: ALL_COMPLETE at $all_complete_line, STORY_DONE at $story_done_line"
    exit 1
fi

if [[ "$story_done_line" -ge "$blocked_line" ]]; then
    echo "FAIL: STORY_DONE should come before BLOCKED"
    echo "Expected: STORY_DONE < BLOCKED"
    echo "Actual: STORY_DONE at $story_done_line, BLOCKED at $blocked_line"
    exit 1
fi

echo "PASS: Detection order is correct: ALL_COMPLETE ($all_complete_line) < STORY_DONE ($story_done_line) < BLOCKED ($blocked_line)"
exit 0
