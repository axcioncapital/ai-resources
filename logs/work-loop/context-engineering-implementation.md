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
Standard. Unit 2 — S2, the isolated inline-carriage probe trial. Stage 1 is **complete**: Claude has
authored and isolated the candidate. Stage 2 is open and belongs to the operator — two fresh Codex runs.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Latest material result

Inspected (2026-08-02):
- Claim (1) state-file identity and turn: HOLDS — read `logs/work-loop/context-engineering-implementation.md`
  frontmatter; `task:` is `context-engineering-implementation`, matching the resolved id; `turn:` was
  `claude`. `## Next action` did not open with core § 3's hand-off token, so this was a new unit, not the
  correction round.
- Claim (1) S1 accepted, scenario plus four fixtures exist: HOLDS — `trials/ce-9-recovery-scenario.md`
  present (11457 bytes); `find trials/fixtures/ce-9/ -type f` returns exactly four —
  `operator-request.md`, `operator-source-note.md`, `project-plan.md`, `task-state.md`. Acceptance is
  recorded in commit `2405675` ("S1 closed — Codex closure check passed").
- Claim (2) `trials/candidate/` absent at S2 open: HOLDS — `ls` on the exact path
  `plans/work-loop-v2-v0.2/context-engineering/trials/candidate/` returned
  `No such file or directory`, exit 1. No unknown candidate existed to conflict with this unit.
- Claim (3) live Codex skill is 116 lines and carries no CE behaviour: HOLDS — `wc -l`
  on `.agents/skills/work-loop-v2/SKILL.md` returns `116`; searched that file for
  `(Context Engineering|context-engineering|\bCE-[0-9]+\b)` case-sensitively, no match (exit 1). Pre-S2
  Git baseline recorded before any edit: `2dd9a99534eaaf01879b767ac237ffe70d71e6a6`.
- Claim (4) plan §4.4 and S2 premises compatible with repository reality: HOLDS — re-read plan §4.4
  (`:186-229`) and S2 (`:515-597`) in full. The one-file invariant, inline-only construction, behavioural
  emptiness and the prohibition on live installation are all satisfiable as written; none conflicts with
  the repository as inspected.

**A grep-method correction made during inspection, recorded because it invalidated a first attempt.**
`grep` in this shell is a function, not the binary. A first case-insensitive absence check with
`-i` on `CE-[0-9]+` returned a false positive — it matched the substring `ce-1` inside
`work-loop-v2-slice-1.test.sh` at `SKILL.md:77`. The absence checks above are therefore case-sensitive,
word-bounded, and run through `command grep`. Each is paired with a positive control proving the same
pattern form can match a string known present in the same file; without that pairing an absence result is
indistinguishable from a grep that could not read the file.

Result: Stage 1 is complete. `trials/candidate/SKILL.md` exists as the single isolated candidate — a
working revision of the live Codex skill carrying the inline carriage probe and nothing else. It is not
installed, the live skill is untouched, and the two fresh-Codex prompts are prepared below. No trial has
been run and no result is claimed about carriage; that is Stage 2's, and Claude is its observer afterwards.

Evidence:
- **Exactly one file in the candidate folder.** `find trials/candidate/ -type f` returns one path,
  `SKILL.md`; `count=1`. A second file there fails the session whatever it contains (plan §7, S2).
- **The inline probe is present, verbatim.** `command grep -nF 'end every brief with a section named
  `Carriage check`'` matches at `SKILL.md:61`, exit 0. It sits inline in the candidate's own body under
  `## Under this carriage` — no pointer, no referenced instruction file.
- **No CE identifier or term is present.** Searched `trials/candidate/SKILL.md` for
  `(Context Engineering|context-engineering|\bCE-[0-9]+\b|context.engineering.spec)` — no match, exit 1.
  *Fail-capable:* the same pattern form with `\bWork Loop\b` substituted matches at `:3`, exit 0, proving
  the search reads the file rather than silently returning empty.
- **No paraphrased CE behaviour entered — by construction and by semantic read.** The candidate is the
  live 116-line skill reproduced unchanged plus one added 3-line section holding the probe. The added
  section is quoted in full in this file; it names no CE behaviour family and imposes no context-engineering
  discipline. This is the necessary-not-sufficient check plan §7 describes: emptiness is *demonstrated* one
  session later by S3's red run failing, not proved here.
- **Protected surfaces unchanged across committed and working-tree state.**
  `git diff --stat 2dd9a99 -- <six pathspecs>` returns empty for the live Codex skill, the executable core,
  the Claude command, the specification, the implementation plan, and the S1 scenario plus its fixtures.
  *Fail-capable:* the identical command form against `logs/friction-log.md` prints
  `1 file changed, 111 insertions(+)`, proving the check detects change rather than passing vacuously.
  Pathspecs are individually quoted — an unquoted variable silently emptied a pathspec in this task's
  previous correction round.
- **The two prompts differ only by the candidate instruction.** Both carry the same request text and the
  same three source paths; the candidate prompt adds one line and nothing else. Neither reveals
  `Carriage check`.

**Construction decision taken during Stage 1, stated rather than resolved silently.** Plan §7 `:551`
describes the candidate as "a fixture, built the way S1 builds its scenario", and plan §4.4's fixture rule
requires every fixture to open with `FIXTURE — … Carries no authority.` The candidate was built **without**
that marker, for three reasons: (a) a line telling the trial thread the file carries no authority confounds
the probe, which measures whether the thread *follows* the file; (b) at S8b the candidate's content lands in
the live skill, so a marker would be a second thing needing stripping and only the probe is scheduled for
removal; (c) §4.4's fixture box is scoped to seeded project artifacts — plans and current-state files that
could be mistaken for authority — whereas the candidate is a working revision of a real skill held outside
the live path. If Codex judges the marker required, this is a one-line change and the trial has not yet run.

Deferrals carried to task closure — one new, three existing:
- **New:** plan §7 `:551` calls the candidate "a fixture", which reads as invoking §4.4's marker rule and
  conflicts with the behavioural emptiness §4.4 itself requires. A wording correction to the plan, not
  actioned here — it is outside this unit's scope.
- The implementation plan header still describes O-1 as outstanding.
- F-10's specification line count is stale.
- S1's corrected range-based scope-check command is not duplicated into its scenario file.

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

Operator: run the two prompts below in **two fresh Codex tasks**, in either order. Each must be a new task
with no prior-thread summary loaded — a thread carrying earlier context is not a valid run and is discarded.
Run neither in this conversation.

**Prompt 1 — negative control.** Paste verbatim into a fresh Codex task:

```
Can we pick Harbourview back up? I've got an hour this afternoon.
What's the next unit — go ahead and brief it.

Sources for this task:
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/project-plan.md
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/task-state.md
- plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/operator-source-note.md
```

**Prompt 2 — candidate run.** Paste verbatim into a second fresh Codex task:

```
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

What to bring back, without interpreting it:

1. **Both Codex outputs, verbatim.** Do not summarise, trim or reformat them — the probe check is applied
   to the exact text, and a paraphrase destroys the measurement.
2. **For each run, whether the task opened any repository file it did not list in its output.** If the Codex
   interface shows the files a task read, report that list as shown.

Do not judge whether either run succeeded. Claude is S2's observer and applies the probe check after the
runs; the expected outcome is deliberately not stated here so that reporting it cannot be shaped by it.

Then: return to Claude with both outputs and run `/work-loop-v2`.
