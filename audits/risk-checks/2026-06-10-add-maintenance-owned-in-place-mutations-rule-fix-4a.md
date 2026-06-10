# Risk Check — 2026-06-10

## Change

Add a "maintenance-owned in-place mutations" rule to docs/commit-discipline.md — Fix 4(a) of the concurrent-session isolation fix-plan (audits/2026-06-09-concurrent-session-isolation-fix-plan.md §3 Fix 4 route (a)).

WHAT THE CHANGE DOES:
1. Reconciles an existing internal contradiction in commit-discipline.md: L25 (foreign-staging tripwire exempt-list) calls improvement-log.md/decisions.md "append-only shared logs ... benign (no lost update)", while L29-31 (shared-log write-path integrity) calls improvement-log.md/friction-log.md "non-append shared logs ... lost-update hazard." The fix clarifies these describe DIFFERENT operations on the same files: (a) atomic appends (benign across sessions — what L25 means) vs (b) in-place mutations = status flips + archiving (the genuine lost-update surface — what L29 means).
2. Adds a new rule codifying that in-place mutations of improvement-log.md / friction-log.md (status flips via /friday-act; archiving via /resolve-improvement-log) are owned EXCLUSIVELY by the maintenance cadence running in dedicated serialized sessions — never mid-work-session. Mid-session writers (/improve, /resolve-incident, /resolve-repo-problem, session-feedback-collector) are append-only, which is already enforced via the existing append-integrity guard (commit-discipline.md § Shared-log write-path integrity).
3. This codifies an invariant that ALREADY HOLDS — Stage 0 investigation confirmed: /friday-act (status flips) and /resolve-improvement-log (archiving) are the only in-place mutators and both run in the dedicated Friday maintenance cadence; every mid-session writer appends only with the existing integrity guard. No command currently violates the rule. No command edits required.
4. Optionally one cross-reference line in docs/parallel-sessions-playbook.md (no rewrite — fix-plan §5 forbids rewriting the playbook).

FILES TOUCHED: docs/commit-discipline.md (primary); possibly one line in docs/parallel-sessions-playbook.md. No command/agent/hook/settings changes.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-09-concurrent-session-isolation-fix-plan.md — exists

## Verdict

GO

**Summary:** A documentation-only edit that reconciles an existing wording contradiction and codifies an invariant that already holds, touching one (optionally two) read-on-demand docs with no command/hook/settings change and clean git-revert reversibility.

## Consumer Inventory

Search terms: `commit-discipline` (the doc being edited), `improvement-log` / `friction-log` (the files the new rule governs), `friday-act` / `resolve-improvement-log` (the named in-place mutators), `parallel-sessions-playbook` (the optional cross-ref target). Grepped across `ai-resources/` and the workspace root.

The change edits/adds **one section** of commit-discipline.md ("maintenance-owned in-place mutations") and reconciles wording in two existing sections (L25 exempt-list, L29-31 write-path integrity). Consumers below are the files that reference commit-discipline.md. Critically, **every existing consumer points at a *different* section** of the doc (staging discipline, or the write-path append-integrity guard) — none parses or depends on the new/edited section's text.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md (L212) | documents (pointer to "commit-boundary sequencing and concurrent-session staging discipline") | no |
| ai-resources/.claude/commands/tweak.md (L38, L120) | documents (cites § concurrent-session staging discipline) | no |
| ai-resources/.claude/commands/improve.md (L60) | documents (cites § Shared-log write-path integrity append-guard) | no |
| ai-resources/.claude/commands/concurrent-session-check.md (L146) | documents (cites § Concurrent-session staging discipline) | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh (L20, L48) | documents (comment pointer to shared-file review) | no |
| ai-resources/.claude/commands/friday-act.md | co-edits (named owner of in-place status flips; the rule describes its existing behavior) | no |
| ai-resources/.claude/commands/resolve-improvement-log.md | co-edits (named owner of archiving; the rule describes its existing behavior) | no |
| ai-resources/.claude/commands/resolve-repo-problem.md | co-edits (named mid-session append-only writer; already append-only per L13/L80/L94) | no |
| ai-resources/.claude/commands/resolve-incident.md | co-edits (named mid-session append-only writer) | no |
| ai-resources/.claude/agents/session-feedback-collector.md | co-edits (named mid-session append-only writer; already guarded) | no |

Total: 10 consumers, 0 must-change. The `documents` rows reference *other* sections of commit-discipline.md, unaffected by the edit. The `co-edits` rows are the commands the new rule *describes* — the change confirms their existing behavior is correct and requires no edit to any of them (CHANGE_DESCRIPTION item 3, confirmed against friday-act.md Step 1.7 status-line handling, resolve-improvement-log.md L79/L95 archive-removal, and resolve-repo-problem.md L13/L80 "Append ... logged (pending)").

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- commit-discipline.md is a read-on-demand doc, not always-loaded. Its own header gates loading: "When sequencing edits across multiple commits ... or before a full-file rewrite of a shared log" (commit-discipline.md L3). Adding a section to it adds zero per-session or per-turn token cost.
- No always-loaded file (workspace or project CLAUDE.md) gains content — workspace CLAUDE.md L212 already carries only a one-line pointer, and the change does not touch it.
- No hook is registered or modified; CHANGE_DESCRIPTION states "No command/agent/hook/settings changes."
- The optional one-line cross-reference in parallel-sessions-playbook.md is also a read-on-demand doc (its own load-gate header, L3) — no ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. CHANGE_DESCRIPTION: "No command/agent/hook/settings changes." Grep for consumers surfaced no `.claude/settings*.json` edits.
- No new tool-invocation pattern, allow/ask/deny entry, or capability is introduced — the change is prose in two docs.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Consumer Inventory: **10 consumers, 0 must-change.** Single primary file edited (commit-discipline.md), optionally one line in a second doc.
- Contract check (the `parses` concern): the inventory found **no consumer that parses the edited/new section**. The five `documents` consumers (CLAUDE.md L212, tweak.md, improve.md, concurrent-session-check.md, check-foreign-staging.sh) all cite *other* sections — "concurrent-session staging discipline" or "Shared-log write-path integrity" — verified by grep. The new section sits alongside them without altering the text they point to.
- The reconciliation of L25 vs L29-31 wording is internal to commit-discipline.md and clarifies (does not invert) the existing meaning: appends benign, in-place mutations hazardous. No consumer depends on the contradictory phrasing being preserved.
- The five named commands (`friday-act`, `resolve-improvement-log`, `resolve-repo-problem`, `resolve-incident`, `session-feedback-collector`) are `co-edits` in name only — the rule documents their *current* behavior; none requires modification (CHANGE_DESCRIPTION item 3, verified).
- No unanticipated consumer surfaced: the inventory matches the change's own stated scope.

### Dimension 4: Reversibility
**Risk:** Low

- Single-to-double file prose edit. `git revert` of the commit fully restores prior state — no sibling files created, no directory added.
- No data/log mutation: the change *describes* who may mutate improvement-log.md/friction-log.md, but does not itself write to those logs, so revert leaves no stale log entries.
- No settings/cache/hook state to clean up manually; no external write or push implied by the change itself (push remains the operator-gated wrap-time step per workspace CLAUDE.md).

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new rule introduces no new parse marker, filename convention, or output contract that callers must honor — it is an ownership-discipline statement, and the discipline it names is documented *at the change site* (commit-discipline.md itself).
- No silent auto-firing: the change adds no hook and no automation. CHANGE_DESCRIPTION confirms no command/agent/hook changes.
- One implicit dependency exists and is benign: the rule asserts `/friday-act` and `/resolve-improvement-log` are the *only* in-place mutators. This was Stage-0-confirmed and re-verified here (friday-act.md Step 1.7; resolve-improvement-log.md archive-removal at L79/L95; resolve-repo-problem.md L13 "append ... logged (pending)"). If a *future* command adds an in-place mutator outside the cadence, the rule becomes the place that must be updated — but that is the intended single-point-of-truth, not hidden coupling. The existing append-integrity guard (commit-discipline.md L29-45) already backstops mid-session writers.
- No functional overlap with an existing mechanism: this rule governs *who/when* (cadence ownership of mutations); the existing write-path-integrity guard governs *how* an append must be done. They are complementary layers on the same files, and the change explicitly distinguishes them (the L25-vs-L29 reconciliation is exactly this disambiguation).

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read successfully at `projects/strategic-os/ai-strategy/principles-base.md`; relevant IDs below are grounded in it.
- **OP-12 (closure before detection):** the change adds *no new detection* — it codifies an ownership invariant and reconciles existing wording. It leans toward consolidation, which OP-12 favors ("prefer closure and consolidation over new building"). Aligned.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction):** the rule has a *current, confirmed* basis — it documents behavior two existing commands already exhibit, not a hook "for Phase 2." DR-7 requires generalizing only on a confirmed consumer; here there is no generalization at all, just codification of the existing state. No violation. (The Consumer Inventory's `co-edits` rows are existing consumers, not absent ones.)
- **OP-5 (advisory vs enforcement):** the change adds prose discipline; it does *not* upgrade any advisory mechanism to auto-correcting enforcement. The existing tripwire and append-guard keep their current advisory/blocking postures unchanged. No silent enforcement upgrade.
- **OP-11 / OP-3 (loud revision, no silent drift):** the change does not revise a principle; it reconciles a *documentation contradiction* loudly and explicitly (the L25-vs-L29 disambiguation is recorded in the edit itself). This is the opposite of silent drift.
- **DR-1 / DR-3 (placement):** the rule lands in commit-discipline.md, which fix-plan §3/§Related explicitly designates as "home for Fix 4(a)'s wrap-owns rule" (fix-plan L83). Correct tier (canonical `ai-resources/docs/`) and correct home (doc, not a new command/hook). The change also honors fix-plan §5's constraint not to rewrite the playbook — only an optional one-line cross-reference. Aligned.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from commit-discipline.md, the fix-plan, and the five named commands; grep-derived consumer counts; principle IDs from the readable principles-base.md). No training-data fallback was used on fetch/read failures.
