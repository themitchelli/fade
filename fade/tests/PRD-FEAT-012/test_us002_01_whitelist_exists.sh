#!/bin/bash
# Test: apply_portability_fixes function exists in fade-cli
# AC: Maintain whitelist of known-safe fix patterns in code

# Check that the function exists in the code
if ! grep -q "^apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli; then
    echo "FAIL: apply_portability_fixes function not found in fade-cli"
    exit 1
fi

# Check that head fix pattern is documented in the function
if ! grep -q "head -n -1.*sed" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli; then
    echo "FAIL: head -n -1 fix pattern not found"
    exit 1
fi

# Check that sed -i fix pattern is documented in the function
if ! grep -q "sed -i.*sed -i.bak" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli; then
    echo "FAIL: sed -i fix pattern not found"
    exit 1
fi

# Check that the function handles error types via case statement
if ! grep -A 50 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "case.*error_type.*in"; then
    echo "FAIL: Error type handling not found in function"
    exit 1
fi

# Check for head_illegal_line_count case
if ! grep -A 80 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "head_illegal_line_count)"; then
    echo "FAIL: head_illegal_line_count case not found"
    exit 1
fi

# Check for sed_i_needs_argument case
if ! grep -A 80 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "sed_i_needs_argument)"; then
    echo "FAIL: sed_i_needs_argument case not found"
    exit 1
fi

echo "PASS: apply_portability_fixes whitelist patterns exist in code"
exit 0
