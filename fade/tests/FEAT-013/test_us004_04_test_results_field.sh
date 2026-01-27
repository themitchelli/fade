#!/bin/bash
# Test: verify status.json includes testResults field
# AC: Per-repo expanded view shows: Regression test results (pass/fail counts, last run time)

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for testResults field
if ! grep -q '"testResults"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing testResults field"
    echo "Expected: JSON contains '\"testResults\"'"
    exit 1
fi

echo "PASS: status.json includes testResults field"
exit 0
