#!/bin/bash
# Test: verify complexity='complex' routes to opus model
# AC: Routing logic: complexity='complex' AND no --model override -> use opus

set -e

FADE_CLI="$(which fade)"

# Check routing logic in cmd_run - complex -> opus
if grep -A 200 "cmd_run()" "$FADE_CLI" | grep -B 2 -A 2 "complex)" | grep -q "opus"; then
    echo "PASS: complexity='complex' routes to opus model"
    exit 0
fi

echo "FAIL: complexity='complex' should route to opus model"
exit 1
