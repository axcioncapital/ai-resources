# Session Plan — 2026-05-28

## Intent
Execute the Wave 2 fix plan at `audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave2-commands.md` — 8 single-file edits across `/prime`, hooks, and docs (~60–90 min, no `/risk-check`). Items 1–3 all edit `prime.md`; coordinate as one edit pass.

## Class
execution

## Model
sonnet — → /model sonnet

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave2-commands.md` — the plan itself
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — target for items 1, 2, 3
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` — read before status-flip edits
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` — target for item 4
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md` — read for item 5 cross-link decision
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/review-chapter.md` — target for item 6 (presentation rule)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/run-report.md` — target for item 6 (mirror rule in chapter-review step)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md` — target for item 7
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/risk-topology.md` — target for item 8 (verify path via Glob first)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — read for item 8 cross-link decision + structural-change tripwire reference
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — status flips for `id-33`, `id-29`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` — status flips for `id-08`, `id-10`, `id-06`, `id-11`, `id-01/id-05`, `id-12`

## Findings / Items to Address
1. **id-08** — Rewrite `/prime` Step 8b to mirror Step 8a's lettered sub-step structure (a–d: header append + marker, `/session-start`, `/session-plan`, autonomous execution); remove the free-floating `**Next:**` footer that conflicts with the "begin execution immediately" directive. Source: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:109`. Target: `prime.md` lines 166–179. Bundle into the coordinated `prime.md` edit pass.
2. **id-10** — Extend `/prime` Step 1a git-log cross-check to traverse both repos when `$CWD_REPO != $AI_RESOURCES` (the variable already exists in Step 0). Merge results before keyword-match. Source: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:128`. Target: `prime.md` Step 1a (~line 43). Bundle into the coordinated `prime.md` edit pass.
3. **id-33** — Add a `work/Wn-*-README.md` scan to `/prime`; surface detected files as a step-6 exception line: `⚠ Phase READMEs detected: {paths}; read before opening the relevant work unit.` Skip silently if `work/` absent. Source: `ai-resources/logs/improvement-log.md:258`. Target: `prime.md` (new step or extension to existing exception-check step). Bundle into the coordinated `prime.md` edit pass.
4. **id-06** — Broaden the path-filter regex in `backup-session-plan.sh:14` from `(^|/)logs/session-plan\.md$` to `(^|/)logs/session-plan(-[a-zA-Z0-9]+)?\.md$`; derive `SRC` and `BACKUP` names from the matched file path. Source: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:95`. Target: `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh`.
5. **id-11** — Create `ai-resources/workflows/research-workflow/docs/required-reference-files.md` listing the 4 expected reference files: `source-class-hierarchy.md`, `quality-standards.md`, `known-limits.md`, `style-guide.md` — each with filename, expected path, one-line role, and which canonical command(s) read it. Cross-link from workflow template's `CLAUDE.md` if a natural insertion point exists. Source: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:147`.
6. **id-01 + id-05** (bundle) — Add the operator-presentation rule (verdict + path only, no inline chapter prose) to both `review-chapter.md` and the chapter-review step of `run-report.md` in nordic-pe-macro. Wording must be identical or cross-referenced to avoid drift. Source: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:88` (recurring entry id-05 + friction-log id-01).
7. **id-29** — Add a workflow-diagnosis boundary section (or one-paragraph note) to `ai-resources/docs/ai-resource-creation.md` distinguishing the `improvement-analyst` agent (session-friction-driven) from the planned `workflow-diagnosis` skill (artifact-defect-driven). Include explicit trigger phrasing for each. Source: `ai-resources/logs/improvement-log.md:76`.
8. **id-12** — Add a new "Deployable-template always-loaded" row to `risk-topology.md` § 1 (load-bearing classes table) for the workflow-template `CLAUDE.md` class. Blast-radius bounded by `/deploy-workflow` consumption count; gate maps to "cross-cutting CLAUDE.md edits" with lower mitigation calibration. Cross-link from `ai-resources/docs/audit-discipline.md § Risk-check change classes` if a one-line addition fits. Source: `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md:160`.

## Execution Sequence
1. **Read all source files in one parallel batch** — the 8 target files + the 2 improvement-log files + `resolve-improvement-log.md` + the audit-discipline + workflow CLAUDE.md cross-reference reads. Verify path for `risk-topology.md` via Glob first. Verify: all reads succeed; no path drift since plan was written.
2. **Apply the coordinated `prime.md` edit pass** — items id-08, id-10, id-33 as one logical edit set (multiple `Edit` calls on the same file are fine; just keep them as one batch). Verify: re-read the edited regions; structural integrity intact; no orphaned syntax.
3. **Run `/qc-pass` on the `prime.md` edit pass** — one QC pass covers all three items (same file, same edit session). Verify: GO verdict, OR REVISE with applicable findings resolved before moving on.
4. **Apply item id-06** — broaden `backup-session-plan.sh` regex; update SRC/BACKUP. Verify: regex matches `session-plan.md` AND `session-plan-pass2.md`; does NOT match unrelated names.
5. **Run `/qc-pass` on the shell edit.**
6. **Apply item id-11** — create `required-reference-files.md`. Verify: file written; cross-link decision logged.
7. **Run `/qc-pass` on the new doc** (judgment on completeness — are the 4 files the actual complete set?).
8. **Apply item id-01/id-05 bundle** — identical (or cross-referenced) presentation-rule wording added to both nordic-pe-macro files. Verify: both files updated; wording consistent.
9. **Run `/qc-pass` on the rule wording.**
10. **Apply item id-29** — boundary note added to `ai-resource-creation.md`. Verify: trigger phrasing unambiguous for each surface.
11. **Run `/qc-pass` on the boundary description.**
12. **Apply item id-12** — new row in `risk-topology.md` § 1; optional cross-link in `audit-discipline.md`. Verify: row label + blast-radius wording follow existing table style.
13. **Run `/qc-pass` on the new row.**
14. **Flip improvement-log entries** — per the plan, each item gets `**Status:** applied 2026-05-28` + `**Verified:** 2026-05-28 — ...` line at its source path. Apply across both `improvement-log.md` files. Verify: each flipped entry references the matching commit SHA where applicable.
15. **Commit per logical batch** — the 3 `prime.md` edits + their log flips as one commit; each remaining item + its log flip as its own commit. Per workspace `Commit behavior` rule: stage and commit in one step, no pre-commit checks.
16. **Notify operator** of completion and push gate per Autonomy Rule #2.

## Scope Alternatives
Single scope — no alternatives. The fix plan defines the full 8-item set; the operator pre-approved the wave split. Items have natural per-item or coordinated-batch boundaries but no min/max degrees of freedom within the wave.

## Autonomy Posture
Full autonomy — Wave 2 is an approved fix plan with concrete per-item targets, no `/risk-check` items per source, and operator memory `feedback_autonomy_during_execution` directs running approved plans to completion.

**Stop points:**
- `/qc-pass` returns REVISE twice on the same item without convergence → escalate (model escalation rule from workspace CLAUDE.md).
- A finding during item id-08 surfaces ordering-of-shared-state concerns that hit the Step-6 tripwire → pause and run `/risk-check` before continuing.
- Compaction threshold approached → write a continuity scratchpad per `compaction-protocol.md` and pause.
- Operator interrupts.

## Risk
Source plan declares no `/risk-check` items, and 7 of 8 items are clearly bounded (single-file edits, new doc, new table row). **Tripwire watch on item id-08:** the Step 8b rewrite touches `/prime`'s session-state automation; if the rewrite incidentally reorders `session-notes.md` writes vs `.prime-mtime` marker writes or vs `/session-start` invocation, that crosses the audit-discipline tripwire on "automation with shared-state effects" and requires `/risk-check` despite the source plan declaring none. Treat the rewrite's order-of-writes preservation as a hard requirement. If maintained, no risk-check; if altered, run `/risk-check` before commit.

No structural change classes apparent across the remaining 7 items — run `/risk-check` if scope changes.
