#!/bin/bash
# Test: discovery prompt includes core question categories
# AC: Session asks about: goals, constraints, tech preferences, edge cases

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script content for discovery prompt question categories
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function and check for question categories
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI" | head -500)

# Check for goals questions
if ! echo "$discover_content" | grep -qi "goal"; then
    echo "FAIL: Discovery prompt missing goals questions"
    echo "Expected: prompt includes questions about goals"
    echo "Actual: 'goal' not found in discover prompt"
    exit 1
fi

# Check for constraints questions
if ! echo "$discover_content" | grep -qi "constraint"; then
    echo "FAIL: Discovery prompt missing constraints questions"
    echo "Expected: prompt includes questions about constraints"
    echo "Actual: 'constraint' not found in discover prompt"
    exit 1
fi

# Check for technical preferences/decisions questions
if ! echo "$discover_content" | grep -qi "technical\|tech"; then
    echo "FAIL: Discovery prompt missing technical preferences questions"
    echo "Expected: prompt includes questions about tech preferences"
    echo "Actual: 'technical' or 'tech' not found in discover prompt"
    exit 1
fi

# Check for edge cases questions
if ! echo "$discover_content" | grep -qi "edge case"; then
    echo "FAIL: Discovery prompt missing edge cases questions"
    echo "Expected: prompt includes questions about edge cases"
    echo "Actual: 'edge case' not found in discover prompt"
    exit 1
fi

echo "PASS: discovery prompt includes core question categories (goals, constraints, tech preferences, edge cases)"
exit 0
