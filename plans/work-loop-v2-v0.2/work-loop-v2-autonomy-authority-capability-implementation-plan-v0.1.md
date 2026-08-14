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
- `git grep -ln "capability envelope\|capability subset\|capability profile\|runtime profile"` across
  `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`, the executable core, and
  `plans/**`, `docs/**` — **zero hits**. The capability-envelope/subset concept proposal §3.2, §7, §11
  describe does not exist anywhere in tracked sources today.
- `git -C .. rev-parse --show-toplevel` from this checkout resolves to `/Users/patrik.lindeberg/Claude
  Code/Axcion AI Repo`, a **separate git repository** (`origin` = `axcioncapital/workspace-root.git`)
  from `ai-resources`. Workspace-root `CLAUDE.md` is tracked there, not in this repository or worktree.

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
| Capability envelope / subset concept | none — greenfield | **Add** | Confirmed absent by the zero-hit search above. This is genuinely new documentation content (not code): a definition of the workspace baseline, where a plan-level envelope would be recorded, and where a unit selects a subset — inside existing artifacts, per proposal §3.2, §7, §11. |
| Workspace `CLAUDE.md` | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` | **Out of this repository's bound — surfaced, not silently absorbed** | Tracked in the separate `workspace-root` git repository, not in `ai-resources` or this worktree. This Work Loop task's state file, its task-ownership helper (`work-loop-owner.sh --depth repo`), and this checkout's git identity are all scoped to `ai-resources`. A tracer that edits workspace `CLAUDE.md` cannot be executed, committed, or owned from this checkout or this task's state file; it requires its own task (or Direct Work) opened inside the `workspace-root` checkout, under that repository's own git identity and review. Proposal §15's closing paragraph already names workspace `CLAUDE.md` as cross-cutting and separately gated — this plan adds the concrete finding that it is also a **different repository**, which the proposal did not state. |

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
2. **A tracer touching workspace `CLAUDE.md` cannot run inside this task.** It is a hard boundary, not a
   scheduling preference (see table row above). This plan schedules it as a named, deferred, separately
   opened unit — never silently folded into a tracer scoped to this repository.
2a. Corollary risk: because that separate unit is outside this Work Loop task's state file, nothing in
    *this* task can mechanically verify it lands. The Execution Plan records it as an explicit deferral
    with a named trigger, not as a step this task will silently skip.
3. **The MVP evidence-gathering phase (§14 items 8–12) is not one small tracer.** Proposal §12 states the
   cost directly: exercising the full twelve-scenario table costs roughly twelve paired live trials until
   a runner exists. Treating it as a single bullet would misrepresent its size; this plan schedules it as
   its own phase with its own per-scenario units, opened only after the MVP mechanical tracers close.
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
- **Fail-capable evidence:** a diff showing only the §9-10 rewrite and the new §1 section; the resolver
  test suite still green after the edit (byte-identity check would fail if a consumer's embedded copy
  drifts from the file).

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
- **Fail-capable evidence:** a diff per file; `work-loop-v2-slice-1.test.sh`'s skill-text assertions (the
  suite already greps live skill text for specific phrases) still green, proving no accidental removal of
  asserted language.

### 3.3 Capability envelope and subset (documentation-only for MVP)

- **Inputs:** proposal §3.2, §7 (baseline / pre-authorizable / operator-reserved capability classes),
  §14 items 4–5.
- **Outputs:** a defined MVP workspace baseline capability envelope (documentation), and a stated content
  shape for where a unit's selected subset appears in `## Brief` and where the effective runtime profile
  appears in `## Latest result` — inside the existing five-field state-file structure, not a new field.
- **Guaranteed behavior:** the connected-development profile (§11) is explicitly named as deferred, not
  silently omitted; no enforcement code is implied or required by this item alone.
- **Failure behavior:** a tracer that tries to *enforce* a capability subset mechanically is out of MVP
  scope per §14 item 4's explicit deferral, and is a scope violation, not this specification's job.
- **Side effects:** none — this is a documentation and state-file-content convention.
- **Public seam:** the state-file template/example in the executable core (§4) is the seam a Codex brief
  and a Claude evidence block both already read.
- **Fail-capable evidence:** the executable core's example state file (§4) still shows exactly five
  fields after the addition; a sample brief demonstrates the subset language without adding a heading.

### 3.4 Nested-actor prevention — evidence record only

- **Inputs:** `carry-turn.test.sh`'s existing nested-actor assertions.
- **Outputs:** a recorded confirmation (state-file evidence, this plan's own inventory above) that
  process observation succeeds on the implementing host and the carrier's refusal is symmetric.
- **Guaranteed / failure behavior:** unchanged — no code changes proposed; this item's risk is already
  covered by the existing suite (285/0, including the "observed," not only "unobserved," path).
- **Fail-capable evidence:** the suite result itself; a suite that could only ever report "unobserved"
  would not prove this, and it does not — both paths are asserted and both pass.

### 3.5 Autonomy scenario paired live trials

- **Inputs:** proposal §12's twelve-scenario table; the `eval-v0-3-restart` shape as the only proven
  paired-trial mechanism (Layer A / Layer B distinction, PASS/PARTIAL/FAIL verdict, thread-id evidence).
- **Outputs:** one paired live trial per scenario, each producing a closed Work Loop task or an
  equivalent durable record, with a stated verdict.
- **Guaranteed behavior:** none of the twelve trials claims completion without load-bearing verification;
  a PARTIAL or FAIL result is recorded as such, not rounded up (matching `eval-v0-3-restart`'s own
  discipline).
- **Failure behavior:** where a trial cannot be run safely (would require an unauthorized capability, or
  would touch workspace `CLAUDE.md`), it is recorded as blocked with the reason, not skipped silently.
- **Side effects:** each trial is itself a real Standard-lane exercise of the carrier/dispatcher within
  their existing authorized profiles — no new capability is granted by running it.
- **Public seam:** the Work Loop task-state file per trial, same as every other unit in this task family.
- **Fail-capable evidence:** the trial's own thread IDs, run-sheet commit, and stated verdict — the same
  evidence shape `eval-v0-3-restart.md` already demonstrates.

**Distinguishing semantic behavior from capability enforcement (brief requirement):** 3.1–3.2 and 3.5 are
semantic Work Loop policy (what the rule says, whether an actor follows it). 3.3 stops at documentation —
it explicitly does not build enforcement. Mechanical capability enforcement (sandbox/network restriction
inside the carrier) is named in the Fixed Point as deferred and is **not** specified here because the
proposal does not schedule it for MVP; specifying it would silently expand scope.

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
- **Verification:** `work-loop-v2-core-resolver.test.sh` stays green (byte-identity check unaffected,
  since both consumers still resolve the same, now-updated, file); a human/Codex diff read confirms only
  the authority line and the new section changed.
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
- **Verification:** `work-loop-v2-slice-1.test.sh` stays green (it already asserts specific skill-text
  phrases; a careless edit that removes asserted language fails immediately).
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
- **Review row:** the plan flags this for the reviewer's own call (Repository Delta table) — propose
  normal/consequential given the change is wording-only and the file is not itself in the structural-class
  list, but confirm at plan review rather than resolving unilaterally here.

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
- **Starting evidence:** confirmed absence (zero-hit search, § Repository Delta); executable core's
  current example state file (five fields, no capability content).
- **Intended change:** new documentation content — likely inside the executable core (where the state
  file's field table and example already live) or the Codex skill's brief-preparation guidance; exact
  placement is an implementing-unit decision inside this specification's bounds, not a new artifact.
- **Verification:** the executable core's example state file still shows exactly five top-level fields
  after the change; no second approval artifact is created (both are explicit fail conditions in the
  proposal and in § 3.3 above).
- **Exit condition:** the envelope and subset/profile content shape are documented; connected-development
  profile enforcement remains explicitly deferred, named as such.
- **Scope boundary:** documentation only; no carrier or dispatcher code.
- **Review row:** normal/consequential — touches the canonical core's own field contract (post-T1), one
  Codex review.

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

### T7 — Autonomy scenario evidence-gathering phase (§14 items 8–12)

- **Behaviour:** each of the twelve proposal §12 scenarios gets one paired live trial, using the
  `eval-v0-3-restart` mechanism.
- **Starting evidence:** zero trials of these twelve specific scenarios exist yet (CE-9's one executed
  trial is a different, Context-Engineering-specific scenario).
- **Intended change:** none to the repository's mechanism; this phase *uses* the existing instrument.
- **Verification:** each trial's own PASS/PARTIAL/FAIL verdict, thread IDs, and run-sheet commit.
- **Exit condition:** the phase ends when the scenario table is exercised, or when the operator accepts a
  bounded subset as sufficient evidence (a value/risk judgment for that later assessment, not this plan).
- **Scope boundary:** each trial is its own bounded unit; none may fold into T1–T6.
- **Review row:** each trial is itself a live Standard-lane exercise, individually assessed by Codex per
  the ordinary Work Loop cycle — not a single batch review of all twelve.
- **Note:** not scheduled as one small tracer — ordering constraint 3 explains why, and the proposal's own
  stated cost (~twelve paired live trials) is carried here rather than compressed.

### Deferred, not scheduled in this plan

- **Workspace `CLAUDE.md` reconciliation** — genuinely required by proposal §14 item 3 and §15's closing
  paragraph, but structurally outside this task's checkout and state file (ordering constraint 2). Named
  here as an explicit deferral with its trigger: open as a separate task inside the `workspace-root`
  checkout once T1–T4 have landed and the reconciled §1 text is stable enough to cite there.
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
| 10 (3–5 real Standard tasks, ≥2 capability shapes) | T7 (folded into the same evidence-gathering phase; each trial is itself a real Standard task) |
| 11 (record escalations/errors/blocks/false-completion) | T7 |
| 12 (correct only demonstrated failures) | Contingent follow-up after T7's results — not a fixed tracer, per the proposal's own "correct only demonstrated failures" instruction (nothing to correct until T7 produces evidence) |
| 13 (generalize profiles only where trials show value) | Deferred — later release, out of MVP |
| 14 (unattended release after full-lifetime containment) | Deferred — out of MVP; blocked on the open descendant-containment limitation (Repository Delta, "Uncertain / requires proof" row) |
| 15 (production/communication/credential profiles later) | Deferred — out of MVP |

### Internal consistency check

Every tracer (T1–T7) carries all six required fields (Behaviour, Starting evidence, Intended change,
Verification, Exit condition, Scope boundary) plus its qc-independence review row — confirmed by the
table structure above; none is missing a field. Every proposed implementation surface named in a tracer
(executable core, skill, command, autonomy-rules, session-plan, state-file field contract, carrier test
suite, evaluation instrument) appears first in § Repository Delta's classification table and § Implementation
Specification's per-capability entry before it appears in a tracer — cross-checked by section: T1↔3.1,
T2↔3.2, T3↔3.2, T4↔(session-plan row, Repository Delta), T5↔3.3, T6↔3.4, T7↔3.5. No tracer introduces a
surface absent from both earlier sections.

---

## Plan-readiness statement

This artifact is draft until a fresh bounded implementation-plan review accepts it and the plan is frozen
(operator process decision, 2026-08-14). It grants no target-edit authority on its own. The Work Loop
state file for task `autonomy-authority-capability` remains the only runtime state; no progress tracker,
review ledger, risk document, test-strategy document, or parallel handoff was created by this unit.
