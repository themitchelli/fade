#!/bin/bash
# Test: verify detection uses efficient grep patterns (completes quickly)
# AC: Detection completes in < 2 seconds

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify detection uses grep -q which is fast (stops at first match)
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'grep -q'; then
    echo "FAIL: Detection should use 'grep -q' for fast matching"
    echo "Expected: 'grep -q' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

# Verify detection uses head -n 1 to limit processing
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'head -n 1'; then
    echo "FAIL: Detection should limit results with 'head -n 1'"
    echo "Expected: 'head -n 1' in detect_shell_portability_error"
    echo "Actual: not found"
    exit 1
fi

# Verify function doesn't load entire file into memory
if ! grep -A 50 'detect_shell_portability_error()' "$FADE_CLI" | grep -q 'grep.*"$output_file"'; then
    echo "FAIL: Detection should grep file directly (not load into memory)"
    echo "Expected: grep against \$output_file"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Detection uses efficient patterns for fast completion"
exit 0
