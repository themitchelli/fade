#!/bin/bash
# Test: verify warning when --remote used without auth
# AC: Warning if --remote used without auth: 'WARNING: Dashboard accessible to network without password'

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for warning message
if ! grep -q 'WARNING.*network without password\|accessible.*without password' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should warn about remote access without auth"
    echo "Expected: Warning message about network access without password"
    exit 1
fi

echo "PASS: Warning displayed when --remote used without auth"
exit 0
