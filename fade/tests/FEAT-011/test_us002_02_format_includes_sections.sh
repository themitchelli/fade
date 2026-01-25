#!/bin/bash
# Test: discovery format includes required sections
# AC: Format includes: Summary, Decisions, Open Questions, Suggested Stories

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for format sections
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function with full template content
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for Summary section in template
if ! echo "$discover_content" | grep -q '## Summary'; then
    echo "FAIL: Discovery format missing Summary section"
    echo "Expected: template includes '## Summary'"
    echo "Actual: '## Summary' not found in discover template"
    exit 1
fi

# Check for Decisions section in template
if ! echo "$discover_content" | grep -q '## Decisions'; then
    echo "FAIL: Discovery format missing Decisions section"
    echo "Expected: template includes '## Decisions'"
    echo "Actual: '## Decisions' not found in discover template"
    exit 1
fi

# Check for Open Questions section in template
if ! echo "$discover_content" | grep -q '## Open Questions'; then
    echo "FAIL: Discovery format missing Open Questions section"
    echo "Expected: template includes '## Open Questions'"
    echo "Actual: '## Open Questions' not found in discover template"
    exit 1
fi

# Check for Suggested Stories section in template
if ! echo "$discover_content" | grep -q '## Suggested Stories'; then
    echo "FAIL: Discovery format missing Suggested Stories section"
    echo "Expected: template includes '## Suggested Stories'"
    echo "Actual: '## Suggested Stories' not found in discover template"
    exit 1
fi

echo "PASS: discovery format includes Summary, Decisions, Open Questions, Suggested Stories"
exit 0
