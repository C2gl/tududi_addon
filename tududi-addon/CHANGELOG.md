# Changelog

All notable changes to this add-on will be documented in this file.

## 0.1.1
- **FIXED:** Resolved "exec /init: exec format error" by temporarily removing aarch64 support
- Multi-arch builds were causing architecture mismatches on AMD64 systems
- Only AMD64 builds are supported until multi-arch issue is resolved

## 0.1.0
- **RELEASED:** Minimal viable product release.

## 0.0.10

- **ADDED:** Translation logic to support localization 
- the EN lang file

## 0.0.9

- **ADDED:** added support for aarch64
- updated the readme
- updated package name

## 0.0.8

- **FIXED:** Re-enabled ingress with proper template literal path rewriting
- Added sed patterns to handle backtick template literals (`/api/` → `./api/`)
- Users can now use "Open Web UI" button - no manual configuration needed
- Works seamlessly with the Tududi integration for iframe embedding

## 0.0.7

- **FIXED:** Disabled Home Assistant ingress to resolve API request routing issues
- Tasks and inbox items now load correctly
- Access via direct port (3002) instead of ingress proxy path
- Added Sequelize migrations execution on startup

## 0.0.6

- Added database migration support
- Installed sequelize-cli globally in Docker image
- Migrations now run automatically on container startup
- Ensures all database schema updates from upstream Tududi are applied

## 0.0.5

- href tentative fix
- > confirmed, this did fix the login again, back to previous state where we encounter issues with the tasks retrieval and creation

## 0.0.4

- **FIXED:** Resolved startup error where addon couldn't write options.json
- Added `map` directive to config.yaml for persistent storage management
- Changed default database path from `/app/backend/db/production.sqlite3` to `/data/production.sqlite3`
- Changed default uploads path from `/app/backend/uploads` to `/data/uploads`
- Storage now persists across addon restarts and updates

## 0.0.3

- **IMPORTANT:** Changed default boot behavior from `auto` to `manual` to prevent HA crashes
- Add-on will no longer start automatically at boot by default
- Updated documentation to emphasize required configuration before first start
- This prevents crashes when add-on attempts to start without proper configuration

## 0.0.2

- pinned the v0.85.1 stable release of the tududi upstream package

## 0.0.1

- Initial release