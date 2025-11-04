# Changelog

All notable changes to this add-on will be documented in this file.
This is the changelog for the dev add-on.

## [0.0.11-dev.01] - 2024-11-04

### Added
- 🔄 **Home Assistant Backup Support**: Full integration with HA's built-in backup system
- 📦 Hot backup functionality - add-on continues running during backups
- 🔧 Pre-backup script to ensure database consistency
- 🧹 Post-backup script for cleanup operations
- 📂 Smart backup exclusions for temporary files, logs, and cache
- 🔐 Backup role permissions for proper HA integration

### Technical Details
- Added `backup: "hot"` configuration
- Implemented pre/post backup scripts with bashio integration
- Added backup exclusion patterns for `*.log`, `/data/temp/*`, `/data/cache/*`
- Set `hassio_role: backup` for proper supervisor permissions

### Notes
- Your Tududi data (database, uploads, config) will now be included in HA backups automatically
- Backup scripts provide logging for troubleshooting
- No user action required - backup integration is automatic

## [dev-20251104] - 2024-11-04

### Added
- 🔄 **Home Assistant Backup Support**: Full integration with HA's built-in backup system
- 📦 Hot backup functionality - add-on continues running during backups
- 🔧 Pre-backup script to ensure database consistency
- 🧹 Post-backup script for cleanup operations
- 📂 Smart backup exclusions for temporary files, logs, and cache
- 🔐 Backup role permissions for proper HA integration

### Technical Details
- Added `backup: "hot"` configuration
- Implemented pre/post backup scripts with bashio integration
- Added backup exclusion patterns for `*.log`, `/data/temp/*`, `/data/cache/*`
- Set `hassio_role: backup` for proper supervisor permissions

### Notes
- Your Tududi data (database, uploads, config) will now be included in HA backups automatically
- Backup scripts provide logging for troubleshooting
- No user action required - backup integration is automatic

## [dev-20251102] - 2024-11-04

### Added
- initialised seperate dev branch to avoid breaking stuff on the main branch.