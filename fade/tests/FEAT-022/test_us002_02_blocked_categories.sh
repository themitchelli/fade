#!/bin/bash
# Test: verify FADE categorizes BLOCKED reasons into specified categories
# AC: FADE categorizes BLOCKED reasons into at least: missing dependency/command, unclear requirement, failing tests, environmental issue, permission issue.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify categorize_blocked_reason function exists
if ! grep -q 'categorize_blocked_reason()' "$FADE_CLI"; then
    echo "FAIL: categorize_blocked_reason function should exist"
    echo "Expected: categorize_blocked_reason() function definition"
    exit 1
fi

# Test 2: Verify failing_tests category
if ! grep -A 50 'categorize_blocked_reason()' "$FADE_CLI" | grep -q 'failing_tests'; then
    echo "FAIL: Should categorize into failing_tests category"
    echo "Expected: failing_tests category in categorize function"
    exit 1
fi

# Test 3: Verify missing_dependency category
if ! grep -A 50 'categorize_blocked_reason()' "$FADE_CLI" | grep -q 'missing_dependency'; then
    echo "FAIL: Should categorize into missing_dependency category"
    echo "Expected: missing_dependency category in categorize function"
    exit 1
fi

# Test 4: Verify unclear_requirement category
if ! grep -A 50 'categorize_blocked_reason()' "$FADE_CLI" | grep -q 'unclear_requirement'; then
    echo "FAIL: Should categorize into unclear_requirement category"
    echo "Expected: unclear_requirement category in categorize function"
    exit 1
fi

# Test 5: Verify environmental category
if ! grep -A 50 'categorize_blocked_reason()' "$FADE_CLI" | grep -q 'environmental'; then
    echo "FAIL: Should categorize into environmental category"
    echo "Expected: environmental category in categorize function"
    exit 1
fi

# Test 6: Verify permission_issue category
if ! grep -A 50 'categorize_blocked_reason()' "$FADE_CLI" | grep -q 'permission_issue'; then
    echo "FAIL: Should categorize into permission_issue category"
    echo "Expected: permission_issue category in categorize function"
    exit 1
fi

# Test 7: Verify pattern matching for common phrases in each category
cat_func=$(grep -A 60 'categorize_blocked_reason()' "$FADE_CLI")

# Check failing tests patterns
if ! echo "$cat_func" | grep -qE 'test.*fail|regression.*fail'; then
    echo "FAIL: Should detect test failure patterns"
    exit 1
fi

# Check missing dependency patterns
if ! echo "$cat_func" | grep -qE 'command not found|missing.*command|missing.*dependency'; then
    echo "FAIL: Should detect missing dependency patterns"
    exit 1
fi

# Check unclear requirement patterns
if ! echo "$cat_func" | grep -qE 'unclear|ambiguous'; then
    echo "FAIL: Should detect unclear requirement patterns"
    exit 1
fi

echo "PASS: FADE categorizes BLOCKED into all required categories"
exit 0
