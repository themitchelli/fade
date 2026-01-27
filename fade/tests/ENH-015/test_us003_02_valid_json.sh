#!/bin/bash
# Test: verify fade/model-selection-history.json is valid JSON
# AC: File is valid JSON, loadable without errors

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Assert: file is valid JSON
if ! python3 -m json.tool "$HISTORY_FILE" >/dev/null 2>&1; then
    echo "FAIL: model-selection-history.json is not valid JSON"
    echo "File: $HISTORY_FILE"
    exit 1
fi

echo "PASS: model-selection-history.json is valid JSON"
exit 0
