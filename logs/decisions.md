# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-29 — Friday-act session-qc-pipeline: 1 APPLIED, 3 SCHEDULE-DEDICATED

**Scope.** Plan session-qc-pipeline had 4 items, 2 [high]. 3 of 4 require /risk-check (shared-state automation OR workspace CLAUDE.md cross-cutting). Substantial structural work; dedicated sessions preferred over multi-task burst.

### Item 1 — Complete TOCTOU mitigation Phases 2-4
SCHEDULE-DEDICATED [high]. Phase 1 (write-only) shipped 2026-05-28 (commit ea93d62). Remaining: `/session-start` + `/session-plan` consume `.session-marker`; downstream consumers `/wrap-session` + `/handoff`; legacy-fallback cleanup. 4 commands to patch with cross-coordinated read protocol. /risk-check required (shared-state automation). Dedicated session within 2 weeks. Phase 1 already mitigates the worst silent-leak path; remaining phases are formalization.

### Item 2 — Auto-apply /qc-pass fixes (REVISE + wording-level + no DISAGREE)
SCHEDULE-DEDICATED [high]. Requires: (a) define "wording-level/mechanical" finding class explicitly, (b) update `/resolve` or the QC → Triage Auto-Loop to skip the prompt and log the auto-apply event in decisions.md, (c) update workspace `CLAUDE.md` § QC → Triage Auto-Loop pointer AND `docs/qc-independence.md` § QC → Triage Auto-Loop. /risk-check required (workspace CLAUDE.md cross-cutting). Dedicated session within 2 weeks — auto-apply rule design is high-leverage and warrants careful boundary-drawing on the "mechanical" class.

### Item 3 — Add Step 2.5 self-check QC to /session-start
✓ APPLIED. Inserted Step 2.5 with four floor checks (work_scope is a sentence not a topic; exit_condition is observable; files_in_scope ≥1 path or `(inferred)`; stop_if is concrete or `(none stated)`). Re-asks max once per field; otherwise auto-fix silently with one-line log appended to Step 4 confirmation. Mirrors `/session-plan` Step 7 self-check pattern. No /risk-check (single-file command edit).

### Item 4 — Strengthen /graduate-resource Step 4+5 generalization + verification
SCHEDULE-DEDICATED [med]. Requires a verify-the-gap-is-real pre-step (run subagent grep-scan against 2-3 recently-graduated resources to confirm the gap is real) BEFORE designing the fix. Then design + edit ai-resources/docs/ai-resource-creation.md § graduation rules. /risk-check required (workspace CLAUDE.md cross-cutting AI Resource Creation pointer). Dedicated session — gap-verification + design + risk-check is a natural 1-hour focused unit.

### Closure note
This dispatch converts 4 plan items into 1 APPLIED (item 3), 3 SCHEDULE-DEDICATED (items 1, 2, 4). All 3 deferred items target 2-week horizon; none are silent drops — each will get its own /session-start mandate when picked.

---

## 2026-05-29 — Friday-act general: 2 APPLIED, 5 SCHEDULE-DEDICATED, 2 PENDING, 1 LAST

**Scope.** Plan general had 10 items, 2 [high]. Item 1 hard-stops without operator GO (DR-8). Item 9 is /cleanup-worktree (runs last per plan ordering).

### Item 1 — Concurrent-session detection hook (DR-8 gate)
SCHEDULE-DEDICATED [high]. DR-8 gate waiting for explicit operator GO before build. Not actioned this session because the hard-stop pre-build approval has not fired. Operator-driven: when ready, invoke a dedicated build session.

### Item 2 — Fix log-sweep-auditor Cat A2 heuristic
✓ APPLIED. Cat A1/A2 and Cat B threshold logic updated: over-threshold now requires `line_count ≥ threshold AND entry_count > KEEP`. Eliminates the long-line / few-entry false-positive pattern. Edit at ai-resources/.claude/agents/log-sweep-auditor.md.

### Item 3 — Extract change-shape classifier to shared reference doc
SCHEDULE-DEDICATED [med]. Two-end contract (`/consult` + `/pm` share the classifier). Dedicated session needed to: (a) extract the logic to a new docs/ reference file, (b) update both consumer commands to point at the doc, (c) verify both readers still resolve. Not a /risk-check class but the cross-resource consistency check (Step 6 Tripwire reminder in the session plan) means careful work.

### Item 4 — Extract Q1-Q8 placement logic into skills/placement-classification/SKILL.md
SCHEDULE-DEDICATED [med]. New skill path → /risk-check required. Two confirmed consumers. Dedicated session: create skill, /risk-check, /qc-pass, update consumers.

### Item 5 — Investigate sub-subagent dispatch limitation in /pm
PENDING [med]. Investigation-only at this stage. Recorded here as `Status: pending` (NOT applied). Findings:
- `/pm` (project-manager) ships in degraded mode for structure escalation because Task tool is not available agent-to-agent.
- Workaround paths: (a) operator-mediated escalation (have main session re-invoke /consult); (b) main-session pre-dispatch (caller decides escalation before invoking /pm); (c) extend Task tool agent-to-agent (Claude Code platform feature, not actionable here).
- No fix this session. Schedule a tighter investigation if escalation rate grows.

### Item 6 — Create improvement-log.md in obsidian-pe-kb + project-planning
✓ PARTIALLY APPLIED. obsidian-pe-kb log seeded with canonical header (no entries). project-planning already has an existing improvement-log.md — no creation needed; verified in pass.

### Item 7 — Schedule dedicated session for /wrap-session refactor + permission-sweep-auditor follow-ups
SCHEDULED [med]. Target: dedicated session within next 2 weeks. Both deferred twice; third defer would be silent drift. /wrap-session refactor is leaner-rewrite (token-audit lever); permission-sweep-auditor follow-ups are the deferred auditor enhancements. Block out 1 hour.

### Item 8 — Build /clean-folder workspace-level command
SCHEDULE-DEDICATED [med]. New command path → /risk-check required. Plan-only output (restructure plan to audits/restructure-plans/). Dedicated session: design + /placement at build time + /risk-check + /qc-pass.

### Item 9 — /cleanup-worktree ai-resources
RUNS AS FINAL ITEM this session — after all preceding Plan 6 items dispatched.

### Item 10 — /improve-skill friday-act
SCHEDULE-DEDICATED [med]. /improve-skill runs its own internal /risk-check at structural-change gate. Auto-triage Step 3 + 3.5 disposition loops (HIGH=f, MED=f unless duplicate/low-value, LOW=d unless decision/chain-blocking, then f). Operator directive 2026-05-29 explicit ("triage the follows AUTOMATICALLY"). Dedicated session within 2 weeks.

### Closure note
Plan 6 dispatch: 2 APPLIED (items 2, 6), 1 PENDING (item 5), 1 SCHEDULED (item 7), 5 SCHEDULE-DEDICATED (items 1, 3, 4, 8, 10), 1 RUNS-LAST (item 9, this session).

---

## 2026-05-29 — Friday-act general item 9 (/cleanup-worktree) deferred to dedicated session

**Context.** Plan general item 9 specified running /cleanup-worktree against ai-resources after the other items landed. End-of-session reality: 12 commits shipped across 5 repos; concurrent session activity confirmed earlier (8 commits rebased over on interpersonal-communication during Plan 1 item 3); /cleanup-worktree itself is a substantial protocol (plan mode + 2 QC + triage + hard gates).

**Decision.** Defer to dedicated /cleanup-worktree session.

**Rationale.** (1) /cleanup-worktree is explicitly designed as its own focused session by the skill itself ("not a sidebar"); (2) running a heavy QC/triage protocol after a long mandate execution adds error risk; (3) the 6 currently-modified files in ai-resources are mostly hook-auto-mods (coaching-data, innovation-registry, session-notes-archive) plus the session's own session-notes/session-plan + a CLAUDE.md change that warrants investigation in fresh context — none are blocking.

**Trigger to revisit.** Operator invokes /cleanup-worktree directly when next sitting down to a maintenance window. Suggested ≤1 week so the dirty files don't accumulate.

**Item closure.** Friday-act plan general item 9 closed as DEFERRED-TO-DEDICATED-SESSION.

## 2026-05-29 — Provisioning fix-plans should name split-log.sh alongside check-archive.sh

**Context.** Fix-plan 2026-05-29-1108 items id-04 and id-07 specified copying `check-archive.sh` into nordic-pe-screening and ai-development-lab from canonical `ai-resources/logs/scripts/`. Spec acceptance: `CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh` exit 0. In practice the smoke-test failed in both projects with `split-log.sh: No such file or directory` (check-archive.sh sources split-log.sh internally). Provisioning split-log.sh too brought both projects to exit 0.

**Decision.** When provisioning `check-archive.sh` into a project's `logs/scripts/`, also provision `split-log.sh`. They are a paired dependency; the fix-plan template and the canonical `/wrap-session` Step 3 documentation should name both.

**Rationale.** (1) Spec acceptance ("exit 0") is unreachable with `check-archive.sh` alone; the dependency is real. (2) Both fix-plan items had the same omission, so it is not a one-off — the spec template needs the update. (3) Workspace convention (per nordic-pe-macro's `logs/scripts/` layout) already pairs both files; provisioning ops should mirror that convention.

**Alternatives considered.** Stop at the spec letter (provision only check-archive.sh and surface the failure to operator) — rejected as obstinate; the fix-plan's clear intent was "make `/wrap-session` Step 3 work in this project," and the dependency is structural.

**Item closure.** Fix-plan 2026-05-29-1108 items id-04 and id-07 closed APPLIED with the documented spec deviation; both projects now pass smoke-test.

## 2026-05-29 — id-08 contradiction inversion vs. fix-plan letter

**Context.** Fix-plan 2026-05-29-1108 item id-08 specified "append a `## Caveats` section" to `ai-resources/docs/permission-template.md`. On inspection, the existing `**Caveats:**` sub-block at line 346 (under `## PreToolUse[Edit] decision-block pattern`) contained a bullet at line 351 that **actively sanctioned** the exact `_decision_block_pattern_doc` JSON top-level key pattern that the FX-E2 incident proved is rejected schema-side at session load. Appending a new Caveats section while leaving line 351 intact would have left the contradiction in place — risk-checks would still find the sanctioning bullet first and continue citing it.

**Decision.** Inverted the existing bullet at line 351 in place (replacing the sanction with the corrected guidance per the proposal text from `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` line 205). Added the audit-discipline.md cross-link as the fix-plan also specified.

**Rationale.** (1) Workspace design principle "Conflicts must be surfaced, not silently resolved" — but the conflict here resolves cleanly (FX-E2 evidence wins over the original speculative sanction). (2) Leaving the sanction in place would have produced a self-contradicting document, defeating the fix-plan's intent. (3) `/qc-pass` reviewer GO-verdict explicitly cited the deviation as "a tactical improvement... substantively the corrected guidance lands."

**Alternatives considered.** (a) Append a `## Caveats` top-level section per the literal spec and leave line 351 intact — rejected (self-contradiction, defeats intent). (b) Delete line 351 and append the new Caveats section — rejected (line-351 location is the precise place a risk-check report would land when investigating PreToolUse[Edit] patterns; the contextual locality matters).

**Item closure.** Fix-plan 2026-05-29-1108 item id-08 closed APPLIED + VERIFIED with documented spec deviation; nordic-pe-macro improvement-log line 205 entry flipped to applied+verified.

## 2026-05-29 — Pipeline-review cycle-2 memo application strategy

**Context.** This session faced 4 cycle-2 pipeline-review memos containing ~40 findings total spanning Innovations / Leanness fixes / Brokenness / Cross-resource interactions / Recommended next-session items. The mandate ("apply findings... or surface with reasoned skip") could be interpreted as: (A) apply everything in scope including structural items with per-finding `/risk-check`, or (B) follow each memo's own "Recommended next session" curated subset and defer structural items to dedicated sessions.

**Decision.** Adopted Approach B — applied non-structural findings (frontmatter, cosmetic, in-place leanness, three small contract-check innovations) and deferred all 5 structural items (PR-3 post-memo /qc-pass gate; C-1 + C-2 consult/agent edits; FL-1 + FL-6 friction-log hook unification; CC-8 subagent-brief externalization) to dedicated sessions with their own plan-time `/risk-check`.

**Rationale.** (1) Each memo's auditor had already curated the "Recommended next session" line into a structural session focus — following that framing honors the auditor's own scoping judgment. (2) Bundling structural changes with cosmetic + leanness fixes compounds context contamination per `principles.md § AP-8` (System Owner's Q1 cited this). (3) The 5 structural items collectively touch hook edits, canonical-agent edits, and shared-state reordering — each requires its own `/risk-check` plan-time scope per `audit-discipline.md`; collapsing them would have produced 5 sequential risk-check gates in one session and exceeded reasonable context. (4) End-time `/risk-check` returned GO confirming Waves 1+2 stayed non-structural as planned. (5) System Owner advisory (Phase 6) confirmed the cut is right at the seam level; PR-2's Registry-contract collapse makes deferred PR-3 *easier* to land later, not harder.

**Alternatives considered.** (a) Approach A (apply everything including structural with per-finding /risk-check) — rejected on context-cost grounds and per the memos' own framing. (b) Apply only Wave 1 (frontmatter conformance) — rejected as too narrow given the operator's "cycle 2 batch" scope choice. (c) Apply everything except hook edits — rejected because the canonical-agent and shared-state reordering items also warrant dedicated sessions.

**Item closure.** Wave 1 commit `51b69dc`, Wave 2 commit `7ec05e6`, Wave 3 docs commit `4c4e980`. Each memo carries an `## Applied / Deferred — 2026-05-29 session` block naming the per-item disposition. Phase 5 risk-check GO; Phase 6 System Owner sanity-check confirmed.

## 2026-05-29 — Deferred-stack ordering: friction-log hook before consult/system-owner agent

**Context.** Five structural items now sit on the deferred-stack from this session. Two pairs cluster: (a) FL-1 + FL-6 (friction-log hook unification + docs convention), (b) C-1 + C-2 (consult return-size cap + project-local agent symlink fix). Question surfaced to System Owner: are these independent, or does one need to ship first?

**Decision.** Sequence FL-1 + FL-6 BEFORE C-1 + C-2 in the deferred stack.

**Rationale (per System Owner Phase 6 Q2).** Not independent. (1) FL-1 touches `friction-log-auto.sh` — a hook with three writers to a shared-state log file (`principles.md § DR-10` shared-state writer discipline applies; hook edits are `risk-topology.md § 3` plan+end-time gated). (2) The system-owner agent (C-1 + C-2) reads friction-log content into its Function-A/B briefs per `consult.md` Step 3 and the agent's Phase-1 references. (3) Landing C-1 + C-2 while the friction-log writer surface is also moving is the `principles.md § AP-6` failure pattern (audit-derived changes applied without impact analysis on what else is in flight). (4) Doing the hook work first means the consult-side session lands with a stable friction-log writer story and doesn't have to model two moving surfaces at once.

**Alternatives considered.** (a) Reverse order (C-1 + C-2 first) — rejected because the friction-log signal that motivated C-1 has been logged FROM the consult-leak observation; fixing the writer first stabilizes the input to the agent's read. (b) Bundle into a single session — rejected as it would re-create the context-contamination problem this session's apply/defer split was designed to avoid.

**Item closure.** Both pairs remain deferred. The next session that picks up either should pick FL-1 + FL-6 first. Recorded as Next Step #1 / #2 in today's session-notes entry.
