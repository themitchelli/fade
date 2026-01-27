# SKIP: US-003 AC-05 - Update EXIT SIGNALS comment block

## Acceptance Criterion
"Update the EXIT SIGNALS comment block (around line 3017-3047) to document the strict patterns used"

## Why Not Testable
This acceptance criterion is about updating documentation comments in source code.
Shell-based regression tests cannot verify:
- Comment content or quality
- Documentation accuracy
- Whether comments match implementation

## Manual Verification
Review the EXIT SIGNALS comment block in bin/fade-cli to verify it documents:
- ALL_COMPLETE: exact line match with grep -qx
- STORY_DONE: '^STORY_DONE: ' pattern at start of line
- BLOCKED: '^BLOCKED: ' pattern at start of line
