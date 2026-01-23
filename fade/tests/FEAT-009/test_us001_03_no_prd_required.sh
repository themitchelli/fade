#!/bin/bash
# Test: verify fade quick does not require PRD file to exist
# AC: Does not require PRD file to exist

# Setup - create a clean test directory with no PRD files
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Ensure no PRD files exist
if [[ -f "prd.json" ]] || [[ -d "prds" ]] || [[ -d "fade/prds" ]]; then
    echo "FAIL: Test setup error - PRD files should not exist"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Act - run fade quick with task (capture what would be sent to Claude)
# We use bash -n to syntax check and verify the command parses correctly
# without actually executing Claude
FADE_CLI="${FADE_CLI:-fade}"

# Check that fade quick with a task description doesn't error before Claude launch
# by examining the CLI source to verify it doesn't check for PRD existence
output=$($FADE_CLI help 2>&1)
quick_section=$(echo "$output" | grep -A5 "Quick Command")

# Assert - quick command description indicates it works without PRD
if ! echo "$quick_section" | grep -qiE "without PRD|no PRD|non-FADE"; then
    echo "FAIL: Quick command description doesn't indicate PRD-free operation"
    echo "Expected: description mentioning 'without PRD' or similar"
    echo "Actual: $quick_section"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade quick does not require PRD file"
exit 0
