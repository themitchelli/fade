#!/bin/bash
# Test: apply_portability_fixes creates backup before modifying files
# AC: Create backup of original file before applying fix

# Check that backup is created before applying head fix
if ! grep -A 40 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q 'cp "$file" "$file.bak"'; then
    echo "FAIL: Backup not created before applying head fix"
    exit 1
fi

# Check that backup is created before applying sed fix
if ! grep -A 40 "sed_i_needs_argument)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q 'cp "$file" "$file.bak"'; then
    echo "FAIL: Backup not created before applying sed fix"
    exit 1
fi

# Check that backup filename is logged
if ! grep -A 120 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "Backup:.*\.bak"; then
    echo "FAIL: Backup filename not logged in healing-log.md"
    exit 1
fi

echo "PASS: apply_portability_fixes creates backups before modifying files"
exit 0
