#!/bin/bash
# Test: verify model-selection-history.json has learnedHeuristics
# AC: learnedHeuristics: {} (decision tree derived from prds)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act
is_dict=$(python3 -c "import json; d=json.load(open('$HISTORY_FILE')); print(type(d.get('learnedHeuristics')).__name__)" 2>/dev/null)

# Assert: learnedHeuristics is a dict
if [[ "$is_dict" != "dict" ]]; then
    echo "FAIL: Expected learnedHeuristics to be an object"
    echo "Expected: dict"
    echo "Actual: $is_dict"
    exit 1
fi

echo "PASS: model-selection-history.json has learnedHeuristics object"
exit 0
