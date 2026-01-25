#!/bin/bash
# Test: Version in package.json matches FADE_VERSION in script
# AC: Version in package.json matches FADE_VERSION in script

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"
FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Extract version from package.json
PKG_VERSION=$(grep '"version"' "$PACKAGE_JSON" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

if [[ -z "$PKG_VERSION" ]]; then
    echo "FAIL: Could not extract version from package.json"
    exit 1
fi

# Extract FADE_VERSION from script
SCRIPT_VERSION=$(grep '^FADE_VERSION=' "$FADE_CLI" | head -1 | sed 's/FADE_VERSION="\([^"]*\)".*/\1/')

if [[ -z "$SCRIPT_VERSION" ]]; then
    echo "FAIL: Could not extract FADE_VERSION from fade-cli script"
    exit 1
fi

# Compare versions
if [[ "$PKG_VERSION" != "$SCRIPT_VERSION" ]]; then
    echo "FAIL: Version mismatch between package.json and fade-cli"
    echo "Expected: package.json version ($PKG_VERSION) == FADE_VERSION ($SCRIPT_VERSION)"
    echo "Actual: $PKG_VERSION != $SCRIPT_VERSION"
    exit 1
fi

echo "PASS: Version in package.json ($PKG_VERSION) matches FADE_VERSION in script"
exit 0
