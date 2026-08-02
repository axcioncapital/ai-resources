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

The brief's five original claims were checked by inspection in the prior round and all held; the record
is in Git at `1238ef1`. This round is the one bounded correction under core §3, so its evidence is the
reproduction of the frozen findings, below.

**Operator scope decision after external review:** supersede the narrow final-fix boundary and reframe
the remaining work as one consolidated revision of this still-unapproved plan. This is an explicit
operator-owned scope change, not a finding silently entering a closure check.

## Latest material result

**Correction round (2026-08-02). All six frozen findings reproduced by inspection, then corrected.**
Two reproduced with a correction to the finding's own stated reasoning; both are named below rather than
absorbed silently.

**Reproduction record.**

- **F-1 · carriage bootstrap** — REPRODUCES. Read the plan at S2: carriage (a) was *"the skill
  referencing the specification by path"*, (b) *"carrying a compressed behavioural checklist"*, while the
  same session asserted *"Neither carries any CE behaviour"* and §4.4 required a Phase 1 exit that is *"a
  carriage with no CE content"*. Direct contradiction. Searched S1's `Repository output` for the carriage
  files: absent — no session authored them. `grep -c 'CE-'` proves identifier absence only, as stated.
- **F-2 · shadow slice** — REPRODUCES. S3b specified *"small, reversible"* and *"committed as ordinary
  Direct Work"*; core §2 (`:40-42`) gives such work *"no state file, no brief, no ceremony"*.
- **F-3 · O-3 reading B** — REPRODUCES, **with one stated premise of the finding falsified.** The
  finding says S8a would exclude v1 *"merely because it has no discoverable Codex skill or
  `logs/work-loop/`"*. **v1 does have a Codex skill** — `ls .agents/skills/` returns `work-loop`
  (`SKILL.md`, 9302 bytes, dated Jul 28). So the first half of that reason is false. The finding's
  substance holds by the *second* half: the test's conjunction requires `logs/work-loop/`, v1 uses
  `logs/loop/` (`ls -d logs/loop` succeeds), so v1 was excluded on a directory-naming difference; and
  S8b's outputs named only the three v2 files, leaving reading B with no route. Also confirmed the
  finding's core premise by inspection: `work-loop.md:41` — *"compose the brief yourself in the
  contract's `BRIEF` shape"* — v1 authors a plan-dependent brief.
- **F-4 · actor map** — REPRODUCES exactly. Counted `**Yes**` cells in §7.0: **10**, against the
  document's claimed *"nine of the fourteen"*. S8b assigned the operator to the pre-run only while its
  own evidence required a post-edit fresh-thread run. Five observer cells named greps, commands or
  questions rather than a party (S1, S8a, S9, S10, and S12's partial).
- **F-5 · CE subcase coverage** — REPRODUCES, **and the finding's example list was incomplete.** Checked
  each promised subcase against the specification's own case labels. Confirmed uncovered: CE-6 A, CE-4 C,
  CE-12 A (the three named). **Four more found by the same check:** CE-4 A and CE-4 B (S4 seeded only the
  editorial/material edit pair, which is case D); CE-11 A (only case B was seeded); and **CE-10 B was
  mislabelled** — the plan called *"a separate alignment stage introduced"* case B, but spec `:705`
  defines case B as *silent deviation from the approved plan*; the gate check is CE-10's evidence clause.
  All seven corrected, since stopping at the three named examples would have left the same defect.
- **F-6 · no-ferry table** — REPRODUCES. Read `work-loop-v2.md:32-38` in full: it implements identity
  (`task:`), turn (`turn:`) and readable frontmatter. **No staleness check exists**, though core §6 rule 2
  (`:269`) names *"stale"* as a separate condition. And `:32` reads *"If more than one qualifies, list
  them and ask which. Never guess."* — so bare `/work-loop-v2` auto-resolves only at exactly one open
  task.

Result: **all six corrected in place** in
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`.
1121 → 1279 lines.

**What each correction did.**

1. **S2 rebuilt around a mechanism-only difference.** The two carriages now differ by **indirection
   versus inline delivery** and nothing else — (a) holds one pointer line to a separate instruction file,
   (b) holds the probe in its own body. Neither mentions the specification or any CE identifier, so the
   Phase 2 baseline is genuinely CE-empty and S3's red run can fail. **Claude is named as the explicit
   author** of all three fixture files, before any thread runs; observer independence holds because
   authoring the instrument and judging Codex's briefs are different outputs. The negative control's
   limit is stated rather than papered over: neither carriage is installed, so S2 answers reachability
   and indirection only — installed discovery is answered by S8b's pre/post pair, and a carriage that
   wins S2 then fails S8b is a Phase 3 finding. The `grep -c 'CE-'` check is demoted to
   necessary-not-sufficient, with behavioural emptiness established by construction and **demonstrated by
   S3's red run failing**; a green red-run is diagnosed as a contaminated bootstrap first.
2. **S3b now takes a genuine Standard-lane unit** with the named admission reason core §2 requires,
   written into that unit's own state file. Low risk is explicitly not the admission test. Two separations
   made checkable: the real unit owns its own state file, scope, evidence and commits, and a commit
   carrying both the real unit's changes and the shadow record fails the session.
3. **O-3's reading now sets the population before any test runs.** The three-condition conjunction is
   replaced by **one** generation-neutral relevance condition — does plan-dependent briefing or
   continuation actually happen through this path. The Codex-skill and state-directory facts are demoted
   to *wiring-shape* facts that decide **how** a path is wired, never **whether** it is relevant. S8b gains
   an explicit conditional route: under reading B the allowed outputs extend to v1's command, Codex skill
   and doc — **or** the operator chooses retirement, S8b makes no v1 edit and stops, and adoption stays
   blocked under Phase 6 condition 2 until mission Step 8 executes it. §4.2's v1 row now records the
   verified facts (own Codex skill, own `logs/loop/`, authors its own brief at `work-loop.md:41`).
4. **Actor map corrected and re-counted.** Now **ten of fourteen**. S8b assigns the operator to **both**
   halves of the pre/post pair. Every observer cell names a party with the list they check against: S1 →
   the operator (re-runs the two greps); S8a → the operator (re-runs each row's command, confirms the O-3
   reading); S9 → Claude (staleness check on the review only); S10 → **Codex** (it owns the closure check);
   S12 → split, Claude for fixes and reproof, the operator for fresh-thread regression cases.
5. **Every promised subcase now has its own seeded condition.** S4 lists CE-4 A/B/C/D, CE-5, CE-6 A/B/C
   separately; S6 lists CE-10 A/B, CE-11 A/B, CE-12 A/B, CE-13 A/B/C, CE-14. S4's stop condition was
   corrected — it previously forbade the second plan document CE-6 B *requires*; it now permits it inside
   the seeded scenario and stops only if a second plan would appear current in the repository's real plan
   space. §7.1 gained two reporting rules (each regression case inherits its slice's complete subcase set;
   each case reports one line per subcase, and a subcase with no line fails the run), and §8 now states
   explicitly that its unit is the behaviour number while the proof's unit is the subcase.
6. **§4.5 split into three distinct rows** — task identity, turn ownership, and freshness, which is
   recorded as **not implemented at all**. The operator-action row states the conditional count: one
   trigger at exactly one open task, two when several are open. S11's evidence is now two counts kept
   apart — context actions (target zero beyond the objective) and trigger actions — with the number of
   `turn: claude` files at invocation recorded, so the count comes from observed state. A trigger count of
   two does not fail clause 3; concealing it does. §4.5 also names two things the seam does not provide,
   and forbids S8b from building either.

Evidence:

- **F-4, by count.** `**Yes**` cells in §7.0 = **10**; `ten of the fourteen sessions` = 1 hit;
  `nine of the fourteen` = **0** hits. **Fails if** the cell count and the stated count diverge again.
- **F-1, by absence and presence.** `compressed behavioural checklist with the specification` → **0**;
  `author — Claude` → **1**; `Negative control` → **1** (the control was not removed while fixing it).
  **Fails if** either contaminating description returns, or the author line disappears.
- **F-5, by enumeration.** `grep -oE '\*\*CE-(4|6|10|11|12) [A-D]\*\* ·'` returns exactly **13** seeded
  subcase lines: CE-4 A/B/C/D, CE-6 A/B/C, CE-10 A/B, CE-11 A/B, CE-12 A/B. **Fails if** any header
  promises a subcase with no matching seeded line.
- **F-3, by absence.** `it is relevant if all three hold` → **0**; `Under reading B additionally` → **1**.
  **Fails if** the conjunction returns, or reading B loses its output route again.
- **F-2, by absence.** `committed as ordinary Direct Work, outside this plan` → **0**;
  `genuine Standard-lane unit` → **1**.
- **F-6, by presence.** The freshness row reading `**It is not.**` → **1**. **Fails if** the table again
  presents `turn:` as a freshness check.
- **Regressions checked, not assumed.** CE-1…CE-17 present with **no gaps** (per-number loop, zero
  missing); §8 map still **17** rows; §9 boundary audit still **17** rows; sessions **14** and
  `^- \*Actors:` lines **14**, matching; the escape-hatch grep
  `stated limitation\|with stated limitations` still returns exactly **1**, and it is the prohibition.
  **Fails if** any count moves.
- **Committed paths.** Exactly two: the plan and this state file. Pre-existing unrelated working-tree
  changes (`logs/friction-log.md`, `logs/session-notes.md`, `logs/runs/2026-08-02-S5-8ee.json`) were not
  staged. **Fails if** `git show --stat` lists a third path.

**One deferral, recorded and not done** (core §5 — noticed during F-3's inspection, outside the frozen
findings): `.agents/skills/wl2-probe/SKILL.md` is still on disk. Its own body reads *"Throwaway Step 2
transport probe. Delete me."*, and `step-2-transport-seam-conclusions.md:110` records the probe as
reverted. It is a leftover from the transport probe, not part of this plan. Not deleted here — deleting a
file is outside a plan-correction unit's scope, and it belongs to whoever owns the Step 2 cleanup.

## Unresolved blocker
None.

## Next action
Codex: the two-question closure check on the frozen findings **only** (core §3 *Correcting once*).

1. Are findings 1–6 resolved?
2. Did the correction introduce a material regression?

Two things to weigh while answering question 1, both disclosed rather than smoothed over:

- **Finding 3's stated reasoning was partly falsified** — v1 *does* have a Codex skill, so the exclusion
  ran through the state-directory condition, not the missing-skill one. The finding's substance held and
  was corrected; the mechanism recorded in the plan is the verified one, not the one the finding named.
- **Finding 5's examples were not exhaustive.** The same check found four more uncovered or mislabelled
  subcases (CE-4 A, CE-4 B, CE-11 A, and CE-10 B, which was mislabelled). All were corrected, on the
  ground that correcting only the three named examples would have left the finding's own defect in place.
  If Codex judges that widening exceeded the frozen scope, say so — it is a scope call, not a fact
  question.

Anything newly noticed is a **deferral**, not a second correction round. The plan remains a **draft** and
is not authorisation to implement; Phase 0's two operator approvals are still outstanding.
