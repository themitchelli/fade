#!/bin/bash
# Test: verify /api/aggregate endpoint is implemented
# AC: Dashboard aggregate view shows: Total PRDs queued across all repos

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for /api/aggregate route handling
if ! grep -q '/api/aggregate' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle /api/aggregate endpoint"
    echo "Expected: route for /api/aggregate"
    exit 1
fi

# Verify get_aggregate_stats method exists
if ! grep -q 'get_aggregate_stats' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have get_aggregate_stats method"
    echo "Expected: get_aggregate_stats method"
    exit 1
fi

echo "PASS: /api/aggregate endpoint is implemented"
exit 0
