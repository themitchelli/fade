#!/bin/bash
# Test: verify /api/docs endpoint is implemented
# AC: Per-repo view includes 'Docs' tab

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for /api/docs route handling
if ! grep -q '/api/docs' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle /api/docs endpoint"
    echo "Expected: route for /api/docs"
    exit 1
fi

# Verify _serve_docs_api method exists
if ! grep -q '_serve_docs_api' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have _serve_docs_api method"
    echo "Expected: _serve_docs_api method"
    exit 1
fi

echo "PASS: /api/docs endpoint is implemented"
exit 0
