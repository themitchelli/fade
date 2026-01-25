#!/bin/bash
# Test: verify 'fade classify' command exists
# AC: Create 'fade classify' command to analyze existing PRDs

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify function exists
if grep -q "^cmd_classify()" "$FADE_CLI"; then
    # Check it's wired up in the case statement
    if grep -q "classify)" "$FADE_CLI"; then
        echo "PASS: 'fade classify' command exists"
        exit 0
    fi
fi

echo "FAIL: 'fade classify' command not found"
exit 1
