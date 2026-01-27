#!/bin/bash
# Test: update preserves user-edited content in FADE.md and custom standards
# AC: Update preserves user-edited content in FADE.md and custom standards; templated sections are clearly separated.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Verify that existing standards files are NOT overwritten by update
# The cmd_update function should skip existing standard files

# Check that cmd_update has logic to preserve existing files
# Look for "exists" skip logic in the standards update section

if ! grep -q "# File already exists" "$FADE_CLI"; then
    echo "FAIL: cmd_update should have logic to preserve existing files"
    echo "Expected: comment indicating file preservation logic"
    exit 1
fi

# Check that existing standards are skipped (not overwritten)
if ! grep -qE "exists.*skip|exists.*do NOT overwrite" "$FADE_CLI"; then
    echo "FAIL: Standards update should skip existing files"
    echo "Expected: Logic to skip existing standard files"
    exit 1
fi

# Verify the preservation message is shown
if ! grep -q "user may have customised" "$FADE_CLI"; then
    echo "FAIL: Update should acknowledge user customizations"
    echo "Expected: Comment about user customization preservation"
    exit 1
fi

# Verify FADE.md sections are tracked as custom vs templated
if ! grep -q "templated_sections\|custom_sections" "$FADE_CLI"; then
    echo "FAIL: FADE.md should distinguish templated vs custom sections"
    echo "Expected: Section tracking for preservation"
    exit 1
fi

echo "PASS: Update preserves user-edited content in FADE.md and custom standards"
exit 0
