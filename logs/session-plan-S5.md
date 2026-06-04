# Session Plan — 2026-06-04 — S5

## Intent
Auto multi-item (reshaped at the approval gate, E1 deferred): (1) decide + execute a clean commit strategy for the unwrapped S1–S3 leftovers, bounded to ai-resources + strategic-os; (2) triage the /prime sibling-repo cross-check gap to improvement-log (no fix); (3) graduate E4 (resolve-improvement-log) via /graduate-resource. E1 (doc-scanner-agent) deferred to a dedicated graduate session per slot-1-decisions.md.

## Model
opus (claude-opus-4-8[1m]) — match. Item 1 is a commit-strategy decision over entangled cross-repo state; item 2 is a graduation pipeline with gates; item 3 is an investigation. Highest-load tier across the set is deciding → opus.

## Source Material
- Item 1: workspace-wide `git status` survey (16 dirty repos); ai-resources + strategic-os diffs verified clean/isolated; `logs/session-notes.md` S2/S3/S4 entries (commit-deferral history).
- Item 2: `projects/strategic-os/ai-strategy/slot-1-decisions.md` (E4 = GRADUATE `resolve-improvement-log`; E1 = "heavy pipeline, dedicated session"); `/graduate-resource` command.
- Item 3: `.claude/commands/prime.md` Step 1a (git cross-check scope); `logs/improvement-log.md`; S4 wrap friction signal (already partly logged).

## Findings / Items to Address

### Item 1 — Commit strategy for leftovers (reshaped)
- **Discovery:** the "leftover S2 work" is entangled in workspace-wide uncommitted drift across ~16 repos — mass deletions (`critical-resource-auditor.md`, `audit-critical-resources.md`, `route-change.md`), dozens of untracked `.claude/` command/agent library files, `.session-marker` churn. Most of this predates and exceeds the S2 Session-Boundaries consolidation.
- **Mandate bound saves scope:** mandate names ai-resources + strategic-os only. The other 14 project-repo CLAUDE.md conversions are out of scope → flagged for a dedicated git-hygiene session, not committed here.
- **ai-resources clean subset:** `CLAUDE.md` (Session-Boundaries one-liner, verified isolated), `templates/project-claude-md/session-boundaries.md`, `docs/session-boundaries.md` (new), `audits/risk-checks/2026-06-04-consolidate-session-boundaries-rule-16-claude-md-to-single-doc.md` (new). Leave: `audits/backbone-manifest.md` (foreign, 107/41), DD audit file (foreign), `logs/session-plan-S1/S2/S3.md` (transient).
- **strategic-os clean subset:** `CLAUDE.md` (Session-Boundaries one-liner), `ai-strategy/slot-1-decisions.md` (F6 override), `ai-strategy/implementation-tracker.md` (Slot-1 status). Leave: two `D` deletions (subsumption, foreign), `ai-strategy/working/system-owner-strategy-review.md` (untracked scratch).

### Item 3 — /prime sibling-repo cross-check gap
- `/prime` Step 1a git cross-check scans only cwd-repo + ai-resources, not sibling project repos (e.g. strategic-os). Surfaces already-done-and-committed items as still-open. Caught by S4's context-discovery engine, not by /prime.
- S4 wrap reported this was "already logged to improvement-log by the feedback collector" — verify; if absent or partial, log a clean entry. Triage-only — no fix to /prime.

### Item 2 — E4 graduation (E1 deferred)
- E4 = `resolve-improvement-log.md` command → GRADUATE (real, in-use, reusable). Run `/graduate-resource resolve-improvement-log`.
- E1 deferred (slot-1-decisions.md: "heavy pipeline — not run inside a closure sweep, dedicated graduate session").
- Structural class (new canonical command) → /risk-check before the graduation per Step 8c.9 + Autonomy Rule #9.

## Execution Sequence

### Stage 1 — Item 1: commit leftovers (ai-resources + strategic-os)
1. ai-resources: `git add` the 4 explicit deliverable paths; commit `batch: session-boundaries consolidation (ai-resources) — S2 deferred deliverable`.
2. strategic-os: `git add` the 3 explicit deliverable paths; commit `batch: ai-strategy Slot-1 records + session-boundaries conversion — S1/S2 deferred`.
3. Leave all foreign drift untouched in both repos. Surface the 14-repo remainder + workspace-wide drift as a [SCOPE] note recommending a dedicated git-hygiene session.

### Stage 2 — Item 3: triage /prime gap
1. Check `logs/improvement-log.md` for the existing S4-logged entry. If present, confirm + optionally enrich; if absent/partial, append a clean triage entry. No /prime edit.

### Stage 3 — Item 2: graduate E4 (risk-check first)
1. Run `/risk-check` on graduating `resolve-improvement-log` to canonical (new command class).
2. On GO: run `/graduate-resource resolve-improvement-log`. Update strategic-os `implementation-tracker.md` + `slot-1-decisions.md` E4 status → done, commit.
3. On RECONSIDER/NO-GO: pause, report, retain plan.

## Scope Alternatives
- **Leaner:** items 1 + 3 only; defer all of item 2 to a dedicated graduate session (E4 is a full pipeline). Viable if context tightens.
- **Fuller:** also commit the 14 other project-repo CLAUDE.md conversions — rejected: out of mandate scope, entangled with heavy foreign drift, deserves its own reviewed git-hygiene session.

## Autonomy Posture
Gated — item 2 E4 graduation is a structural change class (new canonical command); /risk-check runs before it per Autonomy Rule #9. Items 1 and 3 proceed under full autonomy (commit + log-append).

## Risk
- Item 1 commits are explicit-path, isolated, reversible (commit not push). Low risk. Main hazard avoided: never `git add -A` in these dirty repos.
- The workspace-wide drift (16 repos) is a real systemic signal but out of scope; flagged, not actioned.
- Item 2 risk handled by the pre-graduation /risk-check.
