# Changelog

All notable changes to this add-on will be documented in this file.
this is the changelog for the dev addon

## [dev-20251104] - 2025-11-04

### Added
- **Home Assistant Backup Integration** 🎉
  - Automatic integration with Home Assistant's built-in backup system
  - Pre-backup script ensures SQLite database consistency (WAL checkpoint, integrity check)
  - Post-backup script for logging
  - Hot backup support (addon stays running during backups)
  - All data (/data directory including database and uploads) automatically included in HA snapshots
  
- **Backup scripts:**
  - `/scripts/backup-pre.sh`: Prepares database before backup (checkpoint WAL, verify integrity)
  - `/scripts/backup-post.sh`: Post-backup logging

### Changed
- Updated Dockerfile to include backup scripts
- Added backup configuration to config.yaml

### Known Issues
- **ARM64 (aarch64) builds temporarily disabled** due to persistent Node.js/Webpack compatibility issues on Alpine ARM64
  - The upstream Tududi webpack build crashes with "Illegal instruction" or symbol relocation errors on ARM64
  - This is an upstream Alpine/Node.js/Webpack compatibility issue unrelated to backup functionality
  - AMD64 builds work correctly and include full backup support

### Technical Details
- Uses SQLite `PRAGMA wal_checkpoint(TRUNCATE)` for database consistency
- Runs integrity check before backup
- Supports "hot" backups without stopping the addon
- Filesystem sync ensures all writes are committed
