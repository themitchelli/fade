#!/bin/bash
# Test: verify export_session_status uses atomic write (tmp file + rename)
# AC: JSON is atomic write (tmp file + rename to prevent partial reads)

FADE_CLI="$(cd "$(dirname "$0")/../../.." && pwd)/bin/fade-cli"

# Check that the export_session_status function uses temp file + mv pattern
# Search broader range to capture the full function (function is ~150 lines)
if ! grep -A 150 'export_session_status()' "$FADE_CLI" | grep -q 'local temp_file='; then
    echo "FAIL: export_session_status should create a temp file"
    echo "Expected: local temp_file= variable assignment"
    echo "Actual: not found in export_session_status function"
    exit 1
fi

# Verify atomic rename with mv command
if ! grep -A 150 'export_session_status()' "$FADE_CLI" | grep -q 'mv "$temp_file"'; then
    echo "FAIL: export_session_status should use mv for atomic rename"
    echo "Expected: mv \"\$temp_file\" pattern"
    echo "Actual: not found in export_session_status function"
    exit 1
fi

echo "PASS: export_session_status uses atomic write pattern (temp file + rename)"
exit 0
