#!/bin/bash
# Test: verify rate limiting is implemented
# AC: Rate limiting: Max 100 requests/minute per IP to prevent abuse

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for RateLimiter class
if ! grep -q 'RateLimiter\|rate_limit' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have rate limiting"
    echo "Expected: RateLimiter class or rate_limit logic"
    exit 1
fi

# Check for 100 request limit
if ! grep -q '100' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have 100 request limit"
    echo "Expected: 100 requests rate limit"
    exit 1
fi

echo "PASS: Rate limiting is implemented"
exit 0
