# Risk Check — 2026-06-09

## Change

Promote 3 research-methodology deltas from project research-pe-regime-shift-advisory-gap into the canonical research-workflow template at ai-resources/workflows/research-workflow/reference/.
(P1) Add the cross-class triangulation-collapse clause to quality-standards.md § Source-Diversity Matrix (currently a single same-class sentence at line 191) — "channels sharing one underlying origin collapse to ONE evidentiary role even across different source classes," operationalised by the EXISTING `independence basis` field in research-extract-creator/SKILL.md (field + its 4 values independently-observed / same-underlying-dataset / same-press-release / unclear are already in canonical, lines 104-117); a claim resting on ≥2 collapsing channels downgrades to PROXY-SUPPORTED. This is an ADDITIVE clause to an existing rule, not a new gate.
(P2) Reconcile the stale deferred-list note in stage-instructions.md:42 — it currently lists 3 deferred Pass-1 items; mark local-language passes (→S-04), non-substitution (→S-02), and directive-level country ordering (→S-03) as landed in research-prompt-creator (all three sections verified present in canonical research-prompt-creator/SKILL.md lines 145/150/151); only session-level country-first structure remains genuinely deferred. This corrects a now-false "still deferred" claim — documentation accuracy fix.
(P3) Add a NEW optional "Known-Unavailable-Evidence Register" section to known-limits.template.md — Purpose + 5-column schema (Evidence need / Why unavailable / Public proxy / Limit ref / Last-checked) + Stop rule (governs search effort, not claim grading) + one placeholder row. Domain-agnostic; matches the template's existing optional-section convention (e.g., "Asymmetric Blocking-Semantics Gap (optional)", "Project-Side Drift Note (optional)").

All three are genericized (no project-specific names/IDs — Bain/Preqin softened to "underlying benchmark figure", Nordic example softened to Project Config `Languages:` ordering, 9 PE table rows stripped to 1 placeholder).

Blast radius: all future projects deploying the research-workflow template, plus existing projects via /sync-workflow drift detection (these are reference docs under workflows/research-workflow/reference/, which projects instantiate by copy/symlink).

CONTEXT: This is the third attempt. The prior two (S4, S5 today) executed the promotion then rolled it ALL back as premature (operator ruling: promotion is end-of-project). The operator has now EXPLICITLY authorized this run, overriding the "after Notion" rule. No push this session — commits stay local.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/known-limits.template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md — exists (P1 dependency, already carries independence basis field)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists (P2 dependency, already carries S-02/S-03/S-04)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Three additive/corrective edits to canonical reference docs, each with confirmed existing consumers (so no speculative-abstraction violation) — but the change rests on one materially inaccurate propagation claim (`/sync-workflow` does not diff `reference/*.md` docs) and one cross-doc consumption-status contract that must be flipped in lockstep, which together require paired mitigations before landing.

## Consumer Inventory

Search terms used: `quality-standards.md`, `stage-instructions.md`, `known-limits.template`, `Known-Unavailable-Evidence Register`, `Source-Diversity Matrix`, `sync-workflow`, `triangulation`, plus the P1 contract marker `independence basis`. Raw cross-repo grep counts were high (e.g. `quality-standards.md` 1141 hits) but dominated by prior risk-check audits under `ai-resources/audits/` and project log/scratchpad noise; the rows below are the distinct *functional* consumers of the three edit targets and the contracts they touch.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/skills/research-extract-creator/SKILL.md (lines 104-117, 117) | parses (P1 — defines the `Independence basis` field + 4 values that P1 operationalises; line 117 "Consumption status" gates cross-class collapse on the project carrying the clause) | yes |
| ai-resources/skills/cluster-memo-refiner/SKILL.md (Check 9) | parses (applies Source-Diversity Matrix / claim-permission downgrade — consumes the rule P1 strengthens) | no |
| ai-resources/skills/claim-permission-gate/SKILL.md | parses (references Source-Diversity Matrix) | no |
| ai-resources/workflows/research-workflow/reference/claim-permission.template.md | documents (per-claim-type Source-Diversity Matrix table lives here; chassis in quality-standards points to it) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md | invokes (cluster pass that reads the matrix rule) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md | invokes (sufficiency pass referencing the matrix) | no |
| ai-resources/skills/research-prompt-creator/SKILL.md (line 140) | parses (P3 — already names `reference/known-limits.md § Known-Unavailable-Evidence Register` as the fast-lane step-2 anchor, with a graceful-absent contract at line 143) | no |
| ai-resources/skills/execution-manifest-creator/SKILL.md (line 169) + references/manifest-template.md (line 31) | parses (P3 — already names the `Known-Unavailable-Evidence Register` section as the paywall-classification anchor, with loud degraded-mode note when absent) | no |
| ai-resources/.claude/commands/sync-workflow.md | (claimed) propagation channel — but scope is `.claude/commands|agents|hooks` + `reference/skills/` ONLY; does NOT diff `reference/*.md` docs (sync-workflow.md lines 36-46, 80) | no |
| projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md | co-edits (project-local COPY — the source of these deltas; already carries the cross-class clause per extract-creator line 117) | no (already has it) |
| projects/buy-side-service-plan/reference/quality-standards.md | co-edits (project-local COPY, 3 KB / Apr 20 — much older/smaller shape; will NOT auto-update) | no (manual, if ever) |

Total: 11 distinct consumers, 1 must-change (`research-extract-creator/SKILL.md` line 117 — the consumption-status contract).

Notes on the inventory:
- **P3 is NOT a consumer-less new contract.** Both `research-prompt-creator` (line 140, step 2 of the Tier-B/C fast-lane audit) and `execution-manifest-creator` (line 169) already name `reference/known-limits.md § Known-Unavailable-Evidence Register` by exact section heading and path, each with an explicit graceful-absent contract. P3 adds the *template* section those two skills already point at — two confirmed consumers exist. This is decisive for Dimension 6.
- **Project copies, not symlinks.** Both project `quality-standards.md` files are plain files of differing sizes/dates (24 KB Jun 8 vs 3 KB Apr 20) — instantiation is by copy. Editing the canonical template does not change any deployed project.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the three edits touch an always-loaded file. The targets are `workflows/research-workflow/reference/*.md` — loaded only when a project is actively running the relevant research stage, per the project CLAUDE.md instruction "Only load these when actively working on the relevant stage or task."
- No hook, `@import`, subagent brief, or skill-description trigger is added or widened. P1 is one clause appended to an existing § (quality-standards.md:191); P2 edits one note line (stage-instructions.md:42); P3 adds one optional section to a template (known-limits.template.md), matching the existing optional-section convention at lines 73-83.
- Token delta is pay-as-used and small (P1 ~1 sentence + a downgrade clause; P3 ~one schema + placeholder row).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` change. No new tool family, Write path, Bash pattern, external API, or MCP access. The change is content edits to three markdown reference files under `ai-resources/`, a directory the session already edits.
- No settings-scope change (no project→user move, no settings.json touch).

### Dimension 3: Blast Radius
**Risk:** Medium

Grounded in the Step-1.5 inventory: 11 consumers, 1 must-change.

- **The one must-change is a cross-doc contract.** `research-extract-creator/SKILL.md` line 117 ("Consumption status") states the cross-class collapse is "active in any project whose `reference/quality-standards.md § Source-Diversity Matrix` carries the cross-class collapse clause … not yet promoted to the canonical workflow template." P1 lands that clause in the canonical template, so the "not yet promoted to the canonical workflow template" statement in line 117 becomes false the moment P1 lands. That sentence must be updated in lockstep, or the canonical skill will carry a self-contradicting status note.
- **Contract change is backwards-compatible by construction.** P1 is additive (existing same-class sentence stays; cross-class clause is appended) and is operationalised by the `Independence basis` field that is *already* canonical (extract-creator lines 104-117). Downstream matrix consumers (`cluster-memo-refiner` Check 9, `claim-permission-gate`, `run-cluster`, `run-sufficiency`) read the rule shape and degrade gracefully — none requires modification to keep working.
- **P3 lands behind two existing consumers** (`research-prompt-creator` line 140, `execution-manifest-creator` line 169), both of which already carry graceful-absent contracts — so adding the template section cannot break them and satisfies a real demand surface.
- **Deployed projects are NOT auto-affected.** Both project instances are copies, not symlinks; `git revert`/edit of the canonical template changes neither. New-project deployments pick up the new shape; that is the intended, bounded propagation.
- **One CHANGE_DESCRIPTION claim is inaccurate and inflates the apparent blast radius the wrong way** — see Dimension 5 (`/sync-workflow` does not diff `reference/*.md`).

### Dimension 4: Reversibility
**Risk:** Low

- All three are single-file content edits to version-controlled markdown; `git revert` restores prior state cleanly within the working tree. The prior two attempts (S4, S5) were in fact rolled back, demonstrating clean reversibility in practice (commit history: "promotion executed then ROLLED BACK").
- No log/registry append, no settings mutation, no external write. CONTEXT explicitly states "No push this session — commits stay local," so state does not propagate beyond the local repo and a revert needs no remote coordination.
- One caveat keeping this from being trivially Low-with-no-note: the paired edit to `research-extract-creator/SKILL.md` line 117 (and the project-side `improvement-log.md` deferred-promotion entry, if it exists) must be reverted together with P1 — a multi-file revert, but still a clean `git revert` of the same commit set. Bundle all edits into one commit so revert is atomic.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Inaccurate propagation claim.** CHANGE_DESCRIPTION asserts existing projects pick this up "via /sync-workflow drift detection." `sync-workflow.md` builds inventories only for `.claude/commands|agents|hooks` (lines 36-46) and optionally `reference/skills/` (line 80); it does NOT compare `reference/*.md` docs. So `/sync-workflow` will silently NOT detect this drift in `buy-side-service-plan` or any other deployed project. The mental model behind the change is wrong about how existing projects would receive it — they will not, absent a manual copy. This is a hidden-coupling finding: a relied-upon mechanism does not do what the change assumes.
- **Lockstep consumption-status contract (P1).** The cross-class collapse behaviour is gated, in `research-extract-creator` line 117, on the project's quality-standards carrying the clause, and that same line documents the canonical-template promotion status. Landing P1 without flipping line 117 leaves an implicit, now-false dependency note inside an always-relevant Stage-2 skill — exactly the silent-drift pattern OP-11/OP-3 warn about.
- **Back-validation rule rides along (P1).** Line 117 also states: "when a project lands the cross-class clause, the activating edit MUST include a back-validation pass over any extracts already carrying basis tags." Promoting to the *template* is not landing in a project, so the template edit itself triggers no back-validation; but any project that later instantiates the new template inherits this obligation. Worth a one-line note in the template clause so the obligation is not lost.
- P3 coupling is benign — the contract (section name + path) is already documented at both consumer sites with graceful-absent handling, so adding the template section reduces (does not add) hidden coupling.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.

- **OP-9 / DR-7 / AP-7 (speculative abstraction) — NOT violated, and this is the load-bearing finding.** DR-7 licenses generalization only on a *second confirmed consumer*. P3's section has two confirmed canonical consumers already pointing at it by exact heading (`research-prompt-creator` line 140, `execution-manifest-creator` line 169). P1 operationalises a field (`Independence basis`) that is already canonical and already consumed by `cluster-memo-refiner` Check 9. P2 is pure documentation correction. None of the three builds a "hook for later" — each closes an existing forward-reference. This is the inverse of speculative abstraction.
- **OP-12 (closure before detection) — served, not violated.** P2 closes a now-false "still deferred" claim. P3 closes a dangling forward-reference (two skills naming a template section that did not yet exist in canonical). P1 strengthens an existing grading rule rather than adding a new detector. The change consolidates; it does not add unbacked detection.
- **OP-5 (advisory vs enforcement) — no upgrade.** P1's downgrade-to-PROXY-SUPPORTED is the same grading mechanism the matrix already runs (advisory grading applied at Pass 3), not a new auto-correcting enforcement authority. P3's Stop rule explicitly "governs search effort, not claim grading," so it does not silently upgrade grading.
- **DR-1 / DR-3 (placement) — correct tier and home.** Promotion moves a proven project-local delta into the canonical `ai-resources/workflows/` template — the canonical tier per DR-1 ("could this serve more than one project?" — yes, all future research projects). Reference-doc edits stay in reference docs (DR-5: no methodology pushed into CLAUDE.md).
- **OP-11 / OP-3 (loud revision) — applies as a HOUSEKEEPING obligation, not a violation.** The change does not revise a principle. But it DOES change a recorded status note (extract-creator line 117 "not yet promoted to the canonical workflow template"). Updating that note in lockstep is the *loud* way to land this; leaving it stale would be silent drift. Handled in Mitigations.
- **DR-8 process note (context, not a risk score):** DR-8 requires `/risk-check` for gated structural changes and the verdict is binding — this review is that gate. The operator's explicit authorization overrides the "promotion is end-of-project / after Notion" timing rule, which is an operator scheduling decision, not a principle revision; it does not itself create a Dimension-6 risk.

### Dimension 6 verdict note

Dimension 6 is Low: the change actively serves OP-12, DR-1/DR-3, and the DR-7 second-consumer test, and revises no principle. The only OP-11 touch is a status-note sync, addressed as a mitigation rather than a redesign.

## Mitigations

- **(Dimension 3 / Dimension 5 must-change — P1 lockstep edit.)** In the SAME commit as the P1 clause, update `ai-resources/skills/research-extract-creator/SKILL.md` line 117 so the "Consumption status" note no longer says the cross-class collapse is "not yet promoted to the canonical workflow template" — change it to reflect that the canonical template now carries the clause (so any fresh deployment activates the consumption by default). Without this, the canonical skill ships a self-contradicting status note.
- **(Dimension 5 — correct the propagation claim before relying on it.)** Do NOT rely on `/sync-workflow` to push these reference-doc edits into existing projects — it diffs only `.claude/commands|agents|hooks` and `reference/skills/`, not `reference/*.md` (sync-workflow.md lines 36-46, 80). Either (a) accept that only NEW deployments inherit the change and state that explicitly in the promotion record, or (b) if `buy-side-service-plan` should receive it now, do a deliberate manual copy and log it — do not assume drift detection will surface it.
- **(Dimension 5 — carry the back-validation obligation into the template clause.)** Add a one-line note to the promoted P1 clause that a project ACTIVATING this clause must back-validate any extracts already carrying `Independence basis:` tags (mirroring extract-creator line 117), so the obligation is not lost when a project later instantiates the new template.
- **(Dimension 4 — atomic revert.)** Land P1 + its line-117 lockstep edit + P2 + P3 as ONE commit so a future `git revert` undoes the whole promotion cleanly, as the two prior attempts were able to do.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (quality-standards.md:191; stage-instructions.md:42; research-extract-creator/SKILL.md:104-117, 117; research-prompt-creator/SKILL.md:140, 143; execution-manifest-creator/SKILL.md:169; sync-workflow.md:36-46, 80; known-limits.template.md:73-83), grep counts and dedup file lists, `ls -la` symlink-vs-copy verification, principle IDs from `principles-base.md` (OP-5/OP-9/OP-11/OP-12, DR-1/DR-3/DR-7/DR-8, AP-7), and verbatim quotes from CHANGE_DESCRIPTION and the referenced files. No training-data fallback was used on any read.
</content>
</invoke>

## Architectural Commentary

_System-owner second opinion (`system-owner` agent invoked directly per the decisions.md S3 standing posture — `/consult` carries `disable-model-invocation` and bounces; Function B pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-09-risk-check-second-opinion-promote-3-research-methodology-deltas.md`._

**Concur with PROCEED-WITH-CAUTION and all four mitigations.** `research-extract-creator/SKILL.md:117` literally says the cross-class consumption is "not yet promoted to the canonical workflow template" — promoting P1 without the same-commit line-117 edit ships a canonical chassis that contradicts its own operationalising skill (two-end-contract break, `risk-topology.md § 5`). Mitigation 1 is required, not polish.

The `/sync-workflow` correction is right and material: `/sync-workflow` does not propagate `reference/*.md`; workflow templates are graduated via `/graduate-resource`, not synced. Existing project copies + line-117 need manual handling.

**Under-weighted risk — P1 changes a grading rule the whole chassis inherits:**
1. P1 is not additive-in-effect: it downgrades collapsed-channel SUPPORTED claims to PROXY-SUPPORTED, so every future research project inherits a stricter evidentiary gate. Mitigation 3 must write the back-validation obligation into the promoted clause **as a deployment-time rule** (every inheriting project back-validates its own basis-tagged extracts), not as a one-time originating-project note.
2. Stricter inherited grading is a deliberate evolution of intent (OP-11 + OP-3): the commit message must state that promotion tightens the gate for all future research projects. Landing it quietly is the actual alignment risk, not P1 itself.

DR-7 satisfied (confirmed-consumer promotion). P2 (doc-accuracy) and P3 (matches optional-section convention) are low-risk; bundling into the atomic commit is fine.

**Open item — RESOLVED at gate time (main session):** the `[CITATION NEEDED]` on whether any other deployed project copy carries `Independence basis:` extract tags was checked — `grep -rl "Independence basis:" projects/` outside the originating project returns no real extract files (only this consultation artifact quoting the phrase). No other project has a back-validation surface; the obligation is forward-looking only.
