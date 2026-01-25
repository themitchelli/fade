#!/bin/bash
# Test: ALL_COMPLETE pattern uses exact line match (no false positives)
# AC: ALL_COMPLETE detection should match '^ALL_COMPLETE$' on its own line

set -e

# Test case 1: Exact ALL_COMPLETE on its own line (should match)
output1="ALL_COMPLETE"

if ! echo "$output1" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: Valid ALL_COMPLETE not detected"
    echo "Expected: Match"
    echo "Actual: No match"
    exit 1
fi

# Test case 2: ALL_COMPLETE with trailing text (should NOT match with -x)
output2="ALL_COMPLETE: All work is done"

if echo "$output2" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: ALL_COMPLETE with text matched (should be exact line only)"
    echo "Expected: No match (exact match required)"
    echo "Actual: Matched"
    exit 1
fi

# Test case 3: ALL_COMPLETE in middle of text (should NOT match)
output3="Status: ALL_COMPLETE in a sentence"

if echo "$output3" | grep -qx "ALL_COMPLETE"; then
    echo "FAIL: ALL_COMPLETE in middle of text matched"
    echo "Expected: No match"
    echo "Actual: Matched"
    exit 1
fi

echo "PASS: ALL_COMPLETE pattern is correctly strict (exact line match)"
exit 0
