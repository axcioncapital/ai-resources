---
task: eval-v0-3-restart
turn: codex
---

## Objective and scope
Restart the Work Loop v2 behavioural-eval effort from the clean current `main` baseline and carry it to an honest, repeatable eval capability whose first live act is EV-3/CE-9. The operator has approved this `eval-v0-3` restart; adoption remains a later operator decision based on recorded operating evidence.

This task may use the abandoned `session/2026-08-09-eval` branch and its dirty worktree as read-only evidence, but it must not edit, clean, commit, merge, cherry-pick, or otherwise change that checkout. Excluded from the whole task unless the operator later expands scope: an eval platform, dashboard, database, new scoring system, new durable fixture family, unattended eval execution, Work Loop core/skill/command changes, dispatcher changes, and automatic landing or cleanup of another checkout.

## Lane and unit
Standard. Implementation mode. Unit 2 — create one operator-runnable EV-3/CE-9 run sheet for one source-opened run and its paired memory-only control.

Named reason for the loop: the work must survive several sessions, its abandoned predecessor left substantial uncommitted partial effects in another checkout, and independent assessment is needed before any recovered design or implementation counts as the new baseline.

## Brief
Unit 1 established that the first authorized eval act is the still-unrun EV-3/CE-9 proof, while the wider six-scenario proposal remains operator-owned. This unit makes that one proof runnable without adopting the proposal's runner, result schema, or transport assumptions. It advances Harness v0.2 Phase 1's fresh-context proof while keeping the live trial for a later unit.

### Required outcome

Create exactly one new operator-facing run sheet at:

`plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md`

The run sheet must turn the existing CE-9 measurement instrument into a self-contained procedure for exactly one EV-3 trial: one genuinely fresh memory-only control and one genuinely fresh source-opened Codex run. It must be runnable by an operator without relying on this conversation and must preserve the instrument's blindness rules: neither run receives the scenario file; the control receives only the request text between the markers; the source-opened run receives that same request plus exactly the three Harbourview source paths named in the instrument; neither run receives a prior summary, session note, or transcript context.

The sheet must:

1. Give the operator an ordered preflight, launch, capture, scoring, and stop procedure for the paired run, without executing it in this unit.
2. Use the existing instrument's two mechanical checks and state the invalidating mutant: if the discriminator appears inside the request markers, the absence check flips to exit `0`, the instrument is broken, and that trial is failed rather than worked around.
3. Score the one pair against `ce-9-recovery-scenario.md` §6: discriminator recovery and continuation integrity. The source-opened output must recover the offset defect, affected confirmations since 2026-06-14, and the corrective next unit; the control must not reach that corrective unit. The sheet must also require checking the recovered objective, current state, settled decision, live blocker, and next justified unit against the fixtures.
4. State that the later trial's canonical result is returned through this task's existing state file, `logs/work-loop/eval-v0-3-restart.md`, and eventually its closing record—not a new results database, runner log, or append-only eval schema. Define only the minimum evidence needed for this one pair: date and evaluated HEAD, freshness/blindness confirmation for both runs, captured outputs or exact pointers, the mechanical preflight outcomes, discriminator outcome, continuation-integrity outcome, PASS/PARTIAL/FAIL verdict, and the reason for any non-pass.
5. Make the lifecycle boundary explicit: this run sheet prepares one trial; it does not authorize the six-scenario pack, adoption, unattended execution, or any carrier/dispatcher change.

### Governing sources and source dispositions

- **Governing:** the operator's 2026-08-13 restart decision in this state file, including that EV-3/CE-9 is the first live act and adoption remains a later operator decision.
- **Governing product direction for this unit:** `plans/axcion-harness-v0.2/mvp-plan.md` Phase 1 requires the CE-9/CE-17 fresh-context proof and rejects a broad eval platform; `logs/decisions.md` (2026-08-13, “Axcíon Harness v0.2 adopted for normal attended pilot use”) identifies that plan as governing while preserving its later adoption bar. Its stale proposal-status header is a known conflict, not permission to broaden this unit.
- **Governing Work Loop contract:** `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and `.agents/skills/work-loop-v2/SKILL.md` govern roles, evidence, unit boundaries, and hand-back.
- **Verified technical instrument, not authority:** `plans/work-loop-v2-v0.2/context-engineering/trials/ce-9-recovery-scenario.md` and its four `fixtures/ce-9/` files define the already-built measurement and scoring rules this sheet operationalizes.
- **Authoritative current evidence:** `logs/work-loop/context-engineering-implementation.md` establishes that Context Engineering is implemented but CE-9's behavioural proof and integrated proof remain incomplete.
- **Candidate background only:** `plans/work-loop-v2-v0.2/eval-mvp-proposal-v0.2.md`; its six-scenario design, repeat policy, and results schema do not govern this unit.
- **Excluded historical evidence:** the abandoned eval branch, old closing records, and dirty timed-out worktree. Do not inspect or use them in this unit; Unit 1 already established their disposition.

### Claims to verify against repository reality

1. Verify that the exact scenario path above and all four files under `plans/work-loop-v2-v0.2/context-engineering/trials/fixtures/ce-9/` exist and remain internally consistent with the sheet's required blindness and scoring rules. If §4, §5, or §6 materially differs from this brief, stop and hand back the mismatch rather than rewriting the instrument.
2. Search only `plans/work-loop-v2-v0.2/context-engineering/trials/` for an existing operator run sheet or equivalent EV-3/CE-9 procedure. The opening claim is that none exists; report the paths and patterns searched. If an equivalent exists, stop rather than create a duplicate.
3. Verify the current checkout identity and status before editing. Preserve the existing `logs/friction-log.md` modification as pre-existing incidental hook output; do not intentionally rewrite or discard it.
4. Verify that the result destination named by the sheet is this exact state file and that the procedure requires no second durable result artifact.

### Required evidence

- Before-change evidence that the bounded trials-tree search found no equivalent run sheet.
- The exact file-presence and consistency findings for the scenario and four fixtures.
- A temporary-copy proof outside the repository: with an unmodified copy of the CE-9 fixture set, the discriminator-presence check exits `0` with exactly one hit in `task-state.md`, while the request-absence check exits `1` with no output.
- A fail-capability proof against a separate temporary mutant copy: place the discriminator between the request markers, run the same request-absence check, and show it exits `0`; confirm the completed run sheet classifies that state as an invalid instrument and failed trial. Never modify the committed fixtures.
- A final changed-path report showing only the new run sheet, this state file, and any preserved/incidental `logs/friction-log.md` change. Report the exact verification commands and exit statuses; do not substitute a grep that merely finds wording supplied by this brief.

The repository allowlist for this unit is exactly:

- `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md`
- `logs/work-loop/eval-v0-3-restart.md`
- `logs/friction-log.md` only for the already-present or hook-incidental write

### Completion and stop conditions

Complete when the one run sheet exists, the baseline and mutant checks demonstrate that its preflight can both pass and fail, and the hand-back contains the required evidence. Do not launch Codex or Claude as trial actors, execute EV-3, record a trial result, inspect or change the abandoned checkout, create a runner/results file, or change any existing scenario, fixture, carrier, dispatcher, Work Loop skill, command, core, or plan.

Stop and hand back if an equivalent sheet already exists, the instrument is materially inconsistent with the brief, blindness cannot be preserved without giving either actor the answer key, the checks cannot demonstrate the mutant failure, or completion would require another durable artifact or a scope/adoption decision. A false premise is a valid result; do not repair or broaden it silently.

## Latest result

Inspected (2026-08-13):

- **Claim (1): HOLDS, with one precision note** — all five files present and read in full: `ce-9-recovery-scenario.md` (180 lines) and, under `trials/fixtures/ce-9/`, `task-state.md` (51), `project-plan.md` (56), `operator-source-note.md` (21), `operator-request.md` (18). § 4's table and its four blindness rules match this brief exactly — control gets the request text only, source-opened gets that plus the three fixture paths, the scenario file goes to neither, no summary or session note to either. § 5's two checks are quoted into the sheet verbatim. **Precision note, not a mismatch:** § 6 defines only the discriminator layer. It does not mention continuation integrity and does not contradict it — it is silent. The brief's item 3 wording ("score against §6": both layers) therefore needed a second citation, and the sheet grounds Layer B in `context-engineering-spec-v0.1.md` § 6 CE-9 *fresh-session recovery* (`:676-678`), whose seven-item list the brief's five items are a subset of. The instrument was not rewritten and no fixture was touched.
- **Claim (2): HOLDS** — bounded search of `plans/work-loop-v2-v0.2/context-engineering/trials/` only. Directory listing returns six files plus `fixtures/` and `regression/`. Filename search `find … -iregex '.*\(run.?sheet\|ev.?3\|procedure\|runbook\|how-to\|operat\).*'` returned three paths, none an EV-3 procedure: the two CE-9 fixtures matched on `operat`, and `regression/r-5/workspace/windlass/handbook/depot-procedure.md` is seeded workspace material for an unrelated regression case. Content search `grep -rniE "run sheet|runsheet|run-sheet|EV-3|runbook"` over the same tree exited `1` with no output. No equivalent sheet exists.
- **Claim (3): HOLDS** — branch `session/2026-08-13-eval-v0-3`, HEAD `72ddf478b3588148a8f76bf2410af3c07933aa05` (Unit 1's commit). Before editing, `git status --short` showed exactly ` M logs/friction-log.md`. Its diff is three lines appended to the hook's `#### Write Activity` block and nothing else; it was preserved, never rewritten or discarded.
- **Claim (4): HOLDS** — `logs/work-loop-v2-eval-results.md` does not exist in this checkout, and `find . -name '*eval-results*' -o -name 'eval-runner*'` over the whole working tree returned nothing, so no competing durable results artifact exists to drift against. `logs/work-loop/eval-v0-3-restart.md` is present and is the file `work-loop-owner.sh check … --depth repo` resolves to this checkout (verdict `PROCEED`). The sheet's § 6 names that file as the whole destination and forbids a results database, runner log, append-only schema or second state file.

**Result:** one run sheet created at `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md` (253 lines). It carries the five required outcomes: an ordered preflight → launch → capture → scoring → stop procedure for one paired trial that it does not execute (§§ 2–7); the instrument's two mechanical checks quoted verbatim with the invalidating mutant stated as a stop rule (§ 2 steps 3–5, § 2a); two-layer scoring — Layer A from instrument § 6, Layer B from spec CE-9 as five fixture-checkable rows — with a PASS / PARTIAL / FAIL / VOID verdict table (§ 5); the result routed solely to this state file and its eventual closing record, with exactly nine recorded items and an explicit ban on any second durable artifact (§ 6); and the lifecycle boundary stated at the top — one trial, authorising no pack, no adoption, no unattended execution and no carrier or dispatcher change. It also carries an answer-key warning, because the sheet states the discriminator and so must go to neither run.

Two judgments made inside the unit, both recorded rather than assumed. **The control runs first** — once the source-opened answer is visible it is hard to read the control fairly, and the order removes that bias. **No `FIXTURE —` notice** — the five instrument files carry it because they are seeded material, but the five non-fixture records already under `trials/` (`carriage-trial-record.md`, `slice-a-evidence.md`, `integrated-proof-record.md`, `entrypoint-classification.md`, `shadow-slice-record.md`) all open with a plain heading, and the sheet is a real procedure, not seeded material.

**Evidence:**

- *Before-change (claim 2):* `grep -rniE "run sheet|runsheet|run-sheet|EV-3|runbook" plans/work-loop-v2-v0.2/context-engineering/trials/` → exit `1`, no output. The same command now returns hits, so the search that found nothing was capable of finding something.
- *Baseline, on an unmodified copy at a temporary path outside the repository:* presence check → **exit `0`**, exactly one hit, `…/baseline/ce-9/task-state.md:37`. Absence check → **exit `1`**, no output.
- *Fail-capability, on a separate mutant copy* with the discriminator inserted immediately before `<<<REQUEST-END>>>`: the same absence check → **exit `0`**, printing the leaked line. The mutant request block was read back and confirmed to hold the discriminator as its third line. The sheet classifies exactly this state in § 2 step 5 — *"the instrument is broken, and any trial that used it has failed"* — and in § 5's VOID row.
- *The sheet's own § 2a self-test was then run verbatim from the repository root*, since a recipe that does not execute is not a recipe: it exited `0` with the leaked line, as documented.
- *Committed fixtures untouched:* `git status --short …/fixtures/ce-9/` returned no output after every proof.
- *Not run, deliberately:* § 2 steps 3–4 against the **committed** fixtures. Those are EV-3's own preflight, and this unit excludes executing EV-3. Their command text is nonetheless verified — § 2a copies from that exact path and runs the identical `awk`/`grep`, and the step-3 path was resolved separately for validity only.
- *Changed paths:* `plans/work-loop-v2-v0.2/context-engineering/trials/ev-3-ce-9-run-sheet.md` (new), `logs/work-loop/eval-v0-3-restart.md`, `logs/friction-log.md` (hook-incidental, preserved). Nothing else. No actor was launched, no trial result was recorded, and the abandoned checkout was not inspected or touched in this unit.

**Deferral noticed, not done:** the brief's "score against §6" wording will mislead the next reader, because § 6 carries only Layer A. The sheet resolves it by citing both sources, but neither `ce-9-recovery-scenario.md` nor the spec was edited — amending the instrument is outside this unit's allowlist and outside the task's scope.

## Blocker
None.

## Next action
Codex: assess the run sheet against Unit 2's five required outcomes and the evidence above, then decide whether to close the unit, correct it once, or open the trial itself as the next unit. If the trial opens, note that it needs the operator to run two fresh Codex threads and that its result lands in this file under § 6's nine items.
