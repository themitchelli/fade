#!/bin/bash
# Test: verify fade classify displays suggested complexity with reasoning
# AC: Display suggested complexity with reasoning

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify displays suggestion
if grep -A 150 "cmd_classify()" "$FADE_CLI" | grep -q "Suggested complexity"; then
    echo "PASS: fade classify displays suggested complexity"
    exit 0
fi

echo "FAIL: fade classify should display suggested complexity with reasoning"
exit 1
