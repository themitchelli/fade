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

# Check that safety validation exists (realpath check with pwd -P for canonical path)
if ! grep -A 120 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "file_realpath.*tests_realpath"; then
    echo "FAIL: Function doesn't validate files are within tests_dir using realpath"
    exit 1
fi

# Check that function blocks files outside tests directory with SAFETY ERROR
if ! grep -A 120 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "SAFETY ERROR.*Blocked healing"; then
    echo "FAIL: Function doesn't block files outside tests directory with SAFETY ERROR"
    exit 1
fi

echo "PASS: apply_portability_fixes has safety constraints for directory access"
exit 0
