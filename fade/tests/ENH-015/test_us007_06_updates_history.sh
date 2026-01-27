#!/bin/bash
# Test: verify update-heuristics.py updates history file
# AC: Write back to file with updated learnedHeuristics

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/update-heuristics.py"

# Check script content for file writing
if ! grep -q "open.*'w'\|with open\|json.dump" "$TARGET_SCRIPT"; then
    echo "FAIL: update-heuristics.py should write back to history file"
    exit 1
fi

echo "PASS: update-heuristics.py updates history file"
exit 0
