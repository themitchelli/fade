# SKIP: US-003 AC-04 - Add code comments explaining signal format requirements

## Acceptance Criterion
"Add code comments explaining the signal format requirements"

## Why Not Testable
This acceptance criterion is about code documentation/comments, not runtime behavior.
Shell-based regression tests can only verify:
- Runtime behavior
- Output correctness
- Pattern matching results

Code comments are:
- Static documentation
- Subject to human judgment on quality/clarity
- Not affecting program execution

## Manual Verification
Review the code around lines 3939-3944 in bin/fade-cli for the comment block explaining signal patterns.
