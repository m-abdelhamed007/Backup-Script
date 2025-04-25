#!/bin/bash

SOURCE_DIR="/var/www"
BACKUP_DIR="$HOME/backup"
RETENTION_DAYS=7
LOG_FILE="$HOME/backup.log"
LOG_RETENTION=5
EMAIL="admin@example.com"

DATE=$(date +"%Y-%m-%d")
DAY_OF_WEEK=$(date +"%u")

mkdir -p "$BACKUP_DIR" || {
    echo "ERROR: Failed to create backup directory" | mail -s "Backup Failed" "$EMAIL"
    exit 1
}

BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting backup for $date of week" >> "$LOG_FILE"

if tar -czf "$BACKUP_FILE" "$SOURCE_DIR"; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup successful: $BACKUP_FILE" >> "$LOG_FILE"

    find "$BACKUP_DIR" -type f -name "backup-*.tar.gz" -mtime +$RETENTION_DAYS -delete
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaned up backups older than $RETENTION_DAYS days" >> "$LOG_FILE"
else
    ERROR_MSG="Failed to create backup file"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $ERROR_MSG" >> "$LOG_FILE"
    echo "$ERROR_MSG" | mail -s "Backup Failed" "$EMAIL"
    exit 1
fi

if [ -f "$LOG_FILE" ]; then
    LOG_DIR="$HOME/logs"
    mkdir -p "$LOG_DIR"

    LOG_ARCHIVE="$LOG_DIR/backup-$(date +"%Y%m%d-%H%M%S").log"
    cp "$LOG_FILE" "$LOG_ARCHIVE"

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Log archived to $LOG_ARCHIVE" > "$LOG_FILE"

    ls -t "$LOG_DIR"/backup-*.log | tail -n +$((LOG_RETENTION+1)) | xargs -r rm
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaned old logs, keeping $LOG_RETENTION most recent" >> "$LOG_FILE"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup process completed" >> "$LOG_FILE"
exit 0
