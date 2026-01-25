#!/bin/bash
# Test: discovery asks UI-specific questions for UI features
# AC: If building UI component: asks about layout, interactions, states, accessibility

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for UI questions
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function with full content
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for UI Component section header
if ! echo "$discover_content" | grep -qi "UI Component"; then
    echo "FAIL: Discovery missing UI Component question section"
    echo "Expected: section for UI Component questions"
    echo "Actual: 'UI Component' not found"
    exit 1
fi

# Check for layout questions
if ! echo "$discover_content" | grep -qi "layout"; then
    echo "FAIL: Discovery missing layout questions for UI"
    echo "Expected: questions about layout"
    echo "Actual: 'layout' not found"
    exit 1
fi

# Check for interactions questions
if ! echo "$discover_content" | grep -qi "interaction"; then
    echo "FAIL: Discovery missing interaction questions for UI"
    echo "Expected: questions about user interactions"
    echo "Actual: 'interaction' not found"
    exit 1
fi

# Check for states questions
if ! echo "$discover_content" | grep -qi "state"; then
    echo "FAIL: Discovery missing states questions for UI"
    echo "Expected: questions about component states"
    echo "Actual: 'state' not found"
    exit 1
fi

# Check for accessibility questions
if ! echo "$discover_content" | grep -qi "accessibility\|accessible"; then
    echo "FAIL: Discovery missing accessibility questions for UI"
    echo "Expected: questions about accessibility"
    echo "Actual: 'accessibility' or 'accessible' not found"
    exit 1
fi

echo "PASS: discovery includes UI component questions (layout, interactions, states, accessibility)"
exit 0
