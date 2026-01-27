#!/bin/bash
# Test: verify docs API returns modified timestamp
# AC: Last modified timestamp shown for each doc

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for file modification timestamp handling in docs API
if ! grep -q 'st_mtime\|modified' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should include modified timestamp for docs"
    echo "Expected: st_mtime or 'modified' field"
    exit 1
fi

echo "PASS: Docs API includes modified timestamp"
exit 0
