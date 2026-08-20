---
task: house-view-workflow-repair
status: active
turn: codex
---

## Objective and scope

Implement the operator-approved House View workflow repair in
`plans/house-view-workflow-repair-plan-2026-08-20.md`: preserve the proven fail-closed authority
controls, repair the review path only where the historical feasibility test supports it, and run at
most one bounded successor pilot. The authorization follows the plan's recommended sequence: Moves
0–2 first; Moves 3–4 proceed only if Move 2 passes. Move 0 is complete through the closed
`canonical-rw-l4-integrated-pilot` task.

This task is bound to the current checkout. Excluded throughout: reviving the rejected
precision-components proposal, generic deployment or synchronization, a second consumer or pilot,
new review/governance machinery, push, merge, and deployment.

## Lane and unit

Standard. Discovery mode. Unit 2 — blind historical first-challenge feasibility.

Named reason for the loop: the approved repair has a hard feasibility decision after Moves 1–2,
will span several independently assessed units only if it passes, and must stop rather than drift
into the additional machinery the operator rejected.

## Brief

Unit 1 fixed the known final-thesis validator defect. Move 2 now asks the smallest load-bearing
question before any workflow implementation: can one fresh reviewer find the material defects in
the original proposal using complete inputs and a tighter rubric, while keeping the founder-facing
result concise? This unit produces that blind first challenge only; Codex scores it afterward against
the withheld historical outcome.

Governing authority:

- `plans/house-view-workflow-repair-plan-2026-08-20.md`, approved by the operator on 2026-08-20,
  specifically Move 2 and its 16-hour stop condition.
- The historical consumer is read-only:
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence-l1-trial`.
- The original proposal snapshot is commit `c4e432c`, path
  `analysis/judgment/precision-components/precision-components-unit-judgment-brief-proposed.md`.

Required outcome: acting as the one fresh-context reviewer, independently challenge that original
proposal and return one founder-facing required-change summary of at most 1,500 words. Do not score
your own result against later reviews; that answer key is deliberately withheld for Codex assessment.

Freshness boundary — apply before reading the proposal:

- Do not read any `precision-components-unit-judgment-brief-review*.md` file, any later proposal
  revision, the rejected current proposal, either repair audit/report, the closed L4 task record, or
  commits after `c4e432c` that changed the proposal or its reviews.
- Do not invoke another AI or subagent. This fresh Claude session is the reviewer.
- You may use a temporary file outside both repositories to materialize `git show` output, but remove
  it before handback. Write no review artifact in the consumer.

Give the review these complete inputs, keeping evidence and context visibly separate:

**Proposal:** the file at `c4e432c` named above, read from Git rather than from the current checkout.

**Evidence bundle:**

- all six `analysis/cluster-memos/precision-components/*-memo-refined.md` files;
- all six `analysis/claim-permission/precision-components/*-permission-table.md` files;
- `analysis/gate-clearance/precision-components/precision-components-gate-clearance.md`;
- `analysis/gap-assessment/precision-components/precision-components-gap-assessment.md`;
- `analysis/country-parity/precision-components/precision-components-country-parity.md`;
- `analysis/source-conflicts/precision-components/precision-components-source-conflict-log.md`; and
- only where a cited claim needs traceability confirmation, its existing extract. The expected
  scarcity-register path is absent; do not invent a substitute.

**Axcíon context and decision bundle:**

- `reference/axcion-judgment-context.md`;
- `preparation/task-plans/precision-components-task-plan-v1.md`;
- `preparation/research-plans/precision-components-research-plan-v1.md`;
- `logs/decisions.md`; and
- `analysis/editorial-review/precision-components/precision-components-editorial-decisions-approved.md`.

Screen every applicable decision by id, including the numeric/B3 decisions and the CC, GH, FP, EW,
and TR decisions. Absence of a familiar id from one file is a reason to check the other named
decision source, not to infer that the decision does not exist. The minimum completeness check is
that `CC-1` is found and screened.

Apply the existing five challenge questions from
`reference/unit-judgment-brief.template.md` § `What the challenge asks`, plus this two-part rubric:

1. **Evidence and permission:** resolve each decisive heading, verdict clause, implication, and
   load-bearing citation against the actual claim, permission class, caveats, scope, independence,
   and missing limitations. Keep stated rationale, proxy evidence, searched absence, context, and
   direct evidence distinct. Tag an overreach `permission-breach`.
2. **Decision and logic:** test every decisive statement against the complete in-force decision set,
   internal consistency, the strongest countercase, scope/generalization, and whether any
   attribution borrows authority from an absent, future, or circular source. Tag a live conflict
   `decision-conflict: {id}`.

Return in `## Latest result`:

- overall verdict;
- `decisions_checked:` with every screened id;
- one concise required-change finding per material defect, each with a stable local id, applicable
  tags, the exact proposal locus, and the evidence or decision that makes it fail;
- observations only where no change is required;
- the exact word count of the founder-facing review; and
- confirmation that the freshness boundary held and all temporary material was removed.

Check these claims before beginning:

1. Commit `c4e432c` contains the named original proposal and can be read without changing the
   consumer checkout.
2. The complete input paths above exist except for the explicitly absent scarcity register.
3. Both decision sources contain applicable precision-components decisions and together expose
   `CC-1`.
4. No consumer write is necessary to complete the experiment.

Scope: read-only historical review in the consumer and a handback written only to this state file.
Do not modify the repair plan, canonical workflow, consumer, tests, commands, or approval controls.

Dominant deliverable: one blind first-challenge feasibility result against the original proposal.
Evidence required in this hop: the concise review, decision inventory, word count, freshness
confirmation, temporary-file cleanup, and the integration commit carrying the state handback.
Evidence explicitly deferred: scoring against the historical findings, the narrow revision check,
and every Move 3–4 implementation or pilot action.

Capability subset: baseline read/search/history access in both local repositories; write only this
state file; remove only temporary material created by this unit; and make the local integration
commit owned by Claude. Nothing from the empty pre-authorizable set and no operator-reserved
capability is selected. No network, consumer write, push, merge, deployment, credential access,
destructive shared-state operation, or nested AI invocation is needed.

Completion condition: the blind review is complete, no longer than 1,500 words, screens the full
decision surface including CC-1, changes nothing except this state file, and hands back at
`turn: codex` for independent scoring. Stop and hand back a false premise if the original snapshot
or complete input bundle cannot be established without crossing the freshness boundary.

## Latest result

Inspected (2026-08-20):

- Claim (1): HOLDS — `git cat-file -t c4e432c` returns `commit`;
  `git ls-tree -r --name-only c4e432c -- analysis/judgment/precision-components/` lists
  `precision-components-unit-judgment-brief-proposed.md`. Read via `git show c4e432c:<path>` into a
  temporary file outside both repositories; the consumer checkout was never written to.
- Claim (2): HOLDS — all six `*-memo-refined.md`, all six `*-permission-table.md`, and the
  gate-clearance, gap-assessment, country-parity, source-conflict, judgment-context, task-plan,
  research-plan, `logs/decisions.md` and editorial-decisions files are present. On the scarcity
  register the brief is right in substance and imprecise in wording: `analysis/scarcity-register/`
  does not exist, and `execution/scarcity-register/` exists holding only `.gitkeep` —
  `find . -iname '*scarcity*'` returns that directory and nothing else. The approved editorial
  decisions state the register is empty by design ("0 entries; the register does not exist for
  `precision-components`"), so there is nothing to substitute and none was invented.
- Claim (3): HOLDS — `logs/decisions.md` carries the numeric series (Decisions 1–36) and the B3
  series; the editorial-decisions file carries CC-1…CC-5, GH-1…GH-3, FP-1, FP-2, EW-1…EW-3, TR-1.
  `CC-1` was found and screened. Confirming the brief's warning: `grep 'CC-1' logs/decisions.md`
  returns nothing, so a single-file screen would have missed it entirely.
- Claim (4): HOLDS — the whole unit is read-only plus one write to this state file.

**Freshness boundary — held, with one disclosure Codex needs before scoring.** No
`*-review*.md` file, later revision, rejected proposal, repair audit or closed L4 record was opened,
and no subagent was invoked. The disclosure: this session's context already contained
`plans/house-view-workflow-repair-plan-2026-08-20.md`, supplied by the IDE at session start. Its
Move 2 text names the *shape* of the withheld answer key — that the historical run produced findings
numbered F1–F10, that F4 rested on an erroneous premise traceable to CC-1 being absent from the
decision inputs, and that F9 was introduced by a revision. No finding's content was available, and
the review below was built only from the evidence and decision files. Codex should treat the run as
blind on content and primed on structure, and discount the CC-1 hit accordingly — the brief itself
also instructed that CC-1 be screened.

---

**BEGIN FOUNDER-FACING REVIEW**

**Independent challenge — precision-components Unit Judgment Brief (proposed, `c4e432c`)**

**Verdict: REQUIRES REVISION.** The evidence base is handled honestly in most places, and the
verdict's direction is the one the operator already accepted. But ten decisive statements overreach
what their claims permit or contradict a standing decision. Six of those carry mechanical force and
cannot be disposed of by approval.

`decisions_checked:` CC-1, CC-2, CC-3, CC-4, CC-5, GH-1, GH-2, GH-3, FP-1, FP-2, EW-1, EW-2, EW-3,
TR-1; numeric Decisions 10–33 screened, with 13, 14, 19, 20 and 21 load-bearing; B3-13, B3-14, B3-18
and B3-20 screened and found to govern the `custom-dev-data-ai` unit, not this one.

**Required changes**

**R1 — `permission-breach` — Thesis 1 heading and first sentence.** "Every visible buyer is a
strategic, not a sponsor", and "Four in-boundary Finnish transactions … all carry strategic-synergy
or capability-adjacency rationales". [Q7-C04] says three are strategic/industrial and the fourth
(Tenuro/Uudenmaan Ohutlevy) is a self-described compounder whose "qualifying-PE-fund status is not
evidenced" — PE classification `NO-EVIDENCE`, "a nontraditional ownership route". [Q5-C08] agrees.
The proposal converts an unclassified buyer into a strategic. **Change:** three strategic/industrial
acquirers plus one unclassified compounder; do not fold the fourth into either class.

**R2 — `permission-breach` — Thesis 1 heading.** "Consolidation here is real and currently
trade-owned" generalizes the named record to the subsector. [Q7-C05]'s downstream note is explicit:
the report may say strategics dominate *the named record*, not *the subsector* — there is no deal
population denominator. **Change:** bound the claim to the named record.

**R3 — `decision-conflict: FP-1`, `decision-conflict: TR-1` — Thesis 1, closing sentences.** "A
sponsor entering today competes against buyers who can underwrite operating synergies it cannot, and
against sellers showing a preference for industrial continuity. That is a pricing-and-access problem,
not an absence of deal flow." This resolves Tension T1 toward the structural-deterrent narrative.
FP-1 commits to *neither* causal story and keeps T1 explicitly open; TR-1 forbids even a rhetorical
soft-tilt to Position B. Separately, "sellers" is plural drawn from one seller ([Q7-C08]).
**Change:** give the neutral descriptive read, mark T1 open, and let the scope asymmetry TR-1 names
(Nordic proxy vs Finland-direct) carry the lean instead of a supplied mechanism. Singularize the
seller observation. Note the disposition cannot rest on Thesis 1's countercase — that countercase
addresses *absence*, and the breach is about *causation*.

**R4 — `permission-breach` — Thesis 1, [Q3-C11].** Cited for "acquirers stating capacity and
technically-demanding-component expertise as the deal logic" of the four in-boundary transactions.
[Q3-C11] names ITA, HANZA and Caverion — only ITA Nordic belongs to that set. **Change:** cite ITA
alone for the in-boundary set, or say plainly that the pattern is drawn from a wider transaction set.

**R5 — `decision-conflict: CC-1` — Thesis 5, opening sentence.** "The civil/defence boundary rests on
a firm regulatory line" asserts at full strength. Cluster-01 claim-03 is graded SUPPORTED but tagged
`[C-CEILING-EXCEEDED — operator review]`, and CC-1 upheld the tier-C ceiling, requiring
*suggests / is consistent with / points to*. The "firm regulatory line vs judgment bundle" framing is
itself cluster-01 claim-04 at `PROXY-SUPPORTED`. **Surface, do not silently resolve:** Decision 19
describes the defence exclusion as "a firm regulatory line, Finnish H-grade sourced" and forbids
implying parity of rigor between the two exclusions. CC-1 is the claim-specific control on verb
strength and governs here; the asymmetry Decision 19 protects survives hedging both sides, because
the commodity line is capped harder at `ILLUSTRATIVE-ONLY`. The disposition must name CC-1 — Decision
19's wording is what makes this look settled and is not what settles it. **Change:** hedge to
`PROXY-SUPPORTED` verbs while keeping the asymmetry explicit.

**R6 — `decision-conflict: FP-2` — Thesis 4 heading and regulatory passage.** "Deal-execution risk is
bounded and datable", and "that change is dated, not open-ended". FP-2 requires "bounded under
current law, but a live 2027–2028 reform watch-item," explicitly NOT a green light, because a
green-light tone lets claim-04 silence claim-05. [Q11-C21] carries a standing **RE-VERIFY AT
PUBLICATION** flag and says Finland's implementing procedure is still being prepared. Q11 also
records that company-specific screening likelihood is `NO-EVIDENCE`, so the chapter "must not assert
a transaction-level probability or clearance timeline" — which "execution risk is bounded" does.
**Change:** state the statutory elements, keep the reform live as a watch-item, drop "not
open-ended", and attribute the bounded read to the absence of a statutory trigger rather than to an
observed clearance record.

**R7 — `permission-breach` — Thesis 4 citations.** "No value, revenue or fund-size threshold exists
[Q11-C01]" — [Q11-C01] states only the three statutory elements; the no-monetary-threshold finding
lives in the Q11-A02 coverage synthesis and disconfirming-evidence record. And "a Finnish replacement
**Act** still in preparation [Q11-C21]" upgrades what [Q11-C21] calls an implementing *procedure*;
"What would change the view" repeats it as "Enactment of the Finnish replacement Act". **Change:**
re-cite the threshold absence to the claim that carries it, and say implementing procedure.

**R8 — `decision-conflict: EW-2`, `decision-conflict: GH-3` — Thesis 4, "the binding constraints are
exit horizon and price discovery" and "Realisation is the heavier constraint."** EW-2 holds strict
orthogonality between the market/exit and regulatory registers — ranked by neither, with any
integrated weighting deferred and attributed rather than asserted. GH-3 scope-bounds the exit read to
a short hedged note that must state explicitly that exit was not a separately-researched question and
cross-reference that the visible buyer pool means the natural exit is the same strategics. The
proposal asserts the ranking and states neither. **Change:** drop or attribute the ranking; add
GH-3's two required elements.

**R9 — `permission-breach` — Thesis 3.** "The family-ownership premise that shaped selection also
fails" rests on two named cases ([Q4-C15], [Q4-C19]). CC-4's standing rule is that a 2-instance
illustrative cap blocks any general-pattern reading regardless of label. The thesis's own limitation
line does not cure the main clause, and the brief contradicts itself: "What would change the view"
asks for a second and third case before this becomes a pattern. **Change:** state both transitions at
their own strength and drop the general-failure framing.

**R10 — `permission-breach` — Thesis 1, [Q7-C01].** The proposal carries "all-sector and not
disaggregable" but drops the claim's other qualifier, "skewed by a few large investments". That
qualifier is load-bearing: the source-conflict log's `RESOLVED-GRANULARITY` finding turns on record
capital going into fewer, larger deals while PE-specific H1 deal count fell 3% YoY. **Change:** carry
the skew qualifier.

**Observations — no change required**

- The verdict's disconfirmation disclosure — every SUPPORTED claim graded without a disconfirmation
  search, each therefore one strength tier lower — is carried prominently and correctly.
- F3's "unverified, not absent" prohibition is honoured in Thesis 1's countercase and in the verdict's
  handling of [Q7-C05]. Decision 20's Selective/Avoid direction and Decision 13's PE lens are intact.
- GH-1 and GH-2 are honoured in Thesis 5: differentiation markers are presented as analyst-applied
  criteria, and the two Finnish instances are explicitly "two attested cases, not a population
  finding".
- Thesis 2 handles [Q6-C17] accurately (three managers, not five; Sweden and Norway only) and respects
  [Q6-C13]'s no-inference rule on control. "Two of seven cases" tracks the 7-holdings inventory rather
  than a case set — harmless, but the denominator label could match the source.
- No scarcity citation appears, which is correct: the register is empty by approved decision.

**END FOUNDER-FACING REVIEW**

---

Founder-facing review word count: **1,188 words**, against the 1,500-word bound. Measured, not
estimated: `awk '/^\*\*BEGIN FOUNDER-FACING REVIEW\*\*$/{f=1;next} /^\*\*END FOUNDER-FACING
REVIEW\*\*$/{f=0} f' logs/work-loop/house-view-workflow-repair.md | wc -w` → `1188`.

Temporary material: `scratchpad/u2/proposal-c4e432c.md` was created outside both repositories and
removed before handback; `scratchpad/u2/` no longer exists. No file in the consumer checkout was
created, modified or deleted — `git status` there reports the same state as before this unit.

## Blocker

None.

## Next action

Codex: score this blind first challenge against the withheld historical F1–F10 outcome — whether the
first challenge caught the historical defect classes, whether the erroneous F4 premise was avoided,
and whether 1,188 words clears the 1,500-word founder-facing bound. Weigh the structural-priming
disclosure above when judging the CC-1 hit. Then decide whether Move 2 passes, needs the narrow
revision check, or fails and stops the repair.
