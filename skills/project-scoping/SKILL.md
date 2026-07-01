---
name: project-scoping
description: >
  Scopes a complex, multi-workstream project into a control pack + a
  /plan-draft-ready planning brief. Use when a build has multiple workstreams,
  unclear document architecture, meaningful assumptions, or MVP-boundary risk —
  the methodology behind /scope-project. Do NOT use for simple projects (use
  /context-builder); do NOT use for project execution or planning itself
  (that is /plan-draft downstream).
model: opus
effort: high
---

# Project Scoping (complex-build lane)

The methodology for turning early, messy material about a **complex** project into a **control pack** — a small set of governance documents — plus a **planning brief** that hands off to `/plan-draft` with zero rework. Read by the `/scope-project` command and its three stage agents (`scope-synthesis-agent`, `scope-architecture-agent`, `scope-qc-evaluator`).

This skill owns the **process**. Two companions own the rest — read them, do not restate them:
- **`ai-resources/docs/control-pack-schema.md`** — the control-pack *artifact* contract (catalogue, decision rules, one-page note, verdict/ledger, and §7 the single canonical handoff contract).
- **`projects/project-planning/pipeline/ref-context-pack.md`** — the 11-element shape the planning brief conforms to.

## When this fires (and when it must not)

`/scope-project` is the **complex-build** lane. Use it only when the initiative has one or more of: multiple distinct workstreams; unclear/contested document architecture; meaningful technical or governance assumptions to examine before planning; significant MVP-boundary (over-build) risk; enough operational complexity that a single context pack would flatten load-bearing distinctions.

**Scale-to-project is the governing principle.** If the project looks simple or low-risk, recommend the light lane (`/context-builder`), state briefly why, and stop — unless the operator explicitly overrides. Do not run the heavy workflow on a small idea; do not over-document. The default answer to "does this need its own document / its own stage / this adjunct?" is **no** until it earns a yes.

## Operating principles

Apply all five throughout every stage:

1. **Scale-to-project.** Match the weight of the process to the size of the project. Small → one-page control note (§ collapse path); large technical system → full control pack + adjuncts. Never the reverse.
2. **MVP discipline & first-useful-milestone.** Every control document names the **first observable point where the work delivers real value to a real user**. Plans with no early payoff are a scoping failure, not thoroughness.
3. **Manual-before-automated.** Before recommending automation (a command, script, hook), ask whether the part should stay manual / template / prompt-based for now. Automate only where it cuts operator burden, improves consistency, or prevents recurring errors.
4. **Reuse-first.** Prefer adapting or orchestrating existing repo capabilities (skills, templates, commands, workflows) over new build work. Scan for them (§ existing-capability check) and name what you found in the brief.
5. **Persist-outputs.** Every stage artifact is written durably to `projects/project-planning/output/{project-name}/` (the repo is the source of truth; Notion stays manual). No transient-only working notes for load-bearing synthesis.

## The five stages

The `/scope-project` command orchestrates these with an operator gate between stages (NEXT / SKIP / ABORT, mirroring `/new-project`). This skill defines what each stage *does*; the command defines the gates and delegation.

### Stage 0 — Route check
Decide the lane. If the idea is fuzzy, direct the operator to `/grill-me` first, then re-enter with the brief. Apply the complex-build trigger test above. If the project appears simple, recommend `/context-builder` and stop unless overridden. This stage prevents the workflow from overbuilding a small project.

### Stage 1 — Idea scoping (input gather)
Collect the raw material: notes, a `/grill-me` brief, GPT/Claude conversation exports, Notion excerpts, stated risks and open questions. **Read-only intake** — inputs are references, never rewritten (workspace File Write Discipline). Exit when there is enough material to synthesize.

### Stage 2 — Notes consolidation (→ `scope-synthesis-agent`)
Delegate to the synthesis agent. It produces a structured **synthesis** (`synthesis.md`): themes separated (strategy / scope / design / technical / governance / execution / measurement), confirmed vs. open split, weak / overbuilt / underdeveloped areas flagged, contradictions surfaced (not resolved). Operator gate.

### Stage 3 — Document architecture (→ `scope-architecture-agent`)
Delegate to the architecture agent. It produces the **document-architecture map** (`doc-architecture-map.md`): which control documents should exist, which merge, which defer, which is the authority document, which the brief draws from. It applies the **four-test justification** (below) and **actively resists over-documentation**. This is the key judgment gate — operator gate.

### Stage 4 — Control-doc drafting (main session, skill-guided)
Draft each document in the approved map — **only** the documents the map approved. Use the per-document element set in `control-pack-schema.md` § 6. **Bounded drafting:** if drafting reveals a genuinely missing document, flag the gap and ask the operator to approve a map change before adding it — do not expand the map mid-draft. **Collapse path:** when Stage 3 judged the project small/low-risk, produce a single one-page **control note** (`control-note.md`, fields per schema § 5) instead of a full pack; the note *is* the brief. Operator gate.

### Stage 5 — Consolidated QC + brief emission (→ `scope-qc-evaluator`)
Delegate consolidated QC. The evaluator scores four dimensions, proposes a five-way verdict, and splits decisions into the three-way ledger (schema § 8). The **orchestrator** owns the value-verdict reconciliation (optionally folding in `/implementation-triage`'s chat-only ROI call as one input — it informs, never overrides). On `Ready` / `Ready with Revisions` / `Reduce Scope`: run the existing-capability check, then **emit the planning brief** (`context-pack.md`) and finalize the pack. On `Park` / `Do Not Build`: **stop, persist the verdict, emit no brief.** Bounded remediation — revise once, not indefinitely.

## Document-architecture decision rules (Stage 3 core)

A separate control document is justified **only if it passes at least one** of four tests (full detail: schema § 4):

1. **Distinct decision** — governs a decision revisited in isolation, by someone, later.
2. **Distinct risk** — isolates a load-bearing risk/assumption validated independently.
3. **Distinct workstream** — maps to a workstream planned and sequenced separately.
4. **Distinct standard** — defines a policy/schema/interface other work references.

Passes none → **merge** into the nearest document that does. Passes but project is small → **collapse** into the one-page note. A pack of seven thin documents is a Stage-3 failure.

## Consolidated-QC checklist (Stage 5)

Four review dimensions: **Document Fit** (right docs, none missing/redundant, no contradictions) · **Value & Feasibility** (worth building? MVP proportionate? manual-before-automated check) · **Assumptions, Risks & Contradictions** (epistemic discipline intact) · **Roadmap & Prioritisation** (build order, dependencies, first useful milestone, what to defer).

**Five-way verdict:** `Ready` / `Ready with Revisions` / `Reduce Scope` / `Park` / `Do Not Build`. QC can **stop** an idea, not only improve it — `Park` and `Do Not Build` emit no brief. **Three-way ledger:** `Locked` (carried into the brief) / `Open` (tracked) / `Operator` (needs human judgment — never silently resolved).

## Epistemic discipline (reused, not reinvented)

Reuse the Fact / Assumption / Unknown separation and authority tags from `ai-resources/skills/context-pack-builder/SKILL.md`. Every Fact carries a source; every Assumption a validation reason; every Unknown a blocking-impact tag. Do not build a parallel labeling scheme.

## The planning brief (handoff)

The brief is the one artifact that hands the control pack to `/plan-draft`. Its contract is **single-sourced in `control-pack-schema.md` § 7** — do not restate it here with different wording. In one line: the brief conforms to `ref-context-pack.md`'s 11 elements, is written to `output/{project}/context-pack.md`, and is verified by running `/plan-draft {explicit-path}` — the contract is the **content shape**, not the filename. The zero-touch test: `/plan-draft` produces a coherent first draft without reopening settled strategy / scope / MVP / document-architecture decisions.

## Existing-capability check (pre-brief)

Before emitting the brief, run one bounded **scan** (not a full audit) for repo skills / templates / commands / workflows that already solve part of the problem. The brief must prefer reuse / adaptation / orchestration and name what it found.

## Known pitfalls

- **Over-documentation.** The most common failure. When unsure whether a document earns its place, apply the four-test and default to merge.
- **Re-compressing the pack.** Do not route the full control pack back through `/context-builder` — that squeezes a rich multi-doc pack into one context pack and loses detail. The brief summarizes and points; it does not duplicate.
- **Filename-not-shape handoff.** Verifying the handoff by assuming `/plan-draft` finds `context-pack.md` by name — it does not (it takes an explicit path and validates by content). Always test with the explicit path.
- **Unbounded Stage 4.** Drafting new documents mid-stage that the Stage-3 map did not approve. Flag and gate instead.
- **QC that only improves.** Forgetting that `Park` / `Do Not Build` are valid, valuable verdicts.

## Worked example — the Stage-3 four-test (the highest-judgment step)

Candidate document: **"Governance / policy doc"** for a CRM build.
- *Distinct decision?* The CRM shares its contact-ownership rules with the future email machinery → **passes** (a decision another system will revisit in isolation).
- *Distinct risk / workstream / standard?* Also defines the access-control standard other systems reference → passes test 4 too.
- **Verdict:** keep as its own document; mark it a **standard** the planning brief draws from.

Contrast — candidate **"Measurement doc"** for the same build, where success is just "sales team uses it daily":
- Passes no test in isolation (the metric is one line, revisited with the scope charter, not separately).
- **Verdict:** **merge** into the Scope & MVP charter. A separate one-line measurement doc is over-documentation.

## Runtime recommendations

- **Model / effort:** `opus` / `high` — the load-bearing work (Stage 3 document architecture, Stage 5 value verdict) is judgment under ambiguity, not execution. The command and the two opus agents share this tier; `scope-synthesis-agent` runs `sonnet` (consolidation is doing, not deciding).
- **Context posture:** this is a **long, multi-stage, multi-agent** session. The orchestrator (`/scope-project`) runs in the main session and holds the operator gates; Stages 2, 3, and 5 delegate to stage agents that write full notes to disk and return ≤30-line summaries (Subagent Contract), so the main session stays lean. Follow `ai-resources/docs/compaction-protocol.md` named checkpoints on long runs.
- **Invocation control:** this skill is driven by `/scope-project` and its stage agents — it is not intended for free model auto-invocation, and it has real side effects (writes durable artifacts to `output/{project}/`). It declares no `allowed-tools` restriction (it needs Read + Write across the two mounted repos) and no `paths` scope (it is a methodology skill with no file-glob trigger — invocation is command-driven, not path-driven).

**Stage → artifact → schema section** (the output-shape map; content shapes are single-sourced, not restated here):

| Stage | Artifact | Shape defined in |
|---|---|---|
| 2 | `synthesis.md` | `scope-synthesis-agent` output block |
| 3 | `doc-architecture-map.md` | `scope-architecture-agent` output block; rules in `control-pack-schema.md` § 4 |
| 4 | `control-pack/*.md` **or** `control-note.md` | `control-pack-schema.md` § 6 (full) / § 5 (collapse) |
| 5 | `scope-qc-verdict.md` | `control-pack-schema.md` § 8 |
| 5 | `context-pack.md` (the brief) | `ref-context-pack.md` (11 elements); handoff contract `control-pack-schema.md` § 7 |

## Failure behavior

- **Project looks simple:** recommend `/context-builder`, state why, stop. Do not run the heavy workflow to justify itself.
- **Material contradicts itself:** surface the contradiction in the synthesis; do not silently pick a side (workspace Design Judgment Principles).
- **Blocking unknown, operator declines to resolve:** flag it in the brief as an `Operator` ledger item and a blocking-impact `Unknown`; do not fabricate the missing fact.
- **Insufficient material to synthesize:** say so and return to Stage 1; do not invent a synthesis from a thin input.
- **A candidate document passes no test:** merge it; do not create it to be safe.

Prefer admitting a gap over inventing plausible detail. If the operator's premise contains an error (e.g., a "simple" project that is actually multi-workstream, or vice versa), flag it constructively. Accuracy over comprehensiveness.
