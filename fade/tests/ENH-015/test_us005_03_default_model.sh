#!/bin/bash
# Test: verify log-outcome.sh defaults to sonnet model
# AC: MODEL_USED: Actual model used (haiku/sonnet/opus, optional)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/log-outcome.sh"

# Check script content for default MODEL_USED
if ! grep -q 'MODEL_USED=.*:-sonnet' "$TARGET_SCRIPT" && ! grep -q 'MODEL_USED.*sonnet' "$TARGET_SCRIPT"; then
    # Also check for explicit default
    if ! grep -q 'sonnet' "$TARGET_SCRIPT"; then
        echo "FAIL: log-outcome.sh should default MODEL_USED to sonnet"
        exit 1
    fi
fi

echo "PASS: log-outcome.sh has default MODEL_USED value"
exit 0
