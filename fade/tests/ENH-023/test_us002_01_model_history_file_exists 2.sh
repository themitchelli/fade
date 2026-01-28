#!/bin/bash
# Test: verify model history file exists and has expected structure
# AC: FADE maintains `fade/metrics/model-history.json` (or similar) storing per-model outcomes

# This test verifies that the model selection history file exists and contains
# the required fields for tracking per-model outcomes

FADE_DIR="/Users/stevemitchell/Documents/GitHub/fade"
HISTORY_FILE="$FADE_DIR/fade/model-selection-history.json"

# Test 1: Verify history file exists
if [[ ! -f "$HISTORY_FILE" ]]; then
    echo "FAIL: Model history file should exist at $HISTORY_FILE"
    exit 1
fi

# Test 2: Verify file is valid JSON
if ! cat "$HISTORY_FILE" | head -1 | grep -q '^{'; then
    echo "FAIL: Model history file should be valid JSON"
    echo "Actual first line: $(head -1 "$HISTORY_FILE")"
    exit 1
fi

# Test 3: Verify version field exists
if ! grep -q '"version":' "$HISTORY_FILE"; then
    echo "FAIL: Model history should contain version field"
    exit 1
fi

# Test 4: Verify prds array exists
if ! grep -q '"prds":' "$HISTORY_FILE"; then
    echo "FAIL: Model history should contain prds array"
    exit 1
fi

# Test 5: Verify learnedHeuristics section exists
if ! grep -q '"learnedHeuristics":' "$HISTORY_FILE"; then
    echo "FAIL: Model history should contain learnedHeuristics section"
    exit 1
fi

echo "PASS: Model history file exists with expected structure"
exit 0
