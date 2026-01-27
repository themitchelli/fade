#!/bin/bash
# Test: verify FADE stops after K attempts (default 2) with clear summary
# AC: If tests fail after K attempts (configurable; default 2), FADE stops with a clear summary and leaves the bug PRD queued for human review.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify max_attempts parameter with default of 2
if ! grep -A 10 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -qE 'max_attempts.*:-.*2|max_attempts.*2|default.*2'; then
    echo "FAIL: Self-healing should have configurable max attempts with default 2"
    echo "Expected: max_attempts parameter with default value of 2"
    exit 1
fi

# Test 2: Verify retry loop respects max attempts
if ! grep -A 80 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -qE 'while.*attempt.*le.*max|attempt.*-le.*max_attempts'; then
    echo "FAIL: Self-healing should loop while attempts < max_attempts"
    echo "Expected: Loop condition checking attempt count against max"
    exit 1
fi

# Test 3: Verify failure message after max attempts exhausted
if ! grep -A 100 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -qi 'fail.*after.*attempt\|auto-heal.*attempt\|Could not'; then
    echo "FAIL: Self-healing should display failure summary after max attempts"
    echo "Expected: Clear failure message mentioning attempts"
    exit 1
fi

# Test 4: Verify return 1 (failure) when max attempts exhausted
if ! grep -A 100 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -q 'return 1'; then
    echo "FAIL: Self-healing should return 1 (failure) after max attempts"
    echo "Expected: return 1 in attempt_self_healing_for_test_failure on exhaustion"
    exit 1
fi

# Test 5: Verify Bug PRD remains in prds folder (not deleted on failure)
# The function doesn't delete the Bug PRD on failure - it stays for human review
if grep -A 100 'attempt_self_healing_for_test_failure()' "$FADE_CLI" | grep -q 'rm.*bug_prd_path'; then
    echo "FAIL: Bug PRD should NOT be deleted after failed healing attempts"
    echo "Expected: Bug PRD to remain for human review"
    exit 1
fi

echo "PASS: FADE stops after K attempts (default 2) and leaves Bug PRD queued"
exit 0
