#!/bin/bash
# Test: verify detect-sessions.sh requires PRD_ID, progress.md path, PRD JSON path
# AC: Create fade/lib/detect-sessions.sh taking PRD_ID, progress.md path, PRD JSON path as arguments

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Act: run without arguments
output=$(bash "$TARGET_SCRIPT" 2>&1)
exit_code=$?

# Assert: exits non-zero when missing args
if [[ $exit_code -eq 0 ]]; then
    echo "FAIL: detect-sessions.sh should exit non-zero when missing arguments"
    echo "Expected: exit code != 0"
    echo "Actual: exit code = $exit_code"
    exit 1
fi

# Assert: shows usage message
if [[ "$output" != *"Usage:"* ]]; then
    echo "FAIL: detect-sessions.sh should show usage message when missing arguments"
    echo "Expected: output contains 'Usage:'"
    echo "Actual: $output"
    exit 1
fi

echo "PASS: detect-sessions.sh requires arguments and shows usage"
exit 0
