#!/bin/bash
# Test: verify aggregate stats include required fields
# AC: Aggregate view shows: Total stories pending, total stories completed today

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for totalPending in aggregate stats
if ! grep -q 'totalPending\|total_pending' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should calculate totalPending"
    echo "Expected: totalPending field in aggregate stats"
    exit 1
fi

# Check for totalCompleted in aggregate stats
if ! grep -q 'totalCompleted\|total_completed' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should calculate totalCompleted"
    echo "Expected: totalCompleted field in aggregate stats"
    exit 1
fi

echo "PASS: Aggregate stats include required fields"
exit 0
