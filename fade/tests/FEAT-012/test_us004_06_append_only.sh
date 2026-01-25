#!/bin/bash
# Test: verify healing-log.md is append-only, never auto-deleted
# AC: healing-log.md is append-only, never auto-deleted

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify append mode is used (>> not >)
if grep -q 'healing_log$' "$FADE_CLI" | grep -v '>>' | grep -q '>'; then
    echo "FAIL: healing-log.md should use append mode (>>)"
    echo "Expected: >> for healing_log writes"
    echo "Actual: single > redirect found"
    exit 1
fi

# Verify no rm or delete commands for healing-log.md specifically
if grep -qE 'rm\s+(-[rf]+\s+)?(.*healing-log\.md|.*healing.log\.md)' "$FADE_CLI"; then
    echo "FAIL: healing-log.md should never be deleted"
    echo "Expected: no rm commands for healing-log.md"
    echo "Actual: rm command found"
    exit 1
fi

# Verify append pattern in code
if ! grep -q '>> "$healing_log"' "$FADE_CLI"; then
    echo "FAIL: Log should use append operator"
    echo "Expected: '>> \"\$healing_log\"' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: healing-log.md is append-only"
exit 0
