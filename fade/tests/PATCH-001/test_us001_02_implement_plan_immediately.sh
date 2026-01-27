#!/bin/bash
# Test: verify prompt.md instructs to implement plan immediately if one exists
# AC: Update prompt.md to explicitly instruct: if the model has already created a plan file, it must implement the plan immediately and MUST NOT create a new plan.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction to implement existing plan immediately
if ! grep -q "already created a plan file.*MUST implement it immediately" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not instruct to implement existing plan immediately"
    echo "Expected: Instruction that if plan file exists, must implement immediately"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md instructs to implement existing plan immediately"
exit 0
