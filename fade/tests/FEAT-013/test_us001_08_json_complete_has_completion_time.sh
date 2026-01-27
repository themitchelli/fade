#!/bin/bash
# Test: verify status.json includes completionTime when status is complete
# AC: If session completes, write final status with completion timestamp

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check if status is complete
if grep -qE '"status"[[:space:]]*:[[:space:]]*"complete"' "$STATUS_FILE"; then
    # If complete, must have completionTime
    if ! grep -q '"completionTime"' "$STATUS_FILE"; then
        echo "FAIL: status is 'complete' but missing completionTime field"
        echo "Expected: JSON contains '\"completionTime\"' when status is complete"
        echo "Actual: field not found"
        exit 1
    fi
    echo "PASS: status.json includes completionTime for completed session"
else
    echo "PASS: status not complete, completionTime check not applicable"
fi

exit 0
