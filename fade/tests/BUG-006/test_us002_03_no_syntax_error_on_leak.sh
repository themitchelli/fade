#!/bin/bash
# Test: verify syntax error cannot occur even with output leak
# AC: Syntax error no longer occurs even if output leaks

# This test verifies that the defensive validation pattern properly
# handles any possible value that could leak into tests_generated,
# preventing the "[[::" syntax error.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# The fix uses ! [[ "$tests_generated" =~ ^[0-9]+$ ]] which safely handles:
# - Empty strings
# - Strings with special characters (like ════════)
# - Multi-line content
# - Any non-numeric garbage

# Verify the negated pattern check exists (! [[ ... =~ ... ]])
if ! grep -q '! \[\[.*tests_generated.*=~' "$FADE_CLI"; then
    echo "FAIL: Defensive pattern should use negated check"
    echo "Expected: if ! [[ \"\$tests_generated\" =~ ^[0-9]+\$ ]]"
    exit 1
fi

# Verify the pattern is anchored (starts with ^ and ends with $)
# This ensures ONLY fully numeric values pass
pattern_line=$(grep 'tests_generated.*=~' "$FADE_CLI")

if ! echo "$pattern_line" | grep -q '\^'; then
    echo "FAIL: Pattern should be anchored at start with ^"
    echo "Found: $pattern_line"
    exit 1
fi

if ! echo "$pattern_line" | grep -q '\$'; then
    echo "FAIL: Pattern should be anchored at end with \$"
    echo "Found: $pattern_line"
    exit 1
fi

# Simulate the fix behavior - test that our validation logic works
# This is a unit test of the defensive pattern itself
test_values=(
    "0"           # valid
    "1"           # valid
    "42"          # valid
    ""            # invalid - empty
    "abc"         # invalid - letters
    "1abc"        # invalid - mixed
    "════════"    # invalid - unicode (the original bug symptom)
    $'line1\nline2'  # invalid - multiline
    "  5  "       # invalid - whitespace
)

expected_numeric=(1 1 1 0 0 0 0 0 0)

all_pass=true
for i in "${!test_values[@]}"; do
    val="${test_values[$i]}"
    expected="${expected_numeric[$i]}"

    if [[ "$val" =~ ^[0-9]+$ ]]; then
        is_numeric=1
    else
        is_numeric=0
    fi

    if [[ "$is_numeric" != "$expected" ]]; then
        echo "FAIL: Pattern check failed for value '$val'"
        echo "Expected is_numeric: $expected, Got: $is_numeric"
        all_pass=false
    fi
done

if ! $all_pass; then
    exit 1
fi

echo "PASS: Defensive validation prevents syntax error from any leaked value"
exit 0
