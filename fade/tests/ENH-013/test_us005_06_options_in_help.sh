#!/bin/bash
# Test: Options documented in fade map --help
# AC: Options documented in fade map --help

# Act - run fade map --help
help_output=$(fade map --help 2>&1)

# Assert - check all diagram options are documented
if ! echo "$help_output" | grep -q "\-\-diagram"; then
    echo "FAIL: --diagram option not documented in help"
    echo "Expected: --diagram in help output"
    echo "Actual: $help_output"
    exit 1
fi

if ! echo "$help_output" | grep -q "\-\-diagram-output"; then
    echo "FAIL: --diagram-output option not documented in help"
    echo "Expected: --diagram-output in help output"
    exit 1
fi

if ! echo "$help_output" | grep -q "\-\-diagram-title"; then
    echo "FAIL: --diagram-title option not documented in help"
    echo "Expected: --diagram-title in help output"
    exit 1
fi

# Check for level documentation (context, container, component)
if ! echo "$help_output" | grep -qi "context\|container\|component"; then
    echo "FAIL: Diagram levels (context/container/component) not documented"
    echo "Expected: Level options in help"
    exit 1
fi

echo "PASS: Options documented in fade map --help"
exit 0
