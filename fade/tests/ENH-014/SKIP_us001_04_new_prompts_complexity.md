# SKIP: US-001 AC-04 - fade new without flag prompts

## Acceptance Criteria
fade new without flag prompts: 'Complexity? [simple/Medium/complex]'

## Reason for Skipping
This acceptance criterion requires interactive user input via stdin (the prompt requires user to type a response). Shell-based automated tests cannot provide interactive input in a way that reliably tests the prompting behavior.

The implementation exists in cmd_new() at bin/fade-cli:4908 which displays the prompt and reads user input via `read -p`.

## Manual Test Steps
1. Run `fade new feature "Test Feature"` (without --complexity flag)
2. Verify prompt displays: "Complexity? [simple/Medium/complex]"
3. Verify entering "simple", "medium", or "complex" (or pressing Enter) works
