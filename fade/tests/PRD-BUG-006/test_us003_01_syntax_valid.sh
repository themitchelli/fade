#!/bin/bash
# Test: Verify no syntax errors in fade-cli
# AC: Syntax error no longer occurs even if output leaks

FADE_CLI="bin/fade-cli"

# Run bash syntax check
if ! bash -n "$FADE_CLI" 2>&1; then
    echo "FAIL: fade-cli has syntax errors"
    exit 1
fi

echo "PASS: fade-cli passes syntax check"
exit 0
