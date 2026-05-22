# Permission Sweep Report — 2026-05-22 (dry-run)

## Summary

Scanned **26 settings files** across 5 layers (user, workspace, ai-resources, projects, workflow-dev).

Findings:
- **0 CRITICAL** — no live permission-prompt failures right now.
- **2 HIGH** — gaps that will cause future Delete prompts.
- **1 MEDIUM** — Model Tier policy violation.
- **6 ADVISORY** — hardening / hygiene.
- **0 INTENTIONAL-NARROW**.

## What's causing prompts right now

None. No CRITICAL findings — `defaultMode: bypassPermissions` is present across the active layers.

## Other gaps (won't prompt today, but will eventually)

**HIGH — Rule 6 (`Bash(rm *)` missing → Delete operations will prompt):**

1. `projects/ai-development-lab/.claude/settings.json`
   — allow list has no narrow `rm` entry. Delete/Remove operations will prompt.
   Fix: add `"Bash(rm *)"` to `permissions.allow`.

2. `projects/axcion-brand-book/.claude/settings.json`
   — same: no narrow `rm` entry. Delete/Remove operations will prompt.
   Fix: add `"Bash(rm *)"` to `permissions.allow`.

## Model Tier policy violation

**MEDIUM — Rule 11:**

- `~/.claude/settings.json` (user level) carries `"model": "sonnet"`. No other layer has this field. This violates the workspace **Model Tier** rule — model defaults are prohibited in any `settings.json` because a declared default contests in-session `/model` switches.
  Fix: remove the `"model"` field from `~/.claude/settings.json`. (Removing a model field is policy-compliant; the prohibition is on *adding* one.)

## Coverage improvements

**ADVISORY:**

- **A1/A2 — Rule 3:** `ai-development-lab` and `axcion-brand-book` settings.json missing `Edit(**/.claude/**)` + `Write(**/.claude/**)`. Bare `Edit`/`Write` are present, so no live prompt failure — hardening gap only.
- **A3/A4 — Rule 13:** same two files missing `"NotebookEdit"` in allow.
- **A5 — Rule 13:** `model` field hygiene in `~/.claude/settings.json` (paired with the MEDIUM above).
- **A6 — Rule 14:** 7 project settings files carry a `Read(archive/**)` deny but have no `archive/` entry in their project `.gitignore` — projects: `project-planning`, `obsidian-pe-kb`, `repo-documentation`, `interpersonal-communication`, `axcion-ai-system-owner`, `corporate-identity`, `nordic-pe-macro-landscape-H1-2026`.

## Intentionally narrow — not touching

None.

## Full diagnostic notes

`ai-resources/audits/working/permission-sweep-2026-05-22.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.

---

*Dry-run complete. Run `/permission-sweep` without `--dry-run` to remediate.*
