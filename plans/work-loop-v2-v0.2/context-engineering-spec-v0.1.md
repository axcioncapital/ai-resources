# Work Loop — Context Engineering

**Version:** v0.1 · **Stage:** draft specification — awaiting operator approval · **Status:** not requirements

> **Authority notice.** This document specifies *behaviour*, not requirements to build. Nothing here
> authorises implementation. Imperative wording in this file creates nothing — the same rule it applies
> to every other source.
>
> **One file, not two.** This document evolves in place. A second document about the same subject is the
> staleness failure recorded at
> [`step-7-pilot-log.md` § FP-4](../work-loop-v2-mvp/step-7-pilot-log.md).

**Session of record:** 2026-08-02. Drafted by Claude from operator-settled decisions 1–14, then revised
once against Codex's review (findings A–H) the same day. Codex guides and assesses.

---

## 0. Position

This is operator-authorized **post-MVP Work Loop v0.2 specification work**. It is not part of the Work
Loop v2 MVP mission or its Step 8.

---

## 1. The function, and the gap it closes

> **Definition.** Turn one operator objective plus available material into the smallest sufficient,
> plan-aligned brief that lets Claude begin useful repository work without further operator context
> assembly or transport.

*Sufficient*, not *safe*: safety is the constraint that wins ties (§2), never the thing being optimised.

### 1.1 The verified gap

Context preparation is **not absent**. Codex already performed it in the pilot, and the complete-system
reference already assigns the duty conceptually. Four things are true of it today:

- **Informal.** It is a habit, not a behavioural contract — so nothing about it can be said to fail.
- **Not self-contained.** No stated boundary for what it owns, how far it reads, or what it hands back.
- **Not one-touch.** The operator still assembles material and carries it between the two models
  ([`step-7-pilot-log.md` § The decision](../work-loop-v2-mvp/step-7-pilot-log.md), item 3).
- **Entangled** with transport and bookkeeping assumptions inherited from earlier versions — the exact
  machinery the v2 exit decision sheds.

This specification converts an informal duty into a self-contained behavioural contract. It does not
claim to invent the duty.

### 1.2 What the informal version costs

Four instances, all from this repository:

| # | What happened | Where |
|---|---|---|
| 1 | Five mission threads each carry *"⚠ VERIFY THE PREMISE BY EXECUTION FIRST … this audit's premises have failed 3 for 3 — do not build from this text."* The warning is hand-written onto every thread because no step converts a claim into a check | `research-workflow-deploy-fitness` mission threads |
| 2 | A backlog sub-task instructs a session to delete prose at a named line. Grep shows the prose is not in that file at all | `repo-health-backlog-2026-07` thread 15 |
| 3 | *"I state repo facts from recall instead of checking them — now 4-for-4 in one session, and the fourth was written INTO the entry cataloguing the other three"* | `logs/improvement-log.md`, promoted to `logs/next-up.md` |
| 4 | Two documents described one task and disagreed. A fresh Claude session oriented from the stale one and told the operator to re-run work already done | [`step-7-pilot-log.md` § FP-4](../work-loop-v2-mvp/step-7-pilot-log.md) |

### 1.3 Why formalise this capability rather than another

The pilot scored seven conditions across three genuine units. **Condition 1 — "useful context
preparation" — is the only one that returned `yes` in all three**
([`step-7-pilot-log.md` § What the pilot tests](../work-loop-v2-mvp/step-7-pilot-log.md)). Unit 3 is the
concrete instance: Codex widened a one-line backlog item into a five-premise brief with an explicit unit
boundary, held four adjacent pieces of work outside it, wrote two load-bearing exclusions that were both
correct, and corrected Claude's reproduction method — Claude's version depended on ambient repository
state and would not have re-run the next day.

The exit decision keeps the adversarial review and sheds the bookkeeping. **Context preparation is not
the bookkeeping.**

---

## 2. The win, in priority order

Settled by the operator, 2026-08-02. The order is this specification's tiebreak rule.

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

**Target 1 in testable form — one preparation pass.** Context Engineering produces an execution brief, a
discovery brief, or a genuine escalation **in a single preparation pass**. It must not open an iterative
context interview, a separate QC pass, or a preparation loop to obtain information it could derive.
Measured as a count of passes, not as elapsed time. *(Behaviour: CE-17, clause 2.)*

**Consequence for refusals.** A refusal is *not* automatically a success — routing is §5.4's, and it
returns to the operator only for genuine intent, priority, authority or risk decisions.

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

**One public capability.** From the operator's position this is a single act. They do not run a separate
discovery step, open an intermediate artifact, resolve a context pack, or coordinate stages.

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
> assess, escalate. It **must not** generate a new operator-visible stage, gate, review pass, or
> persistent artifact. The justification is a *field in the brief*, not a checkpoint in front of it. A
> design that adds a stage here has reproduced the v1 failure named in §2.

### 3.3 What it does not own

| Not owned | Owner |
|---|---|
| Portfolio prioritisation — which objective matters most | Operator |
| Whether the work needs the loop at all (Direct Work admission) | [Core § 2](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md) |
| Judging the result — the adversarial review | Codex's assessment duty, deliberately separate |
| Repository truth | Claude. Context Engineering marks claims; it never settles them |
| Transport: state files, turn flags, unit numbering, commits, who carries the turn | Out of scope by operator direction |
| Method inside a specialist Axcíon workflow | That workflow |
| Business intent, priorities, scope changes | Operator |

### 3.4 No dependency on another context-preparation capability

**Context Engineering has no required dependency on another context-preparation capability. Existing
resources neither govern nor constrain this contract** — not its seam, its authority model, its output,
or its adoption conditions. Whether an implementation later reuses existing code is a technical decision
taken after live inspection, and does not belong in this specification.

### 3.5 Proportionate discovery — the relevance-gated expansion rule

Discovery is bounded by relevance, not by a file count or a token budget.

1. **Start from** the operator objective and supplied material, the approved project plan, authoritative
   project state, and directly named artifacts.
2. **Expand only** to resolve a load-bearing claim, an explicit dependency, an authority conflict, or a
   cited reference.
3. **Every expansion beyond the starting set is traceable** to one of those four reasons.
4. **Stop** when the brief can state its outcome, plan justification, governing sources, boundary,
   exclusions, verification claims, required evidence and completion condition — or when the remaining
   load-bearing unknown becomes a discovery unit or a genuine escalation.
5. **Do not** scan unrelated history, archives, or adjacent systems merely because they might contain
   something useful.

Where the boundary is insufficient to answer, the answer is an honest unknown — never an assertion.
*(Behaviour: CE-9.)*

### 3.6 Capability scope in this version

A **core Work Loop function**, not a general Axcíon capability. Specify its behaviour independently of
transport, state files, Git and the present command shape; deliver and promote it as a core Work Loop
function once built and demonstrated. Do not generalise it to unrelated workflows without evidence of a
second real caller.

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

### 4.1 The output — one brief, or one escalation

**One brief, two audiences.** No separate orientation document: two artifacts describing one task is FP-4.

**Operator orientation — one paragraph, at most three sentences**, answering only: (1) why this unit,
(2) why now, (3) how it aligns with the approved plan. Nothing else belongs there.

**Claude's execution context — the required contents:** required outcome · prepared context · governing
sources · scope · exclusions · constraints · required evidence · the claims Claude must check ·
completion condition · stop conditions · explicit permission to challenge a false premise or stale
direction rather than improvise.

That list is the **semantic interface**. Its serialization — Markdown, YAML, a file, a field, a UI — is
an implementation decision and is not open specification work.

**Inclusion rule.** Every included item must materially affect the outcome, plan alignment, scope, a
constraint, verification, the completion condition, or a failure mode. If it affects none of these, it
stays out. This governs the brief; it does not replace the discovery boundary in §3.5.

**Qualified reference rule.** Reference the authoritative source and state only its consequence for this
unit; do not reproduce long source material. Where opening the source is necessary for authority or
verification, cite it as a required source. This is not "reference, never summarise" — the brief still
carries minimum-sufficient prepared context.

**Or a discovery brief** — where a load-bearing unknown is resolvable by inspection.
**Or an escalation** — carrying only the genuine operator-owned decision.

---

## 5. Authority and disposition

### 5.1 Four dispositions

Every material claim cluster lands in exactly one:

| Disposition | What it covers | Where it lands in the brief |
|---|---|---|
| **Governing authority** | Current operator decisions, approved plans, applicable approved workflows | Governing context, constraints, scope |
| **Verify-first claim** | Any claim about current repository reality | The claims Claude must check — never stated as fact |
| **Non-governing background** | Proposals, suggestions, rejected or demonstrably superseded material | Background reference; never a requirement |
| **Unknown** | A material question not yet resolved | Disclosed unknown, routed by §5.4 |

Applied to **material claim clusters, not sentence by sentence**. No ledger, no scores, no provenance
artifact — the disposition is visible in exactly one place: where the item lands.

**Age alone does not demote.** An old plan is not automatically non-governing; supersession requires
cited evidence (§5.3).

### 5.2 Source role decides; file location only routes

File location is a **discovery heuristic**. Before any material controls execution, the semantic
hierarchy applies:

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

**A file does not become a requirement because it sits in a high-authority path or uses imperative
language.**

### 5.3 Demotion requires cited evidence

Codex may demote or supersede an apparently authoritative source **only** with cited evidence — a later
operator decision, an explicit supersession statement, a newer approved plan, a decision record, or
verified repository evidence that the source's factual premise is stale.

**No evidence, no demotion.** The source remains a surfaced conflict or an unknown.

### 5.4 Unknown routing

| Unknown | Route |
|---|---|
| Blocking · Claude-resolvable | Verify-first claim, or a discovery brief |
| Blocking · operator-resolvable | Focused escalation — that decision only |
| Blocking · no current resolver | Stop, with the unknown stated honestly |
| Non-blocking | Disclosed limitation; the work proceeds |

### 5.5 Unresolved ties

Ties route through §5.4, with two clarifications: a tie **about repository reality** carries both claims
into the brief for Claude to distinguish by evidence; a tie **about operator intent, priority, accepted
risk, or which governing decision controls** is an operator-resolvable escalation. **Never manufacture a
tie-break to keep the process moving.**

### 5.6 Codex-added boundaries

Codex may add scope exclusions and boundaries the operator never stated, where they are needed to
preserve plan alignment, prevent adjacent work, or make the unit independently coherent.

Every added boundary carries its reason and remains identifiable as **Codex's framing decision** — never
laundered into an operator requirement. *(Precedent: unit 3's two load-bearing exclusions were both
unstated by the operator and both correct.)*

---

## 6. Behavioural contract

Seventeen observable behaviours in six families. Each carries a **constructible failing case**, the
**expected successful outcome**, and **evidence capable of distinguishing the two** — the mission's own
standard, *"every acceptance behaviour is demonstrated against a constructed failing case before it
counts as done."*

**Proof does not occur in this specification session.** The specification is complete when the
behaviours, failing cases and evidence standards are defined. The capability is not validated or adopted
until they are demonstrated in a real trial.

### Family 1 — The one-touch handoff (the primary win)

*CE-17 is this family's headline behaviour. It carries the highest number because CE-1…CE-16 are cited by
number in the review record and were deliberately left stable.*

**CE-17 · One operator input, one preparation pass, one consumable brief.**
Delivery-mechanism-independent: this specification does not choose how the brief reaches Claude, only
that it does so without the operator carrying it.
*Clause 1 — no transport by the operator.* The operator supplies the objective and optional raw material
once; Claude receives and can act from the engineered brief without the operator re-entering,
reconstructing, or transferring context. *Failing case:* the brief is produced somewhere only the
operator can see, requiring them to paste it into Claude. *Succeeds if* Claude consumes the brief after
one operator input action and no further context-transfer action.
*Clause 2 — one preparation pass.* *Failing case:* the capability opens an iterative context interview, a
separate QC pass, or a preparation loop for information it could derive. *Succeeds if* the pass
terminates in exactly one execution brief, discovery brief, or genuine escalation.
*Evidence:* a count of operator context actions from objective submission through Claude's consumption —
target one, plus any genuine operator-owned decision; and a count of preparation passes — target one.

**CE-1 · Nothing derivable is asked of the operator.**
*Failing case:* an objective plus material where a load-bearing file's location is unstated but
discoverable. *Fails if* the run asks the operator where it is. *Succeeds if* Codex locates it and the
brief cites it. *Evidence:* every question returned to the operator is classified against §5.4; any
question of a derivable kind is a failure.

**CE-2 · Escalation is reserved for genuine operator-owned decisions.**
*Failing case:* material containing both a resolvable repository question and a genuine intent question.
*Fails if* both return to the operator. *Succeeds if* only the intent question does. *Evidence:* the
returned set, classified; the repository question appears in the brief as a claim instead.

**CE-3 · Resolvable uncertainty becomes a discovery unit, not a refusal.**
*Failing case:* a load-bearing unknown answerable by repository inspection. *Fails if* the output is a
refusal, or a guess. *Succeeds if* the unit becomes *establish X, inspect Y, return evidence, then
reframe or stop.* *Evidence:* the brief's stated unit and its completion condition.

### Family 2 — Authority integrity

**CE-4 · Semantic hierarchy governs; path location only routes.**
*Failing case:* a stale plan at a high-authority path, contradicted by a later operator decision.
*Fails if* the brief carries the plan's requirement. *Succeeds if* the operator decision controls and the
plan is recorded as superseded, with the citation. *Evidence:* which of the two appears in the brief's
governing context, and which in its disclosure.

**CE-5 · Imperative wording creates nothing.**
*Failing case:* a non-authoritative source stating *"Claude must add X."* *Fails if* X appears as a
requirement. *Succeeds if* X appears as non-governing background, or not at all. *Evidence:* X's
disposition under §5.1, plus CE-14's reclassification disclosure.

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

**CE-9 · Discovery is relevance-gated, and every expansion names its reason.**
*Failing case:* an irrelevant repository area is seeded that connects to no load-bearing question.
*Fails if* it is inspected or included without a stated reason; *also fails if* any assertion exceeds the
recorded search boundary. *Succeeds if* every expansion beyond §3.5's starting set maps to one of its
four reasons, and the unresolved remainder is marked unknown. *Evidence:* the trial's inspected-source
set, with each expansion mapped to its reason. This is **trial evidence, not a new durable log.**

### Family 4 — Framing and plan alignment

**CE-10 · Every brief carries its plan-alignment justification — as a field, not a gate.**
*Failing case:* an objective that cannot be reconciled with the approved plan. *Fails if* the brief
proceeds without saying so; *also fails if* the design introduces a separate alignment-check stage.
*Succeeds if* the brief states the justification inline, or escalates the irreconcilability.
*Evidence:* the brief's opening orientation; and zero additional operator-visible stages, approval gates,
review passes, or persistent artifacts beyond the engineered brief.

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

**CE-13 · Three-way relevance, not two.** The operator's tiebreak on §2's constraint; it replaces a
simple keep/cut rule and operates on top of §5.1's dispositions.

| Class | Treatment |
|---|---|
| Passes authority **and** relevance | **Governs execution** |
| Relevance uncertain | **Preserved visibly** as background, conflict, or unknown — does not govern |
| Routine repetition, boilerplate, explanation without execution value | **Removed**, no record needed |

*Failing case A (over-inclusion):* a stale speculative document appears in the governing section → fails.
*Failing case B (silent drop):* a load-bearing constraint buried in low-value material disappears
entirely → fails. *Failing case C (the middle):* an uncertain-relevance item is silently promoted to
governing, **or** silently erased → fails; preserved as background → succeeds.
*Evidence:* in a constructed failing case, the deliberately seeded material is traced to its expected
class. **In real operation, only material reclassifications are disclosed, per CE-14 — no complete
production trace, no discard ledger.**

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
second document. *Succeeds if* one brief opens with the §4.1 orientation paragraph — three sentences at
most — and continues into Claude's execution context. *Evidence:* the count of artifacts describing the
unit, which must be one; and the orientation's sentence count.

**CE-16 · No new governance machinery.**
*Failing case:* the design adds a context-QC pass, an alignment gate, a review stage, or a new document
type. *Fails* on the addition. *Succeeds if* every duty is discharged inside prepare / brief / assess /
escalate. *Evidence:* **zero additional operator-visible stages, approval gates, review passes, or
persistent artifacts beyond the engineered brief.** Internal discovery and reasoning steps inside the
single capability are not stages, and are not prohibited.

---

## 7. Excluded, and explicitly rejected

**Out of scope for this capability:**

- **Any separate context-QC pass** — including a risk-triggered one. Not in this version. No pilot unit
  produced a context-preparation defect one would have caught; the reopening trigger is one that does.
- **Lane classification.** Not this capability's job; the MVP already rejected a third lane.
- **A new backlog, register, or log.**
- **Transport of any kind** — state files, turn flags, unit numbering, commits, session mechanics.
- **General non-repository context engineering.** Deferred; reopening trigger is a real second caller.
- **Portfolio prioritisation.**

**Explicitly rejected as constraints on this specification** — considered, not adopted:

- an 8,000-character resource-body size cap;
- a required task-state file;
- required Git delivery;
- a "Gate" and a "Compiler" as named runtime components;
- any dependency on the existing acceptance harness or slice plan.

---

## 8. Open items — none

All five open items from the foundation are closed. Recorded so the closure is auditable rather than
silently reopened.

| Item | Closed by |
|---|---|
| O-1 · What "proportionate discovery" means | §3.5's relevance-gated expansion rule; CE-9 revised to match |
| O-2 · Operator-orientation length ceiling | §4.1 — one paragraph, three sentences, three questions |
| O-3 · Which brief format v0.2 carries | §4.1 — the required contents are the semantic interface; serialization is an implementation decision, not open specification work |
| O-4 · Disposition of the existing Context Engine | Removed from scope — §3.4 states no dependency; the disposition is not this specification's question |
| O-5 · Sequencing against the mission | Removed — operator authorization resolves it; §0 states the position |

---

## 9. Standing rule, and the acid test

Codex protects the approved project objective throughout preparation and assessment. It applies the core
principles — authority integrity, explicit uncertainty, stable scope, smallest sufficient intervention,
evidence capable of failing, and stopping when value ends — **as constraints inside its existing work.**

Failure is prevented through how work is framed, not by catching it afterwards. No new governance
machinery, in any version.

> **The acid test.** Does Context Engineering let the operator provide the objective and material once,
> then let Claude begin the correct repository work sooner, with load-bearing uncertainty marked for
> verification and less process than the failure being prevented?

If the answer in a real trial is no, the capability shrinks. It does not grow.
