#!/bin/bash
# Test: verify cmd_run() reads complexity field from PRD
# AC: Update cmd_run() to read complexity field from PRD

set -e

FADE_CLI="$(which fade)"

# Check that cmd_run references get_prd_complexity
if grep -A 100 "cmd_run()" "$FADE_CLI" | grep -q "get_prd_complexity"; then
    echo "PASS: cmd_run() reads complexity field from PRD"
    exit 0
fi

echo "FAIL: cmd_run() should read complexity field via get_prd_complexity"
exit 1
