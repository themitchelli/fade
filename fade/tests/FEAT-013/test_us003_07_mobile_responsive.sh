#!/bin/bash
# Test: verify CSS includes mobile-friendly responsive design
# AC: Mobile-friendly responsive design (works on phone/tablet)

STYLES_CSS="$(cd "$(dirname "$0")/../.." && pwd)/templates/dashboard/styles.css"

if [[ ! -f "$STYLES_CSS" ]]; then
    echo "FAIL: styles.css not found"
    exit 1
fi

# Check for media queries (responsive design)
if ! grep -q '@media' "$STYLES_CSS"; then
    echo "FAIL: styles.css should have @media queries for responsive design"
    echo "Expected: @media queries for mobile/tablet"
    exit 1
fi

# Check for viewport-related or mobile breakpoints
if ! grep -qE 'max-width|min-width|screen' "$STYLES_CSS"; then
    echo "FAIL: styles.css should have responsive breakpoints"
    echo "Expected: max-width or min-width media queries"
    exit 1
fi

echo "PASS: CSS includes mobile-friendly responsive design"
exit 0
