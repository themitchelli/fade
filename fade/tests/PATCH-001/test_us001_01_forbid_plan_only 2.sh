#!/bin/bash
# Test: verify prompt.md forbids plan-only outputs in autonomous runs
# AC: Update prompt.md to explicitly forbid plan-only outputs, planning-phase handoffs, or writing plan documents as the final output in autonomous runs.

PROMPT_FILE="fade/prompt.md"

# Check file exists
if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "FAIL: prompt.md not found at $PROMPT_FILE"
    exit 1
fi

# Check for forbidding plan documents as final output
if ! grep -q "DO NOT write a plan document and exit" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not forbid writing plan documents and exiting"
    echo "Expected: Text forbidding plan-only outputs"
    echo "Actual: Pattern 'DO NOT write a plan document and exit' not found"
    exit 1
fi

# Check for forbidding planning phases as stopping point
if ! grep -q "DO NOT use planning phases as a stopping point" "$PROMPT_FILE"; then
    echo "FAIL: prompt.md does not forbid planning phases as stopping point"
    echo "Expected: Text forbidding planning-phase handoffs"
    echo "Actual: Pattern 'DO NOT use planning phases as a stopping point' not found"
    exit 1
fi

echo "PASS: prompt.md forbids plan-only outputs and planning-phase handoffs"
exit 0
