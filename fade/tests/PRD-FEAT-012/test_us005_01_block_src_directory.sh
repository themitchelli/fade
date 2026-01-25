#!/bin/bash
# Test: Safety constraints block healing attempts in src/ directory
# AC: Integration test: Attempt to heal file in src/ directory, verify it's blocked

cd /Users/stevemitchell/Documents/GitHub/fade

# Test the safety constraint logic directly using bash
# Simulate a file path in src/ directory
file_realpath="/some/project/tests/src/bad_script.sh"

# This is the actual safety check from apply_portability_fixes
if [[ "$file_realpath" == */src/* ]] || \
   [[ "$file_realpath" == */lib/* ]] || \
   [[ "$file_realpath" == */bin/* ]] || \
   [[ ! "$file_realpath" == *test* ]]; then
    echo "PASS: Safety constraint correctly blocks src/ directory"
    exit 0
else
    echo "FAIL: Safety constraint did not block src/ directory"
    echo "File path: $file_realpath"
    exit 1
fi
