# Changelog

All notable changes to this add-on will be documented in this file.

## 1.0.0-rc.1
**BUMPED:** bumped to tududi v1.0.0-rc.1 (release candidate)

**TUDUDI v1.0.0-rc.1 CHANGELOG (since v1.0.0-dev.1):**
- Fix Telegram notification spam with channel-level rate limiting by @chrisvel in #951
- Add MCP Integration with client-agnostic instructions by @chrisvel in #953
- Fix date format inconsistency in Task detail screen by @chrisvel in #956

## 1.0.0-dev.1
**BUMPED:** bumped to tududi v1.0.0-dev.1 (pre-release)

**IMPROVED:** Zero sed fixes in Dockerfile
- Removed logo path sed workaround — fixed upstream in PR #946
  (Navbar.tsx and Login.tsx now use getAssetPath() for logo paths)
- Dockerfile now has zero sed fixes, all path issues resolved upstream

**TUDUDI v1.0.0-dev.1 CHANGELOG:**
- Add comprehensive LLM development documentation by @chrisvel in #939
- Fix date format inconsistency in Defer Until field by @chrisvel in #941
- Add URL detection to inbox processing service by @chrisvel in #942
- Fix notification deduplication to prevent pile-up in navbar by @chrisvel in #945
- fix: use getAssetPath() for logo images in Navbar and Login by @woytekbode in #946

## 0.89.0
**BUMPED:** bumped to tududi v0.89.0 (stable release)

**IMPROVED:** Session secret auto-generation
- When `tududi_session_secret` is not set (the default), the addon now
  auto-generates a cryptographically strong 64-byte hex secret on first
  start and persists it to `/data/.session_secret` (chmod 600).
- Sessions now survive addon restarts without any user configuration.
- The config field is now optional (`str?`) and hidden from the default
  options UI. Power users can still set it manually as an override.
- Previously, leaving the secret empty meant sessions were lost on every
  restart and a warning was logged asking the user to configure it.

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
- Fix remaining multi-weekday recurrence bugs by @chrisvel in #838
- Auto focus on new task by @chrisvel in #856
- Fix new task in mobile by @chrisvel in #857
- Update fonts to use local files by @chrisvel in #858
- Fix Sunday selection in monthly weekday recurrence by @chrisvel in #859
- Fix Telegram task display bug by escaping backslashes by @chrisvel in #860
- Fix tag validation error messages not shown to user by @chrisvel in #861
- Fix status dropdown z-index behind subtasks in project view by @chrisvel in #866
- Fix cancelled control tasks and subtasks by @chrisvel in #867
- Fix tag links for newly created tags (fixes #842) by @rylena in #843

## 0.88.5-rc.1
**BUMPED:** bumped to tududi v0.88.5-rc.1 (pre-release)

## 0.2.1
**BUMPED:** bumped tududi to v0.86.1

## 0.2.0
**BUMPED:** bumped tududi to v0.86

## 0.1.0
- **RELEASED:** Minimal viable product release.
