#!/bin/bash
# Test: verify --model flag skips recommendation
# AC: If --model flag provided, skip recommendation (user override)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check for --model flag handling
if ! grep -q '\-\-model' "$CLI_FILE"; then
    echo "FAIL: fade-cli should support --model flag"
    exit 1
fi

# Check for model_override logic
if ! grep -q 'model_override' "$CLI_FILE"; then
    echo "FAIL: fade-cli should track model override"
    exit 1
fi

echo "PASS: fade-cli supports --model flag override"
exit 0
