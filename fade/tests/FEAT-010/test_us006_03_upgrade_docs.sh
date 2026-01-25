#!/bin/bash
# Test: README documents upgrade path
# AC: Documents upgrade path: npx fade-cli@latest or npm update -g

README="/Users/stevemitchell/Documents/GitHub/fade/README.md"

# Check for @latest tag documentation
if ! grep -q "@latest" "$README"; then
    echo "FAIL: README.md missing @latest tag documentation"
    exit 1
fi

# Check for npm update documentation
if ! grep -q "npm update" "$README"; then
    echo "FAIL: README.md missing 'npm update' documentation"
    exit 1
fi

# Check for upgrading section or context
if ! grep -qi "upgrad\|update" "$README"; then
    echo "FAIL: README.md should have upgrade/update instructions"
    exit 1
fi

echo "PASS: README documents upgrade path (npx @latest and npm update -g)"
exit 0
