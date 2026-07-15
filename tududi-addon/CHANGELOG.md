# Changelog

All notable changes to this add-on will be documented in this file.

## 1.2.4
**BUMPED:** bumped to tududi v1.2.4 (from v1.0.0)

Brings the stable addon to full parity with the dev addon (1.2.4.1). Upstream
progressed v1.0.0 -> v1.1.0 -> v1.1.1 -> v1.2.0 -> v1.2.1 -> v1.2.3 -> v1.2.4;
full upstream notes: https://github.com/chrisvel/tududi/releases

**FIXED:** 401-after-login behind HA Ingress
- `run.sh` now exports `TUDUDI_TRUST_PROXY` (default `true`). Since v1.0.0
  (upstream #1008), session cookies are secure-flagged in production; without
  trust proxy, Express ignores HA Ingress's `X-Forwarded-*` headers, the
  cookie is not honored on the round-trip, and every `/api/*` call after
  login returns 401. Upstream context: chrisvel/tududi#1023.

**ADDED:** Two HA config toggles for upstream Tududi feature flags
- `tududi_trust_proxy` (default `true`) - keep on for HA Ingress; disable
  only in advanced non-ingress setups. `run.sh` logs a warning when disabled.
- `ff_enable_mcp` (default `false`) - controls `FF_ENABLE_MCP`. When enabled,
  tududi exposes `/api/mcp/*` endpoints protected by a Bearer API token
  (generate in Profile -> API Keys). Matches upstream default.
- Friendly names and descriptions added to translations (en/de/fr/nl).

**CHANGED:** base image Alpine 3.19 -> 3.22 (Node 20.15.1 -> 22.16)
- Required for tududi >= 1.2.x: upstream added `jose` v6 (ESM-only), loaded
  via `require('jose')` at startup, which needs Node >= 20.19 or >= 22.12.
  On Node 20.15 the addon would crash-loop with `ERR_REQUIRE_ESM`.
- Alpine 3.19 is EOL and no longer rebuilt by HA docker-base. Alpine 3.22
  matches upstream's own `node:22-alpine`.

**IMPROVED:** Zero sed fixes in Dockerfile
- Removed the logo path sed workaround - fixed upstream in PR #946
  (included since v1.0.0).

**ADDED:** HA backup pre/post scripts (parity with dev addon)

**Upstream highlights v1.0.0 -> v1.2.4 (addon-relevant):**
- OIDC/SSO authentication support (#1008) and CSRF token support (#1025).
- `TUDUDI_TRUST_PROXY=true` now converts to a single trusted proxy hop with a
  startup warning (#1273, fixes #1258) - expect one informational line at
  startup; correct for HA Ingress.
- Canonical data paths moved to `/app/db` (#1250, #1269) - addon unaffected:
  `run.sh` keeps data under `/data`.
- First-install robustness: `SQLITE_BUSY` fix (#1271), migration guards
  (#1268), fail-fast migrations (#1269).
- 20 dependency security vulnerabilities resolved (#983); many recurring-task,
  inbox, CalDAV, kanban, and Telegram fixes; goals and people features.

## 1.0.0
**Bumped:** tududi to V1
**tududi changelog:**
- Add comprehensive LLM development documentation by @chrisvel in #939
- Fix date format inconsistency in Defer Until field by @chrisvel in #941
- Add URL detection to inbox processing service by @chrisvel in #942
- Fix notification deduplication to prevent pile-up in navbar by @chrisvel in #945
- fix: use getAssetPath() for logo images in Navbar and Login by @woytekbode in #946
- Fix Telegram notification spam with channel-level rate limiting by @chrisvel in #951
- feat: Add MCP Integration with client-agnostic instructions by @chrisvel in #953
- Fix date format inconsistency in Task detail screen by @chrisvel in #956
- Fix visual overlap between subtasks icon and status dropdown by @chrisvel in #958
- Fix project update API to support clearing nullable fields by @chrisvel in #961
- Fix recurring task initial due date calculation to match recurrence pattern by @chrisvel in #965
- Fix Telegram notification spam by marking JSON field as changed by @chrisvel in #969
- Fix Today page task completion issues by @chrisvel in #970
- Fix project name overflow and add 6-word validation limit by @chrisvel in #972
- Fix initial due date calculation for weekly tasks with multiple weekdays by @chrisvel in #975
-docs: Clarify tag validation rules and Inbox hashtag syntax by @vincent067 in #964

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
