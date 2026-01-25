#!/bin/bash
# Test: discoveryDoc is optional - PRDs work without it
# AC: Optional field - PRDs work fine without discovery docs

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for optional handling
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Check that get_prd_discovery_doc handles missing field gracefully
discovery_func=$(sed -n '/^get_prd_discovery_doc()/,/^}/p' "$FADE_CLI")
if [[ -z "$discovery_func" ]]; then
    echo "FAIL: get_prd_discovery_doc function not found"
    exit 1
fi

# Function should return empty string if field doesn't exist (default behavior)
# Check that it uses safe grep/parsing that won't fail on missing field
if ! echo "$discovery_func" | grep -q '2>/dev/null\||| true\||| echo\|""\|head -1'; then
    echo "FAIL: get_prd_discovery_doc may not handle missing field gracefully"
    echo "Expected: safe parsing that handles missing field"
    echo "Actual: no error suppression found"
    exit 1
fi

# Check that discovery doc inclusion in run is conditional
full_file=$(cat "$FADE_CLI")
# Should check if discovery_doc is non-empty and file exists before including
if ! echo "$full_file" | grep -q '\-n.*discovery_doc\|discovery_doc.*\-n\|if.*discovery_doc'; then
    echo "FAIL: Discovery doc inclusion not conditional"
    echo "Expected: check if discovery_doc is non-empty before including"
    echo "Actual: conditional check not found"
    exit 1
fi

# Check that file existence is verified before reading
if ! echo "$full_file" | grep -q '\-f.*discovery_doc\|discovery_doc.*\-f'; then
    echo "FAIL: Discovery doc file existence not verified"
    echo "Expected: check if discovery doc file exists"
    echo "Actual: file existence check not found"
    exit 1
fi

echo "PASS: discoveryDoc is optional - PRDs work without it"
exit 0
