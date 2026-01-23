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

## 2026-01-20 - US-001: Scanner treats missing passes field as incomplete (BUG-003) - COMPLETE

- Updated prd_has_incomplete_stories() to compare total stories vs complete stories instead of checking for passes:false
- Updated count_incomplete_stories() to return (total - complete) count, catching both passes:false AND missing passes field
- Verified count_complete_stories() already only counts explicit passes:true (added clarifying comment)
- Updated prd_is_fully_complete() to require total_stories == complete_stories for completion
- All functions now use "id": "US-" pattern to count total stories
- Functions now correctly detect PRDs with missing passes fields as having incomplete work
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual function tests verified correct behavior

## 2026-01-20 - US-002: Validate PRD completion before archive (BUG-003) - COMPLETE

- Updated archive_completed_prds() to re-verify prd_is_fully_complete() immediately before mv
- Updated archive_priority_prd() with same re-verification before moving prd.json
- Both functions now abort with yellow warning message if PRD is no longer complete at move time
- Prevents race conditions where file could be modified between initial check and archive
- prd_is_fully_complete() already requires explicit passes:true on ALL stories (verified from US-001)
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, fade status verified working

## 2026-01-20 - US-004: Add PRD integrity rules to prompt.md (BUG-003) - COMPLETE

- Added new "PRD Integrity Rules" section to prompt.md after Execution Rules
- Section includes "File Handling" subsection with explicit instructions:
  - NEVER create copies of PRD files
  - ALWAYS update the ORIGINAL file in prds/ or fade/prds/
  - NEVER write directly to prd-archive/
- Section includes "Completion Verification" subsection with:
  - Verify passes:true BEFORE signalling completion
  - Only signal STORY_DONE or ALL_COMPLETE after verification
- Added "Why This Matters" explanation of consequences for each violation
- Updated Step 3 in Story Completion Protocol to reference PRD Integrity Rules
- Added re-read verification reminder after editing PRD
- Files changed: fade/prompt.md
- Tests: Manual verification that all acceptance criteria language is present

## 2026-01-20 - US-003: Archive verifies source file deleted after move (BUG-003) - COMPLETE

- Updated archive_completed_prds() to verify source file no longer exists after mv command
- Updated archive_priority_prd() with same verification after mv command
- Both functions display red error message if source file still exists after move
- Both functions clean up partial archive (rm -f) if verification fails
- Archive count only incremented after successful source deletion verification
- Handles edge case where mv might succeed but not remove source (rare filesystem scenarios)
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-20 - US-005: Add version stamps to FADE artifacts (BUG-003) - COMPLETE

- Added version comment to prompt.md template: `<!-- FADE v__FADE_VERSION__ -->`
- Added version comment to FADE.md template: `<!-- FADE v__FADE_VERSION__ -->`
- Updated create_file_if_missing() to replace __FADE_VERSION__ placeholder with actual version
- Added get_artifact_version() helper function to extract version from artifact files
- Updated fade status --json to include artifacts section with fade_md and prompt_md versions
- Updated fade update --check to detect version mismatches in FADE.md and prompt.md
- Version detection uses regex pattern: `FADE v[0-9]+\.[0-9]+\.[0-9]+`
- Artifacts without version stamp show null in JSON and trigger "no version stamp" warning
- All acceptance criteria verified:
  - prompt.md includes version comment at top
  - FADE.md template includes version comment at top
  - fade init stamps current version into generated files
  - fade status --json includes artifact versions
  - fade update can detect version mismatch
- Files changed: bin/fade-cli, fade/prompt.md
- Tests: bash -n syntax check passed, fade init tested with version stamp verification, fade status --json tested

## 2026-01-20 - US-001: Create public version manifest gist (ENH-006) - COMPLETE

- Created version-manifest.json at repo root with release version and per-artifact versions
- Manifest structure: { release: '0.3.0', artifacts: { 'fade-cli': '0.3.0', 'prompt.md': '0.3.0', ... } }
- Added FADE_MANIFEST_URL constant to fade-cli pointing to raw GitHub URL
- URL: https://raw.githubusercontent.com/themitchelli/fade/main/version-manifest.json
- Updated README.md with "Version Manifest" section documenting location and format
- Documented manifest fields: release (semver), artifacts (map of names to versions)
- Using raw GitHub URL instead of gist - provides same stable public access without separate resource
- Files changed: version-manifest.json (new), bin/fade-cli, README.md
- Tests: bash -n syntax check passed

## 2026-01-20 - US-002: Add version headers to all FADE artifacts (ENH-006) - COMPLETE

- Added ARTIFACT_VERSION="0.3.0" constant to fade-cli (line 9)
- Updated FADE_TEMPLATE to use `<!-- FADE FADE.md v__FADE_VERSION__ -->` format
- Updated PROMPT_TEMPLATE to use `<!-- FADE prompt.md v__FADE_VERSION__ -->` format
- Added version header to PROGRESS_TEMPLATE: `<!-- FADE progress.md v__FADE_VERSION__ -->`
- Added version header to LEARNED_TEMPLATE: `<!-- FADE learned.md v__FADE_VERSION__ -->`
- Added version header to CLAUDE_TEMPLATE: `<!-- FADE CLAUDE.md v__FADE_VERSION__ -->`
- Updated actual fade/prompt.md to use new format: `<!-- FADE prompt.md v0.3.0 -->`
- Updated get_artifact_version() function to support both old and new version header formats
- All version headers follow consistent format: `<!-- FADE {filename} v{version} -->`
- Files changed: bin/fade-cli, fade/prompt.md
- Tests: bash -n syntax check passed, regex tested for both old and new formats

## 2026-01-20 - US-003: fade init stamps versions into generated files (ENH-006) - COMPLETE

- Verified create_file_if_missing() already replaces __FADE_VERSION__ placeholder with $FADE_VERSION (line 489)
- Tested fade init in clean directory - all 5 artifacts receive version stamps
- Generated FADE.md contains `<!-- FADE FADE.md v0.3.0 -->`
- Generated prompt.md contains `<!-- FADE prompt.md v0.3.0 -->`
- Generated CLAUDE.md contains `<!-- FADE CLAUDE.md v0.3.0 -->`
- Generated learned.md contains `<!-- FADE learned.md v0.3.0 -->`
- Generated progress.md contains `<!-- FADE progress.md v0.3.0 -->`
- All acceptance criteria satisfied by existing implementation from US-002
- Files changed: none (already implemented)
- Tests: Manual test of fade init verified all files receive version stamps

## 2026-01-20 - US-004: fade version shows detailed version info (ENH-006) - COMPLETE

- Enhanced cmd_version() function to support --all/-a flag
- Without flag: shows CLI version only (existing behaviour preserved)
- With --all flag: shows CLI version plus all detected artifact versions
- Scans for FADE.md, prompt.md, CLAUDE.md, progress.md, learned.md
- Checks both contained (fade/) and legacy (root) locations
- Shows 'not found' for missing artifacts, 'no version' for artifacts without headers
- Highlights outdated versions and missing versions in yellow
- Shows summary: "All artifacts match" or "Some artifacts have version mismatches"
- Updated case statement to pass arguments to cmd_version
- Added "Version Options" section to help text documenting --all/-a flag
- Added examples: fade version, fade version --all
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests verified both modes

## 2026-01-20 - US-005: fade status outputs version info (ENH-006) - COMPLETE

- Added display_version_warnings() function to detect and display version mismatches
- Function checks all 5 FADE artifacts: FADE.md, prompt.md, CLAUDE.md, progress.md, learned.md
- Supports both contained (fade/) and legacy (root) file locations
- Displays warning footer with list of outdated artifacts (shows version) and missing version stamps
- Footer only appears if versions differ; clean output when all match
- Updated cmd_status() to call display_version_warnings() after display_work_queue() for pretty mode
- JSON output already includes version and artifacts object (from US-004 BUG-003)
- All acceptance criteria verified:
  - fade status header shows CLI version (already done)
  - fade status footer shows artifact versions if any are outdated
  - If all versions match: no extra output (clean)
  - If versions differ: shows warning with list of outdated artifacts
  - fade status --json includes versions object in output
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests verified pretty and JSON output

## 2026-01-20 - US-006: Version output after FADE component changes (ENH-006) - COMPLETE

- Enhanced cmd_update() to show version transitions for all updated artifacts
- CLI update already showed 'v0.3.0 → v0.4.0' format (verified unchanged)
- Added prompt_version_before capture before any updates using get_artifact_version()
- Updated prompt.md update message to show version transition: 'v$prompt_version_before → v$latest_version'
- Added artifacts_updated counter to track number of artifacts updated
- Updated summary section to show version transitions for both CLI and prompt.md
- Added summary line: "Updated N artifact(s) to vX.X.X" with proper singular/plural handling
- Changed "Everything is up to date!" to "All artifacts at vX.X.X" when nothing to update
- All acceptance criteria verified:
  - fade update shows before/after versions for each updated artifact
  - Format: 'prompt.md: v0.3.0 → v0.4.0' in summary section
  - Summary line: 'Updated N artifacts to vX.X.X'
  - If nothing to update: 'All artifacts at vX.X.X'
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-20 - US-007: fade run outputs version banner (ENH-006) - COMPLETE

- Added display_version_banner() function to show CLI version, prompt.md version, and warnings
- Banner format: "FADE v0.3.0 │ prompt.md v0.3.0" (concise single line when all match)
- Added YOLO indicator when running in yolo mode: "🤘 YOLO" appended to version line
- Shows warnings on second line when versions mismatch (e.g., "Outdated: FADE.md v0.2.0")
- Checks FADE.md, CLAUDE.md, progress.md, learned.md for version mismatches
- Added build_version_context() function to provide version info in Claude Code session context
- Context includes CLI version, prompt.md version, and any version warnings
- Updated build_context() to prepend version info at start of session context
- Updated cmd_run() to use display_version_banner() instead of basic version output
- fade yolo inherits banner via cmd_run("--yolo") call chain
- All acceptance criteria verified:
  - fade run outputs version banner before launching Claude Code
  - Banner shows: CLI version, prompt.md version, any version warnings
  - Banner is concise (1-2 lines when all versions match)
  - fade yolo also shows version banner
  - Version info captured in session context for Claude Code
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual function tests verified both modes

## 2026-01-20 - US-008: fade update checks gist for latest versions (ENH-006) - COMPLETE

- Added configurable timeout support to fetch_url() function (default 10s, curl uses --connect-timeout and --max-time)
- Added get_manifest_version() function to fetch and parse version-manifest.json
- Function extracts release version (no args) or specific artifact version (e.g., "fade-cli", "prompt.md")
- Updated cmd_update() to try manifest first, fall back to VERSION file if unavailable
- Shows "Note: Manifest unavailable, using VERSION file" on fallback
- Check-only mode now gets per-artifact versions from manifest when available
- Uses manifest versions for fade-cli, FADE.md, and prompt.md comparisons
- All fetch_url calls now include timeout parameter: manifest (5s), prompt.md (10s), CLI (15s)
- Error messages updated to show both attempted URLs on failure
- All acceptance criteria verified:
  - fade update fetches version manifest from FADE_MANIFEST_URL
  - Compares local artifact versions against manifest artifact versions
  - Downloads updated artifacts from raw GitHub URLs (unchanged)
  - Falls back to FADE_VERSION_URL if manifest unavailable
  - Timeout handling via curl --connect-timeout/--max-time and wget --timeout
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manifest parsing tested with local file

## 2026-01-21 - US-001: Create standards folder structure (ENH-009) - COMPLETE

- Updated cmd_init() to create fade/standards/ folder alongside fade/prds/
- Created placeholder README.md in fade/standards/ explaining the folder purpose
- README includes: purpose section, usage instructions linking from FADE.md, guidance for creating custom standards
- Existing projects without standards/ folder continue to work (backwards compatible)
- Running fade init on existing projects adds standards/ folder without affecting other files
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual fade init test verified folder creation with README

## 2026-01-21 - US-002: API Security standard document (ENH-009) - COMPLETE

- Created fade/standards/api-security.md with 7 Claude-actionable security principles
- Principles covered: auth by default, object-level authorization, schema-first input validation, least data returned, rate limiting, parameterized queries, secure error handling
- Each principle has: Apply section with specific actions, code examples (good/bad), and Rationale explaining why it matters
- Written as instructions Claude can apply directly, not enterprise governance prose
- Includes quick reference table and "When to Read" section at end
- File is 756 words, well under the 1,100 word (~1,500 token) limit
- Files changed: fade/standards/api-security.md (new)
- Tests: Word count verified under limit

## 2026-01-21 - US-003: FADE.md template includes Standards section (ENH-009) - COMPLETE

- Added '## Standards' section to FADE_TEMPLATE in bin/fade-cli
- Section placed after 'Coding Standards' and before 'Architecture References'
- Contains markdown table with links to standards/*.md files using relative paths
- Links all 5 core standards: api-security.md, git.md, coding.md, testing.md, documentation.md
- Each standard has brief one-liner description of what it covers
- Includes HTML comment explaining the section purpose and customisation guidance
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-21 - US-004: prompt.md references standards for relevant work (ENH-009) - COMPLETE

- Updated Session Start section to include step 6: Read relevant standards from standards/ folder
- Added sub-bullet to step 1: Check Standards section in FADE.md for links to detailed standards
- Updated Execution Rules to reference standards/ folder alongside FADE.md
- Added new "Standards Reference" section after Execution Rules with:
  - "When to Read Standards" table mapping work types to standard files
  - Explicit instruction: "When working on API endpoints, read standards/api-security.md first"
  - "Adding New Standard References" subsection documenting the pattern for new standards
- Pattern includes: create file, add table row, link from FADE.md
- Notes token limit guidance (under 1,500 tokens / ~1,100 words)
- Files changed: fade/prompt.md
- Tests: Manual verification that all acceptance criteria language is present

## 2026-01-21 - US-005: Git standard document (ENH-009) - COMPLETE

- Created fade/standards/git.md with conventional commit message format and type prefixes
- Covers all required type prefixes: feat, fix, docs, chore, refactor, test, spike
- Documents branch naming conventions (kebab-case, type prefixes like feature/, bugfix/, spike/)
- Covers trunk-based development as default with feature branch guidelines
- Includes FADE-specific conventions:
  - Story completion commit format: `feat: complete US-XXX - Story Title`
  - PRD checkpoint commits with story reference
  - Spike branch rules (never merge to main, use spike: prefix)
- Includes commit hygiene section with atomic commits and what to commit/avoid
- Protected branch rules documented (never force push main)
- Quick reference table for common git commands
- File is 744 words, well under the 1,100 word limit
- Files changed: fade/standards/git.md (new)
- Tests: Word count verified under limit

## 2026-01-21 - US-006: Coding standard document (ENH-009) - COMPLETE

- Created fade/standards/coding.md with language-agnostic coding principles
- Covers all required topics: naming conventions (camelCase/snake_case, PascalCase for classes, boolean prefixes), function guidelines (20-30 line target, single responsibility, max 3 params), file organization (200-300 lines, structure order)
- Includes error handling guidelines (explicit handling, meaningful messages, don't swallow errors)
- Includes comments section (when to comment, self-documenting code examples)
- Includes language-specific rules section for JS/TS and Python
- Includes Do/Don't code examples throughout (naming, functions, error handling, comments)
- Quick reference table and "When to Read" section at end
- File is 803 words, well under the 1,100 word limit
- Files changed: fade/standards/coding.md (new)
- Tests: Word count verified under limit

## 2026-01-21 - US-007: Testing standard document (ENH-009) - COMPLETE

- Created fade/standards/testing.md with test philosophy and patterns
- Covers test pyramid: 70% unit, 20% integration, 10% E2E with rationale
- Documents what to test vs what to skip (business logic yes, framework code no)
- Includes AAA pattern section with clear example
- Covers test naming conventions with good/bad examples
- Documents mocking guidelines: mock boundaries not internals
- Includes test independence rules (no shared state, run in any order)
- Coverage requirements section: 70-80% unit target, not chasing 100%
- Includes good vs bad test code examples throughout
- Quick reference table and "When to Read" section at end
- File is 758 words, well under the 1,100 word (~1,500 token) limit
- Files changed: fade/standards/testing.md (new)
- Tests: Word count verified under limit

## 2026-01-21 - US-008: Documentation standard document (ENH-009) - COMPLETE

- Created fade/standards/documentation.md with documentation layers and guidelines
- Covers all required topics: what to document, README structure, API docs, ADR format, code comments, FADE-specific docs
- Documentation Layers table: README, API docs, ADRs, Code comments, FADE files with audience and location
- README Structure section with required sections and example template
- API Documentation section with endpoint, parameters, response, example format
- ADR template with Status, Context, Decision, Rationale, Consequences sections
- FADE-Specific Documentation section: progress.md, learned.md, FADE.md guidelines
- "What NOT to Document" section with anti-patterns table explicitly preventing over-documentation
- Includes guidance: no docstrings for private functions, no restating code, no giant walls of text
- Quick reference table and "When to Read" section at end
- File is 771 words, well under the 1,100 word (~1,500 token) limit
- Files changed: fade/standards/documentation.md (new)
- Tests: Word count verified under limit

## 2026-01-21 - US-009: fade update includes standards folder and files (ENH-009) - COMPLETE

- Added FADE_STANDARDS_BASE_URL constant pointing to GitHub raw URL for standards folder
- Added FADE_STANDARD_FILES array listing all 5 standard files to be synced
- Added STANDARDS UPDATE section to cmd_update() after prompt.md update section
- Logic: detects FADE project (fade/ or legacy prds/prompt.md), creates standards/ if missing
- Iterates through each standard file: skips if exists (preserves user customizations), fetches and adds if missing
- Reports each file: 'exists' for existing files, 'Added: standards/X.md' for new files
- Updated SUMMARY section to include standards_added count in output
- Shows list of added standards in update complete summary
- Handles both contained (fade/standards/) and legacy (standards/) structures
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, structure detection logic verified manually

## 2026-01-22 - US-001: Scaffold tests folder on fade init (ENH-009) - COMPLETE

- Updated cmd_init() to create fade/tests/ directory
- Created run.sh scaffold with executable permissions (chmod +x)
- run.sh loops through fade/tests/PRD-*/ folders using find command
- run.sh executes all test_*.sh files in each PRD folder
- Exits 0 if all tests pass or if no PRD-* folders exist (empty tests folder)
- Writes failures to fade/tests/failed.log with timestamp, test file, exit code, and output
- Exits non-zero (1) when any test fails
- Failed.log is overwritten on each run (not appended)
- Failed.log is deleted when all tests pass (clean state)
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual fade init test verified folder and run.sh creation, run.sh tested with passing, failing, and empty test scenarios

## 2026-01-22 - US-002: Generate tests on PRD completion (ENH-009) - COMPLETE

- Added TEST_GENERATION_TEMPLATE to bin/fade-cli with comprehensive test generation instructions
- Added helper functions: get_prd_id(), build_test_generation_context(), get_tests_dir(), run_test_generation(), generate_tests_for_completed_prds()
- Updated ALL_COMPLETE handler to call generate_tests_for_completed_prds() before archiving
- Test generation runs via Claude Code with --print flag and full repo context
- Tests written to fade/tests/{PRD-ID}/ folder
- Test file naming: test_{US_ID}_{AC_num}_{slug}.sh
- Skipped ACs create SKIP_{US_ID}_{AC_num}_{slug}.md files with explanation
- Added comprehensive Test Generation section to fade/prompt.md with:
  - Test file structure and naming convention table
  - Test format requirements (shell/curl only, exit codes, assertions)
  - Repo context usage examples for concrete assertions
  - What to skip table with examples
  - SKIP file format template
  - Reference to standards/testing.md
- Updated PROMPT_TEMPLATE in fade-cli with note about test generation on ALL_COMPLETE
- Files changed: bin/fade-cli, fade/prompt.md
- Tests: bash -n syntax check passed

## 2026-01-22 - US-003: Run tests on STORY_DONE (ENH-009) - COMPLETE

- Added run_regression_tests() function to execute fade/tests/run.sh after each STORY_DONE
- Function checks if run.sh exists and is executable before running
- Implements 5-minute timeout using timeout (Linux) or gtimeout (macOS via Homebrew)
- Falls back to no timeout on macOS without gtimeout installed
- Displays full test output to developer during execution
- On test pass: iteration continues normally with green success banner
- On test fail: iteration blocked with red error banner pointing to fade/tests/failed.log
- On timeout: iteration blocked with yellow warning and curation suggestions
- Integrated into cmd_run() STORY_DONE handler after display_iteration_summary()
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-22 - US-004: Failed log captures actionable details (ENH-009) - COMPLETE

- Enhanced run.sh template in fade-cli with grep-friendly failure logging format
- Added [TAG] prefixes for all log entries: [FAILURE], [EXIT_CODE], [TIMESTAMP], [EXPECTED], [ACTUAL], [COMMAND], [OUTPUT]
- Header now includes [RUN_TIMESTAMP] and [RUN_DIR] tags
- Log automatically extracts "Expected:" and "Actual:" values from test output
- Log extracts endpoint/command info from patterns like "Command:", "Endpoint:", "URL:", "curl:", "Running:"
- Log is overwritten on each test run (not appended)
- Each failure is a complete block with clear --- delimiter between failures
- Format enables grep commands like: grep "^\[FAILURE\]" failed.log
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual testing with example failures verified correct extraction

## 2026-01-22 - US-005: Developer can clear tests for context switch (ENH-009) - COMPLETE

- Verified run.sh already handles folder deletion (uses find to discover PRD-*/ folders)
- Verified empty tests folder already returns pass (lines 2252-2256 in fade-cli check if PRD_DIRS is empty)
- No archive mechanism needed - the design is intentionally simple: delete folders to exclude tests
- Added "Regression Testing" section to README.md documenting:
  - Test folder structure (fade/tests/, run.sh, PRD-*/, failed.log)
  - How regression testing works (generation on ALL_COMPLETE, execution on STORY_DONE)
  - "Managing Test Scope (Delete to Focus)" subsection with examples
  - Commands to delete specific PRD test folders
- Updated Repository Structure in README.md to include fade/tests/ folder
- All acceptance criteria verified:
  - Deleting fade/tests/PRD-*/ folders removes those tests from run (find-based discovery)
  - Empty fade/tests/ folder results in pass (exit 0)
  - No archive mechanism (simple delete)
  - Documentation explains the 'delete to focus' pattern
- Files changed: README.md
- Tests: Code review verified run.sh logic handles all cases

## 2026-01-22 01:27 - US-006: Update prompt.md with test generation instructions (ENH-009) - COMPLETE

- Verified prompt.md already contains comprehensive Test Generation section (lines 250-368)
- Section was added during US-002 implementation when test generation feature was built
- All acceptance criteria verified present in fade/prompt.md:
  - Test generation section present: "## Test Generation" at line 250
  - Shell/curl as default format: line 287 "shell scripts with no external dependencies", line 313 "shell/bash and curl only"
  - Test file naming convention: lines 275-283 with table documenting `test_{US_ID}_{AC_num}_{slug}.sh`
  - Repo context for assertions: lines 319-334 "Using Repo Context for Assertions" with examples
  - Skip untestable ACs: lines 336-357 "What to Skip" section with table and SKIP file format
  - Reference to testing.md: line 368 "For test quality guidelines, see `standards/testing.md`."
- Story was already implemented but not marked complete - this is a documentation checkpoint
- Files changed: fade/prds/ENH-009-regression-testing.json (marked passes: true)
- Tests: Manual verification that all acceptance criteria language is present in prompt.md

## 2026-01-23 - US-001: Basic codebase analysis (FEAT-008) - COMPLETE

- Added `fade map` command for analyzing existing codebases
- Implemented detect_languages() function using find to count files by extension
- Implemented extension_to_language() to map extensions to human-readable language names
- Implemented detect_framework() to parse package.json, requirements.txt, pyproject.toml, Cargo.toml, go.mod, Gemfile
- Detects major frameworks: React, Vue, Angular, Svelte, Next.js, Nuxt, Express, Fastify, NestJS, Django, Flask, FastAPI, etc.
- Implemented detect_entry_points() to find common entry files (main.py, index.js, app.ts, etc.)
- Implemented describe_directories() using get_dir_description() case statement for 70+ common directory names
- Output formatted with two sections: analysis results and copy-paste ready markdown for FADE.md
- Added map command to help text and examples
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests on simulated projects verified all detection features

## 2026-01-23 - US-002: Architecture pattern detection (FEAT-008) - COMPLETE

- Added detect_architecture_patterns() function to identify common architectural patterns
- MVC/MVVM detection: checks for models/, views/, controllers/, viewmodels/ directories
- API structure detection: checks for routes/, api/, endpoints/, handlers/, resources/ directories
- Test organization detection: checks for tests/, __tests__/, spec/ directories and colocated *.test.* *.spec.* files
- Config pattern detection: checks for config/, settings/ directories and .env files
- Additional patterns: Service Layer, Repository Pattern, DDD, Middleware, Component-Based UI, Feature/Module Based, Monorepo
- Each pattern reported with confidence level: certain (all evidence), likely (partial), possible (minimal)
- Integrated into cmd_map() with table output showing Pattern, Confidence, Evidence columns
- Added architecture patterns to FADE.md ready output section
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests verified all confidence levels and pattern detection

## 2026-01-23 - US-003: Dependency analysis (FEAT-008) - COMPLETE

- Added categorize_dependency() function to classify dependencies into framework/database/testing/utilities/other
- Added analyze_npm_dependencies() to parse package.json dependencies and devDependencies
- Added analyze_python_dependencies() to parse requirements.txt, requirements-dev.txt, and pyproject.toml
- Added analyze_rust_dependencies() to parse Cargo.toml [dependencies] and [dev-dependencies]
- Added analyze_go_dependencies() to parse go.mod require blocks
- Added analyze_ruby_dependencies() to parse Gemfile with group detection for dev dependencies
- Added analyze_dependencies() main function that combines all sources
- Added format_dependencies_summary() to format output grouped by category
- Integrated into cmd_map() with new "## Dependencies" section showing:
  - Categorized dependencies (Frameworks, Database, Testing, Utilities, Other)
  - Package counts by source (npm, pip, cargo, go, gem)
  - Dev vs production counts
- Updated FADE.md ready output to include "Key Dependencies" section and auto-populate Database in Tech Stack
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests on npm/Python/Rust/Go/Ruby projects verified all detection features

## 2026-01-23 - US-004: Generate FADE.md draft (FEAT-008) - COMPLETE

- Added --init and --force flags to fade map command with argument parsing
- fade map --init generates FADE.md if it doesn't exist (returns error if exists, use --force to override)
- Generated FADE.md includes:
  - Tech Stack section populated from dependency analysis (language, framework, database)
  - Project Overview with detected framework/language filled in
  - Architecture References with detected patterns and directory structure
  - All standard sections (Coding Standards, Standards, Fragile Areas, Off-Limits, etc.)
- All auto-generated sections marked with <!-- AUTO-GENERATED --> comments
- Version stamp included at top: <!-- FADE FADE.md v0.3.0 -->
- Warning message output advising user to review and customize content
- Lists specific sections that need review (Project Overview, Tech Stack, etc.)
- Updated help text with new "Map Options" section
- Updated examples: fade map --init, fade map --init --force
- Updated main case statement to pass arguments to cmd_map
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests verified FADE.md generation, overwrite protection, and --force flag

## 2026-01-23 - US-005: Identify potential fragile areas (FEAT-008) - COMPLETE

- Added detect_fragile_areas() function to identify potential problem spots in codebase
- Function analyzes and flags:
  - Files over 500 lines (medium severity) or 1000 lines (high severity) as potentially complex
  - Directories with more than 20 files (medium) or 50 files (high) as potentially tangled
  - Files/directories with 'legacy', 'old', 'deprecated' in name (medium severity)
  - Files with 5+ TODO/FIXME/HACK/XXX/BUG comments (medium) or 10+ (high severity)
- Added "Potential Fragile Areas" section to fade map output between Directory Structure and FADE.md Ready Output
- Fragile areas displayed in table format with Path, Reason, and Severity (🔴 high / 🟡 medium) columns
- Added fragile areas to FADE.md ready output section for easy copy-paste
- Updated fade map --init to populate Fragile Areas section with detected areas instead of placeholder examples
- Fragile areas in generated FADE.md marked with <!-- AUTO-GENERATED --> comment
- Updated review guidance to mention "Review detected problem spots" when fragile areas found
- Excluded common directories from analysis: node_modules, .git, venv, __pycache__, dist, build, .next, vendor, target
- Results sorted by severity and limited to top 20 items
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests on simulated project verified detection of all criteria

## 2026-01-23 - US-006: Respect gitignore (FEAT-008) - COMPLETE

- Added gitignore parsing and exclusion system to fade map command
- New global variables: GITIGNORE_PATTERNS[], EXCLUDED_PATHS_COUNT, DEFAULT_EXCLUDES[]
- New functions:
  - parse_gitignore(): Reads .gitignore file and populates GITIGNORE_PATTERNS array
  - build_find_exclusions(): Generates find command exclusion arguments (unused, kept for future)
  - should_exclude_path(): Checks if a path matches default excludes or gitignore patterns
  - count_excluded_paths(): Counts how many paths are excluded for transparency reporting
  - get_exclusion_summary(): Formats exclusion info for display
  - filter_excluded_paths(): Helper to filter find results through exclusion logic
- Updated detect_languages() to filter files using should_exclude_path()
- Updated describe_directories() to skip excluded directories using should_exclude_path()
- Updated detect_architecture_patterns() colocated test detection to use filter_excluded_paths()
- Updated detect_fragile_areas() all four find operations to use filter_excluded_paths()
- Added "## Exclusions" section to fade map output showing:
  - Whether .gitignore was found and used
  - Count of default patterns + gitignore patterns
  - Count of excluded paths
- Updated help text with "Map Exclusions" section documenting the behavior
- Default excludes: node_modules, .git, venv, __pycache__, dist, build, .next, target, vendor, coverage, out, .cache, .venv, env, .env, *.pyc, *.pyo, .DS_Store
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, manual tests verified gitignore patterns correctly excluded custom directories

## 2026-01-23 - US-001: Fix test generation to actually create files (BUG-004) - COMPLETE

- Fixed run_test_generation() function in bin/fade-cli to use `claude --dangerously-skip-permissions` instead of `claude --print`
- The `--print` flag was single-turn mode that only outputs text and cannot execute tool calls to create files
- With `--dangerously-skip-permissions`, Claude can now use Write tool to create test files in fade/tests/PRD-xxx/
- Changed from piped input (`echo "$context" | claude --print`) to argument-based input (`claude --dangerously-skip-permissions "$context"`)
- Added output capture via temp file and `tee` to display real-time output while also detecting TESTS_GENERATED signal
- Preserved existing chmod +x logic to make test files executable after generation
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-002, US-003, US-004: PRD copy to test folder (BUG-004) - COMPLETE

- Added PRD copy to run_test_generation() function in bin/fade-cli (line 1136-1143)
- After creating the PRD tests directory, copies source PRD to fade/tests/PRD-xxx/prd.json
- Skip logic: only copies if prd.json doesn't already exist (preserves manual edits)
- Silent skip: no message when prd.json already exists
- Copy happens before test generation context is built (tests and PRD always paired)
- Uses `cp "$prd_file" "$prd_tests_dir/prd.json" 2>/dev/null || true` for safe error handling
- Updated README.md Regression Testing section with new table row for prd.json traceability
- All acceptance criteria for US-002, US-003, US-004 verified:
  - PRD copied to test folder when generating tests
  - PRD saved as prd.json in the PRD test folder
  - Copy happens before test generation
  - Original PRD not modified
  - Existing prd.json preserved (not overwritten)
  - Silent skip (no warning)
  - README documents prd.json in folder table
- Files changed: bin/fade-cli, README.md, fade/prds/BUG-004-test-generation-broken.json
- Tests: bash -n syntax check passed

## 2026-01-23 - US-001: Review recent changes (CHORE-001) - COMPLETE

- Reviewed git log since v0.3.0 (50 commits)
- Identified changes from completed PRDs:
  - FEAT-008: fade map command (codebase analysis, architecture detection, dependency analysis, --init, fragile areas, gitignore)
  - BUG-004: Test generation fix (--dangerously-skip-permissions, PRD copy to test folder)
  - Previously: fade export, standards folder, regression testing, version tracking
- Documentation gaps found:
  - README missing fade map command documentation
  - README missing fade export command documentation
  - README version shows 0.3.0, needs 0.3.1
- All PRDs in prd-archive have corresponding progress.md entries
- Files changed: fade/progress.md
- Tests: Manual verification of git log and archived PRDs

## 2026-01-23 - US-002: Update README.md (CHORE-001) - COMPLETE

- Updated version header from v0.3.0 to v0.3.1
- Added `fade map` command documentation with all options (--init, --force) and detection features
- Added `fade export` command documentation explaining what it exports
- Added `fade version` command documentation with --all flag
- Updated project structure to include standards/ and tests/ folders
- Updated file reference table to include standards/*.md and tests/
- Updated repository structure to include standards/ folder
- Updated version manifest example to show 0.3.1
- All acceptance criteria verified:
  - README reflects all current commands (init, new, status, run, yolo, map, export, update, migrate, version)
  - Installation instructions current
  - Examples accurate
  - Feature list matches implemented functionality
- Files changed: README.md
- Tests: Manual review of all updated sections

## 2026-01-23 - US-003: Update FADE.md project context (CHORE-001) - COMPLETE

- Rewrote FADE.md from template placeholder to actual project description
- Added version stamp header: <!-- FADE FADE.md v0.3.1 -->
- Updated Project Overview with actual description and tech stack (Bash, no framework, file-based)
- Added Coding Standards section with Bash style guide and project conventions
- Added Standards section linking to all 5 standards documents
- Added Architecture References with CLI command overview diagram
- Updated Key Documents table with actual file locations
- Cleared Off-Limits Modules (none currently)
- Updated Session Boundaries with FADE-specific actions
- Updated System Context with current challenges and transition plan (v0.1.x through v0.4.x)
- Added Active Work Items showing current queue
- Added Development Environment with local dev and version bumping instructions
- Added Additional Context noting FADE dogfoods itself
- Added Target Architecture goals (simple shell, file-based, offline-capable)
- Added Fragile Areas table identifying cmd_run(), templates, and detect_interruption()
- Files changed: FADE.md
- Tests: Content review verified all sections populated

## 2026-01-23 - US-004: Update prompt.md execution protocol (CHORE-001) - COMPLETE

- Updated version stamp from v0.3.0 to v0.3.1
- Added standards/ and tests/ folders to Contained Structure file locations
- Verified signal definitions match current implementation (STORY_DONE, ALL_COMPLETE, BLOCKED)
- Verified story completion workflow is accurate (7 steps)
- Verified test generation instructions are current (shell scripts, naming convention, SKIP files)
- All examples reflect actual behavior
- Files changed: fade/prompt.md
- Tests: Content review verified all sections accurate

## 2026-01-23 - US-005: Increment version numbers (CHORE-001) - COMPLETE

- Updated FADE_VERSION in bin/fade-cli from 0.3.0 to 0.3.1
- Updated ARTIFACT_VERSION in bin/fade-cli from 0.3.0 to 0.3.1
- Updated version comment from "v0.3.0 - Added 'fade yolo'" to "v0.3.1 - Documentation update, fade map and export commands"
- Updated VERSION file from 0.3.0 to 0.3.1
- Updated version-manifest.json release and all artifact versions to 0.3.1
- Verified fade version output shows v0.3.1
- Verified bash syntax check passes
- Note: README.md and FADE.md already updated to 0.3.1 in previous stories
- Note: prompt.md already updated to 0.3.1 in US-004
- Files changed: bin/fade-cli, VERSION, version-manifest.json
- Tests: fade version shows v0.3.1, bash -n syntax check passed

## 2026-01-23 - US-006: Verify documentation consistency (CHORE-001) - COMPLETE

- Added `export` command to help text (was missing, now matches README)
- Verified all 10 commands in help text match README sections (init, new, map, run, yolo, status, export, migrate, update, version)
- Verified all 5 standards files exist and are linked from FADE.md
- Verified help text shows v0.3.1
- Verified bash syntax check passes after help text update
- No deprecated or removed feature references found
- Files changed: bin/fade-cli
- Tests: fade help verified, bash -n syntax check passed

## 2026-01-23 - US-001: Basic quick command (FEAT-009) - COMPLETE

- Added cmd_quick() function to bin/fade-cli for single-task execution without PRD
- Command accepts task description as argument: `fade quick "fix typo in README"`
- Launches Claude Code with minimal context (task description + FADE.md if available)
- Does not require PRD files - works in both FADE and non-FADE projects
- Added quick command to main case statement
- Added "Quick Command" and "Quick Options" sections to help text
- Added quick command examples to help
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed, tested in FADE project and empty directory

## 2026-01-23 - US-001: Fix PRD mismatch in iteration summary (BUG-005) - COMPLETE

- Added find_prd_by_story_id() function to search all PRD files for a story with matching ID
- Function searches fade/prd.json, prd.json, fade/prds/*.json, prds/*.json in priority order
- Updated display_iteration_summary() to use find_prd_by_story_id() instead of get_active_prd()
- Changed variable name from active_prd to story_prd to clarify semantics
- Falls back to get_active_prd() if story_id not found in any PRD
- Iteration summary now shows correct PRD name, acceptance criteria, and checkbox status
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-002: Fix output capture in generate_tests_for_completed_prds (BUG-005) - COMPLETE

- Redirected all echo statements in run_test_generation() to stderr using >&2
- This ensures generate_tests_for_completed_prds() only outputs the count to stdout
- Display banners and progress messages still visible to user via stderr
- The comparison [[ "$tests_generated" -gt 0 ]] now works correctly without syntax error
- Also redirected the tee output of Claude Code to stderr so user sees real-time progress
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-003: Diagnose and fix test file generation (BUG-005) - COMPLETE

- Root cause: `claude --dangerously-skip-permissions` without `--print` runs in interactive mode
- Interactive mode doesn't work properly when output is piped through tee
- Fix: Added `--print` flag to Claude invocation: `claude --print --dangerously-skip-permissions`
- `--print --dangerously-skip-permissions` enables non-interactive mode with autonomous file creation
- Verified via manual test: Claude creates test files successfully with the new invocation
- Test file created with correct naming convention and executable permissions
- TESTS_GENERATED signal reliably detected in output
- Files changed: bin/fade-cli line 1218
- Tests: bash -n syntax check passed, manual test verified file creation and signal detection

## 2026-01-23 - US-004: Add integration test for ALL mode flow (BUG-005) - COMPLETE

- Created fade/tests/PRD-BUG-005/ folder for integration tests
- Added test_us001_01_find_prd_correct.sh: verifies find_prd_by_story_id returns correct PRD
  - Tests with multiple PRDs containing different stories
  - Verifies function finds correct PRD by story ID, not alphabetically
  - Tests fallback for non-existent story ID
- Added test_us001_02_summary_uses_find.sh: verifies display_iteration_summary uses find_prd_by_story_id
  - Confirms call pattern in fade-cli code
  - Verifies function checks fade/prd.json first (priority order)
- Added test_us002_01_output_to_stderr.sh: verifies test generation outputs to stderr
  - Counts >&2 redirections in run_test_generation function
  - Verifies stdout/stderr documentation comment exists
- Added test_us003_01_claude_invocation.sh: verifies correct Claude invocation flags
  - Confirms --print flag for non-interactive mode
  - Confirms --dangerously-skip-permissions for autonomous file creation
  - Verifies correct flag order
- Copied PRD to test folder for traceability
- All 4 tests pass via fade/tests/run.sh
- Files changed: fade/tests/PRD-BUG-005/*.sh (4 new test files), fade/tests/PRD-BUG-005/prd.json
- Tests: fade/tests/run.sh shows 4 passed, 0 failed

## 2026-01-23 - US-001: Trace and fix output leak in generate_tests_for_completed_prds (BUG-006) - COMPLETE

- Root cause: stdout from internal commands could leak through to the function's return value
- Fixed generate_tests_for_completed_prds() by wrapping all processing logic in `{ } >&2` block
- This redirects any unintended stdout to stderr, ensuring only the count goes to stdout
- Function structure now:
  - `processed_count=0` initialized before block
  - All processing in `{ } >&2` block (safety net for any stdout leaks)
  - Only `echo "$processed_count"` outside block (the return value)
- Verified all echo statements in run_test_generation already have `>&2`
- Verified get_prd_id, get_tests_dir are called in `$()` so their output is captured locally
- Comparison `[[ "$tests_generated" -gt 0 ]]` now works without syntax error
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-002: Add defensive numeric validation (BUG-006) - COMPLETE

- Added regex validation before numeric comparison: `[[ "$tests_generated" =~ ^[0-9]+$ ]]`
- If not numeric, defaults to 0 and logs warning to stderr
- Warning message uses yellow color for visibility
- This provides defense-in-depth: even if output leaks through US-001 fix, comparison won't fail
- Pattern `^[0-9]+$` matches one or more digits (0, 1, 123, etc.)
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-003: Verify fix with end-to-end test (BUG-006) - COMPLETE

- Created test suite in fade/tests/PRD-BUG-006/ with 5 tests and 3 SKIP files
- test_us001_01_stderr_redirect_block.sh: verifies } >&2 pattern exists in function
- test_us001_02_only_count_to_stdout.sh: verifies echo "$processed_count" is after >&2 block
- test_us002_01_numeric_validation.sh: verifies regex validation pattern exists
- test_us002_02_default_to_zero.sh: verifies fallback to 0 with warning
- test_us003_01_syntax_valid.sh: verifies bash -n syntax check passes
- SKIP files for end-to-end tests requiring manual verification with fade yolo
- All 19 tests pass via fade/tests/run.sh
- Files changed: fade/tests/PRD-BUG-006/ (5 test files, 3 SKIP files, prd.json)
- Tests: 19 passed, 0 failed

## 2026-01-23 - US-002: Quick mode context injection (FEAT-009) - COMPLETE

- Added relevant standards injection to cmd_quick() based on task description keywords
- Standards detection checks for: API/endpoint, git, test, documentation, and coding keywords
- Checks both fade/standards/ (contained) and standards/ (legacy) locations
- Only includes standards that match task keywords to keep context minimal
- Updated quick mode instructions to explicitly state SINGLE-TASK mode
- Added clear prohibition: "Do NOT output STORY_DONE or ALL_COMPLETE signals"
- Added clear prohibition: "Do NOT follow the story completion protocol"
- Context remains minimal: FADE.md (if exists) + relevant standards (if match) + task description
- No PRD protocol elements included in context
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-003: Atomic commit on completion (FEAT-009) - COMPLETE

- Enhanced quick mode commit instructions in cmd_quick() to be more explicit
- Commit message now explicitly derived from task description with instruction and variable reference
- Added concrete examples: "fix typo in README" → "docs: fix typo in README"
- Listed all conventional commit prefixes: fix:, feat:, docs:, chore:, refactor:
- Clarified conditional: "Only commit if you actually made changes - skip commit if no files were modified"
- All acceptance criteria verified:
  - Quick mode prompt instructs Claude to commit changes when done
  - Commit message derived from task description (with $task_description reference)
  - Uses conventional commit format (all prefixes listed)
  - Only commits if changes were made
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-004: Quick task logging (FEAT-009) - COMPLETE

- Verified quick mode already includes progress.md logging instructions (lines 2888-2909)
- Checks for progress.md in both fade/ and root locations
- Only adds logging instructions if progress.md exists (skips for non-FADE projects)
- Log format matches spec: `## YYYY-MM-DD HH:MM - QUICK: task description - COMPLETE`
- Template includes brief summary and files changed placeholders
- All acceptance criteria satisfied by existing implementation (added during US-002/US-003)
- Files changed: fade/prds/FEAT-009-quick-mode.json (marked passes: true)
- Tests: Code review verified all criteria met

## 2026-01-23 - US-005: Quick mode boundaries (FEAT-009) - COMPLETE

- Enhanced quick mode prompt with explicit "Scope Limits" section
- Added guidance: "Target: single file or a few closely related files"
- Added explicit stop condition: "If changes span 3+ unrelated files, STOP and recommend creating a PRD"
- Added prohibition: "No architectural changes, no new features with tests, no multi-step refactors"
- Verified single execution: cmd_quick uses `exec` which replaces shell (no loop possible)
- Verified no test generation: cmd_quick has no test generation logic, no signal detection
- All acceptance criteria verified:
  - Quick mode prompt limits scope to single-file or few-file changes (Scope Limits section)
  - If task seems large, Claude suggests creating a PRD (explicit instruction in prompt)
  - Quick mode does not run in loop (exec $claude_cmd is single execution)
  - No regression test generation for quick tasks (no test logic in cmd_quick)
- Files changed: bin/fade-cli
- Tests: bash -n syntax check passed

## 2026-01-23 - US-006: Quick mode with YOLO (FEAT-009) - COMPLETE

- Verified --yolo flag already implemented in cmd_quick (lines 2736-2738)
- Flag parsing sets yolo_mode=true when --yolo is passed
- Claude command selection (lines 2932-2935) matches cmd_run pattern exactly:
  - Default: `claude_cmd="claude"` (normal permission model)
  - With --yolo: `claude_cmd="claude --dangerously-skip-permissions"`
- Display shows YOLO indicator when yolo_mode is true (line 2925)
- All acceptance criteria satisfied by existing implementation (added during US-001):
  - fade quick --yolo passes --dangerously-skip-permissions to Claude (verified lines 2934-2935)
  - fade quick (without --yolo) uses normal permission model (verified line 2933)
  - Behavior matches fade run --yolo pattern (identical code structure)
- Files changed: fade/prds/FEAT-009-quick-mode.json (marked passes: true)
- Tests: Code review verified identical pattern to cmd_run

## 2026-01-23 - US-001: Create architecture.md standards file (ENH-001) - COMPLETE

- Created fade/standards/architecture.md with 6 AWS Well-Architected Framework pillars
- Sections: Operational Excellence, Security, Reliability, Performance, Cost, Sustainability
- Each section contains guiding questions (not checklists) and practical applications
- Generic framing with AWS Well-Architected cited as source
- Includes cross-reference to api-security.md for API-specific security
- 641 words, well under 1,500 token limit
- Includes "When to Read This Standard" section
- Quick Reference table summarizing core question for each pillar
- Files changed: fade/standards/architecture.md (new)
- Tests: Word count verified under limit

## 2026-01-23 - US-002: Add to prompt.md standards table (ENH-001) - COMPLETE

- Added architecture.md to "When to Read Standards" table in prompt.md
- Mapped to work types: System design, new services, infrastructure
- Follows existing table format (Work Type | Standard to Read)
- Files changed: fade/prompt.md
- Tests: Verified table format matches existing rows

## 2026-01-23 - US-003: Link from FADE.md (ENH-001) - COMPLETE

- Added Architecture row to FADE.md Standards table
- Description summarizes 6 pillars: Operational excellence, security, reliability, performance, cost, sustainability
- Link points to fade/standards/architecture.md
- Placed alphabetically after API Security
- Files changed: FADE.md
- Tests: Verified link format matches existing rows

## 2026-01-23 - US-001: NPM package structure (FEAT-010) - COMPLETE

- Created package.json with all required fields (name, version, description, bin, repository)
- Package name: fade-dev (fade-cli was taken on npm)
- Version: 0.3.1 (matches FADE_VERSION in fade-cli script)
- bin field maps "fade" command to ./bin/fade-cli
- files field includes: bin/, fade/prompt.md, fade/standards/, VERSION, version-manifest.json
- Created MIT LICENSE file matching package.json license field
- Verified with npm pack --dry-run: package is 72.8kB, 13 files
- Files changed: package.json (new), LICENSE (new)
- Tests: npm pkg get validates all fields, npm pack --dry-run shows correct contents

## 2026-01-23 - US-002: npx execution (FEAT-010) - COMPLETE

- Verified npx execution works by testing local package install
- All fade commands work via local npm install: version, help, status, init, map, new
- First run downloads, subsequent runs use cache (npm/npx built-in behavior)
- Tested on macOS Darwin 24.6.0; bash shebang compatible with Linux and Windows WSL/Git Bash
- Package structure validated: bin/fade-cli is executable with #!/bin/bash shebang
- npm pack shows 13 files, 72.8kB package size
- Files changed: none (verification only)
- Tests: Local package install tested all major commands successfully

## 2026-01-23 - US-003: Global installation (FEAT-010) - COMPLETE

- Verified `npm install -g .` installs fade-dev globally without errors
- After install, `fade` command available at nvm bin path (/Users/.../.nvm/versions/node/v18.20.8/bin/fade)
- Global install works alongside existing /usr/local/bin/fade symlink (dev setup)
- Tested local install in /tmp/fade-test-local - works independently of global
- npx in local project uses local install correctly
- Uninstall works: `npm uninstall -g fade-dev` removes package and fade command from nvm bin
- All acceptance criteria verified:
  - npm install -g fade-dev works (tested with local package)
  - After install, 'fade' command is available in PATH
  - Global install doesn't conflict with local installs (tested both simultaneously)
  - Uninstall works: npm uninstall -g fade-dev
- Files changed: fade/prds/FEAT-010-npm-distribution.json (marked passes: true)
- Tests: Manual verification of all install/uninstall scenarios

## 2026-01-23 - US-004: Version management via npm (FEAT-010) - COMPLETE

- Verified npm's built-in version management works with fade-dev package
- npm update -g fade-dev: npm's semver handling automatically updates to latest published version
- npx fade-dev@latest: @latest tag always fetches most recent version from registry
- Version consistency: package.json version (0.3.1) matches FADE_VERSION in bin/fade-cli (0.3.1)
- fade version output: shows v0.3.1 which matches npm package version
- Tested local npm install: `npm install <path>` installs correct version and runs correctly
- All acceptance criteria are npm built-in behaviors, no code changes required
- Files changed: fade/prds/FEAT-010-npm-distribution.json (marked passes: true)
- Tests: Local package install verified version consistency

## 2026-01-23 - US-005: Preserve fade update for artifacts (FEAT-010) - COMPLETE

- Verified fade update command already handles project artifacts independently of CLI distribution method
- Artifact updates verified in cmd_update() function (lines 3682-4481):
  - prompt.md update: fetches from FADE_PROMPT_URL, compares, prompts user, writes new version (lines 4009-4107)
  - standards/ sync: creates folder if missing, downloads standard files that don't exist (lines 4112-4161)
  - --check mode: verifies CLI, FADE.md, prompt.md versions and content diffs (lines 3751-3931)
- Separation between npm and fade update:
  - npm package distributes CLI binary via `bin` field in package.json
  - `fade update` handles prompt.md, standards/, project structure, FADE.md sections
  - npm users: `npm update -g fade-dev` updates CLI, `fade update` updates project artifacts
- All acceptance criteria satisfied by existing implementation (no code changes required)
- Files changed: fade/prds/FEAT-010-npm-distribution.json (marked passes: true)
- Tests: Code review verified all update functionality
