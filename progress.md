# Progress Log

Session history for this project. Append-only.

<!--
Entry format (append new entries below the line):

## YYYY-MM-DD HH:MM - US-XXX: Story Title - COMPLETE

- Summary of what was implemented
- Files changed: list key files
- Tests: passed/added

For blocked stories, use:

## YYYY-MM-DD HH:MM - US-XXX: Story Title - BLOCKED

- What was attempted
- What's blocking progress
- Suggested resolution
-->

---

## 2026-01-20 - US-001: Align exit signals between fade script and prompt.md template - COMPLETE

- Added canonical "Exit Signals (Canonical Reference)" section to prompt.md defining STORY_DONE, ALL_COMPLETE, and BLOCKED
- Updated embedded PROMPT_TEMPLATE in fade script to include the same canonical reference
- Both files now have identical signal documentation ensuring consistency
- Files changed: prompt.md, fade
- Tests: Manual verification that signal names match between prompt.md and fade script detection logic

## 2026-01-20 - US-002: Add signal reference comment in fade script - COMPLETE

- Added EXIT SIGNALS comment block in fade script (before COMMANDS section)
- Comment lists all valid signals: STORY_DONE, ALL_COMPLETE, BLOCKED with their formats and meanings
- Comment references prompt.md as the source of truth for Claude's behavior
- Comment notes that detection uses simple grep string matching
- Files changed: fade
- Tests: Manual verification that comment accurately describes signal behavior

## 2026-01-20 - US-001: Display progress update after each iteration (ENH-008) - COMPLETE

- Added display_iteration_summary() function to show rich feedback after each STORY_DONE
- Summary displays: USER STORY PASSED with story ID and title
- Shows list of acceptance criteria accomplished for the story
- Shows the git commit message used
- Shows progress count (X of Y stories complete)
- Visual distinction with cyan box borders and clear section headers
- Ends with "Starting next iteration..." before continuing loop
- Added helper functions: get_active_prd(), get_story_title(), get_story_acceptance_criteria(), get_latest_commit_message(), get_total_progress()
- Files changed: fade
- Tests: bash -n syntax check passed

## 2026-01-20 - US-002: Display learned.md changes after each iteration (ENH-008) - COMPLETE

- Added display_learned_changes() function to detect and show learned.md modifications
- Captures learned.md content to temp file before each iteration
- Uses diff to detect new lines added during iteration
- Displays new entries with "New Learnings Captured:" heading (yellow) and green + prefix for each line
- Silently skips display when learned.md unchanged (no noise)
- Properly cleans up temp files in all code paths (STORY_DONE, ALL_COMPLETE, BLOCKED, no signal)
- Files changed: fade
- Tests: bash -n syntax check passed

## 2026-01-20 - US-003: Display fade status after each iteration (ENH-008) - COMPLETE

- Added display_prd_stories() function to show story-level status with checkboxes
- Shows PRD name followed by all stories with [✓] (green) for passed and [ ] (red) for incomplete
- Uses awk to extract story ID, title, and passes status from PRD JSON
- Integrated into display_iteration_summary() under "Current PRD Status:" heading
- Shows updated checkboxes reflecting just-completed story
- Combined with existing "Progress: X of Y stories complete" for total progress
- Files changed: fade
- Tests: bash -n syntax check passed, manual function test verified output

## 2026-01-20 - US-004: Visual separator between iterations (ENH-008) - COMPLETE

- Verified display_iteration_summary() already includes visual separators from US-001 implementation
- Uses double-line ═══════════ characters for clear visual boundary (lines 686, 688)
- Separator appears before summary content block
- Displays "Iteration N Complete" prominently centered (line 687)
- Cyan coloring provides consistent visual distinction for easy scanning
- End separator with "Starting next iteration..." also included (lines 730-732)
- All acceptance criteria already satisfied by existing implementation
- Files changed: none (already implemented)
- Tests: bash -n syntax check passed

## 2026-01-20 - US-005: Add --quiet flag to suppress iteration summaries (ENH-008) - COMPLETE

- Added --quiet/-q flag support to cmd_run() with proper flag parsing loop
- When --quiet is set, display_iteration_summary() call is skipped after STORY_DONE
- Final completion messages (ALL_COMPLETE, BLOCKED) still displayed regardless of quiet mode
- Commits and learned.md updates still captured normally
- Updated cmd_yolo() to pass through additional arguments to cmd_run()
- Updated main case statement to pass arguments to cmd_yolo (fade yolo --quiet works)
- Added "Run Options:" section to help text documenting --yolo and --quiet/-q flags
- Added examples: fade yolo --quiet, fade run --yolo --quiet
- Files changed: fade
- Tests: bash -n syntax check passed

## 2026-01-20 - US-006: Update documentation for enhanced loop feedback (ENH-008) - COMPLETE

- Added "Iteration Feedback (ALL/YOLO Mode)" section to README.md
- Documented all information shown in iteration summaries: Story Passed, Acceptance Criteria, New Learnings, Git Commit, Progress, PRD Status
- Documented --quiet/-q flag usage with examples
- Added full example iteration summary output showing the visual format
- README serves as the project description (no separate fade-project-description file exists)
- Files changed: README.md
- Tests: Verified README renders correctly with new section

## 2026-01-20 07:57 - US-001: Create prd-archive folder structure (ENH-006) - COMPLETE

- Updated cmd_init() function in fade script to create prd-archive/ folder
- Added .gitkeep file to prd-archive/ to ensure empty folder is tracked in git
- Includes skip logic when prd-archive/ already exists (consistent with prds/ folder behavior)
- Tested fade init creates folder successfully
- Tested fade init skips existing folder correctly
- Files changed: fade
- Tests: bash -n syntax check passed, manual init test verified folder creation

## 2026-01-20 08:00 - US-002: Archive completed PRDs from prds/ folder (ENH-006) - COMPLETE

- Added prd_is_fully_complete() function to check if all stories in a PRD have passes: true
- Added archive_completed_prds() function to scan prds/ folder and move completed PRDs
- Integrated archive step into ALL_COMPLETE signal handling in cmd_run()
- Archives display "archived: filename" for each moved file with green coloring
- Summary shows count of PRDs archived after completion
- Fixed bug in count_incomplete_stories() and count_complete_stories() functions where grep -c returning 0 would also trigger || echo "0" causing double output
- Files changed: fade
- Tests: bash -n syntax check passed, manual function test verified correct archive behavior

## 2026-01-20 08:06 - US-003: Archive prd.json with proper naming (ENH-006) - COMPLETE

- Added convert_type_to_prefix() function to map type field values to standard TYPE prefixes (feature→FEAT, bug→BUG, enhancement→ENH, chore→CHORE, spike→SPIKE)
- Added generate_slug() function to convert PRD name to slug format (lowercase, spaces to hyphens, max 50 chars, strip special chars)
- Added get_prd_id() function to extract id field from PRD JSON
- Added archive_priority_prd() function that renames and archives prd.json using {ID}-{slug}.json format when ID already contains TYPE-NUMBER pattern, or {TYPE}-{ID}-{slug}.json when ID is just a number
- Integrated archive_priority_prd() into ALL_COMPLETE signal handling before archive_completed_prds()
- Display shows "archived: prd.json → {new_filename}" with green coloring
- Total archived count includes both prd.json and prds/ folder PRDs
- Files changed: fade
- Tests: bash -n syntax check passed, manual function tests verified correct naming for both ID formats

## 2026-01-20 08:15 - US-004: Update prompt.md exit protocol (ENH-006) - COMPLETE

- Added archive documentation to prompt.md Story Completion Protocol section
- Documented that fade script automatically archives completed PRDs when ALL_COMPLETE is output
- Added "PRD Archive Naming Convention" subsection with table explaining TYPE, ID, and slug fields
- Included type-to-prefix mapping (feature→FEAT, bug→BUG, enhancement→ENH, chore→CHORE, spike→SPIKE)
- Added example showing how prd.json gets renamed during archive
- Documentation placed in Step 5 before Step 6 (STOP), consistent with archive running after ALL_COMPLETE signal
- Files changed: prompt.md
- Tests: Manual verification that documentation matches fade script archive behavior

## 2026-01-20 09:30 - US-001: Update FADE CLI to latest version (FEAT-006) - COMPLETE

- Added `fade update` command to fetch and install latest CLI from GitHub
- Implemented fetch_url() function supporting both curl and wget for cross-platform compatibility
- Shows current version before checking for updates
- Fetches latest version from VERSION file on GitHub (themitchelli/fade/main/VERSION)
- Compares versions and shows "already up to date" if current
- Downloads new script from GitHub and validates it contains expected markers (#!/bin/bash, FADE_VERSION=)
- Creates backup of existing script before overwriting
- Shows before/after version comparison on successful update
- Graceful error handling for network failures, missing curl/wget, and write permission issues
- Added update command to main case statement and help text
- Files changed: fade
- Tests: bash -n syntax check passed, help text verified

## 2026-01-20 10:45 - US-002: Update prompt.md to latest template (FEAT-006) - COMPLETE

- Extended `fade update` command to also check and update prompt.md from GitHub
- Added FADE_PROMPT_URL constant for fetching latest prompt.md template
- Checks if local prompt.md differs from latest template
- Shows diff summary with additions/deletions count and preview of first 10 changes
- Prompts user for confirmation before updating prompt.md
- Creates backup to prompt.md.bak before overwriting
- Added --cli-only flag to skip prompt.md update if user wants CLI-only updates
- Updated help text with "Update Options:" section documenting --cli-only flag
- Added examples: fade update, fade update --cli-only
- Updated main case statement to pass arguments to cmd_update
- Handles edge cases: no prompt.md found, fetch failures, prompt already up to date
- Files changed: fade
- Tests: bash -n syntax check passed, help text verified
