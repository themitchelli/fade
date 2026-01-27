#!/bin/bash
# Test: verify pattern does NOT match 'blocked repos', 'BLOCKED status', etc.
# AC: Pattern should NOT match: 'blocked repos', 'BLOCKED status', 'outcome (COMPLETE/BLOCKED)', etc.

# Test the pattern does NOT match false positive cases

# False positive case 1: 'blocked repos' (lowercase, no colon)
output1="Dashboard shows blocked repos with red indicator"
if echo "$output1" | grep -q '^BLOCKED: '; then
    echo "FAIL: Pattern should NOT match 'blocked repos'"
    echo "Expected: no match"
    echo "Actual: matched '$output1'"
    exit 1
fi

# False positive case 2: 'BLOCKED status' (uppercase but no colon at start of line)
output2="Filter for BLOCKED status repos in the list"
if echo "$output2" | grep -q '^BLOCKED: '; then
    echo "FAIL: Pattern should NOT match 'BLOCKED status' mid-line"
    echo "Expected: no match"
    echo "Actual: matched '$output2'"
    exit 1
fi

# False positive case 3: 'outcome (COMPLETE/BLOCKED)' (in parentheses)
output3="Session timeline shows outcome (COMPLETE/BLOCKED)"
if echo "$output3" | grep -q '^BLOCKED: '; then
    echo "FAIL: Pattern should NOT match '(COMPLETE/BLOCKED)'"
    echo "Expected: no match"
    echo "Actual: matched '$output3'"
    exit 1
fi

# False positive case 4: 'Check if session is blocked'
output4="Check if session is blocked before proceeding"
if echo "$output4" | grep -q '^BLOCKED: '; then
    echo "FAIL: Pattern should NOT match 'is blocked'"
    echo "Expected: no match"
    echo "Actual: matched '$output4'"
    exit 1
fi

# False positive case 5: BLOCKED mid-line with colon
output5="The status shows BLOCKED: some context here"
if echo "$output5" | grep -q '^BLOCKED: '; then
    echo "FAIL: Pattern should NOT match 'BLOCKED:' when not at start of line"
    echo "Expected: no match"
    echo "Actual: matched '$output5'"
    exit 1
fi

echo "PASS: Pattern correctly ignores false positive cases"
exit 0
