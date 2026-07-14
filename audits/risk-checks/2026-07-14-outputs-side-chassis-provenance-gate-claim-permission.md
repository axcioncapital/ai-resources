# Risk Check — 2026-07-14

## Change

Outputs-side chassis-provenance gate for the research workflow's claim-permission subsystem. Five canonical files changed on branch `session/2026-07-13-research-workflow` (uncommitted, in the worktree at /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow):

1. `skills/claim-permission-gate/SKILL.md` — Output schema now stamps `chassis_version:` into permission-table frontmatter.
2. `skills/cluster-memo-refiner/SKILL.md` — Check 9 sub-check 3 emits the same stamp (it writes the same path).
3. `skills/section-directive-drafter/SKILL.md` — NEW hard-exit chassis-provenance gate: refuses any permission table with an absent or pre-2026-07-14 `chassis_version`, PLUS a re-stamp invariant (`generated_at` must be >= `chassis_version`). Routes deliberate overrides to the existing signed OPERATOR-OVERRIDE path.
4. `workflows/research-workflow/.claude/commands/run-synthesis.md` — the same hard-exit gate before passing tables to `cluster-synthesis-drafter`.
5. `workflows/research-workflow/reference/quality-standards.md` — states the rule, the verified distribution topology, the honest limits of the gate, and updates the lockstep contract.

The chassis version marker was NOT bumped (no class-condition / adjudication-order / ceiling change).

BLAST-RADIUS CONTEXT (verified this session, not assumed):
- The four skills are SYMLINKED into two LIVE projects (`projects/research-pe-regime-shift-advisory-gap`, `projects/positioning-research`) — skill edits take effect there the moment this branch merges to `main`.
- The chassis and the workflow commands are REAL LOCAL COPIES in those projects — edits (4) and (5) do NOT reach them on merge.
- Both live projects completed section 1.1: unversioned permission tables (generated 2026-06-03 / 2026-06-10), already-written section directives on disk, and `.claim-permission-gate.done` sentinels that prevent re-adjudication.
- CONSEQUENCE TO SCORE: on merge, `section-directive-drafter` will HARD-EXIT in both live projects if re-run on section 1.1.

EVIDENCE THE CHANGE RESTS ON (by execution, not reading):
- Blind re-adjudication of a REAL stale table (1.1-cluster-03) under the current chassis moved 2 of 6 claims from PROXY-SUPPORTED to ILLUSTRATIVE-ONLY.
- A blind `section-directive-drafter` run on the stale table confirmed it emits "hedged framing required" for both — licensing two market-pattern generalizations the current rules forbid outright.
- The gate was then tested red/green/adversarial: unversioned -> EXIT; forged stamp (version pasted, body untouched) -> EXIT; clean -> PROCEED.

KNOWN + DOCUMENTED LIMIT: `chassis_version` and `generated_at` are both self-asserted frontmatter fields, so a determined operator can pass the gate with two edits. Deliberately NOT hardened with a content hash — these are model-executed skills that cannot compute a trustworthy digest without new shell machinery, and the threat model is operator error, not an adversary. Operators are routed to the existing signed OPERATOR-OVERRIDE path instead.

DELIBERATELY NOT GATED: `country-parity-checker` — it reads the permission tables but its own rules forbid it from judging whether a claim is supported; its country-parity output does not change when a class changes.

SPECIFIC QUESTIONS I WANT SCORED:
- Is the hard-exit-into-two-live-projects consequence acceptable, or does it need a migration step before merge?
- Did I miss any consumer of the permission tables? (I found section-directive-drafter and run-synthesis by grep after initially missing both. Assume my inventory is still incomplete and check.)
- Is the decision NOT to gate country-parity-checker correct?
- Is the decision NOT to build a content hash correct, or is it under-hardening?

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/claim-permission-gate/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/section-directive-drafter/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/country-parity-checker/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/.claude/commands/run-synthesis.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/.claude/commands/run-sufficiency.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/reference/quality-standards.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The gate is well-evidenced, correctly scoped, and principle-aligned — but the consumer inventory is still incomplete (`/run-sufficiency` Phases D+F read class verdicts and are ungated), and the hard-exit it lands in two live projects prints a remediation path that dead-ends, so a migration step and a refusal-message fix are required before merge.

## Consumer Inventory

**Search space (stated):** the change worktree `ai-resources-research-workflow/`, the canonical checkout `ai-resources/` (same repo, `main`), and the workspace root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/` including `projects/`. Search terms: `analysis/claim-permission`, `permission-table`, `permission table`, `chassis_version`, `chassis-version`, `claim-permission-gate`, `section-directive-drafter`, `cluster-memo-refiner`, `country-parity-checker`, `run-synthesis`, `generated_at`, `gate-clearance`, `OPERATOR-OVERRIDE`.

**Grep result (canonical + worktree, `analysis/claim-permission`):** 7 files each, identical set — the 4 skills, `/run-sufficiency`, `/run-synthesis`, and `reference/stage-instructions.md`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `skills/claim-permission-gate/SKILL.md` | co-edits (producer — writes the stamp) | yes — in change set |
| `skills/cluster-memo-refiner/SKILL.md` | co-edits (producer — writes the stamp, same path) | yes — in change set |
| `skills/section-directive-drafter/SKILL.md` | parses (reads `chassis_version` / `generated_at`; hard-exits) | yes — in change set |
| `workflows/research-workflow/.claude/commands/run-synthesis.md` | parses (same gate before `cluster-synthesis-drafter`) | yes — in change set |
| `workflows/research-workflow/reference/quality-standards.md` | co-edits (authority — lockstep contract + version marker) | yes — in change set |
| `workflows/research-workflow/.claude/commands/run-sufficiency.md` | **parses** — Phase F (line 87) "Computes NOT-SUPPORTED ratios per cluster and per section **from the Phase A permission tables**"; Phase D (line 67) "applies the project-defined stop conditions to each cluster's evidence + **permission verdicts**" | **yes — NOT in change set (MISS)** |
| `workflows/research-workflow/reference/stage-instructions.md` | documents — Steps 3.4b / 3.5 / 3.7 all name the permission tables as required inputs | **yes (doc) — NOT in change set (MISS)** |
| `skills/country-parity-checker/SKILL.md` | invokes/reads (required input, line 40) but does **not** read the Assigned-class column | no — correctly not gated (see D3) |
| `skills/gap-assessment-gate/SKILL.md` | documented-but-unwired — `stage-instructions.md` Step 3.4b says it takes "the Phase A permission tables as inputs", but `grep -i "permission" skills/gap-assessment-gate/SKILL.md` returns **0 hits** | no — latent consumer, not wired today |
| `projects/positioning-research/reference/quality-standards.md` | imports (real local copy of the chassis; **no chassis-version marker present** — grep, 0 hits) | **yes — back-port required** |
| `projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md` | imports (real local copy; **no chassis-version marker present** — grep, 0 hits) | **yes — back-port required** |
| `projects/positioning-research/.claude/commands/run-synthesis.md` | parses — real copy dated Jun 9, `grep -c chassis` = **0** (no gate) | **yes — if Pass-4 coverage is wanted there** |
| `projects/positioning-research/.claude/commands/run-sufficiency.md` | parses — real copy dated Jun 9, no gate | yes — same |
| `projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-synthesis.md` | parses — real copy dated Jun 1, `grep -c chassis` = **0** (no gate) | **yes — if Pass-4 coverage is wanted there** |
| `projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-sufficiency.md` | parses — real copy, no gate | yes — same |
| `projects/positioning-research/analysis/claim-permission/1.1/*-permission-table.md` (4 files, confirmed on disk) | artifacts the gate will refuse | n/a — must be re-adjudicated |
| `projects/*/analysis/1.1/.claim-permission-gate.done` (both projects) | blocks re-adjudication (Phase-A skip-on-sentinel) | yes — must be deleted to re-run |

**Total: 17 distinct consumers, 11 must-change. 6 of the 11 must-change consumers are NOT in the change set.**

Two of those six are genuine inventory misses (`/run-sufficiency`, `stage-instructions.md`); four are the live-project copies the change description correctly identified as out of reach on merge but did not schedule a migration for.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. `git status --short` on the branch shows exactly 5 changed files plus `logs/session-notes.md` — no `CLAUDE.md`, no `settings.json`, no hook, no `@import`.
- All three SKILL.md files load only when the pipeline invokes them; `quality-standards.md` is explicitly load-on-demand per the workflow CLAUDE.md ("Only load these when actively working on the relevant stage or task").
- `section-directive-drafter`'s `description:` frontmatter (lines 3–16) is **unchanged** — the gate text sits in the body, so the skill's auto-load pattern-match surface does not widen.
- Ongoing cost is pay-as-used: roughly +700 tokens on `section-directive-drafter` (lines 60–72), +450 on `run-synthesis` (lines 30–39), +1,400 on `quality-standards.md` § Provenance (lines 325–360). The largest recurring hit is `quality-standards.md`, read at every Phase-A pre-flight — a per-section-per-run cost inside an already-Opus-tier pipeline, not a per-session tax.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is in the change set (`git status --short`: 5 files, none a `settings.json`).
- No new tool family. `claim-permission-gate` line 244 and `country-parity-checker` line 172 both state "Read + Write only. No shell, no network" — unchanged by this change.
- The change **actively declines** to widen the surface: `quality-standards.md` line 343 rejects the content hash partly because "an LLM cannot compute a trustworthy digest **without new shell machinery**." Choosing the date invariant over a hash avoids introducing shell/Bash into four model-executed skills. This is a permissions-surface *saving*, not a cost.

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Step 1.5 inventory: **17 consumers, 11 must-change, 6 of the 11 not in the change set.**

- **MISS 1 — `/run-sufficiency` Phases D and F are ungated consumers of the class verdicts.** Line 87: Phase F "Computes NOT-SUPPORTED ratios per cluster and per section **from the Phase A permission tables**" and writes the gate-clearance file — "the load-bearing artifact that Pass 4 commands read at their Step 0." Line 67: Phase D applies stop conditions to "each cluster's evidence + **permission verdicts**." Neither carries the chassis-provenance gate, and `/run-sufficiency` is **absent from the lockstep contract table** at `quality-standards.md` lines 312–319. The re-entry rule makes this reachable, not theoretical: line 49, "Skip Phase A if `.claim-permission-gate.done` is present" — and that sentinel **exists on disk in both live projects** (`projects/positioning-research/analysis/1.1/.claim-permission-gate.done`, confirmed). So a re-invocation of `/run-sufficiency 1.1` skips Phase A and runs D+F against the stale tables with no gate anywhere.
  - *Severity is mitigated by direction of error:* the version-history row (line 370) records that the 2026-07-14 re-cut **tightened** `NOT-SUPPORTED` to "zero roles only," so a stale table's NOT-SUPPORTED count is systematically **higher** than a re-adjudicated one. Phase F therefore errs toward `BLOCKED` — fail-safe. It is still an ungated consumer of verdicts the change's own thesis says cannot be trusted, and it belongs in the contract.
- **MISS 2 — `reference/stage-instructions.md` is unchanged.** It names the permission tables as required inputs at Step 3.4b (`gap-assessment-gate`), Step 3.5 (`section-directive-drafter`, line 127) and Step 3.7 (`cluster-synthesis-drafter`, line 132). None of the three mentions the new gate. Documentation-only, but it is the file an operator reads to understand the pipeline.
- **LATENT — `gap-assessment-gate`.** `stage-instructions.md` line 101 says it runs "with scarcity register and the Phase A permission tables as inputs," but `grep -i "permission" skills/gap-assessment-gate/SKILL.md` returns **0 hits**. The doc claims a consumer the skill does not implement. Pre-existing mismatch, not caused by this change — but if that consumer is ever wired, it needs the gate.
- **The gate does not reach Pass 4 in the live projects at all.** `projects/*/.claude/commands/run-synthesis.md` are real copies (dated Jun 1 and Jun 9) and `grep -c chassis` returns **0** on both. So post-merge, the live projects get exactly one control: `section-directive-drafter` hard-exiting at Step 3.5. The `/run-synthesis` gate (edit 4) is inert there. The change description states this ("edits (4) and (5) do NOT reach them"), and `quality-standards.md` line 358 states it as a principle ("a gate on the symlinked consumer, alone, is never enough") — so it is **disclosed, not hidden**. But disclosure is not coverage.
- **A caller requires modification to keep working** — the rubric's explicit High trigger. Both live projects hold section-1.1 tables the gate will refuse, and neither project's `reference/quality-standards.md` carries a chassis-version marker at all (grep, 0 hits in both), so they cannot pass the *existing* Phase-A gate either.
- **`country-parity-checker` correctly excluded — verified, not accepted on assertion.** Its Behavior step 3 (lines 136–144) computes shares "from the source list and country annotations in each claim's supporting evidence" and applies threshold logic — it never reads the Assigned-class column. Its When-Not-to-Use line 31 forbids it from judging sufficiency. A class change cannot move its verdict. **The operator's call is correct.**

### Dimension 4: Reversibility
**Risk:** Medium

- The canonical change reverts cleanly: `git status --short` shows five ` M` entries — modifications only, no new files, no deletions, no symlinks. `git revert` on the branch fully restores prior state in this repo.
- **But operator action taken in response to the gate is outside git's reach.** The refusal message (`section-directive-drafter` line 60) instructs: "delete `analysis/{section}/.claim-permission-gate.done` to allow the re-run." That sentinel lives in `projects/`, not in this repo. Once deleted, a revert of this branch does not restore it, and the project is left with Phase A un-skipped.
- The correct migration (back-porting the chassis into both projects' `reference/quality-standards.md`) is a change in two *other* trees that this branch's revert does not undo — a second cleanup step.
- No push, no external write, no automation that fires between landing and revert. Nothing has propagated beyond the local repos.
- Net: revert works, but needs one-to-two manual cleanup steps in the live projects. Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **The remediation path dead-ends — the strongest finding here, and it is not documented at the change site.** `section-directive-drafter` line 60 tells the operator to "Re-run `claim-permission-gate` for this section against the current chassis (delete `analysis/{section}/.claim-permission-gate.done` to allow the re-run)." But `claim-permission-gate`'s own pre-flight (line 152) hard-exits when the project chassis marker is absent or older than 2026-07-14 — and **neither live project's `reference/quality-standards.md` contains a chassis-version marker** (grep, 0 hits in both). So the operator follows the instruction, deletes the sentinel, re-runs, and hits a *second* hard exit. Recoverable — the second message (lines 203–210) does give full back-port instructions — but the first message walks them into a wall it does not warn about, after mutating state (the deleted sentinel) that the failed re-run cannot restore.
- **The required version is a hardcoded literal in four places, not read from the marker.** `2026-07-14` is pinned in `claim-permission-gate` line 152, `section-directive-drafter` line 60, `run-synthesis` line 30, and named in the lockstep contract at `quality-standards` lines 316–317. The check is a **floor** ("2026-07-14 or later"), so after the *next* chassis bump, tables stamped `2026-07-14` will still pass every gate even though the rules moved — the gate silently under-enforces until all four literals are hand-bumped. The lockstep contract explicitly names this obligation (line 316: "any edit that bumps the version marker"), so it is disclosed — but a floor pinned to a literal in four files is exactly the divergence class this whole change exists to prevent, now re-created one level up.
- **New contract, documented at the change site — good.** The `chassis_version` + `generated_at` + `generated_at >= chassis_version` contract is stated in `quality-standards.md` § Provenance (lines 325–345), in both producers, and in both consumers. This is the *right* way to introduce a contract, and it is the reason this dimension is Medium rather than High.
- **No functional overlap.** The gate does not duplicate the existing input-side chassis-version gate — it covers the strictly disjoint case (artifacts already on disk), as line 327 states plainly.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present).

- **OP-3 (loud failure over silent continuation) — strongly served.** The change replaces a silent, demonstrated over-claim with a hard exit. `quality-standards.md` line 347: "The failure was silent in every stage and detectable in none." This is the principle's paradigm case.
- **OP-5 (advisory vs enforcement) — aligned, because the upgrade is explicit.** A hard exit *is* enforcement, and OP-5 requires that be "an explicit per-component decision." It is: `section-directive-drafter` line 72 and `run-synthesis` line 39 both carry a titled "Why this is a hard exit and not a warning" rationale, and it matches the already-ratified pattern of the input-side chassis gate. Not a silent upgrade.
- **OP-9 / DR-7 / AP-7 (speculative abstraction) — actively served, and this settles Q4.** The gate is built for **confirmed, currently-existing** consumers (two gated, two live projects with real stale tables on disk), on evidence produced by execution. And the decision *not* to build the content hash is a textbook DR-7 call in its own right — `quality-standards.md` line 343: "Revisit only if a forged stamp is ever observed in practice — **not in anticipation of one**." Building the hash would be the AP-7 violation. **Not hardening is the principle-compliant choice, not merely the cheap one.**
- **OP-12 (closure before detection) — the one real tension, and the reason this scores Medium.** OP-12: "new detection that does not close findings counts *against* a candidate... a detection capability ships behind a working closure channel, never ahead of it." This change ships a detector that will fire in two live projects, and its closure channel — the remediation printed in the refusal — **does not work as written** (see D5: it dead-ends at the Phase-A chassis gate). The closure channel exists (back-port, then re-run) but is neither wired into the message nor executed as part of this change. Tension, not violation: closable by the mitigations below.
- **DR-8 (`/risk-check` on gated structural change) — satisfied** by this pass.
- **DR-1 / DR-3 (placement) — aligned.** All five edits land in canonical `ai-resources/` at the correct tier (skills in `skills/`, command in the workflow template's `.claude/commands/`, chassis in the workflow's `reference/`).
- **Complexity budget (`docs/ai-resource-creation.md` rule #7) — passes.** No new command, agent, skill, or always-loaded doc is created; all five files already exist. Prong (b) is satisfied independently: the change cites written, executed evidence of the exact failure mode it addresses (2 of 6 claims reclassified; blind drafter run confirmed the over-claim).
- **OP-11 — no principle is being revised**, so no loud-revision obligation is triggered.

## Mitigations

- **Dimension 3 (High) — close the two inventory misses before merge.** (a) Add the chassis-provenance gate to `/run-sufficiency` Phase F (and Phase D), or, if you judge the fail-safe direction acceptable, add `/run-sufficiency` as a row in the lockstep contract table (`quality-standards.md` lines 312–319) with an explicit note stating *why* it is not gated — matching the treatment `country-parity-checker` already gets at line 321. Silence in the contract is what let `/run-synthesis` get missed the first time. (b) Update `reference/stage-instructions.md` Steps 3.5 and 3.7 to name the gate.
- **Dimension 3 (High) — schedule the migration, do not merge without it.** The hard-exit into the live projects is **correct behavior and should ship**, but it must not land ahead of its remedy. Before or at merge: back-port § Claim-Permission Classes and its subsections into `projects/positioning-research/reference/quality-standards.md` and `projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md` (neither currently has *any* chassis-version marker), then delete the `.claim-permission-gate.done` sentinels and re-run `/run-sufficiency 1.1` in each. Do these in that order — the reverse order strands both projects.
- **Dimension 5 / OP-12 — fix the refusal message so the closure channel actually closes.** `section-directive-drafter` line 60 and `run-synthesis` line 31 both tell the operator to delete the sentinel and re-run; in both live projects that re-run hard-exits again at `claim-permission-gate`'s own chassis gate. Add a step 0 to both messages: *"If your project's `reference/quality-standards.md` has no chassis-version marker, back-port the chassis first — `claim-permission-gate` will refuse the re-run otherwise."*
- **Dimension 5 — record the four-literal pin as a bump obligation.** The `2026-07-14` floor is hardcoded in four files. Add one line to the lockstep contract stating that a version bump requires updating the pinned floor in `claim-permission-gate`, `section-directive-drafter`, and `/run-synthesis` — otherwise the *next* chassis change reintroduces exactly the silent-divergence failure this change closes.
- **Dimension 4 (Medium) — note the sentinel deletion is outside git.** Record in the branch's commit message or session notes that any `.claim-permission-gate.done` deleted in a live project is not restored by reverting this branch.

## Answers to the four scored questions

1. **Hard-exit into two live projects — acceptable, and it needs a migration step before merge.** The exit is the right behavior (it is the only control that actually reaches those projects). But the remediation it prints dead-ends at the Phase-A chassis gate, and neither project has a chassis-version marker at all. Back-port first, then merge.
2. **Yes — the inventory was still incomplete.** `/run-sufficiency` Phases D and F read the permission verdicts (line 67, line 87) and are ungated and absent from the lockstep contract. `reference/stage-instructions.md` documents the tables as inputs at three steps and is unchanged. `gap-assessment-gate` is a documented-but-unwired latent consumer (0 permission hits in its SKILL.md).
3. **Yes — not gating `country-parity-checker` is correct.** Verified against its Behavior step 3 and When-Not-to-Use line 31: it computes shares from source/country annotations, never from the Assigned-class column. A class change cannot move its verdict.
4. **Yes — not building the content hash is correct, and it is not under-hardening.** It is the DR-7 / AP-7-compliant call: build for the observed threat (neglect), not the unobserved one (forgery). The documented limit at line 345 — that the green fixture is byte-identical below the frontmatter to the stale one — is honestly stated and does not change the answer.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
