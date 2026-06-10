# Build-Ready Output Templates — Stages 4 → Final

Fixed structures for the production block (run as one continuous block after the decision gate). The Selection Memo (Stages 2–3) decides *what* to build; these templates make *how to build it* executable without reinterpreting the brief. Compress to fit, but keep each section's intent.

The non-negotiable quality bar across all four: **another capable person or AI builder can execute this without going back to the original brief.**

---

## Stage 4 — Specification

A build-ready spec. Required sections:

- **Scope statement** — one paragraph: what this build includes and explicitly excludes.
- **Functional requirements** — numbered, each a single testable capability ("FR-1: A visitor can submit name + email via a form; submission is stored and triggers a confirmation email").
- **Non-functional requirements** — performance, accessibility, privacy/data handling, browser/device support, SEO baseline, uptime expectations — only those that matter for this project.
- **Stack** — the confirmed tools per layer (frontend, data, automation, hosting), each tied back to the Selection Memo recommendation.
- **Data structure** — entities, fields, types, and relationships. For no-code, the table/base schema. For code, the model shape.
- **Modules / components** — the buildable units, each with a one-line responsibility.
- **Integrations** — every external connection (APIs, forms, email, payment), with direction of data flow.
- **Acceptance criteria** — the highest-leverage section. Per functional requirement, a testable pass condition ("AC-1: submitting the form with a valid email returns a success state and the row appears in the base within 5s"). Not "set up lead capture." A builder checks these off.

## Stage 5 — Roadmap

Ordered phasing, not a flat task list. Required sections:

- **MVP (v1)** — the smallest shippable version that delivers the core outcome. State explicitly what is **manual in v1**.
- **V1.1** — the first iteration after MVP proves the requirement.
- **Later phases** — what grows once validated.
- **Rejected-for-now bucket** — features/tools deliberately deferred, each with the reason (mirrors the Selection Memo's disqualification logic). This prevents scope creep and records *why* something was cut.
- **Workstreams (ordered)** — group tasks into streams and **sequence them with dependencies named**. Sequencing is where technical projects fail — order the work, don't just list it.
- **Risks** — per phase, the realistic failure mode and its mitigation.

## Stage 6 — QA

A pre-build / pre-launch checklist the operator (or builder) runs before going live. Required sections:

- **Pre-build checks** — confirm the spec is complete and the stack is provisioned before work starts.
- **Per-acceptance-criterion checks** — every AC from Stage 4 restated as a checkable line.
- **Pre-launch checks** — functional pass, data/privacy compliance, mobile/responsive, links/forms working, analytics firing, error states handled, backup/rollback if applicable.
- **Owner** — who runs each check (matters when the operator is a non-developer).

## Final — Builder Prompt

A handoff prompt a downstream builder (Claude Code / Cursor / a no-code operator) can execute directly. The builder-prompt output contract — it must contain:

- **Objective** — one line: what to build and for whom.
- **Stack & constraints** — the confirmed tools, and any hard constraints (budget, no-code-only, data rules).
- **What to build** — the modules/components from the spec, in build order.
- **Data structure** — the schema, restated so the builder doesn't need the full spec doc.
- **Acceptance criteria** — copied verbatim from Stage 4; these define "done."
- **Out of scope** — what NOT to build (from the rejected-for-now bucket), so the builder doesn't over-deliver.
- **First task** — the single concrete starting action, so execution begins without further planning.

Tailor the register to the target: a Claude Code/Cursor prompt can be denser and reference files; a no-code-operator prompt must be step-by-step and tool-specific.
