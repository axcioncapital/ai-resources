---
name: capability-development
description: >
  The method for developing an operating capability — a business, operational or
  product ability inside a project that already exists. Defines what a capability
  is, the five phases (Frame, Shape, Build, Prove, Land), the intervention ladder,
  trial design and its stop condition, owner and seam selection, slice standards,
  the evidence-to-claim rule, lifecycle-decision standards, data handling, and the
  capability-specific route triggers. Read by `/work-loop` when, and only when, a
  unit is a capability unit. Not a build engine and not an orchestrator: it holds
  method only. Do NOT use for authoring a new durable AI artifact (that is
  `/develop-ai-resource`), for deciding whether a project should exist (that is
  `/scope-project`), or for ordinary defect and documentation work (that is
  `/work-loop` with no capability route).
model: opus
effort: high
disable-model-invocation: true
---

# capability-development

This skill is **method, not machinery.** It says how a capability is developed well. It says nothing about how work is tracked, resumed, reviewed in transit or closed on disk — that is the process contract at `docs/work-loop.md`, and `/work-loop` is its executor.

**Never invoked directly.** `disable-model-invocation: true` is set deliberately. A capability is developed through `/work-loop`, which reads this file when a unit classifies as a capability unit and ignores it entirely otherwise. If you have arrived here without a unit, you are in the wrong place: state the need to `/work-loop`.

**Read `docs/work-loop.md` alongside this file, never instead of it.** That contract owns the loop's eight steps, route classification, artifact rules, and everything about how work is carried between models. Where this file and the contract appear to disagree, the contract wins on process, this file wins on method, and the disagreement is a defect to report.

---

## Boundary sentences

> **Outcome versus artifact.** `/work-loop` with `capability-development` owns the operating outcome. `/develop-ai-resource` owns the artifact. The skill is not the capability; it is one implementation component.

> **Capability versus project.** A capability lives inside a project that already exists. A project is a new domain with its own deliverables.

> **Goal versus development record.** `logs/missions/{id}.md` answers *what multi-session goal is this serving, and is it drifting?* `development/{slug}.md` answers *what is this capability, where does it stand, what happens next?*

---

## What an operating capability is

An **operating capability** is an ability the business exercises repeatedly to produce a result — preparing a buyer email that is actually sendable, deciding whom to contact and when, turning a source pack into a defensible screening view. It is defined by the **outcome it produces**, never by the machinery that produces it.

Three consequences follow, and they govern everything below.

1. **A capability is stated as a result, not a system.** If the need arrives naming a system ("we need a drafting skill"), restate it as the outcome ("one reviewable buyer email from an approved record") and say plainly that you have restated it. The restatement is frequently where the real disagreement surfaces.
2. **A capability is not its artifacts.** A skill, a template, a checklist and a habit are all implementation components. Any of them may be replaced without the capability changing. This is why an artifact decision never settles a capability question, and why a capability that produces *no* artifact is a legitimate and common outcome.
3. **A capability has an owner and a boundary.** Something that no existing project can legitimately own is not a capability inside a project — it is a new domain, and it leaves this method (see § Handoffs).

**What this method does not develop:** a new durable AI artifact (route to `/develop-ai-resource`), a new project or enduring programme (route to `/scope-project`), a fault in something that already works (that is ordinary `/work-loop` defect work, no capability route), or a multi-session goal contract (`/mission` owns that and is its only writer).

---

## Route triggers

`docs/work-loop.md` § Route triggers owns the **universal** triggers that apply to every unit of any type. **That file is their sole owner. This file cites it and does not restate any part of it.** Classify against the universal set first; what follows is *additional* and applies only to capability units.

Any one trigger fires its route. Ambiguity resolves **upward**, never downward — the same fail-safe posture the universal set uses.

### Challenged — any one fires

| # | Trigger | Test |
|---|---|---|
| **H1** | **External or shared system integration.** The capability reads from or writes to a system outside the owning project in normal operation — CRM, Gmail, Notion, an API, another Axcíon project's tree, another tool in the ecosystem. | Name the system and the direction of flow. A one-off manual copy-paste by a human is not an integration. |
| **H2** | **Real confidential data in normal operation.** Buyer, client, relationship, deal or commercially sensitive information flows through the capability when it runs — not merely during a trial. | Name the data class and its authoritative source. |
| **H3** | **Two or more consumers, or a second project must change.** Another project, workflow or person other than the owner depends on it, or must alter its own artifacts to accommodate it. | Enumerate consumers. "Might be useful to others" is not a consumer. |
| **H4** | **Difficult reversibility.** Undoing it after adoption costs more than reverting a commit — published artifacts, external records, sent communications, data migration, or a working habit others build on. | State the concrete undo procedure. If you cannot state one, H4 has fired. |
| **H5** | **Canonical ownership change.** The capability claims, moves or contradicts a responsibility that another project's authority document currently holds. | Cite the authority document and the clause. |
| **H6** | **Shared infrastructure.** The capability **creates or changes** something used beyond the owning project. | Name what is shared and who else consumes it. **Read the note below before classifying — do not treat this as fully covered by the universal set.** |

**Note on H6 and the universal set — read this before deferring to it.** The two halves of H6 do not behave the same way against `docs/work-loop.md` § Route triggers, and treating them as one is how a capability gets silently under-routed.

- **Creating** shared infrastructure is already covered: it lands on the structural class list that section cites, so the universal set fires challenged on its own. Here H6 adds nothing — classify from the universal set and move on.
- **Changing** something already shared does **not** fire universally as challenged; it fires as *universal reviewed*. **H6 raises it to challenged for capability units**, and that difference is the whole reason this trigger is stated rather than deferred.

Note that the split is by **kind of act** — create versus change — not by which members are on the list. Do not learn the list from this file; it has one owner and `docs/work-loop.md` § Route triggers is the only route to it.

The justification is blast radius, not novelty: a capability that rewires an existing shared resource reaches every consumer exactly as a new one does, and it does so without the visibility a new file has. A capability normally discovers this through its consumer inventory (H3) rather than through a diff, so re-test H6 at the moment that inventory is built.

**Do not evaluate a local copy of the structural class list** — `docs/work-loop.md` § Route triggers cites its owner, and that citation is the only route to it.

### Reviewed — any one fires, when no challenged trigger fired

| # | Trigger | Test |
|---|---|---|
| **M1** | **The operating workflow is not demonstrated.** Nobody has produced the intended result this way, even by hand. The operating model is a hypothesis. | Has one real case been run end to end and the result observed? If no → M1. |
| **M2** | **Three or more distinct behaviours, or work plainly spanning sessions.** | Count the behaviours the capability must exhibit, not the files it touches. |
| **M3** | **Ownership is ambiguous.** More than one project could plausibly own it, or it depends on a sibling project's authority document. | § Owner selection criteria 1–2 did not discriminate cleanly. |
| **M4** | **It needs an AI artifact that does not exist.** A handoff to `/develop-ai-resource` is required. | The artifact must be authored, not merely used. |
| **M5** | **Verification needs more than reading the diff.** A trial, a real record, or comparison against a written standard is required to know it works. | Can a human confirm correctness by looking at the output alone? If no → M5. |

### Solo — the residual

No challenged and no reviewed trigger fires. Concretely: one owner, one project, a workflow already understood, reversible by reverting a commit, one or two behaviours, no external system, no confidential data in operation, no new AI artifact, and verification is "look at the result."

**Solo still performs the whole lifecycle** — outcome, reality inspection, no-build consideration, observable behaviour, one complete slice, proportionate verification, demonstrated use, lifecycle status. It does all of it at the lightest depth. Depth is what the route changes; **presence is not.**

### Escalation and de-escalation

**Escalation is additive.** Nothing already produced is discarded. Re-test the route at every phase boundary, and always on discovering any of: a second consumer · an external system · real confidential data · an irreversible step · a conflicting authority document. Re-testing is cheap and silent when nothing changed.

**De-escalation requires a trigger to be disproven by evidence**, not merely doubted. It may occur only at a phase boundary, and never after an operator stop has approved the heavier route for that phase. State the evidence that disproves each trigger.

**Nothing is discarded to make a route change look clean.** Work already done under the heavier route stands; it simply stops accruing heavier obligations.

---

## The intervention ladder

Before building anything, walk the ladder from the bottom and **stop at the first rung that would actually work.** Name the rung you stopped on and why not the one below it. This is a required output of Frame, not a formality.

1. **Accept the limitation** — the cost of living with it is lower than the cost of removing it.
2. **Change an operating habit** — a person does something differently; nothing is built.
3. **Clarify ownership or information flow** — the work was blocked by ambiguity, not capability.
4. **Reuse an existing capability** — something already does this, possibly under another name.
5. **Simplify or remove the source** — the need exists only because of complexity that can go.
6. **Narrow local improvement** — a small change to something that already exists.
7. **Bounded experiment** — a time-boxed or scope-boxed trial with a defined end.
8. **Build** — permanent new capability.

**A no-build, manual or reuse outcome is a success, not a failure.** It exits Frame directly to Land. The method's value is as much in the capabilities it declines to build as in the ones it builds — and the ladder is the instrument that produces those declines.

**Search by purpose and behaviour, never by name, for rung 4.** Disposition every near-match explicitly as **covers it · covers part of it · adjacent but different**, each with a path. Finding that the need is already served is the cheapest possible good outcome.

---

## Ownership and seams

### Owner selection — the procedure

When a capability touches more than one project, apply these four criteria **in order** and stop at the first that discriminates:

1. **Which project owns the primary operating outcome?** — the project whose deliverable or responsibility the capability directly produces.
2. **Which project owns the capability's continuing decisions and maintenance?** — where the next ten judgment calls about it will be made.
3. **Which authoritative source should define its behaviour?** — the project holding the document that governs how it must work.
4. **Which project would still own it if one dependency were replaced?** — swap the CRM, swap the mail system; who is left holding it.

Four rules bind the procedure:

- **Dependencies never become co-owners.** A capability that reads from a CRM does not make the CRM project a co-owner; it makes the CRM an external dependency recorded in the seam.
- **Evidence, not names.** Every ownership conclusion cites the specific file and line supporting it — a project `CLAUDE.md` clause, an authority order, a standing prohibition. A directory name is not evidence.
- **Absence is not evidence.** An empty directory, an unpopulated table cell or a search that found nothing is evidence *about that source*, never a positive fact about ownership. Treat a null result as a question, not an answer — and when an absence-claim is load-bearing, as a consumer inventory always is, confirm the search was not simply blind (`docs/audit-discipline.md:52`).
- **Route out when no project qualifies.** If the criteria leave no legitimate owner, or selecting one would create a new domain, Frame ends in the new-project handoff. This is a **conclusion, not a default** — state which criterion failed and why.

### The seam

The seam is the capability's public boundary, stated in seven fields:

**Input · Output · Owning capability · External dependencies · Observable failure states · Side effects · How behaviour is tested.**

Keep it small enough that the operator never has to coordinate internals. At the challenged route, state the seam at **two** levels:

- the **technical seam** — interfaces, data, failure states;
- the **operating seam** — who decides what, which system is the official record, and what a human must approve before the capability's output has effect.

An operating seam is what makes a consequential capability governable. It is the difference between "the model drafts an email" and "the model drafts an email that a named person approves before anything is sent."

---

## The five phases

Every route runs all five. **The route changes the depth, never the presence.** A phase whose depth at this route is one sentence is still answered, not skipped.

### Frame — *what is the need, who owns it, and is it in scope at all?*

1. **State the operating outcome** in one sentence, as a result.
2. **Inspect current reality before planning.** Read budget: **four** files at solo, **twelve** at reviewed and challenged. Exceeding the budget is reported as a finding, never treated as permission to keep reading.
3. **Separate confirmed facts (each with a path) · reasonable inferences (each with its basis) · unknowns (each with what would close it).** Two lines each is normal at solo.
4. **Walk the intervention ladder** and name the rung.
5. **Disposition existing capability** (reviewed and challenged) — search by purpose, disposition every near-match with a path.
6. **Select the owner** and cite the clause that establishes it.

At challenged, Frame additionally produces:

- a **consumer inventory** — every project, workflow, document, external system and person that depends on this or must change for it, enumerated explicitly, grep-based where possible;
- an **authority inspection** — for every project touched, the specific clause granting or denying ownership;
- a **reversibility statement** — the concrete undo procedure for each irreversible-looking step. If none can be stated, H4 is confirmed;
- a **data-flow statement** if H2 fired — which data class, which system holds it authoritatively, where it flows, what may and may not leave Axcíon's boundary, and what may go to which external model or tool.

**Exit:** outcome, evidence, ladder rung, owner and route are all stated. A no-build, manual or reuse outcome exits here to Land and is a success.

### Shape — *what exactly will be done, and what would falsify it?*

7. **Terminology** — define only the terms that are genuinely consequential and could mean two things. Each term means one thing; two concepts never share a name.
8. **Ownership and seam** — recorded per § Ownership and seams.
9. **Real-case trial** — required when M1 fired; mandatory at challenged unless the workflow is already demonstrated in production. See § Trial design.
10. **The implementation package** — verified need · intended outcome · users · public interface · observable behaviours · ownership and dependencies · smallest useful version · exclusions · verification · adoption condition · retirement condition.

    It states outcome, boundaries, behaviour, evidence and exclusions. **It does not dictate functions, files or abstractions** — those follow from inspecting the repository, and a package that specifies internals is precisely the failure this method exists to prevent. At solo the package is three lines: owner, observable behaviour, exclusions. At challenged it is durable, versioned and operator-approved.
11. **Vertical slices** — two to five complete behaviours, ordered. See § Slice standards.
12. **Name every AI-artifact handoff now**, not mid-build.

**Exit:** the package is complete, the slices are ordered, and the first slice is a complete behaviour.

### Build — *one slice implemented, repeated per slice*

13. Per slice: **reproduce-or-fail → implement → refactor → verify.**
    - *Reproduce or fail* — create a behavioural check or a reproducible failure and confirm it fails for the expected reason.
    - *Implement* — the smallest coherent change satisfying the behaviour.
    - *Refactor* — naming, boundaries, duplication, while behaviour stays green.
    - *Verify* — the targeted check, relevant surrounding checks, and a representative runtime or operator-path demonstration.
14. **Scope discipline.** Adjacent improvements are not added. A material scope change is a new decision, not a longer diff. If it alters the seam or the exclusions, re-test the route.
15. At challenged, **failure and recovery behaviour is implemented as a slice**, not documented as an intention. A control that has never run in its real invocation path does not count as implemented.

**Exit:** every slice has a failing case, a correction and verification; nothing outside approved scope changed.

### Prove — *did it work, judged against what Shape said would falsify it?*

16. **Both self-review questions, kept separate.** See § The two self-review questions.
17. **Match evidence to claim.** See § Evidence to claim.
18. **Independent review at the depth the route requires.** `docs/work-loop.md` § Route triggers → Route → depth → stops owns which review happens at which route and how it is carried. This file owns only the standard: a review that could not reach its object is recorded **unassessed**, never passed, and a same-model check is never described as independent.
19. **Simplify.** Remove instructions, content or machinery that do not contribute to the demonstrated behaviour — then re-run every materially affected case.

At challenged, Prove additionally requires **behavioural, integration, failure and recovery testing**: integration tests exercise the real seam, failure tests confirm the capability fails visibly and recoverably, and recovery tests confirm the stated undo procedure actually works.

**Exit:** both questions answered, every claim marked, review outcomes recorded.

### Land — *adopt, hold or reject*

20. **Real use.** The capability enters its real operating environment and is used at least once for its actual purpose. The outcome is observed. **Technical completion is not project completion.**
21. **The lifecycle decision.** See § Lifecycle decisions.
22. At challenged, the **retirement condition and rollback method are restated** at the decision — a consequential capability that cannot later be removed is a permanent liability.

---

## Trial design and its stop condition

A trial exists to answer whether the operating workflow produces value **before** permanent work is committed to it. Design one real case to answer six questions:

1. Does the workflow produce a genuinely useful result?
2. Can the operator actually use it?
3. What information is actually needed — as opposed to assumed to be needed?
4. Which assumptions turned out to be wrong?
5. Where are the real boundaries?
6. Is permanent work still justified?

Run it by hand or with temporary tooling. Use real data only when the claim genuinely depends on real operating context; synthetic otherwise. Apply § Data handling throughout.

**The stop condition is real and is the point of the exercise: a trial that does not produce a useful result stops the build.** Record the observed result — including a negative one — and re-enter the intervention ladder. No-build remains available all the way to here.

A trial that "sort of worked" is not validation. Either the result was useful or it was not; if that cannot be answered, the trial was not designed against an observable outcome and should be re-run, not interpreted.

---

## Slice standards

A slice is a **complete behaviour**, end to end, useful on its own.

A well-formed slice is:

- **independently understandable** — a reader grasps what it does without the others;
- **independently testable** — it has its own failing case before it has an implementation;
- **small enough to review** in one sitting;
- **useful end to end** — it produces a result, not a layer;
- **separately committable** — and is committed before the next begins, so a failure discovered three sessions later costs at most one slice of rework.

**Slicing by layer is wrong and must be re-planned, not rationalised.** "All the schemas, then all the logic, then all the tests" produces nothing usable until the last slice lands, hides integration failures until the end, and makes every intermediate state unreviewable. If the work genuinely cannot be expressed as two to five complete behaviours, that is evidence the outcome is not yet understood — return to Shape.

---

## Evidence to claim

**Evidence must match the type of claim.** This is the governing verification rule at every route.

| Claim type | What evidences it |
|---|---|
| Runtime behaviour | Execution — the thing was run and the result observed |
| File scope | The diff |
| Compatibility | A representative test |
| Factual assertion | The source, cited |
| Usage / absence | Every relevant location checked, with a positive control |

Three rules bind it:

- **A control that cannot run is reported `unassessed`, never `passed`.** Operational reality overrides documented status.
- **A file existing, a status field reading complete, or documentation asserting a control is active evidences none of it.** The claim is that the control *works*; only its real invocation path shows that.
- **A negative result is not evidence until a positive control has shown the check can detect what it looks for.** An empty search and a broken search are indistinguishable without one.

Mark every claim **observed · unassessed · blocked**. An honest `unassessed` is worth more than an optimistic `observed`, because the next reader acts on it correctly.

---

## The two self-review questions

Asked separately, always, at every route. Merging them is the failure this separation exists to prevent.

**1. Is it well made?**
Clear purpose and scope · small, understandable interface · one owner per responsibility · no duplicated behaviour · proportionate architecture · tests coupled to outcomes rather than internals · every control demonstrated in its real invocation path · anything removable removed · no unrelated scope entered · work recoverable.

**2. Does it belong in the system?**
The capability is still justified · the mechanism is still the smallest reliable one · it duplicates and conflicts with nothing · it references rather than copies authoritative context · consumers and handoffs are clear · maintenance cost is proportionate · it can be removed cleanly.

**A well-made thing can still be the wrong thing to own.** Question 1 cannot answer question 2, and a strong answer to 1 is often what makes 2 hard to ask.

---

## Adjudicating findings

Findings from any independent review are **claims to be tested, not implementation instructions.** Verify each against the repository before acting on it.

`docs/work-loop.md` § Block formats owns the disposition vocabulary and requires exactly one disposition per material finding. This file owns the standard for choosing among them:

- **Accept and fix** when the finding is verified against the object.
- **Accept and defer** when it is verified but genuinely out of scope — with a concrete reopening trigger: a date, a quarter, or a named event. "Later" is not a trigger.
- **Reject** only with the evidence that disproves it. Disagreeing with a finding does not dispose of it.

Only disagreements turning on **business risk or maintenance burden** reach the operator. Technical disputes are settled by evidence first.

A reviewer that redesigns the solution has exceeded its brief; take the finding, discard the redesign, and do not adopt a parallel design that no one qualified.

---

## Lifecycle decisions

Every capability ends at exactly one status. **Inactivity is not among them** — a capability left `in-development` after work has stopped is the single most common failure of this method.

| Status | Class | Means | Requires |
|---|---|---|---|
| `in-development` | **ACTIVE** | Work is under way | — |
| `continue-trial` | **ACTIVE** | Promising, not yet proven | A named next observation and a date |
| `revise` | **ACTIVE** | The outcome is right, the implementation is not | The specific defect |
| `paused` | **ACTIVE** | Deliberately stopped, resumable | A concrete reopening trigger — a date, a quarter or a named event |
| `adopted` | TERMINAL | In real use and staying | Observed real use — never asserted |
| `keep-local` | TERMINAL | Useful to this project only | An explicit decision not to generalise |
| `closed` | TERMINAL | Purpose achieved; nothing further intended | — |
| `retired` | TERMINAL | Withdrawn from use | The machinery removed, and a record of what was removed |
| `rejected` | TERMINAL | Should not exist, or ownership routed elsewhere | The reason, kept as evidence the question was answered |

**ACTIVE-STATUS-SET** = `in-development` · `continue-trial` · `revise` · `paused`.

**The status literals above are exact.** They are what `templates/capability-record.md` enumerates and what any consumer matches on; the imperative forms ("adopt", "close") name the *decision*, never the recorded value.

**Anything discovering capabilities matches the whole ACTIVE set, never a single status.** This is the difference between a capability that can be picked up again and one that is invisible: `continue-trial`, `revise` and `paused` all mean *more work is expected*, and a consumer filtering on `in-development` alone cannot see any of them. A `paused` record with no reopening trigger is **malformed** — report it, never auto-repair it, because a park with no trigger never drains.

**Reaching a TERMINAL status is the only way to leave the active set.** A record is never moved or deleted to close it.

Two standards bind the decision:

- **Never mark adopted without observed real use.** Adoption is a claim about the operating world, and only the operating world evidences it.
- **Retirement that leaves the machinery in place is not retirement.** Remove it, and record what was removed.

**Rejection is a first-class outcome.** A rejected capability keeps its record — that record is the evidence the question was asked and answered, and it is what stops the same idea returning every quarter as if new.

---

## Data handling

**Confidential material never enters the repository — in any directory, gitignored or not.** It stays in its source system, in an external tool, or in an explicitly created OS temporary directory outside the repository:

```bash
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp}/axcion-capability-XXXXXX")
```

State `WORKDIR` in chat so the operator can find it, and **delete it when the unit closes** — `mktemp -d` persists until the machine reboots, so a directory holding buyer data outlives the work that needed it unless removal is an obligation rather than a suggestion. If it must survive the unit, say so explicitly and say why.

**`WORKDIR` is for *trial* material only.** Review and brief material never goes there — it is redacted at the source so it carries no confidential context, and it then lives where `docs/work-loop.md` § Artifacts puts it, like every other artifact. Diverting a review out of the artifact chain would break the correlation and immutability rules that section depends on; the fix for confidential review content is redaction, never relocation.

**"Put it in the scratchpad" is not a safe instruction in this workspace, and the reason is worth stating.** `logs/scratchpads/` is gitignored but sits *inside* the repository tree. Gitignored is not outside: one forced stage or one `.gitignore` edit exposes it, and nothing warns. A rule that says "keep it out of the commit" permits an uncommitted file full of buyer data sitting in the working tree. The rule below is therefore about the **repository boundary**, not the commit boundary.

| Rule | Applies at |
|---|---|
| **Confidential material stays in its source system, an external tool, or `WORKDIR` — never any path inside the repository** | all routes |
| **Never copy raw buyer, CRM, email or relationship data into any artifact under the repository** | all routes |
| Review and brief material is **redacted so it never carries confidential context** — decisions, schemas, evidence summaries and redacted or synthetic examples only | reviewed, challenged |
| Use the minimum necessary record | reviewed, challenged |
| Prefer anonymised or synthetic data when it tests the same behaviour | reviewed, challenged |
| Name the authoritative source for every data class | reviewed, challenged |
| Durable records carry decisions, schemas, evidence summaries and redacted or synthetic examples only | reviewed, challenged |
| Name the system that remains the official record | challenged |
| State explicitly what may and may not be sent to which external model or tool | challenged |

---

## Handoffs this method requires

Each handoff states what triggers it, what goes out, what comes back, and what must not happen. `docs/work-loop.md` § Execution boundary owns the two terminal route-outs; this section owns what the capability must have established before handing over.

**To `/develop-ai-resource` — a slice needs an AI artifact that does not yet exist.**
Out: a brief carrying the settled upstream context — operating outcome, need validation, ownership and seam, and the fact that the adoption decision is held here. Back: the artifact's disposition and what was tested. **Must not:** never author the artifact inside this method, and never let the artifact's disposition stand in for the capability's adoption decision. If the disposition is defer or delete, that is a **material scope change** — record it and re-test the route.

**To `/scope-project` — owner selection found no legitimate owner, or the work is a new enduring programme.**
Out: the Frame output, including which owner-selection criterion failed. Back: nothing; this is terminal. **Must not:** do not create the project, and do not hold the capability open pending one.

**Not a third route-out: later graduation to shared.** `docs/work-loop.md` § Execution boundary defines **exactly two** terminal route-outs, and this is not one of them. When something built project-local should later become shared, that is a **separate decision taken outside this method**, by `/graduate-resource`, on its own schedule — the capability does not stay open waiting for it. What this method owes that later decision is only the evidence it will need: the consumer list, and which consumers were actually confirmed. **Never generalise on a single confirmed consumer, and never graduate from inside this method.**

**Never write into another project's tree**, even when the capability depends on it. A dependency that must change is a **seam decision surfaced to the operator**, not an edit made on their behalf.

---

## Worked examples

Six cases, chosen because each tests a different boundary.

**1 — Solo stays light.** A screening checklist inside one project gains two questions the operator already asks by hand. One owner, one project, reversible, verification is reading the result. No trigger fires. Frame through Land happens in one pass, at conversational depth, and the only durable trace is the changed checklist itself. *Tests: depth scales down without any phase being skipped.*

**2 — Confidential data forces challenged.** "Prepare a sendable buyer email from an approved record." H2 fires — real buyer and relationship data flows in normal operation — and H1 fires if it reads the CRM. Challenged: consumer inventory, data-flow statement naming what may never leave the boundary, an operating seam with a named human approver, failure slices, and a mandatory trial on synthetic data first. *Tests: the triggers that matter most fire on consequence, not size.*

**3 — Missing authority must stop, not draft.** The same capability meets a contact whose record shows no permission to approach. The correct behaviour is to **stop visibly**, not to produce a draft with a caveat attached. This is a failure state named in the seam and implemented as its own slice, and its evidence is the real invocation path — a documented intention here is worth nothing. *Tests: failure states are built, and evidence comes from the path that actually runs.*

**4 — Non-software capability.** "Decide whom to contact and when" produces decision rules and a standard, not code. Every phase applies unchanged: the outcome is a result, the seam names who decides what, slices are complete decision behaviours, and the trial runs the rules against real past cases. *Tests: the method does not assume software.*

**5 — No-build is the outcome.** "We need somewhere to track which sources were already checked." Frame's ladder stops at rung 4: an existing project log already records this, unused because nobody knew. The outcome is a habit change and a pointer. Nothing is built; the capability's status is `closed`. *Tests: the ladder produces declines, and a decline is a success.*

**6 — Mid-run escalation.** A reviewed capability reaches Build, and the second slice turns out to need a second project's artifact to change. H3 fires now. Escalation is additive: everything built stands, the route becomes challenged, the heavier obligations begin from the current phase, and the operator stop the challenged route carries arms immediately. Nothing is discarded and nothing is back-filled quietly. *Tests: the route is a live judgment, re-tested at every boundary.*

---

## SOP step → phase mapping

The thirteen-step Capability Development SOP is an **operator-supplied document that does not live in this repository** — it was an input to this method's design, not a file a reader can open here. The mapping below is retained because it shows where each of its steps landed; it is a design trace, not a claim you can verify from the repository.

| SOP step | Phase | Solo | Reviewed | Challenged |
|---|---|---|---|---|
| 1 — State the operating outcome | Frame | one sentence | one sentence | one sentence |
| 2 — Inspect current reality | Frame | ≤4 files | ≤12 files | ≤12 + consumers + authority |
| 3 — Choose the smallest intervention | Frame | name the rung | + disposition near-matches | + consumer-aware disposition |
| 4 — Test the workflow before building | Shape | escalates | required when M1 fired | mandatory unless demonstrated |
| 5 — Language, ownership, seams | Shape | owner only | full seven-field seam | + operating seam, authority cited |
| 6 — Thin implementation package | Shape | three lines | eleven fields | durable, versioned, approved |
| 7 — Select review depth | Frame/Shape | † | † | † |
| 8 — Plan vertical slices | Shape | one slice | 2–5 ordered | + failure and recovery slices |
| 9 — Implement one behaviour at a time | Build | ✓ | ✓ | ✓ |
| 10 — Review your own implementation | Prove | inline, both questions | recorded | recorded |
| 11 — Independent review and adjudication | Prove | † | † | † |
| 12 — Deliver and operate the result | Land | demonstrate once | real use, observed | controlled release, observed |
| 13 — Make the lifecycle decision | Land | ‡ | ‡ | ‡ |

**†** Review depth and the number of operator stops per route are owned by `docs/work-loop.md` § Route → depth → stops and are deliberately not restated here. What this file owns is the *standard* for what comes back — § Adjudicating findings, above.

**‡** What the decision contains is § Lifecycle decisions, above. Which operator stop carries it, at which route, is owned by `docs/work-loop.md`.

---

## What this skill never does

- **Never runs itself.** `disable-model-invocation: true`. It is read by `/work-loop` for capability units and by nothing else.
- **Never orchestrates.** It does not track work, resume it, carry it between models, or close it. `docs/work-loop.md` owns the process and `/work-loop` executes it.
- **Never restates the universal route triggers.** They have exactly one owner and this file cites it.
- **Never authors an AI artifact.** That routes to `/develop-ai-resource`, which owns the artifact and returns its disposition here.
- **Never creates a project**, and never writes into another project's tree.
- **Never writes a mission file.** `/mission` is the sole writer of `logs/missions/{id}.md`.
- **Never calls a same-model check independent**, and never reports an unrun control as passed.
