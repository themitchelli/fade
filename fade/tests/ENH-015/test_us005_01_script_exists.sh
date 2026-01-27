#!/bin/bash
# Test: verify fade/lib/log-outcome.sh exists
# AC: Create fade/lib/log-outcome.sh taking: PRD_ID MODEL_USED ESCALATED_TO

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Assert: script exists
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo "FAIL: log-outcome.sh not found"
    echo "Expected: $TARGET_SCRIPT to exist"
    echo "Actual: file not found"
    exit 1
fi

# Assert: script is syntactically valid
if ! bash -n "$TARGET_SCRIPT"; then
    echo "FAIL: log-outcome.sh has syntax errors"
    exit 1
fi

echo "PASS: fade/lib/log-outcome.sh exists and has valid syntax"
exit 0
