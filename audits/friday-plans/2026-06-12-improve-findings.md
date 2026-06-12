# Friday Act Plan — 2026-06-12 — improve-findings

**Source report:** friday-checkup-2026-06-12.md (weekly tier)
**Journal report:** (none)
**Generated:** 2026-06-12
**Items:** 4

> Each item below is a *bundle* of related `/improve` findings for one scope (the checkup rolled them up per scope). Treat each sub-finding as its own commit at execution time.

## Items

### 1. [med] workspace `/improve` bundle — schema discipline + session-plan preconditions
- **Source:** checkup
- **Risk-check required:** yes — change class: hook (.sh) + workspace CLAUDE.md
- **W2.4 auto-draft:** no
- Sub-findings: (a) schema-read-before-draft rule; (b) schema-conformance hook (route via `/pipeline-review`); (c) session-plan state-file preconditions. The new hook and any CLAUDE.md rule edit each gate on `/risk-check`.

### 2. [med] marketing-positioning `/improve` bundle — remote, deferred QC, tier-C convention
- **Source:** checkup
- **Risk-check required:** yes — change class: project CLAUDE.md
- **W2.4 auto-draft:** no
- Sub-findings: (a) resolve broken remote / ~17 unpushed — decide remote vs. local-only and record the decision in the project CLAUDE.md (the CLAUDE.md edit gates on `/risk-check`); (b) close the deferred QC of `research-workflow-contract.md` via the QC-PENDING mechanism; (c) document the late tier-C reversal cascade convention.

### 3. [med] nordic-pe `/improve` bundle — carve-out precedents, 1M-QC pre-flight, unpushed drain
- **Source:** checkup
- **Risk-check required:** no — re-check at execution: if the 1M-context QC pre-flight note lands in a CLAUDE.md, it becomes a change class
- **W2.4 auto-draft:** no
- Sub-findings: (a) record E4/family-office carve-out precedents in `locked-criteria.md` (content doc); (b) add a pre-flight note for 1M-context QC sessions (placement TBD — re-check change class at execution); (c) drain ~21 unpushed + retire the stale "no remote" Open Question (push is operator-gated at wrap).

### 4. [med] positioning-research `/improve` bundle — outline-lock, session-boundary discipline, memory durability
- **Source:** checkup
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- Sub-findings: (a) add an outline-lock micro-step for synthesis drafting (existing research-workflow command/doc edit); (b) defer infra/canonical edits out of pipeline sessions (reference the session-boundaries doc); (c) confirm the mid-execution memory correction is durable. Risk labelled low/med in the report — queued as med on the outline-lock + boundary-discipline weight.

## Execution notes
- Commit each sub-finding separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- Item 3's pre-flight-note placement decides its change-class status — re-run the change-class check at execution.
- The unpushed-commit drains (items 2a, 3c) are operator-gated `git push` actions at `/wrap-session`, not inline fixes.
- Run `/wrap-session` when all items in this plan are done.
