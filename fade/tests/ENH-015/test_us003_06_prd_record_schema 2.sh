#!/bin/bash
# Test: verify PRD records have required fields
# AC: Each PRD record contains: id, date, features, actualOutcome

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act: check first PRD record has required fields
result=$(python3 << EOF
import json
with open('$HISTORY_FILE') as f:
    data = json.load(f)
    prds = data.get('prds', [])
    if not prds:
        print("SKIP:no_prds")
    else:
        prd = prds[0]
        required = ['id', 'date', 'features', 'actualOutcome']
        missing = [f for f in required if f not in prd]
        if missing:
            print(f"FAIL:missing:{','.join(missing)}")
        else:
            print("PASS")
EOF
)

if [[ "$result" == "SKIP:no_prds" ]]; then
    echo "SKIP: No PRDs in history to check"
    exit 0
fi

if [[ "$result" == "PASS" ]]; then
    echo "PASS: PRD records have required fields"
    exit 0
else
    echo "FAIL: PRD records missing fields"
    echo "Result: $result"
    exit 1
fi
