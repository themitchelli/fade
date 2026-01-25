#!/bin/bash
# Test: verify complexity='medium' or missing routes to sonnet model
# AC: Routing logic: complexity='medium' OR missing -> use sonnet (default)

set -e

FADE_CLI="$(which fade)"

# Check routing logic in cmd_run - medium -> sonnet
if grep -A 200 "cmd_run()" "$FADE_CLI" | grep -B 2 -A 2 'medium|""' | grep -q "sonnet"; then
    echo "PASS: complexity='medium' or missing routes to sonnet model"
    exit 0
fi

echo "FAIL: complexity='medium' or missing should route to sonnet model"
exit 1
