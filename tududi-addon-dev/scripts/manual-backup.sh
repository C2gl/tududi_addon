#!/usr/bin/with-contenv bashio
# Manual backup script for Tududi
# Creates a backup of database and uploads to /share/tududi_backups

set -e

bashio::log.info "🔄 Starting manual Tududi backup..."

# Configuration
CONFIG_PATH=/data/options.json
DB_FILE=$(jq --raw-output '.db_file // "/data/production.sqlite3"' "$CONFIG_PATH")
UPLOAD_PATH=$(jq --raw-output '.upload_path // "/data/uploads"' "$CONFIG_PATH")
BACKUP_DIR="/share/tududi_backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="tududi_backup_${TIMESTAMP}"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

# Create backup directory
bashio::log.info "Creating backup directory: ${BACKUP_PATH}"
mkdir -p "${BACKUP_PATH}"

# Checkpoint database before backup
if [ -f "$DB_FILE" ] && command -v sqlite3 &> /dev/null; then
    bashio::log.info "Running database checkpoint..."
    sqlite3 "$DB_FILE" "PRAGMA wal_checkpoint(TRUNCATE);" || bashio::log.warning "Checkpoint failed"
fi

# Backup database
if [ -f "$DB_FILE" ]; then
    bashio::log.info "Backing up database: ${DB_FILE}"
    cp "$DB_FILE" "${BACKUP_PATH}/production.sqlite3"
    
    # Also backup WAL and SHM files if they exist
    if [ -f "${DB_FILE}-wal" ]; then
        cp "${DB_FILE}-wal" "${BACKUP_PATH}/production.sqlite3-wal"
    fi
    if [ -f "${DB_FILE}-shm" ]; then
        cp "${DB_FILE}-shm" "${BACKUP_PATH}/production.sqlite3-shm"
    fi
else
    bashio::log.warning "Database file not found: ${DB_FILE}"
fi

# Backup uploads directory
if [ -d "$UPLOAD_PATH" ]; then
    bashio::log.info "Backing up uploads: ${UPLOAD_PATH}"
    cp -r "$UPLOAD_PATH" "${BACKUP_PATH}/uploads"
else
    bashio::log.warning "Upload directory not found: ${UPLOAD_PATH}"
    mkdir -p "${BACKUP_PATH}/uploads"
fi

# Create metadata file
bashio::log.info "Creating backup metadata..."
cat > "${BACKUP_PATH}/metadata.json" <<EOF
{
  "timestamp": "${TIMESTAMP}",
  "date": "$(date '+%Y-%m-%d %H:%M:%S %Z')",
  "version": "$(jq -r '.version // "unknown"' /data/version.json 2>/dev/null || echo 'dev-20251102')",
  "db_file": "${DB_FILE}",
  "upload_path": "${UPLOAD_PATH}",
  "backup_type": "manual"
}
EOF

# Calculate backup size
BACKUP_SIZE=$(du -sh "${BACKUP_PATH}" | cut -f1)

bashio::log.info "✅ Backup completed successfully!"
bashio::log.info "Location: ${BACKUP_PATH}"
bashio::log.info "Size: ${BACKUP_SIZE}"

# Optional: Clean up old backups (keep last 7 days by default)
RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-7}
if [ "$RETENTION_DAYS" -gt 0 ]; then
    bashio::log.info "Cleaning up backups older than ${RETENTION_DAYS} days..."
    find "${BACKUP_DIR}" -maxdepth 1 -type d -name "tududi_backup_*" -mtime "+${RETENTION_DAYS}" -exec rm -rf {} \; 2>/dev/null || true
fi

exit 0
