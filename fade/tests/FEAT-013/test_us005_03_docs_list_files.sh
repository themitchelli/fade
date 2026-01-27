#!/bin/bash
# Test: verify docs API lists expected documentation files
# AC: Docs tab shows: FADE.md, progress.md (last 50 entries), learned.md, healing-log.md

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check that server defines the expected documentation files
MISSING_DOCS=""

if ! grep -q 'FADE.md' "$DASHBOARD_SERVER"; then
    MISSING_DOCS="$MISSING_DOCS FADE.md"
fi

if ! grep -q 'progress.md' "$DASHBOARD_SERVER"; then
    MISSING_DOCS="$MISSING_DOCS progress.md"
fi

if ! grep -q 'learned.md' "$DASHBOARD_SERVER"; then
    MISSING_DOCS="$MISSING_DOCS learned.md"
fi

if ! grep -q 'healing-log.md' "$DASHBOARD_SERVER"; then
    MISSING_DOCS="$MISSING_DOCS healing-log.md"
fi

if [[ -n "$MISSING_DOCS" ]]; then
    echo "FAIL: dashboard-server.py missing doc file references:$MISSING_DOCS"
    exit 1
fi

echo "PASS: Docs API references all expected documentation files"
exit 0
