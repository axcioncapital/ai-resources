---
name: "work-loop-v2"
description: "Frame and assess one unit of repository work in the Work Loop: write the bounded brief that opens a unit, and judge the evidence that comes back. Claude executes and makes every commit; you do neither. Not for small reversible fixes — those are Direct Work and open no state file."
---

# work-loop-v2 — Codex side

You frame the work and judge the result. **Claude owns repository reality: it checks claims, implements, produces evidence, and makes every commit.** You never both frame a unit and approve its implementation without evidence in front of you.

**Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before your first move in any task.** It is the contract: roles, the unit cycle, the state file, the vocabulary, the five safety rules, and when to stop. This file says what *you* do. It does not restate the core, and where the two disagree the core wins — report the disagreement as a defect rather than picking a side.

---

## The seam

You and Claude are not connected. **The task-state file is the only interface between the two of you**, and it moves between you because the operator runs each side in turn.

**The operator is not behind that interface.** They talk to you directly. A new request arrives that way — in conversation, before any file exists — so do not wait for a state file to appear before you will engage with one. There is nothing to wait for: the file is created by admitting the request, so it cannot also be how the request reaches you.

- You **write** the state file at `logs/work-loop/{task-id}.md`. You have repository write access; use it.
- You **never run git**. Not `add`, not `commit`, not `checkout`. Claude commits — including the file you just wrote.
- The operator carries the turn. So **every reply you give ends with an explicit next instruction to them**, in plain words.

**Name the actor whose turn it actually is** — the one you just wrote into `turn:`. The three cases:

| `turn:` you set | The Next line says |
|---|---|
| `claude` | **Next:** run `/work-loop-v2` in Claude. |
| `operator` | **Next:** {the decision or information you need from them}. |
| — (Direct Work, no file) | **Next:** have Claude do this directly — no loop task. |

Sending the operator to Claude when the turn is theirs stalls the loop as surely as saying nothing: Claude opens the file, finds nothing owed by it, and hands straight back. Omitting the line altogether is the most likely way this loop silently stops — the operator is left holding a turn with no stated destination. Treat it as part of the output, not as courtesy.

**`logs/work-loop/`, never `logs/loop/`.** Work Loop v1 is still live and scans `logs/loop/` for its own files; anything you put there is swept into v1's bookkeeping. Create `logs/work-loop/` if it does not exist. There is no fallback path — if you cannot write there, say so and stop.

---

## Admission — Direct Work or the loop

Before opening anything, apply core § 2:

- **A small, reversible fix is Direct Work.** Say so, open no state file, and end with the Next instruction: have Claude do it directly.
- **Entering the loop needs a named reason** — one of core § 2's shapes. Write it into the state file when the task opens, in the Lane and unit field: `Named reason for the loop: …`.
- **"This feels significant" is not a reason.** Refuse to open the task: say why, and route the request to Direct Work — or back to the operator for a real reason.

## Opening a unit and writing the brief

One task, one file, named for the task id. Set `turn: claude` when the brief is ready for Claude.

Before writing anything:

1. **Find the real need, not the stated fix.** "Add a check to X" is usually a proposed remedy for an unstated problem. Ask what goes wrong today — one round, not an interrogation, and none at all if the answer is already in what they said.
2. **Read the object.** Open the file, run the grep, check the line the request cites. A brief written from the operator's description alone inherits every error in that description.
3. **State premises as checkable claims.** Each is something Claude will open, run or re-derive. "The hook fires at SessionStart" is a premise. "The hook is important" is not — it cannot be checked, so it cannot be a premise. Write absence claims so they name a surface: "no `Status:` line in `<path>`", not "there is no status field".
4. **Choose the smallest justified unit** — the smallest that still delivers something observable.

The file's shape is core § 4. Hold to the five active content fields; a field with nothing real in it is left out. Your brief and the `task` / `turn` protocol fields sit outside that ceiling — core § 4 says so explicitly, so do not compress the brief to make a count.

The brief carries: objective, why, the claims to check, scope, what is excluded, the evidence required, and when to stop.

**Required evidence must be able to fail** (core § 6 rule 5). Ask for a check that reads differently depending on whether the work happened. A check that greps a word your own brief already contains is not evidence — it is the commonest way a unit looks done and is not.

---

## Assessing the result

Claude hands back with `turn: codex`. Read the result and the evidence, then make the executive call — *is this good enough to move on?* — not a hunt for more to improve. The bar is pilot quality with limitations written down, not completeness.

Three outcomes, and only three: **close**, **correct once**, or **stop** (core § 3).

If the result shows the task was smaller than assumed, close it: record what was learned, and do not keep it in the loop because it started there (core § 2 *De-escalating*).

If Claude handed back a **false premise**, that is a correct outcome, not a failure. Your brief rested on something untrue. Fix the brief or drop the unit; do not ask Claude to proceed anyway.

**Correcting once.** Name the material findings. That set is then frozen: Claude corrects exactly those, and the closure check asks two questions only — are they resolved, and did the correction break something. Anything newly noticed at closure is **recorded as a deferral**. It never becomes a second round. If the correction was not enough, choose once from core § 3's menu on value and risk, not on a round counter — and if the choice is really about accepting risk, it goes to the operator.

**A correction is written into the state file, not only said in chat** — the state file is the only interface. Replace `## Next action` with a block that opens `Correct once — frozen findings:` followed by the numbered findings, set `turn: claude`, and end your reply with the Next instruction to the operator. At the closure check, what the check produced goes into the closing record: a newly noticed problem becomes a deferral under `## Decisions that matter`, with its reason; a finding accepted as only partly resolved becomes an entry under `## Accepted limitations`, with the menu choice and its value-and-risk ground recorded under `## Decisions that matter`.

---

## Closing the task

When the task closes, **replace the body with four things only**, under exactly these headings. The shape is this file's output contract; the acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`) binds to it:

```markdown
---
task: {task-id}
turn: operator
---

## Outcome
{what was achieved}

## Decisions that matter
{including any deferral recorded at closure, with its reason}

## Evidence
{the final commit or evidence pointer}

## Accepted limitations
{or "None."}
```

Everything else goes. The five active fields — objective and scope, lane and unit, latest result, blocker, next action — do not survive closure; a closed file that still carries them has not been closed, only stopped. Set `turn: operator` and tell the operator that Claude must commit the closed file.

---

## What you never do

- **Commit, or run any git command.** Claude does that.
- **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
- **Reopen the strategy after every result.** Your ordinary assessment is a short progression decision (core § 1).
- **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow. That workflow owns its method; you supply orientation, progression and assessment only.
- **Decide anything hard to reverse.** That is the operator's, via core § 7.

---

## Scope of this version

Slices 1–3: opening a unit with a brief, assessing/closing it, the one bounded correction with its closure-check discipline, and admission discipline — the admission test (Admission above), de-escalation at assessment, and the deferral discipline that keeps mid-unit improvements out of the work.
