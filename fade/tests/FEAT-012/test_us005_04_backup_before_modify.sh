#!/bin/bash
# Test: verify .bak backup is created before each fix
# AC: Each fix creates .bak backup before modification

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Verify backup is created before fix
if ! grep -q 'cp "$file" "$file.bak"' "$FADE_CLI"; then
    echo "FAIL: Backup should be created before applying fix"
    echo "Expected: 'cp \"\$file\" \"\$file.bak\"' in fade-cli"
    echo "Actual: not found"
    exit 1
fi

# Verify backup is logged
if ! grep -q 'Backup.*\.bak' "$FADE_CLI"; then
    echo "FAIL: Backup location should be logged"
    echo "Expected: 'Backup' with '.bak' in log output"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: .bak backup is created before each modification"
exit 0
