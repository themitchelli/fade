#!/bin/bash
# Test: BLOCKED signal detection should trigger on valid 'BLOCKED: reason' format
# AC: Pattern should match: 'BLOCKED: reason text' or 'BLOCKED:reason'

set -e

# Test case 1: Valid BLOCKED signal with reason
output1="BLOCKED: Cannot find required dependency"

if ! echo "$output1" | grep -q '^BLOCKED: '; then
    echo "FAIL: Valid BLOCKED signal not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    echo "Output: $output1"
    exit 1
fi

# Test case 2: Valid BLOCKED signal in multi-line output
output2="Working on authentication...
Found an issue with the build.
BLOCKED: Unresolved merge conflict in src/auth.js"

if ! echo "$output2" | grep -q '^BLOCKED: '; then
    echo "FAIL: Valid BLOCKED signal in multi-line output not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

# Test case 3: BLOCKED signal with minimal text
output3="BLOCKED: Out of context window"

if ! echo "$output3" | grep -q '^BLOCKED: '; then
    echo "FAIL: BLOCKED signal with minimal reason not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

echo "PASS: Valid BLOCKED signals are correctly detected"
exit 0
