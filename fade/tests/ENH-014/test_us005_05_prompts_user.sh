#!/bin/bash
# Test: verify fade classify prompts user to update PRD
# AC: Prompt: 'Update PRD with suggested complexity? [y/N]'

set -e

FADE_CLI="$(which fade)"

# Check that cmd_classify prompts user
if grep -A 150 "cmd_classify()" "$FADE_CLI" | grep -q "Update PRD with suggested complexity"; then
    echo "PASS: fade classify prompts user to update PRD"
    exit 0
fi

echo "FAIL: fade classify should prompt 'Update PRD with suggested complexity? [y/N]'"
exit 1
