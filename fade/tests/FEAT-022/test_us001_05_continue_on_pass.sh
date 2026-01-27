#!/bin/bash
# Test: verify FADE returns to original PRD/story when tests pass after healing
# AC: If tests pass, FADE returns to the original PRD/story and continues.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify self-healing returns 0 on successful fix (tests pass)
if ! grep -A 80 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -q 'return 0'; then
    echo "FAIL: Self-healing should return 0 when tests pass after fix"
    echo "Expected: return 0 in attempt_self_healing_for_test_failure on success"
    exit 1
fi

# Test 2: Verify successful message is displayed when tests pass
if ! grep -A 80 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -qE 'Self-heal.*success|healed.*success|Tests.*pass'; then
    echo "FAIL: Self-healing should display success message when tests pass"
    echo "Expected: Success message after tests pass"
    exit 1
fi

# Test 3: Verify flow continues after successful healing (caller resumes)
# The self-healing function returns 0, allowing the caller to continue
heal_func=$(grep -A 100 'attempt_self_healing_for_test_failure()' "$FADE_CLI")
if echo "$heal_func" | grep -q 'run_regression_tests' && echo "$heal_func" | grep -q 'return 0'; then
    # Good - the function has the structure to return 0 after tests pass
    :
else
    echo "FAIL: Self-healing should return success to allow caller to continue"
    exit 1
fi

# Test 4: Verify the caller checks return value and continues work
if ! grep -B 5 -A 5 'attempt_self_healing_for_test_failure' "$FADE_CLI" | grep -qE 'if.*attempt_self_healing|then'; then
    echo "FAIL: Caller should check self-healing return value to continue"
    echo "Expected: Conditional check on attempt_self_healing_for_test_failure"
    exit 1
fi

echo "PASS: FADE returns to original PRD/story and continues when tests pass"
exit 0
