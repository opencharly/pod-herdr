# AGENTS.md — pod-herdr

Standalone candy/box repo for the herdr terminal-multiplexer stack: the `herdr`
candy (pinned binary + supervised server + socket bridge), the `herdr` box image,
and the `check-herdr-pod` disposable R10 bed.

Canonical files:

- `box/herdr/charly.yml` — the `herdr` box image (fedora:43 base, composed
  candies, its ADE `plan:` checks).
- `candy/herdr/charly.yml` — the `herdr:` candy entity plus `start-herdr.sh` /
  `start-bridge.sh`.
- `charly.yml` — the `check-herdr-pod` bed and the `herdr-box` `skill:` entity.
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `CHANGELOG/` — per-CalVer history.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-automation:herdr-box` — the owning skill: box properties, build/deploy
  recipe, and the bed. Load before editing, building, deploying, or
  troubleshooting this stack.
- `/charly-automation:herdr` — the `charly herdr` CLI and the `herdr:` check verb
  (owned by `plugin-herdr`).
- `/charly-pod:pod` — the `kind: pod` / deploy schema reference (the
  `check-herdr-pod` bed entity, tree-position nesting, sidecars).
- `/charly-check:check` — the check/R10 framework: the `check:` step verbs, the
  `herdr:` verb dispatch, and `charly check run <bed>`.
- `/charly-image:image` / `/charly-image:layer` — the box / candy authoring
  reference (`charly.yml` schema, `plan:` step verbs, service declarations).
- `/charly-internals:git-workflow` — before any git/PR action.

## Build / validate / test

- `charly box validate` at the repo root — the structural check: the manifests
  must parse and validate at the installed charly.
- The live R10 witness is `charly check run check-herdr-pod`: it deploys the
  `herdr` box and asserts the server answers `ping` over the bridge (verb), the CLI
  reaches the same venue (R3 parity), the workspace/split/run/wait/agent flow
  works end to end, and the verbs `workspace-list` / `agent-list` /
  `pane-wait-output` / `session-snapshot` read it back.
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate. Its only workflow file is
  `.github/workflows/tag-on-merge.yml`.

## Modify this repo

- Edit the candy in `candy/herdr/charly.yml`, the box in `box/herdr/charly.yml`,
  and the bed + `skill:` entity in the root `charly.yml`. The `skill:` entity is
  the owning skill's source — a change and its skill change land together.
- The pinned herdr version (`v0.8.2`) lives in the candy's `download:` step and
  the box's version check; keep the two in step.
- The bridge port (`8095`) is the contract shared by the `port:` field, the
  `herdr-bridge` service, and the bed's `--endpoint`; change it in all three.
- The `skill:` entity is the source for `/charly-automation:herdr-box`; never edit
  the generated `SKILL.md` — regenerate it.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
