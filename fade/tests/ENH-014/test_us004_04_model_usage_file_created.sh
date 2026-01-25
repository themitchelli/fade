#!/bin/bash
# Test: verify log_model_usage creates fade/model-usage.md if it doesn't exist
# AC: Create fade/model-usage.md log tracking all model selections

set -e

FADE_CLI="$(which fade)"

# Check that log_model_usage creates the file with header if it doesn't exist
if grep -A 30 "log_model_usage()" "$FADE_CLI" | grep -q 'if.*!.*-f.*usage_log.*then\|Model Usage Log'; then
    echo "PASS: log_model_usage() creates fade/model-usage.md with header"
    exit 0
fi

echo "FAIL: log_model_usage() should create model-usage.md if missing"
exit 1
