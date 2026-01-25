#!/bin/bash
# Test: License field matches LICENSE file
# AC: License field matches LICENSE file

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"
LICENSE_FILE="/Users/stevemitchell/Documents/GitHub/fade/LICENSE"

# Extract license from package.json
PKG_LICENSE=$(grep '"license"' "$PACKAGE_JSON" | sed 's/.*: *"\([^"]*\)".*/\1/')

if [[ -z "$PKG_LICENSE" ]]; then
    echo "FAIL: package.json missing 'license' field"
    exit 1
fi

# Check LICENSE file exists
if [[ ! -f "$LICENSE_FILE" ]]; then
    echo "FAIL: LICENSE file does not exist"
    exit 1
fi

# Check if LICENSE file contains the license type mentioned in package.json
if ! head -5 "$LICENSE_FILE" | grep -qi "$PKG_LICENSE"; then
    echo "FAIL: LICENSE file does not match package.json license field"
    echo "Expected: LICENSE file to contain '$PKG_LICENSE'"
    echo "Actual: $(head -1 "$LICENSE_FILE")"
    exit 1
fi

echo "PASS: License field '$PKG_LICENSE' matches LICENSE file"
exit 0
