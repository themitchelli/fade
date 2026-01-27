#!/bin/bash
# Test: verify prompt.md specifies STORY_DONE must begin with 'STORY_DONE:' and include story id
# AC: Update prompt.md to explicitly instruct that STORY_DONE must be printed as an exact line beginning with 'STORY_DONE:' and include the current user story id.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for STORY_DONE format specification
if ! grep -q 'STORY_DONE: US-XXX' "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not specify STORY_DONE format with US-XXX placeholder"
    echo "Expected: 'STORY_DONE: US-XXX' format specification"
    echo "Actual: Pattern not found"
    exit 1
fi

# Check for instruction to replace with actual story ID
if ! grep -q "Replace.*US-XXX.*with the actual user story ID" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not instruct to replace US-XXX with actual story ID"
    echo "Expected: Instruction to replace US-XXX with actual story ID"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md specifies STORY_DONE format with story ID requirement"
exit 0
