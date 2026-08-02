---
task: context-engineering-implementation-plan
turn: codex
---

## Objective and approved scope
Produce one self-contained, execution-ready **draft implementation plan** for
`plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`. The plan must guide the later
implementation across fresh sessions and make progression depend on observable evidence.

Write the plan to
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.
It remains non-governing until the operator explicitly approves it. This unit plans only: do not
implement Context Engineering, change the specification's approval status, or edit any Work Loop
runtime artifact.

## Lane and unit
Standard. Unit 1 — inspect the live implementation surface and draft the implementation plan.

Named reason for the loop: the plan must survive several later sessions, the implementation scope
needs bounding before work starts, and Codex must assess the result independently before it counts as
ready for operator approval.

## Brief
Why: the specification is behaviourally detailed but deliberately does not authorize or sequence its
implementation. The operator needs a durable plan that lets each later session take one bounded,
observable slice without reconstructing design history or prematurely wiring the live Work Loop.

Check against the repository before drafting:

1. The specification header still says `draft specification — awaiting operator approval` and `not
   requirements`; no later source has promoted it to governing implementation authority. Inspect the
   specification header and `logs/decisions.md`.
2. `logs/decisions.md` records that the earlier integration mandate was withdrawn because Claude alone
   could not produce CE-17's integrated two-model proof; the retry must first design the two-model
   session shape. Inspect that decision and the named continuity scratchpad.
3. The live v2 surface currently consists at least of the executable core, Claude command, Codex skill,
   and acceptance harness. Inspect each rather than treating the scratchpad's proposed three-file seam
   as settled architecture.
4. The specification defines CE-1 through CE-17, including the isolated-versus-integrated proof split,
   and forbids new runtime QC passes, gates, per-run records, a second state system, and a Wayfinder
   ticket network. Re-derive this from the specification.
5. The attached proposal snapshot is byte-identical to the canonical successful MVP proposal at
   `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`. Treat the canonical file as the reference
   authority for planning form; treat both Matt Pocock documents as non-governing principles, not as a
   lifecycle that must be copied wholesale.

Required outcome: one plan that a fresh Claude session can execute without relying on this conversation.
Use the successful MVP proposal's strengths: a concise situation, settled constraints, an observable
destination, evidence-gated phases, thin vertical slices, explicit exits, standing anti-scope rules,
and an exact next session. Fold the useful session-map detail into this same plan; do not create a
second playbook.

The plan must:

- state its authority and draft status, the implementation objective, boundaries, exclusions, and what
  would falsify success;
- identify the verified live implementation surface and distinguish observed facts from proposed
  implementation choices;
- sequence the riskiest unknown or seam first, then tracer-bullet slices that each produce one complete,
  observable result and fit a fresh implementation session;
- map every CE-1…CE-17 behaviour to a planned slice and a constructible failing case or proof, without
  turning the document into a sentence-by-sentence restatement of the specification;
- keep the isolated Context Engineering proof distinct from the integrated Work Loop proof, and place
  the integrated/adoption step only in a genuinely two-model operator-driven session after isolated
  proof and an explicit progression decision;
- cover every relevant Work Loop entrypoint before any adoption claim, while keeping transport mechanics
  outside Context Engineering's own implementation boundary;
- preserve the one-touch objective, semantic authority hierarchy, durable-source limits, one-artifact
  handoff, proportional discovery, fresh-session recovery, and Codex/Claude/operator ownership split;
- define per-phase/session inputs, one job, expected repository output, evidence capable of failing,
  exit condition, stop condition, and the exact next-session handoff;
- leave reversible technical details to implementation sessions unless live evidence makes one
  load-bearing, and identify any consequential or still-open choice for the operator instead of silently
  deciding it;
- include the planned candidate review, real trial, integrated proof, hardening-from-evidence, adoption
  decision, and stop point without adding a runtime context-QC pass or permanent planning machinery;
- name accepted limitations and deferred work with reopening triggers, and end with the first execution
  session—not with implementation performed in this unit.

Required evidence returned in this state file:

1. An inspection record for all five claims above, naming the paths and observations.
2. A CE coverage check derived from the unique CE identifiers in the specification and in the completed
   plan; report any difference. Numeric presence is only the first control—also cite the plan section
   where each behaviour is assigned a failing case or proof.
3. A boundary audit showing where the plan handles each explicit prohibition from specification §7 and
   CE-16. A prohibition mentioned only as something to build is a failure, not coverage.
4. A fresh-session executability check against the plan's first implementation session: identify its
   named inputs, one job, output, failing evidence, stop condition, and next handoff. If any depends on
   this chat, the plan is not ready.
5. The exact committed path list. It may contain only this state file, the three operator-source snapshots
   already placed in the context-engineering folder, and the new plan. Preserve and do not stage any
   unrelated pre-existing working-tree changes.

**Operator scope decision after external review:** supersede the narrow final-fix boundary and reframe
the remaining work as one consolidated revision of this still-unapproved plan. This is an explicit
operator-owned scope change, not a finding silently entering a closure check. The next Codex assessment
will therefore be one fresh full QC against the specification and original references, not the prior
frozen-findings closure check.

## Latest material result

Inspected (2026-08-02):
- Claim (1): HOLDS — read `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md:3`; found
  *"Stage: draft specification — awaiting operator approval · Status: not requirements"*, and the
  authority notice at `:5-8` *"Nothing here authorises implementation."* Searched `logs/decisions.md`
  for `context engineering|integration mandate|two-model`; the only CE entry is the 2026-08-02
  withdrawal, whose closing line reads *"Not decided here. Whether the CE spec's stage header flips."*
  No source promotes it.
- Claim (2): HOLDS — read `logs/decisions.md:90-126`. Records the withdrawal, the rationale
  (*"cannot be produced by Claude working alone… Codex runs in the ChatGPT desktop app and is
  operator-driven"*), and *"Consequence for the retry. A future attempt must be structured as a
  genuinely two-model session."* The named scratchpad `logs/scratchpads/2026-08-02-13-08-scratchpad.md`
  is cited there as holding the reverted design.
- Claim (3): HOLDS — inspected all four. `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`
  300 lines (read in full); `.claude/commands/work-loop-v2.md` 113 lines (read in full);
  `.agents/skills/work-loop-v2/SKILL.md` 116 lines (read in full);
  `logs/scripts/work-loop-v2-slice-1.test.sh` 673 lines. The three-file seam was re-derived against
  these, not assumed — and reading the command and skill in full is what produced F-11/§4.5.
- Claim (4): HOLDS, with one stated precision. `grep -o 'CE-[0-9]*' | sort -u -V` over the specification
  returns CE-1…CE-17, no gaps. The isolated-versus-integrated split is at `:533-548` (the two-proofs
  table). Four of the five named prohibitions appear verbatim in §7 (`:838-846`): separate context-QC
  pass, gates (`"a 'Gate' and a 'Compiler' as named runtime components"`, `:859`), per-run records
  (CE-16 failing case B, `:812-816`), second state system (`:846`). **"Wayfinder ticket network" is not
  a spec term** — searched the specification for `ticket` (case-insensitive): no match. It is covered in
  substance by §7's *"a new backlog, register, or log"* and CE-16 case A's *"a new document type"*. The
  claim's operative content holds; the plan's §9 audits the actual §7 list rather than the paraphrase.
- Claim (5): HOLDS — `md5` of `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` and of
  `plans/work-loop-v2-v0.2/context-engineering/work-loop-v2-mvp-proposal-v0.4-reference.md` both return
  `54674a8931c93d6d338e592f80136c7b`. Byte-identical.

Result: **one consolidated revision** of
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`,
applying items 1–9 of the superseding mandate. 807 → 1121 lines; 546 insertions, 232 deletions.

**Where each item landed.**

1. **Candidate bootstrap repaired.** S2 is now *the carriage probe trial* and answers **mechanism only**.
   Each carriage carries one probe that is not any of CE-1…CE-17 — *"end every brief with a section named
   `Carriage check`, listing, in the order you opened them, the repository files you opened"* — chosen
   behaviour-shaped rather than as an echoable string, so satisfying it requires acting and its content
   is checkable against reality. Three runs, one of which must fail: a **negative control** with no
   carriage, where the section appearing means the instrument is broken and the session failed; then
   each carriage. The probe is **stripped** from the survivor at exit. New §4.4 paragraph *"What the
   candidate contains when Phase 2 opens"*, the Phase 1 exit and the Phase 2 preamble now say one thing:
   the candidate at Phase 1 exit is *"a carriage with no CE content"*, so S3's red run genuinely fails
   because nothing in the candidate addresses Family 1. §5.2 gained *"a bootstrap that cannot fail"* as a
   named falsification criterion.
2. **Shadow slice added as S3b**, immediately after S3 — the earliest point at which a brief is usable
   (Family 1 + CE-15 present). Actors: operator drives Codex, Claude does the real work; each reports
   their own half and neither judges the other's. Failing evidence: three counts, each able to come back
   badly — questions Claude had to ask that the brief should have answered (target 0), operator actions
   beyond stating the objective and triggering (target 0), and Claude's verdict on sufficiency, *which is
   allowed to be no*; a record with no negative findings and no stated attempt to find any fails. Stop:
   if the brief is unusable, return to Phase 1's carriage question. Consequence: findings enter S4–S7 as
   **constraints on how the remaining families are written**, never as new behaviours, sessions or checks.
   §5.2 and §11 both state it is not the integrated proof and may never be reported as one.
3. **Adoption moved after hardening and final proof.** Phase 4 is now the integrated proof alone and
   hands to Phase 5, explicitly *"Not the adoption decision"*. Phase 5 (S12) hardens, re-proves what the
   fixes touched, runs the full grouped regression on the final candidate, and consolidates evidence.
   **New Phase 6** — assess, decide, stop — carries the adoption decision. §5.1 gained item 9 (*"the
   candidate carrying all of the above is the one that was last proved"*) and §5.2 gained *"a proof
   inherited by a changed candidate"*.
4. **Grouped regression added as §7.1** — five rich cases, R-1…R-5, explicitly *"not a new session, not a
   new stage, not a review"*. Runs in full inside S7 and again inside S12; affected-subset only after an
   intermediate correction, with skipped cases and reasons recorded (stated in S10 and S12).
5. **No-ferry seam owned in new §4.5**, a five-row table with live line references — where Codex writes,
   where Claude reads, how identity and freshness are checked, and what the operator actually does. S8b
   gained *"What it must reuse and must not build"*: no delivery file, queue, handoff document, second
   state system or turn mechanism; a diff adding one fails the session.
6. **Duplication reduced where the three surfaces overlapped.** §8's table lost its two restating columns
   (`Constructible failing case`, `Proved by`) and became a pure assignment map (`Built in`, `Regression
   case`, `Failing case stated in`); each Phase 2 session gained one `Constructed failing cases:` line
   that is now the single place its cases are stated. §1 gained a rule naming the single home for each
   kind of statement (failing case → §7; prohibition handling → §9; falsification → §5.2). §4.2's two
   consequence bullets merged into one paragraph. **Honest observation: the document still grew** — the
   dedup removed restated content, not lines, because §8 is one row per behaviour either way. See the
   deferral below.
7. **Retention bounded in new §7.5.** Survives: `trials/regression/` (the five cases and their fixtures,
   each keeping its `FIXTURE —` line), `trials/evidence-summary.md`, `trials/integrated-proof-record.md`
   — justified as the same kind of thing the repo already hosts (F-4's acceptance harness and fixtures).
   Deleted at S12: the carriage-trial record, slice-a…e evidence, shadow-slice record and entrypoint
   classification. `trials/candidate/` already goes at S8b. Recoverability is Git plus the closing
   record's evidence pointer. Stated as *"one deletion, at one named point"* — not a lifecycle, register
   or runtime log.
8. **v1 made an explicit operator decision.** O-3 was *"v1 retirement"*; it is now *"what does 'every
   relevant Work Loop entrypoint' mean?"* with a two-row reading table — **A** (v0.2 entry protocol only)
   and **B** (every live generation) — each with its consequence, including A's narrower claim being
   written into the adoption record rather than left implied. Evidence offered and explicitly not
   treated as decisive: spec §8's singular *"the Work Loop entry protocol"* leans A; §4.2's live
   plan-dependent v1 makes B substantive. *"Retirement is not assumed either way."* S8a now takes O-3's
   answer as an input and **stops if it is unanswered** rather than picking the shorter reading; its
   three-condition test is relabelled *technically relevant*, with its limit stated.
9. **Actors named** in new §7.0 — a 14-row table giving every session a lead and an observer, with the
   observer never the party being judged and no new review stage. S2's observer resolved to **Claude**
   (wrote none of the briefs; applies the probe check and verifies the named files exist). S5's Claude
   role resolved to **the ordinary Work Loop premise check** (command Step 2) run against the trial
   brief — the seeded claim returning `FALSE` is the confirming evidence. Operator load made visible:
   **nine of fourteen sessions need the operator to drive Codex.**

**Rejected suggestions confirmed not adopted:** no line-count target (§7.5 and §1 state none; the
document grew); no companion artifact (§1 *"no companion playbook and no companion summary"*; S12
*"No successor plan document is written"*); no extra QC gate (Phase 6 states its assessment is core §3
step 5, *"not an added review stage"*; §9's last row); no automatic v1 retirement (O-3 above); the
shadow slice does not replace the integrated proof (§5.2, §11); no new correction lifecycle (C-9
rewritten to name core §3's one round *followed by* the existing value-and-risk menu chosen once).

**Final phase order, and where adoption becomes available:**
Phase 0 authority (two approvals) → Phase 1 (S1 instrument, S2 carriage probe) → Phase 2 (S3 Slice A,
**S3b shadow**, S4 Slice B, S5 Slice C, S6 Slice D, S7 Slice E + first grouped regression) → Phase 3
(S8a classification, S8b seam edit, S9 review, S10 correction) → Phase 4 (S11 integrated proof) →
Phase 5 (S12 harden, affected reproof, full regression, evidence consolidation) → **Phase 6: final Codex
assessment, then the adoption decision, then stop.** Adoption becomes available **only in Phase 6**, and
only when all five conditions hold — integrated proof obtained; every path classified and every relevant
one wired; O-3 settled and the work done under the reading chosen; the seam proved behaviourally with
failing runs on record; and the shipped candidate is the proved candidate. *"Adopt with stated
limitations"* is stated as unavailable for all five.

**Grouped regression cases and CE coverage:** R-1 two-part objective (CE-1, CE-2, CE-3, CE-11, CE-15,
CE-17 clauses 1–2) · R-2 edited approved plan (CE-4, CE-5, CE-6) · R-3 blind fresh thread (CE-7, CE-8,
CE-9) · R-4 unsettled preference (CE-10, CE-12, CE-13, CE-14) · R-5 routine run (CE-16; CE-15
re-confirmed). CE-17 clause 3 is deliberately absent — it needs a two-model session, so its regression is
a re-run of S11 where hardening touched the seam.

**Evidence-retention end state:** `trials/` holds exactly `regression/`, `evidence-summary.md` and
`integrated-proof-record.md`.

Evidence:

- **CE coverage.** `comm -3` over unique `CE-n` identifiers in specification and plan returns only the
  bare token `CE-` on the plan side — from S2's literal `grep -c 'CE-' trials/candidate/SKILL.md` check,
  not a behaviour. A per-number loop over CE-1…CE-17 finds every one present. §8's table carries **17**
  rows, each naming the session where the behaviour is built, its regression case, and the section where
  its failing case is stated. **Fails if** any number is unassigned or a row cites a section that does
  not construct the case.
- **Boundary audit.** §9 carries **17** rows, one per §7/CE-16 prohibition, each naming active handling.
  Three rows were rewritten this round: the archive/lifecycle row now covers §7.5 (*"a single deletion at
  a named point, not a lifecycle"*); the transport row now cites §4.5 showing the path already exists so
  S8b reuses rather than builds; and a new final row covers *"a new correction lifecycle"* against C-9.
  **Fails if** a row names only something to build.
- **Escape hatch stayed closed.** `grep -n 'stated limitation\|with stated limitations'` returns exactly
  **one** hit, and it is the prohibition (`"deliberately not an option for conditions 1–5"`). Before this
  round the same grep returned two, both prohibitions; before the prior correction it returned four, of
  which three were permissions. **Fails if** the count rises or any hit reads as a permission.
- **Item landings, by grep:** `carriage probe|Carriage check` → 5; `S3b|shadow slice` → 7;
  `grouped regression` → 14; `§4.5|no-ferry` → 9; `§7.5|7.5 What survives` → 10; `O-3` and the reading
  labels → 20; `^- \*Actors:` → **14**, matching the 14 sessions found by
  `grep -o '^\*\*Session S[0-9a-b]*' | sort -u`. **Fails if** the Actors count and the session count
  diverge — that is a session with no named evidence producer.
- **Fresh-session executability, checked against S1.** Inputs: this plan's §4, §7.0, §7.1 and Phase 1;
  spec §3.5, §5.7, CE-9; re-verification of §4.1. One job: construct the seeded scenario. Output:
  `trials/ce-9-recovery-scenario.md` plus its durable sources. Failing evidence: two greps, one hit and
  one miss — and the fact appearing in the request means the session **failed**. Stop: no seedable fact →
  report CE-9 as possibly unmeasurable. Next: hand to the operator for S2. **Nothing depends on this
  chat**; §12 names the exact sections to read.
- **Counts, as observations only.** Lines 807 → **1121**. Sessions 13 → **14** (S3b added). Phases 6 →
  **7** (Phase 6 added). The growth is traceable: §4.5 (27) + §7.0 (28) + §7.1 (32) + §7.5 (31) + S3b
  (36) + Phase 6 (36) + O-3's expansion (20) = 210 lines of newly mandated content, plus 14 Actors lines,
  the per-session `Constructed failing cases:` lines, §5.1 item 9, two new §5.2 criteria, a new §10 rule,
  a new §11 row, and the C-9/S2/S12 rewrites.
- **Committed paths.** Exactly two: the plan and this state file. The three operator-source snapshots
  were committed in `ab28c66` and are unchanged this round. Pre-existing unrelated working-tree changes
  (`logs/friction-log.md`, `logs/session-notes.md`, `logs/runs/2026-08-02-S5-8ee.json`) were **not**
  staged. **Fails if** `git show --stat` on the new commit lists any third path.

**One deferral, recorded and not done.** Item 6 asked for reduced operating overhead, and the honest
result is partial: restatement was removed where the plan, coverage map and boundary audit overlapped,
but seven of the nine items add content, so the document grew 807 → 1121. Cutting further would have
meant cutting constraints, which item 6 forbids. Whether the plan is still inside its own §1 claim —
one named session executable from the state file, its plan section, and the specification sections it
names — is a fair question for the fresh QC. Reopening trigger: an implementation session reports that
reading the plan cost more than the orientation it saved.

## Unresolved blocker
None.

## Next action
Codex: run **one fresh full QC** of
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md` against
the specification, the successful MVP proposal at `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`,
both Matt Pocock references in the context-engineering folder, and live repository evidence — not the
frozen-findings closure check, per the operator's scope decision recorded above.

Four things are worth the QC's attention because this round changed them and they are where a defect
would hide:

1. **The carriage probe.** Does S2 now prove *mechanism* without asserting behavioural sufficiency, and
   is the negative control genuinely capable of invalidating the instrument rather than decorating it?
2. **The shadow slice.** Is S3b placed at the right point, and are its consequence and stop condition
   tight enough that its findings cannot become new behaviours, sessions or checks?
3. **The reordered tail.** Phase 4 → 5 → 6 with adoption last, the affected-reproof rule, and the
   grouped regression at two boundaries — does that actually prevent a proof being inherited by a
   changed candidate, or does a path remain where it can?
4. **§4.5 and §7.5.** Is the no-ferry seam described accurately against the live files, and is §7.5's
   single deletion genuinely not an archive lifecycle under CE-16?

The plan remains a **draft** and is not authorisation to implement. Two operator approvals are still
outstanding (Phase 0). The deferral above is recorded and not done.
