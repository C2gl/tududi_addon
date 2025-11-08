# Changelog

All notable changes to this add-on will be documented in this file.
This is the changelog for the dev add-on.

## [0.0.11-rc.03] - 2025-11-08
- **BUMPED:** bumped to v0.86-rc.3 for tududi
https://github.com/chrisvel/tududi/releases/tag/v0.86-rc.3
## [0.0.11-dev.07] - 2025-01-07

### Fixed
- **API Endpoints**: Re-added proper API path rewriting to ensure `/api/` calls work within ingress context
- **HTML Asset References**: Added rewriting for PNG file references directly in index.html
- **Login Graphics**: Enhanced rewriting coverage for login-gfx.png in all file types

## [0.0.11-dev.06] - 2025-01-07

### Fixed
- **API Endpoints**: Removed incorrect rewriting of `/api/` paths that was breaking profile API calls
- **Logo Assets**: Added specific rewriting for `wide-logo-light.png` and `login-gfx.png` files
- **Asset Copying**: Enhanced PNG file copying from public directory to ensure logo assets are available
- **Path Resolution**: Fixed absolute path references for logo files in JavaScript

## [0.0.11-dev.03.2] - 2025-01-06

### Fixed
- **Static Assets**: Enhanced comprehensive asset path rewriting for v0.86-beta.3
  - Added JavaScript rewriting for images/, logo/, and fonts/ paths  
  - Added CSS url() path rewriting for all asset references
  - Fixed absolute path issues introduced in Tududi v0.86-beta.3 logo system

### Changed
- **Tududi Version**: Updated to v0.86-beta.3 (latest upstream)

## [0.0.11-dev.03.1] - 2025-11-06

### Fixed
- **Static Assets**: Fixed display issues with illustrations and static content in v0.86-beta.3


### Notes
- The fix for static assets will need to be added to the main branch in a future release.
### Technical Changes
- Enhanced Dockerfile with additional sed commands for asset path rewriting
- Covers new static asset directories introduced in Tududi v0.86-beta.3

## [0.0.11-dev.03] - 2025-11-06

- **BUMP:** to the newest beta 3 of tududi 86

## [0.0.11-dev.02] - 2025-11-05

### Updated
- 🆙 **Tududi Core**: Updated to v0.86-beta.2 (latest beta release)
- 🧪 **Testing**: This version includes the latest upstream features and fixes
- 🏗️ **Architecture**: Temporarily removed aarch64 support to fix "exec format error"

### Notes
- Based on Tududi v0.86-beta.2 beta release
- Only AMD64 architecture supported in this release
- Includes all backup functionality from previous version

## [0.0.11-dev.01] - 2025-11-04

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

## [dev-20251104] - 2025-11-04

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

## [dev-20251102] - 2025-11-04

### Added
- initialised seperate dev branch to avoid breaking stuff on the main branch.