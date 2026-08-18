# Changelog

All notable changes to this add-on will be documented in this file.

## 1.4.0
**BUMPED:** bumped to tududi v1.4.0 (from v1.2.4)

Promotes the stable addon to the current upstream stable release, keeping it in
step with the dev addon (which ran cleanly in Home Assistant on the v1.4.0-rc.1
pin). Upstream progressed v1.2.4 -> v1.3.0-rc.1 -> v1.3.0 -> v1.3.1 ->
v1.4.0-dev.1 -> v1.4.0-rc.1 -> v1.4.0-rc.2 -> v1.4.0. Addon-relevant analysis
first, then upstream highlights; full upstream notes:
https://github.com/chrisvel/tududi/releases

**Addon-relevant:**
- No `build.yaml` change needed. Upstream still builds on `node:22-alpine` and
  the addon base image is already Alpine 3.22 (Node 22.16) since `1.2.4`. No
  new ESM-only startup dependency was added, so the `ERR_REQUIRE_ESM` class of
  failure cannot recur.
- No `run.sh`, `translations/` or option-schema change needed. The upstream
  runtime feature-flag set is unchanged from v1.2.4 (`FF_ENABLE_MCP`,
  `FF_ENABLE_BACKUPS`, `FF_ENABLE_CALDAV`, `FF_ENABLE_CALENDAR`,
  `FF_ENABLE_HABITS`), so `tududi_trust_proxy` and `ff_enable_mcp` stay as they
  are.
- Frontend build verified locally at the `v1.4.0` tag with the addon's own
  flags (`npm install --legacy-peer-deps`, then
  `NODE_OPTIONS=--max-old-space-size=2048 NODE_ENV=production npm run
  frontend:build`): `tsc --noEmit` clean, webpack exits 0 with only
  bundle-size warnings, main bundle ~3.3 MiB. The 2048 MB heap cap is still
  sufficient, so the Dockerfile needs no `NODE_OPTIONS` change.
- New PWA support (#1343) ships `public/sw.js`; webpack's copy step emits it
  into `dist/`, so the existing `cp -r dist/*` picks it up with no Dockerfile
  change (verified in the local build output). However, `frontend/index.tsx`
  registers the worker at the absolute path `/sw.js` and `manifest.json` uses
  `start_url`/`scope` of `/`, neither of which resolve behind HA Ingress - so
  PWA install and offline mode will not work through ingress. Upstream catches
  the registration failure and treats it as non-fatal, so nothing else is
  affected.
- New frontend flag `ENABLE_INBOX_CLARIFY` (#1364) gates the new inbox clarify
  flow. It is inlined by webpack's `DefinePlugin` at build time, so it cannot
  be exposed as a runtime addon option; left unset, which matches the upstream
  default (feature hidden) and the dev addon.
- `webpack.config.js` (`publicPath: ''`) and `public/index.html` (dynamic
  `<base>` tag) are byte-identical to v1.2.4, so the ingress path handling the
  addon depends on is unchanged and the Dockerfile still needs zero sed fixes.
- Pre-v1.2.0 database handling changed (#1291): `backend/cmd/start.sh` now
  redirects `DB_FILE` to the old `/app/backend/db` path instead of copying the
  file. The addon is unaffected - `run.sh` sets
  `DB_FILE=/data/production.sqlite3` and the image's `/app/backend/db` is
  always empty, so that fallback branch never fires.
- The `uuid` dependency was dropped in favour of the Node built-in
  `crypto.randomUUID()` (#1297). `nanoid@3` and `i18next` are still pinned
  upstream, so the addon's extra `npm install` lines for them remain no-ops.
- New optional upstream env vars are not exposed as addon options: templates
  marketplace (`MARKETPLACE_URL`, `MARKETPLACE_API_KEY`,
  `PROJECT_TEMPLATES_ENABLED`, `MAX_TEMPLATES_PER_USER`) and multi-LLM AI
  (`LLM_API_KEY`, `LLM_BASE_URL`, `LLM_MODEL`). All have safe defaults.

**Features (v1.2.4 -> v1.4.0):**
- Subtasks are now first-class tasks with list visibility (#1346).
- Installable PWA with offline read and queued write sync (#1343) - see the
  ingress caveat above.
- Full goals UX overhaul with area integration (#1354) and goal colours
  (#1357).
- Inbox: multiline capture with an autogrow textarea and first-line list
  preview (#1351); clarify flow behind `ENABLE_INBOX_CLARIFY` (#1364).
- Project templates + marketplace (#1278), plus per-user area overrides for
  shared projects (#1276).
- GTD-aligned reports page with tabbed layout; sidebar reorganised with pinned
  items, boards, insights and admin sections (#1306, #1311), sections now
  collapsed by default with the AI brief respecting the profile setting
  (#1358), plus broad sidebar UI refinements (#1359).
- Rich note editor with wikilinks, backlinks, slash commands and note badges
  (#1340); working copy button on markdown code blocks (#1288).
- Multi-LLM AI support with a dedicated AI settings tab and user profile
  context (#1333); AI Daily Brief restored with a Today page toggle (#1331).
- MCP grew to 54 tools - goals, views and people tools added (#1334, #1335).
- People: user accounts can be linked to Person records, and a self-person is
  created for newly provisioned users (#1319).
- Today page gained a `#today` tagged-tasks section with a toggle setting.

**Fixes (v1.2.4 -> v1.4.0):**
- Auth: password loss during migration prevented and NULL-digest error
  messages improved (#1365); `has_password` reported correctly for OIDC users
  (#1366); OIDC UserInfo endpoint queried to supplement ID token claims
  (#1322).
- CalDAV: sync direction values aligned with model constraints (#1347); task
  associations eager-loaded so tags and parent links reach clients (#1348);
  "ghost tasks" made deletable and stopped from coming back (#1372); date
  timezone handling and ETag on collection GET (#1336).
- Habits: frequency period respected for completion state and streaks (#1368).
- AI Assistant: `json_schema` response format for Anthropic compatibility
  (#1355); 503 `AI_NOT_CONFIGURED` instead of an opaque 500 when no LLM key is
  set (#1369, #1370); configurable `max_tokens` with content fallback for
  reasoning models (#1377).
- Inbox: empty content rejected via MCP and blank items surfaced (#1378).
- Security: 5 production vulnerabilities patched via overrides and upgrades
  (#1338), plus further Dependabot rounds (#1324, #1367, #1381).

**Note for existing users:** upgrading from 1.2.4 runs the v1.3.x/v1.4.0
migrations on first start. Existing data is unaffected - the addon keeps the
database and uploads under `/data`.

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
