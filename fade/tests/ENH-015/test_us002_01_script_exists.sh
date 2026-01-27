#!/bin/bash
# Test: verify fade/lib/extract-features.py exists
# AC: Create fade/lib/extract-features.py that reads PRD JSON

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/extract-features.py"

# Assert: script exists
if [[ ! -f "$TARGET_SCRIPT" ]]; then
    echo "FAIL: extract-features.py not found"
    echo "Expected: $TARGET_SCRIPT to exist"
    echo "Actual: file not found"
    exit 1
fi

# Assert: script has valid Python syntax
if ! python3 -m py_compile "$TARGET_SCRIPT" 2>/dev/null; then
    echo "FAIL: extract-features.py has syntax errors"
    exit 1
fi

echo "PASS: fade/lib/extract-features.py exists and has valid syntax"
exit 0
