#!/usr/bin/with-contenv bashio
# Manual restore script for Tududi
# Restores database and uploads from a backup in /share/tududi_backups

set -e

# Check if backup name is provided
if [ -z "$1" ]; then
    bashio::log.error "❌ Usage: restore.sh <backup_name>"
    bashio::log.info "Available backups:"
    ls -1 /share/tududi_backups/ 2>/dev/null | grep "^tududi_backup_" || bashio::log.info "  (none found)"
    exit 1
fi

BACKUP_NAME="$1"
BACKUP_DIR="/share/tududi_backups"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

# Validate backup exists
if [ ! -d "$BACKUP_PATH" ]; then
    bashio::log.error "❌ Backup not found: ${BACKUP_PATH}"
    bashio::log.info "Available backups:"
    ls -1 "${BACKUP_DIR}/" 2>/dev/null | grep "^tududi_backup_" || bashio::log.info "  (none found)"
    exit 1
fi

bashio::log.warning "⚠️  RESTORING FROM BACKUP: ${BACKUP_NAME}"
bashio::log.warning "⚠️  This will OVERWRITE current data!"

# Read current configuration
CONFIG_PATH=/data/options.json
DB_FILE=$(jq --raw-output '.db_file // "/data/production.sqlite3"' "$CONFIG_PATH")
UPLOAD_PATH=$(jq --raw-output '.upload_path // "/data/uploads"' "$CONFIG_PATH")

# Show backup metadata if available
if [ -f "${BACKUP_PATH}/metadata.json" ]; then
    bashio::log.info "Backup metadata:"
    cat "${BACKUP_PATH}/metadata.json" | jq . || cat "${BACKUP_PATH}/metadata.json"
fi

# Create backup of current data before restore
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TEMP_BACKUP="/data/pre_restore_backup_${TIMESTAMP}"
bashio::log.info "Creating safety backup of current data to: ${TEMP_BACKUP}"
mkdir -p "${TEMP_BACKUP}"

if [ -f "$DB_FILE" ]; then
    cp "$DB_FILE" "${TEMP_BACKUP}/production.sqlite3" || true
fi
if [ -d "$UPLOAD_PATH" ]; then
    cp -r "$UPLOAD_PATH" "${TEMP_BACKUP}/uploads" || true
fi

# Restore database
if [ -f "${BACKUP_PATH}/production.sqlite3" ]; then
    bashio::log.info "Restoring database..."
    
    # Ensure directory exists
    mkdir -p "$(dirname "$DB_FILE")"
    
    # Copy database file
    cp "${BACKUP_PATH}/production.sqlite3" "$DB_FILE"
    
    # Restore WAL and SHM files if they exist in backup
    if [ -f "${BACKUP_PATH}/production.sqlite3-wal" ]; then
        cp "${BACKUP_PATH}/production.sqlite3-wal" "${DB_FILE}-wal"
    fi
    if [ -f "${BACKUP_PATH}/production.sqlite3-shm" ]; then
        cp "${BACKUP_PATH}/production.sqlite3-shm" "${DB_FILE}-shm"
    fi
    
    bashio::log.info "✅ Database restored"
else
    bashio::log.warning "⚠️  No database found in backup"
fi

# Restore uploads
if [ -d "${BACKUP_PATH}/uploads" ]; then
    bashio::log.info "Restoring uploads..."
    
    # Remove current uploads
    rm -rf "$UPLOAD_PATH"
    
    # Restore from backup
    cp -r "${BACKUP_PATH}/uploads" "$UPLOAD_PATH"
    
    bashio::log.info "✅ Uploads restored"
else
    bashio::log.warning "⚠️  No uploads found in backup"
fi

bashio::log.info "✅ Restore completed successfully!"
bashio::log.info "Safety backup saved at: ${TEMP_BACKUP}"
bashio::log.warning "⚠️  Please restart the addon for changes to take effect"

exit 0
