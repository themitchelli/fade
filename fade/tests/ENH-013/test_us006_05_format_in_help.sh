#!/bin/bash
# Test: Format documented in fade map --help
# AC: Format documented in fade map --help

# Act - run fade map --help
help_output=$(fade map --help 2>&1)

# Assert - check diagram-format option is documented
if ! echo "$help_output" | grep -q "\-\-diagram-format"; then
    echo "FAIL: --diagram-format option not documented in help"
    echo "Expected: --diagram-format in help output"
    echo "Actual: $help_output"
    exit 1
fi

# Check for mermaid format mention
if ! echo "$help_output" | grep -qi "mermaid"; then
    echo "FAIL: 'mermaid' format not documented in help"
    echo "Expected: mermaid format option documented"
    exit 1
fi

# Check for html format mention
if ! echo "$help_output" | grep -qi "html"; then
    echo "FAIL: 'html' format not documented in help"
    echo "Expected: html format option documented"
    exit 1
fi

echo "PASS: Format documented in fade map --help"
exit 0
