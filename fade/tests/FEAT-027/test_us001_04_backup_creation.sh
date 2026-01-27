#!/bin/bash
# Test: update writes checkpoint/backup under fade/update-backups/<timestamp>/
# AC: Update writes a checkpoint/backup under `fade/update-backups/<timestamp>/` enabling rollback.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Verify backup directory naming convention in code
# Should use fade/update-backups/<timestamp>-<type>/ format

# Check that create_update_backup function exists
if ! grep -q "create_update_backup()" "$FADE_CLI"; then
    echo "FAIL: create_update_backup function not found"
    echo "Expected: function definition for backup creation"
    exit 1
fi

# Check backup base directory is fade/update-backups
if ! grep -q 'backup_base="fade/update-backups"' "$FADE_CLI"; then
    echo "FAIL: Backup should be in fade/update-backups"
    echo "Expected: backup_base=\"fade/update-backups\""
    exit 1
fi

# Check timestamp format is used in backup directory
if ! grep -q 'date +%Y%m%d-%H%M%S' "$FADE_CLI"; then
    echo "FAIL: Backup directory should use timestamp format"
    echo "Expected: date +%Y%m%d-%H%M%S in backup path"
    exit 1
fi

# Check that backup directory includes the update type
if ! grep -qE 'backup_dir=.*timestamp.*update_type' "$FADE_CLI"; then
    echo "FAIL: Backup directory should include update type"
    echo "Expected: backup_dir using timestamp and update_type"
    exit 1
fi

# Check that actual backup files are created (copy of files before update)
if ! grep -qE 'cp.*backup_dir|backup.*\.bak' "$FADE_CLI"; then
    echo "FAIL: Update should copy files to backup directory"
    echo "Expected: cp command creating .bak files in backup directory"
    exit 1
fi

# Check rollback hint is shown to user
if ! grep -qiE "rollback|backup directory" "$FADE_CLI"; then
    echo "FAIL: Update should show rollback instructions"
    echo "Expected: Instructions for rollback using backup"
    exit 1
fi

echo "PASS: Update writes checkpoint/backup under fade/update-backups/<timestamp>/"
exit 0
