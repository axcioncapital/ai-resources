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
three times the same day: once against Codex's review (findings A–H); again after the operator settled
**Codex's direct durable-context writing authority**, superseding the earlier consume-only boundary; and
again against Codex's bounded correction set — which found the architecture sound but not yet ready for
operator approval. Codex guides and assesses.

---

## 0. Position

This is operator-authorized **post-MVP Work Loop v0.2 specification work**. It is not part of the Work
Loop v2 MVP mission or its Step 8.

---

## 1. The function, and the gap it closes

> **Definition.** Turn one operator objective plus available material into the smallest sufficient,
> plan-aligned brief that lets Claude begin useful repository work without further operator context
> assembly or transport. In doing so, Context Engineering consumes and, only when material project
> understanding changes, maintains the minimum durable sources in §5.7 so later sessions can perform the
> same transformation without operator reconstruction.

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
Measured as a count of passes, not as elapsed time. *(Behaviour: CE-17, clause 1.)*

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

**Durable-context stewardship and brief preparation are that same one capability.** There is no separate
orientation stage, context-capture stage, plan-promotion stage, context-maintenance stage, approval gate
or context-QC pass. Routine invocations **consume** the durable sources of §5.7 and produce the bounded
brief; they create or update a durable context file **only** where new operator input, explicit operator
approval, or verified evidence materially changes durable project understanding.

Where no governing plan exists and one is genuinely required, Codex may prepare the one canonical file as
a **visibly non-governing draft** and return a focused approval decision (§5.4). It must not use that
draft as governing authority beforehand. That approval is a genuine operator-owned decision and does not
violate §2's one-touch target: everything derivable remains Codex's work, and only the authority decision
returns to the operator.

### 3.2 Plan-alignment guardianship — inside, but as framing, not as a gate

Codex is the guardian of alignment with the approved project plan. Context Engineering owns:

- checking that the proposed work can be justified against the approved plan;
- **explaining** that justification, in the brief;
- defining the unit boundary and what is held outside it;
- escalating when the requested work cannot be reconciled with the plan;
- maintaining the approved plan itself as durable context — synthesising the draft, recording the
  operator's approval in it, and reconciling it when a later operator decision or verified evidence
  materially changes it (§5.7).

**It does not own portfolio prioritisation** — which of the operator's objectives matters most is not
its question. **Nor does it own approval:** Codex proposes; only the operator promotes a draft to
governing.

> **Hard constraint.** This guardianship operates through duties that already exist — prepare, brief,
> assess, escalate. It **must not** generate a new operator-visible stage, gate, review pass, or
> **additional** persistent artifact. The justification is a *field in the brief*, not a checkpoint in
> front of it. A design that adds a stage here has reproduced the v1 failure named in §2.
>
> *"Additional" is measured against §5.7's three permitted durable categories.* The one canonical plan
> and the existing current-state interface are not new machinery — they are the minimum durable context
> the one-touch outcome requires. A second plan, a plan copy, an approval record, a per-run log or a new
> state system **is** new machinery, and is prohibited (CE-16).

### 3.3 What it does not own

| Not owned | Owner |
|---|---|
| Portfolio prioritisation — which objective matters most | Operator |
| Whether the work needs the loop at all (Direct Work admission) | [Core § 2](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md) |
| Judging the result — the adversarial review | Codex's assessment duty, deliberately separate |
| Repository truth | Claude. Context Engineering marks claims; it never settles them. *Writing a durable context file records direction and state — it does not settle a repository fact* |
| Implementation, implementation tests, implementation evidence, Git commits | Claude |
| Transport (defined below) | Out of scope by operator direction |
| Method inside a specialist Axcíon workflow | That workflow |
| Business intent, priorities, scope changes | Operator |

> **Persistence is not transport.** The earlier boundary grouped state files with transport and then
> prohibited persistent artifacts beyond the brief. That grouping is superseded; the two are different
> things and only one is excluded.
>
> - **Durable persistence** is Codex maintaining the permitted canonical plan, optional operator source
>   material, and the **existing** current-state interface — the three categories of §5.7, and nothing
>   else. Codex owns this.
> - **Transport** is runtime delivery · turn flags · unit numbering · session mechanics · packaging ·
>   technical identity · Git mechanics · and who carries a runtime turn. All of it remains outside this
>   specification. Context Engineering neither implements nor prescribes any of it.
>
> Context Engineering owns **producing the consumable brief at the Work Loop handoff interface**; the
> surrounding Work Loop owns delivering it. Actual delivery to Claude is therefore an *integrated* Work
> Loop acceptance condition (CE-17), not authorisation for Context Engineering to build a transport
> mechanism.

> **A commit restriction is not an authoring or a decision restriction.** Claude makes every commit
> because Codex was refused write access to `.git`
> ([core § 4](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md), *"Who commits: Claude"*). That
> fact constrains **who runs `git commit`** and nothing else. It does not limit what Codex may author,
> edit, decide, or close. *(Recorded because the pilot produced exactly this conflation: at closure Codex
> declined to write a record, citing "this repository's rule prohibiting Codex from approving or closing
> work" — a rule that does not exist in `docs/qc-independence.md`, `AGENTS.md`, `.codex/` or the core, and
> asked the operator to override it.
> [`step-7-pilot-log.md` § FP-12](../work-loop-v2-mvp/step-7-pilot-log.md). The generalisable lesson is
> the sharper one: **a model citing a rule is not evidence the rule exists.**)*

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
transport, state-file mechanics, Git and the present command shape; deliver and promote it as a core Work
Loop function once built and demonstrated. Do not generalise it to unrelated workflows without evidence
of a second real caller.

*Independence is of the **mechanism**, not of durable context.* §5.7 uses whatever authoritative
current-state interface already exists and defines no new schema; Claude's Git commits remain Claude's
(§4). Neither is specified here.

---

## 4. Actors, inputs, outputs

**Actors — three.**

- **Operator** — supplies the objective and available raw material, once. Is the only source of intent
  the models cannot derive. Receives genuine decisions only. Is not the assembly layer or the transport.
- **Codex** — performs every judgment in §3.1, and is the **custodian of durable project context**.
  Reads the repository proportionately, to write checkable claims. Is never authoritative about what it
  read.
- **Claude** — consumes the brief, checks its claims against the live repository first, and hands back
  rather than building on a false premise.

**Codex's durable-context authority — what it may do.** Within substantive Work Loop work where
cross-session continuity materially matters, Codex may **directly author and edit** durable
project-context files. It may: preserve materially important operator source material · synthesise a
proposed canonical project plan · record explicit operator approval in that plan · maintain concise
current state from verified results · reconcile durable context when new operator decisions or evidence
materially change it · use those sources to prepare the next bounded Claude brief. The authority covers
context, planning and state artifacts. Its lifecycle and limits are §5.7.

**What it does not transfer.** The following remain Claude's, unchanged: verifying live repository
reality · implementing product, code, configuration or workflow changes · running implementation tests ·
producing implementation evidence · performing Git commits. **Codex writes the durable context content;
Claude commits it under the present Work Loop implementation.**

> **Custodian, not sovereign.** Codex stewards durable context; it is not the source of authority over
> it. **What it may and may not do with that custody is §5.7, stated once.**

**Inputs — one boundary, one entry rule.**

**Everything enters as source material. Nothing arrives governing.** Authority is not a property of
arrival; it is the outcome of §5's classification. Two things can leave that classification carrying
authority, and they are not exceptions to the entry rule — they are its two possible results:

| On entry | On classification |
|---|---|
| **A current operator-authored decision** | May carry execution authority once §5 establishes it is current and applicable |
| **An operator-approved governing plan or applicable approved workflow** | Governs under §5.2, once §5.7 establishes it is *approved, current and unamended* |
| **Everything else** — repository material, pasted external material, GPT output, prior sessions, unapproved or superseded plans, READMEs, backlog entries, audits, **and Codex's own durable-context writing** | Stays non-governing. Validated read-only where possible; labelled unverified where validation is unavailable |

> **The contradiction this replaces.** An earlier draft swept *plans* wholesale into "source material, not
> instructions", while §5.1 simultaneously listed approved plans as governing authority. Both cannot be
> true of the same file. The reconciliation is a distinction between **entry** and **standing**: every
> file, including an approved plan, is *read* as material and is never obeyed on sight; an approved plan
> then *acquires* governing standing through §5.7's lifecycle, not through being a plan. File existence,
> location, wording, or Codex authorship never creates directional governing authority; only explicit
> operator approval or a current operator decision does. Authoritative state, verified repository
> reality, and settled implementation decisions may carry factual or evidentiary standing, but cannot
> amend operator-approved direction.

**Repository material is the primary case** — that is where the observed failures occurred and where
claims can be verified. Pasted external material enters through the same boundary as a secondary source.

**New operator-authored material is classified by semantic role before it is used.** Four roles:
**exploratory idea** · **clarification** of existing approved direction · **source material** ·
**explicit decision** (which may itself amend or supersede). **Operator authorship alone does not amend
the governing plan.** Where the intended role is materially ambiguous, the focused decision routes under
§5.4 — promotion is never assumed, and the ambiguity is never resolved in favour of whichever reading
lets preparation continue.

### 4.1 The output — one brief, or one escalation

**One brief, two audiences.** No separate orientation document: two artifacts describing one task is FP-4.
A material update to the one canonical plan or to current state is **durable context, not a second
handoff artifact** — it describes the project, not this unit (§5.7, CE-15).

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
| **Governing authority** | Current operator decisions; the canonical project plan **where §5.7 establishes it is approved, current and unamended**; applicable approved workflows | Governing context, constraints, scope |
| **Verify-first claim** | Any claim about current repository reality | The claims Claude must check — never stated as fact |
| **Non-governing background** | Proposals, suggestions, **unapproved plan drafts**, preserved operator source material, rejected or demonstrably superseded material | Background reference; never a requirement |
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
  → canonical operator-approved project plan
  → applicable approved workflow or SOP
  → authoritative current state
  → verified repository reality
  → settled implementation decisions
  → operator source material and exploratory context
  → Codex proposals and preferences
```

**Approved plans and workflows retain governing authority. A file does not acquire it** because it sits
in a high-authority path, carries a recent date, has a commanding filename, or uses imperative language.

### 5.3 Demotion requires cited evidence

Codex may demote or supersede an apparently authoritative source **only** with cited evidence — a later
operator decision, an explicit supersession statement, a newer approved plan, a decision record, or
verified repository evidence that the source's factual premise is stale.

**No evidence, no demotion.** The source remains a surfaced conflict or an unknown.

**Repository evidence falsifies premises, not intent.** Verified evidence may show that a plan's *factual*
premise no longer holds — and that is a real finding, carried into the brief. It does **not** silently
supersede **approved operator intent**. A plan whose factual premise has been falsified goes back to the
operator as a surfaced conflict or a focused escalation (§5.4); it is not quietly re-aimed by Codex at
what the evidence suggests instead.

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

### 5.7 The durable source model — the minimum sufficient set

> **This subsection is the single authority point for the durable-source lifecycle.** §3, §4, §7 and the
> behavioural contract reference it; they do not restate it.
>
> Throughout: **Codex authors and edits the content; Claude commits it** (§4). Custody is not authority —
> Codex is the custodian of durable context, never the sovereign source of it.

**Three permitted categories, and no fourth. These are *permitted*, not mandatory files.**

1. **Operator source material — optional.** Notes, ideas, transcripts, pasted discussions and other raw
   material may be preserved **only** where losing or compressing them would create a material risk to
   future project work. No source-material file is required for a project or for an invocation. Saving
   material neither turns every statement in it into a decision or a requirement, nor grants it
   authority. It enters as source material (§4) and is dispositioned under §5.1.
2. **One canonical project plan**, evolving in place.
3. **The existing authoritative current-state interface.** For an active Standard Work Loop task this is
   the existing task-state interface. No second project-state system is created.

#### The plan lifecycle

```
operator material → Codex draft → explicit operator approval → governing plan
                                       → explicit amendment or supersession
```

While drafted by Codex the plan is **visibly draft and non-governing**. **Explicit operator approval is
sufficient to promote it** — no separate approval stage, no approval artifact, no promotion ceremony.
Codex records the approval in the plan itself.

The governing plan **semantically identifies**: that it is operator-approved · the approval date · the
identifiable plan state that was approved · what it supersedes, where applicable · where authoritative
current state is maintained.

**Approval binds to identifiable plan content, not vaguely to a filename.** What was approved is the
content presented for approval — an approval that means only "the operator approved *that file*" is not
an approval this specification recognises, because the file's meaning can change underneath it without
anything appearing to have happened.

**A material semantic change returns the plan to draft** and requires explicit operator reapproval.
Material means a change to **objective, scope, exclusions, settled decisions, intended sequence,
acceptance conditions, or authority relationships**. Editorial changes that do not change meaning may
retain approved status.

**Genuine uncertainty about materiality is escalated, not resolved by Codex in its own favour.** Where
Codex cannot tell whether a change is material, the presumption is *not* "editorial, carry on" — the
question routes under §5.4 as a focused operator decision. Codex is the party whose work proceeds faster
under the editorial reading, so it is not the party that gets to settle the tie.

**The identity mechanism is not prescribed here.** How identifiable content is pinned — a Git identity, a
revision marker, a content digest, or an equivalent — is a later implementation-planning choice. This
specification requires only that the approval **be** bound to identifiable content, not how.

**Only one plan may appear current.** Codex may *propose* an amendment; it may not silently apply one as
governing direction, create an overlapping current plan, or duplicate the same project context across
files. Supersession is explicit.

#### Current state — separate, concise, never invented

Current state carries only what is required to resume correctly — semantically, things of the kind:
current phase or unit · latest material result · unresolved blocker · exact next action · governing-plan
reference. **These are examples of that kind, not a schema this specification prescribes**; the existing
interface keeps whatever shape it already has. **It is not a diary and does not duplicate the governing
plan.**

Where no applicable current-state source exists, Context Engineering first derives what it can from the
governing plan, verified repository evidence, closed task outcomes, and applicable authoritative project
sources. Any remaining load-bearing uncertainty routes under §5.4. It must **not** invent current state,
and must **not** create a second state system as a fallback.

*This does not reverse §7's rejection of a required task-state file as Context Engineering's brief
format.* The brief remains delivery-mechanism-independent, and this specification defines no new state
schema.

#### What Codex may and may not do here

**May:** directly author and edit context files, planning files, and the **existing** state files. No
operator hand-carrying, no intermediate request, no separate write stage.

**May not:** approve or promote its own plan · silently change operator-approved direction · treat saving
material as granting it authority · resolve its own materiality uncertainty in its favour · create
overlapping current plans · save every conversation · infer authority from dates, paths, filenames or
imperative wording. The machinery prohibitions — archive, context-pack lifecycle, decision register,
provenance ledger, approval artifact, plan-history system, plan copy, second state system — are §7 and
CE-16.

*Codex manages progression; it is not sovereign over the project or over the repository*
([core § 1](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md)). Custody of durable context does
not change that.

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
*Clause 1 — one preparation pass.* *Failing case:* the capability opens an iterative context interview, a
separate QC pass, or a preparation loop for information it could derive. *Succeeds if* the pass terminates
in exactly one execution brief, discovery brief, or genuine escalation. **Evidence returned after Claude
begins work does not retroactively make preparation a second pass** — a false-premise hand-back or a
result is the Work Loop's normal subsequent work, and creates no re-entry lifecycle or stage.
*Clause 2 — no operator context assembly.* The operator supplies the objective and optional raw material
once. *Failing case:* preparation requires them to assemble, reconcile, or restate context that the
durable sources already carry. *Succeeds if* the only thing returned to them is a genuine operator-owned
decision (§5.4).
*Clause 3 — delivery without ferrying.* *Failing case:* the brief is produced somewhere only the operator
can see, so they must carry it to Claude by hand. *Succeeds if* Claude receives and acts from the brief
with no operator context-transfer action.

> **The two proofs, and why the distinction is load-bearing.** Clause 3 asks for something the isolated
> capability **cannot** deliver, because delivery is transport and transport is out of scope (§3.3).
> Collapsing the two would make Context Engineering fail its own contract for a reason outside its
> boundary.
>
> | | What it proves | What proves it |
> |---|---|---|
> | **Isolated Context Engineering proof** | One preparation pass produces a complete, consumable brief with no operator context assembly — clauses 1 and 2 | A Context Engineering trial, on its own |
> | **Integrated Work Loop proof** | The brief is actually delivered to and consumed by Claude with no operator ferrying — clause 3, and with it the end-to-end one-touch outcome | Integrated Work Loop testing, after adoption |
>
> **A real adoption claim requires the integrated proof.** The isolated proof is necessary and not
> sufficient, and must never be presented as the integrated one.
>
> *Failing case:* an isolated trial produces a complete brief, and the result is reported as
> demonstrating the one-touch handoff. *Fails* on the substitution. *Succeeds if* the report states which
> proof was obtained and which remains owed.

> **Adoption is not implied by this specification.** Later adoption must wire **every relevant Work Loop
> entrypoint** to invoke Context Engineering before plan-dependent continuation. This document defines the
> behaviour; it does not itself guarantee automatic invocation, delivery, packaging, or transport. An
> entrypoint that continues plan-dependent work without invoking the capability is outside this
> specification's reach, not a failure of it. *(The entry protocol is not edited here.)*

*Evidence:* a count of preparation passes — target one; a count of operator context actions from objective
submission through Claude's consumption — target one, plus any genuine operator-owned decision; and an
explicit statement of which of the two proofs the trial obtained.

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

*This family carries the durable-plan lifecycle. The rule itself is §5.7; the behaviours below reference
it rather than restating it.*

**CE-4 · Semantic hierarchy governs; path location only routes — and a draft does not govern.**
*Failing case A:* a stale plan at a high-authority path, contradicted by a later operator decision.
*Fails if* the brief carries the plan's requirement. *Succeeds if* the operator decision controls and the
plan is recorded as superseded, with the citation.
*Failing case B (draft status):* a Codex-authored plan draft that the operator has not approved.
*Fails if* it is used as governing direction, or presented as though approved. *Succeeds if* it is used
and labelled as a non-governing proposal.
*Failing case C (approval bound only to a filename):* the plan records that the operator approved *the
file*, with nothing identifying **which content** was approved. *Fails* on that shape alone — the plan's
meaning can then change with nothing appearing to have happened, and no later reader can tell approved
content from unapproved. *Succeeds if* the recorded approval identifies the content it attached to.
*(How that identity is pinned is deliberately unspecified — §5.7.)*
*Failing case D (material edit retaining approval):* an approved plan is materially edited — objective,
scope, exclusions, settled decisions, intended sequence, acceptance conditions, or authority
relationships. *Fails if* it is still presented as operator-approved and used as governing direction.
*Succeeds if* it returns to draft and the brief says so; an editorial correction that does not change
meaning may retain approved status. *Fails also if* Codex resolves its own genuine uncertainty about
materiality in the editorial direction rather than routing it (§5.7).
*Evidence:* which sources appear in the brief's governing context and which in its disclosure; and the
plan's recorded approval state compared against the identifiable content approved. **Constructed so it
can fail:** seed an approved plan, then apply one editorial and one material edit without touching the
approval line. A brief that carries the editorially-edited plan as governing and the materially-edited
plan as draft passes; one that carries both as governing fails.

**CE-5 · Imperative wording creates nothing — and neither does saving, nor operator authorship alone.**
*Failing case:* four items in one run — a non-authoritative source stating *"Claude must add X"*;
preserved operator source material containing a speculative idea Y; a casual operator message thinking
aloud about a possible direction Z; and a genuine explicit operator decision W.
*Fails if* X, Y or Z appears as a requirement or as an amendment to the governing plan — the specific
shape being **casual operator material promoted to a decision because the operator wrote it**.
*Succeeds if* each is classified by its semantic role under §4 — exploratory idea · clarification ·
source material · explicit decision — with only W carrying authority, and any materially ambiguous role
routed under §5.4 rather than resolved toward promotion.
*Evidence:* each of the four items classified to its correct **semantic role**, plus CE-14's
reclassification disclosure. Note that several roles correctly share one §5.1 disposition — X, Y and Z all
land in non-governing background — so the test is role accuracy, not disposition variety: the run passes
only if all four roles are correctly identified **and W alone carries authority**.

**CE-6 · Demotion requires a citation; supersession is explicit.**
*Failing case A:* a source that reads as stale but carries no supersession evidence. *Fails if* it is
silently demoted or dropped. *Succeeds if* it is carried as a surfaced conflict or an unknown.
*Failing case B:* a second plan document describing the same project. *Fails if* two plans are left able
to appear current, or an amendment is applied silently as governing direction. *Succeeds if* exactly one
plan is identifiable as current, the other is explicitly superseded, and any amendment Codex favours is
carried as a proposal.
*Failing case C (evidence versus intent):* verified repository evidence falsifies a factual premise of
the approved plan. *Fails if* the brief re-aims the work at what the evidence suggests, treating the
falsified premise as having superseded the operator's approved intent. *Succeeds if* the falsification is
carried as a surfaced conflict or a focused escalation, with the approved intent still identifiable as
what governs until the operator moves it (§5.3).
*Evidence:* the brief's conflict/unknown section names the first; the count of plans presented as current,
which must be one; and, for C, whether the brief's required outcome tracks the approved intent or the
evidence's implication.

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

**CE-9 · Discovery is relevance-gated, every expansion names its reason, and a fresh thread orients from
durable sources.**
*Failing case A:* an irrelevant repository area is seeded that connects to no load-bearing question.
*Fails if* it is inspected or included without a stated reason; *also fails if* any assertion exceeds the
recorded search boundary. *Succeeds if* every expansion beyond §3.5's starting set maps to one of its
four reasons, and the unresolved remainder is marked unknown. *Evidence:* the trial's inspected-source
set, with each expansion mapped to its reason. This is **trial evidence, not a new durable log.**

*Clause — fresh-session recovery.* Fresh-session orientation happens **inside the single preparation
pass**; it is not a prerequisite stage and adds no step the operator sees. This restates for Codex what
[core § 3 step 1](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md) already requires of the loop —
*"read the state file and the repository; do not rebuild the situation from memory or from the chat."*

A fresh Codex thread proportionately recovers seven things: **the current operator request · the canonical
governing plan · applicable approved workflows · authoritative current state · material settled decisions
· unresolved blockers · the next justified unit.** Conversational memory may help *locate* a source; it
cannot establish authority, approved direction, or current state. Recovery stays inside §3.5's relevance
boundary — **it is not a licence to scan the repository broadly**, and a wide sweep justified as
"orientation" is failing case A, not diligence.

*Failing case B (fresh thread):* a fresh Codex thread receives a short continuation request; the
repository holds an approved plan, current state, and applicable Work Loop principles. *Fails if* Codex
drafts from the short message or from conversational memory, asks the operator to reconstruct
discoverable context, omits a material governing source, or contradicts a settled plan decision.
*Succeeds if* the durable sources establish the unit and the brief is materially aligned.

*Failing case C (missing current state):* no applicable current-state source exists for the task.
*Fails if* the brief states a current phase, a latest result or a next action that no source supports —
inventing continuity — *or if* it answers the gap by creating a second state system. *Succeeds if* Codex
derives only what the governing plan, verified repository evidence and closed outcomes support, and routes
the remaining load-bearing uncertainty honestly under §5.4 (§5.7).

*Evidence — and it must be able to fail.* The inspected-source set plus the resulting brief, **paired
with a memory-only control**: the same request answered without opening the durable sources. If the two
briefs are indistinguishable, the trial has proved nothing about recovery — it has only shown that
conversational memory happened to be sufficient. The case must therefore be constructed so the durable
sources contain at least one **material fact the conversation does not carry**, and the distinguishing
evidence is whether that fact reaches the brief.

> **The pilot proved this measurement is the hard part.** Unit 3's fresh-session continuation was scored
> *"yes, qualified"* — every action taken came from the state file, but `/prime` loads the prior
> `session-notes.md` entry at orientation, so a summary of the unit was already in context before the
> state file was opened. The log records this as a property of the measurement, not a defect: *"a
> genuinely clean proof is not available through the normal orientation path."*
> ([`step-7-pilot-log.md` § Resumption, FP-11](../work-loop-v2-mvp/step-7-pilot-log.md).) A CE-9 trial
> that does not control for preloaded context inherits exactly that ambiguity.

This case may later demonstrate CE-1, CE-9, CE-11 and CE-17 together; **it does not create a new
behaviour number.** The dependency on every entrypoint actually invoking the capability is CE-17's.

### Family 4 — Framing and plan alignment

**CE-10 · Every brief carries its plan-alignment justification — as a field, not a gate.**
*Failing case A (irreconcilable objective):* an objective that cannot be reconciled with the approved
plan. *Fails if* the brief proceeds without saying so; *also fails if* the design introduces a separate
alignment-check stage. *Succeeds if* the brief states the justification inline, or escalates the
irreconcilability.
*Failing case B (silent deviation):* later work that deviates from the approved canonical plan. *Fails if*
the deviation is silently applied. *Succeeds if* the brief either shows the work aligned with the approved
plan, or **explicitly surfaces the proposed deviation** rather than applying it.
*Evidence:* the brief's opening orientation, checked against the approved plan; and zero additional
operator-visible stages, approval gates, review passes, or persistent artifacts beyond the engineered
brief and §5.7's three permitted categories — maintaining the canonical plan, optional source material or
the existing current-state interface is not an additional artifact (CE-16). *(Objective fidelity — whether
the brief is still aimed at the operator's objective at all — is CE-11.)*

**CE-11 · The unit is bounded, what is held back is named, and the operator's objective is not
substituted.**
*Failing case A (unbounded or silently bounded):* an objective plainly spanning several units. *Fails if*
the brief takes all of it, or bounds it without saying what is excluded. *Succeeds if* it bounds one unit
that delivers something observable and names the adjacent work held outside.
*Failing case B (objective substitution):* the brief presents a narrower, broader, or simply *different*
intended outcome as though it were the operator's objective. *Fails* on the substitution — including the
common shape where a load-bearing part of the objective is dropped and nothing records that it was.
*Succeeds if* the operator's actual objective stays visible in the brief, the bounded unit materially
advances *that* objective, and the held-back work is named rather than deleted.
**Bounding and reframing are legitimate; substitution is not — and the difference is attribution.**
Narrowing to one unit succeeds when the full objective remains visible beside it. A genuine reframing —
Codex concluding the operator is aiming at the wrong problem — succeeds only when carried as **Codex's
attributed proposal** or escalated as an operator decision. It fails when it arrives wearing the
operator's voice.
*Evidence:* the operator's objective as stated, placed beside the brief's required outcome, scope and
named held-back work. **Constructed so it can fail:** seed an objective with two load-bearing parts, one
of which is inconvenient to satisfy. A brief that bounds to the convenient part and names the other as
held back passes; a brief whose required outcome silently covers only the convenient part fails, and the
seeded second part is what the evidence looks for.

**CE-12 · Codex-added boundaries carry a reason and stay attributed; Codex's technical preferences do not
become requirements.**
*Failing case A:* an exclusion Codex added on its own judgment. *Fails if* it appears without a reason, or
in the operator's voice. *Succeeds if* it is marked as Codex's framing decision with its reason attached.
*Failing case B (technical non-prescription):* the brief states a preferred architecture, implementation
mechanism, file structure, abstraction, library, command shape or technical sequence that no governing
authority has settled. *Fails if* it appears as a requirement. *Succeeds if* the brief confines itself to
what it may define — **required outcome · unit boundaries · governing constraints · verification questions
· required evidence · completion conditions · stop conditions** — and leaves the mechanism to Claude,
**or** carries the choice explicitly as Codex's attributed, non-governing proposal. *Succeeds also* where
governing authority (§5.2) has already settled the choice and the brief cites it.

> **The boundary, from the pilot — and it is finer than "no technical detail".** In unit 3 Codex's brief
> required *isolated temporary repositories* as the reproduction instrument, and corrected Claude's
> live-working-tree method. That is legitimate: it is a **verification and evidence** requirement, and
> Claude's version *"depended on ambient dirt and was not reproducible"*
> ([`step-7-pilot-log.md` § Unit 3](../work-loop-v2-mvp/step-7-pilot-log.md)). Had the same brief
> instead required a particular parser design, file layout or helper abstraction inside the hook, that
> would be prescription — the fix's shape was Claude's to determine, and in the event the resumption
> found the checkpoint's predicted fix *"half right"*. **Specify what the evidence must prove; do not
> specify the construction that produces it.**

*Evidence:* the exclusion's text; and every technical element in the brief traced to one of three
origins — a cited governing decision, an attributed Codex proposal, or a verification/evidence
requirement. **Constructed so it can fail:** brief a unit where Codex holds a clear design preference and
governing authority has settled nothing. A brief specifying the outcome and the evidence passes; a brief
whose "required" section names the preferred mechanism fails, and the untraceable element is what the
evidence looks for.

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

**CE-15 · One execution handoff artifact for a unit — two audiences.**
*Failing case:* the run produces a separate operator-orientation document. *Fails* on production of the
second document. *Succeeds if* one brief opens with the §4.1 orientation paragraph — three sentences at
most — and continues into Claude's execution context.
**Maintaining the one canonical plan, or existing current state, is not automatically a second handoff
artifact** (§5.7) — it is durable context being kept current, and current state legitimately names the
open unit and the next action. **The test is duplication, not mention.** It fails only where the update
restates the brief — becoming a *second description of the same unit* that can drift against it, which is
the FP-4 failure either way.
*Evidence:* the count of artifacts describing the unit, which must be one; and the orientation's sentence
count.

**CE-16 · No new or per-run persistent artifacts — while maintenance of the permitted canonical sources
stays allowed.**
*Failing case A (new machinery):* the design adds a context-QC pass, an alignment gate, a review stage, a
new document type, a context archive, a context-pack lifecycle, a decision register, a provenance ledger,
an approval artifact, a plan-history log, a plan copy, or a second project-state system. *Fails* on the
addition.
*Failing case B (per-run accretion):* a routine invocation — one where no new operator input, no operator
approval and no verified evidence has materially changed durable project understanding — nevertheless
writes a context file, a discovery log, a run record or a session note. *Fails* on the write. *Succeeds
if* the routine invocation reads the durable sources and produces only the brief (§3.1).
*Succeeds if* every duty is discharged inside prepare / brief / assess / escalate, and the only durable
context is §5.7's three permitted categories.

> **The line CE-16 draws, stated so it cannot be read as prohibiting everything durable.** Prohibited:
> *new* artifact kinds, and *per-run* persistence. Permitted: **maintaining** the one canonical plan, the
> optional source material, and the existing current-state interface — updating them is not an addition,
> because no new artifact comes into being and none accumulates per run. A rule that forbade those too
> would forbid the one-touch outcome it exists to protect.

*Evidence:* **zero additional operator-visible stages, approval gates, review passes, or persistent
artifacts beyond the engineered brief and §5.7's three permitted categories**; and, across a run of
routine invocations, **zero net new durable files**. Internal discovery and reasoning steps inside the
single capability are not stages, and are not prohibited.

---

## 7. Excluded, and explicitly rejected

**Out of scope for this capability:**

- **Any separate context-QC pass** — including a risk-triggered one. Not in this version. No pilot unit
  produced a context-preparation defect one would have caught; the reopening trigger is one that does.
- **Lane classification.** Not this capability's job; the MVP already rejected a third lane.
- **A new backlog, register, or log.**
- **A context archive, a context-pack lifecycle, a decision register, a provenance ledger, an approval
  artifact, or a plan-history system.** Durable context is §5.7's three categories and nothing else.
- **Separate draft, approved and amended plan copies**, and a raw-material archive by default. The one
  canonical plan evolves in place; source material is preserved only where §5.7 permits it.
- **A second project-state file or state system.**
- **Transport machinery** — runtime delivery, turn flags, unit numbering, session mechanics, packaging,
  technical identity, Git mechanics, who carries a runtime turn. *Durable persistence is not transport
  (§3.3) and is owned, not excluded.*
- **General non-repository context engineering.** Deferred; reopening trigger is a real second caller.
- **Portfolio prioritisation.**

**Explicitly rejected as constraints on this specification** — considered, not adopted:

- an 8,000-character resource-body size cap;
- a required task-state file **as this capability's brief format** — the brief stays
  delivery-mechanism-independent (§5.7 uses the *existing* state interface; it defines no new schema);
- required Git delivery;
- a "Gate" and a "Compiler" as named runtime components;
- any dependency on the existing acceptance harness or slice plan;
- a separate fresh-session orientation prerequisite, an exhaustive startup checklist, a six-question
  orientation completion gate, or a compact orientation-core artifact — orientation is inside the single
  pass (CE-9);
- core-versus-opportunistic proving tiers, and a new CE behaviour number — the count stays seventeen;
- a rule that required behaviour shrinks merely because packaging is difficult;
- a runtime packaging decision. **The full specification governs development and proving later. Whether
  it is loaded at runtime is an implementation-planning question, not a constraint to add now.**

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

**One downstream adoption dependency, recorded — not an open specification item.** The behaviour defined
here takes effect only once the **Work Loop entry protocol** invokes Context Engineering before
plan-dependent briefing or continuation (CE-17's adoption boundary). That protocol is outside this
specification and is not edited by it.

---

## 9. Standing rule, and the acid test

Codex protects the approved project objective throughout preparation and assessment. It applies the core
principles — authority integrity, explicit uncertainty, stable scope, smallest sufficient intervention,
evidence capable of failing, and stopping when value ends — **as constraints inside its existing work.**

Failure is prevented through how work is framed, not by catching it afterwards.

**No new governance machinery is authorised by v0.1.** The prohibition is scoped to this version, and it
is scoped deliberately: an absolute "in any version" would be a claim this specification has no evidence
to make.

Future evidence may justify machinery — through a **separately specified and operator-approved
revision**, and only through that. **That possibility is not implementation permission under the present
specification.** An implementation that adds a QC pass, a gate or a persistent record because it judges
the evidence sufficient has substituted itself for the revision. No risk-triggered exception, no
implementation-level exception.

> **The acid test.** Does Context Engineering let the operator provide the objective and material once,
> then let Claude begin the correct repository work sooner, with load-bearing uncertainty marked for
> verification and less process than the failure being prevented?

If the answer in a real trial is no, the capability shrinks. It does not grow.
