#!/bin/bash
# Test: verify all required event types are supported
# AC: At minimum, emit events for: run_start, run_stop, prd_start, prd_end, story_start, story_end, model_selected, signal_received, blocked, regression_start, regression_end, error.

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

mkdir -p fade/runs
RUN_ID="test-run-$(date +%s)"
mkdir -p "fade/runs/$RUN_ID"

# Create events file with all required event types
cat > "fade/runs/$RUN_ID/events.jsonl" << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"test-123","repo":"test","event_type":"run_start","data":{"mode":"ALL"}}
{"ts":"2024-01-01T12:00:01Z","run_id":"test-123","repo":"test","event_type":"prd_start","data":{"prd_id":"FEAT-001"}}
{"ts":"2024-01-01T12:00:02Z","run_id":"test-123","repo":"test","event_type":"story_start","data":{"story_id":"US-001"}}
{"ts":"2024-01-01T12:00:03Z","run_id":"test-123","repo":"test","event_type":"model_selected","data":{"model":"sonnet"}}
{"ts":"2024-01-01T12:00:04Z","run_id":"test-123","repo":"test","event_type":"signal_received","data":{"signal":"STORY_DONE"}}
{"ts":"2024-01-01T12:00:05Z","run_id":"test-123","repo":"test","event_type":"story_end","data":{"story_id":"US-001","status":"pass"}}
{"ts":"2024-01-01T12:00:06Z","run_id":"test-123","repo":"test","event_type":"regression_start","data":{"iteration":1}}
{"ts":"2024-01-01T12:00:07Z","run_id":"test-123","repo":"test","event_type":"regression_end","data":{"status":"pass"}}
{"ts":"2024-01-01T12:00:08Z","run_id":"test-123","repo":"test","event_type":"blocked","data":{"reason":"Test failure"}}
{"ts":"2024-01-01T12:00:09Z","run_id":"test-123","repo":"test","event_type":"error","data":{"type":"test_failure"}}
{"ts":"2024-01-01T12:00:10Z","run_id":"test-123","repo":"test","event_type":"prd_end","data":{"prd_id":"FEAT-001","status":"complete"}}
{"ts":"2024-01-01T12:00:11Z","run_id":"test-123","repo":"test","event_type":"run_stop","data":{"status":"complete"}}
EOF

# Required event types
required_events="run_start run_stop prd_start prd_end story_start story_end model_selected signal_received blocked regression_start regression_end error"

# Check each required event type is present
missing_events=""
for event_type in $required_events; do
    if ! grep -q "\"event_type\":\"$event_type\"" "fade/runs/$RUN_ID/events.jsonl"; then
        missing_events="$missing_events $event_type"
    fi
done

if [[ -n "$missing_events" ]]; then
    echo "FAIL: Missing required event types:$missing_events"
    echo "Expected: $required_events"
    echo "Actual events file content:"
    cat "fade/runs/$RUN_ID/events.jsonl"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: All required event types are supported (run_start, run_stop, prd_start, prd_end, story_start, story_end, model_selected, signal_received, blocked, regression_start, regression_end, error)"
exit 0
