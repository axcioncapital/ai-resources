# Risk Check — 2026-05-29

## Change

Plan-time gate for TOCTOU mitigation atomic Phase 2+3 (Option A). 10 files in one commit: writers (session-start Step 3, prime Steps 8a.3.a/8b.3.a/8c.3 + 8c.8 + 8c.9 + Step 1a sibling sweep silenced, session-plan Step 0 + Step 7); readers (contract-check Step 2b, drift-check Steps 3/6/7/8, open-items glob, fix-repo-issues-scanner glob, decide Step 2 glob); new docs/session-marker.md. Pre-commit: git rm logs/session-plan.md. Writers hard-fail on marker absent (OP-3); read-only auxiliary readers tolerate. No legacy fallback. Phase 4 N/A.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/toctou-phase-2-and-3-atomic-spec.md — exists (primary input)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-phase-2-full-spec.md — exists (prior PROCEED-WITH-CAUTION verdict for delta)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/open-items.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/decide.md — exists (spot-checked)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/fix-repo-issues-scanner.md — exists (spot-checked)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Option A's atomic landing eliminates the symlink-bridge coupling that drove the prior verdict (Dim 5 drops High → Low for the writer-reader axis), but the spec's "10 files in one commit" list is incomplete — at least three orphan consumers of the bare `logs/session-plan.md` path are NOT updated in this commit and will silently break or degrade after `git rm logs/session-plan.md` ships.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added — workspace CLAUDE.md and `ai-resources/CLAUDE.md` are untouched. New `docs/session-marker.md` (~90 lines) is on-demand reference, not auto-loaded; spec lines 459-549 show it is a standalone doc that consumers "point back to," not `@import`ed anywhere.
- No new hooks, no new subagents, no new skill trigger keywords. The existing `backup-session-plan.sh` PreToolUse hook is untouched and its regex `'(^|/)logs/session-plan(-[a-zA-Z0-9]+)?\.md$'` (verified, hook line 16) already matches the marker-scoped variants `-S1`, `-S2`, etc.
- Net token shift inside command bodies: `/session-plan` Step 0 collapses from 95 lines to ~30 (spec § Item 2c lines 213-243 — saving ~65 lines); `/prime` 8c.9 collision check removed entirely (spec § Item 2b line 197). Aggregate likely net-negative on per-invocation cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No new tool families. `cat`, `stat`, `date`, `echo > path`, `[ -f ]` — all already used at `prime.md`:163-180 baseline.
- No `ln -sfn` call this round (Option A removes the symlink). Pre-commit `git rm logs/session-plan.md` is a one-time setup operation, not a recurring tool invocation in any command body.
- No `deny` rule removed, no scope escalation, no external API, no cross-repo write.

### Dimension 3: Blast Radius
**Risk:** High

- Direct edits per spec: 10 files (3 writers + 5 readers + 1 doc + 1 pre-commit `git rm`).
- **Orphan consumers grep'd that the spec does NOT include in the commit list** — bare `session-plan.md` references that survive the commit and will hit ENOENT or stale text under Option A:
  - `.claude/commands/prime.md:185` and `:187` — operator-facing prompt strings: `"writes logs/session-plan.md"` and `"Plan ready — review logs/session-plan.md"`. Cosmetic-but-misleading post-commit: the file does not exist; the actual write target is `logs/session-plan-${MARKER}.md`. Spec § Item 2b edits only Steps 8a.3.a/8b.3.a/8c.3/8c.8/8c.9 and Step 1a — does not touch lines 185 or 187.
  - `.claude/commands/prime.md:223` — same operator-facing prompt string in Step 8b. Same gap.
  - `.claude/commands/new-project.md:548` — project scaffolding template lists `session-plan.md` as a per-project file. Not updated. New projects will be scaffolded with a stale name.
  - `docs/repo-architecture.md:220` — the architecture table row `| logs/session-plan.md | Session orchestration plan ... | /session-plan |`. Not updated. Canonical architecture doc drifts from reality on commit-day.
  - `docs/weekly-cadence.md:78` — narrative reference: "the per-session plan (`logs/session-plan.md`, produced by `/session-plan`)". Not updated. Stale doc.
  - `docs/compaction-protocol.md:21` — "Target file: append to the active `logs/session-plan.md`". Not updated. Compaction protocol points at a non-existent file.
  - `logs/improvement-log.md:101, :130, :146` — references to `session-plan.md` in the planning text. Historical narrative, lower-priority, but the registry text at line 130 lists "Phase 3 target files" — at least worth noting that Phase 3 just collapsed into atomic.
- Total: at minimum **6 additional locations** holding references to the bare path post-commit that the spec does not address. None are code paths that would silently misroute writes (the writers ARE updated), but `compaction-protocol.md`:21 and `prime.md` operator-facing prompts will produce confusing UX or stale instruction. `new-project.md`:548 scaffolds new projects with a stale filename — that one IS a propagation hazard.
- The spec author's claim "10 files in one commit" understates by ~6 files. Same understatement class as the prior Phase 2 spec's "3 command files" claim that the previous risk-check flagged.
- Contract change to the today's-header pattern in `session-notes.md` (`## YYYY-MM-DD` → `## YYYY-MM-DD — Session ${MARKER}`). The prior risk-check verified that the prefix-anchor `^## YYYY-MM-DD` continues to match for legacy regex consumers (`wrap-session.md`:63, :115, :212 — verified). That cross-cut still holds.

### Dimension 4: Reversibility
**Risk:** Medium

- Single atomic commit — `git revert <hash>` cleanly undoes all 10 file edits in one step. Cleaner than the prior Phase 2-only file-to-symlink one-way state change.
- `git rm logs/session-plan.md` reverses via `git revert` — the file content is restored from the commit's deletion record. Verified: `git rm` deletions are part of the commit's tree and round-trip via revert.
- The marker-scoped files (`logs/session-plan-S1.md`, `-S2.md`, etc.) created post-commit will NOT be auto-removed by a `git revert` of the commit — they were created by post-commit runs of `/session-plan` and live outside the reverted commit. After revert, the operator must manually `rm logs/session-plan-S*.md` and re-run `/prime` for the pre-commit state. The spec's rollback recipe (commit message lines 603-604) names this: `git revert <hash>; rm -f logs/.session-marker logs/session-plan-S*.md`. The recipe is accurate.
- Forward-debt risk: spec does NOT add `logs/session-plan-S*.md` to `.gitignore` (gitignore tail verified — only `.session-marker` and `.prime-mtime` are excluded). This means every session's plan accumulates as committed git history going forward. The current `logs/` directory already has `session-plan-bundle5.md`, `-next.md`, `-pass2/3/4/5.md` evidence of similar accumulation patterns. Not a revert blocker, but the spec is silent on the policy.
- The pre-commit `git rm` removes `logs/session-plan.md` (8742 bytes verified to exist on disk). Recoverable via revert; not data loss.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Asymmetric writer/reader contract — well-founded.** Spec § Item 3a note (lines 301-302) articulates the rationale: "marker-absent case might be a perfectly legitimate 'operator runs `/contract-check` after a session ends' workflow." Writers create state (hard-fail correct under `principles.md § OP-3`); read-only auxiliary consumers serve post-session use cases (tolerate correct). The asymmetry is documented in `docs/session-marker.md`'s registry (spec lines 524-534). Each consumer's classification is grounded in its actual use mode: `/contract-check`, `/drift-check`, `/open-items`, `fix-repo-issues-scanner`, `/decide` all run in both mid-session and post-session contexts. Correct classification.
- **Symlink elimination — drops prior High to Manageable.** The prior verdict's load-bearing High concern (symlink last-writer-wins cross-session race; asymmetric phase coupling lock-in) is structurally eliminated under Option A. There is no shared symlink. Each session writes its own marker-scoped file. Readers either target this session's marker or scan a glob. No cross-session write-through path exists.
- **New coupling introduced — incomplete consumer registry.** The spec's `docs/session-marker.md` registry (spec lines 524-534) names 8 consumers (3 writers + 5 readers). The grep shows at least 3 additional consumers with bare-path references (new-project.md scaffolding, repo-architecture.md table, compaction-protocol.md target-file note). These are out-of-scope for behavior but in-scope for the two-end-contract registry — a reader looking at `docs/session-marker.md` to understand who depends on the marker will get an incomplete picture, and future authors editing one of those three docs won't know they're touching the contract.
- **`prime.md` operator-facing prompt strings (lines 185, 187, 223) drift.** These tell the operator "review `logs/session-plan.md`" after auto-mode runs — but the file does not exist post-commit (the actual file is `logs/session-plan-${MARKER}.md`). Not a code-path coupling, but a user-experience coupling between Step 8c.8's write target (correctly updated) and Step 8c's operator-facing prompts (not updated). Operator clicks/looks at a non-existent path.
- **No silent auto-firing concerns.** No new hooks. The existing `backup-session-plan.sh` hook regex already matches `session-plan-S*.md` (verified). No silent cross-session mutations introduced.
- **`/open-items`, `fix-repo-issues-scanner`, `/decide` glob widening.** Spec § Items 3c/3d/3e (lines 358-451). Each acknowledges the widening explicitly. `/decide` line 451 self-flags: "This is actually a slight broadening of `/decide`'s prior-decision coverage — captures decisions made in sibling sessions as well as this one. Conservative behavior; matches `/decide`'s goal of preventing rework." Same for `/open-items` (cross-session backlog visibility). The widening is justified by the post-commit reality (no single canonical plan exists; the only meaningful aggregation IS the glob), and is bounded (read-only, no writes triggered by the glob). Acceptable scope creep.
- **`/prime` Step 1a sibling-sweep silencing.** Spec § Item 2b lines 131-151. Correct against `principles.md § AP-10` (no warning for impossible-or-normal scenarios) — multiple same-day marker-bearing headers IS the new normal under Option A. Spec offers two options (silence with informational line vs remove entirely); recommends the informational line. Loses no visibility into a residual hazard because the hazard class (shared-state same-day TOCTOU) is structurally eliminated. The informational line preserves operator visibility into concurrent-session count. Correct call.

### Delta vs the prior Phase 2-only verdict (PROCEED-WITH-CAUTION)

For each of the prior 6 mitigations:

- **M1 (chain Wave 2 in same session):** N/A-UNDER-OPTION-A — Option A IS the atomic landing. No "Wave 2 scheduling" concern remains.
- **M2 (fix prime.md:319 auto-mode 8c.8, don't document):** APPLIED-IN-DESIGN — spec § Item 2b Step 8c.8 lines 191-195 update auto-mode to write `logs/session-plan-${MARKER}.md`. SO advisory's load-bearing recommendation honored.
- **M3 (canonical header-format stub):** APPLIED-IN-DESIGN — spec § Item 4 lines 455-549 ship the full `docs/session-marker.md` (not just a stub). Two-end-contract registry included.
- **M4 (read-tests for downstream consumers):** SURVIVES-AS-STILL-REQUIRED — still applicable as a pre-commit verification step. Option A makes the readers marker-aware, so the test is now "marker resolution works at each reader site" rather than "symlink resolves transparently." Same mitigation, slightly different shape. Should be retained as Execution-Sequence step in session-plan.
- **M5 (manual rollback recipe in commit message):** APPLIED-IN-DESIGN — spec lines 603-604 include the recipe: `git revert <hash>; rm -f logs/.session-marker logs/session-plan-S*.md; re-run /prime`.
- **M6 (gitignore decision on `logs/session-plan-S*.md`):** SURVIVES-AS-STILL-REQUIRED — spec is silent on this. Verified gitignore tail (no `session-plan-S*.md` entry). The accumulation policy is undecided; default behavior is "track them" by absence. SO advisory recommended "track them, don't gitignore" — operator can accept this default but should document the decision.

Three of the six prior mitigations are applied in design. One is N/A. Two survive as still-required (M4 read-tests; M6 gitignore decision).

## Mitigations

- **Dimension 3 (Blast radius — orphan consumers):** Before committing, expand the file set to include the 4 orphan consumers with the highest impact: `.claude/commands/prime.md` lines 185, 187, 223 (operator-facing prompt strings — change `logs/session-plan.md` → `logs/session-plan-${MARKER}.md`); `.claude/commands/new-project.md` line 548 (scaffolding template — change `session-plan.md` → `session-plan-${marker}.md` with a parenthetical note); `docs/repo-architecture.md` line 220 (architecture table row — update path column); `docs/compaction-protocol.md` line 21 (target file note — update path). The remaining `docs/weekly-cadence.md`:78 and `logs/improvement-log.md` historical references can be deferred as narrative drift — flag in commit message but do not block.
- **Dimension 3 (Blast radius — registry completeness):** Update `docs/session-marker.md` § Two-end contract registry (spec lines 524-534) to include the additional consumers updated in the prior mitigation. Specifically add the documentation files (`docs/repo-architecture.md`, `docs/compaction-protocol.md`) under a new "Documentation references" subsection so future authors editing those docs see the dependency. Otherwise the registry under-states by 2-3 entries on day one.
- **Dimension 4 (Reversibility — `session-plan-S*.md` accumulation policy):** Explicitly decide whether `logs/session-plan-S*.md` should be tracked (history) or gitignored (per-machine ephemera). Per SO advisory M6, recommend tracking. Document the decision in the commit message one-liner. Sub-second addition, closes the silence.
- **Dimension 5 (Hidden coupling — pre-commit verification):** Per surviving M4, run pre-commit read-tests at each reader site: spawn a fresh shell, set `MARKER=S1`, write a stub `logs/session-plan-S1.md`, then dry-run the marker-resolution helper in each of `/contract-check`, `/drift-check`, `/open-items`, `/decide`, `fix-repo-issues-scanner` (read-only paths — verify each resolves the marker and reads the correct file, and that absent-marker falls through to the documented tolerate-path). Mechanical pass; catches resolution-helper bugs before commit ships.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: spec section/line references (Item 2b lines 124-201, Item 2c lines 209-243, Item 2d lines 253-273, Item 3a lines 285-302, Item 3b lines 311-347, Item 3c lines 357-381, Item 3d lines 389-422, Item 3e lines 431-446, Item 4 lines 455-549, atomic commit composition lines 558-605); grep counts for orphan consumers (5 documentation/command references not in spec's 10-file list); file existence verification (`logs/.session-marker` present 14 bytes, `logs/session-plan.md` present 11630 bytes, `logs/session-plan-pass*.md` already accumulating per `ls -la logs/`); gitignore tail verified (no `session-plan-S*.md` exclusion); `backup-session-plan.sh` regex `'(^|/)logs/session-plan(-[a-zA-Z0-9]+)?\.md$'` already matches marker-scoped variants (verified at hook line 16); prior risk-check report read in full for delta comparison. No training-data fallback used.

---

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Invoked via direct `system-owner` agent spawn because the `/consult` Skill tool is currently disabled-model-invocation (documented workaround per session-notes 2026-05-29 cycle-2 wrap)._

### Q1 — Concur with PROCEED-WITH-CAUTION? Or re-verdict given missed orphans?

**Concur with PROCEED-WITH-CAUTION.** The verdict is correct; do not re-verdict.

The Round 2 review did its job. `new-project.md:548` is the load-bearing find (scaffolding-time propagation of a stale filename into every new project is the silent-degradation pattern `principles.md § OP-3` rules out). `prime.md:185/187/223`, `repo-architecture.md:220`, and `compaction-protocol.md:21` are real consumers, named with line numbers and a recommended fix.

**The recursive PROCEED-WITH-CAUTION is meaningful signal — but not "redesign is bad" signal.** It is "inventory discipline is the binding constraint" signal. The spec author understated by 4 files in Round 1, then by 4 files again in Round 2 — same defect class, two rounds in a row. The verdict is correctly flagging that pattern.

### Q2 — Mitigation 1 (extend to 14 files): right call, or reintroduces material miss?

**Right call. Does NOT reintroduce asymmetric coupling.**

The Round 1 material miss was **asymmetric phase coupling** — writers updated in commit A, readers in commit B, with a symlink bridge leaving a TOCTOU window open across commits. The race was *cross-commit and cross-session*.

The Round 2 mitigation extends a *single atomic commit* from 10 to 14 files. There is no boundary. Every consumer reaches the new state simultaneously. `principles.md § OP-3` is satisfied; `principles.md § DR-7` is satisfied (extending coverage to confirmed real consumers, not generalization). Blast Radius Medium → High is correctly priced into PROCEED-WITH-CAUTION; inside an atomic commit, blast radius is bounded by commit boundary and revertible in one operation.

### Q3 — Are there MORE orphans the Round 2 reviewer missed?

**Two additional live references found. Both narrative/comment drift, not behavioral.**

1. **`ai-resources/.claude/hooks/backup-session-plan.sh:4, 13`** — comment text. Regex behavior fine (matches marker variants); narrative stale. Low priority.
2. **`ai-resources/docs/heavy-read-discipline.md:45`** — narrative reference. Documentation drift; not behavioral.

Same class as the Round 2 reviewer's deferred `weekly-cadence.md:78` and `improvement-log.md` history references. **The verdict-correct-but-incomplete pattern does NOT emerge for behavior** — it emerges for narrative drift only. Workflows-research-workflow references are a different `session-plan.md` (per-section research-workflow plan file; correctly out of scope).

### Q4 — Stop sign or continue?

**Continue. The right pattern is "do MORE per commit" (extend to 14, plus the 2 narrative items if you want clean tree state). NOT "do less per commit" (revert to Phase 2-only with mitigations).**

Two PROCEED-WITH-CAUTIONs would be a stop sign only if they shared the same risk shape. They don't:
- **Round 1** was driven by Hidden Coupling High (symlink bridge, asymmetric phase coupling) — *structural* concern.
- **Round 2** is driven by Blast Radius High (orphan consumers) — *execution-completeness* concern.

"Do less per commit" (revert to Phase 2-only) is structurally worse — it would re-open Round 1's symlink bridge. Trades known-and-mitigable Blast Radius High for known-and-unmitigable Hidden Coupling High. Fails `OP-3` and `AP-10`.

### Position

**Proceed with the atomic Phase 2+3 commit, extended to all 14 files per Round 2 Mitigation 1.** Apply all four Round 2 mitigations as written. Optionally add the 2 narrative-drift items (`backup-session-plan.sh` comment, `heavy-read-discipline.md:45`) — recommend adding (1-line + 1-line touches, clean-tree benefit).

**Process observation (not blocking):** spec author understated the inventory by 4 files in Round 1, then by 4 files again in Round 2. Recommend logging in `ai-resources/logs/maintenance-observations.md` as a Friday-cadence improvement candidate per `principles.md § AP-11` — a pre-spec grep checklist for "all live consumers of every renamed/removed path" would have closed both Round-N inventory gaps before reaching risk-check.

**Files cited:**
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/toctou-phase-2-and-3-atomic-spec.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-atomic-phase-2-3.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-phase-2-full-spec.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/principles/principles.md` (OP-3, DR-7, AP-10, AP-11)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/risk-topology.md` (§ 1 load-bearing components)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/backup-session-plan.sh` (lines 4, 13 — new narrative-drift finding)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/heavy-read-discipline.md` (line 45 — new narrative-drift finding)
