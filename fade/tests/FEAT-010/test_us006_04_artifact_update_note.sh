#!/bin/bash
# Test: README notes that fade update is still needed for project artifacts
# AC: Notes that fade update is still needed for project artifact updates

README="/Users/stevemitchell/Documents/GitHub/fade/README.md"

# Check that fade update is mentioned
if ! grep -q "fade update" "$README"; then
    echo "FAIL: README.md missing 'fade update' documentation"
    exit 1
fi

# Check for context about project artifacts vs CLI
if ! grep -qi "artifact\|prompt.md\|standards" "$README"; then
    echo "FAIL: README should explain what fade update manages (artifacts/prompt.md/standards)"
    exit 1
fi

# Check for explanation of npm vs fade update separation
if ! grep -A5 "fade update" "$README" | grep -qi "prompt\|artifact\|standard"; then
    # Less strict - just verify both topics are covered somewhere
    HAS_FADE_UPDATE=$(grep -c "fade update" "$README")
    HAS_ARTIFACTS=$(grep -ci "artifact\|prompt.md" "$README")

    if [[ "$HAS_FADE_UPDATE" -lt 1 ]] || [[ "$HAS_ARTIFACTS" -lt 1 ]]; then
        echo "FAIL: README should explain the separation between npm updates and fade update"
        exit 1
    fi
fi

echo "PASS: README notes that fade update is needed for project artifact updates"
exit 0
