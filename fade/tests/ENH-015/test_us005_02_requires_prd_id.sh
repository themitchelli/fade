#!/bin/bash
# Test: verify log-outcome.sh requires PRD_ID
# AC: Create fade/lib/log-outcome.sh taking: PRD_ID MODEL_USED ESCALATED_TO

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Act: run without arguments
output=$(bash "$TARGET_SCRIPT" 2>&1)
exit_code=$?

# Assert: exits non-zero when missing PRD_ID
if [[ $exit_code -eq 0 ]]; then
    echo "FAIL: log-outcome.sh should exit non-zero without PRD_ID"
    echo "Expected: exit code != 0"
    echo "Actual: exit code = $exit_code"
    exit 1
fi

# Assert: shows usage message
if [[ "$output" != *"Usage:"* ]]; then
    echo "FAIL: log-outcome.sh should show usage message"
    echo "Expected: output contains 'Usage:'"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: log-outcome.sh requires PRD_ID argument"
exit 0
