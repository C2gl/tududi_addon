# CLAUDE.md — Project Context for AI Assistants

## Overview

This is a fork of [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon), used for testing changes against a live Home Assistant install before submitting PRs upstream.

The addon wraps [chrisvel/tududi](https://github.com/chrisvel/tududi) (a self-hosted task manager) as an HA addon. The upstream repo contains two addon variants:

- **`tududi-addon/`** — Production addon, currently on `v0.89.0` at C2gl, with a massive 60+ line `sed`-based Dockerfile. The `run.sh` still has the old session secret behavior (just warns when empty, no auto-generation).
- **`tududi-addon-dev/`** — Dev addon, still on `v0.88.5-rc.1` at C2gl (bumped to `v0.88.5` stable in this fork), with a much simpler Dockerfile (upstream fixed most ingress path issues since v0.87).

The latest stable upstream tududi release is `v0.89.0` (released 2025-03-12). Our dev addon fork is on `v0.88.5`.

## Repos

| Repo | Role |
|------|------|
| [chrisvel/tududi](https://github.com/chrisvel/tududi) | Upstream app (Node/React task manager) |
| [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon) | Upstream HA addon |
| [woytekbode/tududi_addon](https://github.com/woytekbode/tududi_addon) | This fork — testing ground |

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
Dev addon bumped from `v0.88.5-rc.1` to `v0.88.5` stable (Dockerfile git tag + config.yaml version + changelog).

### 2. Removed `image` field (fork-only)
Removed from dev addon `config.yaml` so HA builds locally from the Dockerfile. **Must be restored for any PR to C2gl** — see PR strategy below.

### 3. Session secret auto-generation
When `tududi_session_secret` is not set, `run.sh` auto-generates a cryptographically strong 64-byte hex secret using Node.js crypto (`crypto.randomBytes(64)`) and persists it to `/data/.session_secret` (chmod 600). Sessions now survive addon restarts. The config field is optional (`str?`) and removed from default options so it doesn't show as an empty text box in the HA UI. Power users can still set it manually as an override. Detailed comment blocks in `run.sh` and `config.yaml`. Changelog updated.

Note: Uses Node.js crypto instead of `openssl` because the Alpine-based addon image doesn't include openssl. Node is always available since it's the tududi runtime.

### 4. Logo path fix
The top-left logo was broken behind HA ingress because `Navbar.tsx` and `Login.tsx` in upstream tududi hardcode `/wide-logo-light.png` and `/wide-logo-dark.png` instead of using the existing `getAssetPath()` helper. Added `sed` rewrites for logo and login image paths in compiled JS. Uses bare path matching (`/wide-logo-light.png` → `./wide-logo-light.png`) instead of quote-specific patterns.

Note: Still needed in v0.89.0 — checked and the hardcoded paths are unchanged in `Navbar.tsx`.

### 5. Port option hidden from UI
The `port` option in `config.yaml` was misleading — changing it would break HA ingress because `ingress_port` and the `ports` mapping are hardcoded to 3002. The port is now hidden from the UI (`int?`, removed from defaults) like the session secret. If someone does override it to something other than 3002, `run.sh` logs a clear warning about the ingress mismatch.

## Testing Status

| Item | Status |
|------|--------|
| Addon builds and starts on HA | ✅ |
| Login works | ✅ |
| Login page graphic renders | ✅ |
| Basic task CRUD works | ✅ |
| Session secret auto-generation | ✅ Verified: generates on first start, persists across restarts |
| Logo in top-left navbar | ✅ Verified |
| Port option hidden from UI | ✅ Verified |

## v0.89.0 Bump Analysis

Bumping from `v0.88.5` to `v0.89.0` should be straightforward:

- **webpack `publicPath`** is already `''` (empty/relative) in both v0.88.5 and v0.89.0 — no sed needed for this. C2gl's production Dockerfile has a `sed` for this but it's a no-op.
- **Logo paths** are still hardcoded in v0.89.0 `Navbar.tsx` — our existing sed fixes still apply.
- **Dockerfile change** is just the git tag: `v0.88.5` → `v0.89.0`.
- **config.yaml** version bump + changelog update.
- The build should work with our existing minimal sed approach (no need for C2gl's 60+ line sed block).

## Upstream Status (as of 2025-03-18)

**chrisvel/tududi:** `v0.89.0` released 2025-03-12 as stable (marked Latest on GitHub).

**C2gl production addon** (`tududi-addon/`) bumped to `v0.89.0`:
- Dockerfile clones `v0.89.0` tag from upstream
- Massive sed block (60+ lines of path rewrites) — even larger than before
- `run.sh` unchanged: still has old session secret behavior (warns when empty, no auto-generation)
- `config.yaml` still has `tududi_session_secret` as `str` (required) with empty default
- Port option still visible and changeable (same ingress mismatch risk)

**C2gl dev addon** (`tududi-addon-dev/`) unchanged at `v0.88.5-rc.1`.

Our improvements (session secret auto-generation, optional config fields, logo fixes, port fix) are still relevant and applicable to both addons.

## PR Strategy

- The fork's **`main` branch** is the working/testing branch with local-build config (`image` field removed).
- When ready to submit upstream, create a dedicated **PR branch** off `main` that:
  - Restores the `image` field (pointing to `ghcr.io/c2gl/tududi-addon-dev`)
  - Excludes fork-only files (this `CLAUDE.md`)
  - Contains only the changes intended for C2gl
- **Do NOT submit a PR with the `image` field removed** — that would force all C2gl users into slow local Docker builds instead of pulling the pre-built image.
- Consider whether to target the dev addon only, or propose improvements for the production addon too.

## Open Items

- Bump dev addon from `v0.88.5` to `v0.89.0` and test
- Decide PR scope: dev addon only, or also propose fixes for production addon?
- Create PR branch, restore `image` field, and submit PR to C2gl
- Consider filing an upstream issue/PR on `chrisvel/tududi` for the logo path bug — both `Navbar.tsx` and `Login.tsx` should use `getAssetPath()` instead of hardcoded absolute paths, which would eliminate the need for `sed` workarounds
- Look for other ways to contribute to the C2gl addon (open issues, missing features, documentation)
