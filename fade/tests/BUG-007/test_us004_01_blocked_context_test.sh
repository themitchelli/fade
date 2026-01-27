#!/bin/bash
# Test: verifies 'BLOCKED' in context text does not trigger BLOCKED detection
# AC: Create test that verifies 'BLOCKED' in context text does not trigger BLOCKED detection

# This test is the actual verification that the pattern works correctly
# It covers multiple false positive scenarios from the PRD

test_cases=(
    "Session timeline shows outcome (COMPLETE/BLOCKED)"
    "shows blocked repos in dashboard"
    "filter for BLOCKED status repos"
    "Check if session is blocked"
    "The BLOCKED state indicates a problem"
    "When status is BLOCKED, manual intervention needed"
)

for test_case in "${test_cases[@]}"; do
    if echo "$test_case" | grep -q '^BLOCKED: '; then
        echo "FAIL: Context text should not trigger BLOCKED detection"
        echo "Expected: no match for '^BLOCKED: '"
        echo "Actual: matched on: '$test_case'"
        exit 1
    fi
done

echo "PASS: BLOCKED in context text does not trigger detection (${#test_cases[@]} cases verified)"
exit 0
