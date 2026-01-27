#!/bin/bash
# Test: verify frontend auto-refreshes every 30s via JavaScript
# AC: Auto-refresh every 30s via JavaScript (no manual reload needed)

APP_JS="$(cd "$(dirname "$0")/../.." && pwd)/templates/dashboard/app.js"

if [[ ! -f "$APP_JS" ]]; then
    echo "FAIL: app.js not found"
    exit 1
fi

# Check for setInterval or setTimeout for auto-refresh
if ! grep -qE 'setInterval|setTimeout' "$APP_JS"; then
    echo "FAIL: app.js should use setInterval/setTimeout for auto-refresh"
    echo "Expected: setInterval or setTimeout for periodic refresh"
    exit 1
fi

# Check for 30 second interval (30000ms or 30 * 1000)
if ! grep -qE '30000|30 \* 1000|30\*1000|refreshInterval' "$APP_JS"; then
    echo "FAIL: app.js should use 30 second refresh interval"
    echo "Expected: 30000ms or 30 * 1000 or refreshInterval reference"
    exit 1
fi

echo "PASS: Frontend auto-refreshes every 30s"
exit 0
