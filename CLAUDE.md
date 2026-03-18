# CLAUDE.md — Project Context for AI Assistants

## Overview

This is a fork of [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon), used for testing changes against a live Home Assistant install before submitting PRs upstream.

The addon wraps [chrisvel/tududi](https://github.com/chrisvel/tududi) (a self-hosted task manager) as an HA addon. The upstream repo contains two addon variants:

- **`tududi-addon/`** — Production addon, currently on `v0.88.4` at C2gl, with a complex 60+ line `sed`-based Dockerfile.
- **`tududi-addon-dev/`** — Dev addon, currently on `v0.88.5-rc.1` at C2gl (bumped to `v0.88.5` stable in this fork), with a much simpler Dockerfile (upstream fixed most ingress path issues since v0.87).

The latest stable upstream tududi release is `v0.88.5`. Note: `v0.89.0` doesn't exist as a release tag — only `v0.89.0-dev.1` (pre-release).

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

## Changes Made (in this fork)

### 1. Version bump
Dev addon bumped from `v0.88.5-rc.1` to `v0.88.5` stable (Dockerfile git tag + config.yaml version + changelog).

### 2. Removed `image` field (fork-only)
Removed from dev addon `config.yaml` so HA builds locally from the Dockerfile. **Must be restored for any PR to C2gl** — see PR strategy below.

### 3. Session secret auto-generation
When `tududi_session_secret` is not set, `run.sh` auto-generates a cryptographically strong 64-byte hex secret via `openssl rand` and persists it to `/data/.session_secret` (chmod 600). Sessions now survive addon restarts. The config field is optional (`str?`) and removed from default options so it doesn't show as an empty text box in the HA UI. Power users can still set it manually as an override. Detailed comment blocks in `run.sh` and `config.yaml`. Changelog updated.

### 4. Logo path fix (in progress)
The top-left logo is broken behind HA ingress because `Navbar.tsx` and `Login.tsx` in upstream tududi hardcode `/wide-logo-light.png` and `/wide-logo-dark.png` instead of using the existing `getAssetPath()` helper. Added `sed` rewrites for logo and login image paths in compiled JS. Latest approach uses bare path matching (`/wide-logo-light.png` → `./wide-logo-light.png`) instead of quote-specific patterns. Pushed but not yet rebuilt/verified.

## Testing Status

| Item | Status |
|------|--------|
| Addon builds and starts on HA | ✅ |
| Login works | ✅ |
| Login page graphic renders | ✅ |
| Basic task CRUD works | ✅ |
| Session secret auto-generation | Pushed, not yet tested |
| Logo in top-left navbar | Fix pushed, not yet rebuilt/verified |

## PR Strategy

- The fork's **`main` branch** is the working/testing branch with local-build config (`image` field removed).
- When ready to submit upstream, create a dedicated **PR branch** off `main` that:
  - Restores the `image` field (pointing to `ghcr.io/c2gl/tududi-addon-dev`)
  - Excludes fork-only files (this `CLAUDE.md`)
  - Contains only the changes intended for C2gl
- **Do NOT submit a PR with the `image` field removed** — that would force all C2gl users into slow local Docker builds instead of pulling the pre-built image.

## Open Items

- Rebuild and verify logo fix
- Test session persistence across restarts (check addon logs for "Generated new persistent session secret" / "loaded from persistent storage")
- Once all verified, create PR branch, restore `image` field, and submit PR to C2gl
- Consider filing an upstream issue/PR on `chrisvel/tududi` for the logo path bug — both `Navbar.tsx` and `Login.tsx` should use `getAssetPath()` instead of hardcoded absolute paths, which would eliminate the need for `sed` workarounds
- Look for other ways to contribute to the C2gl addon (open issues, missing features, documentation)
