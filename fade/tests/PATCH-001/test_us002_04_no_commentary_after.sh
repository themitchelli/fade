#!/bin/bash
# Test: verify prompt.md instructs no additional commentary after completion token
# AC: Update prompt.md to instruct that no additional commentary may appear AFTER the completion token line.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction about no commentary after token
if ! grep -q "with no additional commentary after" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not instruct no commentary after completion token"
    echo "Expected: Instruction that no additional commentary may appear after token"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md instructs no additional commentary after completion token"
exit 0
