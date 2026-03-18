# Changelog

All notable changes to this add-on will be documented in this file.

## 0.88.5
**BUMPED:** bumped to tududi v0.88.5 (stable release)

**IMPROVED:** Session secret auto-generation
- When `tududi_session_secret` is not set (the default), the addon now
  auto-generates a cryptographically strong 64-byte hex secret on first
  start and persists it to `/data/.session_secret` (chmod 600).
- Sessions now survive addon restarts without any user configuration.
- The config field is now optional (`str?`) and hidden from the default
  options UI. Power users can still set it manually as an override.
- Previously, leaving the secret empty meant sessions were lost on every
  restart and a warning was logged asking the user to configure it.

**TUDUDI CHANGELOG:**
    Fix SQLite migration failure when removing uuid column from tasks by @chrisvel in #787
    Fix issue with dropdown spilling over by @chrisvel in #788
    Fix task detail status change by @chrisvel in #789
    Fix subtask completion auto-completing parent task by @chrisvel in #792
    Set stalled projects active without tasks by @chrisvel in #793
    Change relative path by @chrisvel in #794
    Clear local storage on selection by @chrisvel in #795
    Fix link to First Steps in README.md by @korantu in #805

## v0.88.5-rc.1
**BUMPED:** bumped to tududi v0.88.5-rc.1 (pre-release)

## 0.2.1
**BUMPED:** bumped tududi to v0.86.1

## 0.2.0
**BUMPED:** bumped tududi to v0.86

## 0.1.0
- **RELEASED:** Minimal viable product release.
