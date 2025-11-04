#!/usr/bin/with-contenv bashio
# Pre-backup script for Tududi addon
# This script runs before Home Assistant takes a backup

bashio::log.info "Starting Tududi pre-backup procedures..."

# Check if the database file exists
DB_FILE=$(bashio::config 'db_file')
if [ -f "$DB_FILE" ]; then
    bashio::log.info "Database file found at: $DB_FILE"
    
    # Ensure database is properly closed/synced
    # If Tududi is running and has an open connection, we might want to signal it
    # to flush any pending writes to disk
    
    # Create a backup timestamp
    echo "$(date -Iseconds)" > /data/backup_timestamp.txt
    
    bashio::log.info "Database backup preparations completed"
else
    bashio::log.warning "Database file not found at: $DB_FILE"
fi

# Log current data directory size for reference
DATA_SIZE=$(du -sh /data 2>/dev/null | cut -f1)
bashio::log.info "Current /data directory size: $DATA_SIZE"

bashio::log.info "Pre-backup procedures completed successfully"