#!/bin/bash
# Test: verify log-outcome.sh validates JSON output
# AC: Verify JSON is valid after update

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Check script content for JSON validation
if ! grep -q 'json.tool\|json.load\|valid.*JSON' "$TARGET_SCRIPT"; then
    echo "FAIL: log-outcome.sh should validate JSON output"
    exit 1
fi

echo "PASS: log-outcome.sh has JSON validation"
exit 0
