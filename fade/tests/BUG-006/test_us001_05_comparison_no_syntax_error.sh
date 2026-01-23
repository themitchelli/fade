#!/bin/bash
# Test: verify numeric comparison works without syntax error
# AC: Comparison [[ "$tests_generated" -gt 0 ]] works without syntax error

# This test verifies that the defensive validation in the caller ensures
# the comparison never receives non-numeric input that would cause syntax error.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Find where tests_generated is used in the comparison
# It should have defensive validation BEFORE the -gt comparison
comparison_context=$(grep -B 10 'tests_generated.*-gt 0' "$FADE_CLI" | head -15)

if [[ -z "$comparison_context" ]]; then
    echo "FAIL: Could not find tests_generated -gt 0 comparison"
    exit 1
fi

# Verify defensive validation exists before the comparison
# Should have: [[ "$tests_generated" =~ ^[0-9]+$ ]] check
if ! echo "$comparison_context" | grep -q '\[\[.*tests_generated.*=~.*\^\\[0-9\\]'; then
    # Try alternate pattern matching
    if ! grep -B 10 'tests_generated.*-gt 0' "$FADE_CLI" | grep -q 'tests_generated.*=~'; then
        echo "FAIL: No numeric validation found before comparison"
        echo "Expected: Regex check like [[ \"\$tests_generated\" =~ ^[0-9]+\$ ]]"
        echo "Context found:"
        echo "$comparison_context"
        exit 1
    fi
fi

# Verify that if validation fails, tests_generated defaults to 0
if ! echo "$comparison_context" | grep -q 'tests_generated=0'; then
    echo "FAIL: No default value set when validation fails"
    echo "Expected: tests_generated=0 as fallback"
    exit 1
fi

echo "PASS: Comparison has defensive validation to prevent syntax error"
exit 0
