# CLAUDE.md — Project Context for AI Assistants

## GitHub MCP API Access — READ THIS FIRST

The GitHub MCP connection is authenticated as **woytekbode**. This determines what Claude can and cannot do:

**Can do (woytekbode repos):**
- Read files, PRs, issues, comments on any public repo
- Create/push files, create branches on `woytekbode/*` repos
- Create cross-fork PRs from `woytekbode/tududi_addon` → `C2gl/tududi_addon`

**Cannot do (C2gl repos — even though woytekbode is co-maintainer):**
- Push files or create branches directly on `C2gl/tududi_addon`
- Edit PR descriptions, add comments, or update issues on `C2gl/tududi_addon`
- Merge PRs on `C2gl/tududi_addon`
- Trigger GitHub Actions workflows on any repo

**Workflow implications:**
- All code changes go through the fork → PR to C2gl. Never try to push directly to C2gl.
- The user must manually: sync the fork with C2gl, merge PRs on C2gl, run builder workflows, edit PR descriptions on C2gl.
- **The fork must be synced with C2gl's `main` before creating new PR branches.** If the fork is behind, cross-fork PRs will fail. Ask the user to sync first: GitHub → woytekbode/tududi_addon → "Sync fork" → "Update branch".
- PR branch naming convention: `pr/c2gl-<description>` for branches intended as PRs to C2gl.
- After syncing the fork (discard commits), CLAUDE.md and any fork-only config will be lost and must be re-pushed.

## Overview

This is a fork of [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon), used for testing changes against a live Home Assistant install before submitting PRs upstream.

The addon wraps [chrisvel/tududi](https://github.com/chrisvel/tududi) (a self-hosted task manager) as an HA addon. The upstream repo contains two addon variants, both on `main` branch side by side:

- **`tududi-addon/`** — Production addon, at `v0.89.0` at C2gl.
- **`tududi-addon-dev/`** — Dev addon, at `0.89.0` at C2gl (PR #70 merged), with simplified Dockerfile and session secret auto-generation.

**woytekbode is a co-maintainer of C2gl/tududi_addon** (granted by C2gl). The user can merge PRs, run the builder workflow, and manage the upstream repo via the GitHub web UI — but the MCP API cannot do these things (see above).

## Repos

| Repo | Role |
|------|------|
| [chrisvel/tududi](https://github.com/chrisvel/tududi) | Upstream app (Node/React task manager) |
| [woytekbode/tududi](https://github.com/woytekbode/tududi) | Fork of upstream app (for PRs to chrisvel) |
| [C2gl/tududi_addon](https://github.com/C2gl/tududi_addon) | Upstream HA addon (woytekbode is co-maintainer) |
| [woytekbode/tududi_addon](https://github.com/woytekbode/tududi_addon) | Fork of addon (testing ground, MCP can write here) |

## How to Publish a Release

HA addon updates are a two-step process:

1. **Merge to `main`** on C2gl/tududi_addon — HA sees the new version in `config.yaml` and shows "Update available". But the Docker image doesn't exist yet, so clicking Update will 404.

2. **Run the builder workflow** — Actions → "🏗️📢 Build and Publish Add-on" → Run workflow → select `dev` or `stable` or `both`. This pushes the image to GHCR. Only then can users download the update.

**Always run the builder immediately after merging.**

The builder uses `home-assistant/builder@master` which is **deprecated** — migration to new reusable actions is pending.

## Addon Versioning

The addon version in `config.yaml` tracks the upstream tududi version. For addon-level improvements without an upstream bump, use a patch (e.g. `0.89.0` → `0.89.1`).

## Completed Work

### PR #70 — Dev addon improvements (✅ Merged, published)
- Version bump: `v0.88.5-rc.1` → `0.89.0`
- Session secret auto-generation (umask 077, persist, validate)
- Simplified Dockerfile (60+ sed → 4, with TODO for PR #946 removal)
- Port option hidden from UI
- Published to `ghcr.io/c2gl/tududi-addon-dev:0.89.0`

### chrisvel/tududi#946 — Logo path fix (✅ Merged)
- Once in a tududi release, remaining logo sed lines can be removed entirely.

## Planned Roadmap

1. ~~PR #70~~ → ✅ Done.
2. **Port dev improvements to production addon** → version `0.89.1`, same changes as dev but targeting `tududi-addon/`.
3. **Bump dev to `1.0.0-dev.2`** → Keep dev ahead of production.
4. **Migrate builder workflow** → Replace deprecated `home-assistant/builder@master`.

## Open Items

- Create and merge production PR (v0.89.1) — branch `pr/c2gl-prod-addon-improvements`
- After merge: run builder with `stable`
- Bump dev to `1.0.0-dev.2`
- Migrate builder workflow
- Remove logo sed lines when next tududi release includes #946
