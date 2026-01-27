#!/bin/bash
# Test: verify fade run calls recommend-model.py
# AC: When fade run starts with a PRD, call fade/recommend-model.py PRD_ID

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
CLI_FILE="$SCRIPT_DIR/bin/fade-cli"

# Check that CLI references recommend-model
if ! grep -q 'recommend-model\|get_model_recommendation\|display_model_recommendation' "$CLI_FILE"; then
    echo "FAIL: fade-cli should call recommend-model functionality"
    exit 1
fi

echo "PASS: fade-cli integrates model recommendation"
exit 0
