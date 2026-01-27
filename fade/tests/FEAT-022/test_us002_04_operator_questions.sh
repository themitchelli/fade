#!/bin/bash
# Test: verify FADE creates operator_questions.md for unresolved BLOCKED states
# AC: If still BLOCKED, FADE creates a short 'operator question' artifact in `fade/runs/<run_id>/operator_questions.md` that you can answer, then resume via `fade resume <run_id>`.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify create_operator_question function exists
if ! grep -q 'create_operator_question()' "$FADE_CLI"; then
    echo "FAIL: create_operator_question function should exist"
    echo "Expected: create_operator_question() function definition"
    exit 1
fi

# Test 2: Verify operator_questions.md is created in the correct location
if ! grep -A 30 'create_operator_question()' "$FADE_CLI" | grep -q 'fade/runs.*operator_questions.md\|run_dir.*operator_questions'; then
    echo "FAIL: operator_questions.md should be created in fade/runs/<run_id>/"
    echo "Expected: File path referencing fade/runs/<run_id>/operator_questions.md"
    exit 1
fi

# Test 3: Verify the artifact includes the blocked reason
if ! grep -A 50 'create_operator_question()' "$FADE_CLI" | grep -qE 'blocked_reason|Reason'; then
    echo "FAIL: operator_questions.md should include the blocked reason"
    echo "Expected: blocked_reason in operator question content"
    exit 1
fi

# Test 4: Verify resume instructions are provided
if ! grep -A 50 'create_operator_question()' "$FADE_CLI" | grep -qE 'fade resume|resume.*run_id'; then
    echo "FAIL: operator_questions.md should include resume instructions"
    echo "Expected: 'fade resume <run_id>' instruction in content"
    exit 1
fi

# Test 5: Verify resolution handlers call create_operator_question
if ! grep -A 150 'attempt_blocked_resolution()' "$FADE_CLI" | grep -q 'create_operator_question'; then
    echo "FAIL: Resolution handlers should create operator questions"
    echo "Expected: Call to create_operator_question in attempt_blocked_resolution"
    exit 1
fi

# Test 6: Verify guidance field is included in the artifact
if ! grep -A 50 'create_operator_question()' "$FADE_CLI" | grep -qE 'guidance|Guidance'; then
    echo "FAIL: operator_questions.md should include guidance for the operator"
    echo "Expected: guidance field in create_operator_question"
    exit 1
fi

# Test 7: Verify run directory is created if it doesn't exist
if ! grep -A 30 'create_operator_question()' "$FADE_CLI" | grep -q 'mkdir.*-p'; then
    echo "FAIL: Should create run directory if needed"
    echo "Expected: mkdir -p to ensure directory exists"
    exit 1
fi

echo "PASS: FADE creates operator_questions.md with reason and resume instructions"
exit 0
