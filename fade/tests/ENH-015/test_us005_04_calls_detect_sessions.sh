#!/bin/bash
# Test: verify log-outcome.sh calls detect-sessions.sh
# AC: Call fade/lib/detect-sessions.sh to get actual session count

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Check script content for detect-sessions.sh call
if ! grep -q 'detect-sessions' "$TARGET_SCRIPT"; then
    echo "FAIL: log-outcome.sh should call detect-sessions.sh"
    echo "Expected: script references detect-sessions.sh"
    exit 1
fi

echo "PASS: log-outcome.sh calls detect-sessions.sh"
exit 0
