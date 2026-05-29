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

---

## 2026-05-29 — TOCTOU Phase 2+3: Option A (atomic) over Phase-2-only-with-symlink

**Context.** Plan-time Round 1 risk-check on Phase 2-only spec returned PROCEED-WITH-CAUTION (Hidden Coupling: High — symlink-as-bridge between Phase 2 writers and unreached Phase 3 readers; cross-session last-writer-wins on `logs/session-plan.md` is a NEW form of the race the spec claimed to eliminate). System-owner Function-B advisory recommended Option A (atomic Phase 2+3 in one commit, no symlink) as the cleaner design. Operator chose Option A.

**Decision.** Atomic single-commit landing — both writers (prime, session-start, session-plan) AND readers (contract-check, drift-check, open-items, fix-repo-issues-scanner, decide) become marker-aware in the SAME commit. No symlink, no legacy fallback paths, no Phase 4 deferred cleanup.

**Rationale.** (1) Eliminates the symlink-relocation TOCTOU race at its root rather than time-bounding it. (2) Drops Hidden Coupling from High → Low in dimension scoring. (3) Removes the asymmetric phase-coupling material miss the SO advisory flagged (Phase 2 ships infrastructure that REQUIRES Phase 3 to be safe). (4) Per `principles.md § OP-3` loud-failure-over-silent-continuation: hard-failing writers on absent marker is correct; silently bridging via symlink is not. (5) Total work is unchanged vs original chained-Wave-1+Wave-2 plan — only the commit boundary moves (chained → atomic).

**Alternatives considered.** (a) Phase 2-only with all 6 Round-1 mitigations applied — rejected as architecturally inferior to Option A. (b) Option B (Phase 3 readers first, then Phase 2 writers) — rejected as it pushes the actual TOCTOU mitigation further into the future. (c) Option C (skip symlink + loud-fail readers during the rollout window) — rejected because Option A is cleaner still.

**Trigger to revisit.** Next session's `/prime` is the first real test of marker-scoped end-to-end flow. If marker resolution misfires anywhere, fall back to git revert + reseed (recipe in commit `9f91b2f` message).

---

## 2026-05-29 — TOCTOU Phase 2+3: extend commit to 16 files (Round 2 mitigation)

**Context.** Plan-time Round 2 risk-check on atomic spec returned PROCEED-WITH-CAUTION (Blast Radius: High — 4 orphan consumers missed in spec inventory + 2 narrative-drift items found by SO follow-up grep). System-owner Function-B advisory concurred with verdict AND recommended extend-to-16, not revert-to-Phase-2-only.

**Decision.** Extend the atomic commit to all 16 consumers (originally 10) — covers prime auto-mode chat strings (185/187/223), new-project.md scaffolding (548), repo-architecture.md canonical table (220-221), compaction-protocol.md operator-facing note (21), backup-session-plan.sh comments (4 + 13-15), heavy-read-discipline.md narrative (45), weekly-cadence.md Phase D narrative (78). Plus broaden backup-session-plan.sh regex from `(-[a-zA-Z0-9]+)?` to `(-[a-zA-Z0-9]+){0,2}` (QC fix — closes BREAK risk where `session-plan-S1-pass2.md` would be silently un-backed-up).

**Rationale (per SO Function-B Round 2 advisory).** Two PROCEED-WITH-CAUTIONs in a row are NOT the same signal: Round 1 was structural (symlink coupling), Round 2 is execution-completeness (orphan-consumer inventory miss). Different risk classes. Treating them as "stop sign" would conflate two distinct findings and re-open Round 1's structural flaw. "Do less per commit" (revert) trades known-mitigable Blast Radius High for known-unmitigable Hidden Coupling High — fails `OP-3` (silent symlink coupling) and `AP-10` (the symlink-coupling-by-design failure mode).

**Alternatives considered.** (a) Extend to 14 files only (skip SO's 2 narrative-drift items) — rejected as defer-the-cleanup-debt anti-pattern; 2-line touches with clean-tree benefit. (b) Revert to Phase 2-only with all Round 1 mitigations — rejected per SO analysis. (c) Pause and revise spec independently — rejected; risk-checks did their job, fixes are concrete and apply inline.

**Trigger to revisit.** No follow-up expected. The recursive-PROCEED-WITH-CAUTION pattern itself logged as process observation to `logs/maintenance-observations.md` for Friday cadence: pre-spec grep checklist for renamed/removed paths would have closed both Round-N inventory gaps before reaching /risk-check.

---

## 2026-05-29 — TOCTOU Phase 2+3: asymmetric writer/reader marker-handling discipline

**Context.** Marker-aware consumers fall into two roles with structurally different correctness requirements: writers PRODUCE session state, readers CONSUME it. Treating them uniformly would either over-constrain readers (post-session use is legitimate and should not hard-fail) or under-constrain writers (silently writing to an ambiguous location on marker-absent is the silent-degradation pattern OP-3 prohibits).

**Decision.** Asymmetric discipline codified in `docs/session-marker.md` § Two-end contract registry:
- **Writers** (prime, session-start, session-plan): HARD-FAIL loud on marker absent/stale per `principles.md § OP-3` with the standard message `[/{command} Step {N}] HARD-FAIL: logs/.session-marker absent or stale. Run /prime to populate the marker for this session, then retry.`
- **Read-only auxiliary consumers** (contract-check, drift-check, open-items, fix-repo-issues-scanner, decide): TOLERATE marker absence by falling through to alternate sources (mandate line, `$ARGUMENTS`, glob scan).

**Rationale.** (1) Writers produce session-identity-scoped state; operating without identity = ambiguous corruption. (2) Read-only auxiliary consumers may be invoked post-session (no active marker) — hard-fail there would break legitimate workflows like post-session contract-check. (3) The asymmetry is documented in the canonical contract doc (`docs/session-marker.md`) so future writers and readers know their assigned discipline.

**Alternatives considered.** (a) Uniform hard-fail across all consumers — rejected; breaks post-session workflows. (b) Uniform tolerate across all consumers — rejected; writers operating without marker is silent corruption. (c) Per-consumer judgment call without canonical docs — rejected; introduces drift surface.

**Trigger to revisit.** If a new consumer is added that doesn't cleanly fit either role, update `docs/session-marker.md` Two-end contract registry to classify it explicitly.
