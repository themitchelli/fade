#!/bin/bash
# Test: verify /api/doc endpoint for document content is implemented
# AC: Click filename → view full content in modal overlay

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for /api/doc route handling
if ! grep -q '/api/doc/' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle /api/doc/ endpoint"
    echo "Expected: route for /api/doc/"
    exit 1
fi

# Verify _serve_doc_content_api method exists
if ! grep -q '_serve_doc_content_api' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have _serve_doc_content_api method"
    echo "Expected: _serve_doc_content_api method"
    exit 1
fi

echo "PASS: /api/doc content endpoint is implemented"
exit 0
