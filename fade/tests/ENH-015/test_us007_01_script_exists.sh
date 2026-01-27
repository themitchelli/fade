#!/bin/bash
# Test: verify fade/lib/update-heuristics.py exists
# AC: Create fade/lib/update-heuristics.py

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/update-heuristics.py"

# Assert: script exists
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo "FAIL: update-heuristics.py not found"
    echo "Expected: $TARGET_SCRIPT to exist"
    echo "Actual: file not found"
    exit 1
fi

# Assert: script has valid Python syntax
if ! python3 -m py_compile "$TARGET_SCRIPT" 2>/dev/null; then
    echo "FAIL: update-heuristics.py has syntax errors"
    exit 1
fi

echo "PASS: fade/lib/update-heuristics.py exists and has valid syntax"
exit 0
