#!/bin/bash
# Test: STORY_DONE detection should take priority over BLOCKED
# AC: If both STORY_DONE and BLOCKED appear in output, STORY_DONE should be detected first

set -e

# Test case 1: Output with both STORY_DONE and mention of "blocked" elsewhere
output1="Session shows blocked repos in dashboard.
STORY_DONE: US-006"

# Should detect STORY_DONE (at start of line with colon)
if ! echo "$output1" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE not detected when 'blocked' mentioned in output"
    echo "Expected: STORY_DONE detected"
    echo "Actual: Not detected"
    exit 1
fi

# Should NOT detect BLOCKED (not at start of line with colon)
if echo "$output1" | grep -q '^BLOCKED: '; then
    echo "FAIL: False BLOCKED detection when STORY_DONE also present"
    echo "Expected: BLOCKED not detected"
    echo "Actual: Detected"
    exit 1
fi

# Test case 2: Output with multiple mentions of "blocked"
output2="Dashboard shows blocked repos (red) and blocked tasks (yellow).
Completed all acceptance criteria.
STORY_DONE: US-003"

if ! echo "$output2" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE not detected in complex output"
    echo "Expected: STORY_DONE detected"
    echo "Actual: Not detected"
    exit 1
fi

if echo "$output2" | grep -q '^BLOCKED: '; then
    echo "FAIL: False BLOCKED when STORY_DONE with multiple 'blocked' mentions"
    exit 1
fi

echo "PASS: STORY_DONE correctly takes priority over context mentions of 'blocked'"
exit 0
