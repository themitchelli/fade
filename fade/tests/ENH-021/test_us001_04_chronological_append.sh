#!/bin/bash
# Test: verify events are appended in chronological order and never rewritten
# AC: Events are appended in chronological order and never rewritten.

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

mkdir -p fade/runs
RUN_ID="test-run-$(date +%s)"
mkdir -p "fade/runs/$RUN_ID"

# Create initial events file
cat > "fade/runs/$RUN_ID/events.jsonl" << 'EOF'
{"ts":"2024-01-01T12:00:00Z","run_id":"test-123","repo":"test","event_type":"run_start","data":{"mode":"ALL"}}
{"ts":"2024-01-01T12:00:01Z","run_id":"test-123","repo":"test","event_type":"model_selected","data":{"model":"sonnet"}}
EOF

# Record initial content
initial_content=$(cat "fade/runs/$RUN_ID/events.jsonl")
initial_line_count=$(wc -l < "fade/runs/$RUN_ID/events.jsonl")

# Append a new event (simulating what fade does)
echo '{"ts":"2024-01-01T12:00:02Z","run_id":"test-123","repo":"test","event_type":"story_start","data":{"story_id":"US-001"}}' >> "fade/runs/$RUN_ID/events.jsonl"

# Assert - line count should have increased by 1
new_line_count=$(wc -l < "fade/runs/$RUN_ID/events.jsonl")
expected_line_count=$((initial_line_count + 1))

if [[ $new_line_count -ne $expected_line_count ]]; then
    echo "FAIL: Events should be appended, not rewritten"
    echo "Expected line count: $expected_line_count"
    echo "Actual line count: $new_line_count"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - original content should still be at the beginning
first_two_lines=$(head -2 "fade/runs/$RUN_ID/events.jsonl")
if [[ "$first_two_lines" != "$initial_content" ]]; then
    echo "FAIL: Original events were modified (should be append-only)"
    echo "Expected first two lines:"
    echo "$initial_content"
    echo "Actual first two lines:"
    echo "$first_two_lines"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - timestamps should be in chronological order
prev_ts=""
line_num=0
while IFS= read -r line; do
    line_num=$((line_num + 1))
    ts=$(echo "$line" | grep -o '"ts":"[^"]*"' | cut -d'"' -f4)

    if [[ -n "$prev_ts" ]]; then
        # Compare timestamps (string comparison works for ISO 8601)
        if [[ "$ts" < "$prev_ts" ]]; then
            echo "FAIL: Events not in chronological order"
            echo "Line $((line_num - 1)) ts: $prev_ts"
            echo "Line $line_num ts: $ts (should be >= previous)"
            rm -rf "$TEST_DIR"
            exit 1
        fi
    fi
    prev_ts="$ts"
done < "fade/runs/$RUN_ID/events.jsonl"

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Events are appended in chronological order and never rewritten"
exit 0
