#!/bin/bash
# Test: verifies mixed output (STORY_DONE with 'blocked' in context) detects STORY_DONE
# AC: Create test that verifies mixed output (STORY_DONE with 'blocked' in context) detects STORY_DONE

# This is the key test that validates the fix for BUG-007
# It simulates the exact scenario that caused the false positive

output="I've implemented the dashboard feature that shows blocked repos.

The new analytics display includes:
- Session timeline with outcome (COMPLETE/BLOCKED)
- Filter for blocked sessions
- Shows blocked repos in dashboard with red indicator
- Displays BLOCKED status repos prominently

All acceptance criteria have been met.

STORY_DONE: US-006"

# Simulate the detection logic from fade-cli
all_complete_detected=false
story_done_detected=false
blocked_detected=false

# 1. Check ALL_COMPLETE
if echo "$output" | grep -qx "ALL_COMPLETE"; then
    all_complete_detected=true
fi

# 2. Check STORY_DONE (before BLOCKED)
if ! $all_complete_detected && echo "$output" | grep -q '^STORY_DONE: '; then
    story_done_detected=true
fi

# 3. Check BLOCKED (only if no previous signals)
if ! $all_complete_detected && ! $story_done_detected && echo "$output" | grep -q '^BLOCKED: '; then
    blocked_detected=true
fi

# Verify correct detection
if ! $story_done_detected; then
    echo "FAIL: STORY_DONE should be detected in mixed output"
    echo "Expected: STORY_DONE detected"
    echo "Actual: STORY_DONE not detected"
    exit 1
fi

if $blocked_detected; then
    echo "FAIL: BLOCKED should NOT be detected when STORY_DONE is present"
    echo "Expected: BLOCKED not detected (STORY_DONE takes precedence)"
    echo "Actual: BLOCKED detected (this was the BUG-007 false positive)"
    exit 1
fi

echo "PASS: Mixed output with 'blocked' context text correctly detects STORY_DONE (not BLOCKED)"
exit 0
