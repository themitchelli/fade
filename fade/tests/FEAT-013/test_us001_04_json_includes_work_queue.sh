#!/bin/bash
# Test: verify status.json includes workQueue field
# AC: JSON includes: work queue (list of pending PRDs with story counts)

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for workQueue array field
if ! grep -q '"workQueue"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing workQueue field"
    echo "Expected: JSON contains '\"workQueue\"'"
    echo "Actual: field not found"
    exit 1
fi

echo "PASS: status.json includes workQueue field"
exit 0
