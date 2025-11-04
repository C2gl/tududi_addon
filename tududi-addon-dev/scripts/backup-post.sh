#!/usr/bin/with-contenv bashio
# Post-backup script for Tududi addon
# This script runs after the backup is complete

set -e

bashio::log.info "✅ Backup completed successfully"

# Optional: Log backup completion with timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
bashio::log.info "Backup finished at ${TIMESTAMP}"

# Optional: You could add cleanup tasks here if needed
# For example, removing old temporary files, etc.

exit 0
