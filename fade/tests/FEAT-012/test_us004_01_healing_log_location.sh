#!/bin/bash
# Test: verify healing-log.md is created/appended at correct location
# AC: Create/append to fade/healing-log.md

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
HEALING_LOG="$FADE_ROOT/fade/healing-log.md"

# Assert: healing-log.md exists in the fade directory
if [[ ! -f "$HEALING_LOG" ]]; then
    echo "FAIL: healing-log.md should exist at fade/healing-log.md"
    echo "Expected: $HEALING_LOG"
    echo "Actual: file not found"
    exit 1
fi

# Assert: file is in the correct location (fade/ subdirectory)
if [[ ! "$HEALING_LOG" == *"/fade/healing-log.md" ]]; then
    echo "FAIL: healing-log.md should be in fade/ directory"
    echo "Expected: */fade/healing-log.md"
    echo "Actual: $HEALING_LOG"
    exit 1
fi

echo "PASS: healing-log.md exists at correct location"
exit 0
