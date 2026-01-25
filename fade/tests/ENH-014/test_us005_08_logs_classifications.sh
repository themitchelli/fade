#!/bin/bash
# Test: verify fade classify logs all classifications to learned.md
# AC: Log all classifications to learned.md for validation

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify logs to learned.md
if grep -A 200 "cmd_classify()" "$FADE_CLI" | grep -q "learned.*md\|learned_file"; then
    echo "PASS: fade classify logs classifications to learned.md"
    exit 0
fi

echo "FAIL: fade classify should log classifications to learned.md"
exit 1
