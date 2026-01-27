#!/bin/bash
# Test: verify history tracks escalation
# AC: Update history: Mark PRD as 'escalationNeeded: true, escalationPoint: "session 1 test failures"'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Check history schema supports escalation fields
result=$(python3 << EOF
import json
with open('$HISTORY_FILE') as f:
    data = json.load(f)
    prds = data.get('prds', [])
    if not prds:
        print("SKIP:no_prds")
    else:
        prd = prds[0]
        outcome = prd.get('actualOutcome', {})
        if 'escalationNeeded' in outcome and 'escalationPoint' in outcome:
            print("PASS")
        else:
            print("FAIL:missing_fields")
EOF
)

if [[ "$result" == "SKIP:no_prds" ]]; then
    echo "SKIP: No PRDs in history to check"
    exit 0
fi

if [[ "$result" == "PASS" ]]; then
    echo "PASS: History tracks escalation fields"
    exit 0
else
    echo "FAIL: History missing escalation fields"
    echo "Result: $result"
    exit 1
fi
