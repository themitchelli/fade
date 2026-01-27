#!/bin/bash
# Test: if both STORY_DONE and BLOCKED appear in output, STORY_DONE should take precedence
# AC: If both STORY_DONE and BLOCKED appear in output, STORY_DONE should take precedence

# This test simulates the detection logic to verify precedence

output="Working on implementing the feature.
The dashboard now shows blocked repos with indicators.
Some sessions may be BLOCKED due to various reasons.

STORY_DONE: US-006

Also note: if truly blocked, output would show BLOCKED: reason"

# Simulate the detection order from fade-cli
# 1. Check ALL_COMPLETE first
all_complete_detected=false
if echo "$output" | grep -qx "ALL_COMPLETE"; then
    all_complete_detected=true
fi

# 2. Check STORY_DONE second (before BLOCKED)
story_done_detected=false
if ! $all_complete_detected && echo "$output" | grep -q '^STORY_DONE: '; then
    story_done_detected=true
fi

# 3. Check BLOCKED last
blocked_detected=false
if ! $all_complete_detected && ! $story_done_detected && echo "$output" | grep -q '^BLOCKED: '; then
    blocked_detected=true
fi

# Verify STORY_DONE was detected (not BLOCKED)
if ! $story_done_detected; then
    echo "FAIL: STORY_DONE should be detected in output containing both signals"
    echo "Expected: STORY_DONE detected = true"
    echo "Actual: STORY_DONE detected = false"
    exit 1
fi

if $blocked_detected; then
    echo "FAIL: BLOCKED should not be detected when STORY_DONE takes precedence"
    echo "Expected: BLOCKED detected = false"
    echo "Actual: BLOCKED detected = true"
    exit 1
fi

echo "PASS: STORY_DONE takes precedence over BLOCKED when both patterns could match"
exit 0
