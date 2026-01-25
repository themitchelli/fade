#!/bin/bash
# Test: discovery asks data-specific questions for data features
# AC: If building data feature: asks about schema, validation, migrations, backwards compat

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for data questions
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function with full content
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for Data/Database section header
if ! echo "$discover_content" | grep -qi "Data.*Feature\|Database"; then
    echo "FAIL: Discovery missing Data/Database question section"
    echo "Expected: section for Data feature questions"
    echo "Actual: 'Data' or 'Database' section not found"
    exit 1
fi

# Check for schema questions
if ! echo "$discover_content" | grep -qi "schema"; then
    echo "FAIL: Discovery missing schema questions for data features"
    echo "Expected: questions about schema design"
    echo "Actual: 'schema' not found"
    exit 1
fi

# Check for data validation questions
if ! echo "$discover_content" | grep -qi "data validation\|validation"; then
    echo "FAIL: Discovery missing validation questions for data features"
    echo "Expected: questions about data validation"
    echo "Actual: 'validation' not found"
    exit 1
fi

# Check for migration questions
if ! echo "$discover_content" | grep -qi "migration"; then
    echo "FAIL: Discovery missing migration questions for data features"
    echo "Expected: questions about migrations"
    echo "Actual: 'migration' not found"
    exit 1
fi

# Check for backwards compatibility questions
if ! echo "$discover_content" | grep -qi "backwards compat"; then
    echo "FAIL: Discovery missing backwards compatibility questions"
    echo "Expected: questions about backwards compatibility"
    echo "Actual: 'backwards compat' not found"
    exit 1
fi

echo "PASS: discovery includes data feature questions (schema, validation, migrations, backwards compat)"
exit 0
