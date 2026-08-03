---
task: context-engineering-s7-regression
turn: codex
---

## Objective and approved scope

Complete S7 from the governing Context Engineering implementation plan against the live Work Loop v2
implementation: first make the grouped regression instrument complete, then run Slice E only after Codex
has accepted that instrument and the operator drives the required fresh Codex threads.

This task covers S7 only. It does not decide O-3, classify entrypoints, touch Work Loop v1, claim adoption,
or begin S8a/S8b. The closed implementation record is
`logs/work-loop/context-engineering-implementation.md`; it remains closed and is never edited.

## Current lane and unit

Standard. S7 readiness, Unit 1 — build the missing grouped-regression fixtures and stop before any run.

Named reason for the loop: the work spans fixture construction, independent assessment and operator-driven
runs; the scope must stay bounded to S7; and the instrument must be assessed by someone other than its
builder before its results can count.

## Brief

The common v2 implementation is live and its harness is green, but S7's required grouped regression is not
constructible from the repository yet: R-2 exists, R-3 has only the earlier partial CE-9 material, and R-1,
R-4 and R-5 are absent. Build the missing reusable instrument now; do not run Codex or score behaviour.

### Required outcome

Create complete fixture sets under
`plans/work-loop-v2-v0.2/context-engineering/trials/regression/` for R-1, R-3, R-4 and R-5. Preserve the
existing R-2 bytes. Each case must contain one frozen operator request and the minimum synthetic workspace
needed to seed every inherited subcase below, with each fixture file opening with the plan §4.4
`FIXTURE —` authority disclaimer.

The cases must be usable later from disposable roots that contain only `request.md`, `workspace/`, the live
Work Loop v2 skill and the executable core. Do not put the specification, plan, this state file, expected
verdicts, condition labels, answer keys or prior outputs into a runnable case.

### Complete subcase floor

- **R-1:** CE-1 derivable information; CE-2 genuine operator decision versus repository-resolvable
  information; CE-3 a load-bearing unknown answerable by inspection; CE-11 A multi-unit objective with held-
  back work; CE-11 B two load-bearing objective parts with one inconvenient; CE-15 one artifact/two
  audiences; CE-17 clauses 1–2 one input and one preparation pass.
- **R-3:** CE-7 one deliberately false load-bearing repository assertion; CE-8 one absence assertion that
  requires both searched surface and pattern; CE-9 A one irrelevant repository area; CE-9 B fresh-session
  recovery of a material fact absent from the request; CE-9 C missing current state without invented
  continuity. Reuse the existing S1 CE-9 fixture bytes where they fit; add only what makes R-3 complete.
- **R-4:** CE-10 A irreconcilable objective; CE-10 B silent plan deviation; CE-11 A and B; CE-12 A a Codex-
  added exclusion requiring attribution and reason; CE-12 B an unsettled technical preference; CE-13 A
  stale speculative over-inclusion, B a load-bearing constraint buried in low-value material, and C an
  uncertain-relevance item; CE-14 an undisclosed material demotion and the opposite discard-ledger error.
- **R-5:** a sequence of routine invocations with no new operator input, approval or materially changed
  understanding, capable of detecting any new durable context file, discovery log, run record or session
  note; and capable of re-confirming CE-15's one-artifact count.

### Claims to check before acting

1. The closed implementation record says the live skill carries six family blocks, the candidate is
   removed and the harness is 149 passed / 0 failed; recheck those current repository facts.
2. `trials/regression/r-2/` is the only complete grouped-regression case currently present; R-1, R-4 and
   R-5 are absent, while the existing CE-9 scenario explicitly says it is not a complete R-3. Inventory the
   exact searched paths and report any disagreement before building.
3. Plan §7.1 requires each case to inherit the complete seeded subcase set and later report one line per
   subcase. Recheck the S3, S5 and S6 constructed-failing-case lists against the floor above; stop if the
   floor omits a plan-required subcase.
4. The live skill, not a deleted candidate, is now the runtime subject. Do not recreate a development
   candidate or alter the live runtime in this unit.

### Files in scope

- `logs/work-loop/context-engineering-s7-regression.md`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-1/**`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-3/**`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-4/**`
- `plans/work-loop-v2-v0.2/context-engineering/trials/regression/r-5/**`
- `logs/scripts/work-loop-v2-slice-1.test.sh` only to add this exact new task-state filename to its closed
  allowlist; do not change the matcher or any assertion.

Everything else is read-only. Do not edit R-2, the live skill, executable core, Claude command,
specification, implementation plan, closed implementation state, prior evidence, roots or outputs.

### Evidence capable of failing

- Inventory every created file and show that every first line has the fixture disclaimer.
- Map every required subcase above to at least one exact fixture path and seeded fact. A missing mapping
  fails the unit.
- Search the runnable fixture bytes for condition labels, `red`/`green` expectations, slice names, answer-
  key language and the governing specification/plan/state filenames. Any unexplained hit fails the unit.
- Show each request omits at least one material fact that its workspace carries, where the case requires
  discovery rather than request echoing.
- Show R-2 is byte-identical before and after; the live runtime files are unchanged; no file outside the
  declared footprint changed; and the existing harness returns 149 passed / 0 failed after the exact
  allowlist addition.
- State the reproducible future root recipe for each case, but do not build a root and do not run Codex.

### Stop conditions

Stop and set `turn: codex` without constructing past the problem if the subcase floor conflicts with the
approved plan, an answer-key-free case cannot be built, existing fixture bytes would need destructive
rewriting, or any runtime change is required. Do not solve a missing instrument by weakening a pass
condition.

Commit the fixture sets, exact harness allowlist addition and this state file; set `turn: codex`; stop.

## Latest result

Inspected (2026-08-03):

- **Claim (1): HOLDS, with one current-state qualification.** Searched
  `logs/work-loop/context-engineering-implementation.md` for the three assertions; the closed record does
  state all three (lines 8–14, 62–66). Re-derived against the repository: `grep -c '^### '
  .agents/skills/work-loop-v2/SKILL.md` returns **6** (lines 59, 67, 75, 83, 91, 97) — six family blocks,
  confirmed. `ls -d plans/work-loop-v2-v0.2/context-engineering/trials/candidate` returns *No such file or
  directory* — the candidate is removed, confirmed. **The harness figure is stale: `bash
  logs/scripts/work-loop-v2-slice-1.test.sh` returns 147 passed / 2 failed, not 149 / 0.** Both failures are
  assertion `3.1a` (`no state file was opened for the direct request`; `every task-state file present is one
  this build created deliberately`), tripped by this brief's own state file
  `logs/work-loop/context-engineering-s7-regression.md` against the closed allowlist at
  `logs/scripts/work-loop-v2-slice-1.test.sh:430-441`. This is the exact condition the closed record
  predicted and the brief already authorises fixing, so it is a qualification and not the blocker — recorded
  so 147/2 is not later read as a regression.
- **Claim (2): HOLDS.** Searched `plans/work-loop-v2-v0.2/context-engineering/trials/regression/` — it
  contains exactly two entries, `r-2/` and `r-2-void-run-2026-08-03/`. No `r-1/`, `r-3/`, `r-4/` or `r-5/`
  directory exists at that path. `r-2/` holds 15 files, every one opening with the §4.4 `FIXTURE —`
  disclaimer. Searched `plans/work-loop-v2-v0.2/context-engineering/trials/ce-9-recovery-scenario.md` for
  its R-3 disposition; lines 163–166 state that R-3 also carries a false repository claim and an absence
  claim, and that a reader "must not treat this file as a complete R-3." No disagreement to report.
- **Claim (3): the assertion HOLDS; the stop condition it attaches has FIRED.** Searched
  `context-engineering-implementation-plan-v0.1.md` §7.1 (lines 468–477): rule 1 requires each case to
  inherit the complete seeded subcase set from the slice that built those behaviours, and rule 2 requires
  one reported line per subcase — both present as claimed. Rechecking the three slice lists the claim names:
  **S3** (lines 703–708 — CE-1, CE-2, CE-3, CE-15, CE-17 clause 1) is covered by the R-1 floor; **S5**
  (lines 832–835 — CE-7, CE-8, CE-9 A–C) is covered by the R-3 floor; **S6** (lines 857–875 — CE-10 A/B,
  CE-11 A/B, CE-12 A/B, CE-13 A/B/C, CE-14 including its opposite discard-ledger error) is covered by the
  R-4 floor, subcase for subcase. **All three named lists pass.** The omission is in R-5, whose source slice
  is S7 — outside the three slices the claim named to recheck, but inside §7.1 rule 1, which is not limited
  to them. See `## Blocker`.
- **Claim (4): HOLDS.** Searched `plans/work-loop-v2-v0.2/context-engineering/trials/` for a `candidate`
  directory — absent (claim 1). The live skill `.agents/skills/work-loop-v2/SKILL.md` carries the six
  family blocks and its § *Scope of this version* (line 160) states Context Engineering is live in it, so
  the live file is the runtime subject. Nothing in this invocation recreated a candidate or altered a
  runtime file.

Result: The unit did not begin. Three of the four claims hold outright, the fourth holds with a stale
harness figure, and the recheck claim (3) named passed on all three slices it named — but the stop
condition attached to it fired on a fourth slice, so no fixture was built and no file outside this state
file was touched.

Evidence: `git diff` and `git status --short` across every path in `### Files in scope` other than this
state file are empty — no `r-1/`, `r-3/`, `r-4/` or `r-5/` directory was created under
`plans/work-loop-v2-v0.2/context-engineering/trials/regression/`, and
`logs/scripts/work-loop-v2-slice-1.test.sh` is unmodified (its allowlist addition is *authorised* by the
brief but is deliberately not applied, because a hand-back changes nothing but the state file). The check
can fail: it returns non-empty the moment any fixture is written. The harness still returns 147 passed /
2 failed for the reason recorded under claim (1) — committing this file does not change that, because the
assertion scans `logs/work-loop/` for presence, not for tracked status.

## Blocker

**The `### Complete subcase floor` omits a plan-required subcase for R-5: CE-16 A.**

What the plan requires. §8 line 1235 assigns CE-16 to regression case R-5, built in Slice E · S7, with its
failing case stated in S7. §8 lines 1242–1247 are explicit that the assignment table's unit is the
behaviour while the proof's unit is the subcase, and that the subcase claim lives only in the §7 session's
`Constructed failing cases` list — naming this exact error ("headers promising CE-4 A–D, CE-6 A–C and
CE-12 over sessions that seeded one subcase each") as the one an earlier version of the plan already made.
§7.1 rule 1 then requires R-5 to inherit S7's complete seeded subcase set.

What S7 constructed. Plan lines 895–898 name **two** subcases, not one:

- **CE-16 A** — new machinery added: a context-QC pass, an alignment gate, a review stage, a new document
  type, an archive, a context-pack lifecycle, a decision register, a provenance ledger, an approval
  artifact, a plan-history log, a plan copy, or a second state system.
- **CE-16 B** — a routine invocation writing a context file, discovery log, run record or session note.

What the floor names. The brief's R-5 entry requires a routine-invocation sequence "capable of detecting
any new durable context file, discovery log, run record or session note" plus CE-15's artifact count. That
is CE-16 B and CE-15. **CE-16 A is absent** — and it is not covered by implication, because roughly half of
its listed machinery (a context-QC pass, an alignment gate, a review stage, a context-pack lifecycle) adds
an operator-visible stage while writing no durable file, so a file-detector cannot see it. Plan lines
901–902 make the two targets separate and both mandatory: "zero net new durable files, **and** zero
additional operator-visible stages, gates, review passes or persistent artifacts."

Why this stops the unit rather than being widened in place. Three reasons, and the first is the brief's
own: the `### Stop conditions` say to stop and set `turn: codex` without constructing past the problem if
the subcase floor conflicts with the approved plan, and claim (3) says to stop if the floor omits a
plan-required subcase. Second, the required evidence is bound to the floor as written — "map every required
subcase **above** to at least one exact fixture path and seeded fact" — so building to a floor known to be
incomplete would produce a mapping that certifies a complete instrument that is not one (core §6 rule 5).
Third, widening the floor is a framing decision that belongs to Codex; making it here would be the silent
repair of a brief that core §1 prohibits. This is core §7's *hand back — the required evidence cannot be
produced*, not a false claim: no claim in the brief is false.

**Candidate deferral, recorded and not done** (core §5): `r-2-void-run-2026-08-03/`'s captured Codex output
does not open with the §4.4 `FIXTURE —` line. It is a run capture rather than a fixture, so rule 1 may not
reach it — but the S7 fixture-escape grep will read it either way, and nothing in this task's scope decides
which it is. Not touched: the R-2 area is read-only in this unit.

## Next action

Codex: decide the R-5 floor. Either (a) extend the `### Complete subcase floor` to carry CE-16 A alongside
CE-16 B — naming what a fixture must seed for the non-file half (an added stage, gate, review pass or
context-pack lifecycle) and what evidence detects it, since a durable-file diff will not — or (b) record
why R-5 is exempt from §7.1 rule 1 for that subcase, against §8 lines 1242–1247. Then reissue with
`turn: claude`. The other three floors (R-1, R-3, R-4) were rechecked against S3, S5 and S6 and need no
change. Also decide whether the authorised allowlist addition should be folded into the reissued unit —
until it is applied the harness reads 147/2, for the reason recorded above and not for a regression.
