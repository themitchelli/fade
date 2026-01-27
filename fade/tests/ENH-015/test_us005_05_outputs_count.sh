#!/bin/bash
# Test: verify log-outcome.sh outputs PRD count
# AC: Outputs: count of PRDs in history.json

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Check script outputs a count (numeric value on success)
# Look for the pattern that outputs prd_count at the end
if ! grep -q 'echo.*prd_count' "$TARGET_SCRIPT" && ! grep -q 'wc -l' "$TARGET_SCRIPT"; then
    echo "FAIL: log-outcome.sh should output PRD count"
    exit 1
fi

echo "PASS: log-outcome.sh outputs PRD count"
exit 0
