#!/bin/bash
# Test: verify healing only applies patterns from approved whitelist
# AC: Healing only applies patterns from approved whitelist (no dynamic pattern generation)

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the apply_portability_fixes function uses a case statement (fixed patterns)
if ! grep -q 'case "$error_type" in' "$FADE_CLI"; then
    echo "FAIL: Fixes should use case statement with known error types"
    echo "Expected: 'case \"\$error_type\" in' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify only known error types are handled
if ! grep -q 'head_illegal_line_count)' "$FADE_CLI"; then
    echo "FAIL: head_illegal_line_count should be a known pattern"
    echo "Expected: 'head_illegal_line_count)' case in fade-cli"
    echo "Actual: not found"
    exit 1
fi

if ! grep -q 'sed_i_needs_argument)' "$FADE_CLI"; then
    echo "FAIL: sed_i_needs_argument should be a known pattern"
    echo "Expected: 'sed_i_needs_argument)' case in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify unknown error types are rejected
if ! grep -q 'Unknown error type' "$FADE_CLI"; then
    echo "FAIL: Unknown error types should be rejected"
    echo "Expected: 'Unknown error type' error message in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Healing only applies patterns from approved whitelist"
exit 0
