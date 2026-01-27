#!/bin/bash
# Test: output containing 'BLOCKED: Cannot find dependency' should trigger BLOCKED detection
# AC: Test case: output containing 'BLOCKED: Cannot find dependency' should trigger BLOCKED detection

# Test that a real BLOCKED signal is detected

output="I attempted to install the dependency but encountered an issue.

BLOCKED: Cannot find dependency 'libfoo' in any package repository"

# Using the same pattern as fade-cli
if ! echo "$output" | grep -q '^BLOCKED: '; then
    echo "FAIL: Valid BLOCKED signal should trigger detection"
    echo "Expected: BLOCKED signal detected"
    echo "Actual: BLOCKED signal NOT detected"
    exit 1
fi

echo "PASS: 'BLOCKED: Cannot find dependency' correctly triggers BLOCKED detection"
exit 0
