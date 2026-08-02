# Work Loop — Context Engineering

**Version:** v0.1 · **Stage:** specification foundation — awaiting Codex review · **Status:** not requirements

> **Authority notice.** This document specifies *behaviour*, not requirements to build. Nothing here
> authorises implementation. It becomes the specification when Codex's review closes and the drafting
> pass completes; it does not become a build instruction until the operator says so. Imperative wording
> in this file creates nothing — the same rule it applies to every other source.
>
> **One file, not two.** This document evolves from foundation to specification in place. A second
> document about the same subject is the staleness failure recorded at
> [`step-7-pilot-log.md` § FP-4](step-7-pilot-log.md).

**Session of record:** 2026-08-02. Drafted by Claude, from operator-settled decisions 1–14 taken the
same session. Codex guides and assesses.

---

## 0. Governance note — read before judging scope

This foundation is being written **outside** the `work-loop-v2-mvp` mission's Step 8, by operator
direction. Two facts a reviewer needs:

- The mission's Step 8 ends *"stop; do not keep designing it"*, and its v0.2 rework thread records
  scope and shape as **undecided and not designed inside this mission**
  ([`logs/missions/work-loop-v2-mvp.md`](../../logs/missions/work-loop-v2-mvp.md), threads 8 and 9).
- The mission's off-mission signals name *"producing more planning or specification documents instead
  of evidence"* as drift.

Both are surfaced rather than resolved silently. The operator opened this work knowingly. Recorded so a
later session does not read this document as evidence that the mission's boundaries failed.

---

## 1. The problem

**Nothing owns the step between an operator objective and an execution brief.** So either raw material
reaches Claude unfiltered and its errors get built, or the operator prepares it by hand every time.

Four observed instances, all from this repository:

| # | What happened | Where |
|---|---|---|
| 1 | Five mission threads each carry *"⚠ VERIFY THE PREMISE BY EXECUTION FIRST … this audit's premises have failed 3 for 3 — do not build from this text."* The warning is hand-written onto every thread because no step converts a claim into a check | `research-workflow-deploy-fitness` mission threads |
| 2 | A backlog sub-task instructs a session to delete prose at a named line. Grep shows the prose is not in that file at all | `repo-health-backlog-2026-07` thread 15 |
| 3 | *"I state repo facts from recall instead of checking them — now 4-for-4 in one session, and the fourth was written INTO the entry cataloguing the other three"* | `logs/improvement-log.md`, promoted to `logs/next-up.md` |
| 4 | Two documents described one task and disagreed. A fresh Claude session oriented from the stale one and told the operator to re-run work already done | [`step-7-pilot-log.md` § FP-4](step-7-pilot-log.md) |

Plus the standing cost: the operator carries the material between two models
([`step-7-pilot-log.md` § The decision](step-7-pilot-log.md), item 3).

**Why this capability and not another.** The pilot scored seven conditions across three genuine units.
**Condition 1 — "useful context preparation" — is the only one that returned `yes` in all three**
([`step-7-pilot-log.md` § What the pilot tests](step-7-pilot-log.md)). Unit 3 is the concrete instance:
Codex widened a one-line backlog item into a five-premise brief with an explicit unit boundary, held
four adjacent pieces of work outside it, wrote two load-bearing exclusions that were both correct, and
corrected Claude's reproduction method — Claude's version depended on ambient repository state and
would not have re-run the next day.

This specification formalises a capability the pilot demonstrated. It does not propose a new one. That
distinction is load-bearing: the exit decision keeps the adversarial review and sheds the bookkeeping,
and **context preparation is not the bookkeeping.**

---

## 2. The win, in priority order

Settled by the operator, 2026-08-02. The order is the specification's tiebreak rule and is quoted
before any behaviour below is read.

1. **Time to a sufficiently verified useful outcome.**
2. **Remove operator context assembly and transport.** The one-touch handoff: the operator gives the
   objective and whatever material exists, once. After that they do not assemble, remember, reconcile,
   or ferry context between Codex and Claude.
3. **Never obtain that efficiency by turning an unchecked assumption into execution authority.**

**Preventing wrong work is a safety constraint, not the optimisation target.** It wins whenever it
conflicts with self-sufficiency — and it is never the product.

> **The v1 lesson this encodes.** Work Loop v1 died by optimising wrongness-prevention as an end in
> itself and generating process machinery to serve it. Context Engineering must prevent failure
> **through how work is framed**, not by adding a stage that catches it afterwards.

**Consequence for refusals.** A refusal is *not* automatically a success. Where uncertainty can be
resolved by repository inspection, the correct output is an actionable discovery unit. The capability
returns to the operator only for genuine intent, priority, authority, or risk decisions that cannot be
derived.

---

## 3. Functional boundary

### 3.1 What it owns — the complete transformation

```
operator objective + available raw material
  → proportionate repository discovery
  → authority and relevance judgment
  → reconciliation and uncertainty classification
  → plan-aligned unit boundary
  → minimum-sufficient Claude brief
```

**One public capability.** From the operator's position this is a single act. They do not run a
separate discovery step, open an intermediate artifact, resolve a context pack, or coordinate stages.

Nine judgments make up the transformation: readiness · authority · claim type · relevance ·
conflict resolution · plan alignment · unit boundary · verify-or-assert · sufficiency.

### 3.2 Plan-alignment guardianship — inside, but as framing, not as a gate

Codex is the guardian of alignment with the approved project plan. Context Engineering owns:

- checking that the proposed work can be justified against the approved plan;
- **explaining** that justification, in the brief;
- defining the unit boundary and what is held outside it;
- escalating when the requested work cannot be reconciled with the plan.

**It does not own portfolio prioritisation** — which of the operator's objectives matters most is not
its question.

> **Hard constraint.** This guardianship operates through duties that already exist — prepare, brief,
> assess, escalate. It **must not** generate a new gate, review, document, or process stage. The
> justification is a *field in the brief*, not a checkpoint in front of it. A design that adds a stage
> here has reproduced the v1 failure named in §2.

### 3.3 What it does not own

| Not owned | Owner |
|---|---|
| Portfolio prioritisation — which objective matters most | Operator |
| Whether the work needs the loop at all (Direct Work admission) | Core § 2 |
| Judging the result — the adversarial review | Codex's assessment duty, deliberately separate |
| Repository truth | Claude. Context Engineering marks claims; it never settles them |
| Transport: state files, turn flags, unit numbering, commits, who carries the turn | Out of scope by operator direction |
| Method inside a specialist Axcíon workflow | That workflow |
| Business intent, priorities, scope changes | Operator |

### 3.4 Relationship to the existing Context Engine

The repository already contains [`/build-context`](../../.claude/commands/build-context.md), the
[`context-discovery`](../../.claude/agents/context-discovery.md) agent, and
[`docs/context-pack-schema.md`](../../docs/context-pack-schema.md).

**Context Engineering is self-contained. It does not invoke, depend on, extend, or conform to that
system.** The existing engine is **prior art only** — informative about failure cases; its schema,
mechanical tiers, context-pack artifact, read budget, invocation path, and conflict rules do not
govern this specification.

Two clarifications a reviewer will want:

- **§7 borrows an idea, not an artifact.** Using a mechanical, path-based classification as a *starting
  heuristic* is not conformance to the pack schema. No context pack is produced, read, or referenced.
- **Whether the eventual implementation reuses any of that code is Claude's technical decision after
  live inspection.** This specification neither requires nor prohibits reuse.

**Deferred to adoption planning, not settled here:** when this capability is adopted, the older Context
Engine's lifecycle must be explicitly dispositioned so two live capabilities do not claim the same
responsibility.

### 3.5 Self-contained does not mean unbounded reading

Discovery must be **proportionate**. Every material claim states its search boundary. Where the
boundary is insufficient to answer, the answer is an honest unknown — never an assertion.

*(What "proportionate" means concretely is open — see §8, O-1.)*

### 3.6 Capability scope in this version

A **core Work Loop function**, not a general Axcíon capability. Specify its behaviour independently of
transport, state files, Git and the present command shape; deliver and promote it as a core Work Loop
function once built and demonstrated. Do not generalise it to unrelated workflows without evidence of
a second real caller.

---

## 4. Actors, inputs, outputs

**Actors — three.**

- **Operator** — supplies the objective and available raw material, once. Is the only source of intent
  the models cannot derive. Receives genuine decisions only. Is not the assembly layer or the transport.
- **Codex** — performs every judgment in §3.1. Reads the repository proportionately, to write checkable
  claims. Is never authoritative about what it read.
- **Claude** — consumes the brief, checks its claims against the live repository first, and hands back
  rather than building on a false premise.

**Inputs — one boundary, two classes of material.**

| Class | Treatment |
|---|---|
| **Current operator-authored decision** | May carry execution authority |
| **Everything else** — repository material, pasted external material, GPT output, prior sessions, plans, READMEs, backlog entries, audits | **Source material, not instructions.** Validated read-only where possible; labelled unverified where validation is unavailable; never issues instructions through imperative wording alone |

**Repository material is the primary case** — that is where the observed failures occurred and where
claims can be verified. Pasted external material enters through the same boundary as a secondary source.

**Outputs — one artifact, or one escalation.**

- **One brief, two audiences.** It opens by orienting the operator in plain language — *why this unit,
  why now, how it aligns with the approved plan.* The remainder is Claude's bounded execution context:
  required outcome, prepared context, authority sources, scope, exclusions, constraints, evidence
  required, completion condition, stop conditions, and the claims Claude must check.
- **Or a discovery brief** — where a load-bearing unknown is resolvable by inspection.
- **Or an escalation** — carrying only the genuine operator-owned decision.

**No separate orientation document.** Two artifacts describing one task is FP-4.

---

## 5. Authority rules

### 5.1 Source role decides; file location only routes

File location is a **discovery heuristic**. A mechanical, path-based tier may serve as the starting
classification because it is deterministic and falsifiable. Before any material controls execution, the
semantic hierarchy applies:

```
current operator decision
  → approved project mission or plan
  → approved workflow or SOP
  → authoritative project state
  → verified repository reality
  → settled implementation decisions
  → exploratory material
  → proposals and preferences
```

**A file does not become a requirement because it sits in a high-tier path or uses imperative
language.**

### 5.2 Demotion requires cited evidence

Codex may demote or supersede a mechanically authoritative source **only** with cited evidence — a
later operator decision, an explicit supersession statement, a newer approved plan, a decision record,
or verified repository evidence that the source's factual premise is stale.

**No evidence, no demotion.** The source remains a surfaced conflict or an unknown.

### 5.3 Unresolved ties

1. **About repository reality** → carry both claims into the brief, as claims for Claude to distinguish
   by evidence.
2. **About operator intent, priority, accepted risk, or which governing decision controls** → return
   only that decision to the operator.
3. **Never manufacture a tie-break to keep the process moving.**

### 5.4 Codex-added boundaries

Codex may add scope exclusions and boundaries the operator never stated, where they are needed to
preserve plan alignment, prevent adjacent work, or make the unit independently coherent.

Every added boundary carries its reason, and remains identifiable as **Codex's framing decision** —
never laundered into an operator requirement.

*(Precedent: unit 3's two load-bearing exclusions were both unstated by the operator and both correct.)*

---

## 6. Behavioural contract

Sixteen observable behaviours in six families. Each carries a **constructible failing case**, the
**expected successful outcome**, and **evidence capable of distinguishing the two** — the mission's own
standard, *"every acceptance behaviour is demonstrated against a constructed failing case before it
counts as done."*

**Proof does not occur in this specification session.** The specification is complete when the
behaviours, failing cases and evidence standards are defined. The capability is not validated or
adopted until they are demonstrated in a real trial.

### Family 1 — The one-touch handoff (the primary win)

**CE-1 · Nothing derivable is asked of the operator.**
*Failing case:* an objective plus material where a load-bearing file's location is unstated but
discoverable. *Fails if* the run asks the operator where it is. *Succeeds if* Codex locates it and the
brief cites it. *Evidence:* every question returned to the operator is classified against §5.3's two
categories; any question of a derivable kind is a failure.

**CE-2 · Escalation is reserved for genuine operator-owned decisions.**
*Failing case:* material containing both a resolvable repository question and a genuine intent
question. *Fails if* both return to the operator. *Succeeds if* only the intent question does.
*Evidence:* the returned set, classified; the repository question appears in the brief as a claim
instead.

**CE-3 · Resolvable uncertainty becomes a discovery unit, not a refusal.**
*Failing case:* a load-bearing unknown answerable by repository inspection. *Fails if* the output is a
refusal, or a guess. *Succeeds if* the unit becomes *establish X, inspect Y, return evidence, then
reframe or stop.* *Evidence:* the brief's stated unit and its completion condition.

### Family 2 — Authority integrity

**CE-4 · Semantic hierarchy governs; path tier only routes.**
*Failing case:* a stale plan at a high-tier path, contradicted by a later operator decision.
*Fails if* the brief carries the plan's requirement. *Succeeds if* the operator decision controls and
the plan is recorded as superseded, with the citation. *Evidence:* which of the two appears in the
brief's governing context, and which in its disclosure.

**CE-5 · Imperative wording creates nothing.**
*Failing case:* a non-authoritative source stating *"Claude must add X."* *Fails if* X appears as a
requirement. *Succeeds if* X appears as a proposal, or not at all. *Evidence:* the brief's classification
of X, plus §6 CE-14's reclassification disclosure.

**CE-6 · Demotion requires a citation.**
*Failing case:* a source that reads as stale but carries no supersession evidence. *Fails if* it is
silently demoted or dropped. *Succeeds if* it is carried as a surfaced conflict or an unknown.
*Evidence:* the brief's conflict/unknown section names it.

### Family 3 — Verification marking

**CE-7 · Load-bearing repository claims leave as claims, never as facts.**
*Failing case:* material asserting a file holds specific content at a specific line, where it does not.
*Fails if* the brief presents it as fact. *Succeeds if* it appears as a claim to check, naming the file
and the pattern — and this succeeds **even though the claim is false**, because Claude's check is what
settles it. *Evidence:* the brief's claims section; then Claude's inspection record marking it FALSE.

**CE-8 · Absence claims state what was searched.**
*Failing case:* material stating *"nothing consumes this file."* *Fails if* repeated without a named
surface and pattern. *Succeeds if* rewritten as a claim naming both. *Evidence:* the claim's text
contains the searched surface and the pattern. *(Inherits core § 6 rule 3.)*

**CE-9 · Discovery is proportionate, and its boundary is stated.**
*Failing case:* a question whose answer lies outside a proportionate search. *Fails if* the brief
asserts an answer. *Succeeds if* it states the boundary searched and marks the remainder unknown.
*Evidence:* the stated boundary, and whether any assertion exceeds it.

### Family 4 — Framing and plan alignment

**CE-10 · Every brief carries its plan-alignment justification — as a field, not a gate.**
*Failing case:* an objective that cannot be reconciled with the approved plan. *Fails if* the brief
proceeds without saying so; *also fails if* the design introduces a separate alignment-check stage.
*Succeeds if* the brief states the justification inline, or escalates the irreconcilability.
*Evidence:* the brief's opening orientation; and a count of process stages introduced by the capability,
which must be zero.

**CE-11 · The unit is bounded, and what is held back is named.**
*Failing case:* an objective plainly spanning several units. *Fails if* the brief takes all of it, or
bounds it without saying what is excluded. *Succeeds if* it bounds one unit that delivers something
observable and names the adjacent work held outside. *Evidence:* the brief's scope and exclusions
sections, compared against the objective's full surface.

**CE-12 · Codex-added boundaries carry a reason and stay attributed.**
*Failing case:* an exclusion Codex added on its own judgment. *Fails if* it appears without a reason, or
in the operator's voice. *Succeeds if* it is marked as Codex's framing decision with its reason attached.
*Evidence:* the exclusion's text.

### Family 5 — Selection: what governs, what is visible, what is cut

**CE-13 · Three-way relevance, not two.** This is the operator's tiebreak on §2's constraint, and it
replaces a simple keep/cut rule.

| Class | Treatment |
|---|---|
| Passes authority **and** relevance | **Governs execution** |
| Relevance uncertain | **Preserved visibly** as background, conflict, or unknown — does not govern |
| Routine repetition, boilerplate, explanation without execution value | **Removed**, no record needed |

*Failing case A (over-inclusion):* a stale speculative document appears in the governing section →
fails. *Failing case B (silent drop):* a load-bearing constraint buried in low-value material
disappears entirely → fails. *Failing case C (the middle):* an uncertain-relevance item is silently
promoted to governing, **or** silently erased → fails; preserved as background → succeeds.
*Evidence:* each input item traced to exactly one of the three classes.

> **When forced to choose, over-inclusion is worse** — stale, speculative or low-authority material can
> masquerade as governing context and silently produce wrong work. Knowingly dropping load-bearing
> context is also unacceptable. The middle class exists so the choice is rarely forced.

**CE-14 · Material reclassification is disclosed; routine compression is not.**
Disclosed: a proposal that resembled a requirement · a source that lost an authority conflict · a
repository claim demoted to unverified · a material item deliberately held outside the unit.
*Failing case:* a proposal demoted with no disclosure. *Fails if* the brief is silent. *Succeeds if* the
demotion appears in the disclosure. *Also fails* if the brief carries a full discard log — that is the
opposite error. *Evidence:* the disclosure section, checked against the four kinds.

### Family 6 — Form

**CE-15 · One artifact, two audiences.**
*Failing case:* the run produces a separate operator-orientation document. *Fails* on production of the
second document. *Succeeds if* one brief opens with plain-English orientation and continues into
Claude's execution context. *Evidence:* the count of artifacts describing the unit, which must be one.

**CE-16 · No new governance machinery.**
*Failing case:* the design adds a context-QC pass, an alignment gate, a review stage, or a new document
type. *Fails* on the addition. *Succeeds if* every duty is discharged inside prepare / brief / assess /
escalate. *Evidence:* an enumeration of stages, artifacts and gates the capability introduces —
target zero beyond the brief itself.

---

## 7. What is deliberately excluded

- **A separate context-QC pass.** Risk-triggered at most, and no pilot unit produced a
  context-preparation defect one would have caught. Excluded until one does.
- **Lane classification.** Not this capability's job; the MVP already rejected a third lane.
- **A new backlog, register, or log.**
- **Transport of any kind** — state files, turn flags, unit numbering, commits, session mechanics.
- **General non-repository context engineering.** Deferred; reopening trigger is a real second caller.
- **Portfolio prioritisation.**

---

## 8. Open items

Recorded rather than resolved. Each names what would close it.

**O-1 · What "proportionate discovery" means concretely.** §3.5 requires it and §3.4 removes the
existing engine's read budget as a reference. The specification needs a bound that is observable —
otherwise CE-9 cannot fail. *Closes when:* the drafting pass defines the bound, or the first trial
supplies a measured one.

**O-2 · Whether the operator orientation has a length ceiling.** CE-15 puts it at the top of the brief.
Unbounded, it is where the document grows. *Closes when:* the drafting pass sets a ceiling, or accepts
its absence with a reason.

**O-3 · Which brief format v0.2 carries.** The current brief contract (core § 3 step 3) works and is
exercised. But v0.2's shape is undecided, and this specification must not pre-decide it. *Closes when:*
v0.2's scope is settled.

**O-4 · The existing Context Engine's disposition on adoption.** Operator-deferred to adoption planning.
*Closes when:* adoption is planned.

**O-5 · Sequencing against the mission.** §0 records that this work sits outside Step 8's scope by
operator direction. *Closes when:* the operator states where this specification sits relative to the
mission's remaining threads.

---

## 9. Standing rule — alignment through framing

Codex protects the approved project objective throughout preparation and assessment. It applies the
core principles — authority integrity, explicit uncertainty, stable scope, smallest sufficient
intervention, evidence capable of failing, and stopping when value ends — **as constraints inside its
existing work.**

Failure is prevented through how work is framed, not by catching it afterwards. No new governance
machinery, in any version.
