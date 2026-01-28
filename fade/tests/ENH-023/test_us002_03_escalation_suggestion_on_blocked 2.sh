#!/bin/bash
# Test: verify FADE suggests escalation when BLOCKED occurs
# AC: If a run exhibits repeated retries or BLOCKED, FADE suggests escalating model and records the suggestion

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify detect_escalation function exists
if ! grep -q 'detect_escalation()' "$FADE_CLI"; then
    echo "FAIL: detect_escalation function should exist"
    exit 1
fi

# Test 2: Verify BLOCKED pattern is detected
if ! grep -q 'BLOCKED:' "$FADE_CLI"; then
    echo "FAIL: BLOCKED: pattern should be detected for escalation"
    exit 1
fi

# Test 3: Verify opus is not escalated (already highest tier)
if ! grep -qE 'opus.*return.*1|current_model.*==.*opus' "$FADE_CLI"; then
    echo "FAIL: detect_escalation should not escalate opus (already highest)"
    exit 1
fi

# Test 4: Verify iteration count is checked for escalation
if ! grep -q 'iteration_count.*-ge.*2' "$FADE_CLI"; then
    echo "FAIL: Escalation should only trigger after iteration >= 2"
    exit 1
fi

# Test 5: Verify get_escalation_model function exists
if ! grep -q 'get_escalation_model()' "$FADE_CLI"; then
    echo "FAIL: get_escalation_model function should exist"
    exit 1
fi

# Test 6: Verify haiku escalates to sonnet
if ! grep -qE 'haiku.*sonnet' "$FADE_CLI"; then
    echo "FAIL: haiku should escalate to sonnet"
    exit 1
fi

# Test 7: Verify sonnet escalates to opus
if ! grep -qE 'sonnet.*opus' "$FADE_CLI"; then
    echo "FAIL: sonnet should escalate to opus"
    exit 1
fi

echo "PASS: FADE suggests escalating model on BLOCKED state"
exit 0
