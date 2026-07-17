# Permission Sweep Report — 2026-07-17 (dry-run)

## Summary

- Scanned **52** settings files across 6 layers (A, B, B′, C, D, D′; incl. 3 nested vault/knowledge-base pairs, 1 workflow template).
- Findings: **6 CRITICAL, 6 HIGH, 1 MEDIUM, 34 ADVISORY, 6 INTENTIONAL-NARROW** (the intentional-narrow set is a tagged subset within the counts above, all on `projects/strategic-os`).
- Dry-run: **no changes applied.** Run `/permission-sweep` (no `--dry-run`) to remediate.

## What's causing prompts right now — CRITICAL (actionable, 3 of 6)

1. **projects/axcion-brand-book/.claude/settings.json** — Rule 3: 4 scoped Edit/Write globs (`_scoping/**`, `_appendix/**`) with no `Edit(**/.claude/**)` / `Write(**/.claude/**)` companion → edits inside nested `.claude/` still prompt.
   Fix: add `Edit(**/.claude/**)` and `Write(**/.claude/**)` to allow.
2. **projects/interpersonal-communication/knowledge-base/.claude/settings.json** — Rule 4: bare `Edit`/`Write` present but bare `MultiEdit` missing alongside scoped patterns.
   Fix: add bare `"MultiEdit"` to allow.
3. **ai-resources/.claude/settings.local.json** — Rule 5: 4 narrow `Bash(...)` grants, no `Bash(*)` catch-all; matches neither documented B′ canonical form → any new bash command prompts.
   Fix: add `"Bash(*)"`, or convert to a canonical local-file shape.

_(CRITICAL findings 4–6 are the strategic-os Rule 3/4/5 set — INTENTIONAL-NARROW, deliberately scoped for deal/client-sensitive data. Skipped unless `--fix-narrow`.)_

## HIGH (gaps that will cause future prompts)

- **ai-resources/.claude/settings.local.json** — Rule 6: no `Bash(rm *)` and no `Bash(*)` → Delete/Remove prompts. (Same file as CRITICAL 3; one fix covers both.)
- **workspace-root `.claude/settings.local.json`** — Rule 9: 6 `Bash(...)` allow entries hardcode two agent-worktree paths (`agent-a7ef729b…`, `agent-a32f0807…`) that no longer exist on disk (worktrees cleaned up). Stale, safe to remove.
- **projects/axcion-brand-book** and **projects/axcion-website** — Rule 8: no `additionalDirectories` grant anywhere (no `settings.local.json` exists) → ai-resources symlinks won't resolve. Needs operator review (machine-specific path).
- _(strategic-os Rule 6 + Rule 8 HIGH findings — INTENTIONAL-NARROW, skipped.)_

## MEDIUM

- **User-level vs workspace deny divergence** (Rule 11): workspace `.claude/settings.json` denies `Read(**/*deal-*)`, `Read(**/*client-*)`, `Read(**/*confidential*)`; user-level `~/.claude/settings.json` does not. Decide whether the confidentiality read-denies should also apply at user level (sessions opened outside the workspace). Operator call.

## ADVISORY (34 — hygiene, no prompts today)

- **Rule 14 (22 entries):** a `Read(archive/**)` (or concrete-dir) deny exists but `archive/` is not in that repo's `.gitignore`. Fires on 20 Layer-D projects + the research-workflow template. Mechanical fix: add `archive/` to each `.gitignore`.
- **Rule 8 relocate (10 entries):** tracked `settings.json` still carries `additionalDirectories` (machine-specific absolute path) — should live only in gitignored `settings.local.json`.
- **Rule 13 (2 entries):** ai-resources `settings.json` deny has redundant `Read(logs/*-archive-*.md)` + `Read(logs/*archive*.md)` (second is a superset); strategic-os uses `Bash(foo:*)` colon-star form instead of canonical `Bash(foo *)`.

## Out-of-rulebook — flagged for operator (not in the 14-rule scorecard)

- **`~/.claude/settings.json` (user-level) declares `"model": "opus[1m]"`.** This intersects two loaded workspace rules: (1) **Model Tier** — "Model defaults are prohibited anywhere in this workspace; do not declare a `model` field in ANY `.claude/settings.json` … non-negotiable"; (2) the **`[1m]` suffix** matches the inverted 2026-06-18 rule — the suffix causes subagent spawn failures. **Recommend removing the `model` field from user-level settings.json.** Operator's call (user-level file, outside the auto-remediation scope).

## Template / staleness observations

- **permission-template.md staleness:** the template's `§ Intentional-narrow exceptions` names `projects/obsidian-pe-kb/vault/.claude/settings.json` as the "current known exception" — that path does not exist (obsidian-pe-kb has no `vault/`). The file actually exhibiting the intentional-narrow pattern is `projects/strategic-os/.claude/settings.json`, which the template does not document. Template should be updated.
- **research-workflow template settings.json** has no `additionalDirectories` field at all — the intended post-2026-06-26/27 state (grant flows through `/deploy-workflow`), not a regression. No Rule 8/9 finding emitted.

## Full diagnostic notes

`ai-resources/audits/working/permission-sweep-2026-07-17.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause at session start.
- `/new-project` emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.

---

Dry-run complete. Run `/permission-sweep` without `--dry-run` to remediate. Review and commit at session wrap.
