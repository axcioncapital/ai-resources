# Risk Check — 2026-07-13

## Change

Canonical skill-contract edit (mission research-workflow-deploy-fitness, thread 1 — Stage-3 deadlock). Change 4 lines across 2 canonical skills, plus filter wording.

WHAT IS BROKEN: skills/claim-permission-gate/SKILL.md:49 (Inputs table) and :151 (pre-flight), and skills/country-parity-checker/SKILL.md:39 (Inputs table) and :130 (pre-flight), all declare and pre-flight-verify a required input directory `analysis/{section}/cluster-memos-refined/`. Nothing in the workflow creates that directory. The writer, workflows/research-workflow/.claude/commands/run-cluster.md:36, writes to `analysis/cluster-memos/{section}/`. Both skills therefore exit at pre-flight with "run /run-cluster first" even after /run-cluster has completed — Stage 3 deadlocks unconditionally at the first research unit and re-running as prompted loops forever. Note the canonical directory convention is `analysis/{artifact-type}/{section}/` (as country-parity-checker:40 itself correctly uses for `analysis/claim-permission/{section}/`); the two defective lines inverted it to `analysis/{section}/{artifact-type}/`.

PROPOSED CHANGE:
(1) Repoint all 4 lines to `analysis/cluster-memos/{section}/`.
(2) Make both skills address the REFINED memo by name — `{section}-cluster-NN-memo-refined.md` — rather than treating every file in the directory as a memo. Reason: run-cluster.md:36 writes BOTH `{section}-cluster-{NN}-memo.md` (unrefined) and `{section}-cluster-{NN}-memo-refined.md` into that same directory, so a bare path swap would hand both skills two files per cluster, one of them unrefined, while their input tables say "one memo per cluster". This adopts the existing variant-suffix rule at reference/file-conventions.md:19 and the existing precedent at review-chapter.md:26, which reads the refined file by exact name. No new mechanism.
(3) KEEP the pre-flight guard in both skills, merely aimed correctly. Rejected alternative: delete the declared input path so the skills consume only the directory that run-sufficiency.md:44,55 already passes them at dispatch — that would delete a correct guard. Note run-sufficiency.md:21-22 ALREADY has its own correct pre-flight on the same path, so the skills' guard is a second, defense-in-depth layer that also protects a skill dispatched outside /run-sufficiency.

CONSUMER INVENTORY ALREADY RUN (invariant-stem sweep per ai-resource-builder/SKILL.md:365-373 Consumer-Inventory Gate; stems: cluster-memo, cluster-memos, memo-refined, refined). Please INDEPENDENTLY VERIFY rather than trusting this:
- The bad path exists in EXACTLY those 4 lines. No third consumer.
- Already-correct, MUST NOT be touched: run-cluster.md:36 (writer); run-analysis.md:7,32,164; run-synthesis.md:34; run-report.md:23,67; run-sufficiency.md:7,21,22; review-chapter.md:26; check-claim-ids.sh:27 (hook regex); audit-structure.md:33,68; chapter-review/SKILL.md:75; supplementary-evidence-merger/SKILL.md:112; file-conventions.md:19,43,109 (registry).
- Registry reconcile (clause 3) passes: no registry row authorizes `cluster-memos-refined/`.

KNOWN TRAP: `analysis/{section}/` on its own is the CORRECT sentinel directory (run-sufficiency writes five `.{phase}.done` sentinels there, both skills reference it correctly in ~7 places). Only the `cluster-memos-refined/` sub-path is wrong. A find-and-replace across `analysis/{section}/` would silently break Pass-3 re-entry.

BLAST RADIUS CONTEXT: these two skills are canonical and would be symlinked into deployed projects, but the research workflow is NOT YET DEPLOYED ANYWHERE — the Sector Intelligence pilot is the first deployment and it is gated behind this very mission. Live blast radius today is believed zero — the change repairs an unconditionally-broken path. PLEASE VERIFY this claim independently — check whether any project already carries a deployed copy or symlink of these two skills, because if one does, the claim is false and the risk profile changes.

VERIFICATION PLAN: build a scratch fixture reproducing the real layout (analysis/cluster-memos/{section}/ holding BOTH refined and unrefined memos for 2+ clusters, plus the analysis/{section}/ sentinel dir). Dispatch both skills against it BEFORE the edit to confirm they fail at pre-flight (a test that could never fail proves nothing), then AFTER the edit to confirm both clear pre-flight and produce a permission table and a parity table. The mission's non-negotiables forbid closing a thread on a code read.

SPECIFIC CHALLENGE REQUESTED — please address each explicitly in the report:
(a) Is addressing the refined memo BY NAME the right filter mechanism, or is there a better disambiguation (e.g. glob on the -refined suffix, or having run-cluster write refined memos to a distinct subdirectory)? Note that changing where run-cluster WRITES would be a much larger blast radius (it would touch every already-correct reader listed above) — but say so if you think it is nonetheless the right architecture.
(b) Does keeping the skills' declared input path + pre-flight, while run-sufficiency ALSO passes the directory at dispatch, entrench a two-source-of-truth problem that will drift later? Or is the defense-in-depth worth it?
(c) What does the consumer inventory still miss? Specifically consider: deployed/symlinked copies in projects/, the shared-manifest.json, SETUP.md, template CLAUDE.md, settings files, and any test fixtures or scratch deploy directories (e.g. output/deploy-test-scratch-*).

## Referenced files

- skills/claim-permission-gate/SKILL.md — exists
- skills/country-parity-checker/SKILL.md — exists
- workflows/research-workflow/.claude/commands/run-cluster.md — exists
- workflows/research-workflow/.claude/commands/run-sufficiency.md — exists
- workflows/research-workflow/.claude/commands/review-chapter.md — exists
- workflows/research-workflow/reference/file-conventions.md — exists
- skills/ai-resource-builder/SKILL.md — exists
- logs/missions/research-workflow-deploy-fitness.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The fix itself is correct, minimal, and well-scoped, but the change description's own blast-radius claim ("believed zero," "not yet deployed anywhere") is factually wrong — two live projects already symlink both canonical skills and carry real data in the exact two-memos-per-cluster layout the fix must handle correctly.

## Consumer Inventory

The two edit targets are `skills/claim-permission-gate/SKILL.md` and `skills/country-parity-checker/SKILL.md` themselves — they change in lockstep (same defect, same fix shape) and are not counted as their own consumers below. Everything else that references the `cluster-memos-refined` path, the `analysis/cluster-memos/{section}/` contract, or the `-memo-refined.md` naming convention is listed.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `workflows/research-workflow/.claude/commands/run-sufficiency.md` (:7, :21-22, :44, :55) | invokes (dispatches both skills; already passes the correct `analysis/cluster-memos/{section}/` path) | no |
| `workflows/research-workflow/.claude/commands/run-cluster.md` (:36) | co-edits (writer of the directory + both filenames the skills must read; contract source) | no |
| `workflows/research-workflow/.claude/commands/review-chapter.md` (:26) | documents (existing precedent for reading `-memo-refined.md` by exact name) | no |
| `workflows/research-workflow/reference/file-conventions.md` (:19, :43, :109) | documents (Rule 2 variant-suffix convention + canonical naming registry row) | no |
| `workflows/research-workflow/.claude/hooks/check-claim-ids.sh` (:10, :27) | parses (regex matches `/analysis/cluster-memos/` — already correct) | no |
| `logs/missions/research-workflow-deploy-fitness.md` (thread 1) | documents (governing mission contract naming the same 4 lines) | no |
| `audits/research-workflow-deployment-fitness-2026-07-13.md` (:41) | documents (diagnosis of record) | no |
| `projects/research-pe-regime-shift-advisory-gap/reference/skills/{claim-permission-gate,country-parity-checker}` | invokes (symlinks — `lrwxr-xr-x → ../../../../ai-resources/skills/...`; project's own `run-sufficiency.md` dispatches them; section 1.1 already has both `.done` sentinels and real permission/parity output on disk) | no (auto-fixed by editing the canonical file) — **but see finding below** |
| `projects/positioning-research/reference/skills/{claim-permission-gate,country-parity-checker}` | invokes (same symlink structure; section 1.1 also fully sentineled with real output) | no (auto-fixed) — **but see finding below** |

**Total: 9 consumers, 0 must-change.** But the last two rows are a materially incomplete-inventory finding, not a clean "0 must-change" result — see below.

**What the given inventory missed (answers challenge (c)):** The change description's inventory sweep covered canonical `ai-resources` files exhaustively and correctly — no gaps found there. It did **not** check `projects/` for deployed/symlinked copies, and that check surfaces a live consumer the description explicitly asked me to verify. Both `projects/research-pe-regime-shift-advisory-gap` and `projects/positioning-research` carry real symlinks (`file` command confirms `lrwxr-xr-x`) to `ai-resources/skills/claim-permission-gate` and `.../country-parity-checker` — the **main** ai-resources worktree (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`, branch `main`), not this session's worktree checkout. Both projects' `analysis/cluster-memos/1.1/` directories already hold real `-memo.md` / `-memo-refined.md` pairs for multiple clusters (verified: 5 clusters in the PE project, 4 in positioning-research), and both projects' `analysis/1.1/` directories already carry all five `.{phase}.done` sentinels plus completed `claim-permission` and `country-parity` output files — meaning Phase A/C already ran successfully there at some point (the fix-repo-issues log at `audits/fix-plans/fix-repo-issues-2026-06-04-1942.md:42` records that an earlier session "worked around it by passing the canonical path explicitly to sub-agents," which is consistent with how these completed without the SKILL.md bug being hit). `shared-manifest.json`, `SETUP.md`, and the template `CLAUDE.md` were checked directly and contain no reference to `cluster-memos-refined` or `memo-refined` — no gap there. No `output/deploy-test-scratch-*` or scratch-fixture directories exist in the repo today.

**Consequence:** the "not yet deployed anywhere" / "believed zero" framing in the change description is false as a factual claim, though the practical exposure is bounded: (1) the bug is *already live today* in `main` for these two projects, independent of this fix; (2) because both projects are sentinel-complete for section 1.1, `/run-sufficiency` re-entry semantics (skip-on-sentinel-present) mean neither project will re-exercise Phase A/C for 1.1 merely because the canonical file changes; (3) the fix will take effect the moment it merges to `main` (symlinks resolve live, no redeploy step) — for these two projects specifically, that is a *silent* behavior change to already-active, git-committed-today repositories, not a change scoped to an undeployed pilot. If either project starts a section 1.2, or an operator deletes a sentinel to force a Phase A/C re-run (a path `run-sufficiency.md`'s own Failure Modes section documents as normal), the corrected code — not the scratch fixture — is what actually executes next, against real project data.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edit touches two on-demand SKILL.md files invoked only when `/run-sufficiency` dispatches Phase A/C — not always-loaded CLAUDE.md, not a hook, not an `@import`. No token cost is added to every session.
- The change is a path-string correction plus a short by-name filter clause in an existing Inputs row and an existing pre-flight bullet (`claim-permission-gate/SKILL.md:49,151`; `country-parity-checker/SKILL.md:39,130`) — net line-count change is negligible, not a section addition.
- No new hook, no new `SessionStart`/`PreToolUse` registration, no skill-trigger-description change that would widen auto-load.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched; no settings.json of any layer referenced by the change.
- Both skills' documented tool footprint is unchanged — "Read + Write only... No shell, no network" (`claim-permission-gate/SKILL.md:206`; `country-parity-checker/SKILL.md:172`). The fix does not add a Bash pattern, a new Write path outside the existing `analysis/` tree, or any external-API call.
- No settings-file scope change (project → user, or vice versa).

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory above: 9 consumers found, 0 requiring a code change (`run-sufficiency.md`, `run-cluster.md`, `review-chapter.md`, `file-conventions.md`, and the hook regex are already correctly pointed and stay untouched). Taken alone, that pattern (multiple readers, zero must-change) would be Low.
- What moves this to Medium: the inventory surfaced two live, git-committed-today deployed projects (`projects/research-pe-regime-shift-advisory-gap`, `projects/positioning-research`) that the change description's own stated blast-radius belief ("believed zero," "not yet deployed anywhere") did not anticipate and explicitly asked to have checked. Per the framework, an inventory gap not anticipated by the change description is itself a blast-radius finding.
- The exposure is bounded, not open-ended: because both projects are sentinel-complete for their only research unit today (section 1.1), the merge does not retroactively re-execute the buggy/fixed path against them immediately. The real exposure is forward-looking — a future section 1.2 in either project, or an operator-forced sentinel deletion (a documented, normal `run-sufficiency.md` recovery path), will run the corrected code against real production data rather than the scratch fixture the verification plan proposes to build.
- This is not a backward-incompatible contract change for any of the 9 consumers — the path this thread corrects has never worked at any point any of them could have relied on it, so there is no prior-working behavior to regress. That keeps this at Medium rather than High.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are 4-line, single-commit changes to 2 already git-tracked canonical files. `git revert` fully restores the prior text within the same working tree — no sibling files, no new directories, no data/log mutation.
- The symlink propagation to the two live projects means a revert on `main` also reverts their live behavior — but that reversal is itself clean (the projects hold no local copy of the skill, only a symlink), so no extra manual cleanup step is introduced by the symlink relationship.
- No push, no external-system write, no cron/hook that could fire between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Naming-convention dependency (answers challenge (a)):** filtering by the exact filename `{section}-cluster-NN-memo-refined.md` makes each skill implicitly depend on `run-cluster.md` continuing to emit that literal suffix. This is not a new dependency — it is the same variant-suffix convention already governed at `reference/file-conventions.md:19` (Rule 2) and already exercised by `review-chapter.md:26` — so it is "one implicit dependency on an established, already-documented repo convention," which is the Medium calibration point, not High. A glob on the `-refined` suffix (`*-memo-refined.md`) carries the identical dependency and is not materially safer; it is an acceptable equivalent, not an improvement. Having `run-cluster` write refined memos to a **distinct subdirectory** would remove the naming dependency entirely, but — as the change description itself notes — it would ripple into every already-correct reader in the "must not be touched" list (5 commands, the hook regex, `audit-structure.md`, `chapter-review/SKILL.md`, `supplementary-evidence-merger/SKILL.md`, and the naming registry itself): a strictly larger blast radius to solve a coupling that has never actually caused a second failure. Filtering by name is the right call; restructuring the writer is not warranted absent a second observed failure of the naming convention (see Dimension 6, DR-7).
- **Two-source-of-truth (answers challenge (b)):** `run-sufficiency.md` already passes the correct `analysis/cluster-memos/{section}/` path at dispatch (`:44,:55`), and each skill will also independently declare and pre-flight-verify the same path. Keeping both is a real, named duplication — exactly the shape that produced today's bug (the orchestrator was already correct; only the two skills drifted). This is not eliminated by the fix; it is retained deliberately, with a stated reason (protects a skill invoked standalone, outside `/run-sufficiency`). The mitigation is that the failure mode this duplication risks is **loud, not silent**: a future drift between the two locations reproduces the current failure signature exactly (an explicit "run `/run-cluster` first" pre-flight exit), which is immediately diagnosable, not a silent wrong-data continuation. That keeps this at Medium rather than High — the duplication is real but its failure mode is self-announcing.
- No functional overlap with a second, differently-purposed mechanism, and no auto-firing in an unexpected context — the pre-flight check only runs when the skill itself is dispatched, and both skills already document that invocation context (`When to Use`).

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present; used directly).

- **DR-7 / OP-9 / AP-7 (generalize only on a second confirmed consumer / no speculative abstraction).** The fix does not build new infrastructure for an absent consumer — it corrects an existing, already-invoked pre-flight guard's target path and retains an existing (not new) guard. The "keep both the orchestrator's and the skill's own pre-flight" decision (Dimension 5) is not a new complexity-budget item subject to the `docs/ai-resource-creation.md` rule-#7 creation gate — no new command, agent, gate, or always-loaded doc is being introduced; a pre-existing check is being re-aimed. Rejecting the "move the writer's output location" alternative (Dimension 5) is itself DR-7-consistent: it declines to build a new subsystem-shaped fix (a distinct write directory) for a coupling problem that has produced exactly one, already-diagnosed failure — not a second confirmed one.
- **OP-12 (closure before detection).** This change is pure closure — it fixes a defect this same mission's audit already detected (`audits/research-workflow-deployment-fitness-2026-07-13.md:41`), and adds no new scan/audit/flag mechanism. It actively serves this principle rather than creating tension with it.
- **OP-10 (system boundary).** No cross-tool coordination (GPT/Perplexity/Notion/NotebookLM) is touched.
- **OP-5 (advisory vs. enforcement).** The pre-flight guard is retained at its existing enforcement posture (exits and stops) — no shift toward silent auto-correction, and no new enforcement authority is being granted.
- **Mission's own non-negotiables** (`logs/missions/research-workflow-deploy-fitness.md`, "Smallest general fix wins"): the proposed fix is exactly a channel-level correction (align the input path to what the writer already produces, extend an existing naming convention) rather than a new subsystem — directly consistent with the mission's own stated constraint.
- The one point requiring operator attention is not a principle violation but a factual-accuracy gap in the change's own framing (the blast-radius belief), addressed under Dimension 3/Mitigations rather than here.

## Mitigations

- **Blast radius (Medium):** Before merging this fix (i.e., before it takes live effect via symlink in `main`), extend the verification plan beyond the scratch fixture to a **read-only dry run** of both skills' corrected pre-flight logic against the real `analysis/cluster-memos/1.1/` directories in `projects/research-pe-regime-shift-advisory-gap` and `projects/positioning-research` (both already contain the exact two-file-per-cluster layout the fix must handle). Do not write to those projects' output paths — the goal is confirming the pre-flight check clears and the by-name filter selects only the `-refined` file against real data, not synthetic data. Separately, correct the mission's/audit's "believed zero" / "not yet deployed anywhere" blast-radius statement in `logs/missions/research-workflow-deploy-fitness.md` or the next session's notes, so a future session does not inherit a false blast-radius assumption from this thread.
- **Hidden coupling (Medium):** When editing the two skills, make the filename dependency explicit at the point of use — state the literal pattern `{section}-cluster-NN-memo-refined.md` in each skill's Inputs row (not a paraphrase like "the refined file"), and add a one-line cross-reference to `reference/file-conventions.md` Rule 2 in each skill's Cross-References section, so a future editor of `run-cluster.md`'s output naming is prompted to check these two skills before changing the suffix convention.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, `file`/grep output confirming live symlinks and real project data, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit findings from the consumer-inventory grep). No training-data fallback was used on fetch/read failures.
