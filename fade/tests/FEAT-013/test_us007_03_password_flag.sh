#!/bin/bash
# Test: verify --password flag for basic auth
# AC: Optional basic auth: --password flag sets password, prompts on web access

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for --password argument handling
if ! grep -q '\-\-password' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle --password flag"
    echo "Expected: --password argument parsing"
    exit 1
fi

# Check for basic auth implementation
if ! grep -q 'Authorization\|WWW-Authenticate\|Basic' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should implement basic authentication"
    echo "Expected: HTTP Basic Auth headers"
    exit 1
fi

echo "PASS: --password flag for basic auth is implemented"
exit 0
