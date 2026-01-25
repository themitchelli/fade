#!/bin/bash
# Test: verify healing explicitly blocks src/, lib/, bin/ directories
# AC: Healing explicitly blocks patterns: 'src/', 'lib/', 'bin/', any file without 'test' in path

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify src/ is blocked
if ! grep -q '*/src/*' "$FADE_CLI"; then
    echo "FAIL: Code should block src/ directory"
    echo "Expected: '*/src/*' pattern in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify lib/ is blocked
if ! grep -q '*/lib/*' "$FADE_CLI"; then
    echo "FAIL: Code should block lib/ directory"
    echo "Expected: '*/lib/*' pattern in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify bin/ is blocked
if ! grep -q '*/bin/*' "$FADE_CLI"; then
    echo "FAIL: Code should block bin/ directory"
    echo "Expected: '*/bin/*' pattern in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify 'test' requirement in path
if ! grep -q '*test*' "$FADE_CLI"; then
    echo "FAIL: Code should require 'test' in path"
    echo "Expected: '*test*' pattern in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Healing blocks src/, lib/, bin/ and requires 'test' in path"
exit 0
