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

Correction round on the three frozen findings. Each was reproduced by inspection first; all three are resolved.

**Reproduced (2026-08-13), before any edit:**

- **Finding 1 reproduces** — `grep -n "VOID" <sheet>` returned two lines: `205` (the fourth verdict row) and `237` (the verdict item in the nine-item record).
- **Finding 2 reproduces** — `:29` read *"Everything runs from the repository root"*, which applied to Run A too. Nothing in §§ 3, 5 or 7 prevented Run A from searching the checkout, and `:232` captured only *"what it received"*, never where it ran or what it reached. The withheld-paths rule was the only control, and a thread started inside the checkout can find the fixtures by searching for "Harbourview" without being told where they are.
- **Finding 3 reproduces** — Run B's fenced block carried the line `The Harbourview material is in:` between the request and the three paths.

**Result: all three corrected; no Unit 2 requirement broke.**

1. **The fourth verdict is gone.** § 5 now opens *"There are three verdicts and no fourth"* and the table is PASS / PARTIAL / FAIL. The two states that were VOID are folded into FAIL as named causes — *invalid instrument* (preflight step 4 exited `0`) and *blindness breach* (a thread was not fresh, received more than § 3 allows, or Run A reached the checkout or a Harbourview source). The instrument's discard rule is preserved and separated from the verdict in its own paragraph: the contaminated run's **output** is not scored on its merits, and the **paired trial** is still recorded FAIL with the precise reason. § 6 item 8 now reads PASS / PARTIAL / FAIL, item 9 requires naming which check or rule broke and that the affected output was discarded, and § 7's stop list carries the same wording.
2. **Run A is now blind by where it runs, not by promise.** § 1 requires an empty directory outside the repository (`~/ce-9-control`, created with `mkdir -p … && ls -A …`, expecting no output) and states which of the three things runs where — § 2's commands and Run B from the repository root, Run A only from the empty directory. § 3's rules go from four to five; rule 5 states the isolation and why withholding paths alone is insufficient. § 3a opens with `cd ~/ce-9-control`, then requires reading back that Run A worked there, opened/listed/searched no file under the checkout, and reached no Harbourview source by any other route — and classifies any such access as **FAIL, blindness breach**, output discarded, no re-run for a cleaner answer. § 4 captures the directory and that confirmation for both runs; § 6 item 3 records it. **Run A's prompt is byte-identical to before** — no hint added, no summary, freshness untouched.
3. **Run B's input is exactly the authorised input.** The introducing line is removed. Its block is now six lines: the two request lines, one blank, and the three fixture paths.

**Evidence:**

- *Findings resolved:* `grep -n "VOID" <sheet>` → **exit `1`**, no output (was two hits). `grep -n "The Harbourview material is in" <sheet>` → **exit `1`**, no output. `grep -n -E "ce-9-control|isolation|blindness breach"` → 14 hits across §§ 1, 3, 3a, 4, 5, 6, 7.
- *Prompt fidelity, the check that could have caught a silent break:* extracted the authoritative request with the instrument's own `awk` marker filter from `fixtures/ce-9/operator-request.md`, and extracted both fenced prompt blocks from the sheet with `awk`. `diff` of the fixture request against **Run A's block → identical, exit `0`**. `diff` against **Run B's first two lines → identical, exit `0`**. *Fail-capability of that same check:* re-run against a mutant copy with `an hour` changed to `two hours`, `diff` reported the difference — so an identical result means identity, not a check that always passes.
- *Run B's path list:* lines 4–6 of its block sorted and `diff`ed against the instrument's three source paths → **MATCH, no fourth path**; each of the three tested with `test -f` → **EXISTS**.
- *Nothing else regressed:* all 15 headings still present; `Record exactly these nine things` still counts **9** numbered items; § 6 still names `logs/work-loop/eval-v0-3-restart.md` as the whole destination and still bans a results database, runner log, append-only schema and second state file; the answer-key warning and the lifecycle boundary are unchanged. `git diff -U0` hunk ranges show the edit touched §§ 1, 3, 3a, 3b, 4, 5, 6 and 7 — **§ 2 and § 2a were not touched**, so the preflight and the mutant self-test proved in Unit 2 stand unchanged.
- *Changed paths:* the run sheet, this state file, and the hook-incidental `logs/friction-log.md`. Nothing else. No actor launched, no EV-3 run, no trial result recorded, and the abandoned checkout was neither inspected nor touched.

**Residual named rather than overclaimed (part of finding 2, disclosed).** Launching Run A from an empty directory outside the repository removes its default reach — no working-directory search can find Harbourview — but it is a location boundary, not a sandbox, and this sheet cannot enforce one. The remainder of finding 2 is closed by detection rather than prevention: § 3a requires the isolation to be confirmed by reading back what Run A did, and any access is FAIL. That pairing is what the finding asked for; the limit is stated so no later reader mistakes location isolation for containment.

**Candidate deferral noticed during the correction, not implemented:** `~/ce-9-control` is a fixed name in the operator's home directory. If a stale copy from an earlier trial is still there, the `ls -A` check catches it, but the sheet does not say to remove it afterwards. Too small to justify reopening the frozen scope.

## Blocker
None.

## Next action
Codex: run the closure check on the frozen findings only — are findings 1, 2 and 3 resolved, and did the correction break an existing Unit 2 requirement? The residual named under finding 2 (location isolation is not a sandbox; the remainder is closed by detection and a FAIL rule) and the one candidate deferral are stated in `## Latest result` for that judgment.
