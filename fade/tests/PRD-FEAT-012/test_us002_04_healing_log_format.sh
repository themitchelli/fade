#!/bin/bash
# Test: apply_portability_fixes logs each fix application
# AC: Log each fix application to healing-log.md with timestamp, file, pattern, replacement

# Check that healing-log.md location is determined based on fade/ directory existence
if ! grep -A 10 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "healing_log"; then
    echo "FAIL: healing_log variable not found"
    exit 1
fi

if ! grep -A 15 "apply_portability_fixes()" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q 'healing_log="fade/healing-log.md"'; then
    echo "FAIL: healing_log not set to fade/healing-log.md for contained structure"
    exit 1
fi

# Check that log entries include timestamp
if ! grep -A 60 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "## \$timestamp"; then
    echo "FAIL: Log entries don't include timestamp"
    exit 1
fi

# Check that log entries include error type
if ! grep -A 60 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "Error Type:.*head_illegal_line_count"; then
    echo "FAIL: Log entries don't include error type"
    exit 1
fi

# Check that log entries include file path
if ! grep -A 60 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "File:.*\$file"; then
    echo "FAIL: Log entries don't include file path"
    exit 1
fi

# Check that log entries include pattern transformation
if ! grep -A 60 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "Pattern:"; then
    echo "FAIL: Log entries don't include pattern transformation"
    exit 1
fi

# Check that log entries include backup location
if ! grep -A 60 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q "Backup:.*\.bak"; then
    echo "FAIL: Log entries don't include backup location"
    exit 1
fi

# Check that log is appended to (>>)
if ! grep -A 60 "head_illegal_line_count)" /Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli | grep -q ">> \"\$healing_log\""; then
    echo "FAIL: Log is not appended to (should use >>)"
    exit 1
fi

echo "PASS: apply_portability_fixes creates correct healing log format"
exit 0
