---
task: house-view-workflow-repair
status: closed
turn: operator
---

## Outcome

The House View workflow repair stops at the approved Move 2 feasibility gate, with one completed
repair kept and the review-loop redesign not adopted.

Unit 1 stands as a completed, useful repair. It fixed the final-thesis evidence-isolation defect in
the judgment-contract validator — the last thesis could borrow a citation from `## Provisional
verdict`, so an uncited final thesis passed on the verdict's evidence — proved by a targeted
five-thesis case that failed before the production edit and passed after it, with the focused suite
at 20 passed / 0 failed. It also recorded the operator's 2026-08-20 approval of the repair plan as
content-bound header metadata, leaving the approved semantic body byte-unchanged.

Unit 2 ran the Move 2 blind historical first challenge and is accepted as an honest experiment: it
stayed within the 1,500-word founder-facing bound at 1,188 words, screened CC-1 and the full decision
surface, changed nothing outside the state file, and avoided the historical false F4 premise.

The feasibility result is nevertheless **FAIL** under Move 2's conjunctive pass rule. The run found
F1, F5, F6, F8 and F10 in substance, but missed F2's founder-rollover miscitation and F3's model-fit
overclaim. It recognized F7's buyer-classification and scope ingredients in Thesis 1 without flagging
their repetition in the Provisional verdict — the decisive locus whose survival caused the later
serial rediscovery — so F7 is not credited as caught. Missing any of F1–F3, F5–F8 or F10 fails the
experiment; this run missed three required defect classes or loci.

## Decisions that matter

- **Close rather than correct or continue.** This is not an implementation defect in the unit, and no
  correction round can turn a blind result into a different blind result.
- **The approved plan's stop condition governs.** A failed first-challenge experiment stops the
  repair rather than authorizing further workflow machinery. The narrow historical revision check was
  not run, Move 3 was not implemented, and Move 4 and any successor pilot were not opened.
- **What survives.** The Unit 1 parser fix remains in place and is unaffected by the stop. The
  single-reviewer review-loop repair is not proven and is not adopted.
- **Deferred by this closure:** the Move 2 revision check, all Move 3 workflow changes, and the Move 4
  successor pilot — deferred because the feasibility gate they depend on did not pass, not because of
  cost or sequencing.

## Evidence

- Unit 1 commit `6aecd7ad74adbd3ebe459412ac26f42bc2e3a4c6` — validator fix, targeted RED-to-GREEN
  case, plan approval header.
- Unit 2 handback commit `89aea31e367494063da98ef3c97074184a23b331` — the blind review, its measured
  word count, and the freshness disclosure.
- The historical answer-key ledgers in the bound consumer checkout, against which Codex scored the
  blind run.
- This closing commit, titled `close: house-view-workflow-repair — stopped at the Move 2 feasibility
  gate`, on branch `session/2026-08-19-rw-l4-integration`. It is named by title rather than by hash
  because a commit cannot carry its own hash.
- Work Loop capability in this checkout is `READY` after the operator-authorized `/sync-workflow`
  repair, which `cmp` proved byte-identical to canonical. That helper sync stayed outside this task's
  scoped commits.
- `logs/innovation-registry.md` and the untracked repair decision report remain untouched. Nothing was
  pushed, merged or deployed.

## Accepted limitations

None. The missing reviewer coverage is an unmet feasibility outcome — not an accepted limitation, and
not authority to proceed with a partially effective review design.
