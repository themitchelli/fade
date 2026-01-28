#!/bin/bash
# Test: verify prompt.md forbids token variants like 'ALL_COMPLETE: ...' or 'ALL_COMPLETE - ...'
# AC: Update prompt.md to forbid token variants such as 'ALL_COMPLETE: ...' or 'ALL_COMPLETE - ...' as the final completion line.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for forbidding ALL_COMPLETE: variant
if ! grep -q "No variants like.*ALL_COMPLETE:" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not forbid 'ALL_COMPLETE: ...' variant"
    echo "Expected: Text forbidding 'ALL_COMPLETE: ...' variant"
    echo "Actual: Pattern not found"
    exit 1
fi

# Check for forbidding ALL_COMPLETE - variant
if ! grep -q "ALL_COMPLETE - " "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not mention 'ALL_COMPLETE - ...' variant"
    echo "Expected: Text mentioning 'ALL_COMPLETE - ...' as forbidden variant"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md forbids ALL_COMPLETE token variants"
exit 0
