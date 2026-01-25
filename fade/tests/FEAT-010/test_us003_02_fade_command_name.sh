#!/bin/bash
# Test: package.json bin defines 'fade' command for PATH
# AC: After install, 'fade' command is available in PATH

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"

# Check that the bin field defines 'fade' as the command name
if ! grep -A2 '"bin"' "$PACKAGE_JSON" | grep -q '"fade"'; then
    echo "FAIL: bin field should define 'fade' as command name"
    echo "Expected: bin.fade pointing to the CLI script"
    exit 1
fi

# Verify the command name is exactly 'fade' (not fade-cli or fade-dev)
BIN_CONTENT=$(grep -A2 '"bin"' "$PACKAGE_JSON")
if echo "$BIN_CONTENT" | grep -q '"fade-cli"' || echo "$BIN_CONTENT" | grep -q '"fade-dev"'; then
    # These would be the package name, not the command - that's OK
    # We're checking that 'fade' (without suffix) is the command name
    if ! echo "$BIN_CONTENT" | grep -qE '"fade"[[:space:]]*:'; then
        echo "FAIL: Command should be named 'fade' (without suffix)"
        exit 1
    fi
fi

echo "PASS: bin field defines 'fade' command for PATH availability"
exit 0
