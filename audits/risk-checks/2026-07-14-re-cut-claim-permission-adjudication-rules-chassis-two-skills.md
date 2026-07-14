# Risk Check — 2026-07-14

## Change

Re-cut the research-workflow's claim-permission adjudication rules across three canonical files in the ai-resources worktree at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow`:
- `workflows/research-workflow/reference/quality-standards.md` (the "chassis": § Claim-Permission Classes, § Country Coverage Table, § Research Stop Conditions, § Evidence Scarcity Handling, § No-Source-Substitution Rule)
- `skills/claim-permission-gate/SKILL.md`
- `skills/cluster-memo-refiner/SKILL.md` (Check 9)

This is a MANDATORY gate: the chassis's own Canonical-ordering rule states "Future edits that cross this boundary in either direction require /risk-check re-fire," and the Conditions column WAS edited.

WHAT CHANGED (per operator's account, independently verified against `git diff HEAD`):
1. The four permission classes re-cut onto ONE ordered axis (evidentiary-role count, then fit), replacing a mixed-axis rule that produced a demonstrated gap (a single direct non-example source matched no class) and a demonstrated overlap (a 2-role pattern claim matched SUPPORTED and ILLUSTRATIVE-ONLY at once). Class names unchanged.
2. "<3 same-pattern instances" and the country-coverage condition moved from class conditions into ceilings (caps applied after the evidence-graded class).
3. NOT-SUPPORTED tightened to "zero evidentiary roles" only; the un-role-gated `OR all-source-classes-exhausted` clause removed.
4. New § Evidenced Negatives vs Absence of Evidence.
5. New Stop Condition 5 (max supplementary passes exhausted); the reciprocal rule reclassified as a declared-but-unimplementable "process ceiling."
6. New upstream recording obligation on `cluster-memo-refiner` Check 9 (`instances: {count}` / `instances: n/a (population-level — {source})`).
7. New "Lockstep contract" naming the chassis + both skills as a closed set requiring paired edits, plus stale-schema corrections.

EVIDENCE cited: four blind adjudication runs (fresh Opus subagents) against a 5-claim fixture — OLD rules: GAPS 1, OVERLAPS 1; NEW rules: GAPS 0, OVERLAPS 0, UNDETERMINED 0.

Adversarial questions posed by the operator (all investigated below): (a) divergence between the new skill and the two live projects' un-migrated chassis copies; (b) permissiveness-direction risk on the BLOCKED/CLEARED gate; (c) unaccounted consumers; (d) internal coherence of the presence-gate/malformed-input distinction and the narrow-vs-cap split; (e) whether "disclosed but unfixed" is the right call for two enforcement gaps.

## Referenced files

- workflows/research-workflow/reference/quality-standards.md — exists (modified)
- skills/claim-permission-gate/SKILL.md — exists (modified)
- skills/cluster-memo-refiner/SKILL.md — exists (modified)
- skills/country-parity-checker/SKILL.md — exists (unmodified)
- workflows/research-workflow/.claude/commands/run-sufficiency.md — exists (unmodified)
- projects/research-pe-regime-shift-advisory-gap — exists (live project)
- projects/positioning-research — exists (live project)

## Verdict

RECONSIDER

**Summary:** The rule re-cut itself is sound and evidence-verified (0/0/0 defects on the fixture), but two dimensions land High — Blast Radius and Hidden Coupling — both driven by the same root cause: the change's own "Lockstep contract" names a closed set of three files, but the actual dependency graph is wider (two live projects hold real, un-symlinked chassis copies that the change does not touch, plus a fourth skill carrying a partial restatement), and the deployment mechanism (skill via symlink, chassis via real per-project copy) means the skill can go live in both projects before their chassis catches up.

## Consumer Inventory

Search terms derived from the three referenced files and their contract markers: `Claim-Permission Classes`, `SUPPORTED`/`PROXY-SUPPORTED`/`ILLUSTRATIVE-ONLY`/`NOT-SUPPORTED`, `Source-Diversity Matrix`, `Adjudication order`, `Permission ceilings`, `instances:`, `permission-table`. Grepped across `ai-resources-research-workflow/{skills,workflows,.claude,docs}` and the two live project directories.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `skills/cluster-memo-refiner/SKILL.md` | co-edits (Check 9 restates the class conditions) | yes — satisfied in this diff |
| `skills/claim-permission-gate/SKILL.md` | co-edits (authoritative Pass-3 consumer of the chassis) | yes — satisfied in this diff |
| `skills/country-parity-checker/SKILL.md` | documents (1 incidental mention of the NOT-SUPPORTED-ratio relationship; no class-condition restatement — operator's claim verified) | no |
| `workflows/research-workflow/.claude/commands/run-sufficiency.md` | invokes `claim-permission-gate`; parses ratio outputs. Pre-existing (not introduced by this diff) stale schema note at line 27 still describes `## Source-Diversity Matrix` as top-level, when the real chassis nests it as `###` under `## Claim-Permission Classes` | no for this diff, but a latent defect this inventory surfaced |
| `skills/section-directive-drafter/SKILL.md` | documents — carries its own verb/framing table for the four classes (lines 203–208), a fourth working copy not named in the chassis's "Lockstep contract" three-file closed set | no this round (verb lists unchanged), but the Lockstep contract's scope claim is incomplete |
| `skills/evidence-to-report-writer/SKILL.md` | documents — named by the chassis's verb-list enforcement clause; contains zero permission-class vocabulary (grep confirmed 0 hits) | no — disclosed, unfixed, pre-existing |
| `skills/chapter-prose-reviewer/SKILL.md` | documents — named for Stage 4.3 cross-check; zero permission-class vocabulary (confirmed) | no — disclosed, unfixed, pre-existing |
| `skills/citation-converter/SKILL.md` | documents — named for orphan-citation validation; zero permission-class vocabulary (confirmed) | no — disclosed, unfixed, pre-existing |
| `skills/cluster-synthesis-drafter/SKILL.md` | documents/consumes output — reads permission tables per `claim-permission-gate`'s Cross-References; zero permission-class vocabulary (confirmed) | no — disclosed, unfixed, pre-existing |
| `projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md` | co-edits (real, un-symlinked copy of the chassis — verified via `file`/`ls`, not a symlink) — currently carries the OLD mixed-axis Conditions column, including the un-role-gated `OR all-source-classes-exhausted` clause this change removed | **yes — not addressed by this diff** |
| `projects/positioning-research/reference/quality-standards.md` | co-edits (same — real, un-symlinked copy, same old-rules content confirmed by direct read) | **yes — not addressed by this diff** |

**Total: 11 consumers found, 4 must-change** (2 satisfied within this diff — `cluster-memo-refiner`, `claim-permission-gate`; 2 unaddressed — the two live-project chassis copies). This is not an isolated change.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the three edited files are always-loaded. `quality-standards.md` states its own load condition explicitly: "When to read this file... Not needed for every turn" (line 9). It is read on-demand by `claim-permission-gate` and `cluster-memo-refiner`, both invoked positionally by `/run-sufficiency` / `/run-cluster`, not per-turn.
- Neither skill registers a hook; neither has broad auto-trigger description keywords beyond its existing scoped role.
- Secondary observation (does not change the Low verdict, doesn't meet the rubric's Medium/High triggers): the chassis's `## Claim-Permission Classes` section grew substantially (net +158 lines across the 3-file diff, per `git diff --stat`), driven by repeated "corrected 2026-07-14" callout blocks. This raises the per-invocation read cost for an Opus/high-effort skill (`claim-permission-gate`) but the file remains pay-as-used, not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- The diff touches only skill/reference-doc prose (`workflows/research-workflow/reference/quality-standards.md`, two `SKILL.md` files). No `settings.json`, no new Bash/Write/tool pattern, no allow/deny entries anywhere in the diff.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (above): 11 consumers, 4 must-change. Two of the four must-change consumers — the two live projects' own `reference/quality-standards.md` copies — are **not addressed by this diff at all**, which is the rubric's explicit High trigger ("any caller requires modification to keep working").
- Verified by direct inspection: both live projects hold a **real, non-symlinked** copy of `quality-standards.md` (`file` command confirms plain UTF-8 text, not a symlink), while their `reference/skills/{claim-permission-gate,cluster-memo-refiner,country-parity-checker}` are **symlinks** resolving to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/...` — the canonical repo, and this worktree (`ai-resources-research-workflow`) is confirmed via `git worktree list` to be a worktree of that same repo (`ai-resources/.git/worktrees/ai-resources-research-workflow`). Merging the current branch to `main` is the exact merge that updates both live projects' skills, with zero action required in either project.
- Both live projects' existing chassis copies were read directly and confirmed to still carry the OLD mixed-axis `### Four Permission Classes` table, including the specific `NOT-SUPPORTED` `OR all-source-classes-exhausted` clause this change identifies as the source of the demonstrated overlap defect, and the OLD `ILLUSTRATIVE-ONLY` condition (`<3 same-pattern instances, OR single-source named-example, OR two-or-more-countries not evidenced`) that this change identifies as the source of the demonstrated gap defect. Neither project's chassis is touched by this change.
- Both live projects have **already completed Stage 3 for section 1.1** — 9 permission-table artifacts + 2 gate-clearance files exist on disk, graded under the old rules, both currently `CLEARED-WITH-CAVEATS` (verified: research-pe section ratio 0.00/35 claims; positioning-research section ratio 0.04/25 claims — both far under the 30%/40% thresholds).
- The change's own "Lockstep contract" (chassis § Claim-Permission Classes → Lockstep contract, and both skills' Cross-References) names a **closed set of three files** as sufficient — it does not name the per-project chassis deployments as a required update target, and does not name `section-directive-drafter/SKILL.md`, which independently restates the four classes' verb/framing table (lines 203–208) as a fourth working copy.

### Dimension 4: Reversibility
**Risk:** Medium

- The 3-file diff itself is a clean `git revert` — no external writes, no settings changes, all three files git-tracked in this repo.
- The propagation risk (skill auto-updates via symlink on merge, chassis does not) is real but **not automatic**: `/run-sufficiency` Phase A is sentinel-gated (`.claim-permission-gate.done`), and both live projects already carry a completed sentinel for section 1.1 — a plain re-run would skip Phase A, not silently regenerate under mismatched rules. The risk only materializes if the operator runs a **new, not-yet-gated section** in either live project, or explicitly force-deletes a sentinel, before backporting the chassis.
- If it does materialize, the recovery path is not novel — `run-sufficiency.md` line 121 already documents the dispute-resolution mechanic: "operator edits the affected permission-table directly; deletes the `.claim-permission-gate.done` sentinel to force re-emission... rationale logged to `/logs/decisions.md`." This is a known, structured (if manual) cleanup procedure, not an undocumented multi-step rollback.
- Net: revert of the code change is clean; the conditional downstream risk requires one extra, but already-documented, cleanup step if it fires — Medium, not High.

### Dimension 5: Hidden Coupling
**Risk:** High

- Multiple implicit dependencies, all grounded in the Dimension 3 findings: the change's "Lockstep contract" states three files "must change together, or they diverge" — but the true dependency set found by this inventory is wider (two live-project chassis copies + `section-directive-drafter`'s verb-list table), and none of those four consumers are named in the contract's own completeness claim. A contract that asserts closure over a set it has not verified is complete is exactly the "silently relies on an existing convention that could change" pattern this dimension exists to catch.
- New schema field `instances: {count}` / `instances: n/a (population-level — {source})` is a new required contract between `cluster-memo-refiner` (writer) and `claim-permission-gate` (reader) — this one is explicitly disclosed and cross-referenced at both change sites (chassis § Permission ceilings, both skills' Behavior sections), so it does not independently drive High on its own; it is included here because it compounds the same underlying issue — the two live projects' already-emitted memos predate this field and will trigger `[POPULATION-LEVEL-UNVERIFIED — operator review]` flags on generalizing claims at next re-run, which the change anticipates in prose ("Findings written before 2026-07-14 do not carry this field... treat as memo-completion work") but which is a further consequence of the same unaddressed chassis/skill deployment gap.
- Checked for internal contradiction (operator's question d) — found none live: the presence-gate/malformed-input distinction ("legitimately absent → inapplicable" vs "required but missing → fires with a flag") is explicitly reconciled in the chassis text (§ Permission ceilings, "Presence-gating — and the one distinction that makes it coherent") with a stated test, and the narrow-vs-cap split between `cluster-memo-refiner` (may narrow) and `claim-permission-gate` (may only cap) is explicitly reconciled via the `GENERALIZATION-CAPPED` marker and Disposition rule. One minor asymmetry noted but not scored as a defect: a missing Country Coverage Table is treated as categorically "inapplicable, never fires" regardless of project type, while a missing `instances:` field on a generalizing claim is treated as "malformed, fires with a flag" — the asymmetry has a plausible rationale (Check 8 already flags unfillable country entries via its own mechanism) but is not stated as such in the text.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read; present and used as the primary source).

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — checked, not violated.** The one candidate — the "process ceiling" (chassis § Permission ceilings, fourth row), explicitly marked "declared, NOT implementable... no consumer implements this" — is not new infrastructure built for an absent consumer. The underlying reciprocal rule already existed pre-change (§ Research Stop Conditions) and was already unenforced; this change relocates it into the ceiling taxonomy and **more loudly** discloses its non-enforcement status than before. That is closure-adjacent documentation of pre-existing debt, not new speculative building.
- **OP-12 (closure before detection) — checked, not violated.** No new detection mechanism ships in this change without a closure channel; the two disclosed enforcement gaps (verb-list/orphan-citation in four downstream skills — grep-confirmed 0 permission-vocabulary hits in `evidence-to-report-writer`, `chapter-prose-reviewer`, `citation-converter`, `cluster-synthesis-drafter`; and the process ceiling) both pre-date this change and are being surfaced, not newly created.
- **OP-3 / OP-11 (loud revision, never silent drift) — this change scores as aligned.** The "⚠ Enforcement-gap disclosure" and "process ceiling ... do not rely on it" callouts are textbook loud, explicit disclosure of known gaps rather than silent continuation — the correct mechanism under OP-3/OP-11.
- **One Medium-adjacent tension noted (not scored as High):** the Lockstep contract's own completeness claim (three files, "must change together, or they diverge") is not fully verified against the real consumer set (see Dimension 3/5) — a mild version of asserting closure without confirming it. This is not scored as a principle violation because the mechanism that surfaces it (this risk-check, run at the operator's explicit adversarial request) is itself the correct OP-11 channel — it makes the gap loud rather than leaving it silent.

## Recommended redesign

- **Sequence the deployment, don't ship the skill ahead of the chassis.** Before merging this branch into canonical `ai-resources` main, backport the new subsections (`### Adjudication order`, `### Permission ceilings`, `### Evidenced Negatives vs Absence of Evidence`, and the tightened `### Four Permission Classes` table) into both live projects' `reference/quality-standards.md` in the same pass. Pair this with a `chassis_version:` marker in `quality-standards.md` that `claim-permission-gate`'s pre-flight checks explicitly — a version mismatch should produce a **loud pre-flight exit**, not the current silent-misbehavior path (the skill's pre-flight only checks for heading *presence*, and the old chassis's headings happen to still satisfy that presence check, so today a stale chassis would NOT be caught).
- **Widen the Lockstep contract to match the verified consumer set, not the assumed one.** Add the per-deployment project `quality-standards.md` copies and `skills/section-directive-drafter/SKILL.md` to the chassis's and both skills' "must change together" list — this inventory found four real consumers the contract's own three-file framing does not name; a future edit to the Conditions/ceilings should not have to repeat this discovery from scratch.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `git diff HEAD` against the three referenced files, `file`/`ls -la`/`readlink` inspection of both live projects' `reference/` and `reference/skills/` directories, direct reads of both live projects' `quality-standards.md` (confirming old-rules content) and their existing `gate-clearance`/`permission-table` artifacts (confirming current CLEARED status and ratios), and `grep -c` counts across `skills/`, `workflows/research-workflow/.claude/commands/`, and `projects/strategic-os/ai-strategy/principles-base.md`. No training-data fallback was used on fetch/read failures — all referenced-file reads succeeded.
