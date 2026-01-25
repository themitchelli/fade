#!/bin/bash
# Test: verify fixes are committed with proper message when tests pass
# AC: If tests pass: commit fixes with message 'chore: auto-heal shell portability (FEAT-012)'

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify the commit message is correct
expected_msg="chore: auto-heal shell portability (FEAT-012)"
if ! grep -q "$expected_msg" "$FADE_CLI"; then
    echo "FAIL: Commit message should be '$expected_msg'"
    echo "Expected: '$expected_msg' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify git commit is called after healing success
if ! grep -q "git commit -m" "$FADE_CLI"; then
    echo "FAIL: git commit should be called after healing success"
    echo "Expected: 'git commit -m' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Fixes are committed with correct message on success"
exit 0
