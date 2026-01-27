#!/bin/bash
# Test: verify analytics include healing events count
# AC: Per-repo view shows: Healing events count (auto-fixed issues)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for healing events tracking
if ! grep -q 'healingEvents\|healing_events' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should track healing events"
    echo "Expected: healingEvents field in stats"
    exit 1
fi

echo "PASS: Analytics include healing events count"
exit 0
