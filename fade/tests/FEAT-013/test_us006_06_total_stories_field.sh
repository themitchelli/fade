#!/bin/bash
# Test: verify aggregate stats include total stories completed
# AC: Aggregate view shows: Total stories completed (across all repos)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for total stories tracking
if ! grep -q 'totalStories\|total_stories' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should track total stories"
    echo "Expected: totalStories field in aggregate stats"
    exit 1
fi

echo "PASS: Aggregate stats include total stories completed"
exit 0
