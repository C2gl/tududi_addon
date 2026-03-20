# Changelog

All notable changes to this add-on will be documented in this file.

## 0.89.1
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
- Removed 60+ unnecessary sed lines. Upstream already handles path
  rewriting via `publicPath: ''`, dynamic `<base>` tag, and path helper
  functions (`getApiPath`, `getLocalesPath`, `getAssetPath`).
- Only logo path sed fixes remain (upstream bug: Navbar.tsx and Login.tsx
  hardcode absolute paths instead of using getAssetPath())

**IMPROVED:** Port option hidden from UI
- The port must match ingress_port (3002). Changing it breaks ingress access.
- Hidden from default options (int?) to prevent accidental misconfiguration.
- run.sh logs a warning if port is overridden to a non-3002 value.

## 0.89.0
**BUMPED:** bumped to tududi v0.89.0

## 0.88.4
**BUMPED:** bumped to tududi v0.88.4


## 0.88.2
**BUMPED:** bumped to tududi v0.88.2

**TUDUDI CHANGELOG:**
- Fix sql issue by @chrisvel in chrisvel/tududi#723
- Cleanup statuses by @chrisvel in chrisvel/tududi#724
- Fix task long titles by @chrisvel in chrisvel/tududi#726
- Fix recur instance done by @chrisvel in chrisvel/tududi#727

## 0.88.0
**BUMPED:** bumped to tududi V0.88.0

## 0.87
**BUMPED:** bumped to tududi V0.87

## 0.2.1
**BUMPED:** bumped tududi to v0.86.1

## 0.2.0
**BUMPED:** bumped tududi to v0.86

## 0.1.1
- **FIXED:** Resolved "exec /init: exec format error" by temporarily removing aarch64 support

## 0.1.0
- **RELEASED:** Minimal viable product release.
