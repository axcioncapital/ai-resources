# Work Loop v2 Autonomy, Authority, and Capability — Implementation Plan v0.1

**Status:** Draft. Not reviewed, not frozen. Grants no implementation authority. This artifact converts
the approved proposal into one repository-grounded plan for a fresh implementation-plan review to judge
and freeze, per the operator's 2026-08-14 compact-workflow process decision.

**Governs:** [`work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`](work-loop-v2-autonomy-authority-capability-proposal-v0.1.md),
content-bound approved at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67` (blob
`39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`), status-recorded at commit `5b0d5fd857a2d663dfc298071faf2033f884b0eb`.
No substantive proposal content changed between those two commits (verified — see § Repository Delta,
Inventory method).

---

## 1. Fixed Point

**Approved outcome.** Work Loop v2 adopts one governing autonomy rule (proposal §1): within the approved
solution envelope, resolve what evidence can resolve, exercise professional technical judgment, use only
pre-authorized capabilities; consequence scales containment and verification, it does not by itself
transfer the decision to the operator; escalate only for operator-owned intent, accepted risk, a material
solution-envelope change, or capability-envelope expansion; stop when a load-bearing premise or required
verification cannot be established, or continuing would bypass the control system.

**Exact authoritative content identity.** The proposal at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`
/ blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b` governs. Its §14 sequence, §15 decisions, and §16 success
standard are the target this plan implements. Nothing in this plan may narrow or widen §15's seven
approval decisions; a plan detail that would have to do so is a false premise for this plan, not a
license to reinterpret the proposal.

**Fixed decisions carried forward without renegotiation (proposal §§3–13, verbatim intent):**

- The dual-key authority model — semantic authority (should the actor do this?) and capability authority
  (may the actor cause this effect?) are both required; neither substitutes for the other (§3).
- Consequence scales safeguards (stronger premise verification, narrower paths/tools, more tests,
  rollback evidence, isolation, the existing risk-aware review row, a tighter network/effect profile,
  stronger closure proof) — it is not an automatic operator gate (§4).
- Implementation architecture is agent-delegated inside the approved solution envelope; changes to the
  envelope itself, the operating model, material cost/risk profile, or governance model return to the
  operator (§3.1, §6 Operator-reserved decisions).
- The attended carrier (`scripts/axcion-harness-v0.2/carry-turn.sh`) is the sole current Standard
  enforcement surface, released attended-first (§9, §15 item 5).
- The carrier does not enforce per-invocation sandbox or network/tool restriction today — confirmed by
  inspection (§ Repository Delta below) — and this proposal defers that enforcement, and the
  connected-development trial that depends on it, out of the MVP sequence (§9, §11, §14 item 4 and 6).
- The audit-derived harness-configuration confirmation (`docs/autonomy-rules.md` pause trigger 8) and the
  no-self-waiver rule for structural change classes (`docs/audit-discipline.md` § Structural change
  classes) are retained unchanged for the MVP (§14 item 3); nothing in this plan removes or weakens them.
- No new autonomy framework, state system, approval ledger, routine checklist, confidence engine, or
  assumed evaluation runner is created (proposal Design constraint; §12; §13).

**Observable success condition (proposal §16, unchanged):** the Work Loop produces both (1) agents
investigating, choosing, implementing, testing, correcting, and executing pre-authorized technical
actions without unnecessary operator interruption, and (2) agents stopping reliably before inventing
operator intent, exceeding the solution envelope, using an unauthorized capability, accepting undelegated
risk, bypassing containment, or claiming unverified load-bearing results. The evaluation proposal's twelve
scenarios (§12) are the acceptance instrument; each currently resolves to one paired live trial because
no automated runner exists yet (confirmed below).

---

## 2. Repository Delta

### Inventory method

Tracked-source searches only, run from this checkout's repository root (`git rev-parse --show-toplevel`
confirms this checkout is the linked worktree `ai-resources-autonomy-authority`, sharing the `ai-resources`
object store). Every absence claim below names the exact search and its bounded negative result. No
external effect, no live actor, no carrier or dispatcher invocation was launched; all checks are either
`git`/`grep`/`ls` inspection or the repository's own hermetic deterministic test suites (fake actors or
none), run and reported in § Safe deterministic checks run below.

- `git grep -l "work-loop-v2-executable-core"` — 60 tracked hits (commands/skills, docs, logs, plans,
  session-plan archives, run JSON). Live consumers (not history) are the two files revised below.
- `git grep -ln "work-loop-v2-mvp-proposal-v0.4\|Proposal wins"` — 21 tracked hits; the only live
  authority-bearing hit is the executable core itself (§14 item 1's exact target).
- `git grep -n "authority\|autonomy\|Proposal wins\|governing rule" .claude/commands/work-loop-v2.md
  .agents/skills/work-loop-v2/SKILL.md .claude/commands/session-plan.md` — targeted per-file scan (results
  below, per file).
- `git grep -ln "capability envelope\|capability subset\|capability profile\|runtime profile"` with no
  path restriction returns exactly two files: the proposal itself (`work-loop-v2-autonomy-authority-
  capability-proposal-v0.1.md` — §3.2's "Plan capability envelope" / "Runtime profile" hierarchy, §7's
  "Capability model") and this plan, which restates that language. **Corrected finding (was stated as a
  zero-hit "greenfield" claim — that was false; the phrase is literally in the approved proposal).** The
  same search bounded to the eight tracked **live implementation surfaces** —
  `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, the executable core,
  `docs/autonomy-rules.md`, `docs/qc-independence.md`, `docs/audit-discipline.md`, `carry-turn.sh`, and
  `dispatch.sh` — returns **zero hits**. The honest claim is narrower than what was first written: the
  concept is *described* in the governing proposal and now in this plan, but is not implemented,
  referenced, or enforced in any live implementation surface today.
- `git -C .. rev-parse --show-toplevel` from this checkout resolves to `/Users/patrik.lindeberg/Claude
  Code/Axcion AI Repo`, a **separate git repository** (`origin` = `axcioncapital/workspace-root.git`)
  from `ai-resources`. Workspace-root `CLAUDE.md` is tracked there, not in this repository or worktree.
  A bounded read of that file's `## Autonomy Rules` section (lines 129–133) found only a short pointer
  summary to `ai-resources/docs/autonomy-rules.md` — the file being reconciled at T3 — and no separate or
  competing statement of a governing autonomy rule. No conflict was found; see the Components table row
  below for the corrected classification.

### Components, classified

| Component | Path | Classification | Basis |
|---|---|---|---|
| Executable core, authority line | `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:9-10` | **Modify** | Confirmed present verbatim: "Built from the Proposal (`work-loop-v2-mvp-proposal-v0.4.md`), which stays authoritative. Where this file and the Proposal disagree, the Proposal wins." Proposal §14 item 1 targets exactly this line. |
| Executable core, governing rule | same file, § 1 (new) | **Add** | No §1 clause exists in the core today; the file currently has no numbered governing-autonomy section (confirmed by full read). |
| Codex skill authority hierarchy | `.agents/skills/work-loop-v2/SKILL.md:429` | **Keep, reconcile wording only** | The skill already states: "current operator decision → canonical operator-approved project plan → applicable approved workflow or SOP → authoritative current state → verified repository reality → settled implementation decision → operator source material or exploratory context → Codex proposal or preference" — near-identical to proposal §3.1's eight-level hierarchy. No semantic change needed; only a pointer to the now-canonical §1 rule, if the plan reviewer judges one is needed. |
| Claude command | `.claude/commands/work-loop-v2.md` | **Keep, reconcile wording only** | One hit at line 126, framing-only ("never performs Codex's preparation, authority or selection judgments itself"); already consistent with the dual-key model. No contradiction found. |
| `docs/autonomy-rules.md` | whole file (51 lines, read in full) | **Keep, reconcile wording only** | Trigger 8 (audit-derived harness-configuration confirmation) and trigger 9 (structural-class risk-aware review, pointing at `qc-independence.md` and `audit-discipline.md`) already implement the retained rules proposal §14 item 3 names as "already-compatible." No content change is authorized by the proposal; only referencing §1 is in scope, and the proposal explicitly forbids weakening triggers 8–9. |
| `.claude/commands/session-plan.md` Step 5 "Autonomy posture" | lines ~132–150 | **Uncertain — likely no change, confirm at review** | This step classifies **session-level pause granularity** (Full autonomy / Gated / Operator-in-the-loop) for planning a session's wrap behavior — a different axis from §1's per-action semantic/capability authority test. It is not contradictory. Whether "reconcile ... to reference the same §1 rule" requires even a cross-reference here, or nothing, is a plan-review judgment, not resolved by this document. |
| `docs/qc-independence.md` | whole file (71 lines, read in full) | **Keep** | Already implements proposal §4's "one proportional risk-aware review where the existing QC rule requires it" exactly (three-row table: none / one Codex review / one risk-aware Codex review). No change identified. |
| `docs/audit-discipline.md` § Structural change classes | lines 56–110 | **Keep** | Already implements the no-self-waiver rule and the structural-change-class list proposal §14 item 3 requires retained. No change identified. |
| Carrier, `--unattended`/`--contained`/`--sandbox` refusal | `scripts/axcion-harness-v0.2/carry-turn.sh:296-320` | **Keep (confirms proposal §9's claim)** | `refuse_flag()` names each flag and refuses with an explicit reason ("this is the attended surface and it has no unattended mode"). Matches proposal §9 verbatim. |
| Carrier, nested-actor prevention | `carry-turn.sh` (`observe_nested`, `CLAUDE_DENY_MANDATORY`, ~15 nested-actor code hits) + `carry-turn.test.sh` (50 "nested" hits, including both an "observed" and an "unobserved" path) | **Keep — already implemented and verified on this host** | Ran `carry-turn.test.sh`: 285 passed, 0 failed, including nested-count assertions that require live process observation to pass. Proposal §14 item 7 ("add symmetric nested-actor prevention and verify ... on a host where process observation is available") is functionally satisfied; only an explicit evidence record is missing. |
| Dispatcher, contained `--unattended` profile | `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` | **Keep** | Closed task `logs/work-loop/work-loop-v2-contained-unattended-profile.md`: "Phase 1 item 1d is complete." Ran `dispatch.test.sh`: 454 passed, 0 failed (fully simulated). |
| Dispatcher, descendant containment | same file | **Uncertain / requires proof — explicitly unresolved** | Closed discovery task `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md`: "No mechanism available within the present authority can truthfully terminate every fully detached descendant... Disposition: OPERATOR DECISION REQUIRED." A later task closed Phase 1a "at pilot grade," not as full closure. This is the concrete blocker behind proposal §9's "descendant containment remaining insufficient for a safe unattended claim" and behind §14 item 14 (unattended release gated on full-lifetime containment). |
| Task-scoped ownership / one-writer boundary | `logs/scripts/work-loop-owner.sh` + `work-loop-owner.test.sh` | **Keep** | Ran the suite: 92 passed, 0 failed (T1–T13 + F1–F3, concurrent task isolation). Already implements the "exact task, checkout, actor, turn, deadline, one-writer boundary" row of proposal §8's allocation table. |
| Core resolver, linked-worktree identity | resolver text embedded in `.claude/commands/work-loop-v2.md` and `.agents/skills/work-loop-v2/SKILL.md`, tested via `logs/scripts/work-loop-v2-core-resolver.test.sh` | **Keep** | Ran the suite: 4 passed, 0 failed. Not named by the proposal directly, but load-bearing for every unit this plan proposes to run from this worktree. |
| State file capability-context fields | `logs/work-loop/{task}.md` `## Brief` / `## Latest result` | **Modify (content shape, not structure)** | Proposal §3.2: "the current brief records the selected capability subset and the execution evidence records the actual runtime profile. No second approval artifact or capability ledger is created." The five-field ceiling (executable core § 4) is unchanged; this is new *content* inside existing fields, confirmed by re-reading the core's field table — no sixth field is authorized. |
| Evaluation — deterministic layer | `logs/scripts/work-loop-v2-slice-1.test.sh` | **Keep** | Ran the suite: 308 passed, 0 failed — matches the exact count recorded in the closed `eval-v0-3-partial-fixes` task, confirming no drift since that fix landed. |
| Evaluation — behavioural layer | `eval-mvp-proposal-v0.2.md` (12-scenario table proposal §12 references) | **Add (paired live trials), Keep (mechanism)** | No runner exists (confirmed: `git grep` finds no runner implementation, only the proposal text and the CE-9 instrument). `logs/work-loop/eval-v0-3-restart.md` shows the CE-9 paired-trial *mechanism* already executed once (result: PARTIAL) — but CE-9 is Context Engineering's own recovery scenario, not one of this proposal's twelve autonomy scenarios. The twelve scenarios in §12 have not been run under this mechanism yet. |
| Capability envelope / subset concept | described in the proposal (§3.2, §7, §11); absent from all eight live implementation surfaces | **Add (to the live surfaces only)** | Corrected: not a "greenfield" claim about tracked sources — the proposal itself already names the concept. The accurate gap is that no live implementation surface (skill, command, core, autonomy-rules, qc-independence, audit-discipline, carrier, dispatcher) references or enforces it yet. |
| Workspace `CLAUDE.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` | **Keep — repository-boundary finding retained; no required edit proven** | Corrected: §14 item 3 does **not** name workspace `CLAUDE.md` (it names the Codex skill, Claude command, autonomy rules, and session-plan language only). §15's closing paragraph is conditional — *if* workspace `CLAUDE.md` changes, that change is a separate high-consequence unit — it does not itself require a change. A bounded read of the file's `## Autonomy Rules` section found only a pointer to `ai-resources/docs/autonomy-rules.md` (being reconciled at T3) and no conflicting statement, so no edit is proven necessary. The valid, retained finding is narrower than originally stated: workspace `CLAUDE.md` is tracked in a **separate git repository** (`workspace-root`, not `ai-resources`), outside this task's checkout, state file, and ownership helper (`work-loop-owner.sh --depth repo`) — so *if* future evidence proves a required change, that change cannot be executed, committed, or owned from this task and needs its own task (or Direct Work) opened inside the `workspace-root` checkout. |

### Safe deterministic checks run

All hermetic (fixture-based or fully-simulated fake-actor); none launched a live Claude/Codex actor, the
carrier, the dispatcher, or any external effect.

| Suite | Result |
|---|---|
| `logs/scripts/work-loop-v2-slice-1.test.sh` | 308 passed, 0 failed |
| `logs/scripts/work-loop-v2-core-resolver.test.sh` | 4 passed, 0 failed |
| `logs/scripts/work-loop-owner.test.sh` | 92 passed, 0 failed |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` | 454 passed, 0 failed |
| `scripts/axcion-harness-v0.2/carry-turn.test.sh` | 285 passed, 0 failed |

`git status --porcelain` before and after this run differs only by the two files this Discovery unit is
authorized to touch (this artifact, the state file); no test suite left residue in the tree.

### Ordering constraints and risky assumptions

1. **The executable core revision (Fixed Point item 1) must land, at an identifiable approved commit,
   before any other tracer cites "the canonical core"** — the proposal is explicit that this approval "is
   what makes the core canonical; it has not happened yet." Every other reconciliation tracer (skill,
   command, autonomy rules, session-plan) is sequenced after it for that reason, not because their own
   edits are large.
2. **No tracer in this plan touches workspace `CLAUDE.md`.** Corrected: the earlier draft scheduled it as
   a required, deferred unit; the bounded read above found no proven conflict, so nothing is scheduled.
   The retained fact is the boundary itself — a **different git repository** from this checkout — carried
   as a standing constraint that applies *only if* a future tracer's evidence later proves an actual
   required edit. It is not evidence that one is needed now, and this plan does not manufacture one.
3. **The MVP evidence-gathering work (§14 items 8–12) is not one small tracer, and it is not one phase.**
   Proposal §12 states the scenario-suite cost directly: exercising the full twelve-scenario table costs
   roughly twelve paired live trials until a runner exists — that is T7 below. Separately, §14 item 10
   requires 3–5 **real** Standard-lane tasks across at least two capability shapes — organic operational
   use, not constructed scenarios — recorded at T8. Folding item 10 into the scenario-suite trials was a
   correction-round finding (Finding 4); the two are scheduled as distinct units for that reason.
4. **Descendant containment is an accepted open limitation, not a blocker for this MVP.** The proposal
   already scopes unattended release and the connected-development trial out of MVP (§9, §11, §14 items 4,
   6, 14). This plan does not schedule new work to close the descendant-containment gap; doing so would
   expand scope beyond what §15 approved. If a later tracer's evidence changes that judgment, it returns
   to the operator as a scope question, not a decision this plan or its tracers make silently.
5. **Risky assumption:** the plan assumes `.agents/skills/work-loop-v2/SKILL.md`'s existing authority
   hierarchy (line 429) needs no substantive rewrite, only a citation. If the plan reviewer or the
   implementing unit finds a real conflict (not just missing cross-reference), that tracer's scope grows
   and should be re-split rather than absorbed silently.

---

## 3. Implementation Specification

Only for capabilities the approved MVP (proposal §14 items 1–8, plus the evidence-gathering items 9–12)
actually requires. Uses the proposal's own language throughout, per the brief's instruction.

### 3.1 Governing autonomy clause (executable core)

- **Inputs:** the approved §1 clause text (proposal §1, verbatim); the core's current §9-10 authority
  line.
- **Outputs:** the core with (a) a new numbered section carrying the §1 clause, and (b) the authority line
  rewritten so the core is no longer subordinate to the proposal, with `work-loop-v2-mvp-proposal-v0.4.md`
  recorded as historical rationale.
- **Guaranteed behavior:** every consumer that resolves "the executable core" (the two live command/skill
  resolver blocks, confirmed byte-identical by `work-loop-v2-core-resolver.test.sh` check 4) reads the
  same governing rule text; no second copy is created.
- **Failure behavior:** if the operator has not approved the specific revised commit, the core remains
  in its current (draft-header, subordinate) state and no consumer may treat the new clause as canonical.
- **Side effects:** none outside the one file; this is a documentation-authority change, not a runtime
  behavior change by itself.
- **Public seam:** the core file's own text is the seam; every consumer already points at it by relative
  path (confirmed: 60 tracked references, § Repository Delta).
- **Fail-capable evidence (corrected — Finding 5):** the resolver suite proves consumers still resolve
  the same file; it does **not** prove the subordination line is gone or the clause is present, so two
  targeted checks are required in addition: (a) `grep -q "the Proposal wins" <core file>` must go from
  matching (before) to not matching (after); (b) a grep or diff for the approved §1 clause's distinguishing
  text (e.g. "pre-authorized capabilities") must go from not matching (before) to matching (after). Both
  are genuinely failable — a same-file no-op edit fails (a), and forgetting to add the clause fails (b).
  The resolver suite stays as a *third*, independent check that no consumer's embedded copy drifted.

### 3.2 Wording reconciliation (skill, command, autonomy rules, session-plan)

- **Inputs:** the now-canonical core's §1 text; the four files' current authority-adjacent language
  (inventoried above).
- **Outputs:** each file's phrasing points at the same §1 rule where it currently states an equivalent or
  overlapping rule; no file gains a second, competing statement of the governing rule.
- **Guaranteed behavior:** `docs/autonomy-rules.md` triggers 8 and 9 remain textually intact (proposal's
  explicit retention requirement); the structural-class risk-aware review at trigger 9 is reworded, not
  replaced, to cite §1.
- **Failure behavior:** any diff that removes or narrows trigger 8 or 9, or that duplicates §1's text
  instead of citing it, fails this specification and must be reverted, not accepted as a variant.
- **Side effects:** none beyond the four files.
- **Public seam:** each file is read directly by its own consumers (Codex reads the skill; Claude reads
  the command; both read `docs/autonomy-rules.md` per its own "when to read" banner; `/session-plan`
  reads its own command file).
- **Fail-capable evidence (corrected — Finding 5):** `work-loop-v2-slice-1.test.sh`'s existing skill-text
  assertions cover CE-9 and orientation phrasing already in the skill — they do **not** exercise this new
  §1-citation behavior, so citing them alone is not evidence for this change. The genuinely failable check
  is a new, targeted one added for this tracer: a grep for the §1 citation text, failing before the edit
  and passing after, run against both the skill and the command. The existing suite is reported
  separately, as a regression check that nothing else moved — not as proof the new citation exists.

### 3.3 Capability envelope and subset (documentation-only for MVP)

- **Inputs:** proposal §3.2, §7 (baseline / pre-authorizable / operator-reserved capability classes),
  §14 items 4–5.
- **Placement decision (corrected — Claude's framing decision):** the earlier draft placed this content
  in the executable core's §4 state-file example. Any edit to the executable core is explicitly
  high-consequence under §15 regardless of size (Finding 3). To avoid bundling a documentation-only
  convention into that review track, this content is placed in the Codex skill's existing
  brief-preparation guidance (`.agents/skills/work-loop-v2/SKILL.md`, the same section T2 already touches)
  instead — the smallest sufficient, reversible option per proposal §5 Step 2. The core's five-field
  contract is read, not edited, by this item.
- **Outputs:** a defined MVP workspace baseline capability envelope (documentation), and a stated content
  shape for where a unit's selected subset appears in `## Brief` and where the effective runtime profile
  appears in `## Latest result` — inside the existing five-field state-file structure, not a new field.
- **Guaranteed behavior:** the connected-development profile (§11) is explicitly named as deferred, not
  silently omitted; no enforcement code is implied or required by this item alone.
- **The enforced/requested distinction (corrected — Finding 5).** The carrier's MVP enforcement list
  (proposal §11) is exact: it observes and enforces task/checkout/state-file/actor/turn identity,
  task-scoped write paths, no-bypass-mode, symmetric nested-actor refusal, one-hop/timeout/deadline
  limits, and terminal classification — confirmed live by this plan's own test runs. It does **not**
  enforce or observe per-invocation sandbox or network/tool restriction today (also confirmed). The
  recorded "effective runtime profile" must therefore only assert what the carrier actually observed for
  those enforced items; for sandbox/network it must state the **requested** or **selected** capability
  and explicitly disclose that the carrier cannot currently verify it was enforced — never label an
  unobserved property "effective." This mirrors the carrier's own honesty convention for nested-actor
  counts (`nested=unobserved` is a distinct state from `nested=0`, per `carry-turn.sh`).
- **Failure behavior:** a tracer that tries to *enforce* a capability subset mechanically is out of MVP
  scope per §14 item 4's explicit deferral, and is a scope violation, not this specification's job. A
  brief or evidence block that claims sandbox/network enforcement as "effective" without the carrier
  having observed it is a failure of this specification, not an acceptable approximation.
- **Side effects:** none — this is a documentation and state-file-content convention.
- **Public seam:** the Codex skill's brief-preparation section (not the executable core — see placement
  decision above) is the seam a Codex brief is written from; the state file's existing `## Brief` /
  `## Latest result` fields are what a Claude evidence block reads and writes.
- **Fail-capable evidence:** a before/after diff of the skill section showing the new convention added
  without a new state-file field being introduced (checked against the core's unedited five-field
  contract); a sample brief demonstrating the subset language; a sample evidence block that states a
  sandbox/network capability as "requested, not carrier-verified" rather than "effective" — a version of
  the check that would fail if the wording collapsed the two.

### 3.4 Nested-actor prevention — evidence record only

- **Inputs:** `carry-turn.test.sh`'s existing nested-actor assertions.
- **Outputs:** a recorded confirmation (state-file evidence, this plan's own inventory above) that
  process observation succeeds on the implementing host and the carrier's refusal is symmetric.
- **Guaranteed / failure behavior:** unchanged — no code changes proposed; this item's risk is already
  covered by the existing suite (285/0, including the "observed," not only "unobserved," path).
- **Fail-capable evidence:** the suite result itself; a suite that could only ever report "unobserved"
  would not prove this, and it does not — both paths are asserted and both pass.

### 3.5 Autonomy scenario paired live trials (proposal §14 items 8–9 only)

**Corrected scope (Finding 4):** this item covers §14 items 8–9 — the twelve constructed §12 scenarios —
only. It is a distinct evidence type from §14 item 10's real-task operational evidence, specified
separately at § 3.6 below; the two must not be reported as the same evidence.

- **Inputs:** proposal §12's twelve-scenario table; the `eval-v0-3-restart` shape as the only proven
  paired-trial mechanism (Layer A / Layer B distinction, PASS/PARTIAL/FAIL verdict, thread-id evidence).
- **Outputs:** one paired live trial per scenario, each producing a closed Work Loop task or an
  equivalent durable record, with a stated verdict.
- **Guaranteed behavior:** none of the twelve trials claims completion without load-bearing verification;
  a PARTIAL or FAIL result is recorded as such, not rounded up (matching `eval-v0-3-restart`'s own
  discipline).
- **Failure behavior:** where a trial cannot be run safely (would require an unauthorized capability, or
  would touch workspace `CLAUDE.md`), it is recorded as blocked with the reason, not skipped silently.
- **Side effects:** each trial is a **constructed** exercise of the carrier/dispatcher within their
  existing authorized profiles — no new capability is granted by running it, and it does not itself count
  toward §14 item 10's real-task requirement (§ 3.6).
- **Public seam:** the Work Loop task-state file per trial, same as every other unit in this task family.
- **Fail-capable evidence:** the trial's own thread IDs, run-sheet commit, and stated verdict — the same
  evidence shape `eval-v0-3-restart.md` already demonstrates.

### 3.6 Real-task operational evidence (proposal §14 item 10, added — Finding 4)

- **Inputs:** proposal §14 item 10 ("Use the attended carrier for 3–5 real Standard tasks across at least
  two capability shapes") and item 11 (the measures to record across both this and § 3.5).
- **Outputs:** 3–5 records of **organic** Standard-lane Work Loop tasks — ordinary work already scoped to
  run through the loop, not scenarios constructed to exercise it — spanning at least two distinct
  capability shapes (e.g., a read/local-edit task and a task touching a pre-authorized network or
  registry capability, once such a profile exists).
- **Guaranteed behavior:** each recorded task is one this task family would have run anyway; none is
  fabricated or relabeled from § 3.5's constructed trials.
- **Failure behavior:** if fewer than two genuinely distinct capability shapes are available inside the
  MVP capability envelope (§ 3.3) to draw real tasks from, that is recorded as a limitation blocking this
  item's exit condition, not papered over by counting the same shape twice.
- **Side effects:** none beyond the ordinary effects of the real work each task already does.
- **Public seam:** each task's own Work Loop state file, plus a short consolidated tally of the measures
  in item 11 (escalations, unauthorized continuations, capability-selection errors, false-positive
  blocks, false completions) across the 3–5 tasks — no new durable artifact, an addition to this task
  family's own records.
- **Fail-capable evidence:** the 3–5 tasks' own state-file closing records, cross-referenced against the
  item-11 measures; a tally showing zero of any measure is only credible alongside the individual task
  evidence it was drawn from, not asserted alone.

**Distinguishing semantic behavior from capability enforcement (brief requirement):** 3.1, 3.2, 3.5, and
3.6 are semantic Work Loop policy (what the rule says, whether an actor follows it, and whether real and
constructed use both confirm it). 3.3 stops at documentation and an explicit enforced/requested
distinction — it does not build enforcement. Mechanical capability enforcement (sandbox/network
restriction inside the carrier) is named in the Fixed Point as deferred and is **not** specified here
because the proposal does not schedule it for MVP; specifying it would silently expand scope.

**Distinguishing the attended carrier from the unattended dispatcher (brief requirement):** every
specification above targets the attended carrier's documentation and state-file conventions. The
dispatcher's separate `--unattended` profile is Keep-classified evidence for the Fixed Point's "current
release posture" section, not a target any tracer here modifies.

---

## 4. Execution Plan

Small vertical tracer bullets. Risky assumptions and real seams (the core's canonicity, the
capability-envelope greenfield, the workspace-`CLAUDE.md` boundary) are addressed early rather than
deferred.

### T1 — Revise the executable core (Fixed Point item 1, §14 items 1–2)

- **Behaviour:** the core states its own §1 governing autonomy rule and is no longer textually
  subordinate to proposal v0.4.
- **Starting evidence:** current §9-10 subordination line (confirmed present); no §1 section exists.
- **Intended change:** rewrite §9-10; add the §1 clause verbatim from the approved proposal.
- **Verification (corrected — Finding 5):** three independent checks, none of which the others can
  substitute for — (a) `grep -q "the Proposal wins"` on the core: matches before, must not match after;
  (b) a grep for the §1 clause's distinguishing text: must not match before, must match after; (c)
  `work-loop-v2-core-resolver.test.sh` stays green, proving no consumer's embedded copy drifted from the
  file.
- **Exit condition:** the operator approves this exact revised commit — this is the one step proposal
  §14 item 1 states explicitly requires identifiable operator approval before the core is canonical.
- **Scope boundary:** this file only. No consumer file is touched in the same tracer.
- **Review row (`qc-independence.md`):** high-consequence — the executable core is the shared authority
  document for the entire Work Loop; one risk-aware Codex review before implementation, per proposal
  §15's closing paragraph naming "the executable core" explicitly.

### T2 — Reconcile Codex skill and Claude command wording

- **Behaviour:** the skill and command cite the now-canonical §1 rule where they state or imply an
  equivalent principle; no duplicate statement of the rule is introduced.
- **Starting evidence:** skill line 429's existing hierarchy; command line 126's framing note (§ Repository
  Delta table).
- **Intended change:** small, citation-shaped edits only.
- **Verification (corrected — Finding 5):** the existing `work-loop-v2-slice-1.test.sh` assertions cover
  CE-9/orientation phrasing, not this citation — they are reported as a regression check only. The
  genuinely failable evidence is a new, targeted grep for the §1-citation text in both files: must not
  match before the edit, must match after.
- **Exit condition:** both files cite §1 where relevant; no semantic hierarchy content changed.
- **Scope boundary:** these two files only; depends on T1 landing first (ordering constraint 1).
- **Review row:** normal/consequential — one Codex review (not risk-aware; no hook, permission,
  cross-cutting-CLAUDE.md, new-command/skill, symlink, or shared-state-automation class is touched).

### T3 — Reconcile `docs/autonomy-rules.md` wording

- **Behaviour:** trigger 9's structural-class risk-aware review language cites §1 where it overlaps;
  triggers 8 and 9 remain textually intact otherwise.
- **Starting evidence:** full-file read (above); triggers 8–9 as currently worded.
- **Intended change:** citation-shaped wording only.
- **Verification:** re-read triggers 8–9 post-edit; confirm no clause was removed or narrowed (line-by-line
  diff, not a summary).
- **Exit condition:** wording cites §1; no trigger content lost.
- **Scope boundary:** this file only; depends on T1.
- **Review row (corrected — Finding 3):** high-consequence, regardless of edit size. §15's closing
  paragraph names `docs/autonomy-rules.md` explicitly as a separate high-consequence unit for *any*
  change, and notes its review "must reflect" its cross-cutting reach. One risk-aware Codex review before
  implementation, with the seven dimensions and the premise-verification precondition, same as T1.

### T4 — Confirm or adjust `session-plan.md` Step 5

- **Behaviour:** either a citation is added, or the plan review confirms no change is needed because the
  two concepts (session-level pause granularity vs. per-action authority) do not overlap enough to require
  one.
- **Starting evidence:** Step 5 text (above); no direct contradiction found.
- **Intended change:** none, pending plan-review confirmation — or a one-line cross-reference if confirmed
  needed.
- **Verification:** N/A if no change; a targeted re-read if a citation is added.
- **Exit condition:** plan reviewer's explicit disposition recorded (change / no change), not silently
  decided by the implementing unit.
- **Scope boundary:** this file only.
- **Review row:** small/mechanical if a citation is the only change; none needed if disposition is "no
  change."

### T5 — Capability envelope and subset, documentation only

- **Behaviour:** the MVP baseline capability envelope is defined; the state-file content shape for a
  unit's selected subset and effective runtime profile is stated, inside the existing five fields.
- **Starting evidence (corrected — Finding 1):** the concept is described in the approved proposal
  (§3.2, §7) but confirmed absent from all eight live implementation surfaces (§ Repository Delta); the
  executable core's current example state file shows five fields, no capability content.
- **Intended change (corrected placement — Finding 3, see § 3.3):** new documentation content placed in
  the Codex skill's brief-preparation guidance (`.agents/skills/work-loop-v2/SKILL.md`) only. The
  executable core is **not** edited by this tracer — that avoids triggering the core's high-consequence
  review track for a documentation-only convention, per §5 Step 2's "smallest sufficient" test.
- **Verification (corrected — Finding 5):** (a) the executable core's example state file is unchanged
  (diff against T1's committed version — proves this tracer touched no core content); (b) a sample brief
  demonstrates the subset language without adding a state-file heading; (c) a sample evidence block
  states a sandbox/network capability as "requested, not carrier-verified," never "effective" — a check
  that fails if the wording collapses the enforced/requested distinction (§ 3.3).
- **Exit condition:** the envelope and subset/profile content shape are documented; connected-development
  profile enforcement remains explicitly deferred, named as such.
- **Scope boundary:** the Codex skill only; no carrier, dispatcher, or executable-core edit.
- **Review row (corrected — Finding 3):** normal/consequential, one Codex review — confirmed clean of the
  high-consequence track because, with the placement decision above, this tracer touches only the skill
  (already T2's review tier), not the core.

### T6 — Nested-actor prevention evidence record

- **Behaviour:** proposal §14 item 7 is recorded as satisfied, with the evidence this plan already
  gathered (285/0, both observed and unobserved paths asserted).
- **Starting evidence:** this plan's own test run, § Repository Delta.
- **Intended change:** a state-file / task-record entry citing the existing suite result; no code change.
- **Verification:** re-run `carry-turn.test.sh` at the time of this tracer to confirm no regression since
  this plan's run.
- **Exit condition:** the item is marked satisfied with evidence, not re-implemented.
- **Scope boundary:** evidence recording only.
- **Review row:** small/mechanical — deterministic verification only, no review needed.

### T7 — Autonomy scenario suite (§14 items 8–9 only; corrected — Finding 4)

- **Behaviour:** each of the twelve proposal §12 scenarios gets one paired live **constructed** trial,
  using the `eval-v0-3-restart` mechanism.
- **Starting evidence:** zero trials of these twelve specific scenarios exist yet (CE-9's one executed
  trial is a different, Context-Engineering-specific scenario).
- **Intended change:** none to the repository's mechanism; this phase *uses* the existing instrument.
- **Verification:** each trial's own PASS/PARTIAL/FAIL verdict, thread IDs, and run-sheet commit.
- **Exit condition:** the phase ends when the scenario table is exercised, or when the operator accepts a
  bounded subset as sufficient evidence (a value/risk judgment for that later assessment, not this plan).
  This item alone does **not** satisfy §14 item 10 — see T8.
- **Scope boundary:** each trial is its own bounded unit; none may fold into T1–T6 or into T8's real-task
  count.
- **Review row:** each trial is itself a live Standard-lane exercise, individually assessed by Codex per
  the ordinary Work Loop cycle — not a single batch review of all twelve.
- **Note:** not scheduled as one small tracer — ordering constraint 3 explains why, and the proposal's own
  stated cost (~twelve paired live trials) is carried here rather than compressed.

### T8 — Real-task operational evidence (§14 items 10–11; added — Finding 4)

- **Behaviour:** 3–5 **organic** Standard-lane Work Loop tasks, spanning at least two distinct capability
  shapes, are run through the attended carrier as part of this task family's ordinary work, and the item
  11 measures (unnecessary escalations, unauthorized continuations, capability-selection errors,
  false-positive blocks, false completions) are tallied across them.
- **Starting evidence:** zero tasks tagged for this purpose exist yet; the capability shapes available
  depend on T5's documented MVP baseline envelope.
- **Intended change:** none to the repository's mechanism; this item observes real work already
  happening, it does not construct scenarios.
- **Verification:** each task's own Work Loop state-file closing record; a consolidated tally against the
  item-11 measures, cross-referenced to the individual task evidence it was drawn from.
- **Exit condition:** 3–5 real tasks across ≥2 capability shapes recorded, or an explicit limitation
  recorded if fewer than two genuinely distinct shapes exist inside the MVP envelope.
- **Scope boundary:** does not fold into T7's constructed-trial count; each task is independently a real
  unit of this task family's other work, not manufactured for this item.
- **Review row:** each task is reviewed at its own normal Work Loop review tier; this item adds only the
  consolidated tally, which is evidence recording, not itself a reviewable change.

### Deferred, not scheduled in this plan

- **Workspace `CLAUDE.md` reconciliation — corrected, not scheduled (Finding 2).** No tracer in this plan
  touches it; the bounded read in § Repository Delta found no proven required change. The retained,
  narrower fact is the boundary itself (a separate git repository from this checkout), carried only as a
  standing constraint that would apply *if* future evidence proves an edit is actually needed — not
  scheduled as a deferral with a trigger, because nothing here establishes that it is needed.
- **Descendant-containment closure, connected-development trial, unattended release, later
  pre-authorized-profile generalization, production/communication/credential profiles** (§14 items 6, 11,
  13–15) — explicitly out of MVP scope per the proposal itself; not scheduled by this plan (ordering
  constraint 4).

### §14 traceability table

Every proposal §14 item mapped exactly once — to a tracer, an evidence-gathering phase, an operator/review
gate, or an explicit deferral. Failure condition for this table: any item omitted, duplicated, silently
promoted into MVP, or silently dropped.

| §14 item | Disposition |
|---|---|
| 1 (revise core, obtain approval) | T1 |
| 2 (add §1 clause) | T1 (same tracer — both edits land in one reviewed commit) |
| 3 (reconcile skill/command/autonomy-rules/session-plan) | T2, T3, T4 |
| 4 (define baseline envelope; defer connected-development profile) | T5 |
| 5 (record subset in brief, profile in evidence) | T5 |
| 6 (carrier attended-first; defer sandbox/network enforcement) | Fixed Point (Keep — no tracer; already true, stated as a retained fact) |
| 7 (symmetric nested-actor prevention; verify on host) | T6 |
| 8 (scenarios as paired live trials) | T7 |
| 9 (run the scenario suite) | T7 |
| 10 (3–5 real Standard tasks, ≥2 capability shapes) | **T8 (corrected — Finding 4; was wrongly folded into T7's constructed trials, now its own item with its own real-task evidence)** |
| 11 (record escalations/errors/blocks/false-completion) | T7 and T8 together — each records its own measures; T8 tallies them |
| 12 (correct only demonstrated failures) | Contingent follow-up after T7 and T8's results — not a fixed tracer, per the proposal's own "correct only demonstrated failures" instruction (nothing to correct until both produce evidence) |
| 13 (generalize profiles only where trials show value) | Deferred — later release, out of MVP |
| 14 (unattended release after full-lifetime containment) | Deferred — out of MVP; blocked on the open descendant-containment limitation (Repository Delta, "Uncertain / requires proof" row) |
| 15 (production/communication/credential profiles later) | Deferred — out of MVP |

### Internal consistency check

Every tracer (T1–T8) carries all six required fields (Behaviour, Starting evidence, Intended change,
Verification, Exit condition, Scope boundary) plus its qc-independence review row — confirmed by the
table structure above; none is missing a field. Every proposed implementation surface named in a tracer
(executable core, skill, command, autonomy-rules, session-plan, state-file field contract, carrier test
suite, evaluation instrument) appears first in § Repository Delta's classification table and § Implementation
Specification's per-capability entry before it appears in a tracer — cross-checked by section: T1↔3.1,
T2↔3.2, T3↔3.2, T4↔(session-plan row, Repository Delta), T5↔3.3 (skill placement, corrected), T6↔3.4,
T7↔3.5 (scenario suite, corrected scope), T8↔3.6 (real-task evidence, added). No tracer introduces a
surface absent from both earlier sections. T5 and T2 both touch the Codex skill; T5 is sequenced after T2
in the same file for that reason, though neither tracer's own scope depends on the other's content.

---

## Plan-readiness statement

This artifact is draft until a fresh bounded implementation-plan review accepts it and the plan is frozen
(operator process decision, 2026-08-14). It grants no target-edit authority on its own. The Work Loop
state file for task `autonomy-authority-capability` remains the only runtime state; no progress tracker,
review ledger, risk document, test-strategy document, or parallel handoff was created by this unit.
