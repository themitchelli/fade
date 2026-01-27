#!/bin/bash
# Test: STORY_DONE detection matches '^STORY_DONE: ' at start of line
# AC: STORY_DONE detection: match '^STORY_DONE: ' at start of line

# Verify the pattern in source code uses '^' anchor
FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if ! grep -q "grep -q '\^STORY_DONE: '" "$FADE_CLI"; then
    echo "FAIL: STORY_DONE detection should use '^STORY_DONE: ' pattern"
    exit 1
fi

# Test pattern behavior

# Should match: at start of line
output1="STORY_DONE: US-001"
if ! echo "$output1" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Should match STORY_DONE at start of line"
    exit 1
fi

# Should match: at start of line in multiline
output2="Previous line
STORY_DONE: US-002
Next line"
if ! echo "$output2" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Should match STORY_DONE at start of line in multiline output"
    exit 1
fi

# Should NOT match: not at start of line
output3="  STORY_DONE: US-003"
if echo "$output3" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Should NOT match STORY_DONE with leading whitespace"
    exit 1
fi

# Should NOT match: mid-line
output4="Signal was STORY_DONE: US-004"
if echo "$output4" | grep -q '^STORY_DONE: '; then
    echo "FAIL: Should NOT match STORY_DONE when not at start of line"
    exit 1
fi

echo "PASS: STORY_DONE detection matches '^STORY_DONE: ' at start of line"
exit 0
