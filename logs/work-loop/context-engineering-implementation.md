---
task: context-engineering-implementation
turn: codex
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
Standard. Unit 2 — S2, the isolated inline-carriage probe trial. **Both stages are complete.** Claude
authored and isolated the candidate; the operator ran the two fresh Codex threads; Claude has applied the
probe check as S2's observer. The unit is with Codex for assessment.

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

Result: **Both S2 runs are complete and the inline carriage delivered.** The negative control produced no
`Carriage check`; the candidate run produced one naming six repository files in the order it opened them,
led by the candidate itself. The probe was acted on rather than echoed, so an instruction written inline in
one explicitly named file reaches a fresh Codex thread and changes what it produces. Scoped as plan §7, S2
requires: this is evidence about **carriage only**, and it says nothing about installed-path discovery,
which is S8b's pre/post pair.

**Two S2 findings that qualify the result. Neither is a Codex error and both are the observer's to raise.**

1. **The trial wrote into the live Work Loop directory, and the construction made that unavoidable.** Both
   runs created `logs/work-loop/harbourview-arrival-time-correction.md`, carrying `turn: claude` — a
   fictional task now resolvable by the live command. Plan §4.4 rule 2 forbids exactly this and names
   `logs/work-loop/` explicitly; the `task-state.md` fixture states it sits outside that directory on
   purpose. The cause is structural: the candidate is a faithful copy of the live skill, whose line 33
   fixes the state-file folder as `logs/work-loop/` with "no fallback path". **Any** trial run driven by
   this candidate must therefore write there. Neither the plan nor this brief anticipated it. It is a
   defect in S2's construction, and Slices A–C at S3–S7 inherit it unchanged unless it is fixed.
2. **The negative control's state file is unrecoverable, so half its evidence rests on operator
   attestation.** Both runs wrote to the same path: created 20:05:07, modified 20:07:33, never committed.
   The candidate run overwrote the control's file, and Git holds no prior version. Recorded as an accepted
   limitation below rather than presented as repository-verified.

Evidence:
- **Negative control — `Carriage check` absent.** The operator returned the control's final response
  verbatim; it contains no `Carriage check` section, and the operator attests the control's state file
  ended directly at `## Next action`. *Limitation, stated rather than smoothed over:* the control's state
  file itself is **not independently re-inspectable** — see finding 2. The response half is verbatim
  primary material; the state-file half is attestation.
- **Candidate run — `Carriage check` present, and behaviour-shaped.** Present at
  `logs/work-loop/harbourview-arrival-time-correction.md:70-79`, listing six files in open order.
  **All six verified to exist** by a per-path `[ -f ]` test. *Fail-capable:* the identical test against
  `fixtures/ce-9/no-such-file.md` reports `MISSING`, proving it can report absence rather than passing
  vacuously. The three scenario sources named are exactly S1's seeded set.
- **The two runs differed only by the candidate instruction.** Verified mechanically before the runs:
  `diff` of the two extracted prompts returns `7a8,11` — a pure four-line addition, no deletion and no
  modification. Neither prompt contained the string `Carriage check` (0 hits each), so the expected output
  was never revealed to either thread.
- **Nothing was installed.** `git diff --stat 2dd9a99 -- .agents/skills/work-loop-v2/SKILL.md` empty across
  the whole trial, alongside the executable core, the Claude command, the specification, the implementation
  plan and the S1 artifacts. *Fail-capable:* the same form against `logs/friction-log.md` prints
  `1 file changed`.
- **The candidate folder still holds exactly one file.** `find trials/candidate/ -type f` returns one path,
  `SKILL.md`. The probe is still present and has **not** been stripped — the brief forbade stripping before
  the runs, and stripping after them was not briefed.

Superseded Stage 1 evidence (candidate authored, one file, probe inline, no CE identifier, protected
surfaces unchanged) is unchanged and is carried by commit `37a29c1`.

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

Codex: assess S2 against plan §7's exit condition — the negative control was clean, the candidate delivered
the probe. Four things need your decision, and none is Claude's to take:

1. **Does S2 exit on this evidence?** The carriage question is answered positively. The qualification is
   finding 2: the control's state file is unrecoverable and its absence of `Carriage check` rests partly on
   operator attestation rather than on a re-inspectable artifact. Accept as a written limitation, or require
   a re-run of the control with the two runs writing to distinct paths.
2. **Finding 1 — the live-directory contamination — needs a ruling before S3.** The candidate cannot direct
   state files anywhere but `logs/work-loop/` without diverging from the live skill it is a revision of, and
   diverging is itself a change to the object under test. Slices A–C inherit the problem unchanged. This is
   a construction decision about the trial, not a CE behaviour question.
3. **The stray artifact `logs/work-loop/harbourview-arrival-time-correction.md` is untracked and still in
   place.** Claude's recommendation is to move it under `trials/` — it is the candidate run's primary
   evidence and must not be deleted, but it should not sit in the live directory carrying `turn: claude`.
   Not moved: the operator was asked and has not yet ruled, and Claude does not delete or relocate outside
   its session scope on its own.
4. **The probe is still in the candidate, and the trial record does not exist.** Both were correctly out of
   Stage 1's scope. Brief whichever comes next rather than assuming Claude should have done either.

Not done, and deliberately so: Claude did not implement the Harbourview unit. Its premise 3 — that a live
Harbourview implementation and authoritative booking data exist — is false; `find` returns no Harbourview
artifact in this repository other than the brief itself. Executing it would have been trial material
escaping into real work, which is what plan §4.4's placement rule exists to prevent. Noted separately
because the brief itself is sound: it recovered SD-3, ranked the defect above the email template, and
carried the 2026-06-14 boundary. That quality is S5's measurement, not S2's, and is recorded here only so
the observation is not lost.

## Accepted limitations
- The negative control's state file was overwritten by the candidate run before either was committed, and
  Git holds no prior version. Its `Carriage check` absence is established by the operator's verbatim
  response plus attestation, not by a re-inspectable repository artifact. The fix for later slices is to
  give each run a distinct output path.
