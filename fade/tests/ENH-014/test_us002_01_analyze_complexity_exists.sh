#!/bin/bash
# Test: verify analyze_complexity() function exists in bin/fade-cli
# AC: Create analyze_complexity() function in bin/fade-cli

set -e

FADE_CLI="$(which fade)"

# Check that analyze_complexity function is defined in the script
if grep -q "^analyze_complexity()" "$FADE_CLI"; then
    echo "PASS: analyze_complexity() function exists in bin/fade-cli"
    exit 0
fi

echo "FAIL: analyze_complexity() function not found in bin/fade-cli"
exit 1
