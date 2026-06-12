# Permission Sweep Report — 2026-06-12 (dry-run / post-fix verification pass)

> Verification pass run after the 2026-06-12 permissions friday-act fixes (session S5). Distinct from the earlier same-day `permission-sweep-2026-06-12.md` (pre-fix full notes, 41 files) — that file is preserved.

## Summary

- Scanned 44 settings files across 6 layers (A, B, B′, C, D, D′).
- Findings: 1 CRITICAL, 5 HIGH (all INTENTIONAL-NARROW), 0 MEDIUM, 5 ADVISORY, 2 INTENTIONAL-NARROW (excluded), 1 INTENTIONAL-TEMPLATE (silenced).
- Mode: `--dry-run` — diagnose only, no remediation applied.

## Verification results — today's friday-act fixes (all CLEAN)

| Edited file | Rule checked | Result |
|---|---|---|
| `projects/axcion-brand-book/.claude/settings.json` | Rule 7 (deny-shadows-allow) | **CLEAN** — deny glob split `0[1-8]` → `01_*` + `0[4-8]_*`; `02_color.md` / `03_typography.md` no longer shadowed |
| `projects/interpersonal-communication/knowledge-base/.claude/settings.json` | Rule 8 (tracked/stale additionalDirectories) | **CLEAN** — tracked grant removed; relocated to gitignored `settings.local.json` (Layer D′) |
| `knowledge-bases/strategic-os/.claude/settings.json` | Rules 2 + 8 | **CLEAN** — `defaultMode: bypassPermissions` added (tracked); `additionalDirectories` in `settings.local.json` |
| `knowledge-bases/marketing-communication/.claude/settings.json` | Rules 2 + 8 | **CLEAN** — same canonical D + D′ shape achieved |

All three plan items verified structurally correct. Rules 7 and 8 no longer fire on any edited file.

## New CRITICAL finding (pre-existing, NOT introduced by today's fixes — out of this plan's scope)

| # | File | Rule | Severity | Cause | Proposed fix |
|---|---|---|---|---|---|
| 1 | `projects/positioning-research/.claude/settings.local.json` | Rule 1 | CRITICAL | `permissions` block has a narrow `Bash(mkdir -p ...)` allow but no `defaultMode` → shadows the sibling `settings.json`'s `bypassPermissions`, so prompts resume in that project | Add `"defaultMode": "bypassPermissions"` to the local file's `permissions` block |

This is a separate permission change class (settings.json edit) — it warrants its own `/risk-check` and is **not** part of the permissions friday-act plan executed this session. Recommend routing to the next maintenance pass or a dedicated fix.

## HIGH findings — all INTENTIONAL-NARROW (locked on purpose, not fired)

- `pe-kb-vault` (Rules 3, 4, 5) and `knowledge-bases/strategic-os` (Rules 3+4+5, 6) carry intentionally narrow scoped access. Excluded from remediation by default.

## ADVISORY findings

- Findings 7–11 (hygiene): Finding 7 covers 19 files, Finding 11 covers 13 files. Non-prompting; deferred.

## Full diagnostic notes

`ai-resources/audits/working/permission-sweep-2026-06-12.md` (44-file post-fix scan)
