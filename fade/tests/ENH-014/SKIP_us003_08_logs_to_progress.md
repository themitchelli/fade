# SKIP: US-003 AC-08 - Log routing decision to progress.md

## Acceptance Criteria
Log routing decision to progress.md: 'Model selection: haiku (complexity=simple, no override)'

## Reason for Skipping
This acceptance criterion requires running a full fade run session which:
1. Requires Claude API access and credentials
2. Takes significant time to execute
3. Has external dependencies (API availability)

The implementation exists in log_model_usage() at bin/fade-cli:846-847 which calls append_model_usage_to_progress().

## Verification
The logging implementation can be verified by code inspection:
- log_model_usage() is called after PRD completion
- append_model_usage_to_progress() writes to progress.md

## Manual Test Steps
1. Create a PRD with complexity="simple"
2. Run `fade run` and complete the PRD
3. Check progress.md for model usage entry
