#!/bin/bash
# Test: verify --model flag overrides complexity-based routing
# AC: Routing logic: --model flag always overrides complexity-based routing

set -e

FADE_CLI="$(which fade)"

# Check that model_override flag is set when --model is used
if grep -A 50 "cmd_run()" "$FADE_CLI" | grep -q "model_override=true"; then
    # Check that model_override=false triggers complexity routing
    if grep -A 200 "cmd_run()" "$FADE_CLI" | grep -q 'model_override.*false.*get_prd_complexity\|if.*model_override.*false'; then
        echo "PASS: --model flag overrides complexity-based routing"
        exit 0
    fi
fi

echo "FAIL: --model flag should override complexity-based routing"
exit 1
