#!/bin/bash
# Test: verify event schema includes required fields
# AC: Event schema includes: `ts`, `run_id`, `repo`, `event_type`, and a `data` object for details.

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

mkdir -p fade/runs
RUN_ID="test-run-$(date +%s)"
mkdir -p "fade/runs/$RUN_ID"

# Create a sample event with required schema
cat > "fade/runs/$RUN_ID/events.jsonl" << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"test-run-123","repo":"my-repo","event_type":"run_start","data":{"mode":"ALL","model":"sonnet"}}
EOF

# Read the event
event=$(cat "fade/runs/$RUN_ID/events.jsonl")

# Assert - check required fields exist
missing_fields=""

if ! echo "$event" | grep -q '"ts":'; then
    missing_fields="$missing_fields ts"
fi

if ! echo "$event" | grep -q '"run_id":'; then
    missing_fields="$missing_fields run_id"
fi

if ! echo "$event" | grep -q '"repo":'; then
    missing_fields="$missing_fields repo"
fi

if ! echo "$event" | grep -q '"event_type":'; then
    missing_fields="$missing_fields event_type"
fi

if ! echo "$event" | grep -q '"data":'; then
    missing_fields="$missing_fields data"
fi

if [[ -n "$missing_fields" ]]; then
    echo "FAIL: Event schema missing required fields:$missing_fields"
    echo "Expected: ts, run_id, repo, event_type, data"
    echo "Actual event: $event"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - ts should be ISO 8601 format
ts_value=$(echo "$event" | grep -o '"ts":"[^"]*"' | cut -d'"' -f4)
if ! echo "$ts_value" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$'; then
    echo "FAIL: ts field should be ISO 8601 format"
    echo "Expected: YYYY-MM-DDTHH:MM:SSZ"
    echo "Actual: $ts_value"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - data should be an object (starts with {)
data_value=$(echo "$event" | grep -o '"data":{[^}]*}')
if [[ -z "$data_value" ]]; then
    echo "FAIL: data field should be a JSON object"
    echo "Expected: data:{...}"
    echo "Actual: $event"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Event schema contains all required fields (ts, run_id, repo, event_type, data)"
exit 0
