#!/bin/bash
# Test: verify get_archive_list function exists in fade-cli
# AC: Per-repo expanded view shows: Archive list (completed PRDs) with completion dates

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found"
    exit 1
fi

# Check for get_archive_list function
if ! grep -q 'get_archive_list()' "$FADE_CLI"; then
    echo "FAIL: fade-cli should have get_archive_list function"
    echo "Expected: get_archive_list() function"
    exit 1
fi

echo "PASS: get_archive_list function exists"
exit 0
