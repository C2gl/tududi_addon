# CLAUDE.md — Project Context for AI Assistants

## Overview

This is a fork of [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon), used for testing changes against a live Home Assistant install before submitting PRs upstream.

The addon wraps [chrisvel/tududi](https://github.com/chrisvel/tududi) (a self-hosted task manager) as an HA addon. The upstream repo contains two addon variants:

- **`tududi-addon/`** — Production addon, currently on `v0.89.0` at C2gl, with a massive 60+ line `sed`-based Dockerfile. The `run.sh` still has the old session secret behavior (just warns when empty, no auto-generation).
- **`tududi-addon-dev/`** — Dev addon, still on `v0.88.5-rc.1` at C2gl (bumped to `v0.89.0` in this fork), with a much simpler Dockerfile.

The latest stable upstream tududi release is `v0.89.0` (released 2025-03-12). Our dev addon fork is now also on `v0.89.0`.

## Repos

| Repo | Role |
|------|------|
| [chrisvel/tududi](https://github.com/chrisvel/tududi) | Upstream app (Node/React task manager) |
| [woytekbode/tududi](https://github.com/woytekbode/tududi) | Fork of upstream app (for PRs to chrisvel) |
| [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon) | Upstream HA addon |
| [woytekbode/tududi_addon](https://github.com/woytekbode/tududi_addon) | Fork of addon (testing ground) |

## Testing Setup

- Fork is installed as a separate addon repo in HA alongside the original C2gl repo.
- The dev addon builds locally (no pre-built Docker image). The `image` field was removed from `config.yaml` to enable local builds.
- Both addons can be installed in parallel but only one should run at a time (they share the same port and can conflict on the database).
- Testing hardware: N100.
- The addon container name for docker exec is `addon_84c5055d_tududi-dev`.

## How to Test Changes

After pushing changes to this fork, the user rebuilds and tests on their HA install. The general workflow:

1. **In HA:** Go to Settings → Add-ons → Tududi (Development) → Rebuild (or reinstall if config.yaml changed structurally)
2. **Wait for build** — local builds on N100 take a few minutes
3. **Start the addon** and check the Log tab for errors or expected log messages
4. **Test in browser** — open the addon via the sidebar or ingress URL

Important notes:
- **Rebuild** re-runs the Dockerfile and picks up changes to `run.sh`, `Dockerfile`, etc. Needed for any file that gets `COPY`'d into the image.
- **Restart** (stop/start) only re-runs the existing image. Sufficient for testing runtime behavior but won't pick up code changes.
- **Reinstall** (uninstall + install) is needed when `config.yaml` schema or options change structurally (e.g. adding/removing fields, changing types). HA caches the config schema aggressively.
- The `/data` directory persists across rebuilds and sometimes across uninstalls — it's managed by HA outside the container.

Claude should advise which specific things to verify after each change. For example:
- After session secret changes: check logs for "Generated new persistent session secret" on first start, then restart and confirm "loaded from persistent storage"
- After logo/path fixes: inspect the navbar logo in the browser, check browser dev tools network tab for 404s
- After version bumps: confirm the addon starts cleanly and basic CRUD works

## Changes Made (in this fork)

### 1. Version bump
Dev addon bumped to `v0.89.0` stable (from `v0.88.5-rc.1` at C2gl). Dockerfile git tag + config.yaml version + changelog.

### 2. Removed `image` field (fork-only)
Removed from dev addon `config.yaml` so HA builds locally from the Dockerfile. **Must be restored for any PR to C2gl** — see PR strategy below.

### 3. Session secret auto-generation
When `tududi_session_secret` is not set, `run.sh` auto-generates a cryptographically strong 64-byte hex secret using Node.js crypto (`crypto.randomBytes(64)`) and persists it to `/data/.session_secret` (chmod 600). Sessions now survive addon restarts. The config field is optional (`str?`) and removed from default options so it doesn't show as an empty text box in the HA UI. Power users can still set it manually as an override.

Note: Uses Node.js crypto instead of `openssl` because the Alpine-based addon image doesn't include openssl.

### 4. Simplified Dockerfile sed fixes
Removed unnecessary sed lines that upstream already handles:
- **index.html path rewrites** — removed. Upstream `publicPath: ''` and the dynamic `<base>` tag script handle relative paths natively. ✅ Tested, works without sed.
- **login-gfx.png sed** — removed. `Login.tsx` already uses `getAssetPath()` for this. ✅ Tested, works without sed.
- **Logo path sed** — still needed. `Navbar.tsx` and `Login.tsx` hardcode absolute paths for logos. PR submitted to upstream to fix this (see below).

The Dockerfile now has only 4 sed lines (logo fixes) instead of the 9 we started with, and instead of C2gl's 60+.

### 5. Port option hidden from UI
The `port` option was misleading — changing it breaks HA ingress. Now hidden (`int?`, removed from defaults). `run.sh` warns if overridden to non-3002.

## Testing Status

| Item | Status |
|------|--------|
| Addon builds and starts on HA | ✅ |
| Login works | ✅ |
| Login page graphic renders | ✅ |
| Basic task CRUD works | ✅ |
| Session secret auto-generation | ✅ Verified |
| Logo in top-left navbar | ✅ Verified |
| Port option hidden from UI | ✅ Verified |
| v0.89.0 bump | ✅ Verified — all features work |
| Removed index.html sed | ✅ Verified — works without |
| Removed login-gfx sed | ✅ Verified — works without |

## Upstream PRs

### chrisvel/tududi — Logo path fix
- **Branch:** `woytekbode/tududi` → `fix/logo-paths-use-getAssetPath`
- **Target:** `chrisvel/tududi` → `main`
- **Status:** Branch ready, PR needs to be created manually at https://github.com/woytekbode/tududi/compare/fix/logo-paths-use-getAssetPath
- **Change:** Use `getAssetPath()` for logo `src` in `Navbar.tsx` and `Login.tsx` (2 files, ~4 lines changed). `Login.tsx` already imports it; `Navbar.tsx` needs it added to the import.
- **Impact:** Once merged, the remaining 4 logo sed lines in our Dockerfile can be removed entirely, leaving zero sed hacks.

## Upstream Status (as of 2025-03-18)

**chrisvel/tududi:** `v0.89.0` released 2025-03-12 as stable.

**C2gl production addon** (`tududi-addon/`) bumped to `v0.89.0`:
- Massive sed block (60+ lines) — mostly unnecessary since publicPath is already relative
- `run.sh` unchanged: no session secret auto-generation
- `config.yaml`: session secret and port still required with empty/visible defaults

**C2gl dev addon** (`tududi-addon-dev/`) unchanged at `v0.88.5-rc.1`.

## PR Strategy

- The fork's **`main` branch** is the working/testing branch with local-build config (`image` field removed).
- When ready to submit upstream to C2gl, create a dedicated **PR branch** off `main` that:
  - Restores the `image` field (pointing to `ghcr.io/c2gl/tududi-addon-dev`)
  - Excludes fork-only files (this `CLAUDE.md`)
  - Contains only the changes intended for C2gl
- **Do NOT submit a PR with the `image` field removed.**
- Consider whether to target the dev addon only, or propose improvements for the production addon too.

## Open Items

- Submit the logo path PR to chrisvel/tududi (branch is ready, needs manual PR creation)
- Decide PR scope for C2gl: dev addon only, or also propose fixes for production addon?
- Create PR branch for C2gl, restore `image` field, and submit
- Look for other ways to contribute to the C2gl addon
