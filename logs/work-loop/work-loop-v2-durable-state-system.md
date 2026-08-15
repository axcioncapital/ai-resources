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

**Correction round on Tracer bullet 2. Finding 1 is corrected; finding 2 is partly resolved and handed back, because closing it would require a change the finding itself forbids.** Both findings were reproduced by inspection before either was touched. `.owner` remains in the old `{task-id} {date}` form, runtime consumers have not switched, admissions remain paused, and Tracer 3 has not started.

**The frozen findings, carried into the record.** Codex's correction brief was never committed, so the two findings this round answers are preserved here verbatim rather than left only in an uncommitted working copy:

> 1. The frozen Tracer bullet 2 verification says the original Work Loop acceptance harness remains green, and its exit condition says the old runtime completes its deterministic baseline. The reported `logs/scripts/work-loop-v2-slice-1.test.sh` result is 305 passed / 3 failed, exit 1, so unchanged red is not sufficient. Correct the two `mode` assertions that still hardcode the now-retired `work-loop-v2-intake-router.md` as the live task. Point them at this implementation task, or an equally durable current live record, while preserving their ability to fail on a missing/self-defeating named reason and on any mode other than exactly one legal `Implementation` record.
> 2. Reconcile the remaining `ridx` live-installation failure and return the same deterministic harness green. First establish and report the exact set difference behind `the marked set matches the live installations, not just the brief`. Correct only a stale or overbroad test expectation/setup when repository authority already establishes the intended route set; do not edit the routing index, install or remove skills, expand the approved route inventory, or change runtime behaviour to manufacture green. If green would require any such authority or scope change, stop and hand back with the exact mismatch rather than proceeding.

**Reproduction, before any edit.** At HEAD `a1c81caf`, `logs/scripts/work-loop-v2-slice-1.test.sh` gave **305 passed, 3 failed, exit 1** — the same three failures the accepted Tracer 2 result recorded, and exactly the three the findings name.

**Finding 1 — corrected.** The two `mode` assertions hardcoded `logs/work-loop/work-loop-v2-intake-router.md` as "the live task". Unit 3's authorized retirement reduced that record to the four closing headings, so it no longer has a `## Lane and unit`, and both `reason_of` and `mode_of` read the empty string against it — confirmed by direct inspection, both returning `[]`. Both assertions were repointed at this implementation task's own record, which is the current open Standard record: `mode_of` returns `Implementation`, and the named reason ("a high-risk, multi-unit lifecycle-state migration whose scope must remain bounded…") does not match the `SELF_DEFEATING` pattern. The pointer now sits in one variable, `LIVE_TASK_F`, with a comment stating that a closed record has no `## Lane and unit` and that the single line must be repointed when this task closes — the exact failure that produced this finding.

Both repaired assertions were proved fail-capable against mutated copies in a scratch directory; the real record was not touched by any probe:

| Probe | Assertion | Result |
|---|---|---|
| named-reason line deleted | named reason | FAILS |
| named reason replaced with "the change is small and reversible…" | named reason | FAILS |
| `## Lane and unit` renamed away (closed-record shape) | both | FAILS |
| mode changed to `Adoption mode` | one legal mode | FAILS |
| `Implementation mode. Adoption mode.` — two modes | one legal mode | FAILS |
| mode token removed entirely | one legal mode | FAILS |
| target file absent | both | FAILS |

Both pass on the real record. The discrimination the finding required — failing on a missing or self-defeating named reason, and on any mode other than exactly one legal `Implementation` — is preserved in both directions.

**Finding 2 — the exact set difference, and why green is not available inside this scope.** The failing assertion compares the `[Claude-side only]` markers in the routing index against the live installation difference. The difference is exactly one name:

- Marked in `.agents/skills/work-loop-v2/references/routing-index.md`, and listed in the harness's `CLAUDE_ONLY`: **12** names.
- Live `~/.claude/skills` minus `~/.codex/skills`: **11** names.
- The single extra is **`diagnosing-bugs`**. The other 11 match exactly.

`diagnosing-bugs` is installed on **both** sides, so it is not Claude-side-only in the live environment. The Codex-side copy is dated **2026-08-15 11:14**, alongside `axcion-repository-development` at 10:59 the same morning — after the routing index was written (`a22b54b7`) and after `CLAUDE_ONLY` was written (`bd45bf01`). This is a live-environment change, not a stale or overbroad test expectation: the assertion's own comment says it exists so that "a renamed or retired skill breaks this rather than drifting silently", and that is exactly what it did. The stale artifact is the routing index's marker, not the check.

Every available route to green is a change the finding forbids. Removing the marker edits the routing index. Uninstalling the Codex-side copy removes a skill. Changing `CLAUDE_ONLY` alone would break the sibling assertion `exactly the 12 Claude-side-only skills carry the marker`, which reads the index and currently passes. Loosening the live cross-check would delete the discrimination the assertion exists for. Per the finding's own instruction, the mismatch is reported and handed back rather than manufactured green: the first half — establish and report the exact set difference — is discharged; the second half is not, and the harness is not returned fully green.

**Harness result after the correction.** `logs/scripts/work-loop-v2-slice-1.test.sh`: **307 passed, 1 failed, exit 1** — up from 305 passed / 3 failed. The two `mode` failures are gone; the single remaining failure is the `ridx` one above, unchanged and untouched.

**Focused validator regression.** `logs/scripts/work-loop-state.test.sh`: **63 passed, 0 failed, exit 0** — identical to the accepted Tracer 2 result. The correction broke nothing in the validator contract. This record validates as `ACTIVE_CODEX` at hand-back.

**Did the correction break anything inside the frozen scope?** No. Only the two `mode` assertions changed. The harness gained two passes and lost none, and the `ridx` failure is the one that was already red. The migrated record contents, classifications, `context-engineering-implementation-plan.md` preservation, `.owner`, consumers, core, skills, routing index and installations were all left untouched — `git status` shows exactly two modified tracked files, `logs/scripts/work-loop-v2-slice-1.test.sh` and this record. `logs/friction-log.md` remains a hook-owned modification, untouched and outside the commit.

**One note on this round's own execution, disclosed rather than hidden.** While rewriting this section, a `git show HEAD: > file` restore was run against the working copy, which still held Codex's uncommitted correction brief. That brief was reconstructed verbatim and verified: the working copy's only differences from HEAD were the `turn:` line and the `## Next action` block, exactly as Codex left them. Nothing was lost, and the findings above are quoted from that reconstruction. The lesson is the standing one — do not run a restore form against a dirty file.

**Carried forward from the accepted Tracer 2 result** (Git holds the full text at `a1c81caf`): all **74** tracked `logs/work-loop/*.md` paths reconcile into five classes — 55 valid closed, 13 valid active, 0 valid blocked, 3 intentional negative fixtures, 3 non-state target fixtures. All 68 intended-valid records exit 0; the 3 intentional negatives still fail at exits 16, 14 and 16, each on its own invariant. The one disposition beyond mechanical normalization remains `context-engineering-implementation-plan.md`, whose fifth `## Next action` was carried into `## Accepted limitations` quoted in full.

## Blocker

None.

## Next action

Codex: run the correction closure check on the two frozen findings only.

1. Finding 1 is resolved. Confirm the repointed assertions and their fail-capability evidence.
2. Finding 2 is **partly resolved**. The exact set difference is established and reported — `diagnosing-bugs`, marked Claude-side-only in the routing index but live on both sides since 2026-08-15 11:14 — but the harness is not green. Closing it needs a decision outside this correction's frozen scope: correct the routing index marker, accept the divergence as a written limitation, or refer the installation question to the operator. Choose from the § 3 menu. This is not a request for a second correction round.

The Tracer 2 deferral recorded at the previous hand-back is now discharged in part: the two `mode` assertions were repointed here. Nothing was implemented beyond the two frozen findings.
