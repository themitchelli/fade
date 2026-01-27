#!/bin/bash
# Test: update updates version markers consistently
# AC: Update updates version markers consistently (FADE version, artifact versions).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Verify version marker consistency checking exists
if ! grep -q "validate_update_consistency" "$FADE_CLI"; then
    echo "FAIL: validate_update_consistency function not found"
    echo "Expected: function to validate version marker consistency"
    exit 1
fi

# Check that FADE_VERSION is checked
if ! grep -q 'FADE_VERSION=' "$FADE_CLI"; then
    echo "FAIL: FADE_VERSION constant should be defined"
    echo "Expected: FADE_VERSION= definition"
    exit 1
fi

# Check that ARTIFACT_VERSION is defined
if ! grep -q 'ARTIFACT_VERSION=' "$FADE_CLI"; then
    echo "FAIL: ARTIFACT_VERSION constant should be defined"
    echo "Expected: ARTIFACT_VERSION= definition"
    exit 1
fi

# Check that FADE.md version marker is validated
if ! grep -q 'FADE FADE.md v' "$FADE_CLI"; then
    echo "FAIL: FADE.md version marker format should be checked"
    echo "Expected: FADE FADE.md v format in validation"
    exit 1
fi

# Check that prompt.md version marker is validated
if ! grep -q 'FADE prompt.md v' "$FADE_CLI"; then
    echo "FAIL: prompt.md version marker format should be checked"
    echo "Expected: FADE prompt.md v format in validation"
    exit 1
fi

# Check version transition reporting (before -> after)
if ! grep -qE 'v\$.*→.*v\$|version.*update' "$FADE_CLI"; then
    echo "FAIL: Version transition should be reported"
    echo "Expected: Version before → after reporting"
    exit 1
fi

# Check that version manifest is used for consistency
if ! grep -q 'version-manifest\|manifest_version\|get_manifest_version' "$FADE_CLI"; then
    echo "FAIL: Version manifest should be used for consistency"
    echo "Expected: Reference to version manifest"
    exit 1
fi

echo "PASS: Update updates version markers consistently"
exit 0
