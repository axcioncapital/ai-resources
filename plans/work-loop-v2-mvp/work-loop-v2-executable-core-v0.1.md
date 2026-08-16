# The Work Loop — executable core

**Version:** v0.1 (MVP). **Status:** canonical — content at commit `5fef08ff` approved by the operator on 2026-08-14, with § 4's lifecycle contract replaced at the Tracer 3 cutover under the frozen durable-state plan's standing authorisation (`plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`, Tracer bullet 3). Everything outside the state contract is unchanged from the approved content.

**What this is.** The one document that says how the Work Loop runs. The Claude Code command and
the Codex resource **link to this file** and never restate what is in it. One owner, no drift. The
reasoning behind the loop lives in a separate reference document and is not loaded during work.

**Authority.** This file is the Work Loop's own statement of how the loop runs. It was built from
`work-loop-v2-mvp-proposal-v0.4.md`, which is recorded here as historical rationale for the design
rather than a live overriding authority. The operator's content-bound approval of the identifiable
commit carrying this revision is what makes this file canonical.

---

## 1. Who does what

Three parties. Each owns something the others do not.

**Codex** prepares and prioritises the next piece of work. It writes the brief, protects alignment
with the approved objective, and judges whether the evidence supports moving on.

**Claude** owns repository reality. It checks claims against the live repository, implements, tests,
and produces evidence.

**The operator** owns intent and priorities, the approved solution envelope, and the decisions § 7
reserves to them. Consequence alone does not move a decision to the operator; it raises containment,
evidence and review (§ 8).

Four limits on those roles:

- Codex manages progression. It is not sovereign over the project or over the repository.
- Codex's ordinary assessment is a short progression decision. It is not a fresh reading of the
  strategy after every result.
- Claude does not silently repair a bad brief. It reports the problem and hands back.
- Where a unit runs under a specialist Axcíon workflow, that workflow owns its method. The loop
  supplies orientation, progression and assessment only. It never adds a second review or a second
  state system on top.

---

## 2. When to use the loop

**Direct Work is the default.** A small, reversible fix is done directly: no state file, no brief,
no ceremony. Say that Direct Work applies, then do the work.

**The loop is for ordinary meaningful work** — work that is not small and reversible. Entering it
requires a **named reason**, written into the state file when the task opens. "This feels
significant" is not a reason. Reasons that qualify, as a guide and not a closed list:

- The work will not finish in one session, so it must survive a session ending.
- The scope needs bounding before work starts, or it will spread.
- The result needs assessing by someone other than whoever built it before it counts as done.

If the work is small and reversible, it is Direct Work even when one of those is tempting.

**De-escalating.** If work already in the loop turns out to be smaller than assumed, say so, record
what was learned, close the task, and finish the work directly. Do not keep a task in the loop only
because it started there.

Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Consequential
work runs in Standard with stronger containment, evidence and review; it goes to the operator only
when § 7 reserves the decision to them.

---

## 3. The unit cycle

One pass through the loop handles one **unit** — the smallest piece of work worth doing on its own.
A task usually takes several units.

1. **Orient.** Read the state file and the repository. Do not rebuild the situation from memory or
   from the chat. Proportionately re-establish the governing durable sources — the approved plan,
   applicable approved workflows, and authoritative current state — and the current open unit from
   those sources before any plan-dependent work continues. Conversation may point at a source; it
   never establishes authority or current state.
2. **Choose the smallest justified unit.** Smallest that still delivers something observable.
3. **Brief.** Codex writes the brief into the state file: objective, why, claims to check, scope,
   what is excluded, evidence required, and when to stop. It carries the semantic interface the
   Codex skill defines — the unit's justification against the approved plan, each material source's
   disposition, the adjacent work held back, Codex's own framing decisions marked as its own, and
   any material reclassification. That is the brief's content growing, not the state file's: § 4's
   five-field ceiling is unchanged, and no new field, artifact or stage is created.
   Where the brief places its claims to check is free in either of two shapes — each claim marked in
   place where the brief states it, or the claims gathered under one collecting heading such as
   `Check against the repository:`. Both are valid; the marking is what is mandatory. Every claim
   names the file or searched surface and the pattern or evidence that settles it (§ 6, rules 1
   and 3), and the reader reads the whole brief for marked claims rather than relying on any one
   heading.
4. **Execute.** Claude checks the brief's claims first (§ 6, rule 1), then does what the brief's
   completion condition asks. An execution brief is implemented. A **discovery unit** is inspected,
   not implemented: Claude examines the named unknown and returns what is actually there, changing
   nothing beyond the state file, and the hand-back is for Codex to reframe the work or stop. Either
   way, Claude writes the result and the evidence into the state file.
5. **Assess.** Codex reads the result and decides one of four things: close, continue, correct once, or stop.
   **The closing decision is Codex's.** § 4's "Who commits: Claude" is a `.git`-access fact and does
   not restrict Codex's verdict — Codex closes, Claude writes and commits the closing record.
6. **Close, continue, correct once, or stop.**

### The unit's mode

Every open **Standard** unit is in exactly one of three modes, recorded inside `## Lane and unit`
beside the lane and the unit. Mode classifies the unit that is already open: it **is not a third
lane, a new unit type, or a project phase**, and it adds no field, heading or frontmatter key to
§ 4's state file. Direct Work opens no state file and specialist-owned work stays outside the loop,
so neither carries a mode. (Nothing to do with the **courier** of § 4, which is transport, not work.)

**The three are not a sequence.** They are not stages a task passes through, and there is no order
to work down. Each unit is classified on its own, from what is uncertain *now*: a task may run every
unit in one mode and never touch the other two, and a later unit may return to a mode an earlier one
already used. Reading the table below as a pipeline — discover, then implement, then adopt — is the
misreading it most invites, and it would turn mode into the project phase model this section just
said it is not.

**Where the record sits.** Write it as the second sentence of `## Lane and unit`, before the unit:

```
Standard. Implementation mode. Unit 3 — {what this unit does}.
```

The position is what makes it a record rather than prose. A unit whose *subject* is modes will name
all three further down that field, and a reader that scanned the whole field would count three
records where there is one.

Each mode binds to a unit kind step 4 already defines, so no new kind is invented:

| Mode | Use it when | Unit kind | The evidence must |
|---|---|---|---|
| **Discovery** | the problem, requirement, ownership boundary or solution is still uncertain | discovery unit | resolves the named question by inspection, comparison, research or experiment — and does **not implement** the eventual target |
| **Implementation** | objective, authority and boundaries are settled enough to build | execution brief | show the **failing case**, the implemented result, and the regression protection relevant to the change |
| **Adoption** | the capability already exists and the question is whether it enters normal operations | discovery unit | cover real or representative operation, reliability, operator burden, failure conditions and usefulness, and end in an explicit lifecycle decision: **adopt, revise, continue the trial or stop** |

Three rules keep that honest:

- **Implementation does not demand ceremonial tests.** Where a change has no meaningful regression
  check, say so and say why, rather than inventing one that cannot fail (§ 6 rule 5).
- **Adoption asks about operation; it is not a licence to build.** Its named unknown is whether the
  capability should enter normal operations. Where a trial needs the capability actually operated,
  that operating is separate work — Direct Work, a specialist flow, or its own unit — and the unit
  in Adoption mode reads the evidence it produced. It changes nothing beyond the state file, exactly
  as step 4 requires of any discovery unit. This is what lets Adoption exist without a new unit kind.
- **The mode must match the unit's own completion condition.** A unit recorded as Implementation
  whose completion condition asks only for evidence and a hand-back is misclassified, and so is a
  unit recorded as Discovery whose completion condition asks for a built result. The completion
  condition settles it, not the label.

### The "good enough, proceed" judgment

At assessment, Codex's job is the executive call — *is this good enough to move on?* — not finding
more things to improve. The quality bar is pilot quality with limitations written down, not
completeness.

Four statements make that bar checkable rather than a matter of taste:

- **The target is a useful 85–90% result.** Absolute completeness is not the bar, and it is not a
  reason to continue a unit.
- **Minimum necessary work.** A unit does only what its completion condition requires. Work that
  would improve the result without being needed to satisfy that condition is a deferral (§ 5), not
  part of the unit.
- **Evidence is scaled to consequence.** The evidence must be able to fail (§ 6 rule 5); it is not
  required to be exhaustive. A larger check than the consequence warrants is ceremony.
- **There is no perfection pass.** A correction round exists (*Correcting once* below) and is frozen
  to the assessment's named findings. Nothing else re-opens a unit.

These four are owned here. The Codex skill and the Claude command cite this section; neither restates
them.

> *Added 2026-08-07. This clause was approved on its own, and the rest of the file was not
> approved with it at that time. That limitation was superseded on 2026-08-14, when the
> operator's content-bound approval of commit `5fef08ff` made the whole file canonical.*

### Continuing — accepting the unit and opening the next

Continue accepts the completed unit and opens the next one in the same task, because the task's
objective — a named exit condition — remains unmet. It is an acceptance, not a correction: findings
go through the correction round below, and a task whose objective is met closes rather than
continues.

On a continue, Codex records the accepted result as the last material result in `## Latest result`,
writes the next unit's brief (step 3), updates `## Lane and unit`, and sets `turn: claude`. The task
stays open; nothing is reduced to the closing record.

**There is no continue token.** A continue is recognised by its precondition, not by a marker: the
file already carries an accepted result from a previous unit of the same task. Where that
precondition holds, a `Next action` that opens with neither the close token nor the correction token,
and carries a new brief, is a continue. Where it does not — a task's first unit, whose
`## Latest result` records no accepted unit — the same tokenless shape is an ordinary opening, and
reading it as a continue is the mistake this precondition exists to prevent. Because the recognition
rests on the precondition, writing `Continue` as though it were a token is wrong twice over: it
invents a marker the protocol does not have, and it lets a file claim a continue its own state does
not support.

### Closing — the verdict and the record are two moves

Closure is Codex's verdict (step 5) and Claude's write (§ 4, Who commits). Codex does not write the
closed file, and Claude does not decide closure.

**The close token.** Codex writes its close verdict into the state file's `Next action`, opening with
this exact line:

```
Close the task:
```

followed by what the closing record must carry beyond the repository facts: the outcome as Codex
judges it, any deferral recorded at the closure check with its reason, the menu choice and its
value-and-risk ground if one was used, and any accepted limitation. Codex sets `turn: claude`. Claude
reads that line as the signal to reduce the file to § 4's closing record, set `status: closed` and
`turn: operator` in the same write, and
commit. Like the hand-off token below, it is a protocol token shared by both sides: named here, once,
so the producer and the consumer cannot drift apart. Change it here or nowhere.

### Correcting once

If the assessment finds real problems, the correction works like this and only like this:

```
Assessment names the material findings: A, B, C
        ↓
The correction scope is frozen at A, B, C
        ↓
Claude corrects A, B, C
        ↓
The closure check asks two questions only:
  are A, B and C resolved, and did the correction break something?
        ↓
Close, or use the menu below.
```

Anything newly noticed during the closure check is **recorded as a deferral**. It never becomes a
second correction round.

**The hand-off token.** Codex writes the frozen findings into the state file's `Next action`, opening
with this exact line:

```
Correct once — frozen findings:
```

followed by the numbered findings. Claude reads that line as the signal that the invocation is the
one correction rather than a new unit. It is a protocol token shared by both sides: it is named here,
once, so that the producer and the consumer cannot drift apart. Change it here or nowhere.

### If the correction was not enough

Codex chooses **once**, on value and risk — not on a round counter: accept it as a written
limitation; permit one final tightly-bounded fix; revert; reframe the unit; or stop.

The final fix gets no new broad review, and its closure check covers that fix and nothing else. If
the choice is really about accepting risk, it goes to the operator. This menu is the way out of
correction, not a way back into it.

---

## 4. The task-state file

**One task, one file.** It is the only interface **between Codex and Claude** — they never speak to
each other, so anything one needs the other to know is in the file or it is lost. Its physical shape
may change later if real use justifies it. Its role as the single interface does not.

**The operator is not behind that interface.** They talk to both models directly, and they carry the
turn between them. This matters most at the very start: a new request reaches Codex by the operator
telling it, before any file exists. Requiring the file first would be circular — the file is created
*by* admitting the request, so it cannot also be the way the request arrives.

### An approved courier may carry the turn

Carrying the turn is transport, not judgment. The operator may approve a **courier** — any mechanism
that moves an *already explicit* turn from one actor to the other — and delegate that carrying to it.
What the courier is made of is deliberately unsaid here; § 24 of the reference document keeps this
document about behaviour rather than transport, and naming a product inside the contract would date it.

A courier may carry a turn the state file **already states**. It may never:

- change the task, the brief, the result, or any other content of the state file;
- choose which actor moves next, or decide that a turn exists — it carries what `turn:` already says;
- continue past a record the validator classifies `BLOCKED_OPERATOR` or `CLOSED`, both of which stay
  terminal for all automation (§ 7 is unchanged by this). A courier reads that classification from
  `logs/scripts/work-loop-state.sh`; it does not work it out from `turn:` or from the body;
- stand in as evidence. A courier's screen, terminal, exit status or user interface is **never
  authoritative**. The state file and the repository are, and whoever reads a courier's result reads
  the file before acting on it.

A courier that would do any of those is not carrying a turn — it is taking one, and the loop no longer
has three parties. The test is whether removing the courier changes any decision: if it does, it was
never transport.

The operator carrying the turn themselves remains valid and is the default. A courier is an option
they approve, not a stage the loop acquires.

> *Added 2026-08-06. This clause was approved on its own, and the rest of the file was not
> approved with it at that time. That limitation was superseded on 2026-08-14, when the
> operator's content-bound approval of commit `5fef08ff` made the whole file canonical.*

**A request that is refused admission opens no file** (§ 2). Direct Work leaves no state behind.

**Where it lives:** `logs/work-loop/{task-id}.md`. Not `logs/loop/` — Work Loop v1 is still live and
scans that folder for its own files.

The state file is **current truth, not a diary.** Anything already true in the repository or in Git
does not belong in it.

### What it contains

The top block between the `---` lines is the **frontmatter**: machine-readable settings that say how
the hand-off works, not what the task is about.

```yaml
---
task: crm-follow-up-date   # the task id; also the file name
status: active             # where the task is in its life: active | blocked | closed
turn: claude               # whose move it is: claude | codex | operator
---
```

**Lifecycle is stated, never inferred.** `status` says where the task is in its life and `turn` says
only whose move it is. The two are different questions, and reading one off the other is the mistake
this contract removes: `turn: operator` used to mean both "waiting on a decision" and "finished",
which are opposite situations that happen to stop the same automation. Only four combinations are
legal, and every other pairing is malformed:

| `status` | `turn` | What it means |
|---|---|---|
| `active` | `claude` | Claude owes execution, correction, or the closing write |
| `active` | `codex` | Codex owes assessment or progression |
| `blocked` | `operator` | Work waits on the decision named in `## Blocker` |
| `closed` | `operator` | Terminal |

**One reader decides, and it is not you.** `logs/scripts/work-loop-state.sh` is the single authority
that turns a state file into one of those four classifications. Every consumer — this document's two
entry points, the ownership helper, and any approved courier — asks it and uses its answer. No
consumer parses the record for lifecycle itself, and none keeps a fallback reading for when the
validator is unavailable: a validator that cannot run means the lifecycle is **unestablished**, which
stops the caller. It never resolves to "open" or "closed" by default. A second reader is how two
consumers come to disagree about one record, which is the whole failure this seam exists to prevent.

The body carries the **content fields**, and holds **at most** these five while the task is active.
The heading strings in the left column are **normative and exact** — the producer writes them and the
consumer reads them literally, so a file written under different headings is malformed:

| Field heading (exact) | What it holds |
|---|---|
| `## Objective and scope` | What is being achieved, and the agreed boundary |
| `## Lane and unit` | Direct or Standard, which unit is open, its mode (§ 3), and the named reason for the loop (§ 2) |
| `## Latest result` | What actually happened last — not a history |
| `## Blocker` | What is in the way, or `None.` |
| `## Next action` | The single next thing |

Five is a **maximum, not a checklist**. A field with nothing real in it is left out.

### What the ceiling covers, and what it does not

The five fields cap what the file says about the task's **state**. Two other things live in the same
file and are not state, so the ceiling does not cover them:

- **`turn`, `status` and `task`** — protocol fields. They say whose move it is, where the task is in
  its life, and which task this is. `task` is what § 6 rule 2 checks a file's identity against.
- **The brief** — a hand-off from Codex to Claude, required by § 3 step 3.

**A deferral needs no field.** Record it at closure among the decisions that matter. If it changes
what happens next, it belongs in Next action instead.

**When the task closes**, everything above is replaced by the closing record — exactly these four
sections, under these exact headings, at `status: closed` and `turn: operator`. Claude writes and
commits this reduction on Codex's close verdict (§ 3, The close token); the shape below is the closed
file's contract for both sides. The reduction is one write: the status and the body change together,
because a `closed` status over a surviving active body is malformed and the validator rejects it.

```markdown
---
task: {task-id}
status: closed
turn: operator
---

## Outcome
{what was achieved}

## Decisions that matter
{the decisions, including any deferral recorded at closure with its reason}

## Evidence
{the final commit or evidence pointer}

## Accepted limitations
{or "None."}
```

### Example

```markdown
---
task: crm-follow-up-date
status: active
turn: claude
---

## Objective and scope
Contacts can carry a follow-up date, visible in the contact view.
Scope: contact model, contact view, their tests. Excluded: notifications, recurring
follow-ups, email integration.

## Lane and unit
Standard. Unit 1 — add the field and show it.

## Brief
Why: follow-ups are tracked by memory today; missed follow-ups are the top reported friction.
Check against the repository: (1) the contact model has no follow-up or reminder field;
(2) the contact view renders from `contact_view` and nothing else reads the display block.
Evidence required: a contact saved with a follow-up date, and the date still visible on reload.
Stop if: claim (1) is wrong, or the change would touch files outside the scope above.

## Latest result
(empty — not started)

## Blocker
None.

## Next action
Claude: check both claims, then implement if they hold.
```

**Not this:**

```markdown
## Latest result
2026-08-01 — added the field. 2026-08-02 — fixed the migration.
2026-08-03 — reverted the migration, see discussion above.
```

A running log makes the reader work out what is true now, and it grows without limit. Keep the last
material result and let Git hold the history.

> **Who commits: Claude.** Codex writes the brief into the file. **Claude makes every commit.**
> Operator decision, 2026-08-01, amending the Proposal's destination behaviour 1, which has Codex
> committing. It follows what Step 2 observed: Codex can write repository files, but was refused
> write access to `.git`, the folder Git keeps its own records in.
> See `step-2-transport-seam-conclusions.md` § 2.
>
> **This is a commit restriction, not a verdict restriction.** It does not limit what Codex may
> decide. § 3 step 5 assigns closure to Codex; this rule only says who runs the commit afterwards.
> *(Added 2026-08-01, S14-198 — FP-12: Codex read this rule as a prohibition on approving or closing
> work and stopped mid-unit. The two sections did not point at each other.)*

---

## 5. Words we use

Use these words and only these. No synonyms: not "ticket" for unit, not "handover doc" for state
file, not "review round" for correction.

| Word | Meaning |
|---|---|
| **Task** | The whole thing being pursued through the loop, from objective to close. One task, one state file. |
| **Unit** | The smallest piece of work worth doing on its own. A task takes several. |
| **Brief** | What Codex writes to tell Claude what to do. Bounded and checkable; it does not dictate the implementation. |
| **Discovery unit** | A unit whose deliverable is evidence about a named unknown, not a change. It ends in a hand-back for reframing or stopping — never in implementing the eventual target. |
| **State file** | The single file holding the task's current truth. § 4. |
| **Lane** | How work is handled: Direct or Standard. |
| **Mode** | Which of three kinds an open Standard unit is: Discovery, Implementation or Adoption. § 3. |
| **Correction** | One bounded round of fixes, frozen to the findings the assessment named. |
| **Evidence** | What shows the result is real. It must be capable of showing that it is not. |
| **Deferral** | A good idea, recorded and not done now, with the reason. |
| **Continue** | The unit is accepted and the next unit opens in the same task, because a named exit condition of the objective remains unmet. § 3. |
| **Close** | The task ends. The state file is reduced to the closing record in § 4. |

---

## 6. Safety rules

These five apply to every unit, in every lane, always.

1. **Check claims against the live repository before acting.** If a claim the work rests on is
   false, do not build on it. Write down what you inspected, what you found, and why the claim
   fails. Then stop and hand back.
2. **Validate an untrusted file read-only before changing anything.** If the state file is missing,
   malformed, stale, or belongs to a different task, report it and change nothing.
3. **An absence claim must say what was searched.** "There is no such field" is not a finding.
   "There is no such field — searched the model, the view and their tests" is.
4. **Scope and success criteria do not change quietly.** A change to either is stated out loud, never
   made silently. The decision is the operator's when the change is one they reserve — the intended
   outcome or the priority, a material expansion of scope, or the removal of an exclusion (§ 7). A
   change that is none of those is disclosed and proceeds.
5. **Evidence must be able to fail.** If the check would pass whatever happened, it is not evidence.
   Build the failing case first, then show it passing.

---

## 7. When to stop and ask

Stopping is a normal outcome. Each trigger below names who to stop for.

**Consequence is not itself a trigger.** Higher consequence means stronger containment, stronger
evidence and a proportional review — not that the decision moves to someone else (§ 8). A
consequential change whose outcome, envelope and capabilities are already delegated stays with the
agent and is done more carefully. What moves a decision is the class it falls in, and the classes are
listed here.

**Hand back to Codex** — write the finding into the state file, keep `status: active` and set
`turn: codex`, commit, and stop:

- A claim the brief rests on is false (rule 1), or a load-bearing premise is still unsupported after
  bounded investigation.
- The work would go outside the approved scope, or touch something the brief excluded.
- The required evidence cannot be produced.
- The approved plan is materially invalid, and repairing it would go outside the solution envelope.
- A capability the work needs is already authorized, but the available technical means cannot enforce
  it safely. That is a technical or infrastructure problem, and the operator cannot waive it: what is
  missing is containment, not permission.
- The action would bypass, weaken, or self-expand the control system. The operator is reached only
  where the remedy would itself materially change the policy governing agent authority, and then
  through that separate class below — never through this clause.

**Stop for the operator** — write the question into `## Blocker`, set `status: blocked` and
`turn: operator`, commit, and stop. `blocked`, not `closed`: the task is waiting, not finished, and
the two are different classifications precisely so this stop cannot be mistaken for a close:

- The intended outcome or the priority would change.
- Scope would expand materially, or an exclusion would be removed.
- Product or business behaviour must be chosen and existing authority does not determine it.
- The approved operating model, a material architecture commitment, the cost or risk profile, or the
  governance model would change.
- Material residual risk would be accepted that was not already delegated — including the case where
  the correction was not enough and the choice among the options in § 3 is really about accepting
  risk.
- The authorized capability envelope would expand, or a capability the work needs has not been
  granted.
- Production deployment, public or customer communication, credential use, or destructive action on
  shared state would be authorized, and no separate explicit delegation already covers it.
- Operator intentions are genuinely tied or in conflict, or governing sources stay materially tied
  after the authority hierarchy has been applied.
- The policy governing agent authority would materially change.
- An **operator-owned** settled decision would have to be reopened — one the operator settled
  themselves, or one falling in a class this list reserves to them. A settled implementation or
  technical decision delegated inside the approved solution envelope does **not** transfer merely
  because it is settled: reopening it is disclosed, stays subject to every other trigger here, and
  remains the agent's to make on the evidence.
- Continuing would require inventing operator intent.
- The state file is stale or belongs to another task, and it is not obvious which is correct
  (rule 2).

These classes are what stop the work. Everything outside them proceeds under § 8, with containment,
evidence and review scaled to what is at stake.

---

## 8. The governing autonomy rule

> **Within the approved solution envelope, resolve what evidence can resolve, exercise professional technical judgment, and use only pre-authorized capabilities. Consequence increases containment and verification; it does not by itself transfer the decision to the operator. Escalate only when continuing requires operator-owned intent, accepted risk, a material change outside the solution envelope, or expansion of the authorized capability envelope. Stop when a load-bearing premise or required verification cannot be established, or when continuing would bypass the control system.**

This rule governs §§ 1–7 above wherever they touch autonomy: § 7 lists the classes that escalate it,
and § 6 rule 4 states how it applies to a change of scope.
