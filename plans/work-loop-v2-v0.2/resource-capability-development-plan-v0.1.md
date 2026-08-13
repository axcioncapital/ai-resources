# Developing and improving AI resources, capabilities and repository features under Work Loop v2

**Status: Draft — not approved and not authorized for implementation.**

Version v0.1, 2026-08-07. Written under Work Loop v2 task `work-loop-v2-resource-capability-plan`,
Unit 1, Implementation mode. Every repository claim below was checked by inspection on 2026-08-07;
the inspection record is in the task-state file at `logs/work-loop/work-loop-v2-resource-capability-plan.md`.

This is a **planning artifact**. It changes no command, skill, document, template, hook, setting or
test. Approving it would authorize the units in § 7, one at a time, and nothing else.

---

## 1. The destination, and the concrete gap it closes

**Observable destination.** An operator states an outcome they want — for a project capability, a
repository feature, or an AI resource — in ordinary language, and exactly one owner takes it, at a
depth earned by what is actually uncertain. Creating, improving, replacing and retiring are all
reachable, "build something" is not the default answer, and the decision that a thing is *technically
finished* stays separate from the decision that it is *in normal operation*.

**The concrete failure this addresses is not speculative.** On 2026-08-06, commit `0516bf6` deleted
`.claude/commands/work-loop.md` — the v1 `/work-loop` command — on operator instruction. Its own
commit message records what it deliberately left behind:

> log a pending improvement-log entry for the routing surfaces (develop-ai-resource, leverage-idea,
> docs/work-loop*.md) that still name /work-loop — rewiring them is a v2-stream design decision, not
> a mechanical substitution.

That is this plan's mandate, stated by the repository itself. The resulting state, verified on disk:

| Symptom | Verified evidence |
|---|---|
| Two commands send work to a command that does not exist | `develop-ai-resource.md` names `/work-loop` on 7 lines (24, 34, 64, 67, 159, 163, 164 — 8 occurrences); `leverage-idea.md` on 7 lines (16, 63, 166, 191, 195, 270, 274). Counted with `grep -o "/work-loop[^-a-z]"`, which excludes every `/work-loop-v2` form. |
| The operating-capability method is a structurally unreachable orphan | `skills/capability-development/SKILL.md` carries `disable-model-invocation: true` and states "**Never invoked directly** … A capability is developed through `/work-loop`". Its only invoker is deleted. |
| 1,321 lines of v1 doctrine describe an unexecutable system | `docs/work-loop.md` (260), `docs/work-loop-spec.md` (360), `capability-development/SKILL.md` (442), `templates/capability-record.md` (140), `.agents/skills/work-loop/SKILL.md` (119) |
| One live capability record has no executor | `projects/axcion-ai-system-owner/development/prime-runtime-delegation.md` |
| `/develop-ai-resource`'s upstream-verification path can never fire | Step 1.0's own note: "**No executable component emits these fields yet** — the producer ships with `/work-loop`'s capability route." The producer is now deleted, so "yet" became "never". |

**Retirement is defined, but only in the layer that can no longer run, and only for one object
class.** The v1 capability layer defines it properly: `templates/capability-record.md:7` puts
`retired` in the TERMINAL status set, `:83` makes a *retirement condition* a required element of the
implementation package, and `:136` records it with the lifecycle status.
`skills/capability-development/SKILL.md:326` gives it substance — "`retired` | TERMINAL | Withdrawn
from use | **The machinery removed, and a record of what was removed**" — and `:340` states the rule
plainly: "Retirement that leaves the machinery in place is not retirement. Remove it, and record what
was removed."

Two things follow, and they are different problems:

- **That definition is unreachable.** It lives in the layer whose executor was deleted, so nothing
  can apply it.
- **It covers operating capabilities only.** Nothing owns retiring a **durable AI artifact** —
  `/develop-ai-resource`'s eleven verdicts (§ 1.6) cover create, reuse, improve, defer and no-build,
  and none is *retire* — and nothing owns retiring a **non-AI repository feature**.

The `0516bf6` retirement is the demonstration: it retired an AI artifact by hand, under no owner's
rule, and left the three broken routes above. Had `capability-development:340` governed it, "record
what was removed" would have surfaced the dangling references at decision time.

**What is NOT broken, and must not be rebuilt.** Work Loop v2 already delivers most of what the
operator's objective asks for. Section 2 establishes this by inspection, because the largest risk to
this plan is designing a second copy of machinery that already exists and already works.

---

## 2. Verified current-state and ownership map

One owner at each boundary. Four distinct kinds of ownership are in play and are routinely confused;
this table keeps them apart.

| Boundary | Owner | What it decides | Verified at |
|---|---|---|---|
| **Which capability owns an ordinary-language request** | Work Loop v2 Codex skill, § Routing | One owner, from a 50-entry index | `.agents/skills/work-loop-v2/SKILL.md:71–201` |
| **Loop or Direct Work** | Executable core § 2 | Whether a state file opens at all | `work-loop-v2-executable-core-v0.1.md:38–58` |
| **What is uncertain about an admitted unit** | Executable core § 3 *The unit's mode* | Discovery / Implementation / Adoption | core `:95–140` |
| **Progression of an open unit** | Codex (frame + assess) | close / continue / correct once / stop | core `:90–226` |
| **Repository reality** | Claude, via `/work-loop-v2` | Premise checks, implementation, evidence, every commit | `.claude/commands/work-loop-v2.md`; core § 4 *Who commits* |
| **Whether a durable AI artifact should exist** | `/develop-ai-resource` | need → mechanism → candidate → disposition; no-build is valid | `.claude/commands/develop-ai-resource.md:30–172` |
| **How a skill is authored and evaluated** | `skills/ai-resource-builder/SKILL.md` via `/create-skill`, `/improve-skill`, `/migrate-skill` | Skill form, eight-layer evaluation | `docs/ai-resource-creation.md:19` |
| **Whether a new component may exist at all** | `docs/ai-resource-creation.md` rule #7 | Complexity budget: two prongs, five questions, inflow rule, OP-12 | `:27–46` |
| **Shared graduation** | `/graduate-resource` | Project fork → canonical, with consumer consent | `ai-resource-creation.md:23–25` |
| **Specialist engineering method** | The installed Matt skill | Its own method, reviews and gates — the loop adds nothing | core § 1 limit 4; Codex skill `:86` |
| **Real-use success and adoption** | The operating project or capability | Whether a well-made thing is actually kept | Adoption mode, core `:126` |

### 2a. What Work Loop v2 already covers

Checked against the brief's five named questions. All five are **already implemented**:

1. **Ordinary-language owner selection** — implemented. `.agents/skills/work-loop-v2/SKILL.md:71–89`
   routes by interpreted outcome, returns exactly one owner, and treats "continue this project" as one
   intake case rather than a second router. The index carries 25 Axcíon commands and all 25 installed
   Matt skills, plus a by-class statement of what is deliberately not a route (`:191–201`).
2. **Direct versus Standard admission** — implemented, asymmetrically on both sides. Core § 2 owns the
   test; the Codex skill applies it at `:217–222`, the Claude command at its § Admission.
3. **Discovery / Implementation / Adoption mode** — implemented in the filesystem, in all three
   artifacts: core `:95–140`, Codex skill `:91–103`, Claude command § The unit's mode, plus assertions
   in `logs/scripts/work-loop-v2-slice-1.test.sh`.
4. **Project progression and specialist ownership** — implemented and **adopted** 2026-08-06
   (`logs/missions/work-loop-v2-mvp.md:90`). Includes the `Continue` outcome and the fallback
   seven-step spine, explicitly bounded as "a diagnostic and nothing more".
5. **Real-use evidence and lifecycle decisions** — implemented as **Adoption mode**, which requires
   "real or representative operation, reliability, operator burden, failure conditions and usefulness,
   and … an explicit lifecycle decision: **adopt, revise, continue the trial or stop**" (core `:126`).

**Consequence for this plan.** The operator's stated requirement to "keep technical completion
separate from operational adoption" — the *decision point* itself — is already met by Adoption mode.
It does not need designing. It needs *reaching*, which is the gap § 1 describes.

**The limit of that claim, stated here so it is not over-read downstream.** Adoption mode is a
decision point, not a capability-development method. It does not carry trial design, seam selection,
the intervention ladder, retirement conditions or a durable capability address — all of which
`skills/capability-development/SKILL.md` does carry. Whether v2 needs any of them is **Unit 4's gap
analysis**, not a question this section answers. Row 5 above says the lifecycle *decision* exists; it
does not say the method it belongs to has been replaced.

### 2b. Authority status — what is settled and what is not

| Source | Status | Consequence |
|---|---|---|
| `work-loop-v2-executable-core-v0.1.md` | Header reads **draft for operator approval**; the § 4 courier clause was approved separately on its own | Governing for mechanics. Do not read the courier approval as approval of the rest. |
| The mode contract | **Implemented, not closed.** `logs/work-loop/work-loop-v2-intake-router.md` is `turn: claude`, mid-final-tightly-bounded-fix | Repository reality to build on, **not** accepted authority to cite. No unit here may depend on it being closed. |
| Project progression + `Continue` | **Adopted** 2026-08-06, by blob, per mission thread `:90` | Settled. Safe to depend on. |
| Proposal v0.4 | AUTHORITATIVE within MVP scope | This plan proposes nothing inside § 3's ten settled decisions and nothing from § 7's deferred list. |
| `/work-loop` v1 command | **Deleted** at `0516bf6` | Every route naming it is dangling. |
| v1 doctrine (5 files, 1,321 lines) | On disk, unexecutable | Disposition is an operator decision — § 8. |

### 2c. Matt skills — verified from the installed definitions, not from the essays

All ten named skills are installed at `~/.claude/skills/`. Read directly; the contextual essays in
`plans/work-loop-v2-v0.2/context-engineering/` were **not** used to establish method. Two facts
materially affect routing and are not visible in those essays:

**Six of the ten are `disable-model-invocation: true`** — `grill-with-docs`, `wayfinder`, `to-spec`,
`to-tickets`, `implement`, `improve-codebase-architecture`. They are operator-invoked only; no model
can route *into* them. Naming one is therefore always an instruction to the operator, which is exactly
what the Codex skill's `[Claude-side only]` handling already does (`:213–215`). The four freely
invocable ones are `prototype`, `tdd`, `code-review`, `diagnosing-bugs`.

**No tracker configuration is required in advance.** `wayfinder`, `to-spec` and `to-tickets` publish
to an issue tracker, and `docs/agents/issue-tracker.md` is absent here — but the installed definitions
carry their own fallback. `wayfinder/SKILL.md:25`: "**If no tracker has been provided, default to the
local-markdown tracker.**" `to-tickets/SKILL.md:62` specifies that local form concretely — "write one
file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`". The skills degrade to a
local-markdown tracker rather than refusing.

**The proportional consequence.** Setup is not a prerequisite and does not earn a preparatory unit.
If a genuinely foggy initiative reaches one of these specialist boundaries and the installed skill
asks for configuration *at that point*, the operator handles it then — inside the specialist's own
flow, which owns its method (core § 1 limit 4). Building a Discovery unit in advance to answer a
question the skill answers for itself would be exactly the over-preparation this plan exists to
prevent.

---

## 3. The recommended minimum design

> **Reconcile the ownership that already exists. Add no new workflow component. Decide nothing about
> the v1 doctrine before the gap analysis that would justify the decision.**

The design is three moves, in dependency order:

1. **Give the orphaned routes a live destination.** Repoint the operating-capability and
   settled-correction routes in `/develop-ai-resource` and `/leverage-idea` at Work Loop v2's intake
   router, which is the capability that now performs owner selection. This is the part the repository
   evidence already settles, and it is safe to do now.
2. **Establish, by inspection, what the v1 capability method contains that nothing in v2 covers** —
   and hand that gap analysis to the operator. This plan does **not** recommend retiring, porting or
   keeping the v1 doctrine. Unit 4 produces the evidence; the disposition is the operator's.
3. **Give each object class an owner for `retire`, or state precisely who is missing one.** For a
   durable AI artifact, add the verdict to `/develop-ai-resource` § 1.6. For an operating capability
   and a non-AI repository feature, § 5 states the open ownership question rather than answering it.
   No new retirement component is proposed for symmetry.

**Why move 2 is deliberately unresolved.** An earlier draft of this plan recommended retiring the v1
doctrine on the reasoning that Adoption mode already carried its load-bearing part. Inspection does
not support that. `skills/capability-development/SKILL.md` contains, under its own headings,
**the intervention ladder** (`:108`), **owner selection and seam procedure** (`:127–159`), **trial
design and its stop condition** (`:226`), **slice standards** (`:245`), **evidence-to-claim** (`:261`)
and a **lifecycle status table** (`:313–340`). Adoption mode is one decision point — real-operation
evidence ending in adopt / revise / continue / stop (core `:126`). A decision point does not replace
a method, and having the same four options is not evidence of equivalent coverage.

**Nor does the task-state file replace the capability record.** Core § 4 defines the state file as
**current truth for one task**, and reduces it to four sections at closure. It is not durable
operating-capability state: a capability outlives its tasks, and the record's *retirement condition*,
*real-use result* and *lifecycle status* (`templates/capability-record.md:83`, `:131`, `:136`) have
nowhere to live once a task closes. Whether that matters in practice — with exactly one live record —
is Unit 4's question, not this section's assertion.

**Component arithmetic: 0 added in every class.** Nothing is counted as removed, because this plan
recommends removing nothing. It clears complexity-budget prong **(a)** by holding every count flat
while restoring capability, and independently clears prong **(b)** on cited evidence
(`logs/improvement-log.md:2823`, commit `0516bf6`). No unit below proposes a new command, skill,
agent, mandatory gate, always-loaded rule, registry, lifecycle record or state system.

### The strongest rejected alternative

**Build a v2 capability route now** — a fourth mode, or a `capability-development-v2` skill with its
own v2 capability register, so the v1 lifecycle survives with a new executor.

Rejected — but on sequencing and cost, **not** on the claim that v1's content is redundant:

- **It builds before the gap is known.** Move 2 has not run. Designing a replacement register before
  establishing what the existing method actually contributes is the speculative-abstraction failure
  `ai-resource-creation.md:29` names. If Unit 4 shows the trial-design and retirement-condition
  content is load-bearing, the right answer may well be to *keep* it — which costs nothing and is not
  available once it has been replaced.
- **A second concurrent state system is the specific risk.** Core § 1 limit 4 and core § 4 forbid
  standing a second state system beside the task-state file. That objection applies to a *new v2
  register* built now; it is not an argument that the v1 record was wrong to exist.
- **A fourth mode would break the mode contract's own rule** that modes classify what is uncertain
  *now*, not what kind of object is being worked on (core `:96–108`).

*What the rejected option is right about:* v1 correctly insisted that the operating outcome and the
artifact are different things, that the adoption decision belongs to the outcome's owner, and that a
capability needs a durable address that outlives any one unit. The first two are preserved in § 4's
route 6 → 7 seam. **The third is an open question this plan does not close.**

---

## 4. Proportional entry routes

Eight routes, each naming the **first owner only** and the condition that ends that owner's
responsibility. These are routes, not a stack, and not a sequence to work down. Every one is reachable
today except where marked.

| # | The situation | First owner | That owner's responsibility ends when |
|---|---|---|---|
| 1 | A small settled improvement, reversible | **Direct Work** (core § 2) — no state file, no brief | The change is made. Nothing else happens. |
| 2 | An ordinary unresolved feature or resource change | **Work Loop v2**, admitted Standard, mode by what is uncertain | Codex closes the task, or routes it out to a specialist |
| 3 | A large, foggy initiative with dependent decisions | **`wayfinder`** (operator-invoked) | The decision map's tickets are resolved and the way is clear |
| 4 | A difficult defect | **`diagnosing-bugs`** | The cause is established; the fix is then route 1 or 2 |
| 5 | An architecture-health concern | **`improve-codebase-architecture`** (operator-invoked) for code; **`/consult`** for workspace structure | The deepening opportunity is chosen and grilled |
| 6 | A new AI resource supporting an existing operating capability | **`/develop-ai-resource`** | A disposition is returned — including no-build. Adoption stays with the capability's owner. |
| 7 | A non-AI capability or repository feature | **Work Loop v2** — same as route 2. There is no separate capability lane. | As route 2 |
| 8 | Later shared-resource graduation | **`/graduate-resource`** | Every existing canonical consumer has confirmed (`ai-resource-creation.md:23`) |

**Route 6 → route 7 is the one seam that must stay explicit.** A new AI resource is often *one
component* of an operating outcome. `/develop-ai-resource` returns a disposition on the **artifact**;
whether the outcome is achieved is route 7's question, and the adoption decision is Adoption mode's.
This is v1's outcome-versus-artifact boundary, preserved without v1's record.

**Route 3 needs no preparation.** It falls back to a local-markdown tracker when none is configured
(§ 2c). Fogginess is what selects it — not size and not importance; § 9 row 5 is the case that would
expose the drift.

---

## 5. Create, improve, replace, retire — without "build" as the default

Two mechanisms already resist build-bias, and both are load-bearing here:

- **The smallest-mechanism ladder** (`develop-ai-resource.md:79–83`) — ten rungs beginning *accept the
  limitation → change an operating habit → normal prompting → reuse or improve* and only reaching a
  command, script or hook at rungs 8–10. Building is the *last* rung, not the first.
- **The complexity budget** (`ai-resource-creation.md:27–46`) — two prongs, five questions, plus the
  inflow rule that a new command must name what it replaces **and** its invocation path.

| Lifecycle move | Owner today | Change proposed |
|---|---|---|
| **Create** | `/develop-ai-resource` → `/create-skill` | None |
| **Improve** | `/improve-skill` direct when settled; `/develop-ai-resource` first when uncertain or contested | None — the settled-mechanism test already sizes this correctly |
| **Replace** | `/develop-ai-resource` § 1.4, via the inflow rule's "state which existing command it replaces" | None. Replacement is a create whose budget answer names the removal. |
| **Retire** | **Depends on the object class — see below** | **Unit 3**, scoped per class |

### Retire, per object class

Retirement is not one gap. It is defined well for one class, undefined for two, and the plan must say
which is which rather than adding a component for symmetry.

| Object class | Who owns retiring it today | Proposed |
|---|---|---|
| **Operating capability** | **Defined, but unreachable.** `capability-development/SKILL.md:326`, `:340` and `templates/capability-record.md:7`, `:83`, `:136` define `retired` — machinery removed, and a record of what was removed | **No change here. This is Unit 4's question**, because the answer depends on whether that layer is kept, folded into v2, or retired. Deciding it now would pre-empt the operator. |
| **Durable AI artifact** (skill, command, agent, hook, doc) | **Nobody.** `/develop-ai-resource` § 1.6's eleven verdicts contain no retire | **Unit 3** — add `retire` to § 1.6, borrowing the substance already proven at `capability-development:340` rather than inventing it: remove the machinery, and record what was removed |
| **Non-AI repository feature** | **Nobody, and no candidate owner exists** | **Stated as an open ownership question, not answered.** Work Loop v2 can *execute* a retirement as an ordinary unit, but no rule tells anyone what a repository-feature retirement must record. § 11 carries it as a deferral with a reopening trigger. |

Retirement earns its place on cited evidence rather than symmetry: `0516bf6` retired an AI artifact
by hand, under no owner's rule, and left three broken routes. Unit 3 is confined to the one class
where the gap is both real and unambiguous.

---

## 6. Modes, project phases, and Matt's flows — three things, not one

The single most likely misreading of this plan is that Discovery → Implementation → Adoption is a
lifecycle to walk. It is not, and core `:104–108` says so explicitly.

| Concept | What it classifies | Scope | Sequence? |
|---|---|---|---|
| **Work Loop mode** | One admitted Standard unit, by what is uncertain **now** | That one unit | **No.** A task may run every unit in one mode; a later unit may return to an earlier mode. |
| **Project / capability phase** | Where a body of work stands in its own model | The project | Usually yes — but it is the *project's* model, named in the *project's* words |
| **Matt skill** | A specialist method reached at its own boundary | The specialist's own flow | Internally, yes — `implement` runs its own TDD and review |

Three boundaries hold this apart, all already in the artifacts:

- Work Loop **never renames a project's phases** and creates no document to hold the mapping
  (Codex skill `:89`).
- Work Loop **never wraps a specialist** in a unit or adds a second review or state system
  (core § 1 limit 4; Codex skill `:86`, `:215`).
- The seven-step spine is a **fallback diagnostic** for projects with no phase model — "It creates no
  states to traverse, no artifacts, and no exit conditions of its own" (Codex skill `:89`).

**Matt's method applied semantically to non-code resources.** `implement` drives literal
red-green-refactor and a real test suite. A skill, command or workflow document has no test suite, so
the equivalent is a **representative invocation or behavioural case capable of failing** — which is
core § 6 rule 5 and needs no new rule. Core `:130–131` already licenses the honest alternative: where
no meaningful regression check exists, say so and say why, rather than inventing one that cannot fail.

---

## 7. Implementation units

Vertical, independently verifiable, sequenced by dependency and uncertainty. Each is a candidate for
one Work Loop v2 task; **none is authorized by this document.**

---

### Unit 1 — Implementation: repoint `/develop-ai-resource`'s capability seam

- **Outcome and why now.** Eight occurrences across seven lines send the reader to a deleted command,
  and Step 1.0's four-check upstream path can never fire. This is the highest-traffic dangling route
  and it sits in the command that owns AI-artifact qualification.
- **Owner.** Work Loop v2, **Implementation mode**.
- **Owned paths.** `.claude/commands/develop-ai-resource.md`.
- **Prerequisites.** None. **Holds outside:** `leverage-idea.md` (Unit 2), the v1 doctrine files
  (Unit 4), and any change to the four Step 1.0 checks *as checks* — only their producer changes.
- **Claims to verify before mutation.** `.claude/commands/work-loop.md` absent from the tree and from
  `git ls-files`; the seven referencing lines still present; `templates/capability-record.md` still the
  named authority for the ACTIVE/TERMINAL status sets; one live record at
  `projects/axcion-ai-system-owner/development/prime-runtime-delegation.md`.
- **Fail-capable evidence.** Before: `grep -o "/work-loop[^-a-z]"` returns 8 hits across 7 lines in
  this file; a reader following any of them reaches nothing. After: zero such hits, and the upstream
  clause states its status honestly — either the fields have a live producer, or the clause is marked
  dormant with the one live record named. The check fails if the substitution is textual and leaves a
  route pointing at a capability route v2 does not have.
- **Review.** One Codex review. This is a shared `ai-resources` command symlinked into projects —
  reviewed, not challenged; not a structural class, since nothing is created or deleted.
- **Rollback.** Single-file revert.
- **Operator decision it precedes.** None, if the clause is marked dormant. If the recommendation is to
  **delete** the upstream-brief clause, that is a deletion of an active contract and belongs to Unit 4's
  operator decision instead.

---

### Unit 2 — Implementation: repoint `/leverage-idea`'s two routing rows

- **Outcome and why now.** `/leverage-idea` is a router; a router with a dead exit misroutes silently.
  Seven referencing lines, of which four are live routing destinations — the two prose routes (`:191`,
  `:195`) and their table rows (`:270`, `:274`) — plus the duplicate gate at `:63`.
- **Owner.** Work Loop v2, **Implementation mode**.
- **Owned paths.** `.claude/commands/leverage-idea.md`.
- **Prerequisites.** Unit 1, so both files describe the same destination. **Holds outside:** the
  complexity-budget cap at `:166`, which is correct as written and independent of the destination.
- **Claims to verify.** The two routing rows and their prose twins still name `/work-loop`; the cap at
  `:166` explicitly survives a re-route ("The cap survives the route"); Work Loop v2 accepts an
  operating-capability need — verified against the Codex skill's index entry `:120`.
- **Fail-capable evidence.** A worked routing case for each of the two rows — an operating capability
  in an existing project, and a settled correction to a command — showing the returned owner before
  and after. Before, both name a deleted command. The check fails if the settled-correction row is
  re-routed to Work Loop v2 without noting that core § 2 sends a *small reversible* correction to
  Direct Work, which would inflate exactly the work v2 exists to keep out.
- **Review.** One Codex review, same sizing as Unit 1.
- **Rollback.** Single-file revert.
- **Operator decision it precedes.** None.

---

### Unit 3 — Implementation: give `retire` an owner **for durable AI artifacts only**

- **Outcome and why now.** Of the three object classes in § 5, exactly one has a gap that is both real
  and unambiguous: a durable AI artifact has no retirement owner. Operating capabilities already have
  a definition (unreachable — Unit 4's question), and repository features have no candidate owner at
  all (§ 11 deferral). This unit is confined to the unambiguous class.
- **Owner.** Work Loop v2, **Implementation mode**.
- **Owned paths.** `.claude/commands/develop-ai-resource.md` § 1.6 and Step 4's disposition list.
  Possibly one line in `docs/ai-resource-creation.md`.
- **Prerequisites.** Unit 1 (same file). **Holds outside:** any retirement *command* or register;
  retirement of an operating capability (Unit 4 decides whether that definition survives); retirement
  of a non-AI repository feature; and retiring anything at all.
- **Claims to verify.** § 1.6's verdict list contains no retire-equivalent; Step 4's operator choices
  (`Ship` / `Revise` / `Defer` / `Delete candidate`) cover only a candidate under construction, not a
  resource in service; `capability-development:326`/`:340` and `templates/capability-record.md:7`
  already define retirement for capabilities, so the substance is borrowed rather than invented.
- **Fail-capable evidence.** Replay the `0516bf6` retirement against the amended verdict: does it
  require naming every surface that references the retiring resource, and recording what was removed?
  Against the current text the answer is no — which is why three routes broke. A verdict that would
  not have caught that case has not earned its place. Second case: an *operating capability*
  retirement must **not** be claimed as covered by this verdict — if the amended text reads as though
  it were, the unit has overreached.
- **Review.** One Codex review. Adding a lifecycle verdict to a governing command is consequential but
  not destructive.
- **Rollback.** Revert; nothing depends on the verdict until it is used.
- **Operator decision it precedes.** None to add it. Every *use* of it is an operator decision by
  construction.

---

### Unit 4 — Discovery: the v1 capability gap analysis

- **Outcome and why now.** § 3 move 2 deliberately left the v1 disposition open, because the evidence
  to settle it does not exist yet. This unit produces it. Last, because Units 1–3 change what the
  answer should be — after them, the *routing* problem is solved and only the *method* question
  remains.
- **Owner.** Work Loop v2, **Discovery mode**.
- **Owned paths.** The state file only. **This unit deletes nothing and recommends nothing.**
- **Claims to verify.**
  1. **The gap analysis itself, section by section.** For each heading of
     `skills/capability-development/SKILL.md` — the intervention ladder (`:108`), owner selection and
     seam (`:127`), the five phases (`:160`), trial design and its stop condition (`:226`), slice
     standards (`:245`), evidence-to-claim (`:261`), lifecycle decisions (`:313`) — state whether v2
     covers it, partly covers it, or does not. **Do not treat "Adoption mode has four options" as
     covering the lifecycle section**; compare content, not option counts.
  2. Whether the capability **record** holds anything the task-state file cannot, given core § 4
     reduces the state file at closure — specifically `retirement condition`, `real-use result` and
     `lifecycle status`.
  3. Every remaining inbound reference to each of the five v1 files.
  4. The disposition of the one live capability record.
- **Fail-capable evidence.** A per-section coverage verdict and a per-file disposition option, each
  with the citation that supports it. The evidence fails if it cannot distinguish a section v2 genuinely
  covers from one it merely resembles, or a file with live inbound references from one with none. An
  analysis that concludes "retire it all" without a per-section comparison has not run.
- **Review.** None — Discovery changes nothing. The *execution* of any disposition is a separate unit
  and a **structural change class** (retiring active resources), owed one **risk-aware** Codex review
  before implementation per `docs/qc-independence.md`.
- **Rollback.** Nothing to roll back; git holds the files regardless.
- **Operator decision it precedes.** **Yes, and it is the one consequential decision in this plan.**
  Whether the v1 capability layer is kept, folded into v2, or retired is reserved to the operator.
  Unit 4 produces the evidence; **neither it nor this plan decides.**

---

## 8. The v1/v2 seam map

Every dependency, and what this plan does with it. Nothing is silently ported.

| v1 dependency | Disposition | Ground |
|---|---|---|
| `/work-loop` command | **Already gone** | `0516bf6` |
| `.agents/skills/work-loop/SKILL.md` (Codex v1 controller) | **Operator decision** — Unit 4 | Tracked, unreferenced by v2 |
| `docs/work-loop.md` — **loop process**: eight steps, streams, artifacts | **Superseded for process** by core §§ 2–4 | v2 owns admission, units, state and evidence. This covers the *process* half only; the file's capability-boundary content goes to Unit 4. |
| `docs/work-loop-spec.md` | **Operator decision** — Unit 4 | Specification of intent for a deleted command |
| `skills/capability-development/SKILL.md` — method | **Operator decision** — Unit 4, per-section. **No half is asserted as covered here.** Its intervention ladder, owner/seam procedure, trial design, slice standards, evidence-to-claim and lifecycle statuses are compared section by section, not assumed replaced by Adoption mode. | Unreachable today (`disable-model-invocation`), but unreachable is not the same as redundant |
| `templates/capability-record.md` — status vocabulary and durable capability state | **Keep.** Cited by `develop-ai-resource.md:55` as the ACTIVE/TERMINAL authority, and it holds retirement condition, real-use result and lifecycle status that the task-state file discards at closure (core § 4). Whether v2 needs an equivalent is Unit 4's question. | One live record |
| The one live capability record | **Operator decision** — Unit 4 | No executor |
| `**Capability:**` / `**Settled upstream:**` handoff contract | **Adapt** — Unit 1 | Producer deleted; checks still sound |
| v1's outcome-versus-artifact boundary | **Keep** — carried in route 6 → 7 | Correct and independent of v1 machinery |
| v1's four route triggers and three gates | **Do not port** | v2 sizes review by `qc-independence.md`; porting reinstates the gate-stacking the workspace removed |

---

## 9. Test matrix

Eight named failure modes, each with a case that would expose it. This matrix is the acceptance
surface for Units 1–3; a unit that cannot fail one of its rows has not been proven.

| # | Failure mode | Case that exposes it | Fails if |
|---|---|---|---|
| 1 | **Misrouting** | "Add a follow-up-date field to the CRM contact model" | Any owner other than one is returned, or a deleted command is named |
| 2 | **Double ownership** | "Build the new export skill for the buy-side project" | Both `/develop-ai-resource` and Work Loop v2 are returned as simultaneous owners |
| 3 | **Duplicate state** | Any capability need | A capability record *and* a task-state file are both opened for one need |
| 4 | **Build bias** | "Sessions keep forgetting to check X" | The answer is a new hook/command without the ladder's earlier rungs being weighed |
| 5 | **Mandatory-Wayfinder drift** | A three-file settled correction | `wayfinder` is named because the work is *important* rather than *foggy* |
| 6 | **Ceremonial TDD** | A one-paragraph SKILL.md wording fix | A test is invented that would pass whatever the wording said |
| 7 | **Technical completion as adoption** | A shipped dispatcher with no operating run | An Implementation unit's closure is read as the adoption decision |
| 8 | **Detector without closure** | A proposed failure-mode detector | It ships without the channel that acts on what it finds (OP-12) |

---

## 10. Three counterexample walkthroughs

The routes must produce **different, proportionate** outcomes. If all three land in the same place,
the design is a funnel, not a router.

**A. Speculative failure-mode governance with no cited failure.**
*"We should add a supervisor check that catches dispatcher runaway."* → Owner: `/develop-ai-resource`.
Step 1.2 classifies the evidence as **speculative**. The complexity budget fails prong (b) — "we might
need it" is named there as the AP-7/DR-7 violation — and fails prong (a), since it adds a component.
It is also a *detector*, so OP-12 demands its closure channel in the same change.
**Outcome: no build.** Constraint 10 is satisfied without machinery: the concern re-enters later as a
stop condition inside a real unit's brief.

**B. One verified dispatcher failure with a known seam.**
*"`dispatch.sh` exits 0 when the turn did not move."* → Owner: Work Loop v2. Admission: the seam is
load-bearing and the harness reads it, so this is not small-and-reversible → **Standard**. The cause
and the fix location are known → **Implementation mode**. Evidence: the failing case first, the fix,
and the harness assertion that distinguishes them.
**Outcome: one bounded unit.** No Wayfinder — nothing is foggy. No `/develop-ai-resource` — nothing
new is authored.

**C. An existing project capability that needs a new AI resource, then real-use adoption.**
*"The buy-side service needs a repeatable screening write-up."* → **Three owners in sequence, each
ending cleanly** — the case that proves the routes are not a stack:
1. **Work Loop v2** frames the operating outcome. If the requirement is genuinely unsettled, the first
   unit is **Discovery mode**.
2. **`/develop-ai-resource`** owns the artifact once a skill is the identified mechanism. It returns a
   **disposition on the artifact** and stops. It does not decide whether the service adopts it.
3. **Work Loop v2, Adoption mode** reads real operating evidence and returns the lifecycle decision.
   Per core `:132–136`, the operating itself is separate work; the unit reads the evidence it produced.

Contrast with **A**, which stops at step 1 with no build, and **B**, which never reaches steps 2 or 3.

---

## 11. No-build conditions, exclusions, deferrals and the stopping condition

**No-build conditions — any one means the affected unit does not run.**

- Unit 4's gap analysis finds v2 does **not** cover a load-bearing section of the v1 method → that
  section stays, and no retirement is proposed for it.
- Unit 4 finds live inbound references to a v1 file → that file stays, unchanged.
- Any unit's premise check finds the dangling reference already repaired → hand back, do not re-fix.
- The operator decides the v1 doctrine stays as historical reference → Unit 4 ends in a recorded
  decision and nothing else.
- Unit 3 cannot state a retirement rule for AI artifacts without also claiming the capability class →
  it is narrowed or dropped, not broadened.

**Exclusions — outside this plan entirely.** A new command, skill, agent, hook or registry; any
capability register or second state system; a fourth mode; changes to the executable core, the Codex
skill, the Claude command or the harness; installation and propagation of Work Loop v2 (a separate
open mission thread); the v0.2 rework; retiring any resource, which is Unit 4's operator decision;
running `setup-matt-pocock-skills`.

**Deferrals, each with an evidence-based reopening trigger.**

| Deferred | Reopening trigger |
|---|---|
| A durable capability address for v2 (register or record equivalent) | Unit 4 shows the task-state file loses retirement condition, real-use result or lifecycle status at closure **and** a second live capability record appears |
| An owner for retiring a **non-AI repository feature** | A repository feature is actually retired and nobody can say what the retirement had to record — the `0516bf6` pattern repeating in a second class |
| Configuring a non-default Matt issue tracker for `ai-resources` | The local-markdown fallback (§ 2c) proves insufficient during a real Wayfinder run |
| Folding `capability-development`'s trial-design method into v2 | Unit 4 finds it uncovered **and** two Adoption-mode units need guidance the core does not give |
| Automating the dangling-reference check | A third routing surface is found dangling after a retirement |

**Stopping condition for the whole build.** Stop when every route in § 4 reaches a live owner,
durable AI artifacts have a `retire` owner, and Unit 4's gap analysis is recorded and in front of the
operator. **Do not continue into** generalising the router, building capability machinery, acting on
Unit 4's findings without an operator decision, or improving the Matt integration. If § 9's matrix
passes and § 4's routes resolve, this work is finished — the next question belongs to the v0.2 rework
thread, not here.

---

## 12. Adoption proof

Technical completion is not adoption, so this plan states its own adoption proof separately.

**The proof is a real routing session, not a file check.** After Units 1–3, take **three genuine
requests the operator wanted handled anyway** — never manufactured — through the intake router, and
record for each: the owner returned, whether it was reachable, whether the depth matched the
uncertainty, and what the operator had to do by hand.

**A static check is explicitly not this proof.** Greps returning zero `/work-loop` hits, the harness
passing, and this plan existing evidence none of it. Per core `:126`, the evidence must cover real or
representative operation, reliability, operator burden, failure conditions and usefulness.

**It runs as an Adoption-mode unit**, whose lifecycle decision is one of **adopt · revise · continue
the trial · stop**. Its named unknown is whether the reconciled routing is genuinely usable — and per
core `:132–136`, the three requests are operated as separate work; the unit reads what they produced.

---

## 13. Operator approval boundary

**Approving this document would authorize:**

- Opening Units 1–4 as Work Loop v2 tasks, **one at a time**, each with its own brief and premise
  checks.
- Editing exactly two files — `.claude/commands/develop-ai-resource.md` and
  `.claude/commands/leverage-idea.md` — plus possibly one line of `docs/ai-resource-creation.md`.
- Adding `retire` to `/develop-ai-resource` § 1.6, **for durable AI artifacts only**.

**Approval would NOT authorize, and each remains a separate decision:**

- **Deleting, archiving or retiring any v1 file.** Unit 4 produces evidence only. Execution is a
  structural change class owed a risk-aware Codex review.
- **Retiring the v1 capability method, or treating it as superseded.** This plan makes no such
  recommendation; § 3 and § 8 both leave it open, and § 5 leaves capability retirement with the v1
  definition pending Unit 4.
- Retiring an operating capability or a non-AI repository feature under Unit 3's verdict.
- Disposing of the one live capability record.
- Configuring an issue tracker, or installing/updating any Matt skill.
- Any new command, skill, agent, hook, registry, mode or state system.
- Changing the executable core, the Codex skill, the Claude command or the harness.
- Anything in the v0.2 rework or the installation/propagation thread.
- Treating the mode contract as closed. It is `turn: claude` and mid-fix; § 2b applies.

**The one decision the operator should expect to make** is Unit 4's: whether the v1 capability
doctrine is kept, partly folded into v2, or retired. This plan deliberately does not pre-empt it —
`docs/work-loop.md` describes a system that ran real work, and its trial design, seam selection and
retirement conditions may well outlive its machinery. **Unreachable is not the same as redundant**,
and only the gap analysis can tell them apart.
