# Changelog

All notable changes to this add-on will be documented in this file.

## 0.89.0
**BUMPED:** bumped to tududi v0.89.0 (stable release)

**IMPROVED:** Simplified Dockerfile sed fixes
- Removed index.html sed rewrites (upstream publicPath and dynamic base tag handle this)
- Removed login-gfx.png sed rewrites (upstream already uses getAssetPath())
- Only logo path sed fixes remain (upstream bug: Navbar.tsx and Login.tsx
  hardcode absolute paths instead of using getAssetPath())

**IMPROVED:** Port option hidden from UI
- The port must match ingress_port (3002). Changing it breaks ingress access.
- Hidden from default options (int?) to prevent accidental misconfiguration.
- run.sh logs a warning if port is overridden to a non-3002 value.

**TUDUDI v0.89.0 CHANGELOG:**
    Fix remaining multi-weekday recurrence bugs by @chrisvel in #838
    Auto focus on new task by @chrisvel in #856
    Fix new task in mobile by @chrisvel in #857
    Update fonts to use local files by @chrisvel in #858
    Fix Sunday selection in monthly weekday recurrence by @chrisvel in #859
    Fix Telegram task display bug by escaping backslashes by @chrisvel in #860
    Fix tag validation error messages not shown to user by @chrisvel in #861
    Fix status dropdown z-index behind subtasks in project view by @chrisvel in #866
    Fix cancelled control tasks and subtasks by @chrisvel in #867
    Fix tag links for newly created tags (fixes #842) by @rylena in #843

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
