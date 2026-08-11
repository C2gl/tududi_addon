# Changelog

All notable changes to this add-on will be documented in this file.

## 1.4.0-rc.1
**BUMPED:** bumped to tududi v1.4.0-rc.1 (release candidate)

Jump from the previous pin (v1.2.4). Upstream progressed through v1.3.0-rc.1 ->
v1.3.0 -> v1.3.1 -> v1.4.0-dev.1 -> v1.4.0-rc.1. Addon-relevant analysis first,
then upstream highlights; full upstream notes:
https://github.com/chrisvel/tududi/releases

**Addon-relevant:**
- Node / base image: upstream still builds on `node:22-alpine`, and the addon
  base image is already Alpine 3.22 (Node 22.16) since `1.2.4.1`. No new
  ESM-only startup dependency was added, so no `build.yaml` change is needed.
- New PWA support (#1343) ships `public/sw.js`. Webpack's copy step emits it
  into `dist/`, so the existing `cp -r dist/*` in the Dockerfile picks it up
  with no change. However, `frontend/index.tsx` registers the worker at the
  absolute path `/sw.js` and `manifest.json` uses `start_url`/`scope` of `/`,
  neither of which resolve behind HA ingress - so PWA install and offline mode
  will not work through ingress. Upstream catches the registration failure and
  treats it as non-fatal, so nothing else is affected.
- Pre-v1.2.0 database handling changed (#1291): `backend/cmd/start.sh` now
  redirects `DB_FILE` to the old `/app/backend/db` path instead of copying the
  file to the new location. The addon is unaffected - `run.sh` sets
  `DB_FILE=/data/production.sqlite3` and the image's `/app/backend/db` is
  always empty, so that fallback branch never fires.
- `webpack.config.js` (`publicPath: ''`) and `public/index.html` (dynamic
  `<base>` tag) are byte-identical to v1.2.4, so the ingress path handling the
  addon depends on is unchanged and the Dockerfile still needs zero sed fixes.
- Feature flags unchanged from v1.2.4 (`FF_ENABLE_MCP`, `FF_ENABLE_BACKUPS`,
  `FF_ENABLE_CALDAV`, `FF_ENABLE_CALENDAR`, `FF_ENABLE_HABITS`), so the
  `ff_enable_mcp` option and schema stay as they are.
- The `uuid` dependency was dropped in favour of the Node built-in
  `crypto.randomUUID()` (#1297). `nanoid@3` and `i18next` are still pinned
  upstream, so the addon's extra `npm install` lines for them remain no-ops.
- New optional upstream env vars are not exposed as addon options: templates
  marketplace (`MARKETPLACE_URL`, `MARKETPLACE_API_KEY`,
  `PROJECT_TEMPLATES_ENABLED`, `MAX_TEMPLATES_PER_USER`) and multi-LLM AI
  (`LLM_API_KEY`, `LLM_BASE_URL`, `LLM_MODEL`). All have safe defaults.
- Frontend build verified locally at the `v1.4.0-rc.1` tag using the addon's
  own flags: `tsc --noEmit` and webpack both pass under the
  `--max-old-space-size=2048` cap despite the new CodeMirror-based note editor
  (main bundle ~3.3 MiB).

**Features:**
- Subtasks are now first-class tasks with list visibility (#1346).
- Installable PWA with offline read and queued write sync (#1343).
- Project templates + marketplace (#1278), plus per-user area overrides for
  shared projects (#1276).
- GTD-aligned reports page with tabbed layout; sidebar reorganised with pinned
  items, boards, insights and admin sections (#1306, #1311).
- Rich note editor with wikilinks, backlinks, slash commands and note badges
  (#1340); working copy button on markdown code blocks (#1288).
- Multi-LLM AI support with a dedicated AI settings tab and user profile
  context (#1333); AI Daily Brief restored with a Today page toggle (#1331).
- MCP grew to 54 tools - goals, views and people tools added (#1334, #1335).
- People: User accounts can be linked to Person records, and a self-person is
  created for newly provisioned users (#1319).
- Today page gained a `#today` tagged-tasks section with a toggle setting.

**Fixes:**
- CalDAV: sync direction values aligned with model constraints (#1347); date
  timezone handling and ETag on collection GET (#1336); externally-synced tasks
  now viewable.
- Security: 5 production vulnerabilities patched via overrides and upgrades
  (#1338), plus a further Dependabot round (#1324).
- OIDC: UserInfo endpoint queried to supplement ID token claims (#1322); OIDC
  users can set an initial password without supplying a current one (#1320).
- Performance: N+1 notification queries no longer block API requests (#1296);
  `/api/profile` cached to stop redundant fetches on the Today page (#1312).
- SQLite: `SQLITE_BUSY` on system tag seeding fixed by passing the parent
  transaction (#1287); `user_project_areas` index creation made idempotent
  (#1301).
- MCP: shared-project permissions enforced (#1290); archived task status
  mapping corrected (#1318); tags persisted on task update (#1328).
- Habits: completions no longer double-counted in the Today overview or
  inflated on same-day completions (#1315, #1317).
- Telegram: due/deferred notifications batched into one message per user
  (#1329).
- Recurring tasks: monthly occurrence dates corrected for UTC+ timezones
  (#1313).
- Tasks: assigned person embedded in the task response so all users see the
  assignment (#1341); detail view always fetches fresh data to fix stale
  due dates on shared projects (#1293).

**Addon files changed:**
- `Dockerfile`: clone branch `v1.2.4` -> `v1.4.0-rc.1`.
- `config.yaml`: version `1.2.4.1` -> `1.4.0-rc.1`, updated description.

## 1.2.4.1
**FIXED:** startup crash-loop `ERR_REQUIRE_ESM` on v1.2.4
- Upstream v1.2.4 added `jose` v6 (ESM-only), loaded via `require('jose')` at
  startup in `backend/modules/oidc/service.js` regardless of whether OIDC is
  configured. `require()` of an ES Module needs Node >= 20.19 or >= 22.12; the
  addon base image (HA Alpine 3.19) ships Node 20.15.1, so the app crashed
  right after migrations and restart-looped.
- Bumped `build.yaml` base image from Alpine 3.19 to Alpine 3.22 (Node 22.16),
  matching upstream's own `node:22-alpine`. Alpine 3.19 is EOL and no longer
  rebuilt by HA docker-base (currently built: 3.22 / 3.23 / 3.24).
- Addon-side patch only - still pinned to upstream tududi v1.2.4.

## 1.2.4
**BUMPED:** bumped to tududi v1.2.4 (stable release)

Large jump from the previous pin (v1.1.0-dev.14). Upstream progressed through
v1.1.0 -> v1.1.1 -> v1.2.0 -> v1.2.1 -> v1.2.3 -> v1.2.4. Addon-relevant
highlights below; full upstream notes: https://github.com/chrisvel/tududi/releases

**Trust proxy / rate limiting (addon-relevant):**
- `TUDUDI_TRUST_PROXY=true` is now converted to a single trusted proxy hop
  (instead of boolean `true`) with a startup warning, fixing the
  `ERR_ERL_PERMISSIVE_TRUST_PROXY` error flood and 500s on auth routes behind
  a reverse proxy (#1273, fixes #1258). The addon still exports
  `TUDUDI_TRUST_PROXY=true`, which is correct for HA Ingress (a single proxy
  hop) - expect a new informational warning line at startup.

**Docker / data storage (addon-relevant):**
- Canonical data paths moved from `/app/backend/db` to `/app/db`, with an
  automatic copy of pre-v1.2.0 data on first start (#1250, #1269). The addon
  is unaffected: `run.sh` overrides `DB_FILE=/data/production.sqlite3` and
  `TUDUDI_UPLOAD_PATH=/data/uploads`, so data stays under `/data`.
- First-install robustness: `SQLITE_BUSY` race fixed via an `afterConnect`
  `busy_timeout` hook (#1271); migration guards for goals/people on clean
  installs (#1268); fail-fast on migration errors instead of a restart loop
  (#1269); `dotenv` made optional in startup scripts.

**Features / fixes:**
- CalDAV: fixes for viewing externally-synced tasks and aligning sync
  direction values with the backend model (#1274, #1275).
- Interactive project status icon on the main projects page (#1272).
- Calendar shows task titles instead of recurrence-frequency labels (#1253).
- Prevent subtask deletion on kanban / eisenhower / undo paths (#1252).
- Comprehensive MCP integration documentation (#1086).

**Addon files changed:**
- `Dockerfile`: clone branch `v1.1.0-dev.14` -> `v1.2.4`.
- `config.yaml`: version `1.1.0-dev.14.2` -> `1.2.4`, updated description.

## 1.1.0-dev.14.2
**ADDED:** Two HA config toggles for upstream Tududi feature flags

- `tududi_trust_proxy` (default `true`) - now exposed as a user option.
  Controls `TUDUDI_TRUST_PROXY`. Previously hardcoded to `true` in `.14.1`.
  Keep on for HA Ingress (the reverse proxy in front of every HA addon);
  disable only in advanced non-ingress setups where the upstream proxy is
  not trusted. `run.sh` logs a warning when disabled.
- `ff_enable_mcp` (default `false`) - new option, controls `FF_ENABLE_MCP`.
  When enabled, tududi exposes `/api/mcp/*` endpoints protected by a Bearer
  API token. Users must generate an API token in Profile -> API Keys to use
  the server. Matches upstream default.

Friendly names and descriptions for both options added in
`translations/en.yaml` so they render nicely in the HA config UI.

Addon-side change only - still pinned to upstream tududi v1.1.0-dev.14.

## 1.1.0-dev.14.1
**FIXED:** 401-after-login regression behind HA ingress
- Export `TUDUDI_TRUST_PROXY=true` so Tududi calls
  `app.set('trust proxy', true)`. Without this, Express ignores the
  `X-Forwarded-*` headers from HA ingress; combined with the upstream
  change in v1.0.0+ (#1008) that ties `cookie.secure` to `NODE_ENV`,
  the secure session cookie set on `/api/login` was not honored on the
  round-trip and every subsequent `/api/*` returned 401, bouncing the
  frontend to a 404 route.
- Addon-side patch only - still pinned to upstream tududi v1.1.0-dev.14.
- Upstream context: chrisvel/tududi#1023.

## 1.1.0-dev.14
**BUMPED:** bumped to tududi v1.1.0-dev.14 (pre-release)

**TUDUDI v1.1.0-dev.14 CHANGELOG:**
- fix: resolve OIDC session loss and migration failures by @chrisvel in #1023
- build(deps): bump follow-redirects from 1.15.11 to 1.16.0 by @dependabot in #1024
- fix: add CSRF token support to frontend requests by @chrisvel in #1025

**TUDUDI v1.1.0-dev.7 CHANGELOG:**
- fix: resolve OIDC authentication error with existing identities by @chrisvel in #1021

**TUDUDI v1.1.0-dev.6 CHANGELOG:**
- fix: allow Sunday selection in monthly weekday recurring tasks by @chrisvel in #1014
- fix: correct Sequelize alias case for OIDCIdentity-User association by @chrisvel in #1015
- fix: resolve inbox project creation bugs by @chrisvel in #1018
- fix: prevent Telegram polling errors from blocking container startup by @chrisvel in #1019
- fix: prevent task name truncation when creating from inbox by @chrisvel in #1020

**TUDUDI v1.1.0-dev.5 CHANGELOG:**
- feat: Add OIDC/SSO authentication support by @chrisvel in #1008
- Fix: Resolve 20 security vulnerabilities in dependencies by @chrisvel in #983
- Fix: Prevent subtasks from disappearing when updating parent task by @chrisvel in #984
- Fix: Bi-weekly recurring task scheduling for multi-day patterns by @chrisvel in #1005
- fix: add missing i18next dependency to package.json by @chrisvel in #1006
- fix: exclude cancelled tasks from Overdue and Due Today sections by @chrisvel in #1007
- fix: use correct InboxItem model name in MCP inbox tools by @oritromax in #986
- Bump hono from 4.12.8 to 4.12.12 by @dependabot in #1012
- Bump @hono/node-server from 1.19.11 to 1.19.13 by @dependabot in #1011
- Bump lodash from 4.17.23 to 4.18.1 by @dependabot in #1010
- Bump nodemailer from 8.0.4 to 8.0.5 by @dependabot in #1009

**TUDUDI v1.0.0 CHANGELOG (additions since v1.0.0-rc.3):**
- docs: Clarify tag validation rules and Inbox hashtag syntax by @vincent067 in #964

## 1.0.0-rc.3
**BUMPED:** bumped to tududi v1.0.0-rc.3 (release candidate)

**TUDUDI v1.0.0-rc.3 CHANGELOG (since v1.0.0-rc.2):**
- Fix initial due date calculation for weekly tasks with multiple weekdays by @chrisvel in #975

## 1.0.0-rc.2
**BUMPED:** bumped to tududi v1.0.0-rc.2 (release candidate)

**TUDUDI v1.0.0-rc.2 CHANGELOG (since v1.0.0-rc.1):**
- Fix visual overlap between subtasks icon and status dropdown by @chrisvel in #958
- Fix project update API to support clearing nullable fields by @chrisvel in #961
- Fix recurring task initial due date calculation to match recurrence pattern by @chrisvel in #965
- Fix Telegram notification spam by marking JSON field as changed by @chrisvel in #969
- Fix Today page task completion issues by @chrisvel in #970
- Fix project name overflow and add 6-word validation limit by @chrisvel in #972

## 1.0.0-rc.1
**BUMPED:** bumped to tududi v1.0.0-rc.1 (release candidate)

**TUDUDI v1.0.0-rc.1 CHANGELOG (since v1.0.0-dev.1):**
- Fix Telegram notification spam with channel-level rate limiting by @chrisvel in #951
- Add MCP Integration with client-agnostic instructions by @chrisvel in #953
- Fix date format inconsistency in Task detail screen by @chrisvel in #956

## 1.0.0-dev.1
**BUMPED:** bumped to tududi v1.0.0-dev.1 (pre-release)

**IMPROVED:** Zero sed fixes in Dockerfile
- Removed logo path sed workaround - fixed upstream in PR #946
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
