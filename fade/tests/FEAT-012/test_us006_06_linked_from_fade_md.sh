#!/bin/bash
# Test: verify shell-portability.md is linked from FADE.md standards table
# AC: Link from architecture.md in standards reference table
# Note: The actual link is from FADE.md which contains the standards table

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_MD="$FADE_ROOT/FADE.md"

# Assert: shell-portability.md is linked from FADE.md
if ! grep -q "shell-portability.md" "$FADE_MD"; then
    echo "FAIL: shell-portability.md should be linked from FADE.md"
    echo "Expected: 'shell-portability.md' in FADE.md"
    echo "Actual: not found"
    exit 1
fi

# Assert: Shell Portability is in the standards table
if ! grep -q "Shell Portability" "$FADE_MD"; then
    echo "FAIL: Shell Portability should be listed in standards table"
    echo "Expected: 'Shell Portability' in FADE.md"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: shell-portability.md is linked from FADE.md standards table"
exit 0
