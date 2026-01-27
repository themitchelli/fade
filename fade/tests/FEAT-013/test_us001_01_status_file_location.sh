#!/bin/bash
# Test: verify status.json is written to fade/status.json in contained structure
# AC: During FADE run/yolo, write fade/status.json every 60 seconds

# This test verifies status.json exists in the expected location
# by checking the current fade/status.json file

FADE_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
STATUS_FILE="$FADE_DIR/fade/status.json"

# Check that status.json exists in the contained structure
if [[ ! -f "$STATUS_FILE" ]]; then
    echo "FAIL: Expected fade/status.json to exist"
    echo "Expected: $STATUS_FILE exists"
    echo "Actual: file not found"
    exit 1
fi

echo "PASS: fade/status.json exists in contained structure"
exit 0
