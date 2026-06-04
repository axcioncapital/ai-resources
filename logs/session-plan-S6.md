# Session Plan — S6 (2026-06-04)

## Intent
Run 4 picked carryover items in operator order: (1) git-hygiene commit of the remaining 14 project-repo Session-Boundaries CLAUDE.md conversions + a decision on the per-project `.claude/` commit-vs-symlink tracking model; (2) graduate E1 (`doc-scanner-agent`) to canonical; (3) review the System Owner reference files; (5) reconcile the E10 fold-status inconsistency between the strategic-os tracker and slot-1-decisions.

## Model
Recommended: **opus** (item 1 carries a genuine architecture decision; item 2 is a graduation-pipeline judgment). Active: claude-opus-4-8[1m] — **match**, no `/model` switch.

## Source Material
- Item 1: S5 Next Steps (session-notes.md), `logs/improvement-log.md` (S5 16-repo drift follow-up); the 14 project CLAUDE.md files across the workspace; the systemic `.claude/` tracking question.
- Item 2: `projects/strategic-os/ai-strategy/slot-1-decisions.md` L20 (E1 GRADUATE verdict); `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` (the resource to graduate); `/graduate-resource` pipeline.
- Item 3: `projects/axcion-ai-system-owner/references/` — 6 files (grounding, persona, project-layout, systems-building-principles, toolkit-relationship, craft-iteration-article-2026-06-01).
- Item 5: `projects/strategic-os/ai-strategy/slot-1-decisions.md` (L27, L57 — E10 still "queued"); `projects/strategic-os/ai-strategy/implementation-tracker.md` (L23, L29, L59 — E10 "folded").

## Findings / Items to Address

### Item 1 — Git-hygiene (commit + decision)
- **Commit part:** the F6 blanket Session-Boundaries consolidation (S2) converted 14 project CLAUDE.md files to a pointer; per S5, only ai-resources + strategic-os were committed. The 14 remaining project-repo conversions are uncommitted across foreign repos.
- **Decision part (BLOCKED on operator input):** "should per-project `.claude/` command/agent dirs be committed at all, or gitignored/symlinked from canonical?" S5 flagged this as needing a deliberate reviewed pass. This is an architecture decision, not a mechanical task — it will be surfaced to the operator before any change, and a `/risk-check` gates it.
- Discipline: explicit-path commits per repo, never `git add -A`, foreign drift untouched (S5 pattern).

### Item 2 — E1 graduation
- `doc-scanner-agent.md` confirmed genuinely project-local (exists only in `repo-documentation/.claude/agents/`, not canonical). GRADUATE verdict valid.
- slot-1-decisions explicitly tags this "heavy pipeline — not run inside a closure sweep." Will run `/graduate-resource`, gated by `/risk-check` (new canonical resource + symlink distribution = structural).

### Item 3 — SO reference review (AMBIGUOUS — scope to be defined mid-run)
- 6 reference files exist. "Review" has no stated deliverable. Will ask the operator to pin the intent (staleness/currency check vs content-quality pass vs consistency-against-live-SO) before executing; default proposal = a short currency/staleness findings note.

### Item 5 — E10 fold-status reconciliation
- Real inconsistency confirmed: tracker (L23/L29/L59) says E10 folded into `compaction-protocol.md`; slot-1-decisions (L27 "Queued small edit", L57 "Queued — execution pending") says it is still open.
- Resolution: verify whether the fold actually landed in `compaction-protocol.md` + the repo-documentation CLAUDE.md pointer; if yes, update slot-1-decisions L27/L57 to CONFIRMED-DONE; if no, the tracker is wrong — surface and correct the authoritative one.

## Execution Sequence

### Stage 0 — Risk-check (gate, structural items 1+2)
Run `/risk-check` covering item-1 cross-repo commits + `.claude/` tracking-model change + item-2 E1 graduation. GO → proceed; RECONSIDER/NO-GO → pause, retain mandate+plan.

### Stage 1 — Item 5 (E10 reconcile)
Lowest-risk, contained. Verify the fold, reconcile the authoritative record. `/qc-pass` the doc edits.

### Stage 2 — Item 1 commit part
Commit the 14 project-repo CLAUDE.md conversions, explicit paths per repo, foreign drift untouched. Then surface the `.claude/` tracking-model decision to the operator (cannot auto-resolve).

### Stage 3 — Item 2 (E1 graduation)
Run `/graduate-resource doc-scanner-agent` per the heavy pipeline. `/qc-pass` the result.

### Stage 4 — Item 3 (SO review)
Pin the deliverable with the operator, then produce the agreed review note.

Between-item summaries emitted at each stage boundary (visibility only).

## Scope Alternatives
- **Recommended-at-gate subset (operator chose full instead):** item 5 + item-1 commit part only this session; defer item-1 decision, item-2 graduation, item-3 to dedicated sessions. Operator replied `go` for the full bundle.
- **Minimum viable:** item 5 alone (fast reconcile) if context runs short.

## Autonomy Posture
**Gated** — items 1 (cross-repo shared-state commits + tracking-model change) and 2 (new canonical resource + symlink distribution) trigger structural change classes. `/risk-check` runs before execution (Stage 0). The item-1 architecture decision and item-3 scope are explicit operator-input points, not auto-resolved.

## Risk
- STRUCTURAL_RISK = true. Cross-repo git operations on 14 foreign repos = high blast radius; explicit-path discipline mandatory.
- E1 graduation creates always-distributed canonical content (symlinks) — reversibility is moderate.
- Context budget: 4 heterogeneous items spanning 3+ projects in one session risks compaction; apply context-constraint deferral if it tightens — defer later stages rather than rush.
