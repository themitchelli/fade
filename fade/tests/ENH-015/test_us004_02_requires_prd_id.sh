#!/bin/bash
# Test: verify recommend-model.py requires PRD ID
# AC: Create fade/recommend-model.py taking PRD ID as argument

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"

# Act: run without arguments
output=$(python3 "$TARGET_SCRIPT" 2>&1)
exit_code=$?

# Assert: exits non-zero when missing PRD ID
if [[ $exit_code -eq 0 ]]; then
    echo "FAIL: recommend-model.py should exit non-zero without PRD ID"
    echo "Expected: exit code != 0"
    echo "Actual: exit code = $exit_code"
    exit 1
fi

# Assert: shows usage message
if [[ "$output" != *"Usage:"* ]]; then
    echo "FAIL: recommend-model.py should show usage message"
    echo "Expected: output contains 'Usage:'"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: recommend-model.py requires PRD ID argument"
exit 0
