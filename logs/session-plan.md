# Session Plan — 2026-05-25

## Intent
Implement Sonnet 200k plan Tasks 1+2+3 (compaction checkpoints, qc-reviewer cap, session-start optional fields) sequenced with a commit after each; Task 5 stretch if context permits.

## Class
execution

## Model
sonnet — → /model sonnet (currently on opus; tasks are spec-following doc/agent/command edits)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/sonnet-200k-efficiency-implementation.md` (the plan being executed)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/sonnet-200k-efficiency-diagnostic-2026-05-25.md` (diagnostic context per plan's pre-execution gate)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md` (Task 1 target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` (Task 1 + Task 3 target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` (Task 1 target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md` (Task 2 target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md` (Task 2 parity-check reference)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` (Task 3 target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (risk-check change-class reference for Tasks 2 and 3)

## Findings / Items to Address
1. **Task 1** — `sonnet-200k-efficiency-implementation.md` §32–59. Append "Named checkpoints" section to `compaction-protocol.md` with 4 checkpoints (post-inspection, post-implementation, post-QC, pre-closeout); each names required on-disk state, recommended target file, and `/clear` vs `/compact` preference. Add one-line pointers in `wrap-session.md` Step 0.5 (after the existing scratchpad body) and in `session-plan.md` (identify correct section before inserting). Preserve the two existing compaction-protocol rules verbatim.
2. **Task 2** — `sonnet-200k-efficiency-implementation.md` §63–84. Add explicit output cap (max 10 findings) to `qc-reviewer.md` agent body. Required output shape: pass/fail verdict + findings list + per-finding fix recommendation; optional full notes to `audits/working/`. Read `refinement-reviewer.md` first to confirm parity or divergence with its cap before committing. Sanity-check by reviewing last 3 `/qc-pass` invocations to confirm no legitimate run exceeded 10 findings.
3. **Task 3** — `sonnet-200k-efficiency-implementation.md` §88–124. Add two new optional mandate fields to `session-start.md`: `allowed_inputs:` (authorized read paths) and `required_outputs:` (expected artifacts). Both optional (preserves OP-2 autonomy default). Extend Step 3 bullet-format with two new optional bullets (`- Allowed inputs:` / `- Required outputs:`) written only when populated; update Step 3 parse-contract note to name the new labels. Update `wrap-session.md` Step 7a coaching classification to recognise the new bullet labels. `/qc-pass` after edit.
4. **Task 5 (stretch)** — `sonnet-200k-efficiency-implementation.md` §137–148. New file `docs/heavy-read-discipline.md` covering: which commands legitimately read archive/historical directories (`/log-sweep`, `/wrap-session`, `/repo-dd`, `/friday-checkup`) and why; default read floor for normal sessions (tied to `[HEAVY]` guardrail, not a mandate field); what NOT to read by default in normal sessions. Documentation-only; no risk-check class.

## Execution Sequence
Per plan §168–180 — risk-ordered (foundational → dependent), but Tasks 1–3 are technically independent so any may be skipped on blocker without halting downstream:

1. **Task 1** (docs-only, zero risk, highest leverage). Read `compaction-protocol.md`, `wrap-session.md`, `session-plan.md` to locate insertion points. Apply edits. Verify: 4 checkpoints named, pointers landed in both consuming commands, two existing rules preserved. Commit.
2. **Task 2** (canonical-agent edit, optional risk-check). Read `refinement-reviewer.md` for parity check. Plan-time `/risk-check` (operator may skip per plan §68 — invoke given auto-symlink blast radius across every project). Apply edit. Verify: cap present in agent body, output shape spec matches plan. End-time `/risk-check`. Commit.
3. **Task 3** (command edit with two-end parse-contract update). Plan-time `/risk-check` recommended (parse-contract tripwire — see Risk section). Read `session-start.md` Step 3 + `wrap-session.md` Step 7a to confirm insertion points. Apply edits to both files. `/qc-pass` on the changes. Verify: two new optional bullet labels in Step 3, parse-contract note updated, Step 7a recognises new labels, legacy behavior unchanged when fields omitted. End-time `/risk-check`. Commit.
4. **Task 5 (stretch — context-gated)** — execute only if ≥40% context remaining after Task 3 commit. Otherwise defer to fresh session. Create new file; no edits to existing commands needed. Commit.

Between-gate summary (per workspace CLAUDE.md): one-line summary in chat after each commit naming what shipped and what's next.

## Scope Alternatives
- **Min:** Task 1 only (~15–30 min, zero risk, docs-only). Use if context unexpectedly constrained at session-start.
- **Recommended:** Tasks 1 + 2 + 3 (~65–130 min, full required set per plan).
- **Max:** Tasks 1 + 2 + 3 + 5 (~85–160 min, includes stretch doc).

## Autonomy Posture
**Full autonomy** — per workspace CLAUDE.md default. Plan is well-specified; per-task acceptance criteria are observable; between-gate summaries provide visibility without blocking.

**Stop points:**
- Plan-time `/risk-check` verdict for Tasks 2 and 3 (PROCEED-WITH-CAUTION mitigations must be applied before edit; STOP verdict pauses).
- `/qc-pass` REVISE verdict on Task 3 (after the parse-contract edit).
- Context check before Task 5 (stretch decision — defer to fresh session if context lean).
- Otherwise per workspace autonomy rules (no session-specific additions).

## Risk
**Run `/risk-check` after this plan is approved (plan-time gate) for Tasks 2 and 3; run again before commit (end-time gate) per `docs/audit-discipline.md` two-gate model.**

- **Task 1** — docs-only edit; not in any structural change class. No `/risk-check` required.
- **Task 2** — edit to existing canonical agent (`qc-reviewer.md`). Not strictly in enumerated change classes, but blast radius extends to every project running `/qc-pass` via auto-symlink. Plan §68 calls `/risk-check` "optional — invoke given the auto-symlink blast radius." Treating as a soft yes.
- **Task 3** — command edit touching two files with a coupled parse-contract (`session-start.md` Step 3 writes labels, `wrap-session.md` Step 7a reads them). Per the Step 6 tripwire ("edits that reorder operations against shared state"), this is an additive change rather than a reorder — but the two-end coupling and the cross-session-artifact effect (mandate fields land in `logs/session-notes.md` and are read by a downstream command) make `/risk-check` prudent.

Task 5 (stretch, if executed) — new docs file, no structural change class. No `/risk-check` required.
