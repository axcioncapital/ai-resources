# Control Pack Schema

Canonical definition of the **control pack** — the multi-document scoping artifact produced by the `/scope-project` complex-build lane (via the `project-scoping` skill and its stage agents). This is the reference the `scope-qc-evaluator` agent evaluates against, and the contract the `project-scoping` skill drafts to.

A control pack is what a **complex** project produces at the scoping stage instead of a single context pack: a small set of governance documents (each governing one distinct decision, risk, workstream, or standard), plus a derived **planning brief** that hands the whole thing to `/plan-draft` in the exact shape that command already consumes.

This doc is the complex-lane parallel of two existing references:
- **`projects/project-planning/pipeline/ref-context-pack.md`** — the 11-element planning-brief shape the control pack's brief MUST conform to. This schema does not restate those 11 elements; it points to them and defines only how the brief is *derived* from the control pack.
- **`ai-resources/docs/context-pack-schema.md`** — the structural sibling (the Context Engine's pack contract). This doc follows the same "schema + citation discipline + worked example" pattern for a different artifact.

**Scope boundary.** This schema defines the *artifact*. The *process* that produces it (the 5 stages, operating principles, gates) lives in `ai-resources/skills/project-scoping/SKILL.md`. The *orchestration* (operator gates, agent delegation, adjunct wiring) lives in `ai-resources/.claude/commands/scope-project.md`. Edit each at its own home.

---

## 1. When a control pack is the right artifact

`/scope-project` is the **complex-build** lane. A control pack is justified only when the initiative has one or more of:

- multiple distinct workstreams,
- unclear or contested document architecture,
- meaningful technical or governance assumptions that need to be examined before planning,
- significant MVP-boundary risk (real danger of over-building),
- enough operational complexity that a single context pack would flatten load-bearing distinctions.

**Scale-to-project (the leanness governor).** If the project is small or low-risk, the control pack collapses to a single **one-page control note** (§5) — and that note *is* the planning brief. `/scope-project` actively recommends the light lane (`/context-builder`) and stops when the project appears simple, unless the operator overrides. Do not produce a full multi-document control pack for a small project.

---

## 2. Output layout

All outputs land in `projects/project-planning/output/{project-name}/` — the same directory `/plan-draft` reads. Every file is persisted durably to the repo (the repo is the source of truth; Notion stays manual per workspace rules).

```
projects/project-planning/output/{project-name}/
├── synthesis.md            # Stage-2 structured synthesis (promoted from working notes)
├── doc-architecture-map.md # Stage-3 document-architecture map
├── control-pack/           # Stage-4 multi-document control pack (full path)
│   ├── {doc-1}.md
│   ├── {doc-2}.md
│   └── ...
│   — OR —
├── control-note.md         # Stage-4 collapse path (small projects): the one-page note
├── context-pack.md         # The derived planning brief (see §7). THIS is the /plan-draft handoff.
└── scope-qc-verdict.md     # Stage-5 consolidated QC report
```

A given run produces **either** `control-pack/` (full) **or** `control-note.md` (collapsed), never both. `context-pack.md` and `scope-qc-verdict.md` are always produced on a Ready-class verdict.

---

## 3. The control-document catalogue

Stage 3 selects which of these documents a project needs — it does **not** produce all of them by default. The catalogue is a menu, not a checklist. A separate document is justified **only** when it governs a distinct decision, risk, workstream, or standard (§4).

| Control document | Governs | Typical trigger |
|---|---|---|
| **Scope & MVP charter** | What is in / out; the MVP boundary; the first useful milestone | Always present (may be the whole one-page note for small projects) |
| **Strategy / rationale doc** | Why this exists; the business decision it serves; success definition | Business-framed initiative with a non-obvious "why now" |
| **Technical design doc** | Architecture, stack, data model, interfaces | Technically complex initiative; often produced via `/tech-consult` |
| **Governance / policy doc** | Rules, compliance, confidentiality, access, ownership | Regulated data, cross-team ownership, or sensitivity |
| **Risk & assumptions register** | Load-bearing assumptions + risks + their validation/mitigation | Meaningful unexamined assumptions or blocking unknowns |
| **Execution / roadmap doc** | Build order, dependencies, sequencing, what to defer | Multi-workstream builds with real ordering constraints |
| **Measurement doc** | How success is judged; metrics; acceptance signals | Initiatives whose success is not self-evident from the deliverable |

**Anti-proliferation rule (load-bearing).** The default answer to "should this be its own document?" is **no**. Merge related concerns into one document unless separation earns its keep. A control pack of seven thin documents is a Stage-3 failure, not thoroughness.

---

## 4. Document-architecture decision rules (Stage 3)

For each candidate document, the `scope-architecture-agent` applies this test. A separate document is justified **only if it passes at least one**:

1. **Distinct decision** — it governs a decision that a different person, at a different time, will need to make or revisit in isolation.
2. **Distinct risk** — it isolates a load-bearing risk or assumption whose validation is independent of the rest.
3. **Distinct workstream** — it maps to a build workstream that will be planned and sequenced separately.
4. **Distinct standard** — it defines an execution standard (a policy, a schema, an interface contract) that other documents or builds will reference.

If a candidate passes none, it is **merged** into the nearest document that does. If it passes but the project is small/low-risk overall, it collapses into the one-page control note (§5).

The map records, per document: its purpose, which of the four tests it passes, what it merges (if anything), whether it is deferred, whether it is the **authority document** (the one that wins on cross-document conflict), and whether the **planning brief draws from it**.

---

## 5. The one-page control note (collapse path)

For small / low-risk projects, Stage 3 collapses the whole pack to a single `control-note.md`. Required fields (all present, none placeholder):

- **Purpose** — what this builds and why now.
- **MVP** — the minimum that delivers value.
- **In scope** / **Out of scope** — both lists, both specific (the out-of-scope list is the higher-leverage of the two).
- **Key assumptions** — each with a one-line validation reason.
- **Known risks** — each with a one-line severity/mitigation note.
- **First useful milestone** — the first point at which someone gets real value (see §6).
- **Success criteria** — checkable pass/fail signals.

The one-page note **is** the planning brief for small projects — it conforms to the brief contract (§7) by covering the same intent at lower depth. No separate `context-pack.md` is derived; `control-note.md` is passed to `/plan-draft` directly.

---

## 6. Per-document required elements

Every full control document (§3) contains:

- **Purpose** — the decision/risk/workstream/standard it governs (one of the four §4 tests, named).
- **Scope** — what this document covers and, explicitly, what it does not.
- **Relationship to other documents** — which documents it depends on, feeds, or is authority over.
- **Decisions it governs** — the specific choices locked or open within its remit.
- **In / out** — its own scope boundary.
- **Risks & assumptions** — those local to its remit, each labeled (see epistemic discipline below).
- **Open decisions** — what is not yet settled, routed to the three-way ledger (§8).
- **Execution standards** — any standard downstream builds must honor.
- **First useful milestone** — REQUIRED. The first observable point at which the work delivers real value to a real user. Forces MVP discipline; prevents "big-bang" plans with no early payoff.
- **Planning relevance** — what the planning brief should carry forward from this document.

**Epistemic discipline (inherited from the context-pack tradition).** Reuse the Fact / Assumption / Unknown separation and authority tags from `ai-resources/skills/context-pack-builder/SKILL.md` — do not reinvent it. Every Fact carries a source; every Assumption a validation reason; every Unknown a blocking-impact tag. This is evaluated by `scope-qc-evaluator` per document.

---

## 7. The planning brief — THE handoff contract (pin this)

> **This section is the single canonical handoff contract.** The SKILL, the command, and the `scope-qc-evaluator` all defer to this section. Do not restate the contract elsewhere with different wording — a two-name/two-shape contract is itself a structural-risk signal.

The final stage emits **one planning brief** that hands the control pack to `/plan-draft`. The contract has three load-bearing parts:

**(a) Shape.** The brief conforms to the **11 elements of `projects/project-planning/pipeline/ref-context-pack.md`** (Objective, Background, Scope, Deliverable(s), Audience, Facts, Assumptions, Unknowns, Inputs Available, Constraints, Quality Criteria). It is a context pack in all but name. It **summarizes** the control pack in the 11-element shape and **points to** the supporting `control-pack/` files by path — it does **not** duplicate the full control-pack content inside one file (keeps the brief lean).

**(b) Name & location.** The brief is written to `projects/project-planning/output/{project-name}/context-pack.md`. This is the canonical filename the workspace already uses for `/plan-draft` input.

**(c) Invocation — by explicit path, not by filename discovery.** `/plan-draft` (`projects/project-planning/.claude/commands/plan-draft.md:7`) takes `$ARGUMENTS` = *a path to a context pack file* and validates by **content markers** ("structured sections like Project Purpose, Scope, Constraints, or similar context-pack markers"), **not** by the filename. Therefore:
- The handoff is verified by running **`/plan-draft {path-to-context-pack.md}`** with the explicit path — never by assuming `/plan-draft` will discover the file by name.
- The 11-element shape (a) is what makes validation pass; the filename (b) is convention, not contract. Getting the *content shape* right is load-bearing; the filename is not.
- **Marker-robustness (do not skip):** `/plan-draft` validates by scanning for markers "Project Purpose, Scope, Constraints, or similar context-pack markers." The 11-element shape names element 1 "Objective" (not "Project Purpose"), so the handoff must not rely on that one marker alone — it carries the **`Scope`** and **`Constraints`** headings verbatim (elements 3 and 10), guaranteeing at least two of `/plan-draft`'s three named markers always match. This is what makes the "or similar" tolerance a floor, not a single point of failure. (`/plan-draft` is not modified to accept "Objective" — that would touch a working critical command; the brief conforms instead.)

**(d) Execution route (additive metadata field — governs downstream scaffolding weight).** The brief carries a single line, **`**Execution route:** direct`** or **`**Execution route:** engineered`**, decided from *required machinery and risk*, not deliverable format: `engineered` when the project needs durable engineering machinery or material technical risk — shared state, integrations, deployment, coordinated/automated testing, or comparable lifecycle complexity; otherwise `direct`. **Executable code alone is not an `engineered` trigger.** `/new-project` reads this line to choose the lightweight (`direct`) or full (`engineered`) creation path. If the field is absent, malformed, or any value other than the exact literal `direct`, `/new-project` treats the project as `engineered` (fail-safe to full) and asks the operator once. Additive per §11 — consumers that do not read it ignore it silently.

**Zero-touch handoff test (Fresh Claude Test).** The handoff succeeds when `/plan-draft {brief-path}` produces a coherent first draft **without reopening settled strategy, scope, MVP, or document-architecture decisions**. Legitimate detail-level clarifying questions are acceptable; reopening settled scope is the failure. `/plan-draft` receives **no code change** — the brief meets its existing input contract.

For small projects, `control-note.md` (§5) is the brief and is passed to `/plan-draft` the same way (explicit path).

---

## 8. Consolidated QC — verdict and ledger (Stage 5)

The `scope-qc-evaluator` produces one consolidated report (`scope-qc-verdict.md`) across four dimensions, mirroring the `context-evaluator` contract:

**Four review dimensions:**
1. **Document Fit** — right documents present, nothing missing or redundant, no cross-document contradictions.
2. **Value & Feasibility** — worth building? MVP proportionate? Includes the **manual-before-automated check**: should any part stay manual / template / prompt-based before automating? Automate only where it cuts operator burden, improves consistency, or prevents recurring errors.
3. **Assumptions, Risks & Contradictions** — epistemic discipline intact; load-bearing assumptions surfaced and validated or flagged.
4. **Roadmap & Prioritisation** — build order, dependencies, first useful milestone, what to defer.

**Findings severity:** CRITICAL / MAJOR / MINOR (same semantics as `context-evaluator`).

**Five-way readiness verdict** (QC can stop an idea, not only improve it):
- `Ready` — proceed; emit the brief.
- `Ready with Revisions` — proceed after bounded revision; emit the brief.
- `Reduce Scope` — the idea is over-built; cut scope, then emit a reduced brief.
- `Park` — useful later, not now; **stop, persist the verdict, do not emit a brief.**
- `Do Not Build` — not valuable/feasible/proportionate enough to justify planning; **stop, do not emit a brief.**

**Three-way decision ledger** (carried into the brief where relevant):
- `Locked` — settled; preserve downstream (carried into the brief).
- `Open` — tracked; not yet settled.
- `Operator` — needs human judgment; must **not** be silently resolved.

Residual post-revision issues split into **Blockers / Tracked non-blockers / Deferred**.

**Value-verdict ownership (integration seam — do not blur).** The **orchestrator** owns reconciliation of the value verdict, not the evaluator. The `scope-qc-evaluator` returns its independent document-QC findings **and** a proposed five-way verdict. For non-trivial projects the orchestrator optionally runs `/implementation-triage` (chat-only, ROI verdict `WORTH-DOING` / `MARGINAL` / `NOT-WORTH-DOING`) and folds that ROI call in as **one input** to the value verdict — it *informs* Park / Do-Not-Build but does **not** override the evaluator's document-QC judgment. The triage verdict is recorded into `scope-qc-verdict.md` alongside the evaluator's. So the evaluator never depends on triage output and stays focused on document QC.

**Bounded remediation.** Revise once; the loop does not run indefinitely. On `Ready` / `Ready with Revisions` / `Reduce Scope`: emit the brief + finalize the pack. On `Park` / `Do Not Build`: stop and persist the verdict — do not emit a brief.

---

## 9. Existing-capability check (pre-brief)

Before the brief is emitted, run a **scan** (not a full audit) for repo skills / templates / commands / workflows that already solve part of the problem. The brief must **prefer reuse / adaptation / orchestration** of existing capabilities over new build work, and name what it found. One bounded pass — like `/context-builder`'s thinness pre-check, not a `/repo-dd`.

---

## 10. What the schema does NOT carry

- **The 11 planning-brief elements themselves.** Owned by `ref-context-pack.md`; this schema only defines derivation (§7).
- **The stage process / operating principles.** Owned by the `project-scoping` SKILL.
- **Operator-gate orchestration and adjunct wiring.** Owned by `scope-project.md`.
- **Any change to `/plan-draft`.** The brief meets `/plan-draft`'s existing input contract; that command is not modified.
- **Per-domain control-doc templates** (frontend/backend/hosting/data specializations). v2 concern; v1 ships one generic control-document structure (§6).
- **Automation / hooks.** `/scope-project` is operator-invoked only.

---

## 11. Versioning and changes

This is v1 of the schema. Breaking changes (renamed required elements, changed handoff contract) require: (1) an update to the `project-scoping` SKILL and `scope-project.md` command; (2) an update to `scope-qc-evaluator`'s criteria; (3) a migration note in `logs/decisions.md`. Additive changes (new optional control-document types, new optional fields) do not require versioning — producers and the evaluator ignore unknown fields silently.
