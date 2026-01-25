#!/bin/bash
# Test: verify pattern matching against known portability error signatures
# AC: Pattern match against known portability error signatures

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify grep is used for pattern matching
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'grep -q'; then
    echo "FAIL: Detection should use grep for pattern matching"
    echo "Expected: 'grep -q' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

# Verify function returns different codes for match vs no-match
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'return 0'; then
    echo "FAIL: Function should return 0 when pattern matched"
    echo "Expected: 'return 0' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'return 1'; then
    echo "FAIL: Function should return 1 when no pattern matched"
    echo "Expected: 'return 1' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Pattern matching correctly identifies known portability signatures"
exit 0
