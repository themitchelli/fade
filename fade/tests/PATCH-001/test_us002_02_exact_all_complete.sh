#!/bin/bash
# Test: verify prompt.md instructs final completion line must be EXACTLY 'ALL_COMPLETE' with no suffix
# AC: Update prompt.md to instruct that the final completion line must be EXACTLY 'ALL_COMPLETE' with no suffix when the PRD is fully complete.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction that ALL_COMPLETE must be exact with no suffix
if ! grep -q "Must be exactly.*ALL_COMPLETE.*with no suffix" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not specify ALL_COMPLETE must be exact with no suffix"
    echo "Expected: Instruction that ALL_COMPLETE must be exactly as written with no suffix"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md instructs ALL_COMPLETE must be exact with no suffix"
exit 0
