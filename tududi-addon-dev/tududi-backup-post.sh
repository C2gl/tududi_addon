#!/usr/bin/with-contenv bashio
# Post-backup script for Tududi addon
# This script runs after Home Assistant has taken a backup

bashio::log.info "Starting Tududi post-backup procedures..."

# Check if backup timestamp exists
if [ -f "/data/backup_timestamp.txt" ]; then
    BACKUP_TIME=$(cat /data/backup_timestamp.txt)
    bashio::log.info "Backup was initiated at: $BACKUP_TIME"
    
    # Clean up backup timestamp file
    rm -f /data/backup_timestamp.txt
else
    bashio::log.warning "Backup timestamp file not found"
fi

# Optional: Clean up any temporary files that might have been created
# during the backup process
if [ -d "/data/temp" ]; then
    find /data/temp -type f -name "*.tmp" -delete 2>/dev/null || true
    bashio::log.info "Cleaned up temporary files"
fi

# Log completion
bashio::log.info "Post-backup procedures completed successfully"