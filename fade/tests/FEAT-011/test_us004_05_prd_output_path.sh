#!/bin/bash
# Test: PRD output path follows convention
# AC: Output path: fade/prds/FEAT-NNN-{slug}.json

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for PRD path generation
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI" | head -200)

# Check for fade/prds path
if ! echo "$discover_content" | grep -q 'fade/prds\|prds_dir'; then
    echo "FAIL: PRD output doesn't use fade/prds folder"
    echo "Expected: PRD saved to fade/prds/"
    echo "Actual: fade/prds path not found"
    exit 1
fi

# Check for FEAT- prefix in filename
if ! echo "$discover_content" | grep -q 'FEAT-'; then
    echo "FAIL: PRD filename doesn't use FEAT- prefix"
    echo "Expected: filename starts with FEAT-"
    echo "Actual: FEAT- prefix not found"
    exit 1
fi

# Check for numbered ID in filename (e.g., FEAT-001, FEAT-012)
if ! echo "$discover_content" | grep -q 'FEAT-.*[0-9]'; then
    echo "FAIL: PRD filename doesn't include number"
    echo "Expected: FEAT-NNN format"
    echo "Actual: numbered format not found"
    exit 1
fi

# Check for .json extension
if ! echo "$discover_content" | grep -q 'prd_path.*\.json\|\.json.*prd'; then
    echo "FAIL: PRD filename doesn't use .json extension"
    echo "Expected: .json file extension"
    echo "Actual: .json extension not found in prd_path"
    exit 1
fi

# Check that slug is used in filename
if ! echo "$discover_content" | grep -q 'FEAT.*slug\|${slug}.*\.json'; then
    echo "FAIL: PRD filename doesn't include slug"
    echo "Expected: slug in filename"
    echo "Actual: slug not used in PRD path"
    exit 1
fi

echo "PASS: PRD output path follows fade/prds/FEAT-NNN-{slug}.json convention"
exit 0
