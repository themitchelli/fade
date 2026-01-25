#!/bin/bash
# Test: package.json exists with required fields
# AC: package.json exists with name, version, description, bin, repository fields

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"

# Check package.json exists
if [[ ! -f "$PACKAGE_JSON" ]]; then
    echo "FAIL: package.json does not exist"
    exit 1
fi

# Check for name field
if ! grep -q '"name"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing 'name' field"
    exit 1
fi

# Check for version field
if ! grep -q '"version"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing 'version' field"
    exit 1
fi

# Check for description field
if ! grep -q '"description"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing 'description' field"
    exit 1
fi

# Check for bin field
if ! grep -q '"bin"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing 'bin' field"
    exit 1
fi

# Check for repository field
if ! grep -q '"repository"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing 'repository' field"
    exit 1
fi

echo "PASS: package.json exists with all required fields (name, version, description, bin, repository)"
exit 0
