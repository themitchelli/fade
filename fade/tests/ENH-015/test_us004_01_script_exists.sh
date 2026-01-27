#!/bin/bash
# Test: verify fade/recommend-model.py exists
# AC: Create fade/recommend-model.py taking PRD ID as argument

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/recommend-model.py"

# Assert: script exists
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo "FAIL: recommend-model.py not found"
    echo "Expected: $TARGET_SCRIPT to exist"
    echo "Actual: file not found"
    exit 1
fi

# Assert: script has valid Python syntax
if ! python3 -m py_compile "$TARGET_SCRIPT" 2>/dev/null; then
    echo "FAIL: recommend-model.py has syntax errors"
    exit 1
fi

echo "PASS: fade/recommend-model.py exists and has valid syntax"
exit 0
