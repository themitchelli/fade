#!/bin/bash
# Test: verify fade/model-selection-history.json exists
# AC: Create fade/model-selection-history.json with schema

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Assert: file exists
if [[ ! -f "$HISTORY_FILE" ]]; then
    echo "FAIL: model-selection-history.json not found"
    echo "Expected: $HISTORY_FILE to exist"
    echo "Actual: file not found"
    exit 1
fi

echo "PASS: fade/model-selection-history.json exists"
exit 0
