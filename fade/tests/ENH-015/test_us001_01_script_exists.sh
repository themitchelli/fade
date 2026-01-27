#!/bin/bash
# Test: verify fade/lib/detect-sessions.sh exists and is executable
# AC: Create fade/lib/detect-sessions.sh taking PRD_ID, progress.md path, PRD JSON path as arguments

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Assert: script exists
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo "FAIL: detect-sessions.sh not found"
    echo "Expected: $TARGET_SCRIPT to exist"
    echo "Actual: file not found"
    exit 1
fi

# Assert: script is executable or can be sourced
if ! bash -n "$TARGET_SCRIPT"; then
    echo "FAIL: detect-sessions.sh has syntax errors"
    exit 1
fi

echo "PASS: fade/lib/detect-sessions.sh exists and has valid syntax"
exit 0
