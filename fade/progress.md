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

## 2026-01-20 11:15 - US-003: Check for updates without applying (FEAT-006) - COMPLETE

- Added `fade update --check` flag to check for available updates without applying them
- Shows current version vs latest version comparison
- Lists what would be updated: CLI version and/or prompt.md template changes
- Does not modify any files when --check flag is used
- Exit code 0 when everything is up-to-date, exit code 1 when updates are available (useful for scripting)
- Fixed `set -e` interaction with fetch_url by using `|| true` to handle network failures gracefully
- Added --check documentation to help text under "Update Options" section
- Added example: fade update --check
- Files changed: fade
- Tests: bash -n syntax check passed, help text verified, error handling tested

## 2026-01-20 12:30 - US-004: Version tracking (FEAT-006) - COMPLETE

- Added `fade version` command to display current installed version
- Also supports `fade --version` and `fade -v` flags for convenience
- Version is output in semver format with leading 'v' (e.g., v0.2.3)
- Version is stored in FADE_VERSION variable in fade script
- Created VERSION file in repo root as source of truth (matches FADE_VERSION_URL used by update command)
- Added cmd_version() function and version|--version|-v case in main switch
- Updated help text to document version command
- Files changed: fade, VERSION
- Tests: bash -n syntax check passed, all three invocation methods tested (version, --version, -v)

## 2026-01-20 10:14 - US-001: New projects use contained structure (FEAT-007) - COMPLETE

- Updated cmd_init() to create new contained file structure with fade/ directory
- FADE.md stays at project root (visible, human-curated)
- Added CLAUDE.md template with redirect instructions for Claude Code discovery
- CLAUDE.md created at project root pointing to ./FADE.md and ./fade/prompt.md
- Other FADE files (progress.md, learned.md, prompt.md) now created inside fade/
- PRDs folder moved to fade/prds/
- prd.json priority injection now lives in fade/ (documented in CLAUDE.md)
- prd-archive folder moved to fade/prd-archive/
- Updated prds/README.md to reference fade/prd.json as priority location
- Project root now contains: FADE.md, CLAUDE.md, and fade/ directory
- Files changed: fade
- Tests: bash -n syntax check passed, manual init test verified correct structure creation

## 2026-01-20 14:30 - US-002: fade run finds files in new location (FEAT-007) - COMPLETE

- Updated build_context() to check fade/ directory first for progress.md, learned.md, prompt.md
- Falls back to root directory for backwards compatibility with legacy structure
- Updated get_active_prd() to check fade/prd.json and fade/prds/ first, then root
- Updated display_work_queue() to show PRDs from both fade/ and root locations
- Updated get_total_progress() to count stories from both locations
- Updated display_learned_changes() to detect learned.md path dynamically
- Updated cmd_run() learned.md capture to check fade/ first
- Updated archive_completed_prds() to use fade/prd-archive/ when fade/prds/ exists
- Updated archive_priority_prd() to handle fade/prd.json location
- Updated cmd_update --check mode to find prompt.md in either location
- Updated cmd_update prompt.md update to work with fade/prompt.md or root prompt.md
- Updated PROMPT_TEMPLATE embedded in fade script with new File Locations documentation
- Updated prompt.md with both Contained Structure and Legacy Structure documentation
- Updated help text to show both PRD location options
- Files changed: fade, prompt.md
- Tests: bash -n syntax check passed, fade status verified working with legacy structure

## 2026-01-20 15:45 - US-003: fade new creates PRDs in correct location (FEAT-007) - COMPLETE

- Added cmd_new() function to create PRD files with proper naming convention
- Supports all PRD types: feature, bug, toil (chore), enhancement, spike
- Creates PRDs in fade/prds/ when contained structure exists (fade/ directory present)
- Falls back to prds/ at root for legacy structure backwards compatibility
- Auto-generates filenames using {TYPE}-{NNN}-{slug}.json convention
- Auto-increments number by scanning existing PRDs of the same type
- For spikes, creates and switches to a spike/{slug} feature branch (with git repo check)
- Generates PRD template JSON with proper type, id, name, and userStories structure
- Added error handling for missing type, missing name, unknown types, and no PRD folder
- Added new command to main case statement
- Added "New Command" section to help text with usage and type list
- Added examples in help: fade new feature/bug/spike
- Files changed: fade
- Tests: bash -n syntax check passed, error handling verified for all edge cases

## 2026-01-20 10:24 - US-004: Migrate existing projects to contained structure (FEAT-007) - COMPLETE

- Added cmd_migrate() function to move legacy FADE files into contained fade/ structure
- Detects FADE files at project root: progress.md, learned.md, prompt.md, prd.json
- Detects directories: prds/, prd-archive/
- Creates fade/ directory and moves files/folders into it
- FADE.md stays at root (correct location)
- Creates CLAUDE.md redirect if it doesn't exist (using CLAUDE_TEMPLATE)
- Added --dry-run flag to preview migration without making changes
- Added --yes/-y flag to skip confirmation prompt (useful for automation/testing)
- Shows migration summary with counts of files/folders moved and created
- Displays new structure after migration completes
- Handles conflicts: skips files/folders that already exist in fade/
- Added migrate command to main case statement and help text
- Added "Migrate Options" section to help with --dry-run and --yes flags
- Added examples: fade migrate, fade migrate --dry-run
- Files changed: fade
- Tests: bash -n syntax check passed, dry-run and actual migration tested

## 2026-01-20 10:24 - US-005: CLAUDE.md redirect for Claude Code discovery (FEAT-007) - COMPLETE

- Verified CLAUDE_TEMPLATE already exists and is created by cmd_init() (implemented in US-001)
- CLAUDE.md contains instructions pointing to ./FADE.md and ./fade/prompt.md
- CLAUDE.md is minimal (25 lines) - just a redirect with file location map
- fade migrate now creates CLAUDE.md redirect when migrating legacy projects
- All acceptance criteria satisfied by existing implementation plus migrate command
- Files changed: fade (migrate command creates CLAUDE.md)
- Tests: Verified CLAUDE_TEMPLATE content meets all criteria

## 2026-01-20 - US-001 through US-004: Graceful Rate Limit Handling (ENH-008) - COMPLETE

- Added detect_interruption() function to identify known interruption patterns (rate_limit, network_error, service_error)
- Added display_rate_limit_exit() to show friendly message when rate limited, including reset time extraction
- Added display_network_error_exit() for connection/network issues with retry suggestions
- Added display_service_error_exit() for Claude API service issues with status page link
- Added display_generic_interruption_exit() for unrecognized stops without scary error language
- Added display_session_context() and display_resume_instructions() helper functions for consistent messaging
- Updated cmd_run() ALL mode loop to check for interruptions before showing "no signal" error
- Updated EXIT SIGNALS comment block with new interruption types and exit codes
- Exit codes: 0=success, 1=error/blocked, 2=rate-limited, 3=transient error (network/service)
- All interruption handlers show current PRD context and suggest fade run/yolo to resume
- Files changed: fade
- Tests: bash -n syntax check passed, detect_interruption() function tested with various patterns

## 2026-01-20 - US-001: Archive works on macOS (BUG-001) - COMPLETE

- Replaced `head -n -1` with `sed '$d'` for cross-platform compatibility
- GNU `head -n -1` (remove last line) doesn't work on macOS BSD head
- `sed '$d'` (delete last line) works identically on both BSD and GNU sed
- Two occurrences fixed at lines 1629 and 1635 in bin/fade-cli
- Archive display code now properly shows archive messages without errors
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, sed '$d' tested on macOS Darwin 24.6.0

## 2026-01-20 - US-002: Archive handles legacy structure (BUG-001) - COMPLETE

- Verified archive_completed_prds() already handles legacy structure correctly (lines 690-722)
- Logic: checks fade/prds first (line 696), falls back to prds/ at root using defaults
- Verified archive_priority_prd() already handles legacy structure correctly (lines 781-831)
- Logic: checks fade/prd.json first (line 785), falls back to prd.json at root (line 788)
- Both functions use corresponding archive paths (fade/prd-archive/ or prd-archive/)
- Legacy structure support was implemented in FEAT-007 US-002 (lines 236-237 in progress.md)
- All acceptance criteria satisfied by existing implementation:
  - Archive checks fade/prds/ first (new structure)
  - Falls back to prds/ at root (legacy structure)
  - Moves to corresponding archive folder
- Files changed: none (already implemented)
- Tests: Code review verified correct conditional logic for both structures

## 2026-01-20 - US-001: Story completion checkpoint protocol in prompt.md (ENH-006) - COMPLETE

- Enhanced Story Completion Protocol section in prompt.md with explicit checkpointing instructions
- Added "CRITICAL: Checkpoint after EVERY story. Do NOT batch status updates." header
- Added "before proceeding to the next story" to step ordering instruction
- Updated Step 3 to explicitly state "IMMEDIATELY. Do not wait until the end of the session."
- Added new Step 5: Output status line with 'US-XXX: [Story Title] ✅' pattern
- Renumbered Step 6 (Signal completion) and Step 7 (STOP) accordingly
- All acceptance criteria satisfied:
  - prompt.md includes 'Story Completion Protocol' section
  - Protocol requires immediate passes: true update after story completion
  - Protocol requires git commit with appropriate prefix
  - Protocol requires output of brief status line: 'US-XXX: [title] ✅'
  - Protocol explicitly states 'Do NOT batch status updates'
  - Protocol explicitly states 'Checkpoint after every story before proceeding'
- Files changed: fade/prompt.md
- Tests: Manual verification that all required language is present

## 2026-01-20 - US-002: YOLO mode observability guidance (ENH-006) - COMPLETE

- Added "Autonomous Mode Observability" section to prompt.md
- Section placed after Story Completion Protocol, before Exit Signals
- Includes explicit guidance: "Even in autonomous/YOLO mode, output status after each story"
- Includes explicit guidance: "Never go more than 5 minutes without visible output"
- Documents progress indicator pattern: "Working on US-XXX... [brief description]"
- Added example progress indicators showing different phases of story work
- Helps operators monitoring YOLO loops understand work is progressing
- Files changed: fade/prompt.md
- Tests: Manual verification that all acceptance criteria language is present

## 2026-01-20 - US-003: Acceptance criteria checkpoint (ENH-006) - COMPLETE

- Added "Optional: Track acceptance criteria progress" subsection to prompt.md Story Completion Protocol
- Subsection placed under Step 3 (Update PRD) as optional guidance
- Suggests pattern: Update PRD with 'acPassed': ['AC-1', 'AC-2'] array as criteria are verified
- Includes JSON example showing acPassed array alongside passes: false
- Documents rationale: enables recovery from mid-story interruptions when sessions are killed
- Includes "When to use" guidance: stories with 4+ criteria or time-consuming verification
- Explicitly states this is OPTIONAL - framework doesn't require acPassed field
- Files changed: fade/prompt.md
- Tests: Manual verification that all acceptance criteria language is present
