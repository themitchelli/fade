#!/bin/bash
# Test: BLOCKED signal detection should not trigger on "blocked" in context text
# AC: Pattern should NOT match 'blocked repos', 'BLOCKED status', 'outcome (COMPLETE/BLOCKED)', etc.

set -e

# Test case 1: Output containing "blocked" in context should not trigger detection
output1="Dashboard shows blocked repos with red indicator. STORY_DONE: US-006"

# The fixed pattern: grep -q '^BLOCKED: '
# This should NOT match because "blocked" is not at line start with colon
if echo "$output1" | grep -q '^BLOCKED: '; then
    echo "FAIL: False positive detected 'blocked repos' as BLOCKED signal"
    echo "Expected: No match"
    echo "Actual: Matched"
    exit 1
fi

# Test case 2: Output with "BLOCKED status" in middle of text
output2="Check if session is BLOCKED status in dashboard. Working now."

if echo "$output2" | grep -q '^BLOCKED: '; then
    echo "FAIL: False positive detected 'BLOCKED status' as BLOCKED signal"
    echo "Expected: No match"
    echo "Actual: Matched"
    exit 1
fi

# Test case 3: Output with mixed case "blocked"
output3="shows blocked repos and incomplete tasks"

if echo "$output3" | grep -q '^BLOCKED: '; then
    echo "FAIL: False positive detected 'blocked' in mixed context"
    echo "Expected: No match"
    echo "Actual: Matched"
    exit 1
fi

echo "PASS: Context text containing 'blocked' does not trigger BLOCKED detection"
exit 0
