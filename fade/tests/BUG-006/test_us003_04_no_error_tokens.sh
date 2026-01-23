#!/bin/bash
# Test: verify no error tokens can appear in output
# AC: No error tokens visible in terminal output

# This test verifies that the code structure prevents error tokens
# (like "syntax error", "operand expected") from appearing during
# the ALL_COMPLETE flow.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# The error that occurred before the fix:
# "line XXXX: [[: ════════════════════════════════════════════════════════════: syntax error: operand expected"
#
# This happened because:
# 1. Display output (with ═══ chars) leaked into stdout
# 2. Command substitution captured it into tests_generated
# 3. [[ "$tests_generated" -gt 0 ]] tried to do arithmetic on non-numeric string

# Verify the defensive validation catches and handles bad values gracefully
# The warning message should be informative but not an error trace
warning_line=$(grep 'Warning.*test generation.*non-numeric' "$FADE_CLI" || \
               grep 'warning.*tests_generated.*non-numeric' "$FADE_CLI" || \
               grep 'Warning:.*non-numeric' "$FADE_CLI")

if [[ -z "$warning_line" ]]; then
    # Check for any warning message about the validation
    if ! grep -qi 'warning.*non-numeric\|non-numeric.*warning\|defaulting to 0' "$FADE_CLI"; then
        echo "FAIL: No graceful warning message for non-numeric values"
        echo "Expected: User-friendly warning, not bash error trace"
        exit 1
    fi
fi

# Verify there's no raw error output possible from the comparison
# The validation must ALWAYS run before the -gt comparison
# Check that the validation block exists between the function call and comparison
validation_block=$(sed -n '/tests_generated=\$(generate_tests_for_completed_prds)/,/tests_generated.*-gt 0/p' "$FADE_CLI")

if [[ -z "$validation_block" ]]; then
    echo "FAIL: Could not find validation block between function call and comparison"
    exit 1
fi

# Verify the validation includes regex check and default assignment
if ! echo "$validation_block" | grep -q '=~.*\[0-9\]'; then
    echo "FAIL: Regex validation not found in the flow"
    exit 1
fi

if ! echo "$validation_block" | grep -q 'tests_generated=0'; then
    echo "FAIL: Default value assignment not found in the flow"
    exit 1
fi

# Verify the success path shows clean output
if ! grep -q 'Generated tests for' "$FADE_CLI"; then
    echo "FAIL: Clean success message not found"
    exit 1
fi

echo "PASS: Error tokens prevented by proper validation and messaging"
exit 0
