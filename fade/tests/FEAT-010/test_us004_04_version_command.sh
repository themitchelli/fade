#!/bin/bash
# Test: fade version shows npm package version
# AC: fade version shows npm package version

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"

# Get version from package.json
PKG_VERSION=$(grep '"version"' "$PACKAGE_JSON" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

# Run fade version command
VERSION_OUTPUT=$("$FADE_CLI" version 2>&1) || true

# Check that version output contains the package version
if ! echo "$VERSION_OUTPUT" | grep -q "$PKG_VERSION"; then
    echo "FAIL: fade version output doesn't show package version"
    echo "Expected: output to contain '$PKG_VERSION'"
    echo "Actual: $VERSION_OUTPUT"
    exit 1
fi

echo "PASS: fade version shows package version ($PKG_VERSION)"
exit 0
