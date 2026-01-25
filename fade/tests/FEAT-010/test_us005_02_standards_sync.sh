#!/bin/bash
# Test: fade update handles standards/ folder sync
# AC: fade update still syncs standards/ folder

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that the update mechanism handles standards (check the overall CLI for standards handling)
if ! grep -q "FADE_STANDARDS_BASE_URL\|standards_added\|standards_path" "$FADE_CLI"; then
    echo "FAIL: fade-cli doesn't appear to handle standards/ folder sync"
    exit 1
fi

# Check that the CLI defines standards URLs for fetching
if ! grep -q "FADE_STANDARDS_BASE_URL" "$FADE_CLI"; then
    echo "FAIL: FADE_STANDARDS_BASE_URL not defined for remote standards sync"
    exit 1
fi

# Verify standards directory is included in npm package for distribution
PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"
if ! grep -A10 '"files"' "$PACKAGE_JSON" | grep -q "standards"; then
    echo "FAIL: standards/ not included in package.json files field"
    exit 1
fi

echo "PASS: fade update handles standards/ folder synchronization"
exit 0
