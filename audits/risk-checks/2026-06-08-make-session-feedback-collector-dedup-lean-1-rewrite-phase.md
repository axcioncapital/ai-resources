# Risk Check — 2026-06-08

## Change

Make session-feedback-collector dedup lean: (1) rewrite Phase 3 dedup from full-Read of friction-log + improvement-log + improvement-log-archive into grep-first/read-narrow (grep root-cause terms + principle IDs, Read ~10 lines around hits); (2) drop improvement-log-archive from the dedup scan entirely (already non-functional — denied by settings.json lines 28/32); (3) align the binding rubric docs/session-feedback-dimensions.md Constraint 3 and wrap-session.md Step 6.5 input list to match. 4 files, ai-resources canonical copies only. Must not weaken Constraint A (append cap), B (provenance), E (truncation guard on full-rewrite fallback). Workspace-root copy deferred.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-feedback-dimensions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists

## Verdict

GO

**Summary:** A lean-pass refactor of one subagent's dedup step plus two aligned rubric/command edits; the dropped archive scan is already dead (settings deny confirmed), every other consumer of the archive contract is out-of-scope and untouched, and the load-bearing constraints (A/B/E) are explicitly preserved — clean `git revert`, no permission or always-loaded-weight change.

## Consumer Inventory

Search terms derived: `session-feedback-collector` (agent basename + component name), `session-feedback-dimensions` (rubric basename), `improvement-log-archive` (the dedup-input contract being dropped), `wrap-collector` (the provenance/revert marker the change must not weaken). Grep run across `ai-resources` and the workspace root. Hits in `logs/`, `audits/`, `audits/working/`, `output/`, `vault/`, `pipeline/`, scratchpads, and project-local `improvement-log.md` files are **historical records / unrelated project logs**, not functional consumers of the changed contract, and are excluded. The functional consumers — components whose behavior depends on the three changed files or the archive-dedup contract — are:

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md | (this is the changed file — Phase 3 rewrite) | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-feedback-dimensions.md | parses (binding rubric Constraint 3 names the archive as a dedup input) | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md | invokes (Step 6.5 launches the collector, passes archive path in input list) | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json | documents (deny lines 28/32 are the reason the archive scan is non-functional — read only, no edit) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md (workspace-root, non-symlink copy) | invokes (independent Step 6.5 port; Step ~376–379 launches the same collector + passes the archive path) | no (deferred by design) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve.md | documents (references improvement-log-archive in its own logic — not the collector's dedup) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md | documents (own archive reference — out of scope) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md | documents (own archive-writer logic — out of scope) | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md, prime.md, post-project-review.md; .claude/agents/fix-repo-issues-scanner.md | documents (each references the archive in unrelated contexts) | no |

Total: 9 distinct functional-consumer rows (3 must-change — the three in-scope canonical files; 6 no-change). The fourth referenced file (settings.json) is read-only evidence, not edited. One consumer not named in CHANGE_DESCRIPTION as a must-change but correctly deferred: the workspace-root non-symlink `wrap-session.md` copy — see Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The collector is a pay-as-used subagent invoked only by `/wrap-session` Step 6.5, behind the preflight "Feedback + outcome" bundle-2 toggle (`wrap-session.md` lines 20–21) — not always-loaded, not auto-firing per turn. No content is added to any CLAUDE.md or `@import` chain.
- The change *reduces* per-invocation token cost: it replaces a full-`Read` of three logs in Phase 3 (`session-feedback-collector.md` line 49: "check each candidate against active `improvement-log.md` entries and `improvement-log-archive.md`") with grep-first/read-narrow, and drops one of the three reads entirely. Direction of change is cost-down, not cost-up.
- No hook, SessionStart/PreToolUse registration, or skill trigger is added. `settings.json` hooks block (lines 40–139) is unchanged.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edit to `settings.json` — it is read as evidence only. The `allow`/`deny`/`hooks` blocks are untouched.
- The change moves *within* the existing permission envelope: it stops attempting a `Read` that the deny list already blocks. Verified — the deny pattern `logs/*archive*.md` (line 32) matches `logs/improvement-log-archive.md` (glob match confirmed by shell `case` test). The archive read was already failing; removing the attempt narrows, not widens, the effective surface.
- No new Bash/Write/external pattern introduced. The collector's `tools:` list (`session-feedback-collector.md` lines 5–9: Read, Glob, Grep, Write) already includes Grep, which the grep-first dedup uses — no tool grant needed.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: 9 functional consumers, 3 must-change. The 3 must-change are exactly the in-scope canonical files the change names (agent, rubric, command) — a closed, self-consistent set.
- The dropped contract (archive as a collector dedup input) has **zero live consumers that lose function**: the archive read was already denied by settings, so no downstream dedup behavior changes. The 6 other commands referencing `improvement-log-archive` (improve, friday-checkup, resolve-improvement-log, session-start, prime, post-project-review, fix-repo-issues-scanner) reference it in their *own* logic, not the collector's Phase 3 — none parse or depend on the collector's dedup input list. Confirmed by scoping the grep to `.claude/commands` + `.claude/agents` + `docs`.
- Contract alignment is the whole point of edits (2) and (3): the rubric Constraint 3 (`session-feedback-dimensions.md` line 53) and the `wrap-session.md` Step 6.5 input list (line 398) both currently name the archive; the change brings all three in sync, closing — not opening — a contract mismatch.
- Inventory gap called out: the workspace-root non-symlink copy of `wrap-session.md` still names the archive path in its Step 6.5 port (line ~379). The change defers it explicitly ("Workspace-root copy deferred"). This leaves a temporary cross-copy divergence but is harmless — that copy's archive read is denied by the same settings layer, so it too is already a no-op. See Dimension 5.

### Dimension 4: Reversibility
**Risk:** Low

- Three in-scope edits are all prose/instruction edits to versioned `.md` files (agent body, rubric doc, command body). `git revert` of the change commit fully restores prior state — no sibling files created, no data/log mutation, no `settings.json` cached state.
- The collector writes only `friction-log.md` and `improvement-log.md` and the change does not touch its write path (Constraints A/B/E preserved per the change's own guard), so no append-only log mutation is introduced by the change itself.
- Nothing propagates beyond git: no push (gated/batched), no external write, no symlink or hook added that could fire between landing and revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change is contract-aligning by construction: it removes an implicit dependency (the collector assuming a readable archive) rather than adding one. After the change, the three in-scope files agree on the dedup-input set (improvement-log + friction-log, no archive).
- One known, documented divergence is *deferred, not hidden*: the workspace-root `wrap-session.md` (an independent non-symlink copy, confirmed not a symlink) retains the archive path in its Step 6.5 input list and carries an explicit MIRROR NOTE (line 372) instructing the two copies be kept in sync. The deferral is stated in CHANGE_DESCRIPTION, so it is a tracked, surfaced divergence — not silent drift. It is also functionally inert (same settings deny applies workspace-root). Recommend the operator log the deferred sync follow-up so the MIRROR NOTE contract is honored next time that copy is edited.
- No auto-firing in unexpected contexts: the collector runs only at wrap behind a preflight gate. No functional overlap introduced — the change narrows existing behavior.
- Constraints A (append cap), B (provenance/`wrap-collector` revert marker), and E (read-during-rewrite truncation guard on the full-rewrite fallback, `session-feedback-collector.md` lines 68–77) are out of scope of the Phase 3 dedup edit and the change explicitly commits not to weaken them. The grep-first dedup operates before the append path, so it does not touch the Constraint E full-rewrite guard.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base (`projects/strategic-os/ai-strategy/principles-base.md`) was readable; checks applied against it directly.
- **OP-12 (closure before detection):** the change *removes* a non-functional detection path (a dead archive scan) and tightens an existing dedup — it adds no new detection without closure. Aligns with OP-12, does not strain it.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction):** the change is a leanness/correctness fix on a confirmed, in-use component, not generalization for an absent consumer. No speculative hooks. Aligns.
- **DR-5 (CLAUDE.md / always-loaded weight):** no always-loaded content added. The rubric and agent files are read-on-invocation, not every-turn. Aligns.
- **OP-5 (advisory vs enforcement):** the collector stays advisory ("nothing you produce blocks a commit or push", `session-feedback-collector.md` line 125); the change does not move it toward enforcement. Aligns.
- **DR-1 / DR-3 (placement):** edits stay in the canonical `ai-resources/` copies of the agent, rubric, and command — correct tier and home. Aligns.
- **OP-11 / OP-3 (loud, not silent):** the deferred workspace-root copy is named explicitly in the change and governed by an existing MIRROR NOTE — the divergence is surfaced, not drifted. Aligns.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and referenced files, a confirmed glob-match test showing `logs/*archive*.md` deny covers `logs/improvement-log-archive.md`, and a symlink check on the workspace-root copy). No training-data fallback was used on fetch/read failures.
