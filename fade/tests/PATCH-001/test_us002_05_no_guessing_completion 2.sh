#!/bin/bash
# Test: verify prompt.md instructs not to guess completion, implement or emit BLOCKED instead
# AC: Update prompt.md to instruct that if uncertain whether work is complete, the model should not guess completion; it should either implement missing work or emit 'BLOCKED: <reason>'.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction not to guess completion
if ! grep -q "Do not guess completion" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not instruct to avoid guessing completion"
    echo "Expected: 'Do not guess completion' instruction"
    echo "Actual: Pattern not found"
    exit 1
fi

# Check for instruction about strict parser
if ! grep -q "strict parser" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not mention FADE is a strict parser"
    echo "Expected: Mention that FADE/orchestrator is a strict parser"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md instructs not to guess completion and mentions strict parser"
exit 0
