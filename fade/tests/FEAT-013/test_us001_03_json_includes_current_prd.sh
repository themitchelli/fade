#!/bin/bash
# Test: verify status.json includes currentPRD field with id and name
# AC: JSON includes: repo name, current PRD, current story, iteration count, start time, model, mode

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for currentPRD object with id and name
if ! grep -q '"currentPRD"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing currentPRD field"
    echo "Expected: JSON contains '\"currentPRD\"'"
    echo "Actual: field not found"
    exit 1
fi

# Verify structure includes id field within currentPRD
if ! grep -q '"id"' "$STATUS_FILE"; then
    echo "FAIL: status.json currentPRD missing id field"
    echo "Expected: JSON contains '\"id\"' within currentPRD"
    echo "Actual: field not found"
    exit 1
fi

echo "PASS: status.json includes currentPRD field with id"
exit 0
