#!/bin/bash
# Test: verify model-selection-history.json has backfilled data
# AC: Backfill with data from fade/prd-archive: Extract features and outcomes for all completed PRDs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act: count PRDs
prd_count=$(python3 -c "import json; print(len(json.load(open('$HISTORY_FILE')).get('prds', [])))" 2>/dev/null)

# Assert: at least some PRDs are backfilled
if [[ "$prd_count" -lt 1 ]]; then
    echo "FAIL: Expected at least 1 PRD in history (backfilled)"
    echo "Expected: >= 1"
    echo "Actual: $prd_count"
    exit 1
fi

echo "PASS: model-selection-history.json has $prd_count backfilled PRDs"
exit 0
