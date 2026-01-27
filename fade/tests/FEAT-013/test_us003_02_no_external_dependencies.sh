#!/bin/bash
# Test: verify dashboard-server.py uses only Python stdlib (no external dependencies)
# AC: Create fade/lib/dashboard-server.py (simple Python HTTP server, no external dependencies)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for common external package imports that would indicate dependencies
EXTERNAL_PACKAGES="flask|django|fastapi|tornado|aiohttp|requests|bottle|cherrypy|pyramid"

if grep -qE "^(import|from) ($EXTERNAL_PACKAGES)" "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py uses external dependencies"
    echo "Expected: only Python stdlib imports"
    echo "Actual: found external package import"
    exit 1
fi

# Verify it uses stdlib http.server
if ! grep -q 'import http.server\|from http.server' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should use stdlib http.server"
    echo "Expected: import http.server"
    exit 1
fi

echo "PASS: dashboard-server.py uses only Python stdlib"
exit 0
