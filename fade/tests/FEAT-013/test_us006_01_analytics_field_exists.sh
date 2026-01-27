#!/bin/bash
# Test: verify status.json includes analytics field
# AC: Dashboard aggregate view shows: Sessions run today, this week, this month

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for analytics field
if ! grep -q '"analytics"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing analytics field"
    echo "Expected: JSON contains '\"analytics\"'"
    exit 1
fi

echo "PASS: status.json includes analytics field"
exit 0
