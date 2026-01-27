#!/bin/bash
# Test: verify prompt.md instructs STORY_DONE must be a standalone line
# AC: Update prompt.md to instruct that 'STORY_DONE: US-xxx' must be a standalone line and should be the last non-empty line of the message when a user story is completed.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction that STORY_DONE must be standalone line
if ! grep -q "Must be a standalone line" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not specify STORY_DONE must be standalone line"
    echo "Expected: 'Must be a standalone line'"
    echo "Actual: Pattern not found"
    exit 1
fi

# Check for instruction about no suffix on STORY_DONE
if ! grep -q "No suffix like.*STORY_DONE:" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not forbid suffixes on STORY_DONE"
    echo "Expected: Instruction forbidding suffixes on STORY_DONE"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md instructs STORY_DONE must be standalone line with no suffix"
exit 0
