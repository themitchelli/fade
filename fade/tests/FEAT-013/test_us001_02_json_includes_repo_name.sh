#!/bin/bash
# Test: verify status.json includes repo name field
# AC: JSON includes: repo name, current PRD, current story, iteration count, start time, model, mode

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

if [[ ! -f "$STATUS_FILE" ]]; then
    echo "SKIP: No status.json file available for testing"
    exit 0
fi

# Check for repoName field
if ! grep -q '"repoName"' "$STATUS_FILE"; then
    echo "FAIL: status.json missing repoName field"
    echo "Expected: JSON contains '\"repoName\"'"
    echo "Actual: field not found"
    exit 1
fi

echo "PASS: status.json includes repoName field"
exit 0
