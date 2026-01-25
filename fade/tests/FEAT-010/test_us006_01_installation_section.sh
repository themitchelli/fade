#!/bin/bash
# Test: README.md has Installation section with npm commands
# AC: README.md has Installation section with npm commands

README="/Users/stevemitchell/Documents/GitHub/fade/README.md"

if [[ ! -f "$README" ]]; then
    echo "FAIL: README.md not found"
    exit 1
fi

# Check for Installation section
if ! grep -qi "## Installation" "$README"; then
    echo "FAIL: README.md missing '## Installation' section"
    exit 1
fi

# Check for npm install command
if ! grep -q "npm install" "$README"; then
    echo "FAIL: README.md missing 'npm install' command"
    exit 1
fi

# Check for npx command
if ! grep -q "npx" "$README"; then
    echo "FAIL: README.md missing 'npx' command"
    exit 1
fi

echo "PASS: README.md has Installation section with npm commands"
exit 0
