#!/bin/bash
# Test: verify model-selection-history.json has prds array
# AC: prds: [] (array of completed PRD records)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act
is_array=$(python3 -c "import json; d=json.load(open('$HISTORY_FILE')); print(type(d.get('prds')).__name__)" 2>/dev/null)

# Assert: prds is a list
if [[ "$is_array" != "list" ]]; then
    echo "FAIL: Expected prds to be an array"
    echo "Expected: list"
    echo "Actual: $is_array"
    exit 1
fi

echo "PASS: model-selection-history.json has prds array"
exit 0
