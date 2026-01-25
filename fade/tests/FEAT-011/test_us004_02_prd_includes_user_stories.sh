#!/bin/bash
# Test: PRD includes user stories from discovery
# AC: PRD includes user stories derived from discussed features

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for PRD template with user stories
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Search the entire file for PRD template content within cmd_discover context
# The template spans many lines so we need to search the full file

# Check for userStories in PRD template (near discovery/PRD generation code)
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -q 'userStories'; then
    echo "FAIL: PRD template missing userStories field"
    echo "Expected: PRD template includes 'userStories' array"
    echo "Actual: 'userStories' not found in PRD template"
    exit 1
fi

# Check for user story ID format in the PRD template
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -q '"id":.*"US-\|US-001'; then
    echo "FAIL: PRD template missing story ID format"
    echo "Expected: story IDs like 'US-001'"
    echo "Actual: 'US-' ID format not found"
    exit 1
fi

# Check for reference to Suggested Stories from discovery
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -qi "suggested stories"; then
    echo "FAIL: No guidance to derive stories from discovery"
    echo "Expected: instruction to derive stories from discovery's Suggested Stories"
    echo "Actual: story derivation guidance not found"
    exit 1
fi

echo "PASS: PRD includes user stories derived from discovery"
exit 0
