#!/bin/bash
# Test: output containing 'shows blocked repos in dashboard' should NOT trigger BLOCKED detection
# AC: Test case: output containing 'shows blocked repos in dashboard' should NOT trigger BLOCKED detection

# Simulate the exact scenario from the PRD that triggered the bug

output="I've implemented the dashboard feature that shows blocked repos with a red indicator.
The analytics display now includes:
- Session timeline with outcome (COMPLETE/BLOCKED)
- Filter for blocked repos
- Shows blocked repos in dashboard

STORY_DONE: US-006"

# Using the same pattern as fade-cli
if echo "$output" | grep -q '^BLOCKED: '; then
    echo "FAIL: Output mentioning 'blocked repos' should NOT trigger BLOCKED detection"
    echo "Expected: no BLOCKED signal detected"
    echo "Actual: BLOCKED signal detected (false positive)"
    exit 1
fi

echo "PASS: 'shows blocked repos in dashboard' does not trigger BLOCKED detection"
exit 0
