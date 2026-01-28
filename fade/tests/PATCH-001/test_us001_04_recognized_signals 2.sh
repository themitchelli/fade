#!/bin/bash
# Test: verify prompt.md instructs to end with exactly one recognized signal
# AC: Update prompt.md to explicitly instruct that the model must always end each iteration with exactly one of the recognized signals on its own line: STORY_DONE: <US-ID> OR ALL_COMPLETE OR BLOCKED: <reason>.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction about ending with exactly one signal
if ! grep -q "final output MUST end with exactly one of these signals" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not require ending with exactly one signal"
    echo "Expected: Instruction that output must end with exactly one signal"
    echo "Actual: Pattern not found"
    exit 1
fi

# Check all three signals are documented
if ! grep -q "STORY_DONE: US-XXX" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not document STORY_DONE signal format"
    exit 1
fi

if ! grep -q "ALL_COMPLETE" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not document ALL_COMPLETE signal"
    exit 1
fi

if ! grep -q "BLOCKED:.*<reason>" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not document BLOCKED signal format"
    exit 1
fi

echo "PASS: prompt.md instructs to end with exactly one of the recognized signals"
exit 0
