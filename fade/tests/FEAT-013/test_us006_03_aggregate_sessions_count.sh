#!/bin/bash
# Test: verify aggregate stats include session counts
# AC: Dashboard aggregate view shows: Sessions run today, this week, this month

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check for session count fields in aggregate stats
MISSING_FIELDS=""

if ! grep -q 'sessionsToday\|sessions_today' "$DASHBOARD_SERVER"; then
    MISSING_FIELDS="$MISSING_FIELDS sessionsToday"
fi

if ! grep -q 'sessionsThisWeek\|sessions_this_week' "$DASHBOARD_SERVER"; then
    MISSING_FIELDS="$MISSING_FIELDS sessionsThisWeek"
fi

if ! grep -q 'sessionsThisMonth\|sessions_this_month' "$DASHBOARD_SERVER"; then
    MISSING_FIELDS="$MISSING_FIELDS sessionsThisMonth"
fi

if [[ -n "$MISSING_FIELDS" ]]; then
    echo "FAIL: dashboard-server.py missing session count fields:$MISSING_FIELDS"
    exit 1
fi

echo "PASS: Aggregate stats include session counts"
exit 0
