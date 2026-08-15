---
task: work-loop-v2-durable-state-system
status: active
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 4 — Tracer bullet 2: migrate every tracked Work Loop task record to an explicit, validator-classified lifecycle without switching runtime consumers.

Named reason for the loop: this is a high-risk, multi-unit lifecycle-state migration whose scope must remain bounded and whose implementation requires independent assessment before it can progress.

## Brief

Unit 3 established the plan's pre-migration baseline at commit `0a904934`: new admissions are paused, the three authorized old-semantics workflows are retired with their unfinished conditions preserved, and no other non-current live workflow remains. This unit now performs the frozen plan's one-time tracked-record migration while the old runtime is still deliberately in force; the next consumer cutover remains a separate tracer.

**Required outcome:** Account for every tracked `logs/work-loop/*.md` file and leave each one in exactly one evidenced class: valid active, valid blocked, valid closed, intentional negative fixture, or non-state target fixture. Every record intended to be valid must use the accepted explicit lifecycle contract and pass `logs/scripts/work-loop-state.sh`; intentional negatives must remain invalid for their intended reason, and the old Work Loop deterministic baseline must still function with the migrated records. Migrate this implementation task's own record during the unit so that the committed handback is `status: active`, `turn: codex`, and classifies as `ACTIVE_CODEX`.

**Governing authority and source dispositions:**

- Frozen plan `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`, Fixed decisions 1–6, Safe ordering step 3, and Tracer bullet 2 govern the destination, verification, and boundary. Its content-bound status is `FROZEN — approved for sequential implementation`.
- Accepted Unit 3 result and commit `0a904934d68ee4bcac0c199ae349c3d97e163e78` govern the starting position: the admission pause remains in force through operational proof and final landing; the three retirements are accepted; the pre-Tracer-2 inventory reported 46 canonical old-contract records, two noncanonical closed migration inputs, 25 fixtures, one current record, and zero other live workflows.
- `logs/scripts/work-loop-state.sh` and its focused tests are the already-proven inactive implementation of the accepted final record contract. Use its exact validation result to establish lifecycle validity; do not duplicate or loosen the contract in migration-specific logic.
- The currently canonical executable core and runtime consumers still describe/read the old state shape. They remain governing for this handoff and for old-runtime continuity only; this unit must not edit them or infer that their current no-`status` examples override the frozen plan's migration destination. Tracer 3 owns the coherent semantic cutover.
- Current operator decision, 2026-08-15, keeps all new Work Loop admissions in this repository paused. It authorized the three completed retirements; progression into this tracer is authorized by the already frozen sequential implementation plan, not by expanding that retirement decision.

**Check against the repository before editing:**

1. Reconfirm the exact task/checkout, repository-depth ownership, shared-lease state, HEAD `0a904934`, and the pre-existing hook-owned `logs/friction-log.md` modification. Stop if another task or actor now owns or leases a record to be migrated, if HEAD moved unexpectedly, or if the only-authoritative-copy premise is ambiguous.
2. Produce a complete tracked-file inventory from the tracked `logs/work-loop/*.md` surface. Verify the Unit 3 total and categories rather than trusting the reported counts; every path must have exactly one intended post-migration class, and the inventory must distinguish task records from intentional negative fixtures and non-state targets by repository evidence, not filename alone.
3. Run the inactive validator against the intended-valid records before migration and retain fail-capable starting evidence showing the old records do not yet satisfy the explicit lifecycle contract. Establish the relevant failure distribution or representative failures without turning the state file into an exhaustive transcript.
4. For every `turn: operator` record, decide from its own durable wording whether it is an unambiguous retrospective closure or an unresolved operator wait. Normalize the former to `status: closed` and the exact four closing headings; classify the latter as `status: blocked` with all five active/blocked headings and a real blocker. Stop rather than guess where the record is ambiguous.
5. Reconfirm the two known noncanonical closed inputs: `context-engineering-implementation-plan.md` and `foreign-staging-target-repo.md`. If their own records still unambiguously establish retrospective closure, normalize their headings and lifecycle as planned while preserving their substantive outcome, decisions, evidence, and limitations; do not reinterpret their history.
6. Determine each fixture's recorded intent from its tests and use. Preserve intentional negative fixtures as invalid by intent, update state-focused assertions where necessary so each fails for its intended invariant rather than an earlier accidental defect, and keep non-state target fixtures classified rather than forcing them into the state contract.

**Implementation boundary:** Add the explicit `status` lifecycle and mandatory body shape to all intended-valid tracked Work Loop records, performing only the lifecycle/body normalization required to make their already-recorded meaning valid. Preserve historical substance: do not upgrade an outcome, erase a limitation, invent an operator decision, resume a retired workflow, or reinterpret session history. Update existing state-focused fixture assertions only where required to preserve their stated discrimination under the new contract. A disposable migration operation may be used locally if useful, but do not add a permanent migration framework or runtime fallback.

This unit may edit tracked `logs/work-loop/*.md` records and the minimum existing state-focused test/fixture assertions required by the migration. It must not edit `.owner`, the executable core, either Work Loop actor instruction, Reorient, the owner helper, carrier, dispatcher, legacy session records, the frozen plan, deployment assets, or runtime consumer semantics. Do not archive tasks, create a second inventory artifact, clean `logs/friction-log.md`, merge, push, or begin Tracer 3.

**Codex framing decisions:** Treat repository-wide coverage as one dominant migration deliverable because Tracer 2's exit condition explicitly requires no unclassified tracked record; the word “every” is consequence-driven here, not an invitation to adjacent cleanup. Hold consumer cutover, owner-format change, legacy isolation, operational proof, closure, and landing outside this unit because the frozen safe ordering assigns them to later tracers. Treat lifecycle/body normalization as preservation work: wording may be compressed only where the existing meaning remains provably unchanged.

**Capability subset:** Baseline only — read/search/history inspection, repository-depth ownership and lease checks, local tests, edits within the tracked Work Loop records and minimum existing state-focused test assertions, and local commits by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed; no merge, push, deployment, network, credential, destructive action, policy expansion, or runtime consumer switch is authorized. This is an operator-carried interactive turn, so no courier runtime profile is claimed.

**Required evidence:**

- A before/after inventory accounting for every tracked `logs/work-loop/*.md` path in exactly one of the five permitted classes, with totals that reconcile and no unclassified record.
- Failing-first validator evidence from old intended-valid records, followed by `logs/scripts/work-loop-state.sh validate` success for every intended-valid record and the exact classification totals after migration.
- For every intentional negative fixture, an assertion or inventory mapping to its intended validator failure, plus evidence that it fails for that reason rather than an earlier unrelated defect; non-state targets must remain explicitly accounted for.
- Evidence that no ambiguous operator-turn record was guessed. For each migrated operator-turn record, preserve a concise mapping from old recorded meaning to either blocked or closed; call out any record whose disposition required more than mechanical heading/lifecycle normalization.
- Focused validator regression from `logs/scripts/work-loop-state.test.sh` and the original old-runtime deterministic baseline from `logs/scripts/work-loop-v2-slice-1.test.sh`, with exact pass/fail counts and exit status. If another existing state-focused assertion is changed, run its owning focused suite as well.
- Direct validation of this task's committed handback shape as `ACTIVE_CODEX` while the old runtime still accepts it.
- A scoped diff review showing no semantic history rewrite beyond explicit lifecycle/body normalization, no `.owner` or consumer change, and a commit/path summary that accounts for all changed tracked files. Keep the hook-owned `logs/friction-log.md` modification outside the commit and untouched.

**Completion condition:** Commit the complete Tracer 2 migration and its minimum test updates, including this migrated task record. Replace `## Latest result` with the reconciled inventory, classification, ambiguity, validator, negative-fixture, old-runtime, scope, and commit evidence; retain `status: active`, set `turn: codex`, and hand back for assessment. State explicitly that `.owner` remains in old `{task-id} {date}` form, runtime consumers have not switched, admissions remain paused, and Tracer 3 has not started.

**Stop conditions:** Stop without guessing if any tracked operator-turn record has ambiguous lifecycle meaning; a task record has multiple plausible authoritative copies; a live owner or lease conflicts with migration; preserving an intentional negative's reason requires weakening the validator; the old runtime does not tolerate the migrated valid records; the migration would require `.owner` or consumer changes; repository evidence materially invalidates the frozen contract; or completing the inventory would require interpreting legacy session history. Report the exact paths and evidence, set `turn: codex` for a technical/premise handback, and do not partially claim Tracer 2 complete.

## Latest result

Tracer bullet 2 is complete. Every tracked Work Loop record now carries an explicit, validator-classified lifecycle; no runtime consumer switched. **`.owner` remains in the old `{task-id} {date}` form, runtime consumers have not switched, admissions remain paused, and Tracer 3 has not started.**

Inspected (2026-08-15) at baseline HEAD `0a904934`.

- Premise (1): HOLDS — `.owner` reads `work-loop-v2-durable-state-system 2026-08-14`, the old form. `work-loop-owner.sh check --depth repo` → `PROCEED`. HEAD is exactly `0a904934` as the brief states. `logs/friction-log.md` was already modified by the session hook before this unit began and was neither read into scope nor cleaned.
- Premise (2): HOLDS, and the Unit 3 counts were re-derived rather than trusted. The tracked surface is **74** files. Classified from repository evidence: **55 valid closed**, **13 valid active**, **0 valid blocked**, **3 intentional negative fixtures**, **3 non-state target fixtures** — 55+13+0+3+3 = 74, reconciled, with no unclassified record. Unit 3's report used a different partition (it excluded fixtures and counted only non-fixture records); its 46 canonical old-contract records plus the 2 noncanonical inputs plus the 7 closed fixtures give the 55 closed here, so the two inventories agree once the fixture axis is added.
- Premise (3): HOLDS — failing-first. Before migration the validator was run over all **71** tracked state records: **71 of 71 exited 15**, every one with `required frontmatter key 'status' is missing`, and **zero** passed. The old records demonstrably did not satisfy the explicit lifecycle contract, and the run proves the validator was actually executing rather than silently passing.
- Premise (4): HOLDS, and no operator-turn record was guessed. Every `turn: operator` record was checked for a surviving active heading and for retrospective wording. Exactly two carried anything other than the four closing headings, and both are the already-known noncanonical inputs. Every other operator-turn record is Outcome-led with no active heading, so each maps mechanically to `status: closed`. **No record required a blocked classification**, because Unit 3's operator-authorized retirement had already converted the only two genuine operator waits into closing records.
- Premise (5): HOLDS with one flagged exception, below.
- Premise (6): HOLDS — each fixture's intent was read from its use in the harness, not from its filename.

**Classification, and what each class did.**

*Valid closed (55).* `status: closed` inserted above `turn: operator`. Bodies unchanged except for the two noncanonical inputs.

*Valid active (13).* `status: active` inserted. Eight classify `ACTIVE_CLAUDE` and five `ACTIVE_CODEX` after this record's own hand-back flip.

*Intentional negative fixtures (3), preserved as invalid by intent.* Each previously failed at exit 15 on the missing `status` key — an earlier, unrelated defect that masked the invariant it exists to break. Each was given the status its own turn makes legal, so it now fails at its intended invariant instead:

- `fixture-continue-malformed` — exit 16, `unsupported top-level heading '## Next steps'`. Its point is the malformed heading.
- `fixture-slice2-foreign` — exit 14, identity mismatch: the file is `fixture-slice2-foreign` and its frontmatter says `fixture-slice2-other`. Its point is file-identity rejection (behaviour 2.2).
- `fixture-step6-admission` — exit 16, `required heading '## Lane and unit' is missing`. Its point is that a refused admission opened no lane, no unit and no brief; the harness asserts that absence directly, so making it valid would have contradicted the fixture.

*Non-state target fixtures (3), untouched.* `fixture-target`, `fixture-target-2`, `fixture-target-3` carry no frontmatter and are edit targets, not state files. `git diff` for all three is empty. They are classified, not forced into the state contract.

**The one disposition beyond mechanical normalization** — flagged as the brief requires. `context-engineering-implementation-plan.md` was closed by its own wording ("Closed 2026-08-02 by operator approval", and its own last line "This file is closed and is not that one"), so its lifecycle is unambiguous. But it carried a fifth `## Next action`, which a closed record may not hold. Its content is a real outstanding step — the operator must answer O-1 before S1 opens — and that step belongs to a *different* task's file. Rather than delete it, it was carried into `## Accepted limitations` quoted in full, with a sentence recording that the Tracer 2 normalization moved it and withdrew nothing. `foreign-staging-target-repo.md` needed only a heading rename, `## Final commit and evidence` to `## Evidence`; likewise `## Evidence pointer` to `## Evidence` in the first record. No outcome was upgraded, no limitation erased, no history reinterpreted.

**Validator evidence after migration:** all **68** intended-valid records exit 0 — 55 `CLOSED`, 8 `ACTIVE_CLAUDE`, 5 `ACTIVE_CODEX` — and the 3 intentional negatives still fail, at exits 16, 14 and 16 respectively, each naming its own invariant rather than the missing-status defect. This record validates as `ACTIVE_CODEX` at hand-back.

**Focused validator regression** `logs/scripts/work-loop-state.test.sh`: **63 passed, 0 failed, exit 0** — up from a pre-existing **62 passed, 1 failed, exit 1** at the start of this unit.

**Old-runtime deterministic baseline** `logs/scripts/work-loop-v2-slice-1.test.sh`: **305 passed, 3 failed, exit 1** before this unit, and the same **3 failures remain** after it. The migration added no failure and removed none. The three are unchanged and pre-existing:

- `ridx  the marked set matches the live installations, not just the brief` — about installed skills, unrelated to state records.
- `mode  the live task's named reason does not defeat its own admission either`
- `mode  the live task's own state file records exactly one legal mode`

The two `mode` failures have a definite cause worth recording: both assertions hardcode `logs/work-loop/work-loop-v2-intake-router.md` as "the live task", and Unit 3's accepted retirement removed that record's `## Lane and unit`, so `mode_of` and `reason_of` now read an empty string. They were red at this unit's baseline and are red now. **Repointing them at the current live task is adjacent improvement, not migration work, so it is recorded here as a deferral and left unimplemented.**

**Two existing assertions were changed, both required by the migration, and both keep their discrimination.**

1. `mode  every mode fixture carries task and turn frontmatter and nothing else` counted exactly two frontmatter keys, which the added `status` key breaks. It now requires exactly `task`, `status` and `turn` and exactly three lowercase keys. Its real invariant — that mode never becomes a frontmatter key — is intact: a `mode:` line would still make the second count disagree with the first and fail it.
2. `work-loop-state.test.sh` P5, `dispatch.sh --status still parses the status-augmented record`, was failing before this unit for a sandbox setup gap: `new_git_checkout()` copied the owner helper but not `work-loop-lease.sh`, and `dispatch.sh` resolves that library under the checkout and exits 11 before it ever parses a state file. The assertion could not discriminate at all — it reported a lease-library error, never a verdict. One `cp` line was added so the sandbox carries the library. P5 now passes on a real verdict.

Because P5 is an assertion this unit repaired, the old-runtime tolerance claim does not rest on it. It was proved independently against the real repository: the real `dispatch.sh --status` reads the migrated active record and the migrated closed record correctly, printing the expected task, owner and lock lines, and `work-loop-owner.sh check --depth repo` still returns `PROCEED` against migrated records. The probe is fail-capable — run against a task id that does not exist it returns visibly different output with no lock lines.

**Scope.** The commit contains the migrated tracked records plus exactly the two test files named above. No `.owner` change, no consumer change, no core or plan edit, no new migration framework and no runtime fallback — the migration was a disposable local script. `logs/friction-log.md` remains a hook-owned modification, untouched and outside the commit.

## Blocker

None.

## Next action

Codex: assess Tracer bullet 2. The tracked-record inventory reconciles at 74 with no unclassified record, every intended-valid record validates, each intentional negative fails for its own invariant, and the old runtime still reads the migrated records. Two decisions are yours: whether the `context-engineering-implementation-plan.md` disposition — carrying its former `## Next action` into `## Accepted limitations` — is the right preservation, and whether to schedule the recorded deferral repointing the two `mode` assertions at a live task record. If Tracer 2 is accepted, the next unit is Tracer bullet 3; it has not started.
