#!/bin/bash
# Test: verify FADE re-runs regression tests automatically after fix attempt
# AC: After a fix attempt, FADE re-runs regression tests automatically.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify attempt_self_healing_for_test_failure function exists
if ! grep -q 'attempt_self_healing_for_test_failure()' "$FADE_CLI"; then
    echo "FAIL: attempt_self_healing_for_test_failure function should exist"
    echo "Expected: attempt_self_healing_for_test_failure() function definition"
    exit 1
fi

# Test 2: Verify run_regression_tests is called after bug-fix attempt
if ! grep -A 60 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -q 'run_regression_tests'; then
    echo "FAIL: Self-healing should re-run regression tests after fix attempt"
    echo "Expected: Call to run_regression_tests in self-healing loop"
    exit 1
fi

# Test 3: Verify the order: bug-fix agent runs BEFORE regression tests re-run
# Look for run_bug_fix_agent followed by run_regression_tests in the function
heal_func=$(grep -A 80 'attempt_self_healing_for_test_failure()' "$FADE_CLI")
if ! echo "$heal_func" | grep -q 'run_bug_fix_agent' || ! echo "$heal_func" | grep -q 'run_regression_tests'; then
    echo "FAIL: Self-healing should run bug-fix agent then re-run tests"
    echo "Expected: run_bug_fix_agent followed by run_regression_tests"
    exit 1
fi

# Test 4: Verify message indicates re-running tests
if ! grep -A 80 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -qi 're-run\|rerun\|Re-running'; then
    echo "FAIL: Self-healing should indicate tests are being re-run"
    echo "Expected: Message about re-running regression tests"
    exit 1
fi

echo "PASS: FADE automatically re-runs regression tests after fix attempt"
exit 0
