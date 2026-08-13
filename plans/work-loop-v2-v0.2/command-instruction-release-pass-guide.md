# Work Loop v2 Command Instruction Release Pass

## Purpose

This guide explains how to make the final clarity and behaviour pass on the Claude-side Work Loop v2 command before release.

The pass has two goals:

1. Make the command understandable to the operator.
2. Confirm that clearer wording has not changed the command's behaviour.

This is not a new design phase. It does not reopen the purpose, architecture, roles, or scope of Work Loop v2. It improves the released instruction only after those matters are settled.

The command under review is:

`ai-resources/.claude/commands/work-loop-v2.md`

## The standard for passing

The command is ready when all of the following are true:

- The operator can read it and explain what Claude will do.
- Claude can follow it without relying on the conversation that produced it.
- Every instruction causes an observable action, decision, output, or stop.
- The command uses the Work Loop's agreed words consistently.
- Shared policy remains in the executable core instead of being copied into the command.
- Representative behaviour checks still pass after the wording changes.
- The final command is no longer than necessary.

A command does not pass merely because it sounds polished or professional.

## Embedded executable blocks

A fenced block meant to be executed character-for-character may not contain tokens owned by the slash-command expander. Claude Code rewrites `$1`-style positional placeholders (and `$ARGUMENTS`) in a command body at invocation, so an embedded script that uses Bash positional parameters arrives corrupted whenever the command is invoked with a multi-word argument — while a short single-token argument passes untouched, which hides the defect from routine testing. Pass values into embedded shell functions through named variables assigned before each call instead.

Check during this pass: `grep -nE '\$[0-9]' <command file>` must match nothing, in code or comments, outside an intended placeholder. Apply the same check to any mirrored copy of the block (the Codex-side skill).

Defect record: `plans/work-loop-v2-v0.2/core-resolver-argument-substitution-defect-report-2026-08-10.md`.

## When to run this pass

Run the pass after the command's intended behaviour is stable and before the command is released or installed more widely.

For the current Work Loop v2 work, wait until:

- all approved changes that affect the Claude command have landed;
- the Context Engineering work, or any other open v0.2 work that changes the command, is complete;
- there is no unresolved design decision that could require another command rewrite;
- the existing behaviour checks pass before the clarity edit begins; and
- Claude can identify the exact version or commit being reviewed.

Do not run the pass while the command is still gaining features. Otherwise the review will become stale as soon as the next feature lands.

Do not wait until after release. The point is to find unclear or misleading instructions before they become operating behaviour.

## What this pass may change

The pass may:

- replace dense language with plain English;
- split long sentences;
- remove internal build history and release-stage labels;
- define an unavoidable technical term the first time it appears;
- replace an unclear cross-reference with a precise instruction;
- remove repetition that adds no behaviour;
- reorder instructions when their current order is hard to follow; and
- improve headings or examples when that makes the required behaviour clearer.

## What this pass must not change

The pass must not:

- add a new Work Loop capability;
- change who owns a decision or action;
- change admission, stopping, correction, evidence, or handoff rules;
- change the state-file contract;
- move policy out of the executable core;
- expand Context Engineering or another unfinished feature;
- edit the Codex-side skill merely to make both files look alike;
- add another review layer or another persistent artifact; or
- turn build history into permanent runtime instruction.

If clear wording requires a policy or architecture change, stop. Record that as separate work. Do not hide it inside an editorial revision.

## Roles

Three people or systems take part.

### Operator

The operator reads the command and explains it in their own words. The operator decides whether the result is understandable and whether it may be released.

### Reviewer

The reviewer inspects the command and reports unclear, unnecessary, conflicting, or behaviourally risky instructions. The reviewer does not edit the command during the review.

Codex should normally perform this role because it did not write the Claude-side implementation.

### Builder

The builder makes the agreed changes and runs the checks. Claude should normally perform this role because the file is a Claude command and Claude owns repository implementation and commits.

The reviewer finds. The builder fixes. The operator decides.

## Required inputs

Before starting, give the reviewer these files:

1. The release candidate: `.claude/commands/work-loop-v2.md`.
2. The executable core: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.
3. The writing standard: `plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md`.
4. The behaviour harness: `logs/scripts/work-loop-v2-slice-1.test.sh`.
5. Any existing evidence record needed for a case affected by the edit.
6. This guide: `plans/work-loop-v2-v0.2/command-instruction-release-pass-guide.md`.

The reviewer may inspect another source only when it is needed to resolve a specific ambiguity. This is not an invitation to reopen the whole project history.

## The workflow

### Step 1 — Freeze the candidate

Claude identifies the exact command version being reviewed. Use a Git commit when possible.

Claude also records the result of the existing behaviour checks before making any wording change. This is the baseline.

Complete this step when:

- the candidate can be identified later;
- the command has no unfinished edit in progress; and
- the baseline behaviour result is recorded.

Stop if the command is still changing for another approved work item.

### Step 2 — Run the operator's first read

The operator reads the command without receiving an explanation of it first.

After reading, the operator explains these points in their own words:

1. When should this command run, and when should it not run?
2. What input does the command accept?
3. What does Claude read and check before changing anything?
4. What is the normal path when the brief is correct?
5. What situations make Claude stop instead of implementing?
6. What does Claude write and commit before handing back?
7. Who acts after Claude finishes?

Record where the operator is uncertain or where their explanation differs from the instruction's intended meaning.

Do not fix a failed read by explaining the command in chat. The command itself must become clearer.

Complete this step when every point is either understood or recorded as a clarity finding.

### Step 3 — Run the independent instruction review

The reviewer reads the command from start to finish. Each paragraph receives one result:

- **Keep** — clear, necessary, and behaviourally useful.
- **Rewrite** — necessary, but unclear, dense, or open to more than one interpretation.
- **Remove or move** — build history, repeated policy, unused explanation, or wording that produces no behaviour.

The reviewer checks the following questions.

#### Trigger and input

- Does the opening say plainly what the command does?
- Does it say when the command should not run?
- Is the argument explained without assuming technical knowledge?
- Is the no-argument case clear?

#### Order of work

- Can the operator follow the sequence from reading the state file to handing back the result?
- Does each step have one clear purpose?
- Are cross-references precise about which actions to repeat?
- Could following one section literally conflict with another section?

#### Stops and handoffs

- Is every stopping condition visible?
- Does each stop say what Claude records, what Claude leaves unchanged, and who acts next?
- Are false premises, invalid state files, scope problems, unavailable evidence, and operator-owned decisions kept distinct?

#### Language

- Does the command use common words where they are sufficient?
- Does each sentence carry one main idea?
- Are unavoidable technical terms explained?
- Does it avoid internal labels such as slice numbers, behaviour numbers, session identifiers, or test history?
- Does it use the agreed Work Loop vocabulary rather than introducing synonyms?

#### Authority and duplication

- Does the executable core remain the owner of shared rules?
- Does the command keep only Claude-specific actions and output shapes?
- Does any copied policy risk drifting away from the core?
- Does any explanation describe history or rationale that belongs outside the runtime command?

#### Behavioural precision

- Can every instruction succeed or fail in an observable way?
- Does each required evidence check have a possible failing result?
- Is every output shape clear enough for another session to consume?
- Could clearer wording accidentally widen scope or grant new authority?

The review should report material findings only. Personal wording preferences are not findings.

Complete this step when every command section has been considered and every proposed change names the behavioural or comprehension problem it solves.

### Step 4 — Lock the revision scope

Turn the accepted findings into one bounded revision brief.

The brief must state:

- the command version being changed;
- the exact findings to correct;
- the behaviour that must remain unchanged;
- the files that may change;
- the files that must not change;
- the behaviour checks to rerun; and
- the conditions that require stopping.

The default file scope is one file:

`.claude/commands/work-loop-v2.md`

Do not add attractive improvements after the revision begins. Record them separately and leave them out of this pass.

Complete this step when the builder can make the changes without deciding what else should be improved.

### Step 5 — Make the minimum revision

Claude changes only the accepted findings.

Useful editing rules:

- Prefer a short direct sentence over a formal one.
- Use concrete verbs such as “read,” “check,” “write,” “commit,” “report,” and “stop.”
- Split instructions that combine several conditions or actions.
- Name files and fields exactly when exactness matters.
- Explain technical syntax in one short sentence.
- Remove build history from the runtime instruction.
- Keep a prohibition when evidence shows that it prevents a real failure.
- Do not shorten wording if the shorter version becomes less precise.

After editing, Claude reads the command in order as if entering with no conversation history. Claude corrects only defects within the locked scope.

Complete this step when all accepted findings are addressed and no unrelated change has entered the file.

### Step 6 — Repeat the operator read

The operator reads the revised command without using the review notes as an explanation.

The operator answers the same seven questions from Step 2.

The revision passes this step when:

- the operator can explain the whole command accurately;
- no essential behaviour depends on an explanation outside the command; and
- the revised passages are easier to understand than the baseline.

If the operator still cannot understand a material instruction, revise that instruction. Do not accept a separate explanation as the solution.

### Step 7 — Verify behaviour

Clearer wording is not enough. Claude must show that the command still behaves correctly.

Rerun the existing automated harness. Then run a fresh representative case for every command area whose instruction changed.

Use the table below as the coverage map. Confirm that evidence exists for every case. Existing evidence may be reused only when the revision did not touch the instructions that govern that case.

| Case | Expected result |
|---|---|
| Small reversible request | Direct Work; no state file is opened |
| Valid state file and true premises | The scoped unit is implemented and evidence is handed to Codex |
| False load-bearing premise | No implementation; the finding is recorded and handed to Codex |
| Missing or malformed state file | Nothing is changed; the problem is reported |
| State file for a different task | Nothing is changed; the mismatch is reported |
| Wrong `turn:` value | Nothing is changed; Claude says whose move it is |
| Work would exceed scope | No out-of-scope implementation; the problem is handed back |
| Work turns out to be small | The task de-escalates according to the core |
| Bounded correction | Only the frozen findings are corrected |
| New issue found during correction | It is reported as a possible deferral, not implemented |

For every case, record:

- what was run;
- what happened;
- whether that matches the expected result; and
- any limitation or part that was not assessed.

A search showing that the right words appear in the command is not behavioural evidence.

Complete this step when all materially affected cases have passed, failed, been blocked, or been honestly marked unassessed.

### Step 8 — Run the closure review

The independent reviewer checks only:

1. Were the accepted findings resolved?
2. Did the revision change or break anything outside those findings?
3. Does the evidence support the claimed result?
4. Is the command the same length or shorter, unless extra words were necessary for clarity?

This is not another broad review. Newly noticed improvements are recorded for later. They do not open another correction round.

Complete this step when the reviewer recommends release, one bounded correction, or a stop.

### Step 9 — Make the release decision

The operator chooses one outcome:

- **Release** — the command is understandable and the behaviour remains supported.
- **Revise** — one named problem still needs a bounded correction.
- **Hold** — release waits for another feature, decision, or missing piece of evidence.
- **Revert the wording change** — the revision weakened the command, so keep the earlier version.

Record the chosen outcome, the command version, the behaviour result, and any accepted limitation.

Complete this step when there is one explicit decision and no ambiguous candidate remains.

## Ready-to-use prompts

The prompts below are starting instructions. Replace bracketed text with the real paths or commit.

### Prompt for the independent review

```text
Review the Work Loop v2 Claude command as a release-candidate instruction.

Read:
- .claude/commands/work-loop-v2.md at [candidate commit]
- plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
- plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md
- logs/scripts/work-loop-v2-slice-1.test.sh
- plans/work-loop-v2-v0.2/command-instruction-release-pass-guide.md

Do not edit any file.

For each section of the command, decide: Keep, Rewrite, or Remove or move.
Report only material problems involving operator comprehension, ambiguous behaviour,
unexplained technical language, internal build history, inconsistent vocabulary,
imprecise stops or handoffs, or policy copied from the executable core.

For every finding, cite the exact passage, explain the practical problem in plain
English, and state what behaviour must remain unchanged. Do not propose new Work Loop
features or reopen settled architecture.
```

### Prompt for the bounded revision

```text
Revise the Work Loop v2 Claude command against the frozen findings below.

Candidate: [path and commit]
Findings: [numbered accepted findings]

Change only .claude/commands/work-loop-v2.md. Preserve the command's behaviour,
authority, scope, state-file contract, stop conditions, output contracts, and handoffs.
Use plain English. Remove internal build language. Define unavoidable technical terms.
Do not change the executable core, the Codex-side skill, Context Engineering behaviour,
or the test harness unless a named finding explicitly requires it.

Stop and report instead of editing if a finding cannot be fixed without changing shared
policy or architecture. After editing, run the required checks and report what was run,
what happened, and what remains unassessed.
```

### Prompt for the closure review

```text
Assess the revised Work Loop v2 Claude command against the frozen findings and evidence.

Check only whether each finding was resolved, whether the revision caused a regression,
whether the evidence supports the claims, and whether the command became clearer without
unnecessary growth. Do not start a new broad review.

Return one recommendation: Release, one bounded revision, Hold, or revert the wording
change. Record newly noticed improvements as later suggestions only.
```

## Operator worksheet

Use this short worksheet during Steps 2 and 6.

```text
Candidate version:

1. This command should run when:
2. This command should not run when:
3. The input is:
4. Before changing anything, Claude:
5. When everything is valid, Claude:
6. Claude stops when:
7. Before handing back, Claude writes or commits:
8. The next actor is:

Words or passages I did not understand:
Instructions I could interpret in more than one way:
```

## Final checklist

Before choosing **Release**, confirm:

- [ ] The intended Work Loop behaviour was stable before this pass began.
- [ ] The exact candidate version was recorded.
- [ ] The existing checks passed before editing.
- [ ] The operator completed both reads without being coached through the command.
- [ ] Every accepted change solves a named comprehension or behavioural problem.
- [ ] No new capability, role, decision, state, or review layer was added.
- [ ] Shared policy still has one owner.
- [ ] Internal build history is absent from the runtime command.
- [ ] Necessary technical language is explained.
- [ ] Stops and handoffs are distinct and unambiguous.
- [ ] The automated harness passes after the revision.
- [ ] Materially affected behaviour cases were observed, not inferred from wording.
- [ ] Failed, blocked, and unassessed checks are visible.
- [ ] The independent closure review is complete.
- [ ] The operator chose one explicit release outcome.

## Definition of complete

This pass is complete when the operator can accurately explain the command, independent evidence shows that its material behaviour still works, and one release decision has been recorded.

If any of those three conditions is missing, the pass is not complete.
