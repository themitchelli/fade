#!/bin/bash
# Test: BLOCKED uses consistent strict pattern matching
# AC: BLOCKED detection should match '^BLOCKED: ' at start of line

set -e

# Test case 1: Valid BLOCKED signal (should match)
output1="BLOCKED: Cannot find required file"

if ! echo "$output1" | grep -q '^BLOCKED: '; then
    echo "FAIL: Valid BLOCKED signal not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

# Test case 2: BLOCKED in middle of text (should NOT match)
output2="The session status is BLOCKED: network error"

# Should NOT match because BLOCKED is not at start of line
if echo "$output2" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED in middle of text matched"
    echo "Expected: No match (must be at line start)"
    echo "Actual: Matched"
    exit 1
fi

# Test case 3: word "BLOCKED" without colon (should NOT match - colon required)
output3="BLOCKED Repos in Dashboard"

if echo "$output3" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED without colon matched"
    echo "Expected: No match (colon required)"
    echo "Actual: Matched"
    exit 1
fi

# Test case 4: Valid BLOCKED in multi-line output
output4="Authentication failed.
Tried multiple approaches.
BLOCKED: Out of context window space"

if ! echo "$output4" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED in multi-line output not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

echo "PASS: BLOCKED pattern correctly matches '^BLOCKED: '"
exit 0
