#!/bin/bash
# Test: Verify .bak backup files are created before modification
# AC: Each fix creates .bak backup before modification

# This test verifies the backup creation logic is present in the code
# (Actual backup creation is tested by existing US-002 tests)

cd /Users/stevemitchell/Documents/GitHub/fade

# Check that backup creation exists in head_illegal_line_count case
if grep -A 35 "head_illegal_line_count)" bin/fade-cli | grep -q 'cp "$file" "$file.bak"'; then
    echo "PASS: Backup creation found in head_illegal_line_count case"
else
    echo "FAIL: Missing backup creation in head_illegal_line_count case"
    exit 1
fi

# Check that backup creation exists in sed_i_needs_argument case
if grep -A 35 "sed_i_needs_argument)" bin/fade-cli | grep -q 'cp "$file" "$file.bak"'; then
    echo "PASS: Backup creation found in sed_i_needs_argument case"
    exit 0
else
    echo "FAIL: Missing backup creation in sed_i_needs_argument case"
    exit 1
fi
