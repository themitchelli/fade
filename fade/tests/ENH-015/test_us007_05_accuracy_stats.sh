#!/bin/bash
# Test: verify update-heuristics.py outputs accuracy stats
# AC: accuracyStats: {haiku_accuracy, sonnet_accuracy, opus_accuracy} (percentages)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/update-heuristics.py"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act: run the script and parse accuracyStats
output=$(python3 "$TARGET_SCRIPT" "$HISTORY_FILE" 2>/dev/null)

# Check for accuracy fields
if [[ "$output" != *"haiku_accuracy"* ]]; then
    echo "FAIL: Output should contain haiku_accuracy"
    echo "Output: $output"
    exit 1
fi

if [[ "$output" != *"sonnet_accuracy"* ]]; then
    echo "FAIL: Output should contain sonnet_accuracy"
    echo "Output: $output"
    exit 1
fi

if [[ "$output" != *"opus_accuracy"* ]]; then
    echo "FAIL: Output should contain opus_accuracy"
    echo "Output: $output"
    exit 1
fi

echo "PASS: update-heuristics.py outputs accuracy stats for all models"
exit 0
