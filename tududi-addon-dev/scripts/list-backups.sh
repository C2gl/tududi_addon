#!/usr/bin/with-contenv bashio
# List available backups script for Tududi

set -e

BACKUP_DIR="/share/tududi_backups"

bashio::log.info "📦 Available Tududi Backups"
bashio::log.info "=========================="

if [ ! -d "$BACKUP_DIR" ]; then
    bashio::log.warning "No backup directory found at ${BACKUP_DIR}"
    exit 0
fi

# Count backups
BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "tududi_backup_*" | wc -l)

if [ "$BACKUP_COUNT" -eq 0 ]; then
    bashio::log.info "No backups found"
    exit 0
fi

bashio::log.info "Found ${BACKUP_COUNT} backup(s):"
echo ""

# List backups with details
for backup in "$BACKUP_DIR"/tududi_backup_*; do
    if [ -d "$backup" ]; then
        BACKUP_NAME=$(basename "$backup")
        SIZE=$(du -sh "$backup" 2>/dev/null | cut -f1)
        
        # Extract timestamp from backup name
        TIMESTAMP="${BACKUP_NAME#tududi_backup_}"
        DATE_PART="${TIMESTAMP:0:8}"
        TIME_PART="${TIMESTAMP:9:6}"
        
        # Format as readable date
        FORMATTED_DATE="${DATE_PART:0:4}-${DATE_PART:4:2}-${DATE_PART:6:2}"
        FORMATTED_TIME="${TIME_PART:0:2}:${TIME_PART:2:2}:${TIME_PART:4:2}"
        
        echo "  📁 ${BACKUP_NAME}"
        echo "     Date: ${FORMATTED_DATE} ${FORMATTED_TIME}"
        echo "     Size: ${SIZE}"
        
        # Show metadata if available
        if [ -f "$backup/metadata.json" ]; then
            VERSION=$(jq -r '.version // "unknown"' "$backup/metadata.json" 2>/dev/null || echo "unknown")
            BACKUP_TYPE=$(jq -r '.backup_type // "unknown"' "$backup/metadata.json" 2>/dev/null || echo "unknown")
            echo "     Version: ${VERSION}"
            echo "     Type: ${BACKUP_TYPE}"
        fi
        echo ""
    fi
done

bashio::log.info "To restore a backup, run:"
bashio::log.info "  /scripts/restore.sh <backup_name>"

exit 0
