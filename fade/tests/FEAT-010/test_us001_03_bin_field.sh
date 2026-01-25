#!/bin/bash
# Test: bin field points to fade shell script
# AC: bin field points to the fade shell script

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"
REPO_ROOT="/Users/stevemitchell/Documents/GitHub/fade"

# Check that bin field exists and references fade-cli
if ! grep -q '"fade"' "$PACKAGE_JSON"; then
    echo "FAIL: bin field should define 'fade' command"
    exit 1
fi

# Extract the bin path
BIN_PATH=$(grep -A1 '"bin"' "$PACKAGE_JSON" | grep '"fade"' | sed 's/.*: *"\([^"]*\)".*/\1/')

if [[ -z "$BIN_PATH" ]]; then
    echo "FAIL: Could not extract bin path from package.json"
    exit 1
fi

# Check that the referenced file exists
FULL_PATH="$REPO_ROOT/$BIN_PATH"
if [[ ! -f "$FULL_PATH" ]]; then
    echo "FAIL: bin target does not exist"
    echo "Expected: $FULL_PATH"
    echo "Actual: file not found"
    exit 1
fi

# Check that the file is executable or is a shell script
if head -1 "$FULL_PATH" | grep -q '^#!/bin/bash'; then
    echo "PASS: bin field points to valid shell script at $BIN_PATH"
    exit 0
fi

echo "FAIL: bin target is not a bash shell script"
exit 1
