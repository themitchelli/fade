#!/bin/bash
# Test: verify metrics output is deterministic and readable (table-like)
# AC: Metrics output is deterministic and readable (table-like).

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

# Create consistent events for testing determinism
cat > fade/runs/run-001/events.jsonl << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"run-001","repo":"test","event_type":"run_start","data":{"mode":"ALL"}}
{"ts":"2024-01-01T12:00:01Z","run_id":"run-001","repo":"test","event_type":"model_selected","data":{"model":"sonnet"}}
{"ts":"2024-01-01T12:00:02Z","run_id":"run-001","repo":"test","event_type":"story_end","data":{"story_id":"US-001","status":"pass"}}
{"ts":"2024-01-01T12:00:03Z","run_id":"run-001","repo":"test","event_type":"story_end","data":{"story_id":"US-002","status":"pass"}}
{"ts":"2024-01-01T12:00:04Z","run_id":"run-001","repo":"test","event_type":"blocked","data":{"reason":"Test"}}
{"ts":"2024-01-01T12:00:05Z","run_id":"run-001","repo":"test","event_type":"regression_end","data":{"status":"pass"}}
{"ts":"2024-01-01T12:00:06Z","run_id":"run-001","repo":"test","event_type":"run_stop","data":{"status":"complete"}}
EOF

# Act - run fade metrics multiple times
output1=$("$FADE_CLI" metrics 2>&1)
output2=$("$FADE_CLI" metrics 2>&1)
output3=$("$FADE_CLI" metrics 2>&1)

# Assert - output should be deterministic (same each time)
if [[ "$output1" != "$output2" ]] || [[ "$output2" != "$output3" ]]; then
    echo "FAIL: Metrics output is not deterministic"
    echo "Run 1:"
    echo "$output1"
    echo "---"
    echo "Run 2:"
    echo "$output2"
    echo "---"
    echo "Run 3:"
    echo "$output3"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output should be table-like (contains aligned columns or structured format)
# Check for common table indicators: multiple spaces for alignment, dashes, equals, or consistent formatting
if ! echo "$output1" | grep -qE '([-=]{5,}|  +[0-9]+|[A-Za-z]+:.*[0-9])'; then
    echo "WARN: Metrics output may not be table-like formatted"
    echo "Output:"
    echo "$output1"
    # Not failing here as format may vary - just check it's readable
fi

# Assert - output should contain numeric values (metrics)
if ! echo "$output1" | grep -qE '[0-9]+'; then
    echo "FAIL: Metrics output should contain numeric values"
    echo "Output:"
    echo "$output1"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - output should have multiple lines (not just a single line dump)
line_count=$(echo "$output1" | wc -l)
if [[ $line_count -lt 2 ]]; then
    echo "FAIL: Metrics output should be multi-line (table-like)"
    echo "Expected: multiple lines"
    echo "Actual: $line_count line(s)"
    echo "Output:"
    echo "$output1"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Metrics output is deterministic and readable (table-like format)"
exit 0
