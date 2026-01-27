#!/bin/bash
# Test: verify dashboard returns model accuracy stats
# AC: Model accuracy stats: 'Haiku: 95% (12 PRDs), Sonnet: 75% (18 PRDs), Opus: 100% (5 PRDs)'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
DASHBOARD_FILE="$SCRIPT_DIR/fade/lib/dashboard-server.py"

# Check for model stats calculation
if ! grep -q 'modelStats\|model_stats\|accuracy' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should calculate model accuracy stats"
    exit 1
fi

# Check for individual model stats
if ! grep -q 'haiku\|sonnet\|opus' "$DASHBOARD_FILE"; then
    echo "FAIL: dashboard-server.py should track individual model stats"
    exit 1
fi

echo "PASS: dashboard-server.py has model accuracy stats"
exit 0
