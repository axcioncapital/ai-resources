---
model: opus
---

# /scope-project — Complex-Build Scoping Orchestrator

You orchestrate the **complex-build** scoping lane: you turn early, messy material about a complex project into a **control pack** plus a `/plan-draft`-ready **planning brief**. You run Stages 0–5 with an operator gate between stages, delegate the heavy stages to three stage agents, draft the control documents in-session at Stage 4, and emit the brief at Stage 5.

Argument: `$ARGUMENTS` = project name and/or a path to raw material (optional; prompt if absent).

**Read the methodology first.** Read `ai-resources/skills/project-scoping/SKILL.md` (the process, operating principles, and stage definitions) and `ai-resources/docs/control-pack-schema.md` (the artifact contract — catalogue § 3, decision rules § 4, one-page note § 5, per-document elements § 6, the single canonical **handoff contract § 7**, and verdict/ledger § 8). These own the *what*; this command owns the *orchestration*. Do not restate their content — apply it.

This is the **complex** lane. The **simple** lane is `/context-builder`. Both converge at `/plan-draft`. `/scope-project` does not change `/context-builder`, `/plan-draft`, or any other pipeline command.

## Outputs

All artifacts land in `projects/project-planning/output/{project-name}/` (the directory `/plan-draft` reads). Confirm `projects/project-planning/` is mounted (`--add-dir`) before the first write there; if it is not, stop and ask the operator to mount it — the pack and brief cannot be written otherwise.

- `synthesis.md` (Stage 2) · `doc-architecture-map.md` (Stage 3) · `control-pack/` or `control-note.md` (Stage 4) · `scope-qc-verdict.md` (Stage 5) · `context-pack.md` (Stage 5, the brief).

## Gate Protocol

Between stages, present a one-paragraph summary of what the stage produced and pause for the operator:

- **`NEXT`** → proceed to the next stage.
- **`SKIP`** → valid only where a stage is explicitly optional (Stage 0 route recommendation; an adjunct). Marks it skipped and continues.
- **`ABORT`** → stop the workflow. Do not delete artifacts already written.

Track progress inline (which stage is done / in progress). This is an operator-gated workflow, not a silent run — the judgment gates (Stage 3, Stage 5) are where the operator's input matters most.

## Stage 0 — Route check

Decide the lane before doing any work.

1. If the material is a **fuzzy idea** (no concrete scope, notes, or brief), direct the operator to run `/grill-me` first, then re-enter with the resulting mandate brief. Do not try to scope a fuzzy idea.
2. Apply the **complex-build trigger** (SKILL § "When this fires"): multiple workstreams · unclear/contested document architecture · meaningful technical/governance assumptions · significant MVP-boundary risk · complexity a single context pack would flatten.
3. **If the project appears simple:** recommend the light lane (`/context-builder`), state briefly why, and **stop** — unless the operator explicitly overrides (`SKIP` this recommendation to proceed anyway). Do not overbuild a small project; scale-to-project is the governing principle.

Gate.

## Stage 1 — Idea scoping (input gather)

Collect the raw material: notes, a `/grill-me` brief, GPT/Claude conversation exports, Notion excerpts, stated risks and open questions. **Read-only intake** — inputs are references, never rewritten (File Write Discipline). Optionally, for a business-framed *and technically* complex initiative, point the operator to `/tech-consult` to produce a build-ready technical framing that becomes a technical control document. Exit when there is enough material to synthesize. Gate.

## Stage 2 — Notes consolidation (delegate)

Spawn the **`scope-synthesis-agent`** (sonnet). Pass it: the raw-material paths, the output path `projects/project-planning/output/{project-name}/synthesis.md`, and the project name. It writes the structured synthesis to disk and returns a ≤30-line summary + path (Subagent Contract — read the full file only if the summary flags something needing context). Present the summary. Gate.

## Stage 3 — Document architecture (delegate — key judgment gate)

Spawn the **`scope-architecture-agent`** (opus). Pass it: the `synthesis.md` path, the schema path `ai-resources/docs/control-pack-schema.md`, the output path `projects/project-planning/output/{project-name}/doc-architecture-map.md`, and the project name. It applies the four-test justification, resists over-documentation, and returns the map summary + path.

**Optional adjunct (architecturally-heavy projects):** point the operator to `/consult` (system-owner) to vet the document-architecture map — the same pattern `/new-project` uses at its architecture gate. Optional and gate-placed; skip for smaller projects.

This is the key judgment gate — present the map and the keep/merge/defer calls clearly. Gate.

## Stage 4 — Control-doc drafting (main session, skill-guided)

Draft each document **in the approved map** — and only those — using the per-document element set in `control-pack-schema.md` § 6. Apply epistemic discipline (Fact/Assumption/Unknown from `context-pack-builder`). Every document names its **first useful milestone**.

- **Bounded drafting:** if drafting reveals a genuinely missing document, **flag the gap and ask the operator to approve a map change** before adding it. Do not expand the map mid-draft.
- **Collapse path:** if Stage 3 recommended the one-page control note (small/low-risk project), write a single `control-note.md` (fields per schema § 5) instead of a full pack. The note *is* the brief.

Write to `control-pack/` (full) or `control-note.md` (collapse). Gate.

## Stage 5 — Consolidated QC + brief emission (delegate + reconcile)

1. **Delegate QC.** Spawn the **`scope-qc-evaluator`** (opus). Pass it: the control-pack path(s), `synthesis.md`, `doc-architecture-map.md`, the schema path, the brief-shape reference `projects/project-planning/pipeline/ref-context-pack.md`, the output path `projects/project-planning/output/{project-name}/scope-qc-verdict.md`, and the project name. It scores four dimensions, proposes a five-way verdict, and splits the three-way ledger — returning a ≤30-line summary + path.

2. **Value-verdict reconciliation (you own this — do not delegate it).** For non-trivial projects, optionally run **`/implementation-triage`** (chat-only ROI verdict: `WORTH-DOING` / `MARGINAL` / `NOT-WORTH-DOING`). Fold its ROI call in as **one input** to the value verdict — it *informs* Park / Do-Not-Build but does **not** override the evaluator's document-QC judgment. Record the triage verdict into `scope-qc-verdict.md` alongside the evaluator's proposed verdict. The evaluator stays focused on document QC; you reconcile.

3. **Optional pre-brief adjunct (larger projects):** run `/blindspot-scan` on the control pack (adversarial real-usage/stale-prerequisite pass — a different class than QC). Optional and gate-placed.

4. **Existing-capability check (pre-brief).** Run one bounded scan (not a full audit) for repo skills / templates / commands / workflows that already solve part of the problem. The brief must prefer reuse / adaptation / orchestration and name what it found.

5. **Act on the reconciled verdict:**
   - `Ready` / `Ready with Revisions` / `Reduce Scope` → apply bounded remediation (**revise once**, not indefinitely), then **emit the planning brief** to `projects/project-planning/output/{project-name}/context-pack.md` per the handoff contract (`control-pack-schema.md` § 7): conform to `ref-context-pack.md`'s 11 elements, summarize the pack and point to the `control-pack/` files (do not duplicate), and for a collapsed project let `control-note.md` serve as the brief. The brief (or `control-note.md`) carries the **`**Execution route:**`** line (§ 7(d)): `engineered` only for durable engineering machinery or material technical risk (shared state, integrations, deployment, coordinated/automated testing, or comparable lifecycle complexity) — executable code alone is not a trigger; otherwise `direct`.
   - `Park` / `Do Not Build` → **stop, persist `scope-qc-verdict.md`, emit no brief.** Announce the stop and why. QC can stop an idea — this is a valid, valuable outcome.

## Handoff verification (before you declare done)

Verify the zero-touch handoff by the **content-shape contract, not the filename**: `/plan-draft` (`projects/project-planning/.claude/commands/plan-draft.md`) takes an explicit path argument and validates by content markers, not by discovering `context-pack.md` by name. Confirm the handoff by stating that `/plan-draft {output-path}/context-pack.md` would receive an 11-element brief it can draft from without reopening settled strategy / scope / MVP / document-architecture decisions. Do not modify `/plan-draft`.

## Failure behavior

- **Fuzzy idea:** route to `/grill-me`, stop.
- **Simple project:** recommend `/context-builder`, state why, stop unless overridden.
- **project-planning not mounted:** stop before any write there; ask the operator to mount it.
- **A stage agent errors or its references are unreachable:** surface the error, note which stage could not run, and pause — do not fabricate the missing artifact or silently skip a judgment gate.
- **`/implementation-triage` or an adjunct errors:** note it, proceed with the evaluator's proposed verdict (adjuncts are advisory; their failure must not block).
- **Material too thin to synthesize:** return to Stage 1; do not invent a synthesis.

Commit directly per workspace Commit behavior (no pre-commit checks); do not push (batched to `/wrap-session`).
