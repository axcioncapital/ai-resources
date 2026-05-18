# Session Plan — 2026-05-18

## Intent
Execute W21 items 5, 6, 8, 9 — over-threshold log archive batch (7 files), hardcoded-path fixes in ai-resources `.claude/settings.json` (2 lines), usage-log archive via `/log-sweep`, and `/resolve-improvement-log` for 2 pending ai-resources entries.

## Class
execution

## Model
sonnet — → /model sonnet (currently on opus 4.7[1m]; this session is mostly mechanical/light-judgment with no design work)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/session/week-mandate-2026-W21.md` — the source mandate for items 5, 6, 8, 9
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/log-sweep.md` — Item 8 procedure
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` — Item 9 procedure
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — Item 6 target (lines 20–21 confirmed as the 2 hardcoded paths)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — Item 9 source (2 pending entries: 2026-04-25 /wrap-session leaner; 2026-04-28 permission-sweep-auditor template-source classification)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/usage-log.md` — Item 8 target (652 lines, Cat B over 500-line threshold)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/maintenance-observations.md` — Item 5 target (232 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/logs/session-notes.md` — Item 5 target (447 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md` — Item 5 target (411 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/friction-log.md` — Item 5 target (612 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/logs/session-notes.md` — Item 5 target (263 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/logs/session-notes.md` — Item 5 target (419 lines)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — risk-check guidance for Item 6 (settings.json edit is a structural change class)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical portable-path pattern for Item 6

## Findings / Items to Address

1. **Item 5 — Manual log archive batch (6 files over 200-line threshold).** Per W21 mandate Item 5. For each file: determine archive policy (keep recent N, move older entries to `<name>-archive.md`), apply edits, verify counts after. Files and current line counts:
   - `ai-resources/logs/maintenance-observations.md` (232) → archive
   - `projects/global-macro-analysis/logs/session-notes.md` (447) → archive
   - `projects/nordic-pe-macro-landscape-H1-2026/logs/session-notes.md` (411) → archive
   - `projects/nordic-pe-macro-landscape-H1-2026/logs/friction-log.md` (612) → archive
   - `projects/project-planning/logs/session-notes.md` (263) → archive
   - `projects/repo-documentation/logs/session-notes.md` (419) → archive

2. **Item 6 — Fix 2 hardcoded absolute paths in ai-resources/.claude/settings.json.** Per W21 mandate Item 6. Lines 20–21 currently read:
   - Line 20: `"Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)"`
   - Line 21: `"Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)"`

   Replace with workspace-portable forms. Check `ai-resources/docs/permission-template.md` for the canonical pattern (likely `${HOME}` substitution or a relative form). This edit is a **structural change class** (settings.json permission edit) — requires `/risk-check` plan-time and end-time.

3. **Item 8 — Archive ai-resources/logs/usage-log.md via /log-sweep.** Per W21 mandate Item 8. 652 lines exceeds Cat B 500-line threshold. Last `/log-sweep` was 2026-05-16 in `--dry-run` mode flagging this exact file. Run `/log-sweep` without `--dry-run` to apply.

4. **Item 9 — /resolve-improvement-log for 2 pending ai-resources entries.** Per W21 mandate Item 9.
   - `2026-04-25 — Make /wrap-session leaner` (5 sub-proposals; one already obsolete per inline note)
   - `2026-04-28 — permission-sweep-auditor: classify template sources, skip Rule 8` (auditor refinement)

   For each: read entry, decide implement-now or defer-with-rationale. If defer, add `Status: deferred YYYY-MM-DD` and reason. If implement, ship the change and add `Status: applied YYYY-MM-DD` + `Verified:` line. Then run `/resolve-improvement-log` to archive resolved entries.

## Execution Sequence

1. **Switch model to sonnet** (`/model claude-sonnet-4-6[1m]`).
2. **Item 6 first** (highest-risk; structural change class — settings.json):
   - Read `docs/permission-template.md` for canonical portable-path pattern.
   - Run `/risk-check` plan-time on the proposed 2-line edit.
   - If GO: apply edit; verify settings.json still parses (jq or manual check).
   - Commit in ai-resources.
   - Verification: lines 20–21 contain no `/Users/...` literal; settings.json still valid JSON.
3. **Item 8** (`/log-sweep` for usage-log.md):
   - Invoke `/log-sweep` (not dry-run) against ai-resources scope.
   - Verify usage-log.md now ≤500 lines; archive file created.
   - Commit any resulting changes in ai-resources.
4. **Item 9** (resolve 2 improvement-log entries):
   - Read both entries.
   - Decide implement-or-defer per entry (sonnet judgment).
   - Apply Status updates + rationale.
   - Run `/resolve-improvement-log` to archive.
   - Commit in ai-resources.
   - Verification: improvement-log.md no longer contains either entry as `logged (pending)`; archive file updated.
5. **Item 5** (manual archive batch — last because mechanical and 6 files):
   - For each file: determine archive cut (keep recent ~10 entries / ~150 lines, archive the rest).
   - Apply edits per file; verify line counts after.
   - Commit per-repo (ai-resources commit for the 1 ai-resources file; workspace-root or per-project commits for the 5 project files — determine actual git tracking before staging).
   - Verification: each file ≤200 lines post-archive.
6. **End-time `/risk-check`** for Item 6 (settings.json edit). Run after all commits, before wrap.

## Scope Alternatives

- **Min:** Item 6 only (smallest unit; structural-class so highest risk-density per item). Skip 5, 8, 9 to a later session.
- **Recommended:** All 4 (Items 5, 6, 8, 9). Operator-confirmed scope. ~1.5–2 hours.
- **Max:** Add Item 7 (ADV-1/ADV-2 permission glob normalisation). Also LOW-risk mechanical; same file as Item 6 so could be bundled. Operator explicitly excluded — do not expand.

## Autonomy Posture

Full autonomy.

**Stop points:**
- Item 6 `/risk-check` plan-time returns NO-GO or NEEDS-MITIGATION
- `/log-sweep` surfaces unexpected archive scope (>100 entries to archive, or scope reaches files not flagged)
- Item 9 entries can't be cleanly classified as implement-or-defer (e.g., entry depends on operator-only judgment)
- Item 5 archive cut policy ambiguous for any file (operator clarification needed)

## Risk

Run `/risk-check` after this plan is approved (plan-time gate) — specifically scoped to Item 6 (ai-resources/.claude/settings.json edit, lines 20–21). Run `/risk-check` again before commit (end-time gate). Items 5, 8, 9 are append-only working-state edits — not in structural change classes per `audit-discipline.md`.
