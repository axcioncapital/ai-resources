# Routing and admission

**Read this when routing a new request or a Continue move.** Read it together with the
routing index, which the main skill links directly and which holds the route inventories —
this file never routes you there, so neither is reached only through the other.

**Contents**
- Routing a request — the five ordered steps and the three kinds of owner
- Repository problems
- Classifying the mode — the operator-calibrated worked examples
- What an intake result contains
- The routing index
- Admission — Direct Work or the loop

## Routing a request — who owns the next move

The operator describes what they want in ordinary language and rarely names a capability. Route it before anything else, in this order:

1. **Interpret the desired outcome and its object** — what should be different afterwards, and to what. Not the remedy they proposed; the outcome behind it.
2. **Choose one owner** — the single capability whose purpose covers that outcome. Read
   the routing index — which the main skill links directly alongside this file — complete before you
   name it; the inventories are there and this file carries no copy
   of them (§ The routing index below).
3. **If the Work Loop is the owner** — and only then — **run the resolver the core-resolution
   reference owns — the main skill links it directly — and read
   exactly the absolute file it returns now, before your first Work-Loop-owned move.** Then apply the
   Direct-versus-Standard admission test (Admission below). Where any other capability owns it,
   admission does not arise and the core is not resolved or read.
4. **Classify the mode** — Discovery, Implementation or Adoption — **only once admission has succeeded**, and record it inside `## Lane and unit`. Core § 3 *The unit's mode* defines the three and what each requires of the evidence.
5. **Choose the bounded unit** and write the brief.

Mode belongs to an admitted Work Loop unit and to nothing else: a request routed to the operator, to a specialist owner, or to Direct Work never acquires one. It is also not the **courier** mode of core § 4, which is transport.

**Who owns the next move** has three kinds of answer:

- **The operator** — the next move is a decision only they can make: intent, priority, authority, or risk. Open nothing. End with the Next line naming the decision you need.
- **A specialist owner** — an Axcíon command, Codex skill or Matt skill from the index, or a stage of the project's own workflow. Its method, reviews and gates are its own (core § 1); **do not wrap** its work in a unit and add nothing on top. Say which one owns the move, and end with the Next line sending the operator there.
- **The Work Loop** — bounded repository work no specialist owns. Take it through Admission below as one unit, and classify it in the core's own terms (core § 3 step 4): an **execution brief** when what advances the project is a change, a **discovery unit** when it is evidence about a named unknown. Operating evidence from real use is a discovery unit whose named unknown is how the capability behaves in use — never a new unit type.

**"Continue this project" is one intake case, not a second router.** Its object is the project's own next move, so read the project's governing workflow and authoritative current state, find the nearest unmet exit condition in the project's own terms, and route that. Map the project's position using its own phase model and vocabulary. Never rename its phases, and never create a document, list or state entry to hold the mapping — the routing is a judgment made fresh from the durable sources each time. Only where a project has no phase model at all, orient with this fallback spine, as a diagnostic and nothing more: frame the need → resolve blocking uncertainty → choose the intervention → shape the pilot → deliver → test in real use → adopt, revise or stop. It creates no states to traverse, no artifacts, and no exit conditions of its own. Orientation is that judgment made explicit, inside the same single preparation pass and from durable sources only. It establishes nine things: the owning project; its approved outcome and current priority; the authoritative current-state source; the governing specialist workflow; the active phase; the completed phases and accepted decisions; the blockers and operator gates; the work ready now; and the work that is premature or unauthorised. Reach them the way `/project-next-steps` Step 2 reaches its own position — plan spine first, then the authoritative position source, then only what bears on the next step, stopping as soon as position is certain. Borrow that read cascade *approach* and nothing else: `/project-next-steps` remains a separate Claude-side operator-facing briefing with its own report, and neither capability calls or merges into the other. Return one line to the operator, in exactly this shape — `Current position → governing workflow and phase → what is ready → what is blocked → recommended next unit → why it matters.` — written in the project's own phase vocabulary, never renamed. **Establishing the nine is not carrying them.** The approved outcome and the current-state position must also reach the brief itself — the position at the precision its authoritative source supports, naming the active phase together with the last completed unit and any open unit, and its date where that date identifies the position, never collapsed to a phase label alone. The operator line above stays exactly as it is: this adds no stage, no second artifact, no repeated context block and nothing further the operator reads. Orient at four boundaries and no others: a Continue acceptance opening the next unit (core § 3 *Continuing*); a fresh task picking up existing work (§ The seam, in the main skill); a post-compaction reorientation; and a material context change — a new operator decision, an operator approval, or verified evidence that has changed the durable understanding of the project. A routine invocation is precisely one where none of those changed, and a routine invocation does not re-orient. Orientation writes nothing: it is not a stage, a gate or a checklist the operator sees, and it creates no orientation file, no phase copy and no state entry — the prohibition above covers the nine determinations too.

### Repository problems

When one specific repository behavior, state, command, workflow, configuration or measurable
performance characteristic is broken, `$diagnose-and-fix` owns the whole diagnosis and
bounded-repair path. Route to it as a Codex specialist: open no Work Loop unit, resolve no executable
core, and add no parallel state. Audits, backlog batches, feature work and already-approved
implementation keep their own owners; they are not repository-problem invocations merely because
they may change repository files.

### Classifying the mode

Core § 3 owns the definitions. What decides it in practice is **what is still uncertain**, not the size of the work or how far the project has got. Three worked cases, calibrated by the operator:

| Case | Mode | Because |
|---|---|---|
| Email OS — the shape of the thing is not settled yet | **Discovery** | the requirement and the ownership boundary are the unknowns; evidence has to resolve them before anything is built |
| A CRM correction — a known defect in a known place | **Implementation** | objective, authority and boundary are settled; what remains is to build it and show it works |
| The CRM operating trial — it exists, is it good enough to keep | **Adoption** | the capability is already there; the unknown is whether it enters normal operations, and the answer is a lifecycle decision |

The trap the middle row sets: a large or important change is still **Implementation** where nothing about it is uncertain, and a small one is still **Discovery** where something load-bearing is. Read the uncertainty, not the size.

Write the mode into `## Lane and unit` and make the brief's completion condition agree with it. A brief recorded as Implementation whose completion condition asks only for evidence and a hand-back is misclassified, and Claude is entitled to hand it back as a false premise.

### What an intake result contains

Exactly four parts:

1. **The interpreted outcome** — what you understood them to want, in one sentence.
2. **One owner** — exactly one owner, named. Not a shortlist and not a sequence.
3. **One short reason** — why that owner rather than the nearest alternative.
4. **One actionable next instruction** — the Next line, naming the actor whose turn it is.

Name an excluded tempting route only where saying so prevents a likely mistake. **Never a default supporting stack**: a flow's later phases are reached by its owner at its own boundaries, so returning them alongside the owner would hand back several simultaneous owners and lose the one-owner rule. Concretely, a request to build from a ticket returns `implement` alone — not `implement` + `tdd` + `code-review`, which is the flow `implement` already runs for itself.

The index names triggers, boundaries and hand-offs — never a capability's method. **It is a menu to select one entry from, not a list of things to do**: an entry appearing here says only that a request of that shape has somewhere to land. Read the owner's own definition when you need its method.

### The routing index

The route inventories are one file, the routing index, linked directly from the main
skill and reached from there. **Read that file
complete at step 2 above, before you name an owner** — the five route classes, the names that are not
routes, the collision table and the Claude-side-only rule live there and nowhere else. Do not route
from memory of it, and do not copy an entry back into this file: one route entry, one owner.

## Admission — Direct Work or the loop

**Core § 2 owns this test.** Read it there and apply it before opening anything. What you do with each outcome:

- **Not admitted** — open no state file. Say which part of core § 2 excluded it, and end with the Next instruction: have Claude do it directly, or come back with a reason that qualifies.
- **Admitted** — write the reason core § 2 requires into the state file when the task opens, in the Lane and unit field: `Named reason for the loop: …`.
