#!/bin/bash
# Test: verify council_suggested event is emitted to telemetry
# AC: Suggestion is non-blocking and recorded in telemetry as `council_suggested`.

# This test verifies the telemetry emission code exists and the event structure
# by checking the fade-cli source code

# Setup
FADE_CLI="${FADE_CLI:-$(which fade)}"
if [[ -z "$FADE_CLI" ]]; then
    # Try common installation paths
    for path in "/usr/local/bin/fade" "$HOME/.local/bin/fade" "$(dirname "$0")/../../../bin/fade-cli"; do
        if [[ -x "$path" ]]; then
            FADE_CLI="$path"
            break
        fi
    done
fi

if [[ -z "$FADE_CLI" ]] || [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: Could not locate fade-cli script"
    echo "Expected: fade-cli at standard location or FADE_CLI env var"
    echo "Actual: not found"
    exit 1
fi

# Resolve symlinks to get actual script
FADE_CLI_RESOLVED=$(readlink -f "$FADE_CLI" 2>/dev/null || realpath "$FADE_CLI" 2>/dev/null || echo "$FADE_CLI")

# Act - verify emit_event is called with council_suggested
if ! grep -q 'emit_event.*council_suggested' "$FADE_CLI_RESOLVED"; then
    echo "FAIL: council_suggested event not emitted"
    echo "Expected: emit_event called with 'council_suggested' event type"
    echo "Actual: event emission not found in fade-cli"
    exit 1
fi

# Assert - event includes prd_id in data
if ! grep -q 'council_suggested.*prd_id' "$FADE_CLI_RESOLVED"; then
    echo "FAIL: council_suggested event missing prd_id"
    echo "Expected: event data includes prd_id"
    echo "Actual: prd_id not found in event data"
    exit 1
fi

# Assert - event includes reason in data
if ! grep -q 'council_suggested.*reason' "$FADE_CLI_RESOLVED"; then
    echo "FAIL: council_suggested event missing reason"
    echo "Expected: event data includes reason"
    echo "Actual: reason not found in event data"
    exit 1
fi

# Additional validation: check an actual events.jsonl file if it exists
# This verifies the format in a real run
TEST_EVENTS_DIR=$(dirname "$0")/../../../fade/runs
if [[ -d "$TEST_EVENTS_DIR" ]]; then
    # Find any events.jsonl with council_suggested
    EVENTS_FILE=$(find "$TEST_EVENTS_DIR" -name "events.jsonl" -exec grep -l "council_suggested" {} \; 2>/dev/null | head -1)

    if [[ -n "$EVENTS_FILE" ]]; then
        # Verify the event structure in actual telemetry
        EVENT_LINE=$(grep "council_suggested" "$EVENTS_FILE" | head -1)

        if ! echo "$EVENT_LINE" | grep -q '"event_type":"council_suggested"'; then
            echo "FAIL: Actual telemetry event has wrong event_type format"
            echo "Expected: event_type is 'council_suggested'"
            echo "Actual: $EVENT_LINE"
            exit 1
        fi

        if ! echo "$EVENT_LINE" | grep -q '"prd_id"'; then
            echo "FAIL: Actual telemetry event missing prd_id field"
            echo "Expected: data contains prd_id"
            echo "Actual: $EVENT_LINE"
            exit 1
        fi
    fi
fi

echo "PASS: council_suggested telemetry event properly implemented with prd_id and reason"
exit 0
