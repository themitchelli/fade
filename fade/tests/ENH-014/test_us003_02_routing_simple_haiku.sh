#!/bin/bash
# Test: verify complexity='simple' routes to haiku model
# AC: Routing logic: complexity='simple' AND no --model override -> use haiku

set -e

FADE_CLI="$(which fade)"

# Check routing logic in cmd_run - simple -> haiku
if grep -A 200 "cmd_run()" "$FADE_CLI" | grep -B 2 -A 2 "simple)" | grep -q "haiku"; then
    echo "PASS: complexity='simple' routes to haiku model"
    exit 0
fi

echo "FAIL: complexity='simple' should route to haiku model"
exit 1
