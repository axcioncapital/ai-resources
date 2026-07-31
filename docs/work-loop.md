# The work loop — contract

Reference contract for `/work-loop`. The command orchestrates and implements; this file defines the vocabulary, the artifacts and the rules both models rely on. Read by `/work-loop` on every invocation and by the Codex `work-loop` controller skill.

`ai-resources` is the **required Codex control room.** Codex is opened rooted there, reads sibling repositories from that root, and writes only within `ai-resources`. Nothing in this design depends on Codex write access to a sibling. Briefs and reviews are printed in chat and transcribed by Claude into the target repository, where **Claude is the single writer.**

---

## Boundary sentences

> **Outcome versus artifact.** `/work-loop` with `capability-development` owns the operating outcome. `/develop-ai-resource` owns the artifact. The skill is not the capability; it is one implementation component.

> **Capability versus project.** A capability lives inside a project that already exists. A project is a new domain with its own deliverables.

> **Goal versus development record.** `logs/missions/{id}.md` answers *what multi-session goal is this serving, and is it drifting?* `development/{slug}.md` answers *what is this capability, where does it stand, what happens next?*

---

## The eight steps

Every invocation runs 1–2. Steps 3–8 run per unit.

| # | Step | Output |
|---|---|---|
| 1 | **Reconcile** — repair inconsistent state before anything is consulted (§ Reconciliation) | One line per repair, or silence |
| 2 | **Resume or ingest** — tiered resume (§ Resume order); with no open work, ingest a brief | The unit being worked |
| 3 | **Open the unit** — allocate or carry the stream; write the brief, then the pointer, then commit both | `STREAM` + `UNIT` |
| 4 | **Verify premises** — run what the brief cites; open the lines it names; re-derive its counts | `PREMISE: confirmed` / `rejected` with evidence |
| 5 | **Classify route** — solo / reviewed / challenged (§ Route triggers) | Route + the criterion that fired |
| 6 | **Execute the phase** — implement in-scope changes, or route out (§ Execution boundary) | Working-tree changes |
| 7 | **Return evidence, review, adjudicate** — evidence to Codex; every material finding gets one disposition | Evidence + review + dispositions |
| 8 | **Close** — close the unit; the stream's last unit closes the stream in the same commit | Closure + artifact deletion at stream close |

**The unit opens before its premises are verified, and that order is deliberate.** A rejected premise is a *result* — it says a need was brought and its foundation was disproved — and a result needs an identity to be recorded under. Verifying first would produce that result before any stream, unit id or brief existed, so it could only be written to an unbound path, and § Resume order (which indexes on briefs) and § Reconciliation (whose every row keys on a brief or a pointer) would both be blind to it. Opening first costs one commit on a unit that may stop immediately; it buys a rejection that is addressed, indexed, closed and recoverable like every other outcome.

**A rejected premise stops at step 4** — see § Closing without a change. Report the rejection with the evidence that disproves it, make **zero edits to the object under work**, and close the unit. Do not repair the brief's reasoning on its behalf.

**What step 4 gates is the object under work, not the loop's own bookkeeping.** The unit's artifacts in `logs/loop/` are written before the gate; nothing else is. The invariant is checkable rather than a matter of judgement: every commit made before premise verification passes stages `logs/loop/{unit}.*` paths and nothing else.

---

## Execution boundary

`/work-loop` **implements** ordinary, in-scope edits to things that already exist, and capability slices: defect fixes, documentation, standards, decision rules, processes, data structures, configuration, project-local artifacts, and settled corrections to existing commands, skills, scripts and hooks.

It **routes out**, and does not implement, in exactly two cases. **The two differ in whether the stream survives, and that difference — not the identity of the receiving command — is what decides whether the unit closes `routed-out`:**

- **`/develop-ai-resource`** — a **new** durable AI artifact must be authored, or an existing one materially expanded. This matches that command's own authority text at `.claude/commands/develop-ai-resource.md:13-17`. **Not terminal when the artifact is a component of a live stream.** § Boundary sentences gives that command the *artifact* and keeps the *operating outcome* here, so the lifecycle decision never leaves; its own Step 1.0 says the same from the other side. The stream stays open and the unit closes on its ordinary outcome. The **artifact** disposition — is it well made, does it do what it claims, what was tested and observed — returns through the **capability record**, not through the unit, which may be long closed by the time the artifact is authored: adjudicate it, record it under the record's `## Pointers` and `## Verification evidence`, then resume the slice. An artifact judged unfit is a material scope change, not a quiet retry. Only when the routed work is the unit's **whole need** does this become a `routed-out` close.
- **`/scope-project` → `/new-project`** — owner selection finds no legitimate owner, or the work is a new enduring programme. **Always a terminal exit:** the stream closes, any record closes `status: rejected` with the routing note, and **nothing is held open pending a project.**

`/work-loop` never writes mission files. `/mission` is the sole writer of `logs/missions/{id}.md`.

---

## Route triggers

Universal — every unit of any type. Any one fires; ambiguity resolves **upward**.

- **Challenged** — touches a structural change class **as listed at `docs/audit-discipline.md:60-65`** (that file is the sole owner of the list; it is cited here, never copied); or deletes or retires an active resource; or changes git, branch or worktree behaviour; or touches three or more repositories; or has already failed to converge twice.
- **Reviewed** — changes a shared `ai-resources` resource symlinked into projects; or produces an artifact that leaves the repository; or changes five or more files; or produces analytical output the operator cannot judge unaided.
- **Solo** — residual: one repository, revert-reversible, four files or fewer, no shared blast radius, no external delivery.

Capability units carry **additional** triggers owned by `skills/capability-development/SKILL.md` § Route triggers. That file cites this section and does not restate it.

A structural risk class does not fire a separate gate. It makes the change **high-consequence**, which is carried inside the route: the Codex review for that unit is briefed **risk-aware** (`docs/qc-independence.md` § Risk-aware review — the seven dimensions plus the premise-verification precondition), and a solo unit escalates rather than bolting a reviewer onto itself. One review, sized to the change.

**Escalation** is additive: nothing already produced is discarded, and escalation into challenged arms G1 immediately. **De-escalation** requires every trigger disproven with cited evidence, only at a phase boundary, and never after a stop has approved the heavier route.

### Route → depth → stops

| Route | Independent review | Operator stops |
|---|---|---|
| **solo** | None. A mandatory risk class escalates the route rather than bolting a gate onto it. | 0 |
| **reviewed** | One Codex review of the result — **risk-aware when the change is in a structural class**. Inline self-review only as fallback, when Codex cannot reach the object. | 1 — the lifecycle decision, and only when the stream has a genuine adoption question. A defect fix closes as `close` with no stop. |
| **challenged** | Codex before implementation and after, **in separate units**. Both are **risk-aware** — a challenged route is high-consequence by construction. | 3 — G1 scope and package · G2 release · G3 lifecycle |

### The challenged route — gates and review placement

The three stops are **exactly three**. A passing verdict produces no stop; a stop exists to put a decision in front of the operator, not to announce good news.

| Gate | Sits at | Operator is deciding | Held package |
|---|---|---|---|
| **G1 — scope and package** | End of the **Shape** unit, after the pre-implementation review is adjudicated **and its precondition passes** | Whether this is the right change, at the right scope, before anything is built | The plan and the pre-implementation review **by identity, never by name** — path, containing commit and blob for each — plus the adjudication of the findings and the slice list Build will execute (§ Reviewed-object identity → The G1 held package) |
| **G2 — release** | End of the **Prove** unit, after the post-implementation review is adjudicated | Whether what was built is fit to stand | The evidence, the post-implementation review, the adjudication, and any residual limitation |
| **G3 — lifecycle** | The **Land** unit | Adopt, hold or reject — and for a capability, which `status:` the record takes | Everything above plus the real-use result |

**Escalation into challenged arms G1 immediately.** A unit that escalates mid-flight does not skip the gate it has already passed the position of; it stops at G1 with whatever package exists, and says what is missing.

**Review placement is structural, not procedural.** The pre-implementation review belongs to the **Shape** unit and the post-implementation review to the **Prove** unit. Because cardinality gives challenged work one unit per phase, those are different units, so `{shape-unit}.review-1.md` and `{prove-unit}.review-1.md` are **different files by construction**. Neither is ever mutated into the other, and no unit ever holds both. That is what makes "two distinct reviews" a property of the file layout rather than a discipline someone has to remember.

- **Shape's review reads a plan, not a diff.** Its object is `{shape-unit}.plan.md` — what will be done and what would falsify it. It is the only gate that can stop a bad change *before* it is made, which is why a challenged unit may never be run as reviewed.
- **Prove's review reads the result against Shape's falsification criteria.** Its object is the implemented change plus `{prove-unit}.evidence.md`. It asks whether what Shape said would falsify success actually occurred — not whether the work looks reasonable.

A `review-2` in either unit is a closure review after corrections, justified only when the corrections changed something the first review's verdict rested on — never on a general wish for more assurance. It is never the other phase's review filed in the wrong unit. **§ Reviewed-object identity → Correction lifecycle owns the full sequence** — one initial review, at most one material correction, at most one `review-2`, no `review-3`, and `hold-reframe` when a material finding survives `review-2`. (The Independent Review SOP is an **operator-supplied document that does not live in this repository**; its five triggers cannot be the operative test here, because nothing in the repository states them. The bar above is this contract's own and is what a reader applies.)

**Build sits between G1 and G2 and holds no review of its own.** Build units are one per slice; each returns evidence and commits, and the stream's correlation is what lets Prove read every slice's evidence at once. A slice that cannot be verified is a finding at Prove, not a fourth gate.

---

## Reviewed-object identity and the G1 precondition

**A review is worth exactly what it inspected, and "the plan" is a name rather than a proof.** The challenged route's whole value is that G1 decides on something an independent reviewer actually read. A name cannot carry that: a plan may be revised between the review and the gate, and the package would still be described in the same words. So a challenged Shape unit identifies what it carries to G1 by **content**, not by name.

Observed failure this makes impossible (2026-07-29, two streams — `prime-minimum-responsibility` and `review-layer-consolidation`): a plan revised after review reached G1, in full compliance with the contract as it then stood, because the held package was specified by name and no consumer-side check compared the presented plan against the reviewed one. Nothing was wrong on disk and nothing warned. *Rejected alternative:* trust the revision label. `-v2` is navigation, not content, and it is written by the same session that would benefit from getting it wrong.

### Plan identity

Three fields; the blob is the authority on content.

| Field | Form |
|---|---|
| `PLAN-PATH` | repository-relative path |
| `PLAN-COMMIT` | full 40-hex commit SHA at which the plan exists at that path |
| `PLAN-BLOB` | full 40-hex blob SHA of the plan at that commit |

**Binding relation:** `git rev-parse {PLAN-COMMIT}:{PLAN-PATH}` returns `{PLAN-BLOB}`. Abbreviated SHAs are rejected, so every comparison is exact string equality — no prefix matching, and no second hash beside the blob.

### Review identity

The same three fields, for the review artifact.

| Field | Form |
|---|---|
| `REVIEW-PATH` | repository-relative path — `logs/loop/{unit}.review-{n}.md` |
| `REVIEW-COMMIT` | full 40-hex commit SHA at which the review exists at that path |
| `REVIEW-BLOB` | full 40-hex blob SHA of the review at that commit |

**Binding relation:** `git rev-parse {REVIEW-COMMIT}:{REVIEW-PATH}` returns `{REVIEW-BLOB}`.

**Review identity is computed by Claude after verbatim transcription and commit — never declared by the reviewer.** A reviewer cannot name the commit that will contain its own transcription, so asking for it in the `REVIEW` block would be unsatisfiable. The order is: validate the header, transcribe verbatim, commit by pathspec, then compute the three fields from git and verify the binding relation.

### The review header carries the plan identity

Every Shape `REVIEW` block carries three lines after the six standard header fields:

```
PLAN-PATH:   logs/loop/{shape-unit}.plan[-v{n}].md
PLAN-COMMIT: {40-hex}
PLAN-BLOB:   {40-hex}
```

The reviewer emits **plan** identity only; review identity is Claude's to compute, above. `.agents/skills/work-loop/SKILL.md` carries the same requirement from the reviewer's side and is the surface Codex reads.

**The header is validated before the review is transcribed, never after.** A review artifact is immutable (§ Artifacts), so a malformed header written into one would have no lawful correction path afterwards. Validating first makes every transcribed review valid by construction.

### The G1 precondition

Runs in the Shape unit, after adjudication, immediately before G1, and nowhere else.

1. The candidate plan is committed. Uncommitted, dirty or absent is a stop.
2. Compute the candidate identity — `PLAN-PATH`; `PLAN-COMMIT` = `git log -1 --format=%H -- {PLAN-PATH}`; `PLAN-BLOB` = `git rev-parse {PLAN-COMMIT}:{PLAN-PATH}`.
3. Take the plan identity from the latest valid review — `review-2` where one exists, otherwise `review-1`.
4. Verify that review's own plan binding relation. This is what catches an internally inconsistent header.
5. Compare all three plan fields by exact string equality.
6. Compute and verify the **review** identity of the artifact just used.

**G1 is blocked by any one of:** a candidate that is uncommitted or absent · no review artifact · a missing field · a malformed field, including an abbreviated SHA · a review whose stated blob is inconsistent with its own commit and path · any plan field differing from the candidate's · a review identity whose binding relation fails.

The stop names the failed field and both values. G1 does not open and no package is presented. **Fail-closed: absence of proof blocks.**

**This is a precondition on G1, not a stop of its own.** It puts no decision in front of the operator — it either lets G1 open or blocks before it. A passing comparison produces no stop; it is reported in one line inside the package. The stops stay exactly three.

### The G1 held package, in identities

| Element | Displayed as |
|---|---|
| Plan | `PLAN-PATH` + `PLAN-COMMIT` + `PLAN-BLOB` |
| Review | `REVIEW-PATH` + `REVIEW-COMMIT` + `REVIEW-BLOB`, and the plan identity that review names |
| Adjudication | one disposition per material finding, each with its reason |
| Slice list | the slices Build will execute |
| Limitations | residual limitations |
| Comparison | one line — passed, with the matched plan blob |

A package that presents its plan or its review by bare name has not met this section.

### An `unassessed` review cannot open G1

**An inline or self-review recorded `unassessed` cannot satisfy the precondition.** It is not independent, so a plan resting on it is not an independently reviewed plan — and § The challenged route gives Shape's review the one job of stopping a bad change *before* it is made. This replaces the `unassessed` path at G1 **for challenged Shape only.** `unassessed` is not removed from the contract: it remains available for reviewed-route work and for Prove, where the fallback is unchanged.

When the independent reviewer cannot inspect the plan:

- stop before G1;
- **leave the Shape unit open** — do not close it, and do not mark its evidence `Status: complete`;
- return a **blocker handoff**: the six-field block header, the plan identity, why G1 is blocked, and what would unblock it;
- open no gate and invent no new `CLOSE` outcome.

**This needs no new machinery.** An open unit whose evidence lacks `Status: complete` is already *incomplete* under § Resume order, so Tier 2 re-offers it and the stream resumes when independent review is available. The existing mechanism is the recovery path.

### A malformed header — one repair, with a receipt that survives a restart

A missing or malformed `PLAN-PATH`, `PLAN-COMMIT` or `PLAN-BLOB` blocks G1. Exactly **one** mechanical re-emission may be requested, and it is spent in this order:

1. **Write the `HEADER-REPAIR` receipt first** — into `logs/loop/{unit}.evidence.md`, committed by pathspec, **before** anything is requested. It records four things: the date · that the single re-emission allowance is now **consumed** · the plan identity the received block named, as received · and the received block's **verdict, finding IDs, and material and minor counts**.
2. **Request the re-emission.** It is **header-only** — the same review with the three `PLAN-*` fields corrected. A formatting repair, not a new review and not a revised one.
3. **Check the re-emission against the receipt.** Its verdict, finding IDs and counts must match what was recorded. Consistent → transcribe and continue. A mismatch on any of them means it is not the same review, so the allowance does not cover it: stop before G1, leave the unit open, return the blocker handoff. A second invalid header takes the same stop.

**Resume rule.** An executor resuming an open Shape unit reads the evidence before acting. A `HEADER-REPAIR` entry is proof that the allowance is already consumed: **no further re-emission is permitted**, and the only remaining moves are a valid header or the blocker stop. That is what makes the cap survive a restart instead of resetting with every session — a control expressed only as an in-session intention is not a cap.

**Why the receipt goes to the evidence file and not the review artifact.** A malformed header must never be written into `logs/loop/{unit}.review-{n}.md`, which is immutable and where no lawful correction would exist. The evidence file is append-only but not immutable, and exists precisely to record what was received and observed. A receipt is not a transcription.

The header request is **not** `review-2`, does **not** consume the material-correction budget, and does **not** trigger `hold-reframe`.

**Declared residual.** Matching verdict, finding IDs and counts detects a substituted or renumbered review. It does not detect a re-emission whose reasoning changed underneath an unchanged set of IDs. That is a deliberate proportionality decision, recorded here rather than hidden.

### Correction lifecycle

- One initial independent review — `review-1`.
- At most **one** material correction. It produces a new immutable plan revision, never an edit to the reviewed one.
- At most **one** closure `review-2`, justified only when the correction changed something the first verdict rested on.
- **No `review-3`.** It does not exist in the same unit or stream.

After `review-2`:

- no material change still required → the exact reviewed revision proceeds to the G1 precondition above, then to G1;
- material change still required → the stream closes **`hold-reframe`**.

Non-material findings consume nothing — see § Materiality. A settled finding is not reopened without new evidence.

#### `hold-reframe`

`hold-reframe` is the terminal outcome for an unresolved material `review-2`, and it is reserved for exactly that case. It is a fifth unit outcome joining the three that close without altering the object under work: Shape makes no object edit, so § Closing without a change applies to it unchanged — evidence carrying the outcome and both identities, the `CLOSE` block, the stream closing in the same commit, and the durable `logs/decisions.md` pointer with the recovery SHA.

**It is terminal for the stream and it is not a gate.** It opens no operator decision and adds no stop. Continuation starts a **new** stream whose brief cites the held one and states what is being reframed.

**Shape review point only.** A Prove-side `hold-reframe` would have to dispose of object edits that have already landed; that is a release question, and it belongs to G2.

#### `hold-reframe` on a capability record

Non-capability challenged work has no record and needs nothing beyond the above. A challenged **capability** stream closes its record like this, using existing fields and sections only:

1. Append the `## Units` row with outcome `hold-reframe` — append-only, never a rewrite.
2. Set `active_unit: none` and `updated:` to today, in the closing commit.
3. Set `status: paused` with a concrete `reopen_trigger:`. The **stream** is terminal; the **capability** is not, so no TERMINAL status is correct here. A `paused` record without a trigger is malformed.
4. Write the held stream's closing commit SHAs into `## Pointers` **before** its `logs/loop/{STREAM}-*` artifacts are deleted at stream close — once deleted, those SHAs are the only route back.
5. State in `## Current phase and next action` that continuation requires a new stream citing the held one, and what must be reframed.

**Resume — the one exception to the carry rule.** On operator-authorized continuation from a `hold-reframe` record, the executor **allocates** a new stream by the ordinary collision check (§ Streams, units and phases) and updates `stream:` to it, preserving the held stream in `## Pointers`. The `## Units` table keeps its existing rows unchanged; new rows carry the new stream's unit ids.

**The exception is stated for `hold-reframe` and for nothing else.** Every ordinary continuation still carries the stream unchanged, so the silent-split hazard that rule exists to prevent is untouched. The exception is safe precisely because the held stream is terminal and its artifacts are already deleted: nothing is left to correlate against, which is the condition that makes carrying correct in the ordinary case.

### Materiality

A change to a reviewed plan is **material** when it can affect execution or judgment: need or intended outcome · scope or exclusions · architecture or behavioural design · interfaces, consumers or ownership · slice boundaries or ordering · acceptance or falsification criteria · verification design · rollback or risk · the basis of a review verdict or an operator decision. Spelling, punctuation, formatting and non-substantive citation repairs are non-material **only** when meaning is unchanged. **Ambiguity resolves as material.**

**A non-material finding is annotated, never mutated in.** It is recorded in the adjudication or as a G1 annotation, and it cannot change the plan's blob. That is what stops a wording note from minting a revision and pulling another review round in behind it. A material correction is the only thing that produces a new revision, and it spends the one correction the lifecycle allows.

---

## Streams, units and phases

A **stream** spans many units. A **unit** is one bounded piece of work with one brief, one evidence package and one review lifecycle — one initial review, at most one material correction, at most one closure `review-2`, no `review-3` (§ Reviewed-object identity → Correction lifecycle).

```
STREAM = {date-of-first-unit}-{slug}[-{n}]
UNIT   = {STREAM}-{phase}
```

The stream is allocated once, at its first unit, and carried forward unchanged — a Prove unit keeps the stream's original date even when run days later. **One case allocates instead of carrying, and only one:** continuation from a record that closed `hold-reframe`, whose held stream is terminal and whose artifacts are already deleted (§ Reviewed-object identity → `hold-reframe` on a capability record). Every other continuation carries.

**Collision handling.** Before allocating, check **both** surfaces for the candidate id: any `logs/loop/{candidate}-*` artifact, and any `development/*.md` carrying `stream: {candidate}`. On a hit append `-2`, then `-3`, until clear. Unit ids derive from the resolved stream and cannot collide independently. Allocation is single-writer, so an existence check suffices — no allocator, no shared counter.

**Cardinality.** Solo is exactly **one** unit; the stream is that unit, with no record and no `active_unit`. Reviewed and challenged run **one unit per phase**, except Build, which is **one unit per slice**. One unit per phase is what makes distinct pre- and post-implementation reviews structural rather than procedural: they belong to different units, so they are different files by construction and neither is ever mutated.

| Phase | Question it closes |
|---|---|
| **Frame** | What is the need, who owns it, and is it in scope at all? |
| **Shape** | What exactly will be done, and what would falsify it? |
| **Build** | One slice implemented — repeated per slice |
| **Prove** | Did it work, judged against what Shape said would falsify it? |
| **Land** | Adopt, hold or reject — the lifecycle decision |

**Correlation.** Siblings are found by globbing `logs/loop/{STREAM}-*`. Challenged **non-capability** work has no capability record and correlates purely by stream — no extra file is required. Capability units use the same stream key and *additionally* get the `## Units` table in their record.

**Correlation is what makes the challenged route work across sessions, and it has one hard requirement:** a Prove unit must be able to read its stream's Shape review **on disk**, days later and after any number of `/clear`s. Two rules together guarantee it — the stream id carries the *original* first-unit date unchanged (so the glob still matches), and § Artifacts retains every `{STREAM}-*` file until the stream closes (so the file is still there). Neither alone is sufficient. This is why retention is per stream and not per unit, and why a Prove unit must never re-date the stream to the day it happens to run.

To pick up a stream, glob `logs/loop/{STREAM}-*` and read what is there; **do not reconstruct a prior phase's output from memory or from the conversation.** A phase whose artifact is missing is a § Reconciliation stop, not something to re-derive — re-deriving a Shape review inside the Prove unit would silently collapse the two distinct reviews into one, which is the exact property the route exists to provide.

---

## Artifacts

Durable state: `projects/{p}/development/{slug}.md` (written by `/work-loop`), `logs/decisions.md` (append-only, any session), `logs/missions/{id}.md` (`/mission` only), and git history.

Temporary state lives entirely in `logs/loop/`, single-writer:

| Artifact | Authored by | Written by | Mutability |
|---|---|---|---|
| `{unit}.brief.md` | Codex | Claude transcribes once — or Codex directly when rooted in the target repo | **Immutable** |
| `{unit}.plan.md` | Claude | Claude | **Immutable** — a revision is `-v2` |
| `{unit}.evidence.md` | Claude | Claude | **Append-only, not immutable** |
| `{unit}.review-{n}.md` | Codex | Claude transcribes | **Immutable** |

**The review path is `logs/loop/{unit}.review-{n}.md` with `n ∈ {1, 2}`, and nothing else is a valid review artifact.** The ordinal starts at 1. A closure review after corrections — justified only on § The challenged route's bar, and never on a general wish for more assurance — is `-2`, never an edit to `-1`. **`n ≥ 3` does not exist:** the lifecycle permits no `review-3`, so a `review-3.md` is not a file to be written but a signal that the stream should have closed `hold-reframe` (§ Reviewed-object identity → Correction lifecycle). Pre- and post-implementation reviews are never both in one unit.

**Commit boundary.** Every temporary artifact is committed by explicit pathspec **at write time**, before the next phase begins.

**Retention is per stream, not per unit.** A Prove unit must be able to read its stream's Shape review **on disk**, and reconciliation must be able to see completed units. The **stream-closing commit deletes every `logs/loop/{STREAM}-*` file together.** The final unit of a stream closes the stream in that same commit — no stream sits in an "awaiting closure" state. The record's `## Pointers` carries the commit SHAs, so every deleted artifact stays recoverable from git; there is no permanent handoff archive.

**Confidential material never enters the repository — in any directory, gitignored or not.** Trial material containing real buyer, CRM, email or relationship data stays in its source system, in an external tool, or in an explicitly created OS temporary directory **outside** the repository:

```bash
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp}/axcion-capability-XXXXXX")
```

State `WORKDIR` in chat so the operator can find it, and **delete it when the unit closes** — `mktemp -d` persists until reboot, so a directory holding buyer data outlives the work that needed it unless removal is an obligation rather than a suggestion. If it must survive the unit, say so explicitly and say why.

**"Put it in the session scratchpad" is not a safe instruction here, and this contract used to give it.** `logs/scratchpads/` is gitignored but sits *inside* the repository tree, and gitignored is not outside: one forced stage or one `.gitignore` edit exposes it, with nothing warning. The boundary that matters is the **repository** boundary, not the commit boundary. `WORKDIR` is for **trial** material only — review and brief material is *redacted at the source* and then lives where § Artifacts puts it, because diverting it elsewhere would break the correlation and immutability rules this contract depends on. The method-side statement of the same rule is `skills/capability-development/SKILL.md` § Data handling. The two are kept **textually equivalent on three points** — the repository boundary, the `mktemp -d` `WORKDIR`, and disposal at unit close with an explicit stated reason for any survival — so a divergence on any of them is a defect to report, not a nuance to interpret. This section is the one that binds every route.

**Ordering rule (crash atomicity).** Git commits are atomic; the write sequence leading to one is not. Within a unit-open operation write `logs/loop/{unit}.brief.md` **first**, then set `active_unit` in the record, then commit both by pathspec. The brief is the fact; `active_unit` is only a pointer. A dangling pointer and an orphan brief are both detectable and repairable; a pointer written with no brief behind it is the harder case, so it is written second.

**Artifact root — one rule, no judgement.** A unit's artifacts live in `logs/loop/` **of the repository its block names in `REPO`**, and `/work-loop` is invoked **from that repository's root**. So the invoking session's cwd, the artifact root and `REPO` are always the same directory, and every glob in § Reconciliation and § Resume order — all of which are repository-relative — keeps working with no extra machinery. A session rooted elsewhere does not write the unit to its own root and hope: it stops and says which root to re-invoke from.

Observed failure this makes impossible (2026-07-28, `logs/decisions.md`): a unit declaring `REPO: ai-resources` had its brief and evidence committed at the *workspace* root, because the command globbed the invoking session's cwd. Nothing was wrong on disk and nothing warned, but a `/work-loop` rooted in `ai-resources` could not see the open unit at all — the stream was unreachable from the only root entitled to resume it. *Rejected alternative:* let artifacts follow the invoking root and treat `REPO` as informational. Simpler to state, but it lets one stream split across two roots with no signal, and a stream whose Shape and Prove units sit in different repositories cannot correlate — a silent wrong answer where this rule gives a loud stop.

**The brief precedes every other artifact of its unit, without exception.** It is the index the whole resume and reconciliation design keys on: § Resume order globs briefs, and every row of § Reconciliation matches on a brief or on a pointer to one. An evidence, plan or review file whose brief does not exist is therefore unreachable by both — not merely untidy, but invisible. This is why the unit opens at step 3, before premise verification: it guarantees that any artifact a unit produces, including the evidence for its own rejection, already has a brief in front of it.

---

## Block formats

Six blocks carry work between the models. Every block header carries all six fields:

```
UNIT: {unit-id}      STREAM: {stream-id}    PHASE: {phase}
REPO: {target repo}  BASE: {git SHA}        NEXT: {who acts next}
```

| Block | Direction | Body |
|---|---|---|
| **BRIEF** | Codex → Claude | Need · scope · premises to verify · what would falsify success. 15–25 lines |
| **PLAN** | Claude, challenged only | What will be done, in order · what it touches · what would falsify it |
| **EVIDENCE** | Claude → Codex | Per claim: what was run, what was observed. `LIMITATIONS:` populated, never blank |
| **REVIEW** | Codex → Claude | Findings, **premise dimension first**. Each finding states the object it inspected. A **Shape** review additionally carries the three-line plan identity after the six header fields (§ Reviewed-object identity → The review header) |
| **ADJUDICATION** | Claude | One disposition per material finding (below), each with its reason |
| **CLOSE** | Claude | Outcome · commits · what closed · whether the stream closed with it |

```
**Capability:** {slug}          ← bare slug, OR a workspace-relative path to the record. Nothing else.
**Settled upstream:** operating outcome, need validation, ownership and seam, and the adoption
decision. Do not reopen these. Qualify the ARTIFACT only; return its disposition here, not to the operator.
```

**A `BRIEF` handed out to `/develop-ai-resource` carries those two extra labels — a contract between the commands, not a courtesy.** Both are required; either alone is a malformed handoff. **`**Capability:**` takes the bare slug or the path and nothing else — no owner, no trailing `record:` clause.** The composite form carried by the superseded `develop-capability-build-plan*.md` drafts is **rejected** by Step 1.0's check 1, and fails as a *provenance* error rather than a format one, which is far harder to diagnose. The pair is a *claim* of provenance, not proof of one — any document can carry them — so Step 1.0 verifies it against the named record on disk before honouring it, and reports a malformed handoff rather than repairing it. That verification is the consumer's; this section owns only the shape.

**Five outcomes**, exactly one per `CLOSE` block. The first changed the object under work; the other four did not, and all four take § Closing without a change:

`close` — the work landed · `rejected-premise` — a load-bearing premise was disproved at step 4 · `route-unavailable` — the classified route is not built in this revision · `routed-out` — the unit's **whole need** left the loop terminally under § Execution boundary, which owns the whole-need-versus-component distinction and is the section to read before closing any hand-off · `hold-reframe` — a material finding survived `review-2` at a challenged **Shape** review point, so the correction lifecycle has run out and the stream closes terminally (§ Reviewed-object identity → `hold-reframe`). Mis-closing a component hand-off as `routed-out` deletes the stream's artifacts under § Artifacts while the capability is still in development, stranding the record the disposition must return to.

This is the unit's outcome axis. A capability's `status:` (adopt / hold / reject at Land) is a separate axis on the record and never substitutes for one of these.

**Six dispositions**, one per material finding: `fixed` · `deferred` (with the trigger that reopens it) · `rejected` (with the evidence that disproves it) · `already-true` (with the citation) · `out-of-scope` (with the owner) · `operator` (needs a decision this loop cannot make). `/triage` does not fire — adjudication is the loop's own step 7.

**Evidence standard.** Every claim names what was run and what was observed. A bare assertion is not evidence, and an empty result is not evidence until a positive control has shown the check can detect the thing it is looking for.

---

## Closing without a change

Four outcomes close a unit that never altered the object under work: `rejected-premise`, `route-unavailable`, `routed-out` and `hold-reframe`. All four take the **same** path, and it is the ordinary one — there is no separate lifecycle for a unit that stops early.

1. **Write `logs/loop/{unit}.evidence.md`** carrying the outcome and the proof of it: for `rejected-premise`, the premise and what disproved it; for `route-unavailable`, the trigger that fired and the revision that lands the route; for `routed-out`, the owner and the brief handed over; for `hold-reframe`, the surviving material finding **and both identities** — the plan's and the review's, each as path, commit and blob — so the held object is recoverable by content and not only by name. `LIMITATIONS:` is populated as on any unit. Mark it `Status: complete` — the unit is finished, not outstanding, and § Resume order must not offer it again.
2. **Write the `CLOSE` block** with that outcome, then close the stream. A unit that stops before implementation is always its stream's last unit, so the stream closes in the same commit and its artifacts are deleted there, exactly as § Artifacts prescribes.
3. **Append the durable pointer** (below) in that same commit.

**The durable pointer is not optional, and it is what keeps the outcome findable.** A unit that closed as `close` leaves its change in the repository; the change *is* the durable trace. These four leave nothing — no change, no record for non-capability work, and artifacts deleted at stream close. Without a pointer their only trace is a deleted file in a commit no one holds the SHA for, which is indistinguishable from the work never having been attempted. That is how a disproved premise comes back as the same brief a week later.

So the closing commit appends one entry to `logs/decisions.md`:

```
## {date} — /work-loop {unit}: {outcome}

**Need.** {the brief's need, one line}
**Outcome.** `{outcome}` — {the premise and what disproved it · the unbuilt route · the owner}
**Artifacts.** `logs/loop/{unit}.*`, deleted at stream close; recoverable at {SHA}.
```

Four lines. It is a decision record in the ordinary sense — *this was not done, and here is the evidence for why* — so it needs no new log and no new convention.

**Never delete the evidence without writing the pointer**, and never write the pointer without the SHA. Either half alone re-creates the gap this section closes.

---

## Reconciliation

Runs at **every** invocation, before any resume tier is consulted. Deterministic — no guessing. Every repair reported in one line. Git is the tiebreak: the last commit is the last known-consistent state, and `git status` names what is uncommitted.

| Observed | Action |
|---|---|
| `active_unit: X`; no `X.brief.md` on disk **and** none in git | The unit never opened. Reset to `none`, report, offer a fresh open. |
| `active_unit: X`; `X.brief.md` absent from the tree but **present in git history** | Uncommitted deletion or lost working tree. Restore from git, report the SHA, continue. |
| `X.brief.md` names a capability whose record reads `active_unit: none`, **and `X.evidence.md` is absent or lacks `Status: complete`** | The record write was lost. Show both paths, re-point `active_unit` to X, report. |
| Same, but **`X.evidence.md` carries `Status: complete`** | **Normal — no action, no report, no repoint.** A completed unit whose artifacts are retained until the stream closes is not outstanding work. |
| `active_unit: Y` while an **incomplete** `X.brief.md` for the same stream is open | **Stop. Report both paths. The operator decides.** Never merge, never guess. |
| Any `logs/loop/{unit}.{evidence,plan,review-*}.md` whose `{unit}.brief.md` is absent **from the tree and from git history** | The ordering rule was violated — an artifact exists that no tier can reach. **Report the path and stop.** Do not resume it, do not synthesise the missing brief, and **never delete it**: it may be the only copy of a real result, and a rejected premise is exactly the result that lands here. The operator decides whether to re-brief or to record and remove. |
| Uncommitted changes in `logs/loop/` at invocation | Report before resuming. Do not commit silently. |

## Resume order

**Status is a set, not a flag — every tier below matches the whole ACTIVE set.** The ACTIVE statuses are `in-development` · `continue-trial` · `revise` · `paused`; the TERMINAL ones are `adopted` · `keep-local` · `closed` · `retired` · `rejected` (`templates/capability-record.md`, which owns the vocabulary). **Three of the four ACTIVE statuses mean "more work is expected", so a tier matching `in-development` alone makes the other three invisible** — a capability at `revise` or `continue-trial` would silently drop out of resume with nothing reporting it. Reaching a TERMINAL status is the only way to leave the active set.

**Tier 1** — capability records whose `status:` is in the ACTIVE set and `active_unit != none`.
**Tier 2** — streams with an incomplete unit. Glob `logs/loop/*.brief.md`; a unit is **incomplete** when its evidence is absent or lacks `Status: complete`. Group by stream. Exclude any stream whose incomplete unit is already named by a Tier-1 record. **Completed units are ignored here.**

Tier 2 indexes on briefs, so it cannot see an artifact whose brief is missing. That is deliberate and safe **only because § Artifacts guarantees the brief is written first and § Reconciliation stops on any artifact that lacks one** — the blind spot is closed upstream, before this tier is consulted. Do not widen the glob to compensate; an evidence file with no brief is a reconciliation stop, not a resume candidate.
**Tier 3** — capabilities whose `status:` is in the ACTIVE set and `active_unit: none`; the record's `## Current phase and next action` states what opens next.

Exactly one candidate in the highest non-empty tier → resume it, announcing in one line. More than one → list them once and ask. All tiers empty → treat any argument as a new need; with no argument, ask once. A lower tier is consulted only when every higher tier is empty. **No path sorts by timestamp.**

**Named residuals**, both accepted. (1) A reviewed capability with no mission binding is invisible at session start unless the operator runs `/work-loop`; mission binding is offered when a record opens, and if this bites twice in real use that is the trigger to reconsider a `/prime` step as its own separable change. (2) **`paused` records are not date-gated here.** A record parked with a `reopen_trigger:` of a future date still matches Tier 3 today, so a long park re-offers itself at every bare invocation; `reopen_trigger:` is enforced as *present*, never as *due*. Accepted rather than fixed — gating on it means parsing three trigger shapes (a date, a quarter, a named event), and only the first is machine-comparable. The trigger to revisit is a park that has re-offered itself often enough to be noise.
