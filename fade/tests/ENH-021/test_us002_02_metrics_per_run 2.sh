#!/bin/bash
# Test: verify fade metrics --run <run_id> shows per-run metrics
# AC: Command `fade metrics --run <run_id>` prints per-run metrics including per-story durations and outcomes.

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

# Initialize a minimal FADE structure with a sample run
RUN_ID="test-run-123"
mkdir -p "fade/runs/$RUN_ID"

# Create events for the run with multiple stories
cat > "fade/runs/$RUN_ID/events.jsonl" << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"test-run-123","repo":"test","event_type":"run_start","data":{"mode":"ALL"}}
{"ts":"2024-01-01T12:00:01Z","run_id":"test-run-123","repo":"test","event_type":"model_selected","data":{"model":"sonnet"}}
{"ts":"2024-01-01T12:00:02Z","run_id":"test-run-123","repo":"test","event_type":"story_start","data":{"story_id":"US-001"}}
{"ts":"2024-01-01T12:00:10Z","run_id":"test-run-123","repo":"test","event_type":"story_end","data":{"story_id":"US-001","status":"pass"}}
{"ts":"2024-01-01T12:00:11Z","run_id":"test-run-123","repo":"test","event_type":"story_start","data":{"story_id":"US-002"}}
{"ts":"2024-01-01T12:00:20Z","run_id":"test-run-123","repo":"test","event_type":"story_end","data":{"story_id":"US-002","status":"pass"}}
{"ts":"2024-01-01T12:00:21Z","run_id":"test-run-123","repo":"test","event_type":"regression_end","data":{"status":"pass"}}
{"ts":"2024-01-01T12:00:22Z","run_id":"test-run-123","repo":"test","event_type":"run_stop","data":{"status":"complete"}}
EOF

# Act - run fade metrics --run <run_id>
output=$("$FADE_CLI" metrics --run "$RUN_ID" 2>&1)
exit_code=$?

# Assert - command should succeed
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: fade metrics --run command failed with exit code $exit_code"
    echo "Output: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output should reference the specific run
if ! echo "$output" | grep -q "$RUN_ID"; then
    echo "FAIL: fade metrics --run output should reference the run ID"
    echo "Expected: output containing $RUN_ID"
    echo "Actual output:"
    echo "$output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output should show story outcomes (passed/failed counts)
if ! echo "$output" | grep -qiE "(pass|stories|total)"; then
    echo "FAIL: fade metrics --run output should show story outcomes"
    echo "Expected: output containing passed/stories information"
    echo "Actual output:"
    echo "$output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - handle non-existent run ID gracefully
nonexistent_output=$("$FADE_CLI" metrics --run "nonexistent-run-xyz" 2>&1)
nonexistent_exit=$?

if [[ $nonexistent_exit -eq 0 ]] && echo "$nonexistent_output" | grep -qv "not found\|No.*found\|error"; then
    # Should either return non-zero or indicate run not found
    echo "WARN: fade metrics --run should handle non-existent run gracefully"
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: fade metrics --run shows per-run metrics with story outcomes"
exit 0
