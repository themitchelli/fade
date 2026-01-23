#!/bin/bash
# Test: verify numeric validation exists before comparison
# AC: Before comparison, validate that $tests_generated is numeric

# This test verifies that the code validates tests_generated is numeric
# using a regex pattern check before attempting arithmetic comparison.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Find the defensive validation pattern
# Should check: [[ "$tests_generated" =~ ^[0-9]+$ ]]
validation_pattern='tests_generated.*=~.*\[0-9\]'

if ! grep -q "$validation_pattern" "$FADE_CLI"; then
    echo "FAIL: No numeric validation for tests_generated found"
    echo "Expected: Pattern like [[ \"\$tests_generated\" =~ ^[0-9]+\$ ]]"
    exit 1
fi

# Verify the validation is BEFORE the -gt comparison
# Get line numbers
validation_line=$(grep -n "$validation_pattern" "$FADE_CLI" | head -1 | cut -d: -f1)
comparison_line=$(grep -n 'tests_generated.*-gt 0' "$FADE_CLI" | head -1 | cut -d: -f1)

if [[ -z "$validation_line" ]] || [[ -z "$comparison_line" ]]; then
    echo "FAIL: Could not determine line numbers for validation check"
    exit 1
fi

if [[ "$validation_line" -ge "$comparison_line" ]]; then
    echo "FAIL: Validation must occur BEFORE the -gt comparison"
    echo "Validation line: $validation_line"
    echo "Comparison line: $comparison_line"
    exit 1
fi

echo "PASS: Numeric validation exists before comparison"
exit 0
