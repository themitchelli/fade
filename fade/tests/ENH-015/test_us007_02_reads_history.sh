#!/bin/bash
# Test: verify update-heuristics.py reads model-selection-history.json
# AC: Read fade/model-selection-history.json prds array

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/update-heuristics.py"

# Check script content for history file reading
if ! grep -q 'model-selection-history.json\|history.*json' "$TARGET_SCRIPT"; then
    echo "FAIL: update-heuristics.py should read model-selection-history.json"
    exit 1
fi

echo "PASS: update-heuristics.py reads history file"
exit 0
