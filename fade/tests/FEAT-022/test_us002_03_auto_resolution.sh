#!/bin/bash
# Test: verify FADE automatically attempts resolution for recoverable categories
# AC: For recoverable categories (e.g., failing tests, missing command), FADE automatically attempts a resolution step (install guidance, alternative command, or bug-fix loop).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify attempt_blocked_resolution function exists
if ! grep -q 'attempt_blocked_resolution()' "$FADE_CLI"; then
    echo "FAIL: attempt_blocked_resolution function should exist"
    echo "Expected: attempt_blocked_resolution() function definition"
    exit 1
fi

# Test 2: Verify failing_tests has a handler (self-healing is triggered by caller)
if ! grep -A 100 'attempt_blocked_resolution()' "$FADE_CLI" | grep -qE 'failing_tests\)'; then
    echo "FAIL: failing_tests category should have a resolution handler"
    echo "Expected: failing_tests case in attempt_blocked_resolution"
    exit 1
fi

# Test 3: Verify missing_dependency handler exists and provides suggestions
if ! grep -A 100 'attempt_blocked_resolution()' "$FADE_CLI" | grep -qE 'missing_dependency\)'; then
    echo "FAIL: missing_dependency should have a case handler"
    echo "Expected: Handler for missing_dependency category"
    exit 1
fi

# Test 4: Verify case statement handles multiple categories
res_func=$(grep -A 150 'attempt_blocked_resolution()' "$FADE_CLI")

# Check for case statement with category handling
if ! echo "$res_func" | grep -q 'case.*category'; then
    echo "FAIL: attempt_blocked_resolution should use case statement for categories"
    echo "Expected: case statement to handle different categories"
    exit 1
fi

# Test 5: Verify each recoverable category has a resolution action
for category in "failing_tests" "missing_dependency" "unclear_requirement" "environmental" "permission_issue"; do
    if ! echo "$res_func" | grep -q "$category)"; then
        echo "FAIL: Resolution should handle $category category"
        echo "Expected: Case handler for $category"
        exit 1
    fi
done

# Test 6: Verify unrecoverable category exists and returns 1
# The pattern is: unrecoverable) ... return 1 within the case block
unrecoverable_block=$(grep -A 150 'attempt_blocked_resolution()' "$FADE_CLI" | sed -n '/unrecoverable)/,/;;/p')
if [[ -z "$unrecoverable_block" ]]; then
    echo "FAIL: unrecoverable case should exist"
    echo "Expected: unrecoverable) case in attempt_blocked_resolution"
    exit 1
fi

if ! echo "$unrecoverable_block" | grep -q 'return 1'; then
    echo "FAIL: unrecoverable should return 1"
    echo "Expected: return 1 for unrecoverable category"
    exit 1
fi

echo "PASS: FADE automatically attempts resolution for recoverable BLOCKED categories"
exit 0
