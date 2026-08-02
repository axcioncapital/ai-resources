---
task: context-engineering-implementation
turn: operator
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the approved implementation
plan, one evidence-gated session at a time. Progression is bounded by the plan's S1–S12 exit and stop
conditions. S1 is complete. This unit authorises S2 only: determine whether one explicitly named inline
candidate delivers a non-CE probe instruction to a fresh Codex thread.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, approved
against `cc635d4`.

## Current lane and unit
Standard. Unit 2 — S2, the isolated inline-carriage probe trial. One bounded correction is open, frozen to
findings 1–2. **Correction setup is complete**; the two isolated re-runs have not happened. Turn is the
operator's.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Latest material result

Reproduced (2026-08-02) — both frozen findings, by inspection, before any correction:
- Finding (1) the trial escaped into the live Work Loop directory: REPRODUCES — `logs/work-loop/harbourview-arrival-time-correction.md`
  was present with `task: harbourview-arrival-time-correction` and `turn: claude`;
  `git ls-files --error-unmatch` reported it untracked. Enumerating `^turn:` across `logs/work-loop/*.md`
  returned it as one of three `turn: claude` files, so the live command could resolve a fictional task.
- Finding (2) the negative control is not independently inspectable: REPRODUCES — `git log` for that path
  is empty, so no version was ever committed; `stat` shows birth 20:05:07 and modification 20:07:33, the
  two runs writing the same path; a repository-wide `find` for `*harbourview*` returns one artifact. The
  control's state file is therefore unrecoverable from Git.

Result: **Correction setup is complete and both findings are addressed structurally, but neither is yet
*resolved* — resolution requires the two isolated re-runs, which have not been performed.** The escaped
artifact is preserved outside the repository, the live directory is clear, and two byte-identical isolated
roots exist at one committed baseline with the probe's answer key removed from both.

Evidence:
- **The escaped artifact is preserved, not deleted, and the live path is clear.** Re-verified before moving:
  `task:` matched and `git ls-files --error-unmatch` confirmed untracked; the destination was confirmed
  non-existent first, so nothing was overwritten. Moved to
  `{scratchpad}/s2-correction/evidence/harbourview-arrival-time-correction.escaped-run1.20260802T202838.md`,
  4851 bytes — byte count unchanged — retaining its `Carriage check` section as run-1 diagnostic evidence.
  Re-enumerating `^turn:` across `logs/work-loop/*.md` now returns only this task and the pre-existing
  acceptance fixture `fixture-slice2-foreign.md`; the fictional task is gone from the live directory.
- **Two isolated roots exist at one committed baseline.** `git worktree add --detach` created a control
  root and a candidate root, both at `edd85e1d6ccd1e955a3a125ca2aca52a0fa9c1cc`, confirmed by
  `git -C <root> rev-parse HEAD` on each. Both sit outside the live repository. The candidate is committed
  and clean at that baseline (`git diff --stat HEAD` on it is empty; it last changed in `37a29c1`).
- **The two roots are byte-identical.** `diff -rq control candidate -x .git` returns no output, so they
  differ only in which prompt is supplied — the symmetry finding 2 requires.
- **The answer key was removed from both roots, identically.** *This was necessary and is a construction
  decision, stated rather than taken silently.* A worktree carries the whole committed tree, and
  `git grep -l -F 'Carriage check'` against the baseline returned three files: the candidate itself, **this
  task's own state file**, and **plan §7 S2**, the latter two stating the probe and its expected outcome. A
  re-run against an unscrubbed root would have handed both threads the answer, making finding 2's re-run
  invalid on arrival. Both files were therefore deleted from both roots. Post-scrub,
  `grep -rl -F 'Carriage check'` in each root returns exactly one path — `trials/candidate/SKILL.md`, the
  probe itself. No trial-only output override was added to the candidate and the isolation rule was not
  relaxed; the candidate is untouched.
- **Required material survives in both roots**, verified per-path with `[ -f ]`: the candidate, the
  executable core, and all three ce-9 fixture sources.

**Residual weakness, recorded rather than smoothed over.** `trials/candidate/SKILL.md` remains present in the
*control* root, because the frozen finding requires the two roots to differ only in whether the candidate
instruction is supplied. The control is therefore blind **by instruction**, not **by construction** — a
control thread that browsed the tree could find the probe. Run 1's control had the same exposure and came
back clean. Removing it from the control root alone would break the symmetry the finding mandates, so it is
reported for Codex rather than fixed here.

**The stop condition in finding 1 may be live, and the operator must resolve it before running.** Finding 1
says to stop if fresh Codex tasks cannot be constrained to the assigned roots. Evidence in this repository
points both ways and cannot settle it: `git worktree list` shows Codex maintains its own worktrees under
`~/.codex/worktrees/`, which would place a task outside the assigned root — yet run 1 wrote directly into
the live checkout, so Codex is not always confined to one. This is an environment fact Claude cannot
determine by inspection. The operator verifies it as step 1 below; if a task cannot be held to its root, the
runs do not proceed.

Carried deferrals, unchanged and explicitly not implemented in this round: the candidate-marker wording at
plan §7 `:551`; the implementation plan's stale header; F-10's stale specification line count; and S1's
corrected range-based scope-check command not being duplicated into its scenario file.
## Brief
Why: S2 must separate carriage from Context Engineering behaviour. It asks only whether an instruction
placed inline in one explicitly named candidate file reaches a fresh Codex thread and changes the brief.
If the probe works, the probe is later removed and the same single file enters Phase 2 with no CE behaviour.

Check against the live repository before acting:

1. Validate this state file's identity and turn. Reconfirm S1 is accepted and its scenario plus all four
   fixture files exist.
2. Recheck the exact `trials/candidate/` surface. It was absent when Codex opened S2. If it now exists,
   inspect it and stop if it conflicts with this unit; do not overwrite or merge an unknown candidate.
3. Read the live `.agents/skills/work-loop-v2/SKILL.md` as the object being revised outside the live path.
   Confirm it remains 116 lines and contains no Context Engineering behaviour. Record the pre-S2 Git
   baseline before editing so later protected-file evidence spans committed changes rather than merely the
   working tree.
4. Re-read plan §4.4 and S2 in full. Treat the one-file invariant, inline-only construction, behavioural
   emptiness, and prohibition on live installation as premises. If any is incompatible with repository
   reality, stop and hand back rather than inventing another carriage.

Stage 1 — Claude authors the instrument, but does not run or judge the trial:

- Create exactly one file in `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/`:
  `SKILL.md`. It is the working revision of the live Codex skill, isolated outside `.agents/skills/`.
- Put this probe instruction inline in that file, with no pointer or referenced instruction file:
  *Under this carriage, end every brief with a section named `Carriage check`, listing — in the order you
  opened them — the repository files you opened while preparing it.*
- The candidate must mention Context Engineering, `CE-1`…`CE-17`, and the CE specification nowhere, and
  must carry no paraphrased CE behaviour. It may contain the existing Work Loop instructions and the probe,
  nothing more.
- Do not install the candidate, edit the live skill, create an alternative or indirection file, modify the
  S1 scenario or fixtures, create `trials/carriage-trial-record.md` before evidence exists, or strip the
  probe before the two runs.

Prepare the operator handoff inside this state file. It must give two copy-paste prompts for two **fresh**
Codex tasks:

1. **Negative control:** the Harbourview request plus the three source fixture paths, with no candidate
   path, no scenario file, no mention of the probe, and no prior-thread summary.
2. **Candidate run:** identical text and source paths, plus only the instruction to read and follow
   `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md` as the trial Work Loop
   instruction instead of the installed live skill. It must not reveal the expected `Carriage check`.

Tell the operator to preserve both Codex outputs verbatim and report whether either task opened files not
listed in its output. Do not ask the operator to interpret success; Claude is S2's observer after the runs.

Evidence required for this Stage 1 handoff:

- `trials/candidate/` contains exactly one file, `SKILL.md`; the inline probe is present; prohibited CE
  identifiers and terms are absent; and a semantic read confirms no paraphrased CE behaviour entered.
- A range-based check from the recorded pre-S2 baseline shows the live Codex skill, executable core,
  Claude command, specification, implementation plan, and S1 artifacts are unchanged.
- The two prepared prompts use the same request and three source paths, and differ only by the candidate
  instruction needed for the candidate run.

After authoring and checking Stage 1, write the material result and both exact prompts here, set
`turn: operator`, commit the candidate and this state file, and stop. Do not create the trial record or
remove the probe yet.

Stop and set `turn: codex` instead if inline delivery cannot be tested through an explicitly named file,
if Codex cannot reach the repository as assumed, if the candidate would require a second file or live
installation, or if a premise is false. Do not try alternative packaging; that would exceed S2.

## Next action

Operator: the correction's re-runs are yours. Do them in this order — **step 1 is a gate, not a formality.**

**Step 1 — confirm a fresh Codex task can be held to a given root.** Finding 1's stop condition turns on
this. Open a fresh Codex task, point it at the control root below, and ask it to report its working
directory and to list the files directly inside `plans/work-loop-v2-v0.2/context-engineering/trials/`.
If it answers from the control root, proceed. **If it works anywhere else — its own worktree, the live
checkout — stop and tell Claude.** Do not adapt the prompts to make it fit; the frozen finding forbids
relaxing the isolation rule, and that call is Codex's, not yours or Claude's.

The two roots:

```
control root:   /private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/3fb9ea75-bce7-47fa-adc0-cb540c3f5aae/scratchpad/s2-correction/control
candidate root: /private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/3fb9ea75-bce7-47fa-adc0-cb540c3f5aae/scratchpad/s2-correction/candidate
```

**Step 2 — run the two prompts in two fresh Codex tasks**, one per root, neither carrying any prior-thread
summary. The two prompts are identical except for the root path and, in the second, the candidate
instruction. Neither names the expected output.

**Prompt 1 — negative control.** Paste verbatim into a fresh Codex task:

```
Work exclusively in this repository root, and write nothing outside it:
/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/3fb9ea75-bce7-47fa-adc0-cb540c3f5aae/scratchpad/s2-correction/control

Can we pick Harbourview back up? I've got an hour this afternoon.
What's the next unit — go ahead and brief it.

Sources for this task:
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/project-plan.md
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/task-state.md
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-source-note.md
```

**Prompt 2 — candidate run.** Paste verbatim into a second fresh Codex task:

```
Work exclusively in this repository root, and write nothing outside it:
/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources/3fb9ea75-bce7-47fa-adc0-cb540c3f5aae/scratchpad/s2-correction/candidate

Can we pick Harbourview back up? I've got an hour this afternoon.
What's the next unit — go ahead and brief it.

Sources for this task:
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/project-plan.md
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/task-state.md
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-source-note.md

For this task, read and follow
plans/work-loop-v2-v0.2/context-engineering/trials/candidate/SKILL.md as the Work Loop
instruction, instead of the installed work-loop-v2 skill.
```

**Step 3 — leave every produced state file exactly where it is.** Do not move, tidy, rename or open-and-save
them. Claude inspects both files in place; that is what makes the control independently inspectable this
time and is the whole point of finding 2. If the same filename appears in *both* roots that is correct and
expected — they are separate directories, so neither can overwrite the other.

**What to bring back:** both Codex responses verbatim, unsummarised, and for each run whether the task
opened any file it did not mention. Do not judge whether either run succeeded; the expected output is
deliberately not stated here so your report cannot be shaped by it.

**One check worth running yourself afterwards**, from the live repository root — it must print nothing:

```
ls logs/work-loop/harbourview-arrival-time-correction.md 2>/dev/null
```

Anything printed means a run escaped into the live checkout again, which invalidates it under finding 1.

Then: return to Claude with both outputs and run `/work-loop-v2`. Claude observes the two preserved state
files, and only if both findings are resolved does it proceed to the closure work Codex staged — the trial
record, stripping the probe, the protected-file confirmations, and removing the disposable roots.
