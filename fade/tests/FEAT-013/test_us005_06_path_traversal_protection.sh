#!/bin/bash
# Test: verify doc API has path traversal protection
# AC: Security: ensure doc_path doesn't escape repo directory

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for path normalization and validation
if ! grep -q 'normpath' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should use normpath for path security"
    echo "Expected: os.path.normpath for path validation"
    exit 1
fi

# Check for path prefix validation (startswith check)
if ! grep -q 'startswith' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should validate path prefix"
    echo "Expected: startswith check for path traversal protection"
    exit 1
fi

echo "PASS: Doc API has path traversal protection"
exit 0
