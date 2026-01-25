#!/bin/bash
# Test: verify each fix is logged to healing-log.md
# AC: Log each fix application to healing-log.md with timestamp, file, pattern, replacement

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
HEALING_LOG="$FADE_ROOT/fade/healing-log.md"

# Assert: healing-log.md exists (should have been created by prior healing operations)
if [[ ! -f "$HEALING_LOG" ]]; then
    echo "FAIL: healing-log.md should exist"
    echo "Expected: $HEALING_LOG"
    echo "Actual: file not found"
    exit 1
fi

# Assert: log contains date/time format
if ! grep -qE "^## [0-9]{4}-[0-9]{2}-[0-9]{2}" "$HEALING_LOG"; then
    echo "FAIL: Log should contain timestamped entries"
    echo "Expected: ## YYYY-MM-DD format"
    echo "Actual: $(head -5 "$HEALING_LOG")"
    exit 1
fi

# Assert: log contains Error Type field
if ! grep -q "Error Type:" "$HEALING_LOG"; then
    echo "FAIL: Log should contain Error Type field"
    echo "Expected: Error Type: in log entries"
    echo "Actual: not found"
    exit 1
fi

# Assert: log contains Pattern field
if ! grep -q "Pattern:" "$HEALING_LOG"; then
    echo "FAIL: Log should contain Pattern field"
    echo "Expected: Pattern: in log entries"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: Fix applications are logged to healing-log.md"
exit 0
