## Intent
Sweep the remaining open tactical follow-up items from the 2026-06-05 monthly friday-checkup. Apply all low/med-risk non-structural items autonomously. Gate structural items (Read() deny at workspace root) via /risk-check. Explicitly defer large-effort items with logged reason.

## Model
claude-sonnet-4-6 — matches task profile (doing + routine decisions).

## Source Material
- `audits/friday-checkup-2026-06-05.md` — source of all follow-up items
- `logs/improvement-log.md` — target for defer-with-logging entries
- `logs/session-notes.md` — S5 mandate

## Findings / Items to Address

### Already resolved by S1–S4 (skip)
- settings.local.json bypassPermissions ✓
- Push-rule in marketing-positioning + research-pe ✓
- /new-project CLAUDE.md template ✓
- Pre-push git fetch + divergence check in /wrap-session ✓
- research-pe skill frontmatter (model:/effort:) ✓
- Model de-versioning in nordic-pe + project-planning ✓
- ai-resources Read() deny rules ✓
- vault/components/_index.md atomic-index counts ✓

### Still open — low risk (apply autonomously)
- `/resolve-improvement-log` — ~5–6 applied+verified entries pending archive
- `/log-sweep` (real run) — 2 archival candidates: improvement-log-archive.md + project-planning session-notes.md

### Still open — med risk, non-structural (apply autonomously)
- Date-qualify session-plan filename in session-marker.md + writers + glob consumers
- Add `scripts/fix-mojibake.sh` to research-workflow intake
- Reroute `improvement-analyst` to avoid `Read(logs/*archive*.md)` deny
- Add per-item done-condition check in `/prime` Step 8c
- SESSION-ISSUE: `/fix-symlinks` blind → decide fix/defer/close
- SESSION-ISSUE: Step 3.5 CONCURRENT block strands session → decide fix/defer/close
- Add collaboration-coach project-root guardrail

### Still open — structural (gate via /risk-check)
- Add Read() deny rules at workspace root + research-pe deny extension

### Defer explicitly (large effort or needs dedicated session)
- Marketing-positioning stranded worktree, W2.1 registry maintenance, DR-1 hook duplicates, /cleanup-worktree, pull.rebase policy, session-entry guard

## Execution Sequence

### Stage 1 — Low-risk routine
1. Run `/resolve-improvement-log`
2. Run `/log-sweep` (real run)

### Stage 2 — Non-structural med-risk edits
3. Date-qualify session-plan filename in session-marker.md + command writers
4. Add `scripts/fix-mojibake.sh` + wire into research-workflow intake
5. Reroute `improvement-analyst` archive de-dup
6. Add per-item done-condition check in `/prime` Step 8c
7. Decide both SESSION-ISSUEs — log in improvement-log
8. Add collaboration-coach project-root guardrail

### Stage 3 — Structural (gated)
9. /risk-check on workspace-root Read() deny → apply on GO, defer-log on RECONSIDER/NO-GO

### Stage 4 — Defer-with-logging
10. Log explicit deferrals for large-effort items

## Scope Alternatives
- **Minimal (context constrained):** Stage 1 only + defer-log everything else.
- **Full (current plan):** All 4 stages.

## Autonomy Posture
Gated — structural class detected (Read() deny = harness-config). /risk-check runs before Stage 3.

## Risk
- Session-plan filename date-qualify touches session-marker.md + multiple command files + glob consumers — verify globs after edit.
- Collaboration-coach guardrail: if via hook rather than prompt, escalates to structural → /risk-check.
- Read() deny workspace-root: explicitly gated.
