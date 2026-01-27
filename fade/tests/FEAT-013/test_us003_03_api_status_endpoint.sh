#!/bin/bash
# Test: verify /api/status endpoint is implemented
# AC: Server reads all status.json files from configured repos every 30s

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for /api/status route handling
if ! grep -q '/api/status' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle /api/status endpoint"
    echo "Expected: route for /api/status"
    exit 1
fi

# Verify _serve_status_api method exists
if ! grep -q '_serve_status_api' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have _serve_status_api method"
    echo "Expected: _serve_status_api method"
    exit 1
fi

echo "PASS: /api/status endpoint is implemented"
exit 0
