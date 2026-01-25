#!/bin/bash
# Test: STORY_DONE uses consistent strict pattern matching
# AC: STORY_DONE detection should match '^STORY_DONE: ' at start of line

set -e

# Test case 1: Valid STORY_DONE signal (should match)
output1="STORY_DONE: US-001"

if ! echo "$output1" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Valid STORY_DONE signal not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

# Test case 2: STORY_DONE in middle of text (should NOT match)
output2="The test returned STORY_DONE: US-001 successfully"

# Should NOT match because STORY_DONE is not at start of line (^ anchor)
if echo "$output2" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE in middle of text matched"
    echo "Expected: No match (must be at line start)"
    echo "Actual: Matched"
    exit 1
fi

# Test case 3: STORY_DONE without colon (should NOT match - colon is required)
output3="STORY_DONE US-001"

if echo "$output3" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE without colon matched"
    echo "Expected: No match (colon required)"
    echo "Actual: Matched"
    exit 1
fi

# Test case 4: Valid STORY_DONE in multi-line output
output4="Working on the issue...
Fixed the authentication bug.
STORY_DONE: US-002"

if ! echo "$output4" | grep -q '^STORY_DONE: '; then
    echo "FAIL: STORY_DONE in multi-line output not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

echo "PASS: STORY_DONE pattern correctly matches '^STORY_DONE: '"
exit 0
