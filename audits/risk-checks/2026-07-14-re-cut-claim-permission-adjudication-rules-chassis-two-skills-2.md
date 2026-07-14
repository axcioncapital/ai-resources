# Risk Check — 2026-07-14

## Change

**RE-FIRE after a RECONSIDER verdict.** Your prior review of this change set (report at `audits/risk-checks/2026-07-14-re-cut-claim-permission-adjudication-rules-chassis-two-skills.md`) returned RECONSIDER with two redesign requirements. This is the corrected change set. Judge the CURRENT state of the files — re-verify from the diff, do not assume my account is accurate.

The change (unchanged in substance): re-cut the research-workflow's claim-permission adjudication rules onto a single ordered axis (independent evidentiary roles → evidence fit), moving the `<3 same-pattern instances` and country-coverage conditions out of the class conditions and into CEILINGS. Closes a demonstrated GAP and OVERLAP. No class renamed, none added. Files: `workflows/research-workflow/reference/quality-standards.md` (chassis), `skills/claim-permission-gate/SKILL.md`, `skills/cluster-memo-refiner/SKILL.md`, and now `skills/section-directive-drafter/SKILL.md`.

WHAT I CHANGED IN RESPONSE TO YOUR RECONSIDER — verify each is real and sufficient:

**Your redesign item 1 — "add a `chassis_version:` marker the skill's pre-flight checks (turns silent misadjudication into a loud exit)."** DONE, and this is the load-bearing mitigation:
- Chassis § Claim-Permission Classes now opens with a version marker (both `<!-- chassis-version: 2026-07-14 -->` and a visible `**Chassis version: \`2026-07-14\`.**` line).
- `claim-permission-gate` pre-flight now has a CHASSIS-VERSION GATE as its FIRST check: absent marker, or date < 2026-07-14 → HARD EXIT, adjudicate nothing. Full remediation prompt added under Failure Behavior naming exactly which sections to back-port.
- `cluster-memo-refiner` Check 9 has the identical gate.
- Rationale is documented in-file: every OTHER pre-flight check is a heading-presence check, and the old chassis has all the same headings — so nothing else can detect the divergence.

**Your redesign item 2 — "widen the Lockstep contract to name the real consumer set (both live-project chassis copies + `section-directive-drafter`), not just the assumed three-file set."** DONE:
- The chassis's § Lockstep contract is now a 4-row table naming: `cluster-memo-refiner` Check 9 (restates conditions), `claim-permission-gate` (relies on names as literals), `section-directive-drafter` (restates verb lists + prose framing, NOT conditions — so a conditions-only edit does not trigger it), and **each consuming project's own real (non-symlinked) copy of the chassis**.
- Added a § Version history table recording the 2026-07-14 re-cut and its back-port obligation.
- `section-directive-drafter` itself was updated: a `[GENERALIZATION-CAPPED]` disposition rule (narrow or omit — never restate the generalization under a hedge), a `[POPULATION-LEVEL-UNVERIFIED]` handling rule, the `NOT-SUPPORTED` ≠ false clarification, and the single-sourced-non-named-case addition to ILLUSTRATIVE-ONLY.

**Your finding (c) — the missed 4th consumer `section-directive-drafter`** — accepted and acted on (above). I also CORRECTED an overstatement of my own in the mission log: I had written that permission enforcement happens "nowhere", but `section-directive-drafter` IS a real live consumer converting classes into prose constraints. The narrowed, accurate statement: classes ARE converted to prose constraints at Stage 3 by `section-directive-drafter`, and are enforced by nothing at Stage 4.3.

**NOT DONE — and I need your judgment on whether this is acceptable:** I did **NOT** back-port the new chassis into the two live projects (`projects/research-pe-regime-shift-advisory-gap`, `projects/positioning-research`). This is an explicit, operator-approved scope bound on this session's mandate ("the two live projects' own reference/ copies are not edited — canonical only"), and it is a declared stop condition. My argument that the merge is nonetheless SAFE without it:
  (i) The chassis-version gate makes both skills HARD-EXIT in those projects rather than misadjudicate.
  (ii) Both projects have ALREADY COMPLETED Stage 3 for section 1.1 — the `.claim-permission-gate.done` sentinels are present, so `/run-sufficiency` SKIPS the phase entirely and the gate does not even run unless someone deletes a sentinel.
  (iii) Your own finding (b): both projects sit at NOT-SUPPORTED ratios of 0.00 and 0.04 against 30%/40% thresholds, so no BLOCKED→CLEARED flip is reachable on current data.
**Attack this.** Is the merge genuinely safe with the back-port deferred to an operator decision, or is there a path I have not seen where a project silently misadjudicates, or where a hard-exit blocks live work in a way that is worse than the divergence? Verify (i)/(ii)/(iii) yourself — especially the sentinel claim, which is doing a lot of the work.

ALSO RE-TEST (do not take my word):
- Did the version-gate edits introduce any NEW internal contradiction, particularly against the "presence-gate → ceiling does not fire" rule? (A version gate is a HARD exit, not a presence-gate skip — confirm the two do not collide conceptually or textually.)
- Is the `section-directive-drafter` conditions-vs-framing distinction in the Lockstep table CORRECT — i.e. does that skill really restate only verb lists/framing and not the class conditions? If it restates conditions anywhere, my table is wrong and a conditions-only edit WOULD need to touch it.
- Any consumer still missed, now that four are named?

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/reference/quality-standards.md — exists (modified)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/claim-permission-gate/SKILL.md — exists (modified)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/cluster-memo-refiner/SKILL.md — exists (modified)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/skills/section-directive-drafter/SKILL.md — exists (modified)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap — exists (live project — verified: no chassis-version marker, sentinels present, ratios confirmed)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research — exists (live project — verified: no chassis-version marker, sentinels present, ratios confirmed)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both prior RECONSIDER redesign items are genuinely implemented and verified against the live files (not the operator's account) — the chassis-version gate is textually correct and consistent, the widened Lockstep contract is accurate, and no fifth consumer was missed — so the two live-project chassis copies now fail loud instead of failing silent; the deferred back-port remains a real, bounded blast-radius item that needs one explicit operator-owned follow-up action, not a design fix.

## Consumer Inventory

Search terms re-derived from the four referenced files' contract markers and re-grepped fresh (not reused from the prior report): `chassis-version` / `Chassis version`, `Claim-Permission Classes`, the four class-name literals in combination (`SUPPORTED`/`PROXY-SUPPORTED`/`ILLUSTRATIVE-ONLY`/`NOT-SUPPORTED`), independent-evidentiary-role / same-pattern-instance condition language. Grepped across `ai-resources-research-workflow/` and the workspace root (`Axcion AI Repo/`), per Step 1.5.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `skills/cluster-memo-refiner/SKILL.md` Check 9 | co-edits (restates class conditions + chassis-version gate) | yes — satisfied in this diff |
| `skills/claim-permission-gate/SKILL.md` | co-edits (relies on class names as literals + chassis-version gate) | yes — satisfied in this diff |
| `skills/section-directive-drafter/SKILL.md` | co-edits (verb lists + prose framing only — **verified by grep: zero hits for condition-language patterns** — `≥2`, `exactly 1`, `zero evidentiary`, `same-pattern instance`, `independent evidentiary role`, `not evidenced` all absent from this file) | no this round — correctly excluded; would need to change only if verb lists/framing changed |
| `projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md` | co-edits (real, non-symlinked chassis copy — **verified: no `chassis-version`/`Chassis version` string present** → will HARD-EXIT on next `claim-permission-gate` or Check 9 invocation) | **yes — deferred, not addressed in this diff; mitigated by the hard-exit gate** |
| `projects/positioning-research/reference/quality-standards.md` | co-edits (same — **verified: no version marker present**) | **yes — deferred, not addressed in this diff; mitigated by the hard-exit gate** |
| `skills/execution-manifest-creator/SKILL.md`, `skills/research-prompt-creator/SKILL.md`, `reference/stage-instructions.md`, `.claude/commands/run-synthesis.md`, `.claude/commands/run-cluster.md`, `.claude/commands/run-sufficiency.md`, `skills/country-parity-checker/SKILL.md` | documents — each cites the four class-name literals (unchanged by this edit) but restates no conditions, adjudication order, or ceilings | no — verified unaffected |
| `skills/evidence-to-report-writer/SKILL.md`, `skills/chapter-prose-reviewer/SKILL.md`, `skills/citation-converter/SKILL.md`, `skills/cluster-synthesis-drafter/SKILL.md` | documents — named by the chassis's disclosed (pre-existing, unfixed) enforcement-gap callout; zero permission-class vocabulary | no — disclosed, unfixed, pre-existing; unaffected by this diff |

**Total: 13 consumers found, 4 must-change** (2 satisfied within this diff — `cluster-memo-refiner`, `claim-permission-gate`; 2 unaddressed but now safely gated — the two live-project chassis copies). No fifth consumer was found beyond the four the widened Lockstep contract now names; the "documents"-type consumers found by a fresh grep all cite only the unchanged class-name literals, not the re-cut conditions, so they are correctly outside the change's must-change set.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the four edited files are always-loaded. `quality-standards.md` states its own on-demand load condition ("When to read this file... Not needed for every turn," line 9). Both skills are invoked positionally (`/run-sufficiency` Phase A, `/run-cluster` Check 9), not per-turn; `section-directive-drafter` is invoked positionally by the Stage-3 step.
- No hook registered, no `@import` added, no settings.json touched (confirmed: `git status --short` shows only the four SKILL.md/chassis files plus session/log files — no `.claude/settings*.json` in the diff).
- The chassis-version gate adds a small, fixed per-invocation read (one marker line/HTML comment check) to each skill's pre-flight — negligible relative to the existing per-cluster-memo context footprint both skills already carry.

### Dimension 2: Permissions Surface
**Risk:** Low

- The diff touches only skill/reference-doc prose across four files (confirmed via `git diff --stat`: `claim-permission-gate/SKILL.md` +75/-, `cluster-memo-refiner/SKILL.md` +47/-, `section-directive-drafter/SKILL.md` +15/-, `quality-standards.md` +182/-). No settings file, no new Bash/Write/tool pattern, no allow/deny entries anywhere in the diff.

### Dimension 3: Blast Radius
**Risk:** High (viable mitigation present — see Mitigations)

- Consumer inventory above: 13 consumers, 4 must-change, 2 satisfied in this diff, 2 deferred. The rubric's High trigger ("any caller requires modification to keep working") technically still fires: both live projects' chassis copies remain on the pre-2026-07-14 rules and will need to be back-ported before either project can process a *new* section.
- **What changed since the prior RECONSIDER, verified directly (not taken on the operator's word):**
  - Both live projects' `reference/quality-standards.md` were grepped fresh for `chassis-version` / `Chassis version` — **zero hits in either file**, confirming both are still on the pre-2026-07-14 chassis and will trip the new hard-exit gate exactly as designed.
  - Both live projects' `analysis/1.1/.claim-permission-gate.done` sentinels were confirmed present on disk (`find` located both).
  - `run-sufficiency.md` (read in full) confirms the re-entry mechanic exactly as claimed: "Re-entry: Skip Phase A if `.claim-permission-gate.done` is present at Step 0" (line 49), and the command's Re-entry-semantics summary states each phase is "skip-on-sentinel-present," with no auto-clean of stale sentinels — deletion is an explicit, operator-initiated action, never automatic.
  - Both live projects' `analysis/gate-clearance/1.1/1.1-gate-clearance.md` were read directly: `research-pe-regime-shift-advisory-gap` — section_ratio 0.00 against a 0.40 section threshold, verdict `CLEARED-WITH-CAVEATS`; `positioning-research` — section_ratio 0.04 against 0.40, verdict `CLEARED-WITH-CAVEATS`. Both confirmed against the file, not the operator's summary.
  - Net: the risk the trigger names is real (both projects are stale) but its *consequence* is now a controlled, visible, operator-actionable halt on the next fresh Phase-A run for a *new* section — not a silent re-adjudication of already-cleared claims. Section 1.1 in both projects is not exposed to this change at all under current operating conditions.
- **The unmitigated residual risk is operational, not correctness-related:** if either project's operator (or a future session) deletes the `.claim-permission-gate.done` sentinel or opens a new section without first back-porting, the run will hard-exit — a real friction cost, but a safe one, and exactly the trade-off the mitigation was designed to make.

### Dimension 4: Reversibility
**Risk:** Medium

- The 4-file diff itself is a clean `git revert` — all four files git-tracked in this worktree/repo, no external writes.
- Confirmed via `git worktree list`: `ai-resources-research-workflow` is a worktree of the same repo as canonical `ai-resources` (currently at `ff526b6 [main]`); merging this branch to `main` is the merge event that updates both live projects' skill symlinks instantly, while their chassis copies remain untouched (verified non-symlink `file` type in the prior report's evidence chain — unchanged in this re-fire).
- The propagation risk is now *strictly better* than before the mitigation: previously, a stale chassis would silently misadjudicate (requiring after-the-fact detection and possibly re-grading already-emitted claims — a multi-step cleanup). Now, a stale chassis simply refuses to run, which is trivially reversible (nothing happened; back-port, then re-run) and requires no forensic detection step.
- Net: Medium, unchanged from the prior report, but the character of the residual risk shifted from "may require retroactive re-grading of a misadjudicated run" toward "may require a manual back-port before the next run" — a bounded, single, already-documented step.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The prior High finding was driven entirely by the Lockstep contract asserting closure over a consumer set (three files) that a fresh inventory showed was actually wider (two live-project copies + `section-directive-drafter`). This re-fire's fresh consumer inventory (Step 1.5, independently re-derived and re-grepped) confirms the widened 4-row Lockstep contract now matches the real consumer set — no additional restater of conditions/adjudication order/ceilings was found beyond the four it names.
- One new implicit contract is introduced by the mitigation itself: the chassis-version marker's exact textual format (`**Chassis version: \`YYYY-MM-DD\`.**` or `<!-- chassis-version: YYYY-MM-DD -->`). Verified this is consistently stated in all three places that need to agree — the chassis header (both forms present), `claim-permission-gate` pre-flight (both forms named, identical wording), `cluster-memo-refiner` Check 9 pre-flight (both forms named, identical wording). No format mismatch found. This is a new contract, but it is documented at the change site in all three consumers — the rubric's Medium condition ("one new contract that is documented at the change site"), not High.
- Checked for a conceptual/textual collision between the new chassis-version HARD-EXIT gate and the pre-existing "presence-gate → ceiling does not fire" rule (operator's explicit ask) — **none found.** The two operate at different scopes and different moments: the version gate is a file-level pre-flight check ("is this reference doc new enough to adjudicate at all"), run *before* any claim is touched, and its remedy is external (back-port the file). The presence-gate is a per-claim, per-ceiling behavior *during* adjudication ("is this optional input present for this specific claim"), and its remedy is internal (record `n/a` or bind Tier B). The chassis text keeps them textually separate — the version gate's own line explicitly says "check this FIRST, before any adjudication" (distinct verb: HARD-EXIT vs. "does not fire"). No shared vocabulary, no overlapping trigger condition.
- Verified the `section-directive-drafter` conditions-vs-framing distinction directly (operator's explicit ask, not taken on account): grepped the file for `independent evidentiary role`, `≥2`, `exactly 1`, `zero evidentiary`, `same-pattern instance`, `not evidenced`, `Conditions column` — **zero matches**. The file's only class-vocabulary content is the verb-list/prose-framing table (Permission-Class Constraints, lines 197–221) plus the `[GENERALIZATION-CAPPED]` and `[POPULATION-LEVEL-UNVERIFIED]` disposition rules newly added — both of which consume the *ceiling outputs*, not the class *conditions*. The Lockstep table's claim is correct.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read; present, same source as the prior report).

- **OP-5 (advisory vs. enforcement) — checked, not violated.** The new chassis-version gate is a hard STOP with a remediation prompt, not an auto-correct — it advises (names exactly what to back-port) and halts; it does not silently fix the stale chassis itself. This is squarely on the advisory side of OP-5, not a silent enforcement upgrade.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — checked, not violated.** The version gate is built for two already-confirmed, already-existing consumers (both live projects, verified stale on disk) — not a hypothetical future consumer. It is the textbook non-speculative case: the second confirmed consumer already exists and the gate protects it.
- **OP-11 / OP-3 (loud revision, never silent drift) — this change scores as aligned, and is stronger than the prior draft.** The chassis's own § Lockstep contract line ("Any edit here that bumps the version marker creates a back-port obligation for every deployed project. Enumerate them before merging") is satisfied literally — both live-project copies are now enumerated in the table. The deferred back-port itself is stated as an explicit, operator-approved scope bound for this session ("the two live projects' own reference/ copies are not edited — canonical only"), not silent debt — this is the correct OP-11/OP-3 mechanism (a recorded, deliberate deferral, not drift).
- **DR-1 (placement) — not implicated.** No new file, no new resource category; edits are in-place to existing canonical skills and the chassis.
- No Medium-level tension found this round: the prior report's one noted tension (Lockstep contract's completeness claim not fully verified) is the specific thing this re-fire's fresh grep was run to re-check, and it now holds up.

## Mitigations

- **Dimension 3 (Blast Radius) — the required paired mitigation:** Schedule and execute the back-port of the re-cut `§ Claim-Permission Classes` (all subsections), `§ Country Coverage Table`'s gate rule, and `§ Research Stop Conditions` into both `projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md` and `projects/positioning-research/reference/quality-standards.md`, before either project's next `/run-sufficiency` invocation on a section beyond 1.1, or before anyone deletes either project's `.claim-permission-gate.done` sentinel. Until that back-port lands, treat any request to re-run Phase A in either project as a known, expected hard-exit — not a bug — and do not attempt to work around the gate by hand-editing the skill or the sentinel.
- **Secondary (supports Dimension 3, optional but recommended):** Record the back-port obligation as a standing line item in each live project's own `logs/decisions.md` (both already exist and are actively used) so the obligation is visible from inside the project, not only inside the canonical chassis file — the chassis enumerates the obligation, but nothing inside either project currently flags it back to the operator proactively.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: fresh `grep`/`find`/`Read` against the four referenced files (not the operator's account) confirming the chassis-version marker's presence and exact wording in the canonical files and its confirmed absence in both live projects' chassis copies; direct reads of both live projects' `.claim-permission-gate.done` sentinels (found present) and `1.1-gate-clearance.md` files (ratios 0.00/0.04 against 0.40, verdict `CLEARED-WITH-CAVEATS`, confirmed); a full read of `run-sufficiency.md` confirming the sentinel-skip re-entry mechanic; `git diff --stat` and `git worktree list` confirming the diff scope and the worktree-to-canonical-repo relationship; a fresh repo-plus-workspace-root grep confirming no missed consumer beyond the four the widened Lockstep contract names, and confirming `section-directive-drafter` restates no class conditions. No training-data fallback was used on fetch/read failures — all referenced-file and inventory reads succeeded.
