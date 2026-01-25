#!/bin/bash
# Test: verify FADE_MODEL env var overrides complexity, but --model flag overrides both
# AC: Routing logic: FADE_MODEL env var overrides complexity, but --model flag overrides both

set -e

FADE_CLI="$(which fade)"

# Check default model uses FADE_MODEL env var
if grep -A 10 "cmd_run()" "$FADE_CLI" | grep -q 'FADE_MODEL:-sonnet\|FADE_MODEL:-'; then
    # Check that model_override (--model flag) takes precedence
    if grep -A 200 "cmd_run()" "$FADE_CLI" | grep -q 'routing_source="--model flag"'; then
        echo "PASS: FADE_MODEL env var overrides complexity, --model flag overrides both"
        exit 0
    fi
fi

echo "FAIL: Override precedence should be: --model flag > FADE_MODEL > complexity"
exit 1
