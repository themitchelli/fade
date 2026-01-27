#!/bin/bash
# Test: verify update-heuristics.py outputs decision tree
# AC: Output updated learnedHeuristics with: useHaikuIf, useSonnetIf, useOpusIf, accuracyStats

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/update-heuristics.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act: run the script
output=$(python3 "$TARGET_SCRIPT" "$HISTORY_FILE" 2>&1)

# Assert: output contains decision tree keys
if [[ "$output" != *"useHaikuIf"* ]]; then
    echo "FAIL: Output should contain useHaikuIf"
    echo "Output: $output"
    exit 1
fi

if [[ "$output" != *"useSonnetIf"* ]]; then
    echo "FAIL: Output should contain useSonnetIf"
    echo "Output: $output"
    exit 1
fi

if [[ "$output" != *"useOpusIf"* ]]; then
    echo "FAIL: Output should contain useOpusIf"
    echo "Output: $output"
    exit 1
fi

if [[ "$output" != *"accuracyStats"* ]]; then
    echo "FAIL: Output should contain accuracyStats"
    echo "Output: $output"
    exit 1
fi

echo "PASS: update-heuristics.py outputs decision tree structure"
exit 0
