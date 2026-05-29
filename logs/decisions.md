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

## 2026-05-29 (S4) — Free-text-intent path skips formal /session-start + /session-plan when plan is chat-built

**Context.** Session S4 was built by deriving 4 items from inline /open-items + /resolve-repo-problem triage findings rather than picking from the /prime menu. The plan was iteratively shaped in chat and operator-approved with "go" before any disk-write. Running the formal planning chain (/session-start + /session-plan) on top of a paste-ready, operator-confirmed plan is overhead — Mandate Confirmation echo + class-confirmation + 3-option keep/overwrite/pass2 flow are all redundant when the plan is already agreed.

**Decision.** Skip formal /session-start + /session-plan when the plan was chat-built and operator-confirmed. Write the mandate block + marker-bearing header inline (matching /prime Step 8 contract exactly) and write a marker-scoped `session-plan-S{N}.md` file inline. Downstream readers (/drift-check, /contract-check, /wrap-session) see identical on-disk state.

**Rationale.** (1) Per 2026-05-29 usage-log telemetry observation: "Codify the 'skip planning-chain when input IS the plan' pattern (~3-5k tokens/session when applicable). This session demonstrated the saving; the pattern is currently undocumented." S4 is the second demonstration. (2) Inline writes follow the exact load-bearing format contracts (Mandate line shape, bullet labels, marker-bearing header) so /wrap-session 7a / /drift-check / /contract-check parse correctly. (3) Free-text-intent path was already supported by /prime Step 8b (no formal pause for "go"); this session generalises the same posture to operator-confirmed chat-built plans.

**Alternatives considered.** (a) Run /session-start + /session-plan formally — rejected; pure ceremony when plan is already operator-confirmed. (b) Skip the marker-bearing header entirely — rejected; downstream readers depend on it for marker-aware logic. (c) Use plan-mode — rejected; the operator explicitly said "go" indicating execution intent.

**Trigger to revisit.** If a paste-ready chat-built plan ever fails a downstream /drift-check or /contract-check parse, surface the format-drift root cause and re-evaluate whether inline mandate writes need codified format guardrails.

## 2026-05-29 (S4) — Bundle-and-pair commit strategy for accidentally-absorbed uncommitted state

**Context.** During Item 3 (improvement-log changes), `git add logs/improvement-log.md` absorbed 75 lines of pre-existing uncommitted deletions — entries that had been removed from improvement-log.md by a prior session's `/resolve-improvement-log` auto-archive sweep but never committed. The matching archive additions in improvement-log-archive.md were also unstaged. The Item 3 commit message described only the intended changes (~22 lines), not the bundled 75-line deletion.

**Decision.** Land Item 3's commit as-is (with bundled deletions) and immediately follow with a companion commit `97f4ddf` that lands the matching archive additions. Net result: the two commits together represent the canonical archived state, with no destructive `git reset --hard` needed.

**Rationale.** (1) Workspace destructive-ops rule: "Before running destructive operations (e.g., git reset --hard...), consider whether there is a safer alternative." (2) Splitting the commit retroactively would require either `git reset --hard` or interactive rebase — both destructive and high-risk for a session's worth of state. (3) The bundled deletions are semantically correct (those entries WERE archived by a legitimate `/resolve-improvement-log` sweep); the issue is only that the archive-side write never landed in a commit pair. (4) Companion commit `97f4ddf` explicitly notes "Pairs with 178ba3a to complete the auto-archive landing" in the commit message, so the history is self-documenting.

**Alternatives considered.** (a) Amend Item 3's commit — rejected per workspace rule "Always create NEW commits rather than amending." (b) `git reset --hard` to remove the bundled deletions, then re-stage the intended changes — rejected as destructive and high-risk. (c) Leave archive additions uncommitted — rejected; would leave the commit pair inconsistent indefinitely.

**Trigger to revisit.** Add a pre-commit-time check to /wrap-session (or commit-time guidance to commands that touch improvement-log.md) that detects uncommitted matched-pair state in improvement-log-archive.md before staging. Would have surfaced this for explicit operator decision rather than accidental bundling.

## 2026-05-29 (S4) — Short-circuit maintenance-observations → improvement-log triage gate for high-confidence SO observations

**Context.** Item 3 promoted the System Owner pre-spec grep-checklist observation from `logs/maintenance-observations.md` directly into `logs/improvement-log.md` as a `logged (pending)` entry. The conventional path is: SO observations land in maintenance-observations, get triaged at the next quarterly maintenance-observations sweep, and only then promoted to improvement-log for Friday cadence pickup. This session bypassed the quarterly triage gate.

**Decision.** Promote to improvement-log directly when the SO observation meets three criteria: (a) high-confidence diagnosis (this observation was made by the SO subagent with concrete evidence — two recursive PROCEED-WITH-CAUTION rounds), (b) clear proposal (a one-paragraph mechanical fix), and (c) recurrence-rate would justify Friday-cadence pickup rather than quarterly. Otherwise, keep on the maintenance-observations → quarterly → improvement-log default path.

**Rationale.** (1) The maintenance-observations.md file is designed for "logged here for next `/friday-checkup` cadence to triage into improvement-log if confirmed worthwhile" — promotion requires confidence. (2) Waiting for quarterly sweep when Friday could pick it up adds 2-12 weeks of latency to no end. (3) The triage gate is a quality filter, not a procedural barrier — when the entry already passes the filter at logging time, the gate is busy-work.

**Alternatives considered.** (a) Wait for quarterly sweep — rejected; high-confidence observation doesn't need re-triage. (b) Promote ALL maintenance-observations to improvement-log — rejected; the triage filter exists for a reason (low-confidence observations would clutter the Friday queue). (c) Add a per-entry confidence field to maintenance-observations — rejected as over-engineering for a small-volume log.

**Trigger to revisit.** If `/friday-checkup` ever surfaces a low-quality entry from a short-circuited promotion, tighten the three-criteria filter. The risk is minor — improvement-log entries can be re-classified at any cadence.

---

### 2026-05-29 — Treat prior system-owner "do-not-build" memo as superseded by explicit operator briefs

**Context.** A 2026-05-29 system-owner memo (`projects/ai-development-lab/output/memos/2026-05-29-context-engine/memo.md`) recommended NOT building a context engine as a standalone subsystem, arguing the defensible Axcíon version was a smaller "command + sub-agent doing agentic retrieval" and that at single-operator / 7-project scale, better-curated static context packs may be the correct stopping point. Memo also recommended an eval-first approach before any build.

**Decision.** Operator chose to build the Context Engine MVP per two new explicit briefs (`context-engine-brief.md` + `context-engine-session-pairing.md`), treating the prior memo's "may not be worth building" caution as outdated context.

**Rationale.** (1) The new briefs are sharper than the original transcript the memo was based on — they specify the use case (pre-change context packs for repo modifications) and the architecture posture (command-first, read-only, narrow before broad, evidence-led routing). (2) The memo's scale concern is real but the operator's explicit choice signals they value the design surface for future Phase 2 work even if Phase 1 evaluation is inconclusive. (3) The memo's design hook (`consumer:` frontmatter field + stable convention path) was preserved; the scale marker (4-of-5 unused → reassess) was preserved as an in-build checkpoint.

**Alternatives considered.** (a) Honor the memo and build only a smaller subset — rejected; operator explicitly chose the briefs as written. (b) Run an eval against static-pack baseline first — rejected; operator deferred Phase 1 evaluation entirely with "proceed". (c) Stop and reconsider — rejected; operator override is decisive.

**Trigger to revisit.** If Phase 1 evaluation (when operator runs it) shows the engine produces packs the consuming agent doesn't use ≥4-of-5 times, the memo's scale concern materializes and the engine should be wound back to a static-pack-only baseline.

---

### 2026-05-29 — Drop SessionStart hook from Context Engine MVP scope

**Context.** Scope v3.1 (operator-approved post-/clarify) included a SessionStart hook in `ai-resources/.claude/settings.json` to auto-fire the context engine at every session open. Plan QC + drift-check verified that Claude Code SessionStart hooks emit `systemMessage` JSON only — they cannot invoke slash commands. The hook would degrade to "emit reminder to run `/prime`," not actually fire the engine.

**Decision.** Drop the SessionStart hook deliverable. Engine still auto-fires inside `/session-start` Step 2.4 and `/prime` Step 8c.4.5 — those are the load-bearing entry points. The hook would only nudge the operator to run a command they already run by convention.

**Rationale.** (1) Mechanism mismatch: hooks can't execute commands; the "automatic" framing operator selected in /clarify was unimplementable as designed. (2) Per `feedback_minimal_infra_subset.md` memory rule, the lower-risk subset should be offered proactively when value is marginal. (3) Hook drop avoids: settings.json edit, new bash script, an additional `/risk-check` change class. (4) System-owner second opinion on the related risk-check concurred PROCEED-WITH-CAUTION, not RECONSIDER — accepting the hook drop did not weaken the architecture.

**Alternatives considered.** (a) Keep hook as `systemMessage` reminder — rejected; marginal benefit (operator already runs `/prime` by convention); /risk-check trigger cost; second SessionStart hook stacking alongside `friday-checkup-reminder.sh`. (b) Restructure hook to write a marker that `/prime` checks — rejected as over-engineering for a nudge.

**Trigger to revisit.** Only if operator workflow proves to skip `/prime` in cases where the engine would have helped — surface in `/friday-checkup` improvement-log.

---

### 2026-05-29 — Markdown summary parse contract for `context-discovery` agent (not JSON)

**Context.** Phase 2 commands (`/session-start` Step 2.4, `/prime` Step 8c.4.5) need to extract structured fields (`pack_path`, `files_in_scope`, `allowed_inputs`, `required_outputs`, `sufficient_to_plan`, `sufficient_to_implement`) from the `context-discovery` agent's return. Risk-check verdict surfaced ambiguity about whether the agent should return JSON or markdown.

**Decision.** Markdown summary, fixed template per schema §5b. Callers extract `pack_path` from summary line 1, then Read the pack file's YAML frontmatter for structured fields.

**Rationale.** Per system-owner second opinion: (1) DR-7 — second-consumer rule: no current second consumer requires JSON; switching pre-emptively is speculative abstraction. (2) AP-7 — the agent already returns a parseable fixed-template markdown summary; the ambiguity was a documentation defect, not a shape problem. (3) YAML frontmatter is the structured contract for downstream consumers; markdown summary is just for chat display. (4) Parse contract is concrete (YAML schema) rather than fuzzy (markdown extraction).

**Alternatives considered.** (a) Return JSON — rejected per DR-7 / AP-7. (b) Markdown summary AS the structured contract — rejected; markdown extraction is fragile; YAML frontmatter is the right home.

**Trigger to revisit.** If a Phase 2 consumer beyond the two named callers needs the structured fields without reading the pack file, evaluate JSON return then.

---

### 2026-05-29 — Engine outcome distinction: 4 classes surface to operator, no silent absorption

**Context.** Risk-check + system-owner second opinion flagged that an engine returning `sufficient_to_plan: false` could be silently absorbed into the Step 2 confirmation block — operator would confirm an enriched mandate without seeing the engine's readiness gaps.

**Decision.** `context-discovery` agent returns one of 4 outcome classes (`success-enriched` / `success-insufficient` / `engine-skipped` / `engine-error`). Both `/session-start` Step 2.4 and `/prime` Step 8c.4.5 / 8c.6 surface the outcome class explicitly in the operator-facing re-emit or approval gate.

**Rationale.** Per OP-3 (Conflicts must be surfaced) and OP-5 (advisory MVPs should fail loud, not silent). Silent absorption of an insufficient pack defeats the engine's purpose — the readiness booleans exist precisely to flag incomplete coverage to the next stage.

**Alternatives considered.** (a) Trust the readiness booleans implicitly without surfacing — rejected per OP-3. (b) Block on `sufficient_to_implement: false` — rejected; MVP enforcement is Phase 2-deferred (schema-field-only carriage).

**Trigger to revisit.** Phase 2 consumer behaviors (pre-edit check enforcement) will repurpose the outcome class. If those land, the surface-only posture upgrades to surface + enforce.


## 2026-05-29 — S5: Drop conditional-write threshold in C-1 (/consult Function A/B output contract)

**Context.** The source memo (`audits/pipeline-reviews/consult-2026-05-29.md`) proposed extending /consult Functions A and B to write the full advisory to disk and return a ≤30-line summary, with a conditional carve-out: if the advisory naturally converges below the 30-line cap, skip the disk write. Plan-time /risk-check returned PROCEED-WITH-CAUTION but did not flag the conditional. System Owner second opinion (Function B advisory) caught the principle conflict.

**Decision.** Drop the conditional-write threshold. All Function A and Function B outputs write to disk unconditionally — same shape across all output sizes.

**Rationale.** Three vault principles converge on always-write: (1) OP-3 (loud failure over silent continuation) — conditional writes create operator-perception ambiguity over whether a given consult is archived; (2) DR-6 (outputs go to `output/{project}/`) — unconditional rule, no carve-out for small outputs; (3) AP-7 (speculative abstraction) — the token-saving benefit of skipping short writes is hypothetical and marginal. The on-disk archive also keeps a future Function F/G consumption path open without partial-archive degradation.

**Alternatives considered.** (a) Keep the conditional per the source memo — rejected on principle conflict. (b) Add a tag in the returned summary indicating "no disk write this time" — rejected as solving the perception ambiguity by adding ceremony where unconditional is simpler.

## 2026-05-29 — S5: Path-back line as a leading line in the agent's returned summary, not a /consult Step 5 transformation

**Context.** C-1 needs to make the on-disk advisory discoverable to the operator (without it, the file is silently hidden because /consult Step 5 returns the agent's response unmodified). Two shapes were considered: (a) the agent emits a `**Full advisory on disk:** {path}` line at the top of the returned summary; (b) /consult Step 5 detects the on-disk write and displays the path.

**Decision.** Shape (a) — leading line in the agent's returned summary. /consult Step 5's "return unmodified" pass-through stays unchanged.

**Rationale.** Five sibling consumer commands (`/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`) use the same identical pass-through posture. Introducing a detect-and-display special-case in /consult only would create sibling inconsistency — exactly the silent special-casing AP-1 (silent conflict resolution) prohibits. The agent owns the format; the command stays a thin wrapper. Leading position beats trailing because the operator scans top-down — a path-back line buried at the bottom of a 30-line block is easy to miss.

**Alternatives considered.** (a) Trailing line — rejected on scanability. (b) /consult Step 5 transformation — rejected on sibling consistency.

## 2026-05-29 — S5: Split C-1 and C-2 into two commits with C-1 first

**Context.** C-1 (canonical agent edit + /consult brief) and C-2 (project-local agent symlink swap) were originally planned as one combined Item 3 commit. System Owner advisory flagged that they are distinct change classes with different reversibility profiles.

**Decision.** Two commits, C-1 first. C-2 follows after C-1 verification.

**Rationale.** C-1 is a canonical-agent edit (six-consumer shared agent per `risk-topology.md § 3`); C-2 is a new symlink (distinct class). Different change classes mean different reversibility profiles — one-commit coupling sacrifices independent rollback. Order matters: C-1 first ensures the canonical content is post-edit before the symlink points at it; if C-2 ships first, there is a brief window where the project session would load the pre-edit canonical via the new symlink. (C-2 ended up invisible to git per the project-local gitignore — verified via swap + diff + grep, no commit was needed.)

**Alternatives considered.** (a) Combined commit — rejected on reversibility separation. (b) C-2 first — rejected on transient pre-edit-canonical exposure.

## 2026-05-29 — S5: Item 5 (context-engine MVP intake) deferred per Context constraint deferral

**Context.** Item 5 was the fourth picked item in the /prime auto-mode multi-item gate. By the time it was reached, the session had spent 6 subagents (2 risk-check-reviewer + 2 qc-reviewer + 2 system-owner advisory) / >20 turns / 8 artifacts — past the [COST] threshold. Brief 1 (MVP) describes a substantial discovery engine; Brief 2 explicitly says "do not build until MVP is proven."

**Decision.** Defer Item 5 to a dedicated session. Brief 2 stays in inbox per its own phase-2 instructions. Brief 1 (MVP) requires a fresh-context session.

**Rationale.** Workspace `Context constraint deferral` rule: when context is clearly constrained, defer remaining work, flag the deferral, log it — do not push to close the task or rush a plan. Brief 1 is non-trivial enough that running `/create-skill` end-to-end in a context-constrained session would compete with wrap quality and degrade the design. The briefs stay in `inbox/` — not perishable.

**Alternatives considered.** (a) Run /create-skill end-to-end on Brief 1 — rejected on rush risk. (b) Defer both briefs to a follow-up Friday-act item — rejected on lower visibility than leaving in inbox.

**Subsequent observation.** Moot — a concurrent S6 session in another terminal built both phases of the context-engine MVP independently and wrapped first (commits `7dc5e6e`, `e774eb5`, `7daac4e`). Decision still stands as the correct discipline call for the S5 session at the time it was made.

## 2026-05-29 — S6: Schedule dedicated session for /wrap-session leaner refactor + permission-sweep-auditor follow-ups (Friday-checkup general #7)

**Context.** Both items have been deferred twice in prior Friday-act waves. The plan classified another defer as "operator-driven silent drift" — a third pass without commitment would normalize the deferral. The /wrap-session command body has grown organically (Step 3.5 marker-aware counter + Step 7a coaching-data classification + multiple guards), and the permission-sweep-auditor accumulated follow-ups during the 2026-05-22 + 2026-05-29 cycles without being addressed.

**Decision.** Block out one dedicated session within the next two weekly cadences (target: 2026-06-05 or 2026-06-12 /friday-act wave, or a Monday session if /monday-prep surfaces capacity). Session shape: open with /prime, pick both items as the multi-item auto bundle, /risk-check both at plan time, single mandate, single wrap. Estimated duration: 2–3 turns of design + edit + commit per item.

**Rationale.** Both items are structurally similar (existing-resource refactor, no new path creation, /risk-check NO per plan classifications) — bundling them in one session amortizes the /prime → /session-plan setup cost. Their blast radii are bounded (one command + one agent), so a combined session does not compound risk. Splitting them across two sessions doubles setup cost for no risk reduction. Alternatives: bundle into next /friday-act wave indirectly (rejected — Friday-act sessions are already crowded with that week's findings); add to /improve-skill / /create-skill backlog (rejected — these are refactors of existing resources, not new builds).

**Trigger to revisit.** If neither 2026-06-05 nor 2026-06-12 /friday-act surfaces capacity, escalate to a dedicated weekday session (treat as do-now). A third defer past 2026-06-12 will be logged as silent drift and re-triaged via /improve-skill against /wrap-session itself.

## 2026-05-29 — S6: /pm sub-subagent dispatch — investigation only (pending)

**Context.** Friday-checkup general plan item #5 surfaced the `/pm` Phase 4 escalation limitation: Claude Code does not grant the Task tool to subagents at runtime, so the project-manager → system-owner dispatch fails deterministically and the DISPATCH FAILED redirect fires. Plan classification: investigation only, marked pending in decisions.md (not applied).

**Decision.** Investigation completed; notes file at `audits/working/2026-05-29-pm-sub-subagent-investigation.md`. Four workaround candidates documented (A: move dispatch to /pm command; B: pre-fetch SO read every invocation; C: drop the escalation; D: wait for SDK update). Status: **pending** — operator decides between defer (recommended default) and approve Option A in a dedicated session.

**Rationale.** Current degraded mode is bounded: hybrid-question frequency is low (~1-2×/month per usage-log telemetry); operator-facing experience is clear (redirect to /consult); no fabrication risk. Implementing Option A is a real improvement but is a cross-resource refactor (3 files, plan-time /risk-check required) — better as a dedicated session than absorbed into Friday-cadence. Surfaces the investigation now, defers the build to operator decision.

**Alternatives considered.** (a) Build Option A inline in S6 — rejected on session budget (would compete with Wave 2-4 leverage). (b) Open a /create-skill / /improve-skill loop now — rejected as premature without operator approval of the refactor.

**Trigger to revisit.** If hybrid-question frequency rises above ~1×/week, fast-track Option A. Otherwise, re-surface at next monthly /friday-checkup tier.

## 2026-05-29 — S7: Friday-checkup S6-plan Wave 1+2 closure (engine-reframed mandate)

**Context.** S7 picked the open Friday-checkup items from `logs/session-plan-S6.md` (Wave 1 + Wave 2). At /session-start, the context-discovery engine surfaced that **5 of the 10 picked items were already done or blocked**: Wave 1 #1 already shipped (both target improvement-log files exist with canonical headers); Wave 1 #3 + #4 already recorded in `projects/repo-documentation/logs/decisions.md` D-51 + D-52 (S6 Wave 1.3 + 1.4); Wave 1 #5 + #6 already recorded above in this file (S6 closures); Wave 2 #7–#9 returned **RECONSIDER** at `audits/risk-checks/2026-05-29-wave-2-settings-json-cluster-friday-checkup-permissions.md` because all three planned edits are NO-OPS against current file state.

**Decision.** **Reframe mandate.** Only Wave 1 #2 (paste 7 net-new vault entries) and Wave 1 #1 verify-close are net-new S7 work; the rest are either pre-closed by S6 or blocked by the existing RECONSIDER verdict.

**S7 actually shipped:**
- **Wave 1 #1 — verify-and-close.** Both `projects/obsidian-pe-kb/logs/improvement-log.md` (line 20: `(no entries yet — log seeded 2026-05-29 by Friday-act general plan item 6)`) and `projects/project-planning/logs/improvement-log.md` (15 historical entries from 2026-05-26 onward) verified present with canonical headers. Closed.
- **Wave 1 #2 — paste 6 entries across 2 vault components.** Pasted 4 missing canonical agents (`context-discovery`, `fix-repo-issues-scanner`, `log-sweep-auditor`, `project-manager`) into `vault/components/agents.md` in alphabetical order; pasted 2 missing projects (`ai-development-lab`, `axcion-brand-book`) into `vault/components/projects.md` at the end (insertion-order convention). Closed. **Audit-vs-disk drift noted:** the source plan said "7 entries (1 command + 4 agents + 2 projects)"; current vault state shows `pipeline-review` already present in `commands.md` (likely pasted between audit generation and S7) — so 6 entries pasted in S7, not 7. The 1-command line was already done.

**S7 already-done (no S7 write needed — referenced for audit trail):**
- Wave 1 #3 — `projects/repo-documentation/logs/decisions.md` D-51 (S6 Wave 1.3: selective paste-now; 212-entry bulk deferred to dedicated session).
- Wave 1 #4 — D-52 (S6 Wave 1.4: Status field + prose body for deprecation; no §4.1 schema change).
- Wave 1 #5 — "S6: Schedule dedicated session for /wrap-session leaner refactor + permission-sweep-auditor follow-ups" entry above in this file.
- Wave 1 #6 — "S6: /pm sub-subagent dispatch — investigation only (pending)" entry above; investigation notes at `audits/working/2026-05-29-pm-sub-subagent-investigation.md`.

**S7 dropped (Wave 2 #7–#9 — audit-stale, RECONSIDER verdict honored):**
- **#7 nordic-pe `Bash(rm *)` add — DROP.** Current file state already contains `"Bash(rm *)"` at line 6 of `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` per risk-check § Dimension 2. Planned edit is a no-op.
- **#8 interpersonal-communication stale `danielniklander` path remove — DROP.** Current file state shows no `danielniklander` entry in `additionalDirectories` per risk-check § Dimension 2. Planned edit is a no-op.
- **#9 user-level `"model": "sonnet"` remove — DROP.** Current `~/.claude/settings.json` contains no `"model"` field per risk-check § Dimension 2. Planned edit is a no-op.

Per `docs/audit-discipline.md` line 43: "RECONSIDER — redesign before proceeding. Do NOT downgrade the verdict to push the change through." Plan-time gate already satisfied; end-time gate moot (no edits to gate). The risk-check report at `audits/risk-checks/2026-05-29-wave-2-settings-json-cluster-friday-checkup-permissions.md` stays on disk as the audit trail.

**S7 surfaced to operator (Wave 2 #10):**
- **#10 user-level uniform git guards (MEDIUM M1).** The audit at `audits/permission-sweep-2026-05-29.md` § M1 lines 42–43 explicitly forbids mechanical execution: "Operator review. Layer A is intentionally more permissive (personal machine); divergence is by design. No mechanical fix unless operator wants uniform git guards at user level." Surfaced as yes/no at S7 wrap. Operator decision will be recorded in a follow-up entry.

**Rationale for the reframe.** Two governing principles: (1) workspace `Design Judgment Principles` — "Conflicts must be surfaced, not silently resolved" — the engine flagged 3 source-plan-vs-disk conflicts and 1 unknown-scope; ignoring would have produced no-op edits + an audit-discipline violation (downgrading RECONSIDER); (2) workspace `Decision-Point Posture` — "pick the recommended option and proceed" — the recommended option was the engine-derived reframe. Operator confirmed reframe at /session-start Step 2.4 with `y`.

**Maintenance observation (candidate for improvement-log):** Stale-audit-to-plan coupling. Friday-checkup audit ran ~07:00; S6 plan was generated ~midday based on audit; by the time S7 picked items up in evening, 5 of 10 items had already shipped via other sessions or were no-ops against current file state. The plan did not auto-refresh against current state — every consumer would have to do their own pre-flight check. Pattern: when a wave plan ages past one same-day session boundary, recommend re-running the source audit OR add a "stale check" pre-step to plan-execution commands. Dimension 5 of the wave-2 risk-check report makes the same observation.

**Alternatives considered.** (a) Execute the original 10-item plan literally (would produce 3 no-op settings.json edits + a stack of "already-done" duplicate decisions.md entries; violates `audit-discipline.md` line 43) — rejected. (b) Defer the entire S7 mandate to a fresh-context session after re-running the source audit — rejected, the engine had already done the equivalent of a re-audit; deferring would be ceremony.

**Trigger to revisit.** Next /friday-act tier — apply the stale-audit observation as a structural improvement (either re-audit pre-step or session-plan TTL).
