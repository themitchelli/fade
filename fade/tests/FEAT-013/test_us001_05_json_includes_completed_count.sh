#!/bin/bash
# Test: verify status.json includes completedThisSession field
# AC: JSON includes: completed count (stories done this session)

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for completedThisSession field
if ! grep -q '"completedThisSession"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing completedThisSession field"
    echo "Expected: JSON contains '\"completedThisSession\"'"
    echo "Actual: field not found"
    exit 1
fi

echo "PASS: status.json includes completedThisSession field"
exit 0
