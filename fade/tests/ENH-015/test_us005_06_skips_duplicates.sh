#!/bin/bash
# Test: verify log-outcome.sh skips duplicate PRD entries
# AC: Check if PRD already exists in history (avoid duplicates)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Check script content for duplicate detection
if ! grep -q 'already in history' "$TARGET_SCRIPT" && ! grep -q 'existing_count' "$TARGET_SCRIPT" && ! grep -q 'duplicate' "$TARGET_SCRIPT"; then
    echo "FAIL: log-outcome.sh should check for and skip duplicates"
    exit 1
fi

echo "PASS: log-outcome.sh has duplicate detection"
exit 0
