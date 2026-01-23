#!/bin/bash
# Test: verify test generation flow structure is complete
# AC: Test generation flow completes successfully

# This test verifies the code structure allows test generation to complete
# successfully by checking that all the pieces are properly connected.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Verify generate_tests_for_completed_prds exists and is well-formed
if ! grep -q "^generate_tests_for_completed_prds()" "$FADE_CLI"; then
    echo "FAIL: generate_tests_for_completed_prds function not found"
    exit 1
fi

# Verify it's called from ALL_COMPLETE handler
if ! grep -q 'tests_generated=\$(generate_tests_for_completed_prds)' "$FADE_CLI"; then
    echo "FAIL: generate_tests_for_completed_prds not called with command substitution"
    exit 1
fi

# Verify defensive validation is in place
if ! grep -q 'tests_generated.*=~.*\[0-9\]' "$FADE_CLI"; then
    echo "FAIL: Defensive numeric validation not found"
    exit 1
fi

# Verify comparison happens after validation
if ! grep -q 'tests_generated.*-gt 0' "$FADE_CLI"; then
    echo "FAIL: Comparison [[ tests_generated -gt 0 ]] not found"
    exit 1
fi

# Verify success message is conditional on test count
if ! grep -A 3 'tests_generated.*-gt 0' "$FADE_CLI" | grep -q 'Generated tests'; then
    echo "FAIL: Success message not found after comparison"
    exit 1
fi

# Verify archive CALL happens after test generation CALL
# Use grep for the actual function calls (with $( prefix), not definitions
archive_call_line=$(grep -n '\$(archive_priority_prd)\|\$(archive_completed_prds)' "$FADE_CLI" | head -1 | cut -d: -f1)
test_gen_call_line=$(grep -n '\$(generate_tests_for_completed_prds)' "$FADE_CLI" | head -1 | cut -d: -f1)

if [[ -z "$archive_call_line" ]] || [[ -z "$test_gen_call_line" ]]; then
    echo "FAIL: Could not find test generation and archive function calls"
    exit 1
fi

if [[ "$archive_call_line" -lt "$test_gen_call_line" ]]; then
    echo "FAIL: Archive should happen AFTER test generation"
    echo "Test gen call line: $test_gen_call_line, Archive call line: $archive_call_line"
    exit 1
fi

echo "PASS: Test generation flow structure is complete and correct"
exit 0
