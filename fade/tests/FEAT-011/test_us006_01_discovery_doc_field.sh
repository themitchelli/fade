#!/bin/bash
# Test: PRD JSON can include discoveryDoc field
# AC: PRD JSON can include 'discoveryDoc' field pointing to discoveries/*.md

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for discoveryDoc field handling
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Check for get_prd_discovery_doc function
if ! grep -q 'get_prd_discovery_doc' "$FADE_CLI"; then
    echo "FAIL: get_prd_discovery_doc function not found"
    echo "Expected: function to extract discoveryDoc from PRD"
    echo "Actual: function not found"
    exit 1
fi

# Check that function parses discoveryDoc field
discovery_func=$(sed -n '/^get_prd_discovery_doc()/,/^}/p' "$FADE_CLI")
if ! echo "$discovery_func" | grep -q 'discoveryDoc'; then
    echo "FAIL: get_prd_discovery_doc doesn't look for discoveryDoc field"
    echo "Expected: parsing of 'discoveryDoc' field"
    echo "Actual: discoveryDoc not referenced in function"
    exit 1
fi

# Check that discover command includes discoveryDoc in generated PRD template
# Search in the PRD Generation section
if ! grep -A 200 'PRD Generation.*--prd mode' "$FADE_CLI" | grep -q 'discoveryDoc'; then
    echo "FAIL: Generated PRD doesn't include discoveryDoc field"
    echo "Expected: discoveryDoc field in PRD template"
    echo "Actual: discoveryDoc not in PRD template"
    exit 1
fi

echo "PASS: PRD JSON can include discoveryDoc field"
exit 0
