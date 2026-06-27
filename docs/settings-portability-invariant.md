# Settings Portability Invariant

> **When to read this file:** whenever you author or edit anything that writes a `settings.json` / `settings.local.json` file — a project generator (`/new-project`, `/deploy-workflow`), a permission tool (`/permission-sweep`, `/fewer-permission-prompts`), a workflow template, or a hand edit to a committed settings file. Also the canonical statement cited by the settings-path-portability mission.

---

## The invariant

**A git-tracked `settings.json` must never contain a machine-specific absolute path.** Per-machine configuration — anything whose correct value differs from one operator's machine to another — lives only in the gitignored `settings.local.json`.

The canonical instance is the workspace-root grant:

- `permissions.additionalDirectories` holds an **absolute** path to the workspace root (the directory containing `ai-resources/`). That path differs per machine.
- It therefore belongs in `settings.local.json` (gitignored), **never** in the tracked `settings.json`.

This is the layer-level statement of canonical Detection **Rule 8** and **Layer D′** in [`permission-template.md`](permission-template.md). Rule 8 is the detector; this doc is the standing rule the detector enforces.

## Why

A tracked absolute path is correct only on the machine that committed it. Every other machine that pulls the repo inherits a path that does not exist locally, so `ai-resources/` becomes unreadable: skill symlinks resolve to nothing and pipeline commands fail silently. Committing the path trades a one-time per-machine setup step for a recurring cross-machine breakage. (Real incident: two operators sharing a git-tracked project, 2026-06-03; root-cause close completed 2026-06-26/27.)

## Where per-machine config lives

| Concern | Tracked `settings.json` | Gitignored `settings.local.json` |
|---|---|---|
| Tool permissions (`allow` / `deny`) | ✅ canonical home | local-only overrides |
| `defaultMode` | ✅ | **required** whenever the local file declares a `permissions` block (omitting it shadows the parent's bypass) |
| `additionalDirectories` (workspace-root grant) | ❌ never | ✅ canonical home (machine-specific absolute path) |
| `model` default | ❌ prohibited workspace-wide | ❌ prohibited |

When `settings.local.json` declares any `permissions` block, it MUST include `defaultMode: "bypassPermissions"` — see [`permission-template.md`](permission-template.md) Layer B′ / Layer D′.

## Enforced by

- **Generators** write the grant to `settings.local.json`, not the tracked file: `/new-project` (Post-Pipeline Enrichment step 3), `/deploy-workflow` (grant sub-step). The research-workflow template ships **no** `additionalDirectories` in its tracked `settings.json`; its `SETUP.md` §1.5 directs the manual deploy path to the gitignored local file.
- **`/permission-sweep`** Rule 8 remediation writes new grants to `settings.local.json` and **relocates** any grant found in a tracked `settings.json` out to the local file. Rule 12 flags a `settings.local.json` that is itself tracked (it must be gitignored).
- **Per-machine recovery:** when a project's tracked grant has been removed, each operator adds their own machine's path to their local file once — ready-to-paste snippet in [`settings-local-recovery.md`](settings-local-recovery.md).

## Scope note

This invariant governs the **shape** of committed settings, not whether a grant is needed at runtime. A project that genuinely needs `ai-resources/` visibility still gets it — via the gitignored local file, which the generators populate at deploy time and the recovery snippet restores by hand.
