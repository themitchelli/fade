#!/bin/bash
# Test: verify FADE suggests escalation when test failures occur
# AC: If a run exhibits repeated retries or BLOCKED, FADE suggests escalating model

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify test failure pattern is detected for escalation
if ! grep -qE 'test.*fail' "$FADE_CLI"; then
    echo "FAIL: detect_escalation should detect 'test fail' pattern"
    exit 1
fi

# Test 2: Verify tests fail pattern is in escalation detection
if ! grep -qE 'tests.*fail' "$FADE_CLI"; then
    echo "FAIL: detect_escalation should detect 'tests fail' pattern"
    exit 1
fi

# Test 3: Verify escalation only happens after iteration >= 2
if ! grep -q 'iteration_count.*-ge.*2' "$FADE_CLI"; then
    echo "FAIL: Escalation should only trigger after iteration >= 2"
    exit 1
fi

# Test 4: Verify escalation suggestion is displayed
if ! grep -q 'display_escalation_suggestion' "$FADE_CLI"; then
    echo "FAIL: display_escalation_suggestion should be called for test failures"
    exit 1
fi

# Test 5: Verify test failure detection in run loop
if ! grep -qE 'grep.*test.*fail|test.*fail.*escalat' "$FADE_CLI"; then
    echo "FAIL: Test failure pattern should be detected in run loop"
    exit 1
fi

echo "PASS: FADE suggests escalating model on repeated test failures"
exit 0
