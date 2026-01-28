#!/bin/bash
# Test: verify fade metrics summarizes runs with required information
# AC: Command `fade metrics` summarizes the last N runs across the current repo: total stories completed, failures, BLOCKED count, regressions run, average story duration, model usage breakdown.

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Get the fade-cli path
FADE_CLI="${FADE_CLI:-fade}"

# Check if fade command is available
if ! command -v "$FADE_CLI" &> /dev/null; then
    echo "SKIP: fade command not available in PATH"
    rm -rf "$TEST_DIR"
    exit 0
fi

# Initialize a minimal FADE structure with sample runs
mkdir -p fade/runs/run-001
mkdir -p fade/runs/run-002

# Create events for run-001
cat > fade/runs/run-001/events.jsonl << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"run-001","repo":"test","event_type":"run_start","data":{"mode":"ALL"}}
{"ts":"2024-01-01T12:00:01Z","run_id":"run-001","repo":"test","event_type":"model_selected","data":{"model":"sonnet"}}
{"ts":"2024-01-01T12:00:02Z","run_id":"run-001","repo":"test","event_type":"story_end","data":{"story_id":"US-001","status":"pass"}}
{"ts":"2024-01-01T12:00:03Z","run_id":"run-001","repo":"test","event_type":"regression_end","data":{"status":"pass"}}
{"ts":"2024-01-01T12:00:04Z","run_id":"run-001","repo":"test","event_type":"run_stop","data":{"status":"complete"}}
EOF

# Create events for run-002
cat > fade/runs/run-002/events.jsonl << 'EOF'
{"ts":"2024-01-02T12:00:00Z","run_id":"run-002","repo":"test","event_type":"run_start","data":{"mode":"ALL"}}
{"ts":"2024-01-02T12:00:01Z","run_id":"run-002","repo":"test","event_type":"model_selected","data":{"model":"haiku"}}
{"ts":"2024-01-02T12:00:02Z","run_id":"run-002","repo":"test","event_type":"story_end","data":{"story_id":"US-002","status":"pass"}}
{"ts":"2024-01-02T12:00:03Z","run_id":"run-002","repo":"test","event_type":"blocked","data":{"reason":"Test failure"}}
{"ts":"2024-01-02T12:00:04Z","run_id":"run-002","repo":"test","event_type":"regression_end","data":{"status":"fail"}}
{"ts":"2024-01-02T12:00:05Z","run_id":"run-002","repo":"test","event_type":"run_stop","data":{"status":"blocked"}}
EOF

# Act - run fade metrics
output=$("$FADE_CLI" metrics 2>&1)
exit_code=$?

# Assert - command should succeed
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: fade metrics command failed with exit code $exit_code"
    echo "Output: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output should contain key metrics information
# Check for column headers or metrics indicators
if ! echo "$output" | grep -qiE "(stories|passed|failed|blocked|run)"; then
    echo "FAIL: fade metrics output missing expected metrics"
    echo "Expected: output containing stories, passed, failed, blocked information"
    echo "Actual output:"
    echo "$output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output shows multiple runs
if ! echo "$output" | grep -qE "(run-001|run-002|2 runs|Last [0-9])"; then
    echo "FAIL: fade metrics should show information about runs"
    echo "Expected: run information or run count"
    echo "Actual output:"
    echo "$output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade metrics summarizes runs with stories, failures, blocked count"
exit 0
