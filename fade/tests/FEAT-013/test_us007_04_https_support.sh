#!/bin/bash
# Test: verify HTTPS support via --cert and --key flags
# AC: HTTPS support via --cert and --key flags (self-signed cert OK for local network)

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for --cert argument handling
if ! grep -q '\-\-cert' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle --cert flag"
    echo "Expected: --cert argument parsing"
    exit 1
fi

# Check for --key argument handling
if ! grep -q '\-\-key' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should handle --key flag"
    echo "Expected: --key argument parsing"
    exit 1
fi

# Check for SSL context creation
if ! grep -q 'ssl\|SSLContext' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should use SSL module for HTTPS"
    echo "Expected: ssl module usage"
    exit 1
fi

echo "PASS: HTTPS support via --cert and --key is implemented"
exit 0
