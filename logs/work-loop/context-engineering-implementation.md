---
task: context-engineering-implementation
turn: operator
---

## Objective and approved scope
Implement and prove the governing Context Engineering specification according to the approved implementation
plan, one evidence-gated session at a time. Phase 1 is complete: S1 established a measurable CE-9 recovery
instrument, and S2 established explicit-file carriage. No Phase 2 slice is open yet.

Governing specification: `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, approved against
`148689d42ee7817239219417a1b884b961660f86`. Plan of record:
`plans/work-loop-v2-v0.2/context-engineering/context-engineering-implementation-plan-v0.1.md`, approved
against `cc635d4`.

## Current lane and unit
Standard. S2 complete — the isolated inline-carriage probe trial is accepted after one bounded correction.
S3, Slice A, awaits operator authorisation.

Named reason for the loop: the implementation spans multiple sessions, its scope must remain bounded across
S1–S12, and each result needs assessment by someone other than its builder before progression.

## Latest material result
S2 passed its correction closure check.

- Finding 1 resolved: the counted rerun stayed inside two disposable roots; no Harbourview state entered the
  live repository; both roots and the rejected run-1 artifact were removed only after evidence capture.
- Finding 2 resolved: the control and candidate state files survived separately for inspection. Control had
  no `Carriage check`; candidate had one listing five verified paths.
- Result: an inline instruction in one explicitly named candidate file reaches a fresh Codex thread and
  changes what it produces. This licenses Phase 2's explicit-candidate trials only. Ordinary installed-skill
  discovery remains unproved until S8b.
- Evidence record:
  `plans/work-loop-v2-v0.2/context-engineering/trials/carriage-trial-record.md`.
- The probe was stripped. `trials/candidate/SKILL.md` is the candidate folder's only file and is
  byte-identical to the 116-line live Codex skill, establishing behavioural emptiness by construction.
- The rejected first run, answer-key scrub, control-root candidate presence, model-chosen task-id variation,
  and audited disposal are recorded in the trial record. None weakens the within-file carriage contrast.

Carry to task closure as deferrals: candidate-marker wording in plan §7; the plan header's stale O-1
status; F-10's stale specification line count; and S1's range-based scope check not being duplicated into
its scenario file.

## Next action
Operator: authorise S3, Slice A, to begin the isolated proof, or stop after the completed Phase 1. If
authorised, return the decision to Codex so it can write the S3 red–green trial brief; do not ask Claude to
start S3 directly from the plan.
