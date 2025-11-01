# Changelog

All notable changes to this add-on will be documented in this file.

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