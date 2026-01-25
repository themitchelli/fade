#!/bin/bash
# Test: README shows both npx and global install options
# AC: Shows both npx (no install) and global install options

README="/Users/stevemitchell/Documents/GitHub/fade/README.md"

# Check for npx option
if ! grep -q "npx" "$README"; then
    echo "FAIL: README.md missing npx installation option"
    exit 1
fi

# Check for global install option (-g flag)
if ! grep -q "npm install -g" "$README"; then
    echo "FAIL: README.md missing global install option (npm install -g)"
    exit 1
fi

# Check that both are mentioned in distinct sections or contexts
NPX_COUNT=$(grep -c "npx" "$README")
GLOBAL_COUNT=$(grep -c "\-g" "$README")

if [[ "$NPX_COUNT" -lt 1 ]] || [[ "$GLOBAL_COUNT" -lt 1 ]]; then
    echo "FAIL: README should clearly show both npx and global install options"
    echo "Found npx mentions: $NPX_COUNT"
    echo "Found -g mentions: $GLOBAL_COUNT"
    exit 1
fi

echo "PASS: README shows both npx (no install) and global install options"
exit 0
