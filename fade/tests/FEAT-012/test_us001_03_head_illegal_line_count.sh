#!/bin/bash
# Test: verify detection of 'head: illegal line count' errors
# AC: Detect 'head: illegal line count' errors

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the head: illegal line count pattern is detected
if ! grep -q 'head: illegal line count' "$FADE_CLI"; then
    echo "FAIL: Code should detect 'head: illegal line count' pattern"
    echo "Expected: 'head: illegal line count' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify error_type is set correctly for this pattern
if ! grep -q 'error_type=head_illegal_line_count' "$FADE_CLI"; then
    echo "FAIL: error_type should be 'head_illegal_line_count'"
    echo "Expected: 'error_type=head_illegal_line_count' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: 'head: illegal line count' errors are detected"
exit 0
