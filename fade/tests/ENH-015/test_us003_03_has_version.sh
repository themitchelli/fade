#!/bin/bash
# Test: verify model-selection-history.json has version field
# AC: version: "1.0"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
HISTORY_FILE="$SCRIPT_DIR/fade/model-selection-history.json"

# Act
version=$(python3 -c "import json; print(json.load(open('$HISTORY_FILE'))['version'])" 2>/dev/null)

# Assert: version is "1.0"
if [[ "$version" != "1.0" ]]; then
    echo "FAIL: Expected version = '1.0'"
    echo "Expected: 1.0"
    echo "Actual: $version"
    exit 1
fi

echo "PASS: model-selection-history.json has version 1.0"
exit 0
