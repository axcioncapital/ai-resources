# Session Plan — 2026-07-13

## Intent

Align the input contracts of `claim-permission-gate` and `country-parity-checker` to `analysis/cluster-memos/{section}/` — the path `/run-cluster` actually writes — filtering on the `-refined` variant suffix and retaining the pre-flight guard (mission `research-workflow-deploy-fitness`, thread 1: the Stage-3 deadlock). Done when the acceptance test passes against real behaviour, thread 1 is ticked citing the test result, and the work is committed (no push).

## Model

`opus` — match (active session is Opus 4.8).

The hard part is *deciding*, not doing: the edit itself is four lines, but the context pack surfaced two unresolved design questions (refined-vs-unrefined filtering; declared path vs. passed argument) that a mechanical tier would have swapped paths straight past.

## Source Material

- `skills/claim-permission-gate/SKILL.md` — edit target (:49 inputs table, :151 pre-flight)
- `skills/country-parity-checker/SKILL.md` — edit target (:39 inputs table, :130 pre-flight)
- `workflows/research-workflow/.claude/commands/run-cluster.md` — the **writer**; :36 defines the correct path and is the authority for it
- `workflows/research-workflow/.claude/commands/run-sufficiency.md` — the **invoker**; :44,:55 pass the memo directory at dispatch (source of design question 2)
- `workflows/research-workflow/reference/file-conventions.md` — canonical naming registry; :19 is the `-refined` variant-suffix rule (source of the resolution to design question 1); :43 fixes the base row
- `workflows/research-workflow/.claude/commands/review-chapter.md` — :26 is the in-repo **precedent** for addressing the refined variant by name inside the shared directory
- `skills/ai-resource-builder/SKILL.md` — :304 routes this change class through the **Consumer-Inventory Gate** at :365–373; mandatory procedure, not optional
- `docs/audit-discipline.md` — structural change classes (`/risk-check` gate)
- `logs/missions/research-workflow-deploy-fitness.md` — the governing plan; thread 1 and the frozen validation contract
- `output/context-packs/skill-20260713-c4f1a/pack.md` — context pack (untracked)

## Findings / Items to Address

1. **The defect (4 lines, complete inventory).** Both skills declare and pre-flight-verify `analysis/{section}/cluster-memos-refined/`, a directory nothing in the workflow creates, and exit with "run `/run-cluster` first" when it is absent. `/run-cluster` writes to `analysis/cluster-memos/{section}/` (`run-cluster.md:36`). Stage 3 therefore deadlocks unconditionally at the first research unit, and re-running as prompted loops forever. — *audit F-1/C-1, `audits/research-workflow-deployment-fitness-2026-07-13.md:41`; mission thread 1.*

2. **Consumer inventory is complete and there is no third consumer.** The invariant-stem sweep (`cluster-memo`, `cluster-memos`, `memo-refined`, `refined`) across commands, skills, hooks, reference docs, settings and manifests found the bad path in exactly those 4 lines. Five commands, one hook regex, two skills and the naming registry are already on the correct path and **must not be touched**. — *context pack § Background sources.*

3. **Design question 1 — the refined-vs-unrefined filter (RESOLVED, was `missing_context`).** `run-cluster.md:36` writes *both* `{section}-cluster-{NN}-memo.md` and `{section}-cluster-{NN}-memo-refined.md` into the same directory. Both skills need the **refined** one and their input tables say "one memo per cluster". A bare path swap would hand them two files per cluster, one unrefined — so the audit's "~4 lines" remedy under-specifies the fix. **Resolution:** the skills address the `-refined` variant by name, per the variant-suffix rule at `file-conventions.md:19` and the existing precedent at `review-chapter.md:26`. Adopts an existing convention; invents no mechanism. — *"smallest general fix wins", mission non-negotiables.*

4. **Design question 2 — declared path vs. passed argument (RESOLVED, was `missing_context`).** `run-sufficiency.md:44,55` already passes the memo directory to both sub-agents at dispatch, while both skills hardcode and pre-flight-verify a declared path; no file says which is authoritative. **Resolution:** align the declaration to the real path and **keep** the pre-flight. *Rejected:* dropping the declared path so the skills consume only the passed argument — that deletes the pre-flight guard, and the guard is correct behaviour ("run `/run-cluster` first"); it was merely aimed at a directory that never existed. Fix the aim, not the guard.

5. **Trap to avoid (would cause a silent regression).** `analysis/{section}/` is the **correct** sentinel directory — `run-sufficiency.md` writes all five `.{phase}.done` sentinels there and both skills reference it correctly in 7 places. Only the `cluster-memos-refined/` sub-path is wrong. A find-and-replace across `analysis/{section}/` would break Pass-3 re-entry silently. — *context pack § Missing context, closing note.*

## Execution Sequence

1. **Verify both ends against live files, not against this plan.** Read the 4 defect lines, `run-cluster.md:36`, `run-sufficiency.md:44,55`, `file-conventions.md:19,43`, `review-chapter.md:26`. — *Verify:* the 4 line numbers and the writer path match what is recorded above; if they do not, the plan's premise is wrong and must be resurfaced (mandate `Stop if`). The mission requires each session to confirm attach points rather than trust the list.

2. **Consumer-Inventory Gate, clause 3.** Re-run the bidirectional reconcile of the grep result against the naming registry (`file-conventions.md`) per `ai-resource-builder/SKILL.md:365–373`. — *Verify:* no consumer appears in the registry that the grep missed, and none in the grep that the registry lacks. This gate exists because this exact under-count has recurred 3+ times in this repo.

3. **`/risk-check` — plan-time gate.** Canonical skill-contract edit → workspace Autonomy rule #9 and the mission's own non-negotiables both fire. — *Verify:* verdict is GO. On RECONSIDER or NO-GO, **stop** (mandate `Stop if`) and surface.

4. **Build the scratch fixture.** A throwaway project tree carrying the real directory layout: `analysis/cluster-memos/{section}/` populated with synthetic `-memo.md` / `-memo-refined.md` pairs for ≥2 clusters, plus the `analysis/{section}/` sentinel directory and whatever other inputs the two skills declare. — *Verify:* the fixture reproduces the layout `run-cluster` actually produces (checked against `run-cluster.md:36` + `file-conventions.md:43`), including the unrefined memos — a fixture holding only refined memos would hide design question 3's whole point.

5. **Baseline test — prove the test can FAIL before trusting it to pass.** Dispatch both skills against the fixture **before** the edit. — *Verify:* both exit at pre-flight with the "run `/run-cluster` first" prompt. A test that passes after a fix but could never have failed before it proves nothing; this step is what makes step 7 evidence rather than ceremony.

6. **Edit the two skills.** `claim-permission-gate/SKILL.md` :49 + :151; `country-parity-checker/SKILL.md` :39 + :130. Path → `analysis/cluster-memos/{section}/`; input description and pre-flight → address the `-refined` variant by name. Leave every `analysis/{section}/` sentinel reference untouched. — *Verify:* re-grep both files for `cluster-memos-refined` → zero hits; re-grep for the sentinel paths → all 7 original references intact.

7. **Acceptance test — thread 1's frozen criterion.** Re-dispatch both skills against the same fixture. — *Verify:* Phase A and Phase C pre-flights both clear, and the skills produce a permission table and a parity table respectively. No "run `/run-cluster` first" exit. Record the actual result (not "looks right") for the mission file.

8. **Tick thread 1 and commit.** Mark thread 1 in `logs/missions/research-workflow-deploy-fitness.md`, citing the step-5 baseline and step-7 result. Commit; **do not push** (workspace rule — push is batched to wrap).

9. **Thread 2 — only if context clearly allows.** Deployment placeholder handling. If context is constrained, defer and log rather than rush (workspace `Context constraint deferral`).

## Scope Alternatives

- **Min:** steps 1–3, 6, 8 — fix the four lines, skip the fixture, verify by re-reading. **Rejected outright:** the mission's non-negotiables forbid closing a thread on a code read ("no fix-and-declare; no 'verified by reading the code'"), and thread 1's acceptance test is frozen in the validation contract.
- **Recommended:** steps 1–8 — includes the failing baseline (step 5), which is what converts the acceptance test from ceremony into evidence.
- **Max:** steps 1–9 — adds thread 2 (deployment placeholder handling) if context allows after thread 1 closes. Thread 2 is the second demonstrated blocker, so it is the correct next item, but it is a distinct fix with its own acceptance test and must not be half-done.

## Autonomy Posture

**Gated** — one hard stop, one deliberate checkpoint.

**Stop points:**
- **`/risk-check` verdict (step 3).** RECONSIDER or NO-GO halts the session per the mandate's `Stop if`.
- **Premise failure (step 1).** If the live files contradict the recorded attach points or the writer path, stop and resurface rather than adapting the fix silently — the mission file governs, and a wrong premise there is a finding in its own right, not an obstacle to route around.

Everything else runs to completion under full autonomy.

## Risk

Run `/risk-check` after this plan is approved (plan-time gate). **This is a canonical skill-contract edit** — a structural change class under `docs/audit-discipline.md`, and independently required by the mission's own non-negotiables ("`/risk-check` gates apply to canonical command / hook / skill-contract edits").

**End-time gate:** skipped by design, with reason. The workspace's `end-time /risk-check skip rule` applies — plan-time risk-check will have covered this exact diff with mitigations applied, the change is bounded to 4 lines in 2 files with a complete consumer inventory, and the empirical acceptance test (steps 5 + 7) is a stronger end-state check than a second review pass. Documented here rather than silently dropped.

**No separate `/qc-pass` subagent.** Per workspace `Subagent Proportionality` § "Do not stack gates": this change is cleared by `/risk-check` plus a failing-then-passing empirical test against real skill dispatch. A QC reader would be re-deriving what the test demonstrates. The main session performs the inline re-grep verification named in steps 6–7.

**Blast radius note for the risk-checker:** these two skills are canonical and symlinked into deployed projects, but the workflow is **not yet deployed anywhere** — Sector Intelligence is the first pilot and deployment is gated behind this very mission. So the live blast radius is zero today and the change is strictly a repair of an unconditionally-broken path. The real risk is not breaking a working system; it is shipping an *incomplete* fix (design question 3) that appears to work on a fixture holding only refined memos.

**Environment-fit:** not applicable — the work product is skill instruction text, not launch/runtime-gated tooling.
