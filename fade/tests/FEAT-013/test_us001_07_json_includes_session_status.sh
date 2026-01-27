#!/bin/bash
# Test: verify status.json includes status field with valid values
# AC: JSON includes: session status (running/blocked/complete), if blocked: reason

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for status field
if ! grep -q '"status"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing status field"
    echo "Expected: JSON contains '\"status\"'"
    echo "Actual: field not found"
    exit 1
fi

# Verify status is one of the expected values
if ! grep -qE '"status"[[:space:]]*:[[:space:]]*"(running|blocked|complete|idle)"' "$STATUS_FILE"; then
    echo "FAIL: status field has invalid value"
    echo "Expected: one of running, blocked, complete, idle"
    echo "Actual: $(grep '"status"' "$STATUS_FILE" | head -1)"
    exit 1
fi

echo "PASS: status.json includes valid status field"
exit 0
