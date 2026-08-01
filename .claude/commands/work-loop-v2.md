---
model: opus
effort: high
argument-hint: "[the task id whose state file to act on, or nothing to use the only open one]"
---

Run Claude's half of one Work Loop v2 unit: read the task-state file, check the brief's premises against the live repository, then either hand back a false premise or implement the unit and hand back evidence. Codex frames and assesses; Claude owns repository reality and makes every commit.

Input: `$ARGUMENTS` — a task id, or empty to use the only state file whose `turn:` is `claude`.

**Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before anything else, every invocation.** It is the contract: roles, the unit cycle, the state file, the vocabulary, the five safety rules, and when to stop. This command does the work; it does not restate the contract. Where the two disagree, the core wins and the disagreement is a defect to report.

This command is not a session lifecycle command. It does not invoke `/prime`, `/session-start` or `/session-plan`.

**Scope of this version — Slice 1 Claude side, plus Slice 2 continuity.** Behaviours 1.2, 1.3, the fresh-session pickup (2.1) and file-identity rejection (2.2). Not yet built, and not to be improvised here: the bounded single correction exercised end to end (2.3, 2.4), and the admission test that decides Direct Work versus the loop (Slice 3). If the work in front of you needs one of those, say so and stop — do not invent it.

---

## Step 1 — Orient

Read the state file at `logs/work-loop/{task-id}.md`. Resolve `{task-id}` from `$ARGUMENTS`, or — if empty — from the single file under `logs/work-loop/` whose frontmatter `turn:` is `claude`. If more than one qualifies, list them and ask which. Never guess.

Read the repository, not the conversation. Core § 3 step 1: do not rebuild the situation from memory or from chat.

**Validate the file's identity read-only, before anything else is done with it** (core § 6 rule 2). If the frontmatter `task:` does not match the resolved `{task-id}`, the file is stale or belongs to a different task: report the mismatch — both values, in plain words — and **change nothing**. No inspection record, no turn flip, no commit; the rejection leaves no trace in the file, and that is the point. If it is not obvious which side is correct, the report ends with the question for the operator (core § 7). Then stop. The same applies to a file that is missing or has no readable `task:` / `turn:` frontmatter — report, change nothing, stop.

If `turn:` is not `claude`, stop and say whose move it is. Change nothing.

## Step 2 — Check the premises before acting

Core § 6 rule 1. Take every claim under `## Brief` → `Check against the repository:` and check it **by inspection** — open the file, run the grep, read the line. Not by recall.

Write an inspection record into `## Latest result`, in this shape. The shape is the command's output contract; the acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`) binds to it:

```
Inspected (YYYY-MM-DD):
- Claim (1): HOLDS — searched `<path>` for `<what>`; found `<what was found>`.
- Claim (2): HOLDS — searched `<path>` for `<pattern>`; no match.
```

Two rules govern that record, and both are load-bearing:

- **Every claim gets a line, including the ones that hold.** The record appears even when nothing is wrong — a run that found no problem must still show what it looked at, or a later reader cannot tell inspection from assumption.
- **An absence claim must name what was searched** (core § 6 rule 3). "There is no `Status:` line" is not a finding. "Searched `logs/work-loop/fixture-target.md` for `Status:` — no match" is. Name the surface *and* the pattern.

## Step 3 — If a claim is false, hand back and stop

Core § 1: Claude does not silently repair a bad brief. Core § 7 *Hand back to Codex*.

Do all of this and nothing else:

1. Mark the claim in the inspection record: `- Claim (N): FALSE — searched <path> for <what>; not present.`
2. Write the finding into `## Blocker`, replacing `None.`, naming the claim that failed and what was actually found.
3. Set `turn: codex` in the frontmatter.
4. Set `## Next action` to what Codex must decide.
5. `git add` the state file **by explicit pathspec**, then commit.
6. **Stop.**

**Change no other file.** Not the file the brief named, not a "small fix while I'm here". A false premise means the unit does not begin — `git diff` across every file the brief named must be empty. Building the missing thing so the claim becomes true is the specific failure this behaviour exists to prevent.

## Step 4 — If every claim holds, implement the unit

Stay inside `## Objective and scope`. A change that would touch anything the scope excludes is a hand-back under Step 3's rules, not a judgement call (core § 6 rule 4 — scope changes go to the operator).

## Step 5 — Write the result and the evidence

Into `## Latest result`, below the inspection record:

```
Result: <what actually happened — the latest material result, not a history>
Evidence: <the check, what it returns now, and what it returned before>
```

**The evidence must be able to fail** (core § 6 rule 5). Build its failing case first and see it fail, then see it pass. A line that would read the same whether or not the work happened is not evidence — the commonest form is a check that greps a word the brief already contains.

The state file is current truth, not a diary (core § 4). Replace the previous result; do not append a running log. Git holds the history.

Then set `turn: codex`, set `## Next action` to what Codex assesses, `git add` by explicit pathspec — the state file and the files the unit changed — and commit.

## Step 6 — Report in one line

Say what happened, in plain words: which task, whether a premise failed, what was committed. Then stop. Assessment is Codex's move, not yours.
