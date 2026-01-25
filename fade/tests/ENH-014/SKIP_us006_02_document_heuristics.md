# SKIP: US-006 AC-02 - Document heuristics

## Acceptance Criteria
Document heuristics: what makes a PRD simple vs complex

## Reason for Skipping
This is a documentation requirement that describes content quality rather than presence. Automated tests cannot meaningfully verify that documentation is clear, complete, or accurate.

## Manual Verification
1. Review README.md and/or architecture.md
2. Verify heuristics are documented (AC count thresholds, keywords, effort estimates, dependencies)
3. Verify the documentation matches the actual implementation in analyze_complexity()
