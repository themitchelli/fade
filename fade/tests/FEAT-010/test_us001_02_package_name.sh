#!/bin/bash
# Test: package name follows expected pattern
# AC: Package name is 'fade-cli' (or similar available name)

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"

# Extract package name
NAME=$(grep '"name"' "$PACKAGE_JSON" | head -1 | sed 's/.*: *"\([^"]*\)".*/\1/')

# Check if name starts with 'fade'
if [[ ! "$NAME" =~ ^fade ]]; then
    echo "FAIL: Package name should start with 'fade'"
    echo "Expected: fade-cli, fade-dev, or similar"
    echo "Actual: $NAME"
    exit 1
fi

# Check that name is valid npm package name (lowercase, hyphens allowed)
if [[ ! "$NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "FAIL: Package name is not a valid npm package name"
    echo "Expected: lowercase letters, numbers, hyphens"
    echo "Actual: $NAME"
    exit 1
fi

echo "PASS: Package name '$NAME' is valid and follows fade naming pattern"
exit 0
