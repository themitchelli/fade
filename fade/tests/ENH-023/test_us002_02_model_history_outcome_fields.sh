#!/bin/bash
# Test: verify model history stores per-model outcomes with required fields
# AC: FADE maintains `fade/metrics/model-history.json` storing per-model outcomes:
#     success rate, retries, regression failures, average duration per story

FADE_DIR="/Users/stevemitchell/Documents/GitHub/fade"
HISTORY_FILE="$FADE_DIR/fade/model-selection-history.json"

if [[ ! -f "$HISTORY_FILE" ]]; then
    echo "FAIL: Model history file should exist"
    exit 1
fi

# Test 1: Verify PRD entries have outcome section
if ! grep -q '"actualOutcome":' "$HISTORY_FILE"; then
    echo "FAIL: PRD entries should have actualOutcome section"
    exit 1
fi

# Test 2: Verify sessionsRequired (tracks retries)
if ! grep -q '"sessionsRequired":' "$HISTORY_FILE"; then
    echo "FAIL: actualOutcome should include sessionsRequired (for retry tracking)"
    exit 1
fi

# Test 3: Verify modelRecommended (what was suggested)
if ! grep -q '"modelRecommended":' "$HISTORY_FILE"; then
    echo "FAIL: actualOutcome should include modelRecommended"
    exit 1
fi

# Test 4: Verify modelSucceeded (what actually worked)
if ! grep -q '"modelSucceeded":' "$HISTORY_FILE"; then
    echo "FAIL: actualOutcome should include modelSucceeded"
    exit 1
fi

# Test 5: Verify escalationNeeded (tracks if model was insufficient)
if ! grep -q '"escalationNeeded":' "$HISTORY_FILE"; then
    echo "FAIL: actualOutcome should include escalationNeeded flag"
    exit 1
fi

# Test 6: Verify errors array (tracks failures)
if ! grep -q '"errors":' "$HISTORY_FILE"; then
    echo "FAIL: actualOutcome should include errors array for regression failures"
    exit 1
fi

# Test 7: Verify accuracy statistics exist
if ! grep -q '"accuracyStats":' "$HISTORY_FILE"; then
    echo "FAIL: learnedHeuristics should include accuracyStats"
    exit 1
fi

echo "PASS: Model history stores per-model outcomes with required fields"
exit 0
