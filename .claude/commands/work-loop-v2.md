---
model: opus
effort: high
argument-hint: "[the task id whose state file to act on, or nothing to use the only open one]"
---

Run Claude's half of one Work Loop v2 unit: read the task-state file, check the brief's premises against the live repository, then either hand back a false premise or implement the unit and hand back evidence. Codex frames and assesses; Claude owns repository reality and makes every commit. Not for small reversible fixes — those are Direct Work and open no state file (core § 2).

Input: `$ARGUMENTS` — a task id, or empty to use the only state file whose `turn:` is `claude`.

**Read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` before anything else, every invocation.** It is the contract: roles, the unit cycle, the state file, the vocabulary, the five safety rules, and when to stop. This command does the work; it does not restate the contract. Where the two disagree, the core wins and the disagreement is a defect to report.

This command is not a session lifecycle command. It does not invoke `/prime`, `/session-start` or `/session-plan`.

**Scope of this version — Slices 1–3, Claude side.** Behaviours 1.2, 1.3, the fresh-session pickup (2.1), file-identity rejection (2.2), Claude's half of the bounded correction (2.3, 2.4 — the Correction rounds section below), and admission discipline: the admission test (Admission below), de-escalation (De-escalating below), and mid-unit deferrals (Step 4). Plus the unit's mode (2026-08-06 — The unit's mode below), which Codex classifies and you execute against.

Context Engineering is live on the Codex side. This command **consumes** the engineered brief — checking its claims against the repository and acting on it — and never performs Codex's preparation, authority or selection judgments itself.

---

## Admission — Direct Work or the loop

Runs when the work arrives without a state file — the operator brings a request rather than a task id.

**Core § 2 owns this test.** Read it there and apply it. What this command does with each outcome:

- **Not admitted** — name the part of core § 2 that excluded it, do the work directly if that is the answer, and **open no state file**. `logs/work-loop/` is left untouched; the absent file is the evidence that admission was refused.
- **Admitted** — the named reason core § 2 requires is already written in the state file. If it is missing, the brief is malformed: hand back under Step 3 rather than supplying a reason on Codex's behalf.

When invoked on an existing state file that carries its reason, admission was decided at open — go to Step 1.

## Step 1 — Orient

Read the state file at `logs/work-loop/{task-id}.md`. Resolve `{task-id}` from `$ARGUMENTS`, or — if empty — from the single file under `logs/work-loop/` whose frontmatter `turn:` is `claude`. If more than one qualifies, list them and ask which. Never guess.

Read the repository, not the conversation (core § 3 step 1).

**Validate the file's identity read-only, before anything else is done with it** — core § 6 rule 2 states the conditions; this is what Claude does when one is met. If the frontmatter `task:` does not match the resolved `{task-id}`, report the mismatch — both values, in plain words — and **change nothing**. No inspection record, no turn flip, no commit; the rejection leaves no trace in the file, and that is the point. If it is not obvious which side is correct, the report ends with the question for the operator (core § 7). Then stop. The same applies to a file that is missing or has no readable `task:` / `turn:` frontmatter — report, change nothing, stop.

If `turn:` is not `claude`, stop and say whose move it is. Change nothing.

If `## Next action` opens with core § 3's hand-off token, this invocation is the one bounded correction, not a new unit — go to **Correction rounds** below and skip Steps 2–5.

If `## Next action` opens with core § 3's close token, Codex has decided closure and this invocation writes the closing record — go to **Closing the task** below and skip Steps 2–5.

## Step 2 — Check the premises before acting

Core § 6 rule 1 governs this step. The claims are the brief's load-bearing repository assertions. Core § 3 owns their placement: a brief may mark each claim in place where it states it, or gather them under one collecting heading — both are valid, and each claim names the surface and the pattern or evidence that settles it. So read the whole brief for them, and do not conclude there are none because any particular heading is absent. Check each **by inspection** — open the file, run the grep, read the line. Not by recall.

Write an inspection record into `## Latest result`, in this shape. The shape is the command's output contract; the acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`) binds to it:

```
Inspected (YYYY-MM-DD):
- Claim (1): HOLDS — searched `<path>` for `<what>`; found `<what was found>`.
- Claim (2): HOLDS — searched `<path>` for `<pattern>`; no match.
```

Two rules govern that record:

- **Every claim gets a line, including the ones that hold.** The record appears even when nothing is wrong — a run that found no problem must still show what it looked at, or a later reader cannot tell inspection from assumption.
- **An absence claim names the surface *and* the pattern** (core § 6 rule 3). In this record that is the `searched <path> for <pattern>` clause, not a bare "there is no `Status:` line".

## Step 3 — If a claim is false, hand back and stop

Core § 1 and core § 7 *Hand back to Codex* govern this step. Do all of this and nothing else:

1. Mark the claim in the inspection record: `- Claim (N): FALSE — searched <path> for <what>; not present.`
2. Write the finding into `## Blocker`, replacing `None.`, naming the claim that failed and what was actually found.
3. Set `turn: codex` in the frontmatter.
4. Set `## Next action` to what Codex must decide.
5. `git add` the state file **by explicit pathspec**, then commit.
6. **Stop.**

**Change no other file.** Not the file the brief named, not a "small fix while I'm here". A false premise means the unit does not begin — `git diff` across every file the brief named must be empty. Building the missing thing so the claim becomes true is the specific failure this behaviour exists to prevent.

## Step 4 — If every claim holds, implement the unit

Stay inside `## Objective and scope`. A change that would touch anything the scope excludes is a hand-back under Step 3's rules, not a judgement call (core § 6 rule 4).

**An adjacent improvement noticed mid-unit is a deferral, not work** (core § 5). Record it in the hand-back in plain words — what it is, and why it is not being done now — and leave it unimplemented. A deferral that is neither recorded nor implemented has silently disappeared, which is the failure.

**A discovery unit is inspected, not implemented** (core § 3 step 4). When the brief's completion condition is to establish and return evidence about a named unknown rather than to change the repository, the unit's work is the inspection itself: examine the named surfaces, and write what was found into `## Latest result` with evidence that could have read differently (core § 6 rules 3 and 5). The inspection record still appears even when such a brief pre-states few or no claims — the discovery's own findings are the record. Then hand back under Step 5 for Codex to reframe or stop. Do not implement the eventual target, and do not treat the returned evidence as permission to proceed with it.

## The unit's mode

Core § 3 *The unit's mode* owns the three modes and what each requires. `## Lane and unit` records which one is open. This is what each changes for you:

- **Discovery** — inspect, do not implement. Step 4's discovery-unit rule already describes the work; the mode is what tells you in advance that it applies.
- **Implementation** — build it, and return the failing case, the implemented result, and the regression protection relevant to the change. Where no meaningful regression check exists, say so and say why, rather than inventing one that cannot fail (core § 6 rule 5).
- **Adoption** — the capability already exists. Return evidence about how it behaves in operation — reliability, operator burden, failure conditions, usefulness — and end with the lifecycle decision the brief asks for. Do not build the eventual target, and do not read operating evidence as permission to proceed with it.

**A mode that disagrees with the brief's own completion condition is a false premise** — hand back under Step 3. A unit recorded as Implementation whose completion condition asks only for evidence and a hand-back has not been classified; it has been mislabelled, and building from it is the error the check exists to prevent.

## De-escalating — when the work turns out smaller

Core § 2 *De-escalating* decides when this applies — inspection or implementation is where Claude notices it. When it does apply:

1. Say so, in plain words.
2. Reduce the state file to the closing record (core § 4), recording under `## Decisions that matter` that the task de-escalated and what was learned. Set `turn: operator`.
3. Finish the work directly, as Direct Work.
4. `git add` the state file and the changed files by explicit pathspec, commit once, stop.

## Step 5 — Write the result and the evidence

Into `## Latest result`, below the inspection record:

```
Result: <what actually happened — the latest material result, not a history>
Evidence: <the check, what it returns now, and what it returned before>
```

**The evidence must be able to fail** — core § 6 rule 5, including how to prove it.

The state file is current truth, not a diary (core § 4): replace the previous result rather than appending to it.

Then set `turn: codex`, set `## Next action` to what Codex assesses, `git add` by explicit pathspec — the state file and the files the unit changed — and commit.

## Correction rounds

Core § 3 *Correcting once* governs this round, including what may and may not enter it. The frozen findings are in `## Next action`.

1. Reproduce each frozen finding by inspection first, the same way Step 2 checks claims. A finding that does not reproduce is handed back as exactly that — not silently dropped.
2. Correct exactly the frozen findings. Anything newly noticed goes into the hand-back in plain words as a candidate deferral, and is not implemented.
3. A finding you can only partly resolve is handed back as exactly that: what was resolved, what was not, and why. Do not stretch the evidence to cover the gap (core § 6 rule 5).
4. Write the result and evidence into `## Latest result` per Step 5's shape. Set `turn: codex`. Set `## Next action` to the closure check on the frozen findings only. `git add` the state file and the corrected files by explicit pathspec, commit, stop.

## Closing the task

Core § 3's close token in `## Next action` is Codex's close verdict; core § 4 owns what a closed file holds. Claude writes and commits the record — the verdict is not re-judged here. The general turn guard and the identity check in Step 1 apply to this invocation like any other.

1. Reduce the state file to core § 4's closing record — its exact four headings, nothing else surviving — carrying what the verdict names: the outcome, the decisions that matter (including any deferral the verdict records, with its reason), the final commit or evidence pointer, and the accepted limitations (or `None.`). Set `turn: operator`.
2. `git add` the state file by explicit pathspec, commit, stop. A closing invocation changes no other file.

## Step 6 — Report in one line

Say what happened, in plain words: which task, whether a premise failed, what was committed. Then stop. Assessment is Codex's move, not yours.
