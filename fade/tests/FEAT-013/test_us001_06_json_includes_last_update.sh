#!/bin/bash
# Test: verify status.json includes lastUpdate timestamp in ISO 8601 format
# AC: JSON includes: last update timestamp (ISO 8601 format)

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for lastUpdate field
if ! grep -q '"lastUpdate"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing lastUpdate field"
    echo "Expected: JSON contains '\"lastUpdate\"'"
    echo "Actual: field not found"
    exit 1
fi

# Verify ISO 8601 format (YYYY-MM-DDTHH:MM:SSZ pattern)
if ! grep -qE '"lastUpdate"[[:space:]]*:[[:space:]]*"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z"' "$STATUS_FILE"; then
    echo "FAIL: lastUpdate not in ISO 8601 format"
    echo "Expected: format like \"2026-01-25T12:34:56Z\""
    echo "Actual: $(grep '"lastUpdate"' "$STATUS_FILE")"
    exit 1
fi

echo "PASS: status.json includes lastUpdate in ISO 8601 format"
exit 0
