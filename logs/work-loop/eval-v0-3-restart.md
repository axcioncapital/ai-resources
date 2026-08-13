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

Final tightly-bounded fix — correction finding 2 only. Nothing else in the sheet was reviewed or changed.

**Inspected (2026-08-13), before any edit:**

- **Claim (1): HOLDS** — the sheet overclaims access prevention. Searched the sheet for `not reachable|reachable from`; found one hit at `:121`, *"so the durable Harbourview sources are not reachable from where it is working"*, with nothing in the procedure enforcing it.
- **Claim (2): HOLDS, and is worse than the brief states** — searched the sheet for `sandbox|contain|not a boundary|location boundary|detection, not`; the only hit was `:204` *"cannot contain the discriminator"*, unrelated. **The non-sandbox disclosure is not in the sheet at all** — it is in this state file's previous result. So the sheet made the strong claim with no caveat beside it. This does not change the required work: the instruction was to enforce the claim or stop, and enforcement was the answer either way.
- **Claim (3): FALSE as the brief framed the risk, and materially so** — the finding assumed the reachable sources were "elsewhere on a filesystem it can read" in the abstract. `mdfind "Harbourview"` returned **121 files**, of which **25 sit outside the workspace root**, including a complete `fixtures/ce-9/` set under `/Users/patrik.lindeberg/Claude Code/wl2-b8-verification-94807fd/`. A further **121 files under `~/.codex`** — past Codex session transcripts — also carry Harbourview. Denying only the checkout, or only the workspace, would have left the control with the answer key. This widened the fix; it did not invalidate it, so the unit continued rather than handing back.

**Result: finding 2 is closed by enforcement, not by disclosure. `~/.codex` is a mid-unit deferral resolved inside scope — see below.**

Run A's launch now imposes a `sandbox-exec` read boundary that denies **every** read under `$HOME`, allowing back only the control directory, the launcher and the Codex program files. It is paired with an isolated `CODEX_HOME` under the control directory, because `~/.codex` holds prior Harbourview transcripts. § 3a gained four operator checks that run **before** launch — a profile-loaded check, a machine-wide denial check, a by-exact-path check on the three named sources, and a boundary-removed control — and § 7 gained the stop rule that a failed boundary check means Run A is not launched and no trial is recorded. § 3 rule 5 no longer claims unreachability from working directory; § 1 states the profile and why `$HOME` is the right scope.

**Evidence — every command below was extracted from the sheet's own fenced blocks and executed as written, not retyped:**

- *The procedure runs as stated, from a clean `~/ce-9-control`:* check 0 → **`exit=0`**; check 1 → **`checked=235 denied=235 other=0`**; check 2 → **`exit=1`** for `project-plan.md`, `task-state.md`, `operator-source-note.md`; check 3 → **`exit=0`**; the directory afterwards lists **`.codex-home` and nothing else**.
- *Codex starts inside the boundary:* the sheet's own launch line returned **`codex-cli 0.147.0`, `codex_exit=0`**.
- *The denial check can fail — three independent ways, each run:* with the deny rule replaced by `(version 1)(allow default)`, the identical check 1 returned **`denied=0 other=0`** against the same 235 files (was 235/235). With `CE9_PROFILE` empty, check 0 returned **`exit=65`** and check 1 returned **`denied=0 other=235`**. Before the boundary existed, an unsandboxed read of `task-state.md` returned **`exit=0`**.
- *That fail-capability work found a real defect in my own first draft and it was fixed:* the original check 1 counted any non-zero exit as "denied", so an empty profile scored a **false 235/235 pass**. Check 0 and the `other=` counter exist because of that run. The check now separates exit `1` (denied) from anything else (unproved).
- *Nothing accepted was broken:* `VOID` → **0 occurrences**; *"Record exactly these nine things"* still carries **9** numbered items; **3** verdict rows (PASS/PARTIAL/FAIL); **15** headings; the answer-key warning, the lifecycle boundary and `logs/work-loop/eval-v0-3-restart.md` as the whole destination all unchanged.
- *Run A's prompt is byte-identical:* extracted with the instrument's own `awk` marker filter from `fixtures/ce-9/operator-request.md` and `diff`ed against the sheet's Run A block → **exit `0`**. The same check against a mutant (`an hour` → `two hours`) → **exit `1`**, so identity means identity. Run B untouched: first two lines identical to the fixture request, block still **6 lines**, its three paths `diff` → **MATCH**.
- *§ 2 and § 2a were not touched:* § 2 spans lines 69–130 in the new file; no `git diff -U0` hunk starts inside that range, so the accepted preflight and its mutant self-test stand unchanged.
- *Changed paths:* the run sheet, this state file, and the hook-incidental `logs/friction-log.md`. Nothing else. No actor launched as a trial, no EV-3 run, no trial result recorded, and the abandoned checkout was neither inspected nor touched.

**Limits stated rather than papered over.**

1. `sandbox-exec` is deprecated by Apple. It is present and working on this machine (verified above), but it is not a guaranteed-future interface.
2. The profile denies `$HOME`. A Harbourview copy **outside** `$HOME` would not be denied by the profile itself — check 1 is what covers that case: such a copy would come back readable and the operator stops. Prevention is scoped to `$HOME`; detection is machine-wide.
3. Check 1 enumerates via `mdfind`, which depends on Spotlight indexing. A copy on an unindexed volume might not be listed. Check 2 covers the three named sources by exact path regardless of indexing.
4. Only `codex --version` was run inside the boundary — no interactive session, since launching a trial actor is outside this unit. Nested seatbelt was separately tested and **fails** (`sandbox_apply: Operation not permitted`), so Codex's own sandbox for model-generated shell commands may refuse inside the outer boundary. § 3a now states that a refused shell command is the boundary working rather than a fault, because Run A needs to read nothing.

**Mid-unit deferral, recorded and resolved inside scope:** the `~/.codex` transcript route was not in the frozen finding. It is the same defect — a reachable Harbourview source — so it was closed by the same boundary rather than deferred; leaving it would have shipped a boundary with a hole in it.

**Candidate deferral carried forward, still not implemented:** the previous round's note that `~/ce-9-control` is a fixed name with no removal step after a trial. Check 0 now cleans up its own probe file, and § 1's listing rule catches a stale directory, but nothing tells the operator to delete the directory when the trial ends.

## Blocker
None.

## Next action
Closure check on the final tightly-bounded fix — finding 2 and nothing else.

Two questions only: is the access-prevention fix real, and did it break an existing Unit 2 requirement?

For the first: the sheet no longer claims unreachability from working directory. Run A launches under a `sandbox-exec` profile that denies every read under `$HOME`, with an isolated `CODEX_HOME` because `~/.codex` held prior Harbourview transcripts. Four operator checks run before launch, and § 7 makes a failed check a stop with no trial recorded. The evidence in `## Latest result` was produced by extracting the sheet's own fenced blocks and executing them, and it fails when it should: an open profile scores 0/235 denied where the boundary scores 235/235, and an empty profile is caught by check 0.

For the second: `VOID` absent, nine numbered record items, three verdict rows, 15 headings, Run A's prompt byte-identical to the fixture request, Run B's block unchanged at six lines with matching paths, and no diff hunk inside § 2 or § 2a.

Four limits are stated in the result rather than claimed away — `sandbox-exec` deprecation, prevention scoped to `$HOME` with machine-wide detection, `mdfind` indexing, and no interactive Codex session run inside the boundary. Assess whether those are acceptable as written or whether any is a blocker.

One candidate deferral carries forward, still not implemented: no step tells the operator to delete `~/ce-9-control` when a trial ends.
