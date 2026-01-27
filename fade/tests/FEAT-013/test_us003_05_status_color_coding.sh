#!/bin/bash
# Test: verify frontend supports status color coding
# AC: Each card color-coded: green (running), red (blocked), gray (idle), blue (complete)

STYLES_CSS="$(cd "$(dirname "$0")/../.." && pwd)/templates/dashboard/styles.css"

if [[ ! -f "$STYLES_CSS" ]]; then
    echo "FAIL: styles.css not found"
    exit 1
fi

# Check for status-based color classes
MISSING_COLORS=""

if ! grep -q '\.running\|status-running\|card\.running' "$STYLES_CSS"; then
    MISSING_COLORS="$MISSING_COLORS running"
fi

if ! grep -q '\.blocked\|status-blocked\|card\.blocked' "$STYLES_CSS"; then
    MISSING_COLORS="$MISSING_COLORS blocked"
fi

if ! grep -q '\.idle\|status-idle\|card\.idle' "$STYLES_CSS"; then
    MISSING_COLORS="$MISSING_COLORS idle"
fi

if ! grep -q '\.complete\|status-complete\|card\.complete' "$STYLES_CSS"; then
    MISSING_COLORS="$MISSING_COLORS complete"
fi

if [[ -n "$MISSING_COLORS" ]]; then
    echo "FAIL: styles.css missing color classes for:$MISSING_COLORS"
    exit 1
fi

echo "PASS: Frontend supports status color coding"
exit 0
