# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-27 — Build `/contract-check` to close the post-iteration contract-drift gap

**Context.** During long, complex sessions with multiple rounds of `/qc-pass` → `/resolve` → re-QC, cumulative local fixes can pull an artifact away from the original mandate. Each individual QC pass judges against the passed scope (often updated between passes) so the drift is invisible per-pass by design. Existing commands cover related shapes: `/drift-check` watches session trajectory (commits vs mandate, not artifact-content), `/qc-pass` is scope-bounded by design (QS-1 context isolation), `/risk-check` is the structural-change gate, `/scope` locks deliverables pre-execution but does not re-verify mid-execution. None of them anchors on the original contract and compares the current artifact text against it.

**Decision.** Build `/contract-check` as a slash command + fresh-context general-purpose subagent, following the canonical `/drift-check` pattern. The subagent receives only the frozen contract and the current artifact text — no QC history, no session conversation, no creation context (QS-1 preserved). Verdict shape mirrors `/drift-check`: CONTRACT-ALIGNED / MINOR-DRIFT / MAJOR-DRIFT with enumerated divergences. Hard-vs-soft contract calibration: literal-match for hard contracts (settings.json edits, hook scripts, structural-change mitigations); intent-match for soft contracts (research briefs, advisory questions, exploratory specs). Live at `ai-resources/.claude/commands/contract-check.md`. Reminder section added to workspace `CLAUDE.md` so it loads across every project.

**Rationale.** System Owner Function A consult confirmed the failure mode is architectural, not a discipline problem. QS-1's context-isolation rule is correct — QC subagents must not see the creation conversation — but context-isolation also means the QC subagent has no memory of what the original contract said two passes ago. Each pass is locally correct; cumulative drift is invisible to any individual pass. AP-11 names a related anti-pattern (repeated same-direction feedback) but catches the wrong shape — contract drift produces different local feedback that is each reasonable in isolation, with cumulative effect diverging. The two-pass cap (QS-2 in `docs/qc-independence.md`) stops runaway iteration but resets each pass — it does not surface what structurally drifted across the loop. `/contract-check` is the instrument the cap implies but never had. Path follows DR-2 (canonical pipelines), DR-3 (cross-project resources in `ai-resources/.claude/commands/`), DR-6 (frozen contract joins the read-only-references class), and DR-7 (no speculative new commands — built only after operator named the failure mode and SO confirmed).

**Alternatives considered.**
1. **Extend `/qc-pass`** to also check against original contract on the Nth pass — Rejected: violates QS-1 (would require passing creation context into the QC subagent) and conflates two distinct concerns (per-pass scope-bounded QC vs cumulative contract conformance).
2. **Extend `/drift-check`** to also check artifact content — Rejected: changes a load-bearing command's contract; trajectory-vs-artifact are distinct dimensions that deserve distinct verdicts.
3. **Build `/scope` freeze-baseline first, defer `/contract-check`** — Rejected: the freeze-baseline is a nice-to-have; the command works without it via fall-through to session-plan / mandate-block / project briefs. Building the command first lets the operator use it immediately; freeze-baseline can land later as an auto-detect quality improvement.
4. **Wait for `/implementation-triage`** — Rejected: operator explicitly skipped triage and said "start the build" after the SO consult. SO already supplied the architectural ROI judgment.

**Scope deferrals (logged for future sessions).**
- `/scope` freeze-baseline extension (writes contract to `logs/contracts/{date}-{slug}.md` at scope-lock time).
- Auto-invocation of `/contract-check` at the QS-2 two-pass cap.
- `system-doc.md § 4.5` entry naming "Original contract → post-iteration artifact conformance" as a previously-undocumented open feedback loop now closed by this command.

## 2026-05-27 — `/decide` slash command: shape and design decisions

**Context.** Built the `/decide` command via the `/create-skill` pipeline. The inbox brief (`decision-resolver`, operator-renamed to `decide`) described an operator-invoked tool to pre-research mixed-shape decision lists Claude surfaces mid-session. Several material design decisions surfaced during Step 1, plan-time `/risk-check`, and system-owner second opinion.

**Decision 1: Output target = slash command at `.claude/commands/decide.md`, NOT SKILL.md at `skills/decide/SKILL.md`.**

**Rationale.** The session plan's first cut targeted `skills/decide/SKILL.md` because `/create-skill` Step 2 literally says "Create the skill directory at `skills/{skill-name}/`." Plan-time `/risk-check` flagged this as a direct contradiction against the proposed CHANGE_DESCRIPTION (which targeted slash command). System-owner second opinion firmly endorsed the slash-command shape on architectural grounds: (a) the brief's behavior — operator-invoked, on-demand, producing specific output — maps to slash command per `repo-architecture.md` § Q2; (b) all named composition partners (`/resolve`, `/scope`, `/clarify`, `/recommend`) are slash commands at `.claude/commands/`, not SKILL.md skills — putting `/decide` in `skills/` would create asymmetry in a tightly coupled set; (c) `/contract-check` shipped same day as a slash command for behavior of comparable complexity (precedent). The plan's rationale conflated "which pipeline created the artifact" with "which canonical home it belongs in" — `/create-skill` is the right pipeline but its Step 2 output target does not apply when the artifact's correct canonical home is `.claude/commands/`. Recorded in `logs/session-plan-pass2.md` § Output artifact decision.

**Decision 2: Auto-detect upstream decision lists, with hard ambiguity-guard.**

**Rationale.** The brief described auto-detection from common upstream sources (`/qc-pass` REVISE, `/scope` §5, `/clarify` clarifying-questions, mid-stream numbered lists). Operator confirmed Q2=auto-detect. The risk: misfire when multiple candidate lists are in context. Mitigation: STOP and ask the operator which list to pick — never silently default to most-recent. Anti-narrowing principle applied at the entry point.

**Decision 3: Soft per-question evidence-gathering guidance, not hard cap.**

**Rationale.** The brief suggested a hard cap (e.g., "max 3 files, max 200 lines"). Operator chose soft guidance (Q3). Reasoning: hard caps are brittle (the right budget depends on the question), but the escalation contract is firm — when a question would need many reads or whole-file scans, the item moves to the `Operator-only` bucket with a note on what couldn't be confirmed within sensible budget. Critical anti-pattern excluded: the command does NOT recurse into broader searches.

**Decision 4: End-time `/risk-check` skipped.**

**Rationale.** Per `feedback_end_time_risk_check_skip` memory: skip when plan-time gate covered with mitigations applied AND drift bounded AND QC clean. All three held. Plan-time `/risk-check` returned PROCEED-WITH-CAUTION with 5 mitigations applied (4 reviewer-named + 1 system-owner gating); drift between plan-time CHANGE_DESCRIPTION and final shipped batch was bounded to the planned scope (the 4 cross-reference edits in upstream commands were explicitly named in Mitigation 4); post-edit `/qc-pass` returned GO. End-time gate would have been confirmatory only. System-owner's advisory had recommended end-time on the batch, but on review the skip-criteria cleanly applied. Documented in commit message.

**Decision 5: Skipped QC Finding 4 caveat** (low-severity `/clarify` output-shape note).

**Rationale.** Per `feedback_minimal_infra_subset`: skip QC-clean components of low marginal value. QC verdict was GO; Finding 4 was advisory ("`/clarify` emits prose, not block delimiter — caveat the numbered-list assumption"). The matched bold-string marker (`**Clarifying questions**`) is correct; items after may be bullets or paragraphs but the heading-based detection holds regardless. Adding the caveat would tighten prose without changing behavior.

**Alternatives considered for Decision 1.** Three were on the table:
- (a) SKILL.md at `skills/decide/SKILL.md` — follows pipeline literally but creates structural asymmetry with composition partners. Rejected by system-owner architectural commentary.
- (b) Slash command at `.claude/commands/decide.md` — chosen.
- (c) Both — over-engineering. Rejected immediately.

---

## 2026-05-28 — Project Manager agent + /pm command — three load-bearing scoping decisions

**Context.** Designed and shipped the project-manager agent + `/pm` slash command in `ai-resources/.claude/`. PM is a project-scoped advisor that grounds rulings in the active project's constitution docs (CLAUDE.md, plan, decisions, context-pack, architecture) and produces a 3-part ruling (Verdict + citation-grounded Reasoning + Recommended action). First deployment target: `nordic-pe-screening-project`. Commit `587558f`. Three decisions emerged during the build that warrant the decision journal — distinct from routine plan-execution choices.

**Decisions.**

1. **Internal QC step added to /pm (divergence from approved plan).** The approved plan said NO internal QC pass, mirroring `/consult`'s chat-only-return precedent. The operator added the QC step mid-implementation because PM "will be solving quite important issues" — PM rulings will be cited as load-bearing project-content decisions AND will feed forward-looking artifacts (mandate text, session-plan outlines) into `/session-start` / `/session-plan`. The QC step uses `qc-reviewer` with pass cap of 2.

2. **Function-A-only escalation from PM to system-owner.** PM escalates only general-structure questions (Function A) to `system-owner` via the `Task` tool. Change-shaped structure questions (operator proposes a specific repo modification) emit Fallback 5d (REDIRECT TO `/consult`) instead of forwarding through PM. PM does NOT plumb `ROUTING_CONTEXT` from `repo-architecture.md`.

3. **Ship in degraded mode for structure escalation (Option 1).** BLOCKING gate trace test confirmed Claude Code does not grant the `Task` tool to subagents at runtime, despite frontmatter declaration. PM is the first agent in the repo to actively use Task to spawn another named agent. Phase 4 fallback fires loudly (DISPATCH FAILED — operator runs `/consult` directly) per `principles.md § OP-3`. Operator chose ship-in-degraded-mode + v1.1 investigation entry over (b) hold the commit until investigation completes, or (c) rip out Phase 4 entirely (always emit "/consult redirect" deterministically).

**Rationale.**
- *Decision 1:* PM's domain (project-content advisory grounded in constitution docs) is more load-bearing than `/consult`'s general structural advisory — rulings will be cited downstream and feed mandate/plan artifacts. The QC step's cost (up to 4 Opus calls per `/pm` invocation worst case) earns its place by reducing the chance of an ungrounded ruling propagating. Data-gated v1.1 review trigger added (review qc-reviewer pass-rate after 3 invocations).
- *Decision 2:* `principles.md § DR-7` (no speculative generalization). PM doesn't have a confirmed second consumer for ROUTING_CONTEXT replication, and Function B is genuinely operator-explicit-territory. Cleaner boundary: redirect to `/consult` for change-shaped questions.
- *Decision 3:* `principles.md § OP-3` (loud failure over silent continuation). The DISPATCH FAILED fallback handles the runtime gap correctly. PM's primary value (project-content advisory) is unaffected. v1.1 investigation will resolve the architectural question.

**Alternatives considered.**
- *Decision 1 alternatives:* (a) no QC step, mirror `/consult` precedent — initial plan default, rejected by operator; (b) lighter "self-check" instruction inside PM Phase 5 instead of full QC spawn — not pursued (operator wanted independent QC pass).
- *Decision 2 alternatives:* (a) PM mirrors `/consult` Step 3 and reads `repo-architecture.md` when shape=change, passing ROUTING_CONTEXT to system-owner — rejected per DR-7; (b) PM never attempts structure escalation at all (Phase 4 removed) — rejected because Function-A escalation IS useful when it works.
- *Decision 3 alternatives:* (b) hold the commit until runtime investigation completes — rejected (delays 80% benefit on a runtime quirk); (c) restructure PM to never attempt escalation — rejected (premature de-abstraction; AP-7 in reverse).

**Risk-check verdicts.**
- Plan-time: PROCEED-WITH-CAUTION (Low / Low / Medium / Medium / Medium)
- End-time: PROCEED-WITH-CAUTION (Medium / Low / Medium / Medium / Medium — D1 promoted)
- System-owner Function-B advisory concurred at both gates; recommended commit.
- 4 mitigations applied: BLOCKING dispatch trace test (fired); two-end-contract framing (both files); revert command dry-run verified; spot-check deferred to operator.

Plan retained: `/Users/patrik.lindeberg/.claude/plans/i-want-to-build-tidy-lake.md`.

### 2026-05-28 — Placement Discipline rule: enforcement, scope, and locked phrasing

**Context.** Operator asked whether `/route-change` could be auto-suggested from CLAUDE.md to keep future repo structure clean. Three design forks needed to be picked before the plan could be written: enforcement strength, trigger scope, repo scope. After plan draft, System Owner advisory surfaced three further scope adjustments. All decisions affected the always-loaded workspace rule layer.

**Decision.**

1. **Enforcement = soft CLAUDE.md rule** (not a PreToolUse hook).
2. **Trigger scope = only genuinely new files in new/uncertain locations** (not every Write, not edits).
3. **Repo scope = workspace-wide** (`ai-resources/`, `workflows/`, `projects/*`).
4. **Rule body phrasing locked verbatim** at "use the recommendation as the default" (not "consider").
5. **Third skip condition = structural** ("target home is one this session has already written to in a prior turn"), not judgment-based ("obvious from session context").
6. **Closing feedback line directs misses to `friction-log.md`** so accumulated misses size the future Hybrid hook upgrade.

**Rationale.** (1)–(3) chose the lowest-infrastructure option that still covers the operator's intent (no per-write latency, no false-positive prompts). (4) prevents the rule from softening into rubber-stamping (`principles.md § AP-4` — system-owner-cited). (5) avoids leaning on the same judgment the rule exists to backstop. (6) closes the loop on the rule's own reliability — gives a measurable signal for upgrading to the Hybrid hook later (`system-doc.md § 4.5`).

**Alternatives considered.** PreToolUse hook (rejected — over-fires on obvious placements, adds per-write latency); Hybrid soft-rule + narrow-path hook (deferred to a future addition contingent on friction-log signal); placing the rule in `ai-resource-creation.md` only (rejected — fails workspace-wide scope; misses non-resource placements like new dirs, audit subdirs); extending `/route-change`'s own self-trigger guidance (rejected as structurally inert — operator-invoked commands can't trigger themselves).

**Review trail.** `/qc-pass` GO + `/consult` PROCEED + `/risk-check` GO. SO behavioral-reliability estimate ~50–70% fire rate (structural triggers reliable; subjective triggers depend on the same recognition step the rule backstops — explicit reason the feedback-loop line was added).

## 2026-05-28 — Build `/resolve-incident` as fix-applying companion to `/resolve-repo-problem` (MVP scope)

**Context.** Operator presented a 7-file spec bundle for a 5-phase "Incident-Resolution & Change-Safety System" (10 governance assets + 6 commands + 3 review agents + learning layer with ADRs and pattern tracking). The spec was authored without knowledge of the existing `ai-resources` workspace; most of its Phases 1, 2, and 4 duplicate infrastructure that already exists: `/risk-check`, `/qc-pass`, `/refinement-pass`, `/route-change`, `/contract-check`, `/drift-check`, `/resolve-repo-problem`, the `system-owner` agent, `improvement-log.md`, `friction-log.md`. The spec's genuinely new value is concentrated in one place — a single fix-applying command that takes a known fault mid-session, classifies it, applies a bounded fix, and produces a standardized resumable incident record. `/resolve-repo-problem` does triage but explicitly applies no fix; no existing command closes the fault → classify → fix → verify → log loop end-to-end.

**Decision.** Build the MVP as a thin shell: 1 new command (`/resolve-incident`) + 2 new governance docs (`docs/protected-zones.md`, `templates/incident-log-template.md`) + 1 new log (`logs/incident-log.md`) + 1 new audit subdirectory (`audits/incidents/`) + 1 deprecation note on `/resolve-repo-problem`. Zero new agents. Zero new subagents. The new command routes to existing `/risk-check` and `/consult` Function B on High-risk paths via the Skill tool; conditionally appends `logged (pending)` entries to `improvement-log.md` for structural follow-ups (same coupling pattern `/resolve-repo-problem` already uses); produces a 4-field verification receipt inline (no external playbook); maintains a `status` field for resumability. The spec's Phases 2–5 (three-mode routing, four supporting commands, three review agents, ADR folder, incident-index automation, pattern-tracking thresholds, AUTO mode, verification-playbook) are explicitly deferred until at least three real incident runs show which assets are load-bearing.

**Rationale.** The operator-side memory `feedback_minimal_infra_subset` directs us to offer the lower-risk subset when a plan has a risky/novel component; the operator routinely drops QC-clean components of low marginal value. The spec's own Phase 3 doc explicitly recommends "Build small first... Get [the lean version] working end-to-end before layering in every table above." Existing infrastructure already provides ~80% of the spec's governance/QC/review surface. Building a parallel `command-registry`, `agent-registry`, `escalation-policy.md`, `authority-matrix.md`, `recurrence-prevention-policy.md`, `repo-map.md`, or `known-failure-modes.md` would produce duplicates that mostly restate `docs/autonomy-rules.md`, `docs/audit-discipline.md`, `docs/repo-architecture.md`, the existing `.claude/commands/` and `.claude/agents/` directories, and the active operational logs. The thin shell adds only what is genuinely new (fix-applying loop + protected-zone classification + standardized incident record).

**Alternatives considered.** (a) Spec-only critique with no build — rejected; operator wanted a buildable artifact. (b) Phase 1+3 only (full 10-asset governance foundation + the pipeline command, defer commands 2 and 4/5) — rejected; most of the 10 governance assets duplicate existing infrastructure. (c) Vertical slice across all 5 phases at minimum depth — rejected; adds 6 commands + 3 agents + 10 governance files + ADR folder + incident index for ~10% command-list growth and high orchestration-friction risk (recent friction-log shows command-orchestration false-positives are the dominant friction class). (d) Keep `/resolve-repo-problem` as the only fault-handling command — rejected; the spec's value-add is precisely the fix-applying loop, and the operator wants it.

**Sub-decisions made within the MVP.** (1) `/resolve-repo-problem` deprecate-and-absorb (option i) rather than keep as sibling (option ii) — only 1 deprecation note added; full deprecation deferred to v1.1 once usage data exists. (2) Keep canonical template + dedicated log (option B from the QC simpler-alternative finding) over writing per-incident records to `audits/working/` with schema in command body — operator chose explicit canonical shape over surface-area minimization. (3) Approve the auto-coupling to `improvement-log.md` Step 8c — same pattern `/resolve-repo-problem` already uses; disclosed inline. (4) Inline a 4-field verification rubric in the command body instead of deferring verification-receipt format to v1.1 — operator delegated decision via "help me decide"; chose immediately-actionable over file-dependency.

**Review trail.** `/clarify` → `/decide` (5 questions pre-researched against repo state; 1 self-resolved, 3 recommendable with operator confirmation, 1 operator-only) → `/scope` approved → `/qc-pass` REVISE → `/triage` (4 self-resolve + 3 operator-judgment + 1 low-signal) → 7 findings resolved → `ExitPlanMode` approved → build executed → end-time `/risk-check` PROCEED-WITH-CAUTION → 4 mitigations applied inline (heading-anchor citations + rollback note + 3× verbatim-shape contracts + routing-defect verification via symlink check) → System Owner second opinion concurred and added [PHASE-2-FILL] marker + 4th implicit contract identified → effective GO → commit `bc1db87`.

---

## 2026-05-28 — id-20 review-principle placement: new `## All Reviews` section

**Context.** Wave 1 fix-plan item id-20 added a "Name the bright-line before reviewing it" principle to `skills/ai-resource-builder/references/review-principles.md`. The file is organized into per-resource-type sections (`## Skills`, `## Workflows`, `## Pipeline Output`, `## Project Instructions`) plus a `## Candidates` queue for operator-pending drafts. Three placements were viable.

**Decision.** Created a new top-level `## All Reviews` section between `## How This File Works` and `## Skills`. Placed the bright-line bullet there.

**Rationale.** The principle applies across every review class — it's about how a reviewer anchors their judgment, not what they're reviewing. Duplicating into each per-resource section would create maintenance debt; parking in `## Candidates` is for drafts pending operator approval, but this principle has been operator-coached for 3 cycles (2026-05-16, 2026-05-20, 2026-05-22) and is past the candidate stage. The new section sits at file top, above per-resource sections, which mirrors the existing reading-order pattern (general → specific). QC reviewer verdict GO — confirmed placement is correct, wording fidelity high, downstream `evaluation-framework.md` reference path unchanged.

**Alternatives considered.** (a) Duplicate the bullet into every per-resource section — rejected; maintenance debt and visual noise. (b) Park in `## Candidates` — rejected; principle has cleared the candidate threshold (3 coaching cycles, codification explicitly directed by Wave 1 plan). (c) Extend the `## Project Instructions` section — rejected; bright-line-naming is about reviewer discipline, not the reviewed artifact's testability (the existing "Rule testability" bullet there is about *the rule being reviewed*, not *how the reviewer anchors judgment*).

**Review trail.** `/clarify` → `/scope` ("approved") → execution → `/qc-pass` GO (no revisions) → commit `f598ee1`.

---

## 2026-05-28 — Skip `/qc-pass` on Wave 1 id-04 because no edit was applied

**Context.** Wave 1 fix-plan item id-04 instructed: "Fix 4-vs-5-vs-6 count-drift in `ref-implementation-starter.md` Synthesis rules (line 60)" with `QC needed: yes` because the correct count is a judgment call. On reading the file at execution time, I found the file already consistent at "seven" (lines 39, 63, plus a 7-field table); the count-drift had been fixed by commit `fd8b5e7` on 2026-05-27 (the Stage 8.5 retirement session).

**Decision.** No edit to `ref-implementation-starter.md`. Annotated the source `session-notes.md` line 362 with `Resolved: applied 2026-05-28 via wave-1 hygiene plan — file currently consistent at "seven"; count-drift already fixed by commit fd8b5e7 (2026-05-27)`. Skipped `/qc-pass` because no judgment-bearing edit was applied.

**Rationale.** The plan's `QC needed: yes` was conditional on the fix being applied (the judgment is *which count is correct*, not *whether the file is consistent*). With no edit, the QC trigger does not fire. Skipping QC on a no-op preserves the operator's `feedback_minimal_infra_subset` preference for not running QC on QC-clean components of low marginal value.

**Alternatives considered.** (a) Run `/qc-pass` anyway as a verification ritual — rejected; the QC subagent's check would be against a non-existent edit, producing no actionable output. (b) Treat the plan instruction as binding regardless of file state and add a no-op edit + QC — rejected; ceremony without purpose. (c) Skip the annotation entirely — rejected; the annotation closes the loop on the source session-notes-line-362 flag, so a future audit pass doesn't re-flag the same already-resolved issue.

**Review trail.** Plan instructions read → file state verified (count-consistent) → git log confirmed fix in `fd8b5e7` → annotation applied → commit `8776651`.

## 2026-05-28 — Wave 2 commit cadence: per-repo batching over per-item

**Context.** Wave 2 fix plan execution touched 3 separate git repos (ai-resources, nordic-pe-macro-landscape-H1-2026, repo-documentation). The plan instructed "Commit per logical batch — the 3 `prime.md` edits + their log flips as one commit; each remaining item + its log flip as its own commit." Following this literally would have required splitting both `improvement-log.md` files across multiple commits.

**Decision.** One commit per repo (3 total). ai-resources `e45334e` (8 files), nordic-pe `5028c3b` (4 files), repo-documentation `5adbaa9` (1 file).

**Rationale.** Cross-repo log files cannot be split atomically — each `improvement-log.md` modification needs to be in a single commit OR the log files need to be temporarily split into per-item state. The latter adds churn without information value (the audit trail is already in the commit message + the source plan file). Per-repo batching preserves: (a) the atomic-staging rule from `commit-discipline.md`, (b) per-repo commit-message specificity (each commit names exactly the items it carries), (c) the bisect-ability of each item via the commit + the plan file index.

**Alternatives considered.** (a) Per-item commits with `improvement-log.md` split across commits — rejected (artificial state churn). (b) Single workspace-wide commit — impossible (3 separate repos). (c) Per-item commits with log-flip deferred to a final cleanup commit — rejected (split-stamp pattern is harder to audit than the natural per-repo grouping).

**Review trail.** Decided inline during Wave 2 execution after observing the cross-repo log-file constraint; no /risk-check needed (commit-cadence is not a /risk-check change class).

## 2026-05-28 — Path drift on Wave 2 id-12 (risk-topology.md)

**Context.** Wave 2 plan named the target file as `projects/axcion-ai-system-owner/references/risk-topology.md` for item id-12. Glob found the actual file at `projects/repo-documentation/output/phase-1/risk-topology.md` (plus a gitignored vault/ copy at `projects/repo-documentation/vault/architecture/risk-topology.md`).

**Decision.** Edited the actual canonical path (`projects/repo-documentation/output/phase-1/risk-topology.md`). Recorded the path drift in the QC handoff and the wrap entry.

**Rationale.** The plan's target path was a guess from the source improvement-log entry (line 172 of the nordic-pe improvement-log, which explicitly said "path to be confirmed by Friday cadence — likely under `projects/axcion-ai-system-owner/references/`"). The actual canonical location is in repo-documentation per the prior session-notes decision (2026-05-27 wrap): "Cluster 3 routing — edited `output/phase-1/` canonical source (not `vault/`, which is gitignored downstream Obsidian copy)."

**Alternatives considered.** (a) Defer the edit and ask the operator — rejected; the actual path was unambiguously discoverable via Glob + the prior session-notes precedent. (b) Edit both the output/phase-1/ and vault/ copies — rejected; vault/ is downstream of output/phase-1/ and gitignored.

**Review trail.** Path verified via Glob → prior session-notes decision (2026-05-27) confirmed output/phase-1/ as canonical → edit applied → committed in `5adbaa9`.

---

## 2026-05-28 — Removed git-push approval gate workspace-wide

**Context.** Across nearly every session, `git push` was blocked at the permission layer and branches sat ahead of remote at session end (ai-resources accumulated 10 unpushed commits; project-planning 9). The gate was reinforced by Autonomy Rule #2 ("External writes — `git push`, …") and restated in 15 CLAUDE.md / docs / commands files. The friction was structural — every project session inherited it.

**Decision.** Removed the push gate at all three layers: (a) `Bash(git push*)` stripped from the deny list in 21 settings.json files plus the canonical template, (b) "Push requires operator approval" language replaced with "push automatically after commit" in workspace `CLAUDE.md`, `ai-resources/CLAUDE.md`, `autonomy-rules.md`, `session-rituals.md`, and 11 project CLAUDE.md files, (c) `wrap-session.md` updated to run `git push` as a third step after commit; `new-project.md` updated to push the initial commit automatically; related commands (`resolve-incident.md`, `deploy-workflow.md`, `graduate-resource.md`) updated accordingly. Force-push, `reset --hard`, and branch deletion remain gated under Autonomy Rule #1. PR create, issue comment, Slack/email send, and third-party uploads remain gated under Autonomy Rule #2.

**Rationale.** Operator stated the friction directly and asked for both layers removed. Push is no different from any other bash command in this single-operator workspace: the operator already runs the session, owns the repos, and pays the cost of every commit they direct. The compensating controls (Autonomy #1 for destructive ops, force-push still gated) cover the residual risk. Memory `feedback_zero_permission_prompts.md` and `feedback_autonomy_during_execution.md` were already pointing this direction; this codifies them at the rule level.

**Alternatives considered.** (a) Keep the gate but auto-approve at wrap-session — rejected; the gate still consumes a permission-prompt cycle on every wrap, and the rule still gets restated everywhere it leaks. (b) Remove only the permission layer (settings.json) and keep the rule — rejected; the rule would re-add the deny on every audit and create false-positive `/permission-sweep` findings. (c) Add `Bash(git push*)` to ASK rather than removing it from DENY — rejected; ASK still surfaces a prompt, contradicting `feedback_zero_permission_prompts.md`.

**Review trail.** /clarify → 3 Explore agents (settings inventory, rules-doc inventory, command inventory) → plan written → ExitPlanMode approved by operator → all three layers edited → 16 batch commits across 16 git repos → 12 of 16 pushed successfully (3 remote-config issues unrelated to the gate, 1 with prior-session foreign dirty state blocking rebase) → memory `feedback_push_autonomous.md` written and linked in MEMORY.md.

## 2026-05-28 — Wave 3 deferral of id-09 (marker-as-counter security regression)

**Context.** Executing the Wave 3 fix plan's item 2 — id-09 (`/wrap-session` Step 3.5 PRIME_TASKS counter to handle chained auto-mode false-positives). The plan called for reading `logs/.session-marker` (written by id-31 Phase 1, just landed) as the `PRIME_TASKS` subtractor. At the re-evaluation gate after id-31 landed, I traced the failure mode end-to-end and surfaced a hidden security regression.

**Decision.** Defer id-09 to id-31 Phase 2 rather than apply the unsafe fix or a diagnostic-only fix. Friction-log:85 annotated with the deferral rationale. The fix re-opens alongside Phase 2's marker-scoped session-notes headers.

**Rationale.** `logs/.session-marker` is a SHARED file — both this session and a parallel session bump it. Concrete failure scenario: session A runs 1 `/prime` (writes `S1`), session B runs 1 `/prime` (overwrites to `S2`). A's `/wrap-session` reads the marker, computes `PRIME_TASKS=2`, subtracts from `ADDED_HEADERS=2`, gets `FOREIGN=0` → silently SHIPS B's content under A's wrap commit. This is the exact failure mode the foreign-guard exists to prevent. The current `PRIME_RAN=1` binary correctly STOPS in this case because it can't distinguish 1 vs 2 of my own — but applying id-09 with marker-counter math breaks that protection. Counting "this session's tasks" cleanly requires session-scoped state — which lands with Phase 2 (marker-scoped headers `## YYYY-MM-DD — Session {marker}` allow exact per-session counts via grep for THIS session's marker).

**Alternatives considered.** (a) Apply the marker-as-counter fix anyway, accept the regression, document the limitation — rejected; the regression is the exact failure the guard exists to prevent. (b) Diagnostic-only fix: keep PRIME_RAN=1, when FOREIGN ≥ 1 ADD a diagnostic showing "if chained-auto, expected task count = {marker N}" to help operator verify — operator-considered, rejected; reduces friction but doesn't auto-resolve, and the operator already verifies manually today. (c) Separate `.prime-task-count` file written ONLY by this session's /prime — rejected; same shared-file problem (any session writing to the file overwrites others). The only safe path requires session-scoped state.

**Review trail.** Plan-time re-evaluation gate after id-31 landed → analysis of marker-as-counter design → surfaced security regression → AskUserQuestion with three options → operator picked "defer to id-31 Phase 2 (Recommended)" → friction-log:85 annotated with deferral note + rationale → no /risk-check needed (no fix applied) → bundled into commit `2836dfa` alongside id-32.

## 2026-05-28 — Wave 3 id-31 Phase 1 source-spec deviation (footer drop)

**Context.** Executing the Wave 3 fix plan's item 1 — id-31 Phase 1 (`/prime` writes per-session marker `logs/.session-marker`). The QC'd plan called for surfacing the marker value in the `/prime` brief footer (Step 6) as a one-line `Session marker: {value}`.

**Decision.** Drop the brief-footer display from Phase 1. The marker-write at Step 8 (per source spec) lands; the footer display defers to Phase 2 alongside the first consumer.

**Rationale.** Step 6 brief renders BEFORE Step 8's marker write fires — the footer can't display a value that hasn't been written yet. Source spec (`logs/improvement-log.md` § "Concurrent sessions cause TOCTOU races on shared log files" / Migration plan / Phase 1) explicitly classifies Phase 1 as "Risk: zero (additive)" with NO consumers — the footer would cross into consumer territory. Dropping it keeps Phase 1 truly additive and pushes the footer naturally into Phase 2 where `/session-start` and `/session-plan` start reading the marker.

**Alternatives considered.** (a) Compute marker in a new early step (e.g., Step 4.5), display in Step 6, write at Step 8 — over-engineered for Phase 1; introduces dual-state. (b) Write marker at Step 4.5 (early), drop Step 8 writes, display at Step 6 — deviates further from source spec which specifies write at Step 8. (c) Show "PROJECTED" value in footer (peek without write) — workable but adds bash duplication and is misleading if /prime aborts.

**Review trail.** Plan QC'd to GO with footer requirement; deeper inspection during drafting surfaced timing conflict; picked source-spec-faithful subset per `feedback_minimal_infra_subset` → stated deviation inline before /risk-check → risk-check GO → applied → QC GO.


## 2026-05-29 — /tweak audit-log target: separate `tweak-log.md` (SO mitigation b)

**Context.** `/risk-check` on the proposed `/tweak` command returned PROCEED-WITH-CAUTION with Hidden coupling = High. The original SO-CHANGE-3 (first `/consult`) had directed `/tweak` to append its audit trail to `logs/maintenance-observations.md` so the Friday cadence would catch recurring patterns. The risk-check reviewer surfaced that this append shape would silently break 7 downstream consumers of `maintenance-observations.md` (`log-sweep.md:201` Cat A2 archival, `monday-prep.md:91` `tail -30` autonomy-axis parse, `docs/repo-architecture.md:215` single-writer claim, plus `so-monthly.md:22`, `session-plan.md:106`). Two mitigations on offer: (a) add dated aggregate `## YYYY-MM-DD — /tweak invocations` headers inside `maintenance-observations.md` + rewrite `monday-prep` parse; (b) route writes to a new sibling file `logs/tweak-log.md` registered in `log-sweep.md` Cat A2 and added to the Q6 log table.

**Decision.** Mitigation (b) — `logs/tweak-log.md`.

**Rationale.** Second `/consult` (auto-fired per `/risk-check` Step 4a on non-GO verdict) returned an SO concurrence with the verdict but disagreement with the reviewer's (a) recommendation. SO grounded (b) in: (i) `repo-architecture.md § Q6 log table` — one file × one writer × one purpose canonical pattern; `/tweak` audit trail is a distinct purpose from `/friday-act` repo-health observations; (ii) DR-7 + AP-7 — no shared infrastructure without confirmed second consumer; reusing `maintenance-observations.md` for an audit-trail purpose is speculative-shortcut shape; (iii) OP-3 — semantic overloading is silent coupling: under (a) the file would carry two block-shape contracts distinguished only by header suffix; (iv) smaller blast radius — (b) edits 3 files, (a) edits the same 3 plus `monday-prep.md` parse plus unverified rechecks of `so-monthly.md:22` and `session-plan.md:106` semantics.

**Alternatives considered.** (a) Per reviewer's recommendation, retain `maintenance-observations.md` as the single audit-trail file with namespaced day-headers. Rejected per SO grounding above. The reviewer's recommendation came from a "preserve file-locality" frame; SO countered with the principles frame (DR-7, OP-3, Q6 canonical pattern). When two grounded recommendations conflict, prefer the principle-cited one.

**Review trail.** `/clarify` → `/decide` (5 Recommendable items) → `/consult` 1 (ship with three named changes including SO-CHANGE-3 = `maintenance-observations.md` append) → operator plan approval → `/risk-check` (PROCEED-WITH-CAUTION, Hidden coupling High caught the SO-CHANGE-3 schema defect) → `/consult` 2 auto-fired per Step 4a (SO disagreed with reviewer's mitigation, recommended (b)) → operator picked (b) → implemented → `/qc-pass` REVISE → 4 fixes applied → end-time `/risk-check` skipped per `feedback_end_time_risk_check_skip` (drift bounded; QC fixes hardened bash logic only) → shipped commit `f84d87a`.

## 2026-05-29 — `/pipeline-review` cadence shape and `/audit-critical-resources` subsumption

**Context.** Operator asked for a recurring pattern to maintain and improve critical AI infrastructure resources (skills, commands, agents). System Owner advised, twice, against the chosen shape. Two operator overrides occurred in the same session; both load-bearing.

**Decision A — stand-alone weekly command, not a `/friday-checkup` tier.** System Owner's pre-ship Function B advisory cited `system-doc.md § 2.4` (architecture review already framed as a checkup tier) and `principles.md § DR-7 / AP-7` (no parallel cadence without forcing function) to recommend folding `/pipeline-review` into `/friday-checkup`. Operator picked stand-alone anyway.

**Rationale.** Operator preference for a deliberate, separable weekly slot tied specifically to design-review work — not housekeeping. The combined cadence would mix design-review judgment with checkup mechanical-execution and dilute the per-pipeline focus. Documented "Known design risk" inside the plan: two operator-invoked cadences with independent skipped-cycle gates can stall together silently. Mitigation: loud `[CADENCE-LATE]` marker at `>10 days`. Revisit fold-into-checkup if skipped twice per quarter.

**Decision B — consolidate `/audit-critical-resources` into `/pipeline-review` (option 3 of three).** When asked whether the new `/pipeline-review` could replace the old `/audit-critical-resources`, surfaced three options: full delete (lose currency-check signal), keep both (System Owner's earlier preference), or hybrid (fold currency-check into the new auditor + delete the old command). Recommended option 3. Operator confirmed.

**Rationale.** `/audit-critical-resources` ran exactly once since it was built (the 2026-05-25 report). Its unique contribution was the currency-check against three pinned Anthropic doc URLs — preserved by folding into `pipeline-review-auditor`'s Brokenness section. Operator memory `feedback_minimal_infra_subset` prefers leaner infra; this delete + fold cleanly satisfies that preference without losing signal. Scope of subsumption: 3 non-orchestrator commands from the old manifest (`friction-log`, `cleanup-worktree`, `token-audit`) added to the pipeline-review registry to preserve coverage.

**Alternatives considered.** Option 1 (full delete) loses currency-check. Option 2 (keep both, System Owner's pre-ship preference) preserves orthogonality but maintains an unused command and parallel registry. The hybrid (option 3) preserves all known signal while halving the maintenance surface.

**Review trail.** `/clarify` → `/decide` (5 Recommendable items) → `/consult` 1 (System Owner pushed back on stand-alone cadence; operator override) → plan QC'd, triaged, fixed → `/risk-check` (PROCEED-WITH-CAUTION, 6 mitigations applied) → shipped commit `e557915` → `/consult` 2 post-ship Function B (7 follow-ups; 4 cleared by triage including the highest-risk EXCLUDE_AGENT_GLOBS leak) → fixes shipped commit `0b2a3f0` → operator asked whether subsumption was possible → `/risk-check` 2 (PROCEED-WITH-CAUTION, 3 mitigations applied including the WebFetch frontmatter addition and the 32-symlink dry-run manifest) → shipped commits `bc17fdc` (ai-resources canonical), `6bd3d8c` (workspace), `e2f7eb5` (axcion-ai-system-owner).

**Both Step 4a `/consult` second opinions skipped** per `feedback_minimal_infra_subset` precedent (mitigations were operational, architectural choices were already operator-confirmed). Both end-time `/risk-check` calls skipped per `feedback_end_time_risk_check_skip` (drift bounded inside the plan-time envelope; corrective fixes only). All four skips surfaced explicitly in commit messages.

---

## 2026-05-29 — /pipeline-review registry expanded to tiered shape

**Context.** Operator asked what `/pipeline-review` considers as "critical." The registry at `audits/pipeline-review-registry.md` held 17 entries — the cold-start population from when `/pipeline-review` shipped earlier today plus 4 entries inherited from the deleted `critical-resources-manifest.md`. Operator triggered a System Owner consultation on whether other commands should be added.

**Decision.** Adopt System Owner's recommended tiered registry shape (weekly + quarterly) over flat expansion. Registry grew from 17 → 47 entries (32 weekly + 15 quarterly). Selection criterion made explicit in registry contract: weekly tier requires (i) `risk-topology.md § 1` Critical/High OR closed-loop choke point per `system-doc.md § 4.5`, AND (ii) multi-step / orchestration-shaped OR Anthropic-currency-dependent. Single-step utilities that are critical but stable → quarterly.

**Operator overrides applied.** Two SO recommendations overridden:
1. `friction-log` kept weekly (SO recommended TIER-LATER to quarterly). Operator judgment: the logging-pipeline contract is load-bearing for the friction → improvement → Friday loop; weekly depth is worth the rotation cost.
2. `recommend` added to weekly (SO had recommended SKIP as a simple posture-switch command). Operator judgment: the command is invoked often enough to warrant deep design review.

**Post-write tweaks (operator-directed).** After commit, operator tweaked the command directly:
- Removed 3-pick cap per cycle. Replaced with `[HEAVY]` cost advisory above 3 picks. Rationale: with 32 weekly entries, the 3-pick cap forced a ~12-week rotation; relaxing it lets the operator pick more when bandwidth allows.
- Expanded shortlist from top-5 to top-10 — surfaces row 6–10 without forcing path override.

**Rationale.** SO's tiered argument grounded in `system-doc.md § 4.5` (closed-loop bounded-latency) and `principles.md § DR-7` (second-confirmed-consumer test). Flat expansion past ~20 entries would push average per-pipeline rotation past the useful-memo half-life. Tiering routes deep-design work to the cadence that fits its cost profile — weekly for fast-evolving load-bearing infrastructure, quarterly for slow-changing single-step utilities.

**Alternatives considered.**
- Option a — keep registry tight (~17 entries) for fast rotation. Rejected: Friday cadence partners (`friday-act`, `friday-so`, etc.), the entire QC loop, and critical advisors stay invisible. Major coverage gap.
- Option b — flat expansion to ~25 entries. Rejected: rotation period dilutes past memo half-life for actively-changing pipelines.
- Option c — tiered (adopted). Routes each work type to the right cadence.

**Review trail.** Operator question → `system-owner` agent (Function A consult, ~93k tokens) → advisory at `projects/axcion-ai-system-owner/output/advisories/2026-05-29-pipeline-review-registry-scope.md` → operator adopt-with-overrides → registry + command shipped commit `c83e994` → operator post-write tweaks to remove 3-pick cap + expand shortlist top-10.

**Risk-check skipped at end-time** per `feedback_end_time_risk_check_skip` precedent: the registry edit is a content change against an existing contract (not a structural class), the file count is bounded (2 + 1 advisory), and the auditor body is unchanged. No mitigations to apply.

---

## 2026-05-29 — Relax /pipeline-review 3-pick cap; defer currency-check scope widening

### Decision 1 — Remove the 3-pipeline-per-cycle cap on /pipeline-review

**Context.** `/pipeline-review` shipped with a hardcoded cap at 3 picks per cycle (Step 21 rejection branch). Cycle 1 (cold start, 2026-05-29) ran against the freshly-expanded 47-row registry; operator's initial pick was 6 pipelines (rejected), trimmed to 3. After the run, operator asked why only 3 — confirming usage cost was not a constraint.

**Decision.** Removed the hard cap from Step 21. Shortlist expanded top-5 → top-10. New `[HEAVY-WIDE]` advisory line in Step 23 fires above N=3 with a token estimate (`N × ~100k`) — preserves cost visibility without gating.

**Rationale.** The original cap rested on three forces: opus cost per subagent (~85–110k tokens), operator throughput on the "Recommended next session" output queue, failure blast radius if N subagents partially fail. With the registry at 47 entries and usage not a constraint, the actual ceiling is fix-session-queue throughput — which is operator-side and can self-regulate. Cost signal preserved via `[HEAVY]` + `[HEAVY-WIDE]` chat markers.

**Alternatives considered.**
- **Keep cap at 3** — rejected: operator pushback; rotation too slow against 47 entries (weekly tier ~11 weeks rotation OK; quarterly tier ~5 quarters for 15 entries — too slow).
- **Raise cap to 4 on quarterly tier only** — rejected: half-measure; operator wanted the option to pick more whenever, not just on quarterly weeks.
- **Soft cap with confirmation above N=3** — rejected: adds a prompt; operator's decision-point posture is "no opinion-seeking asks"; `[HEAVY-WIDE]` advisory is the chosen middle ground (visible, not gating).

### Decision 2 — Defer widening the auditor's currency-check URL set

**Context.** Operator noticed `pipeline-review-auditor` reads only one pinned URL per memo (unified skills/commands docs) and doesn't sweep MCP, hooks, agent-tool conventions, or model-card updates. Asked whether to fix.

**Decision.** Defer. Neither variant is urgent; trigger to implement = a future `/pipeline-review` cycle surfaces a real miss tied to MCP/hooks/agent-tool drift that the single-URL check missed.

**Rationale.** Today's three reviews didn't miss anything a wider check would have caught (currency findings were all in the frontmatter-shape category, which the current URL covers). Widening proactively adds cost without proven signal. Two design variants exist if/when the trigger fires.

**Alternatives considered.**
- **Dynamic per-pipeline URL set** — auditor adds the hooks doc only when the pipeline reads/writes hooks, MCP doc only when it invokes MCP tools. Keeps signal density high; deferred as the "implement first" variant when trigger fires.
- **Separate quarterly platform-drift sweep command** — fetches the broader Anthropic doc surface once, writes a workspace-wide drift memo. Cleaner separation; deferred as the alternative shape.
- **Blanket widen now** — rejected: 3–5× WebFetch cost per memo with most pipelines not touching MCP/hooks meaningfully; dilutes signal density.

---

## 2026-05-29 — Friday-act permissions-settings item 7: M1 Layer-divergence accepted as intentional

**Context.** Permission-sweep 2026-05-29 surfaced 1 MEDIUM finding (M1, Rule 11): Layer A (`~/.claude/settings.json`) lacks `Bash(git reset --hard *)` and `Bash(git checkout *)` denies that Layer B (workspace root `.claude/settings.json`) carries. Layer A also has broader `Edit(**)` / `Write(**)` allows absent from Layer B.

**Decision.** Accept divergence; no edit to either layer.

**Rationale.** The audit's own remediation hint reads "Operator review. Layer A is intentionally more permissive (personal machine); divergence is by design. No mechanical fix unless operator wants uniform git guards at user level." Operator memory `feedback_zero_permission_prompts` ("never add to deny list") forbids adding the missing guards to Layer A. Removing the existing guards from Layer B would reduce protection on the workspace where shared/sensitive state lives. Neither move improves the safety/ergonomics trade.

**Alternatives considered.**
- **Add `Bash(git reset --hard *)` + `Bash(git checkout *)` to Layer A.** Rejected per `feedback_zero_permission_prompts` memory.
- **Remove the two git guards from Layer B.** Rejected — Layer B is the workspace-wide guard layer and the denies are operator-accepted.
- **No-op.** Selected.

**Item closure.** Friday-act plan permissions-settings item 7 closed as "decision-only, no file edit, no risk-check needed".

---

## 2026-05-29 — Friday-act log-sweep item 2 deferred: workspace excluded from /log-sweep scope

**Context.** Friday-act log-sweep plan item 2 specified running /log-sweep against workspace root logs/session-notes.md (518 lines) and logs/session-notes-archive-2026-04.md (821 lines, gap-file rotation). This morning's apply-mode /log-sweep across 14 scopes excluded workspace root by spec design (only ai-resources + projects/* are valid /log-sweep scopes).

**Decision.** Defer item 2. Two paths exist; neither is a same-day fix.

**Rationale + alternatives.**
- **Manual archive of workspace session-notes.md (~518 lines):** doable but requires careful coordination with the workspace's own `check-archive.sh` cadence (referenced by the SessionStart hook). Not a fast win in a fix session.
- **Gap-file rotation of session-notes-archive-2026-04.md (821 lines):** even less urgent — this is an old archive (April); 821 lines is not blocking anything operationally. Splitting it into gap files would add file-count churn without clear benefit until a token-budget gate fires on workspace reads.
- **Extend /log-sweep spec to include workspace root scope:** structural change, /risk-check required. Out of scope for this item.

**Trigger to revisit.** A token-audit signal that workspace session-notes.md or its archive is showing up as a meaningful read-budget consumer; OR an operator request.

**Item closure.** Friday-act plan log-sweep item 2 closed as DEFERRED-WITH-REASON.

---

## 2026-05-29 — Friday-act project-triages: triage + dispatch decisions

**Scope.** Plan project-triages had 3 items (one per project) covering 14 total improvement-log entries (5 + 3 + 6). Decisions recorded below per entry-batch.

### Item 3 — nordic-pe-macro (6 entries)

1. **RECURRING check-archive.sh CLAUDE_PROJECT_DIR-unset:** ✓ APPLIED this session. Canonical `ai-resources/.claude/commands/wrap-session.md` Step 3 wrapped with explicit `CLAUDE_PROJECT_DIR="$(pwd)"`. Workspace-root wrap-session.md does not invoke the script — no port needed. Smoke-test on next wrap.
2. **RECURRING wrap-session today-header inflation:** SCHEDULE-DEDICATED. Fix requires new `.session-header-line` marker file + symmetric writes in `/session-start` Step 3 mandate-append + read in `/wrap-session` Step 4. Multi-file shared-state protocol — wants /risk-check (PROCEED-WITH-CAUTION likely) and a focused session. Block out time within next 2 weeks. Recurring 4 days running; do not defer further.
3. **settings.json _comment schema rejection — fallback pattern undocumented:** DEFER. One-paragraph doc add to `docs/permission-template.md` § Caveats + cross-link from `docs/audit-discipline.md`. Trivial but only first occurrence; batch with the next docs-edit session (Plan 4's repo-documentation overlap is a candidate).
4. **/innovation-sweep triage cadence:** DEFER. Add a decision-cadence rule to `innovation-sweep.md` (or sibling). First occurrence; pattern not yet established. Revisit at next `/innovation-sweep` invocation that produces >0 unplanned candidates.
5. **Verify /session-plan Step 0 MISMATCH fix actually suppressed firing:** DEFER. Verification-only; not a defect yet. Sample 2-3 next /session-plan invocations from this project to see whether the MISMATCH branch fires or not before deciding fix vs boilerplate update.
6. **Innovation-sweep auditor cross-repo write:** DEFER. One-line clarification to auditor SKILL.md or calling command. Trivial but low-impact; bundle with next innovation-sweep-related touch.

### Item 1 — ai-development-lab (5 entries)

Themes per plan: ambiguous-referent self-check, concurrent-session staging detection, mid-session staleness of clean-tree snapshot, friction-log Write Activity capture gap, pipeline write-deny rationale doc.

**Triage outcome — all DEFER.** None are RECURRING; none flagged HIGH in the plan. Themes are mature-system tuning, not bug-fixes. Schedule as a dedicated ai-development-lab maintenance session within next 2 weeks. The "concurrent-session staging detection" entry overlaps with workspace TOCTOU mitigation (Plan 5 item 1) — do not double-fix; defer until TOCTOU rollout phases 2-4 land.

### Item 2 — axcion-brand-book (3 entries)

Themes per plan: `/draft-module` heredoc routing for cached-deny modules, brand-strategist subagent contract (notes-to-disk), per-module allow-override CLAUDE.md pointer.

**Triage outcome — all DEFER.** First-occurrence design improvements for a system in active build. Schedule as a dedicated axcion-brand-book session when the operator next touches that project. The "subagent contract notes-to-disk" entry should reference `ai-resources/CLAUDE.md` § Subagent Contracts when implemented.

### Closure note

This dispatch converts 14 pending improvement-log entries into 1 APPLIED, 12 DEFER, 1 SCHEDULE-DEDICATED. The deferrals are logged decisions, not silent drops — each entry stays in its project's improvement-log with this decision-anchor pointing back here.

## 2026-05-29 — Reversed push protocol: autonomous → gated and batched

**Context.** On 2026-05-28 the operator removed the "ask before pushing" gate and the rule layer, making `git push` autonomous after every commit. Rationale at the time: branches were piling up unpushed (e.g., ai-resources at 10+ commits) and the gate had become structurally blocking. One session later (2026-05-29), the operator reversed the decision.

**Decision.** Push is gated and batched. No `git push` mid-session. Commits accumulate locally until session end (`/wrap-session` or explicit "we're done" / "ship it"). At that point, a single confirmation prompt — `Ready to push N commits across M repos: [list]. Push now? y/n` — gates the actual push. Push proceeds per repo on `y`, skips on `n`. No mid-session exceptions, even for "critical" fixes.

**Rationale.** Operator wants control over when remote state changes, including the ability to inspect commits before they ship and to keep work local while iterating. The autonomous rule had the practical effect of making every commit a remote write, which removed an inspection point the operator values. The VS Code extension push path was a secondary concern — gating the push at one well-defined moment (session end) makes the extension's push behavior testable and predictable instead of firing at every commit.

**Alternatives considered.**
- **Operator runs `git push` manually** (Claude never pushes) — rejected. Adds operator burden without solving the inspection-point problem any better than a single confirmation prompt.
- **Per-commit confirmation prompt** — rejected. Restores the high-friction shape that originally drove the 2026-05-28 removal.
- **Hook-based enforcement** (pre-push hook blocks mid-session pushes) — rejected for this round. Rule-level change is sufficient and reversible; hook-level enforcement adds blast radius without proportional benefit.

**Trade-offs accepted.** Branches will again accumulate commits between session ends. The operator accepts this in exchange for the inspection point. If accumulation becomes a problem again, the resolution is *not* a return to autonomous push but a faster wrap cadence.

---

## 2026-05-29 — Friday-act repo-documentation: item-by-item decisions

**Scope.** Plan repo-documentation had 6 items spanning W2.1 doc-scanner fixes (item 1), projects.md §4.4 re-author (item 2), 7-entry vault paste (item 3), 212-entry backlog (item 4), deprecation-row policy (item 5), /kb-integrity re-run (item 6).

### Item 1 — W2.1 doc-scanner coverage gaps
✓ APPLIED. Added 2 walk rows (skill-internal subagents `ai-resources/skills/*/agents/*.md` → agents; workspace-root `.claude/references/*.md` → references) and a basename-collision detection rule for project-local files sharing canonical basenames. Edit at `projects/repo-documentation/.claude/agents/doc-scanner-agent.md`.

### Item 2 — Re-author projects.md against §4.4 schema
ALREADY DONE — confirmed by reading current `vault/components/projects.md` (last_updated: 2026-05-22): all 7 entries have the 10-field §4.4 schema (Type, Location, Source, Purpose, Model, Status, Phase, Key Outputs, Infra Dependencies, Risk Class); the 6 unexpected §4.1 fields (Triggers, Scope, Used By, Depends On, State Writes, Governed By) are gone. The 2026-05-22 re-author session closed this; the friday-act plan was stale on this item.

### Item 3 — Paste 7 net-new entries since 2026-05-22
DEFER to dedicated KB-paste session. The 7 specific entries (1 command `pipeline-review`, 4 canonical agents — likely `fading-gate-scanner`, `fix-repo-issues-scanner`, `friday-act-16a-summarizer`, `project-manager`; 2 projects) must be hand-picked from the 1771-line `w2-1-doc-scan-2026-05-29.md` drift report, with each Added entry's `Status: draft` promoted to `Status: active` after review. Mechanical-but-careful work; batch with item 4.

### Item 4 — 212-entry carry-forward backlog
DEFER + recommended approach: dedicated KB-paste session within next 2 weeks. The 212 entries are accumulated drift since 2026-05-22. Doing them piecemeal across sessions is wasteful; one focused session with the drift report open is the right shape. Per decision-point posture, the operator's recommended option = scheduled dedicated session (not silent further-defer).

### Item 5 — Deprecation-row policy (prose body vs §4.1 schema addition)
DECISION: §4.1 schema addition. Treats deprecation as a first-class lifecycle state rather than prose narrative. Cleaner long-term; consistent with the existing Status enum (`draft | active | deprecated`). The schema addition itself = adding the `Status: deprecated` enum semantics + a brief one-paragraph rule to `documentation-structure.md` §4.1 stating how deprecated entries should be marked. APPLICATION DEFERRED — bundle with item 3/4's KB-paste session so the new policy lands together with the entries it governs.

### Item 6 — Re-run /kb-integrity after items 2, 4, 5
DEFER — depends on items 4 and 5 landing first. Run at end of the dedicated KB-paste session.

### Closure note
This dispatch converts 6 plan items into 1 APPLIED (item 1), 1 ALREADY-DONE (item 2), 4 DEFER-WITH-DECISION (items 3-6). All deferrals are scheduled into a single dedicated KB-maintenance session within next 2 weeks.

---

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
