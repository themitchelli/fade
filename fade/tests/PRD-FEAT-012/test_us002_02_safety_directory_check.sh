#!/bin/bash
# Test: apply_portability_fixes only processes files from tests directory
# AC: Apply fixes only to files in fade/tests/ directory

# Check that function uses get_tests_dir() to determine which files to process
if ! grep -A 10 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "tests_dir.*get_tests_dir"; then
    echo "FAIL: Function doesn't call get_tests_dir() to determine test directory"
    exit 1
fi

# Check that function only finds files within tests_dir
if ! grep -A 30 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q 'find.*\$tests_dir.*-type f.*\.sh'; then
    echo "FAIL: Function doesn't use find to search only within tests_dir"
    exit 1
fi

# Check that safety validation exists (realpath check)
if ! grep -A 100 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "file_realpath.*tests_dir"; then
    echo "FAIL: Function doesn't validate files are within tests_dir using realpath"
    exit 1
fi

# Check that function skips files outside tests directory
if ! grep -A 100 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "Skipping file outside tests directory"; then
    echo "FAIL: Function doesn't skip files outside tests directory"
    exit 1
fi

echo "PASS: apply_portability_fixes has safety constraints for directory access"
exit 0
