#!/bin/bash
# Test: STORY_DONE detection uses strict pattern matching ('STORY_DONE: US-XXX' format)
# AC: STORY_DONE detection should also use strict pattern matching ('STORY_DONE: US-XXX' format)

# Verify the pattern in source code
FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

# Check that STORY_DONE uses the strict '^STORY_DONE: ' pattern
if ! grep -q "grep -q '\^STORY_DONE: '" "$FADE_CLI"; then
    echo "FAIL: STORY_DONE detection should use strict pattern '^STORY_DONE: '"
    echo "Expected: grep -q '^STORY_DONE: '"
    echo "Actual: pattern not found in source"
    exit 1
fi

# Test the pattern behavior
# Should match
output1="STORY_DONE: US-001"
if ! echo "$output1" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Pattern should match 'STORY_DONE: US-001'"
    exit 1
fi

# Should match (in multiline)
output2="Some output
STORY_DONE: US-006
More output"
if ! echo "$output2" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Pattern should match STORY_DONE at start of line in multiline output"
    exit 1
fi

# Should NOT match (mid-line)
output3="The signal STORY_DONE: US-001 was sent"
if echo "$output3" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Pattern should NOT match STORY_DONE when not at start of line"
    exit 1
fi

echo "PASS: STORY_DONE detection uses strict pattern '^STORY_DONE: '"
exit 0
