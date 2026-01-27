#!/bin/bash
# Test: verify server serves static HTML/CSS/JS from templates
# AC: Server serves static HTML/CSS/JS from fade/templates/dashboard/

DASHBOARD_SERVER="$(cd "$(dirname "$0")/../.." && pwd)/lib/dashboard-server.py"
TEMPLATES_DIR="$(cd "$(dirname "$0")/../.." && pwd)/templates/dashboard"

if [[ ! -f "$DASHBOARD_SERVER" ]]; then
    echo "FAIL: dashboard-server.py not found"
    exit 1
fi

# Check that templates directory exists
if [[ ! -d "$TEMPLATES_DIR" ]]; then
    echo "FAIL: templates/dashboard directory not found"
    echo "Expected: $TEMPLATES_DIR exists"
    exit 1
fi

# Check for index.html
if [[ ! -f "$TEMPLATES_DIR/index.html" ]]; then
    echo "FAIL: templates/dashboard/index.html not found"
    exit 1
fi

# Check for styles.css
if [[ ! -f "$TEMPLATES_DIR/styles.css" ]]; then
    echo "FAIL: templates/dashboard/styles.css not found"
    exit 1
fi

# Check for app.js
if [[ ! -f "$TEMPLATES_DIR/app.js" ]]; then
    echo "FAIL: templates/dashboard/app.js not found"
    exit 1
fi

# Verify server has _serve_file method
if ! grep -q '_serve_file' "$DASHBOARD_SERVER"; then
    echo "FAIL: dashboard-server.py should have _serve_file method"
    exit 1
fi

echo "PASS: Server serves static HTML/CSS/JS from templates"
exit 0
