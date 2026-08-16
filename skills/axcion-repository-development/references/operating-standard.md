# Axcíon Repository Development Operating Standard

## Contents

- Purpose and governing flow
- Define and inspect (sections 1–2)
- Operating modes and reversible escalation (sections 3–4)
- Planning capabilities, specifications, and tickets (sections 5–8)
- Vertical implementation and proof (sections 9–12)
- Review, authority, routing, and scope (sections 13–17)
- Permanent machinery, integration, and operating proof (sections 18–20)
- Use, future changes, stop conditions, and anti-overengineering (sections 21–24)
- Default paths, governing questions, and final standard (sections 25–27)

## Purpose

This standard governs how Claude Code, Codex and the operator develop new Axcíon repositories and material repository capabilities.

It is intentionally lean.

Its purpose is to help agents answer:

1. What operating outcome are we trying to achieve?
2. What already exists?
3. What level of planning is justified right now?
4. Which skill or capability should be used next?
5. What evidence will prove the behaviour works?
6. When should the work escalate, stop or return to a simpler mode?

The governing principle is:

> **Use the minimum process required to preserve intent, resolve material uncertainty and prove behaviour. Escalate only when the work demonstrates that more structure is necessary.**

The normal shape is:

```text
DEFINE
   ↓
INSPECT
   ↓
ROUTE
   ↓
PLAN — only as much as needed
   ↓
SPEC — if useful
   ↓
SLICE — if useful
   ↓
BUILD + PROVE
   ↓
REVIEW
   ↓
INTEGRATE
   ↓
OPERATING PROOF — when proportionate
   ↓
USE
```

The workflow routes agents into specialised skills.

It does not duplicate those skills' internal procedures.

---

# 1. Define the Operating Outcome

Start from what must become possible.

Do not begin from the proposed repository, architecture or implementation.

Weak:

> Build a Macro Intelligence repository.

Better:

> Axcíon needs to turn current macroeconomic developments into evidence-backed implications for sectors, companies and acquisition themes.

Capture enough to understand:

* who needs the outcome;
* what happens today;
* what materially needs to improve;
* why it matters.

Keep this brief.

Do not create an artifact merely to complete this step.

---

# 2. Inspect Before Building

Before introducing durable machinery, inspect whether the desired outcome can already be achieved through:

1. the existing system;
2. an operating change;
3. reuse of an existing capability;
4. simplification;
5. a materially smaller intervention.

Repository questions should be answered from the repository.

Agents should inspect as relevant:

* existing code;
* tests and evals;
* current commands and skills;
* repository documentation;
* Git history;
* existing interfaces;
* runtime behaviour.

Do not ask the operator to perform technical discovery that the agent can perform itself.

The operator supplies business intent, trade-offs and consequential judgment.

For obvious cases, this inspection may take seconds.

Do not turn it into a formal qualification exercise.

If durable development is unnecessary, stop or use the smaller intervention.

---

# 3. Choose the Minimum Operating Mode

Use the minimum planning mode justified by the uncertainty that exists **right now**.

The modes are dynamic.

A project may escalate or de-escalate as evidence changes.

---

## Small / Clear

Use when:

* the required behaviour is already clear;
* boundaries are understood;
* no material product or architectural decision remains unresolved.

Typical path:

```text
clear outcome
→ inspect
→ /implement
→ appropriate proof
→ /code-review
→ integrate
```

A specification or ticket structure is not required merely because this standard mentions them.

---

## Normal

Use when meaningful planning is required but can be resolved within one effective planning context.

Typical path:

```text
operating outcome
→ inspect
→ /grill-with-docs
→ implement directly
   OR /to-spec if useful
   OR /to-spec → /to-tickets if useful
→ /implement
→ proof
→ /code-review
```

This should be the default mode for most bounded Axcíon projects.

---

## Foggy

Use when several material decisions are unresolved and dependent on one another.

Use:

```text
/wayfinder
```

Wayfinder is appropriate when the route to implementation cannot be resolved reliably in one normal planning context.

It may route uncertainty into:

* `/grilling`;
* `/domain-modeling`;
* `/research`;
* `/prototype`;
* prerequisite tasks.

Resolve only the uncertainty necessary to reach a buildable next step.

Then leave Wayfinder and return to the ordinary build path.

> **Wayfinder is an escalation mechanism for decision fog, not a permanent project-management mode.**

Do not invoke Wayfinder because a project is merely large, important or strategically interesting.

---

# 4. Escalation Is Reversible

The operating mode is not a permanent project classification.

Examples:

```text
NORMAL
→ several dependent decisions appear
→ /wayfinder
→ uncertainty resolved
→ NORMAL
```

or:

```text
FOGGY
→ material decisions resolved
→ clear bounded implementation
→ SMALL / CLEAR
```

Always return to the minimum sufficient mode.

Do not continue using a planning mechanism after the uncertainty that justified it has disappeared.

---

# 5. Planning Skills

Use skills according to the condition encountered.

## `/grill-with-docs`

Use when the project needs bounded interrogation and repository-aware planning that can fit within one effective context.

Its purpose is to resolve important decisions.

Do not invoke it when the required behaviour is already clear.

---

## `/wayfinder`

Use when planning contains several dependent unresolved decisions that should persist across fresh contexts.

Wayfinder manages decision uncertainty.

It does not remain involved during normal implementation once the route is clear.

---

## `/grilling`

Use when a consequential question requires human judgment.

Examples:

* MVP boundary;
* product behaviour;
* acceptable trade-off;
* operator approval semantics.

The agent should not answer the operator's side of the decision.

---

## `/domain-modeling`

Use when ambiguous terminology is materially affecting:

* behaviour;
* interfaces;
* state;
* specifications;
* tests or evals.

Do not create an ontology merely because domain terms exist.

---

## `/research`

Use when a decision depends on external facts.

Research should normally:

* prefer primary sources;
* cite consequential claims;
* leave durable evidence when later decisions depend on it.

Research supplies evidence.

It does not automatically make business or product decisions.

---

## `/prototype`

Use when discussion and research are insufficient and something concrete would resolve the uncertainty faster.

A prototype should answer one meaningful question.

Treat prototype code as disposable by default.

---

# 6. Specifications Are Conditional

Use:

```text
/to-spec
```

only when a durable implementation specification materially improves coordination.

A specification is useful when:

* several implementation sessions must share the same destination;
* multiple behaviours must remain coherent;
* consequential decisions need a concise implementation-facing synthesis;
* implementation would otherwise repeatedly rediscover intent.

Do **not** create a specification for workflow compliance.

A bounded project may legitimately run:

```text
/grill-with-docs
→ accepted plan
→ /implement
```

without `/to-spec`.

---

## Specification authority

While active, the specification defines the intended behaviour of that scoped project.

It is coordination material, not permanent system truth.

After the specified change is delivered:

> **close or archive the specification.**

Permanent knowledge belongs where appropriate in:

* code;
* tests and evals;
* domain documentation;
* ADRs;
* genuine operator documentation.

A later V1 or V2 should normally create a new scoped specification rather than indefinitely expanding the old MVP specification.

---

# 7. Implementation Tickets Are Conditional

Use:

```text
/to-tickets
```

when implementation genuinely benefits from multiple bounded slices.

Useful when:

* several behaviours must be delivered;
* dependency ordering matters;
* separate fresh implementation contexts are beneficial;
* one large implementation session would be difficult to review.

Do not manufacture tickets for a change that is already small and coherent.

A legitimate path is:

```text
/to-spec
→ /implement
```

without `/to-tickets`.

Or:

```text
/grill-with-docs
→ /implement
```

when neither artifact adds meaningful value.

---

# 8. Ticket Contract

When implementation tickets are useful, keep them small.

The default ticket contains only:

```text
OUTCOME
What becomes possible?

ACCEPTANCE
What evidence proves it works?

BOUNDARY
What is explicitly not part of this ticket?
```

Add only when materially useful:

```text
DEPENDENCIES

PROOF SEAM

IMPORTANT DECISION REFERENCE
```

Do not require every ticket to restate technical detail already discoverable from the repository or active specification.

Implementation tickets should describe **vertical behaviour**, not technical layers.

Good:

> One approved content brief produces one reviewable LinkedIn draft through the actual workflow.

Weak:

> Create the content schema.

> Create the prompt module.

> Build the agent.

> Add the database.

---

# 9. Build Vertical Behaviour

Implementation should establish useful behaviour through the real system as early as practical.

Prefer:

```text
real input
→ real interface
→ required behaviour
→ useful output
→ credible proof
```

Avoid building generic infrastructure before there is a behaviour that requires it.

The first meaningful slice should normally act as a tracer bullet through the proposed system.

Build infrastructure only as the behaviour requires it.

---

# 10. Implement

Use:

```text
/implement
```

for bounded implementation work.

The agent should:

1. read the current outcome, specification or ticket as applicable;
2. inspect the relevant repository implementation;
3. identify the appropriate proof seam;
4. implement only the required behaviour;
5. keep feedback fast;
6. avoid adjacent scope;
7. run proportionate verification.

Small implementation details belong to Claude.

Material product, scope or architectural uncertainty does not.

---

# 11. Proof

Every implemented behaviour needs credible evidence.

Use:

> **the cheapest proof mechanism that genuinely demonstrates the claim.**

Do not force every Axcíon capability into a conventional unit-test model.

---

## Deterministic behaviour

Prefer:

```text
behavioural test
→ RED
→ minimum implementation
→ GREEN
```

Use `/tdd` where appropriate.

The test should exercise the meaningful behaviour rather than implementation shape.

---

## AI judgment

Use representative:

* fixtures;
* examples;
* eval sets;
* rubrics;
* comparison cases.

Typical loop:

```text
representative cases
→ below acceptance
→ improve
→ meets acceptance
```

Do not invent meaningless deterministic tests for inherently probabilistic quality.

---

## Operator workflow

Use a representative workflow or acceptance case.

Typical loop:

```text
representative case
→ unacceptable / unusable
→ improve
→ acceptable
```

---

## Proof seam

A proof seam is simply:

> **Where can we observe whether the claimed behaviour actually works?**

It may be:

* an automated test;
* integration test;
* eval;
* schema/invariant check;
* representative fixture;
* operator acceptance;
* real workflow execution.

Do not turn these into mandatory categories or additional process.

---

# 12. Keep the Feedback Loop Tight

During implementation prefer:

```text
small change
→ focused proof
→ immediate signal
```

over:

```text
large implementation
→ broad verification
→ ambiguous failures
```

Use broader checks as the change stabilizes.

When deterministic TDD is appropriate:

> **RED → GREEN before structural polishing.**

Refactor afterward where justified while keeping the behaviour proven.

---

# 13. Review

Use:

```text
/code-review
```

for material implementation.

Review two questions separately:

## Specification / Outcome Fidelity

Did we build the required behaviour?

Check for:

* missing behaviour;
* misunderstood requirements;
* scope expansion;
* violated boundaries.

## Implementation Quality

Was it built coherently?

Check for:

* unnecessary abstractions;
* duplicated responsibility;
* poor module boundaries;
* excessive machinery;
* implementation-coupled tests;
* unnecessary complexity.

Reviewer findings are claims to verify, not automatic instructions.

Do not continue review indefinitely merely because another theoretical improvement can be proposed.

---

# 14. Authority by Subject

Use each artifact for the question it owns.

### Decision records

Explain **why a consequential decision was made**.

### Active specification

Defines **intended behaviour for the current scoped project**.

### Active implementation ticket

Defines **the current implementation slice and its boundary**.

### Repository code and runtime

Describe **what currently exists and actually happens**.

### Tests, evals and other proof

Provide **behavioural evidence**.

### Domain documentation / ADRs

Carry durable terminology and consequential architectural decisions where appropriate.

No single linear hierarchy applies across all of these.

If material authorities contradict one another:

> **reconcile or escalate the contradiction.**

Do not blindly choose whichever artifact appears to rank higher.

---

# 15. Conditional Routing During Work

The following are routing responses, not lifecycle stages.

| Condition                             | Route                            |
| ------------------------------------- | -------------------------------- |
| Human/product decision unresolved     | `/grilling`                      |
| Material terminology ambiguity        | `/domain-modeling`               |
| External factual uncertainty          | `/research`                      |
| Need something concrete to decide     | `/prototype`                     |
| Difficult defect                      | `/diagnosing-bugs`               |
| Raw unverified issue                  | `/triage`                        |
| Several dependent decisions emerge    | `/wayfinder`                     |
| Context genuinely needs transferring  | `/handoff`                       |
| Unsure which skill applies            | `/ask-matt`                      |
| Small technical implementation detail | Claude decides locally           |
| Adjacent improvement discovered       | Record separately; do not absorb |

Do not make these mandatory merely because they appear in the standard.

---

# 16. Scope Discipline

Do not absorb adjacent improvements into current implementation.

When something new is discovered, determine whether it is:

* required for the current outcome;
* a separate issue;
* a future improvement;
* irrelevant.

Only the first enters the current work automatically.

Evidence may justify changing scope.

Convenience does not.

---

# 17. Escalation During Implementation

Stop normal implementation when a material unresolved decision appears.

Examples:

* intended behaviour becomes ambiguous;
* a different state model appears necessary;
* responsibility boundaries need changing;
* external research is required;
* several decisions become dependent on one another;
* the active scope must materially expand.

Route to the smallest appropriate planning capability.

Do not continue coding while silently inventing consequential decisions.

Once the uncertainty is resolved:

> return immediately to the normal build path.

---

# 18. Permanent Machinery

Do not add permanent machinery merely because it might eventually be useful.

Before introducing a new:

* service;
* agent;
* command;
* state store;
* database;
* hook;
* registry;
* recurring process;
* orchestration layer;

require a demonstrated current need.

Prefer:

1. removal;
2. simplification;
3. reuse;
4. narrow implementation;
5. new machinery only when necessary.

---

# 19. Integration

Once the implementation and review evidence are sufficient, hand the change into the repository's existing integration and release machinery.

Typically:

```text
commit
→ push
→ PR
→ CI
→ review
→ merge / integrate
→ runtime verification where relevant
```

This standard does not redefine:

* merge authority;
* worktree handling;
* release safety;
* deployment;
* repository integration controls.

Use the governing Work Loop or repository-specific release process.

---

# 20. Operating Proof

For a **new repository, MVP or material capability**, run at least one representative real operating case before considering the capability delivered.

Ask:

> **Can the system now perform the operating job that justified building it?**

Example:

```text
real macro development
→ actual workflow
→ cited evidence
→ driver interpretation
→ company or sector implication
→ usable output
```

For a small change inside an already-proven system, implementation-level acceptance evidence may be sufficient.

Do not force an artificial repository-wide demonstration after every minor change.

Proof depth should be proportionate to the claim being made.

---

# 21. Use Before Expanding

Once a new or material capability works:

> use it.

Observe:

* what creates value;
* where friction remains;
* where agents become confused;
* which assumptions were wrong;
* what requires repeated manual correction;
* which expected features do not matter.

Do not immediately turn every observation into permanent infrastructure.

Real use should determine subsequent versions.

---

# 22. Future Changes

New evidence may produce:

### Small clear change

```text
/implement
→ proof
→ /code-review
```

### Bounded new capability

```text
/grill-with-docs
→ optional /to-spec
→ optional /to-tickets
→ /implement
```

### New decision fog

```text
/wayfinder
→ resolve material uncertainty
→ return to ordinary build path
```

Do not keep an old project specification or Wayfinder process permanently open merely because the system continues evolving.

---

# 23. Stop Conditions

Stop or escalate when:

* the desired business behaviour is materially unclear;
* repository reality contradicts an important project assumption;
* the active scope must expand materially;
* a consequential architecture decision is unresolved;
* two systems appear to own the same responsibility;
* adequate proof cannot be established;
* the next action would create unapproved destructive or irreversible effects.

Do not stop for ordinary implementation details that the agent can resolve safely inside the accepted boundary.

---

# 24. Anti-Overengineering Rules

Do not:

* create a specification because the workflow mentions specifications;
* create implementation tickets because the workflow mentions tickets;
* invoke Wayfinder because the project sounds large;
* create formal qualification artifacts;
* model every future decision upfront;
* require every qualitative AI behaviour to have a unit test;
* turn every ticket into a miniature specification;
* duplicate instructions already owned by a specialised skill;
* keep planning machinery active after uncertainty is resolved;
* expand scope because an adjacent improvement appears attractive;
* maintain completed specifications as permanent competing system truth;
* add infrastructure without demonstrated need.

The standard should make development **lighter**, not administer itself.

---

# 25. Default Operating Paths

## Small / Clear

```text
DEFINE
→ INSPECT
→ /implement
→ appropriate proof
→ /code-review
→ integrate
```

---

## Normal

```text
DEFINE
→ INSPECT
→ /grill-with-docs
→ /to-spec        [only if useful]
→ /to-tickets     [only if useful]
→ /implement
→ appropriate proof
→ /code-review
→ integrate
→ operating proof if material
→ use
```

---

## Foggy

```text
DEFINE
→ INSPECT
→ /wayfinder
   → resolve only material decision fog
→ return to normal path
→ /to-spec        [if useful]
→ /to-tickets     [if useful]
→ /implement
→ appropriate proof
→ /code-review
→ integrate
→ operating proof
→ use
```

---

# 26. Governing Questions

At any point, a fresh Claude or Codex session should be able to answer:

1. **What operating outcome are we trying to achieve?**
2. **What already exists?**
3. **What uncertainty exists right now?**
4. **What is the minimum operating mode justified by that uncertainty?**
5. **Do we actually need a specification?**
6. **Do we actually need multiple tickets?**
7. **What behaviour are we building now?**
8. **What evidence will prove it works?**
9. **What is outside the current boundary?**
10. **What would require escalation?**

If the answer to a question is available from the repository or durable project artifacts, inspect them rather than asking the operator.

---

# 27. Final Standard

The Axcíon repository-development model is:

> **Define the operating need. Inspect before building. Use only enough planning to resolve the uncertainty that exists. Create specifications and tickets only when they materially improve coordination. Build vertical behaviour through the cheapest credible proof loop. Review the result. Integrate through existing repository controls. Prove new or material capabilities in real operation. Then learn from use before expanding them.**

Matt Pocock's skills provide the engineering capabilities.

This standard determines **when to invoke them and when not to**.

The system is working correctly when agents use less process for simple work and automatically escalate only when uncertainty or consequence genuinely requires it.
