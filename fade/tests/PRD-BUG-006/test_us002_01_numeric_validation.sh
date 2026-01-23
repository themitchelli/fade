#!/bin/bash
# Test: Verify defensive numeric validation exists
# AC: Before comparison, validate that $tests_generated is numeric

FADE_CLI="bin/fade-cli"

# Check for the regex pattern that validates numeric input
# The pattern is: [[ "$tests_generated" =~ ^[0-9]+$ ]]
if ! grep -q '\[\[.*tests_generated.*=~.*\[0-9\]' "$FADE_CLI"; then
    echo "FAIL: Missing numeric validation regex pattern"
    exit 1
fi

# Check the pattern includes the regex anchors
if ! grep 'tests_generated.*=~' "$FADE_CLI" | grep -q '\^.*\$'; then
    echo "FAIL: Regex pattern should have ^ and $ anchors"
    exit 1
fi

echo "PASS: Numeric validation regex pattern exists"
exit 0
