#!/bin/bash
# Test: verify Bug PRD is generated into fade/prds/ folder
# AC: FADE generates a Bug PRD (type `bug`) into `fade/prds/` or a dedicated `fade/prds/auto/` folder with clear description and acceptance criteria.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify generate_bug_prd_for_test_failure function exists
if ! grep -q 'generate_bug_prd_for_test_failure()' "$FADE_CLI"; then
    echo "FAIL: generate_bug_prd_for_test_failure function should exist"
    echo "Expected: generate_bug_prd_for_test_failure() function definition"
    exit 1
fi

# Test 2: Verify Bug PRD is created in prds directory
if ! grep -A 30 'generate_bug_prd_for_test_failure()' "$FADE_CLI" | grep -q 'prds_dir'; then
    echo "FAIL: Bug PRD should be created in prds directory"
    echo "Expected: Reference to prds_dir for output location"
    exit 1
fi

# Test 3: Verify Bug PRD has type "bug"
if ! grep -A 50 'generate_bug_prd_for_test_failure()' "$FADE_CLI" | grep -q '"type": "bug"'; then
    echo "FAIL: Bug PRD should have type 'bug'"
    echo "Expected: '\"type\": \"bug\"' in generated PRD"
    exit 1
fi

# Test 4: Verify Bug PRD file is named with BUG- prefix
if ! grep -A 30 'generate_bug_prd_for_test_failure()' "$FADE_CLI" | grep -q 'BUG-'; then
    echo "FAIL: Bug PRD filename should use BUG- prefix"
    echo "Expected: Filename pattern with BUG- prefix"
    exit 1
fi

# Test 5: Verify Bug PRD has acceptance criteria
if ! grep -A 50 'generate_bug_prd_for_test_failure()' "$FADE_CLI" | grep -q 'acceptanceCriteria'; then
    echo "FAIL: Bug PRD should include acceptance criteria"
    echo "Expected: acceptanceCriteria field in generated PRD"
    exit 1
fi

# Test 6: Verify Bug PRD includes failure summary in description
if ! grep -A 60 'generate_bug_prd_for_test_failure()' "$FADE_CLI" | grep -qE 'failure_summary|Failure Summary'; then
    echo "FAIL: Bug PRD should include failure summary in description"
    echo "Expected: Reference to failure summary in PRD content"
    exit 1
fi

echo "PASS: Bug PRD generated with type=bug, clear description and acceptance criteria"
exit 0
