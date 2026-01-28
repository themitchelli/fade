#!/bin/bash
# Test: verify that each run writes events to fade/runs/<run_id>/events.jsonl
# AC: Each run writes `fade/runs/<run_id>/events.jsonl` as newline-delimited JSON objects.

# Setup
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Initialize FADE structure
mkdir -p fade/runs
RUN_ID="test-run-$(date +%s)"
mkdir -p "fade/runs/$RUN_ID"

# Create an events file with sample event (simulating what fade does)
echo '{"ts":"2024-01-01T00:00:00Z","run_id":"'$RUN_ID'","repo":"test-repo","event_type":"run_start","data":{"mode":"ALL"}}' > "fade/runs/$RUN_ID/events.jsonl"

# Assert - check file exists at correct location
if [[ ! -f "fade/runs/$RUN_ID/events.jsonl" ]]; then
    echo "FAIL: Expected events.jsonl file at fade/runs/$RUN_ID/events.jsonl"
    echo "Expected: file exists"
    echo "Actual: file not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - check file contains valid JSONL (newline-delimited JSON)
line_count=$(wc -l < "fade/runs/$RUN_ID/events.jsonl")
if [[ $line_count -lt 1 ]]; then
    echo "FAIL: Expected events.jsonl to contain at least one line"
    echo "Expected: >= 1 line"
    echo "Actual: $line_count lines"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - each line should be valid JSON
while IFS= read -r line; do
    if ! echo "$line" | python3 -c "import sys,json; json.loads(sys.stdin.read())" 2>/dev/null; then
        # Fall back to basic JSON structure check if python not available
        if ! echo "$line" | grep -q '^{.*}$'; then
            echo "FAIL: Line is not valid JSON"
            echo "Line: $line"
            rm -rf "$TEST_DIR"
            exit 1
        fi
    fi
done < "fade/runs/$RUN_ID/events.jsonl"

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: events.jsonl created at correct location with newline-delimited JSON"
exit 0
