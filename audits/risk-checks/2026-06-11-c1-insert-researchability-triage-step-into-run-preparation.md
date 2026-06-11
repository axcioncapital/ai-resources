# Risk Check — 2026-06-11

## Change

C1 — Insert a Researchability Triage step into run-preparation.md: add new Step 3c between the Research-Plan QC gate (Step 3b) and answer-spec generation (Step 4). The step reads the approved research plan + reference/known-limits.md + reference/source-map.md + Project Config Source-availability posture and classifies each RQ into one of four routes (web-answerable / proxy-only / structurally-unavailable / internal-import). Only web-answerable and proxy-only RQs proceed to Step 4 answer-spec generation; structurally-unavailable routes to the Evidence Boundary Register; internal-import routes to firm-held intake. Emits a triage table to preparation/checkpoints/{section}-step-3c-triage.md. Operator reviews triage at the existing Stage-1 gate before answer specs are written. Also update reference/stage-instructions.md Stage 1 bullet list and reference/known-limits.md How-to-Use Stage-1 pointer. File: projects/positioning-research/.claude/commands/run-preparation.md, reference/stage-instructions.md, reference/known-limits.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/.claude/commands/run-preparation.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/reference/known-limits.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A self-contained, fully reversible project-local edit with no permission/token cost, but it materially overlaps the existing Step 3b researchability QC dimension (Dimension 5 / OP-5 tension), and is retroactive for a Section 1.1 run already in Stage 3/4 — both manageable with explicit mitigations.

## Consumer Inventory

Search terms: `run-preparation`, `known-limits`, `source-map`, `stage-instructions`, `step-3c`, `Researchability`, `Step 3c`, `triage`. Searched across `ai-resources/` and the workspace root (`projects/`). Historical artifacts (audits/, logs/, inbox/, generated context-packs, and per-section work products under `execution/`, `analysis/`, `report/`) are excluded from the runtime-consumer set — they are records, not parsers of the changed contract. Three change targets are all plain files (not symlinks); the project `run-preparation.md` has already diverged from the canonical workflow template (project copy dated 2026-06-11, 5657 bytes; canonical `ai-resources/workflows/research-workflow/.claude/commands/run-preparation.md` dated 2026-04-27, 4698 bytes), so this edit is project-local and does not propagate to the template or other projects.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/positioning-research/reference/stage-instructions.md | co-edits | yes |
| projects/positioning-research/reference/known-limits.md | co-edits | yes |
| projects/positioning-research/reference/source-map.md | imports (read by new Step 3c) | no |
| projects/positioning-research/.claude/commands/workflow-status.md | parses (reads stage-instructions.md, extracts per-stage step IDs/gates) | no |
| projects/positioning-research/.claude/commands/audit-structure.md | parses (reads stage-instructions.md folder/structure) | no |
| projects/positioning-research/.claude/commands/run-cluster.md | documents (references stage-instructions.md) | no |
| projects/positioning-research/.claude/commands/run-execution.md | documents (references stage-instructions.md) | no |
| projects/positioning-research/.claude/commands/wrap-session.md | documents (references stage-instructions.md) | no |
| projects/positioning-research/docs/required-reference-files.md | documents (names known-limits.md + stage-instructions.md roles) | no |
| projects/positioning-research/docs/project-config-schema.md | documents (Source-availability field the new step reads) | no |

Total: 10 consumers, 2 must-change (both named explicitly in CHANGE_DESCRIPTION as co-edits: stage-instructions.md Stage-1 bullet list, known-limits.md How-to-Use pointer). The two must-change consumers are anticipated by the change; no unanticipated must-change consumer surfaced. `source-map.md` is a new read-dependency (the step consumes it) but is not modified. `workflow-status.md` re-derives the Stage-1 step list dynamically from stage-instructions.md text (it does not hard-code step numbers), so an added Step 3c is rendered, not broken — confirmed by reading workflow-status.md Phase 1 (extracts `{list of step IDs and titles}` per stage). No command hard-codes the Stage-1 `3b → 4` adjacency as a contract; grep for `step-3b`/`3c`/`step-3-checkpoint` returns only run-preparation.md itself.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. The change edits a slash-command body (`run-preparation.md`), a stage-reference doc read only at stage start, and a project-reference doc — none are workspace/project CLAUDE.md and none are `@import`-ed every turn. stage-instructions.md self-declares "Not needed for every turn" (stage-instructions.md:3).
- No hook registered. The new step runs only inside `/run-preparation` (a Sonnet command per its frontmatter, `model: sonnet`, run-preparation.md:3), invoked once per section at Stage 1 — pay-as-used, not per-session or per-tool-call.
- New Step 3c adds one in-line classification pass reading 3 already-available inputs (research plan, known-limits.md, source-map.md, all <5KB) plus one Project Config field. Marginal token cost falls inside an already-heavy preparation command and is incurred only when the command runs.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` change. The change is content-only (markdown edits to a command and two reference docs). No new Bash pattern, Write path, external API, or MCP surface introduced.
- The one new Write target — `preparation/checkpoints/{section}-step-3c-triage.md` — sits inside the existing `preparation/checkpoints/` directory that the command already writes checkpoints to (e.g., run-preparation.md:17, :41, :50). No new write scope is opened.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consume Step 1.5 inventory: 10 consumers, 2 must-change. The 2 must-change (stage-instructions.md, known-limits.md) are both named in CHANGE_DESCRIPTION as co-edits — anticipated, in-lockstep, low surprise.
- Contract check (parses rows): `workflow-status.md` and `audit-structure.md` read stage-instructions.md. `workflow-status.md` Phase 1 extracts the per-stage step list dynamically (`{list of step IDs and titles}`, workflow-status.md:17) rather than against a fixed step count, so an inserted Step 3c is additively rendered, not a breaking parse. No backwards-incompatible contract change found.
- Shared-infra check: the change touches stage-instructions.md, which 7+ commands reference. But the edit is scoped to the Stage-1 bullet list only; Stage 2–5 text (the part those commands actually consume) is untouched. The blast is contained to the Stage-1 region.
- Retroactivity finding (drives the Medium): Section 1.1 is already past Stage 1 — `execution/`, `analysis/cluster-memos/`, `analysis/claim-permission/`, and `report/chapters/1.1/` artifacts exist on disk. Inserting a Stage-1 triage step now does not re-run for the in-flight section; it applies to the next section/run. The change description frames an insertion into the live pipeline but the only live project (positioning-research, Section 1.1) has already consumed Stage 1 — so for this project the step is effectively forward-only. Not a breakage, but a scope nuance the description does not call out.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are to version-controlled markdown; `git revert` fully restores prior state. No data/log mutation, no settings.json change, no external write, no push implied.
- The only new on-disk artifact is the triage checkpoint (`{section}-step-3c-triage.md`), a generated file under `preparation/checkpoints/`. A revert of the command body leaves a stale triage file behind — one trivial cleanup step (delete the generated checkpoint), not a multi-step rollback. This is the single extra step keeping it from a "nothing to clean up" Low-floor, but it stays Low because the residue is an inert generated file in an output dir, not propagated state.
- No hook/cron/symlink added that could fire between landing and revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Functional overlap with an existing mechanism (the driving finding). Step 3b's QC gate already evaluates researchability: dimension "(C) researchability: each question is answerable within the project's source-availability posture (Project Config `Source-availability:` field)" (run-preparation.md:48). The new Step 3c re-reads the same `Source-availability` posture and re-classifies each RQ by answerability one step later. Two adjacent steps now both judge "can this RQ be answered from available sources" — overlapping purpose. If Step 3b passes a research plan as APPROVED (all RQs researchable) and Step 3c then routes some RQs to structurally-unavailable, the two verdicts can disagree with no documented reconciliation rule.
- New read-dependency on source-map.md that is not yet documented at the dependency surface. known-limits.md (known-limits.md:5–11) and required-reference-files.md (required-reference-files.md:43–48) both enumerate which components read each reference file; neither lists source-map.md as a Stage-1 prep input, nor lists `run-preparation` as a consumer of known-limits.md. The change adds run-preparation.md as a new reader of both known-limits.md and source-map.md without updating those reverse-consumer maps — an undocumented new contract. (The description updates the known-limits.md *How-to-Use* pointer, which partially closes this for known-limits.md, but not the source-map.md side and not required-reference-files.md.)
- Implicit dependency on the four-route taxonomy mapping cleanly onto existing closure channels: the step assumes the Evidence Boundary Register and firm-held intake exist and accept the routed RQs. Those channels do exist in this project (`report/registers/1.1/1.1-evidence-boundary-register.md` is present), so the dependency is satisfied — but it is an assumed downstream contract, not one the step body verifies.

### Dimension 6: Principle Alignment
**Risk:** Medium

- principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present, 42 frozen-ID principles).
- OP-12 (Closure before detection): the change adds new *detection* (a researchability classifier) but wires each route to a *closing* channel — structurally-unavailable → Evidence Boundary Register, internal-import → firm-held intake, web/proxy → answer-spec generation. Detection ships behind existing closure channels, not ahead of them. This is OP-12-*aligned*, a point in the change's favor.
- OP-5 (Advisory vs enforcement) — the tension that drives the Medium: Step 3b is advisory (QC gate → operator approves/revises). The new Step 3c moves toward enforcement — it *gates* which RQs "proceed to Step 4," auto-routing structurally-unavailable and internal-import RQs *out of* answer-spec generation. The description does say "Operator reviews triage at the existing Stage-1 gate before answer specs are written," which keeps a human in the loop and pulls it back toward advisory. But the routing decision (which RQs are dropped from the answer-spec set) is made by the step, not surfaced as an operator choice — an advisory-to-enforcement edge that is not loudly named. Worth an explicit "operator can override any route" line.
- OP-9 / DR-7 / AP-7 (speculative abstraction): NOT triggered. The step has a confirmed live consumer (this project's pipeline) and solves a present need (avoiding answer-spec spend on un-answerable RQs); it is not a "hook for Phase 2." The inventory shows a real consuming pipeline, not an absent one.
- OP-10 (system boundary): not touched — the step stays inside Claude Code; it reads project files and routes within the project's own registers.
- DR-1 / DR-3 (placement): correct tier. The change is project-local (positioning-research), edits a project-local command and project reference docs; it does not belong in canonical because the project copy has already diverged from the workflow template. Placement is sound.
- Net: one real principle *tension* (OP-5 advisory→enforcement edge, not loudly acknowledged), no clear violation. Medium, not High — and not a High that blocks, because OP-12 alignment is a genuine plus and the operator-gate keeps the enforcement edge supervised.

## Mitigations

- **Dimension 5 (overlap):** Before landing, decide and document the Step 3b ↔ Step 3c relationship. Either (a) fold the four-route triage *into* Step 3b's existing researchability dimension (C) so a single step both QCs and routes — removing the duplicate judgment — or (b) if kept separate, add one line to Step 3c stating that it consumes Step 3b's APPROVED verdict as a precondition and that a Step 3c route conflicting with a Step 3b "researchable" pass is surfaced to the operator, not silently applied. Pick one; do not ship two adjacent steps that both judge answerability with no reconciliation rule.
- **Dimension 5 (undocumented read-dependency):** Update the reverse-consumer maps so the new dependency is visible at the dependency surface: add `run-preparation` (Stage 1) as a consumer of known-limits.md in known-limits.md's Authority/Loaded-by list and in `docs/required-reference-files.md`, and record source-map.md as a Stage-1 prep input. The change already edits the known-limits.md How-to-Use pointer — extend that edit to the Loaded-by block and add the source-map.md side.
- **Dimension 6 (OP-5 advisory→enforcement edge):** Add an explicit advisory-posture line to Step 3c: the triage table is a *recommendation*, the operator may re-route any RQ at the Stage-1 gate, and no RQ is dropped from answer-spec generation without that review passing. This keeps the routing operator-gated (OP-5/OP-2 compliant) rather than a silent enforcement upgrade.
- **Dimension 3 (retroactivity):** State in the Step 3c body (or the stage-instructions Stage-1 note) that the step applies to runs entering Stage 1 fresh; for a section already past Stage 1 (Section 1.1), the step is forward-only and is not retro-applied to in-flight answer specs. Removes the scope ambiguity between "insert into the live pipeline" and the actual forward-only effect.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Routing:** Land C1 project-local. The target (`run-preparation.md`) is a diverged project-local command; the two co-edited reference docs are project-local too. Zero blast radius beyond positioning-research's own sessions (`risk-topology.md § 3, § 5`) — no canonical-template touch, no sync. DR-7 satisfied by construction.

**Concurrence with PROCEED-WITH-CAUTION:** We concur. Self-contained and reversible, but two genuine tensions earn the caution:
- 3b/3c answerability overlap with no reconciliation rule — the AP-3 shape; two judges silently drift.
- 3c routes RQs *out of* answer-spec generation = an enforcement action; the Stage-1 gate is what keeps it on the right side of OP-5 (proposal, operator ratifies — not silent routing).

**Concurrence with the recommended path:** All four items required and correctly mapped — (1) resolve overlap *structurally* (make one judge canonical, state precedence; a comment is a patch, not a fix), (2) update reverse-consumer maps for the new `source-map.md` + `known-limits.md` read-dependency, (3) advisory-posture line = the OP-5 mitigation, (4) document retroactivity (forward-only effect on past-Stage-1 1.1) per OP-3 loud-over-silent.

**Risk the dimension review missed:** The classifier can silently re-decide a parked/gate-reopener RQ. The review covered the OP-5 *routing* edge but not the *classification-content* edge. A `structurally-unavailable` / `proxy-only` verdict on a flagship or gate-reopener-eligible RQ (RQ-A5, RQ-B5) or a parked buyer-core need is functionally an answerability re-decision — which the project's execution contract forbids ("gate-reopeners are proposals, never silent re-decisions"). Mitigation beyond the four: Step 3c must route any such RQ into the Gate-Reopener / Buyer-Validation Backlog register as a proposal, not drop it. Secondary: record 3c as a `Source-availability` consumer (GR-2 migration exposure).

**Position:** GO-under-caution — land project-local, execute all four mitigations plus the gate-reopener-routing mitigation before commit.

_Full advisory: projects/axcion-ai-system-owner/output/consultations/consult-2026-06-11-c1-researchability-triage-step-3c.md_

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references — run-preparation.md:3/:48, stage-instructions.md:3, known-limits.md:5–11, required-reference-files.md:43–48, workflow-status.md:17; grep counts and `ls -la` symlink/divergence checks; verbatim quotes from CHANGE_DESCRIPTION and referenced files; principle IDs OP-5/OP-9/OP-10/OP-12/DR-1/DR-3/DR-7/AP-7 cited from principles-base.md). No training-data fallback was used on fetch/read failures.
