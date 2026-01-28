#!/bin/bash
# Test: verify prompt.md instructs not to ask for user confirmation
# AC: Update prompt.md to explicitly instruct: do not ask the user for confirmation; proceed with implementation unless the work is truly impossible, in which case emit BLOCKED: <reason>.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for instruction not to ask for confirmation
if ! grep -q "Do NOT ask for confirmation" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not instruct to avoid asking for confirmation"
    echo "Expected: 'Do NOT ask for confirmation'"
    echo "Actual: Pattern not found"
    exit 1
fi

# Check for BLOCKED instruction when impossible
if ! grep -q "If the work is impossible.*BLOCKED" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not instruct to emit BLOCKED when work is impossible"
    echo "Expected: Instruction to emit BLOCKED when work is impossible"
    echo "Actual: Pattern not found"
    exit 1
fi

echo "PASS: prompt.md instructs not to ask for confirmation and to emit BLOCKED when impossible"
exit 0
