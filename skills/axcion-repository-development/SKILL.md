---
name: axcion-repository-development
description: Choose the minimum sufficient workflow for creating or replacing an Axcíon repository, designing a new system, or developing a material multi-step repository capability. Use when the appropriate planning, build, proof, and integration route must be chosen. Do not use for routine bug fixes, isolated small changes with clear requirements, ordinary explanations or read-only reviews, or work already governed by a more specific skill.
---

# Axcíon Repository Development

Own one question: **What process does this systems-building project need now?**

Route execution to the specialized capability that owns it. Do not reproduce that capability's method here.

Follow repository-local `AGENTS.md`, operator decisions, safety rules, and release controls where they are more specific.

## Route the Project

1. **Define.** State the operating outcome: what must become possible, for whom, and why.
2. **Inspect.** Inspect repository and operating reality before proposing durable machinery. Test whether removal, an operating change, reuse, simplification, or a smaller intervention is sufficient.
3. **Choose the minimum current planning mode.**
   - **Clear after admission:** proceed to bounded implementation. Routine isolated changes with clear requirements should bypass this skill.
   - **Bounded uncertainty:** use `grill-with-docs` when available.
   - **Dependent decision fog:** use `wayfinder` when available. Resolve only material uncertainty, then return immediately to the ordinary path.
4. **Specify only if useful.** If a durable implementation specification materially improves coordination, route to `to-spec`; otherwise do not create one.
5. **Slice only if useful.** If multiple bounded vertical implementation slices materially improve execution, route to `to-tickets`; otherwise implement directly.
6. **Build.** Route bounded implementation to `implement`. Build useful vertical behavior through the real system and add infrastructure only when demonstrated behavior requires it.
7. **Prove.** Use the cheapest proof seam that genuinely demonstrates the claim. Route deterministic test-first work to `tdd`; use representative evals for AI judgment and representative acceptance cases for operator workflows.
8. **Review.** Route material implementation to `code-review`.
9. **Integrate.** Use the repository's existing Work Loop when present and its governing integration and release machinery. Do not redefine merge, deployment, or release controls here.
10. **Prove the operating job proportionately.** Require a representative real operating case for a new repository, MVP, or material capability. Implementation-level acceptance evidence may be sufficient for a small change inside an already-proven system.
11. **Use before expanding.** Put a new or material capability into real operation and let evidence determine subsequent development.

## Route Conditional Work

Use these only when the condition exists:

- Consequential human or product judgment: `grilling`
- Material terminology ambiguity: `domain-modeling`
- External factual uncertainty: `research`
- Concrete experiment needed to decide: `prototype`
- Non-trivial defect encountered during development: `diagnosing-bugs`

Use other named capabilities from the operating standard only when they are installed. Never claim to invoke an unavailable capability. If its absence blocks a material decision, surface the gap instead of inventing its procedure.

## Use Authority by Subject

- Decision records explain **why**.
- An active specification defines **intended behavior for its scoped change**.
- An active ticket defines **the current implementation slice and boundary**.
- Repository code and runtime describe **what currently exists**.
- Tests, evals, and other proof provide **behavioral evidence**.

Reconcile or escalate material contradictions. Do not resolve them through blind document precedence.

## Consult the Detailed Standard Conditionally

Read the relevant sections of [references/operating-standard.md](references/operating-standard.md) when:

- the correct mode or escalation path is unclear;
- deciding whether a specification, tickets, or permanent machinery are justified;
- defining a ticket contract, proof seam, review boundary, or operating proof;
- authorities conflict, scope may expand, or a stop condition may apply;
- the operator asks for the complete standard to govern the work.

Do not load the full reference when this router already determines the next action.

## Keep It Lean

Do not create artifacts for workflow compliance, duplicate specialized skills, absorb adjacent scope, keep planning machinery active after uncertainty clears, or add infrastructure without demonstrated current need.

At every decision point, prefer the smallest process and intervention that preserve intent, resolve material uncertainty, and credibly prove behavior.
