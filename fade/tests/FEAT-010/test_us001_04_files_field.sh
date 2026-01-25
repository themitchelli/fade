#!/bin/bash
# Test: files field includes necessary files
# AC: files field includes only necessary files (bin/, prompts, templates)

PACKAGE_JSON="/Users/stevemitchell/Documents/GitHub/fade/package.json"

# Check that files field exists
if ! grep -q '"files"' "$PACKAGE_JSON"; then
    echo "FAIL: package.json missing 'files' field"
    exit 1
fi

# Check that bin/ is included
if ! grep -A10 '"files"' "$PACKAGE_JSON" | grep -q '"bin/"'; then
    echo "FAIL: files field should include 'bin/'"
    exit 1
fi

# Check that prompt.md is included (directly or via pattern)
if ! grep -A10 '"files"' "$PACKAGE_JSON" | grep -qE '"fade/prompt\.md"|"fade/"'; then
    echo "FAIL: files field should include prompt.md or fade/ directory"
    exit 1
fi

# Check that we're not including everything (no "." or wildcard for entire repo)
if grep -A10 '"files"' "$PACKAGE_JSON" | grep -qE '"\."$|"\*"$'; then
    echo "FAIL: files field should not include entire repository"
    exit 1
fi

echo "PASS: files field includes necessary files (bin/, prompts)"
exit 0
