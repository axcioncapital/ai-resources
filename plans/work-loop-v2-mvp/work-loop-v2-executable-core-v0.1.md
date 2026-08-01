# The Work Loop — executable core

**Version:** v0.1 (MVP). **Status:** draft for operator approval.

**What this is.** The one document that says how the Work Loop runs. The Claude Code command and
the Codex resource **link to this file** and never restate what is in it. One owner, no drift. The
reasoning behind the loop lives in a separate reference document and is not loaded during work.

**Authority.** Built from the Proposal (`work-loop-v2-mvp-proposal-v0.4.md`), which stays
authoritative. Where this file and the Proposal disagree, the Proposal wins.

---

## 1. Who does what

Three parties. Each owns something the others do not.

**Codex** prepares and prioritises the next piece of work. It writes the brief, protects alignment
with the approved objective, and judges whether the evidence supports moving on.

**Claude** owns repository reality. It checks claims against the live repository, implements, tests,
and produces evidence.

**The operator** owns priorities, scope, and any decision that is hard to reverse.

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

Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Genuinely
consequential work stops and goes to the operator instead (§ 7).

---

## 3. The unit cycle

One pass through the loop handles one **unit** — the smallest piece of work worth doing on its own.
A task usually takes several units.

1. **Orient.** Read the state file and the repository. Do not rebuild the situation from memory or
   from the chat.
2. **Choose the smallest justified unit.** Smallest that still delivers something observable.
3. **Brief.** Codex writes the brief into the state file: objective, why, claims to check, scope,
   what is excluded, evidence required, and when to stop.
4. **Execute.** Claude checks the brief's claims first (§ 6, rule 1), then implements, then writes
   the result and the evidence into the state file.
5. **Assess.** Codex reads the result and decides one of three things: close, correct once, or stop.
6. **Close, correct once, or stop.**

### The "good enough, proceed" judgment

At assessment, Codex's job is the executive call — *is this good enough to move on?* — not finding
more things to improve. The quality bar is pilot quality with limitations written down, not
completeness.

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
turn: claude               # whose move it is: claude | codex | operator
---
```

The body carries the **content fields**, and holds **at most** these five while the task is active:

| Field | What it holds |
|---|---|
| Objective and approved scope | What is being achieved, and the agreed boundary |
| Current lane and unit | Direct or Standard, and which unit is open |
| Latest material result | What actually happened last — not a history |
| Unresolved blocker | What is in the way, or nothing |
| Next action | The single next thing |

Five is a **maximum, not a checklist**. A field with nothing real in it is left out.

### What the ceiling covers, and what it does not

The five fields cap what the file says about the task's **state**. Two other things live in the same
file and are not state, so the ceiling does not cover them:

- **`turn` and `task`** — protocol fields. They say whose move it is and which task this is. `task`
  is what § 6 rule 2 checks a file's identity against.
- **The brief** — a hand-off from Codex to Claude, required by § 3 step 3.

**A deferral needs no field.** Record it at closure among the decisions that matter. If it changes
what happens next, it belongs in Next action instead.

**When the task closes**, everything above is replaced by four things only: the outcome, the
decisions that matter, the final commit or evidence pointer, and any accepted limitations.

### Example

```markdown
---
task: crm-follow-up-date
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

---

## 5. Words we use

Use these words and only these. No synonyms: not "ticket" for unit, not "handover doc" for state
file, not "review round" for correction.

| Word | Meaning |
|---|---|
| **Task** | The whole thing being pursued through the loop, from objective to close. One task, one state file. |
| **Unit** | The smallest piece of work worth doing on its own. A task takes several. |
| **Brief** | What Codex writes to tell Claude what to do. Bounded and checkable; it does not dictate the implementation. |
| **State file** | The single file holding the task's current truth. § 4. |
| **Lane** | How work is handled: Direct or Standard. |
| **Correction** | One bounded round of fixes, frozen to the findings the assessment named. |
| **Evidence** | What shows the result is real. It must be capable of showing that it is not. |
| **Deferral** | A good idea, recorded and not done now, with the reason. |
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
4. **Scope and success criteria do not change quietly.** A change to either is stated out loud, and
   a change to scope goes to the operator.
5. **Evidence must be able to fail.** If the check would pass whatever happened, it is not evidence.
   Build the failing case first, then show it passing.

---

## 7. When to stop and ask

Stopping is a normal outcome. Each trigger below names who to stop for.

**Hand back to Codex** — write the finding into the state file, set `turn: codex`, commit, and stop:

- A claim the brief rests on is false (rule 1).
- The work would go outside the approved scope, or touch something the brief excluded.
- The required evidence cannot be produced.

**Stop for the operator** — write the question into the state file, set `turn: operator`, commit, and
stop:

- The change would be hard to reverse.
- Proceeding would need a settled decision to be reopened.
- The state file is stale or belongs to another task, and it is not obvious which is correct
  (rule 2).
- The correction was not enough, and the choice among the options in § 3 is really about accepting
  risk.
- Anything else that is genuinely consequential.

In this version, "stop and bring this to the operator" is the answer for consequential situations.
