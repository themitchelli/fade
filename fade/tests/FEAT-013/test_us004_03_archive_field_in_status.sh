#!/bin/bash
# Test: verify status.json includes archive field
# AC: Per-repo expanded view shows: Archive list (completed PRDs) with completion dates

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for archive field
if ! grep -q '"archive"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing archive field"
    echo "Expected: JSON contains '\"archive\"'"
    exit 1
fi

echo "PASS: status.json includes archive field"
exit 0
