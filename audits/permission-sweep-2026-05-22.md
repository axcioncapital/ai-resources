# Permission Sweep Report — 2026-05-22

## Summary

- Scanned 26 settings files across 5 layers (user, workspace, ai-resources, projects, workflow-dev).
- Findings: 0 CRITICAL, 2 HIGH, 0 MEDIUM, 3 ADVISORY, 0 INTENTIONAL-NARROW.
- Applied: 4 (2 HIGH + 2 advisory). Deferred: 1 advisory (A1). Skipped INTENTIONAL-NARROW: 0.
- Run as the execution mechanism for the 2026-05-22 friday-act `permissions` plan. Risk-checked GO (`audits/risk-checks/2026-05-22-add-bash-rm-and-notebookedit-to-two-project-settings-json.md`).
- Supersedes the earlier same-day dry-run report (friday-checkup weekly rotation).

## Findings applied

| # | File | Rule | Severity | Change |
|---|------|------|----------|--------|
| 1 | projects/axcion-brand-book/.claude/settings.json | Rule 6 | HIGH | Added `Bash(rm *)` to `permissions.allow` |
| 2 | projects/ai-development-lab/.claude/settings.json | Rule 6 | HIGH | Added `Bash(rm *)` to `permissions.allow` |
| 3 | projects/axcion-brand-book/.claude/settings.json | Rule 13 | ADVISORY | Added `NotebookEdit` to `permissions.allow` |
| 4 | projects/ai-development-lab/.claude/settings.json | Rule 13 | ADVISORY | Added `NotebookEdit` to `permissions.allow` |

The two advisory `NotebookEdit` additions are normally excluded from `apply all`; they were applied here because they are plan item 4 of the approved friday-act `permissions` plan. The two `Edit(**/.claude/**)` / `Write(**/.claude/**)` globs also named in plan item 4 were **not** applied — this run's Rules 3 and 4 did not fire (bare `Edit`/`Write` already cover all paths), so the globs are redundant. (Note: the earlier dry-run flagged these globs as advisory under Rule 3; the two runs disagree on Rule 3. The fresh run's reasoned disposition — bare `Edit`/`Write` cover all paths — is taken as authoritative; the globs are at worst a redundant hardening entry.)

## Findings deferred (not approved this run)

| File | Rule | Severity | Reason |
|------|------|----------|--------|
| 8 project settings.json files (`Read(archive/**)` deny without `archive/` in `.gitignore`) | Rule 14 | ADVISORY | Out of scope for the friday-act `permissions` plan — a `.gitignore` change, not a permission change. Surfaced to the operator for a separate decision. `buy-side-service-plan` is highest priority (its `archive/` directory exists on disk). The other 7: `corporate-identity`, `nordic-pe-macro-landscape-H1-2026`, `project-planning`, `obsidian-pe-kb`, `repo-documentation`, `interpersonal-communication`, `axcion-ai-system-owner`. `global-macro-analysis` is already compliant. |

## Plan items with no corresponding finding

- **friday-act `permissions` plan item 3** — "Remove the `model` field from `~/.claude/settings.json`." The earlier same-day dry-run (friday-checkup) confirmed `"model": "sonnet"` was present at checkup time (a Rule 11 MEDIUM). This fresh run finds **no `model` field** in `~/.claude/settings.json` (and no `~/.claude/settings.local.json` exists) — the field was removed by an intervening session between the checkup and this run. Item 3 is resolved; no change made.

## Intentional-narrow files (excluded)

- None. The documented exception (`projects/obsidian-pe-kb/vault/.claude/settings.json`) does not exist on disk.

## Full diagnostic notes

`ai-resources/audits/working/permission-sweep-2026-05-22.md`

## Prevention

- SessionStart hook `check-permission-sanity.sh` flags the primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
