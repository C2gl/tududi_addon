#!/usr/bin/with-contenv bashio
# Pre-backup script for Tududi addon
# This script ensures the SQLite database is in a consistent state before backup

set -e

bashio::log.info "🔄 Preparing Tududi for backup..."

# Read database path from config
CONFIG_PATH=/data/options.json
DB_FILE=$(jq --raw-output '.db_file // "/data/production.sqlite3"' "$CONFIG_PATH")

# Check if database exists
if [ ! -f "$DB_FILE" ]; then
    bashio::log.warning "Database file not found at ${DB_FILE}, skipping checkpoint"
    exit 0
fi

bashio::log.info "Database: ${DB_FILE}"

# SQLite WAL (Write-Ahead Logging) checkpoint
# This ensures all pending writes from the WAL file are committed to the main database
if command -v sqlite3 &> /dev/null; then
    bashio::log.info "Running SQLite checkpoint..."
    
    # PRAGMA wal_checkpoint(TRUNCATE) ensures:
    # 1. All WAL data is transferred to the database file
    # 2. The WAL file is reset/truncated
    # 3. The database is in a consistent state
    if sqlite3 "$DB_FILE" "PRAGMA wal_checkpoint(TRUNCATE);" 2>&1; then
        bashio::log.info "✅ SQLite checkpoint completed successfully"
    else
        bashio::log.warning "⚠️ SQLite checkpoint failed, but continuing backup"
    fi
    
    # Run integrity check
    bashio::log.info "Running database integrity check..."
    INTEGRITY=$(sqlite3 "$DB_FILE" "PRAGMA integrity_check;" 2>&1 || echo "error")
    if [ "$INTEGRITY" = "ok" ]; then
        bashio::log.info "✅ Database integrity check passed"
    else
        bashio::log.warning "⚠️ Database integrity check: ${INTEGRITY}"
    fi
else
    bashio::log.warning "sqlite3 not available, skipping checkpoint"
fi

# Sync filesystem to ensure all writes are flushed to disk
sync

bashio::log.info "✅ Backup preparation complete - ready for snapshot"

exit 0
