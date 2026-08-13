# Matt Pocock’s Wayfinder-Led Project Development Lifecycle

## 1. Purpose

This guide explains how to develop a large project using Matt Pocock’s current Wayfinder-led skill stack.

It treats Matt’s latest Wayfinder video transcript as the authoritative description of the lifecycle. The individual skill definitions are used to clarify what each skill does, what it produces and how it connects to the next stage.

The central lifecycle is:

```text
/setup-matt-pocock-skills
        ↓
/wayfinder
        ↓
Decision tickets resolved through:
  /grilling + /domain-modeling
  /research
  /prototype
  prerequisite tasks
        ↓
/to-spec
        ↓
/to-tickets
        ↓
Fresh /implement session per implementation ticket
        ↓
/tdd
        ↓
/code-review
        ↓
Commit, PR, CI and deployment
```

Wayfinder replaces `/grill-with-docs` as the main planning entry point when the work is too large or uncertain to plan within one effective agent session. It does not replace `/to-spec`, `/to-tickets`, `/implement` or `/code-review`. It feeds into them.

---

# 2. The Two Main Planning Routes

Matt’s lifecycle has two principal routes.

## 2.1 Normal-sized work

Use this route when the project can be understood and planned in one strong context window:

```text
/grill-with-docs
→ /to-spec, when needed
→ /to-tickets, when needed
→ /implement
→ /code-review
```

`/grill-with-docs` investigates the repository, interviews the operator and records useful decisions in repository documentation.

This remains the default route for ordinary features and bounded projects.

## 2.2 Large or foggy work

Use this route when the project contains more uncertainty than one session can resolve:

```text
/wayfinder
→ resolve the decision map
→ /to-spec
→ /to-tickets
→ /implement
→ /code-review
```

Matt explicitly describes Wayfinder as occupying the same position that `/grill-with-docs` normally occupies.

The difference is scale:

* `/grill-with-docs` handles planning that fits inside one session.
* `/wayfinder` distributes planning across several specialised sessions.

You therefore do not normally run:

```text
/grill-with-docs
→ /wayfinder
→ /to-spec
```

Instead, choose one planning route:

```text
Smaller project:
  /grill-with-docs → /to-spec

Large uncertain project:
  /wayfinder → /to-spec
```

Wayfinder still uses the underlying grilling discipline internally. The distinction concerns who manages the planning process and whether it must persist across several sessions.

---

# 3. One-Time Repository Setup

## Skill: `/setup-matt-pocock-skills`

Before using the engineering lifecycle in a repository, run:

```text
/setup-matt-pocock-skills
```

This is a one-time repository configuration skill.

It establishes:

* the issue tracker used by the skills;
* the triage label vocabulary;
* the location of domain documentation;
* where `CONTEXT.md` and ADRs belong;
* which repository instruction file refers agents to those conventions.

The supported tracker may be:

* GitHub Issues;
* GitLab Issues;
* local Markdown tickets;
* another configured issue tracker.

Wayfinder depends on this setup because its map, child tickets, blocking relationships and decision history live in the configured tracker. `/to-spec`, `/to-tickets`, `/triage` and `/code-review` also need to know where project issues and specifications live.

### Relationship to the lifecycle

```text
/setup-matt-pocock-skills
        ↓
Makes the repository understandable to:
  /wayfinder
  /to-spec
  /to-tickets
  /triage
  /code-review
```

### Use it when

* Matt’s skills are first installed in the repository;
* the repository has no configured issue tracker;
* the issue tracker changes;
* the skills do not know where domain documentation belongs.

Do not run it at the beginning of every project.

---

# 4. Start the Planning Lifecycle

## Skill: `/wayfinder`

Invoke `/wayfinder` when the intended destination is visible but the route remains unclear.

Examples include:

* a new software repository;
* a substantial product capability;
* a major repository redesign;
* a migration involving several architectural decisions;
* a project that depends on research and prototypes;
* work whose planning cannot fit inside one effective model context.

The first `/wayfinder` session performs two functions:

1. It defines the destination.
2. It charts the initial decision map.

Wayfinder is a planning skill. Its default purpose is to produce decisions, not implementation deliverables.

---

## 4.1 Define the destination

Wayfinder first invokes the underlying grilling discipline to establish what the project is trying to reach.

In an engineering project, the destination is usually:

> A buildable specification for the intended system or feature.

For example:

> Produce a buildable specification for the minimum Axcíon CRM required to support the first 50–60 buyer relationships.

The destination is not necessarily the completed software. It is the point at which the planning process has resolved enough uncertainty for the normal implementation lifecycle to begin.

Matt’s transcript explains that Wayfinder destinations can vary. They may be:

* a buildable specification;
* a settled technical decision;
* a migration approach;
* a non-software plan;
* in exceptional cases, a completed change.

For normal engineering work, however, a specification is the preferred destination because it provides a stable reference for implementation across multiple sessions.

---

## 4.2 Chart the initial map

Once the destination is defined, `/wayfinder` creates a parent issue representing the complete planning effort.

The map normally contains:

### Destination

What the planning process must produce.

### Notes

Persistent context, relevant skills, domain instructions and standing constraints.

### Decisions so far

A concise index of resolved tickets, with links to the detailed primary sources.

### Not yet specified

Known areas of uncertainty that cannot yet be expressed as precise tickets.

### Out of scope

Matters deliberately excluded from the destination.

The map is an index, not a comprehensive store. Detailed decisions remain inside the individual decision tickets.

---

# 5. Wayfinder’s Relationship to the Underlying Skills

Wayfinder is an orchestration skill. It does not contain every planning method itself.

It manages a map whose tickets are resolved using other Matt Pocock skills.

The core relationship is:

```text
/wayfinder
    ├── /grilling
    │      └── /domain-modeling
    │
    ├── /research
    │
    ├── /prototype
    │
    └── prerequisite task
```

Each Wayfinder ticket is assigned one of four types:

1. Grilling
2. Research
3. Prototype
4. Task

These are **decision tickets**. They are different from the implementation tickets produced later by `/to-tickets`.

---

# 6. Grilling Decision Tickets

## Skills: `/grilling` and `/domain-modeling`

Use a grilling ticket when a question requires human judgment, clarification or a business decision.

Examples:

* What is the minimum useful CRM workflow?
* What information belongs in the CRM rather than the knowledge base?
* Which user actions require operator confirmation?
* What should the first version deliberately exclude?
* How should the repository define a “relationship,” “buyer” or “interaction”?

The session should invoke:

```text
/wayfinder <map and grilling ticket>
        ↓
/grilling
        +
/domain-modeling
```

## 6.1 Role of `/grilling`

`/grilling` conducts the focused interview.

It should:

* ask one question at a time;
* distinguish factual questions from human decisions;
* challenge unclear assumptions;
* surface trade-offs;
* continue until the particular ticket can be resolved.

The agent must not answer the operator’s side of the discussion on the operator’s behalf.

## 6.2 Role of `/domain-modeling`

`/domain-modeling` improves the language used in the project.

It should:

* identify ambiguous or overloaded terms;
* define important domain concepts;
* maintain consistent vocabulary;
* update `CONTEXT.md`;
* record consequential, hard-to-reverse decisions as ADRs where appropriate.

For example, the CRM project may need to distinguish clearly between:

* a contact;
* an organisation;
* a buyer;
* a fund;
* a relationship;
* an interaction;
* an opportunity;
* a next action.

These definitions influence later specifications, tickets, data structures and code.

### Output

The output of the session is a resolved decision recorded in the Wayfinder ticket.

Wayfinder then:

* closes the ticket;
* links the decision from the map;
* updates the frontier;
* creates new tickets when the decision exposes additional questions.

---

# 7. Research Decision Tickets

## Skill: `/research`

Use a research ticket when a decision depends on facts that are not yet available.

Examples:

* Which API capabilities exist?
* What limitations apply to a selected database?
* How does an external CRM provider represent relationship history?
* Which authentication methods are officially supported?
* What technical constraints apply to an integration?

The relationship is:

```text
/wayfinder creates research ticket
        ↓
/research investigates the question
        ↓
Cited research artifact
        ↓
Wayfinder records the answer
        ↓
Dependent decision tickets become available
```

`/research` should use primary sources and leave a cited Markdown artifact in the repository.

Research does not automatically make the business decision. It supplies evidence to the Wayfinder map.

For example:

```text
Research ticket:
  Determine whether Gmail integration can reliably identify
  replies and associate them with CRM contacts.

Research result:
  Documents available APIs, event mechanisms and constraints.

Later grilling ticket:
  Decide whether the CRM MVP should include automated reply capture.
```

Matt’s transcript explains that research tickets can be started automatically through sub-agents and may run in parallel when they do not depend on each other.

---

# 8. Prototype Decision Tickets

## Skill: `/prototype`

Use a prototype ticket when discussion and research are insufficient to settle the question.

The relationship is:

```text
/wayfinder creates prototype ticket
        ↓
/prototype creates a disposable artifact
        ↓
Human reacts to the artifact
        ↓
Decision is recorded in Wayfinder
        ↓
Prototype is discarded or retained only as evidence
```

Examples:

* prototype a CRM company profile;
* test whether a relationship-state model feels understandable;
* compare a queue-based workflow with a record-based workflow;
* test a proposed API interaction;
* model a state transition;
* create a rough UI for operator feedback.

The prototype should answer one important question.

It is not intended to become production code.

Matt emphasises prototypes because they prevent large planning efforts from becoming low-fidelity waterfall exercises. A prototype introduces real behaviour or visible structure into the planning process, allowing the operator to react to something concrete.

### Appropriate prototype questions

* Does this state model behave correctly?
* Is this interface understandable?
* Does this workflow reduce operator burden?
* Can the proposed integration function?
* Which of two interaction patterns should be selected?

### Inappropriate use

Do not use `/prototype` to begin implementing the whole system before the Wayfinder decisions are complete.

Preserve:

* the conclusion;
* screenshots where useful;
* decision-rich snippets;
* identified constraints.

Discard or clearly isolate the throwaway implementation.

---

# 9. Task Decision Tickets

## Wayfinder ticket type: task

A task ticket is used when something must be done before planning can continue.

Unlike the other ticket types, it may not invoke a separate named Matt Pocock skill.

Examples:

* create an account for an external service;
* obtain API credentials;
* export representative data;
* interview a stakeholder;
* provision a test environment;
* gather sample inputs;
* perform a manual operating trial.

The relationship is:

```text
/wayfinder creates prerequisite task
        ↓
Human or agent completes the task
        ↓
Facts or access become available
        ↓
Dependent Wayfinder decision tickets unblock
```

The task belongs inside Wayfinder because it supports a decision. It is not an implementation ticket merely because it involves action.

For example:

```text
Task:
  Export ten representative buyer records from the current source.

Purpose:
  Allow the team to decide the minimum CRM data model.
```

The output is the completed action and the facts or artifacts created by it.

---

# 10. Blocking Relationships and the Frontier

Wayfinder records dependencies between decision tickets.

For example:

```text
/research:
Investigate Gmail event capabilities
        ↓
/grilling:
Decide the CRM-email ownership boundary
        ↓
/prototype:
Test the reply-review workflow
        ↓
/grilling:
Approve the Email OS integration scope
```

A ticket should only become available when all decisions blocking it have been resolved.

The open, unblocked tickets form the **frontier**.

The frontier answers:

> Which decisions can be worked on now?

The remaining unclear areas stay in **Not yet specified**, or the fog of war.

The map should not attempt to predict and ticket every future question at the beginning. As decisions are resolved, the frontier advances and previously vague uncertainty becomes precise enough to convert into new tickets.

---

# 11. Work One Wayfinder Ticket per Session

The normal operating rhythm is:

```text
Session 1:
  /wayfinder <map>
  → chart map

Session 2:
  /wayfinder <map + ticket A>
  → resolve ticket A

Session 3:
  /wayfinder <map + ticket B>
  → resolve ticket B

Session 4:
  /wayfinder <map + ticket C>
  → resolve ticket C
```

Each ticket should normally receive a fresh context window.

The exception is research: several independent research tickets may run in parallel through sub-agents.

When invoking Wayfinder on an existing ticket, the skill should:

1. Load the low-resolution map.
2. Select or accept the specified frontier ticket.
3. Claim the ticket.
4. Load only the related decision context.
5. Invoke the appropriate underlying skill.
6. Record the resolution.
7. Close the ticket.
8. Update the map.
9. Create or modify newly exposed tickets.
10. Recalculate the frontier.

Matt describes using `/wayfinder` both to chart the original map and to walk through the individual decision tickets.

---

# 12. Crossing Context Windows

## Skill: `/handoff`

`/handoff` is a supporting skill rather than a mandatory stage in every Wayfinder ticket.

Use it when:

* the current context is approaching its effective limit;
* a prototype should be created in a clean session;
* research or implementation must move to another agent;
* a session needs to preserve its state before continuing elsewhere.

The relationship is:

```text
Current session
        ↓
/handoff
        ↓
Markdown context artifact
        ↓
Fresh session
        ↓
Continue with /wayfinder, /prototype, /research or /implement
```

Wayfinder’s issue map already preserves much of the project state, so a separate handoff is not always necessary. The ticket and map should remain the primary planning authorities.

Use `/handoff` for session-specific context that has not yet been incorporated into those durable artifacts.

Matt distinguishes `/handoff` from the built-in `/compact`:

* `/handoff` moves the work into a fresh session.
* `/compact` continues the current conversation with compressed history.

---

# 13. Complete the Wayfinder Map

Wayfinder is complete when the route to the destination is sufficiently clear.

For a software project whose destination is a buildable specification, completion normally means:

* major product decisions have been resolved;
* relevant research has been completed;
* uncertain interactions have been prototyped;
* important domain terminology is clear;
* architecture-shaping decisions have been recorded;
* dependencies and constraints are understood;
* scope and exclusions are clear;
* remaining uncertainty is either non-material, deferred or outside scope.

Wayfinder should stop when the project is ready to be specified.

It should not continue creating decision tickets merely because additional questions could theoretically be explored.

The map is then handed to:

```text
/to-spec
```

---

# 14. Convert the Wayfinder Map into a Specification

## Skill: `/to-spec`

Invoke:

```text
/to-spec <Wayfinder map>
```

`/to-spec` reads:

* the Wayfinder parent map;
* its resolved decision tickets;
* linked research;
* prototypes;
* domain documentation;
* relevant ADRs;
* current repository structure.

It then collapses the distributed planning record into one coherent build specification.

Matt describes the Wayfinder map as potentially too dense to use directly for implementation. `/to-spec` converts that network of primary decisions into a usable destination document.

The specification should contain:

* problem statement;
* solution;
* user stories;
* implementation decisions;
* testing decisions;
* exclusions;
* further notes.

`/to-spec` does not conduct another general interview. It synthesises what has already been decided.

### Relationship between the map and the specification

```text
Wayfinder map
  = primary decision history

/to-spec output
  = implementation-oriented synthesis
```

The map remains useful when an implementation agent needs to inspect the original reasoning behind a decision.

The specification provides the concise, coherent destination for the build.

---

# 15. Convert the Specification into Implementation Tickets

## Skill: `/to-tickets`

Invoke:

```text
/to-tickets <specification>
```

This is the point where the project changes from decision planning to implementation planning.

`/to-tickets` creates **implementation tickets**, not Wayfinder decision tickets.

The distinction is fundamental:

```text
Wayfinder ticket:
  What should be decided?

Implementation ticket:
  What working behaviour should be delivered?
```

`/to-tickets` divides the specification into tracer-bullet vertical slices.

Each ticket should:

* deliver one complete, observable behaviour;
* cross the necessary layers;
* be demonstrable independently;
* fit inside one fresh implementation context;
* declare its blocking relationships;
* contain acceptance criteria.

For example:

```text
Incorrect horizontal breakdown:
  Ticket 1: Build CRM database
  Ticket 2: Build CRM API
  Ticket 3: Build CRM UI

Correct vertical breakdown:
  Ticket 1: Create and retrieve one organisation record
  Ticket 2: Add a contact to an organisation
  Ticket 3: Record and display a buyer interaction
  Ticket 4: Assign and display the next justified action
```

The user reviews the proposed ticket structure before publication.

Tickets created by `/to-tickets` are already intended to be agent-ready. They do not need to go through `/triage`.

---

# 16. Implement Each Ticket

## Skill: `/implement`

Each unblocked implementation ticket should normally be completed in a fresh session.

Invoke:

```text
/implement <implementation ticket>
```

The relationship is:

```text
/to-tickets
        ↓
Agent-ready implementation ticket
        ↓
Fresh /implement session
        ↓
/tdd
        ↓
/code-review
        ↓
Commit
```

`/implement` should:

* read the ticket and relevant specification;
* inspect the current repository;
* respect domain terminology and ADRs;
* implement only the specified vertical slice;
* use the agreed testing seams;
* run focused tests and type checks during the work;
* run the complete relevant test suite at the end;
* invoke `/code-review`;
* commit the completed ticket.

The implementation session should not reopen the Wayfinder planning process unless it discovers a genuinely material contradiction or missing decision.

Small implementation details can be resolved locally. Material scope or architecture uncertainty should be returned to a decision process rather than silently invented by the builder.

---

# 17. Build Through Test-Driven Development

## Skill: `/tdd`

`/implement` invokes `/tdd` where possible.

The implementation loop is:

```text
Red
→ write a failing behavioural test

Green
→ implement the smallest change that passes

Continue
→ repeat one behavioural slice at a time
```

The test should operate at the previously agreed seam.

Wayfinder, prototypes and `/to-spec` help identify what behaviour matters. `/to-tickets` narrows it into a vertical slice. `/tdd` then provides the implementation feedback loop.

The skills therefore connect as follows:

```text
/wayfinder
  decides what the system should do

/to-spec
  consolidates the intended behaviour

/to-tickets
  divides behaviour into buildable slices

/tdd
  proves each slice during implementation
```

Use `/tdd` directly only when a concrete behaviour is already well defined and the broader Wayfinder or specification lifecycle is unnecessary.

---

# 18. Review the Completed Ticket

## Skill: `/code-review`

At the end of `/implement`, run:

```text
/code-review <fixed point>
```

`/code-review` examines the diff along two independent axes.

## 18.1 Standards review

Does the implementation follow:

* repository coding standards;
* domain and architectural conventions;
* expected module boundaries;
* relevant quality principles?

## 18.2 Specification review

Does the implementation:

* satisfy the ticket and originating specification;
* omit required behaviour;
* introduce unapproved scope;
* implement any requirement incorrectly?

The two reviews remain separate because work can pass one and fail the other.

Examples:

```text
Standards pass, Spec fail:
  Well-written code implements the wrong behaviour.

Spec pass, Standards fail:
  Correct behaviour damages repository structure.
```

The current skill runs these two perspectives in separate sub-agent contexts and reports them independently.

The resulting findings should be corrected before the ticket is committed or considered complete.

---

# 19. Commit and Continue Through the Ticket Frontier

After review:

1. Correct material findings.
2. Rerun relevant tests.
3. Commit the ticket.
4. Mark the implementation ticket complete.
5. Identify newly unblocked implementation tickets.
6. Start the next ticket in a fresh session.

The implementation phase therefore has its own frontier, based on the blocking relationships created by `/to-tickets`.

```text
Decision frontier:
  managed by /wayfinder

Implementation frontier:
  created by /to-tickets
  executed through /implement
```

These are separate systems serving separate phases of the lifecycle.

---

# 20. Pull Request, CI and Deployment

Matt’s core public skill lifecycle reaches reviewed and committed code.

The repository’s own operating system must then handle:

```text
Commit
→ push
→ pull request
→ CI
→ review
→ merge
→ deployment
→ runtime verification
```

These stages are not automatically provided by Wayfinder.

Wayfinder ensures that the project was properly decided.

`/to-spec` ensures that those decisions form a coherent build destination.

`/to-tickets` ensures that the build is divided into manageable slices.

`/implement`, `/tdd` and `/code-review` ensure that each slice is built and reviewed.

The repository remains responsible for safe release and operational verification.

---

# 21. The Complete Skill Relationship

## Planning layer

```text
/setup-matt-pocock-skills
        ↓
/wayfinder
        ├── /grilling
        │      └── /domain-modeling
        ├── /research
        ├── /prototype
        └── task tickets
        ↓
Resolved Wayfinder map
```

## Specification layer

```text
Resolved Wayfinder map
        ↓
/to-spec
        ↓
Buildable specification
```

## Implementation planning layer

```text
Buildable specification
        ↓
/to-tickets
        ↓
Tracer-bullet implementation tickets
```

## Build layer

```text
Implementation ticket
        ↓
/implement
        ↓
/tdd
        ↓
Working vertical slice
```

## Review layer

```text
Working vertical slice
        ↓
/code-review
        ↓
Standards review + Spec review
        ↓
Corrections
        ↓
Commit
```

## Supporting context skill

```text
Any full or branching session
        ↓
/handoff
        ↓
Fresh session with preserved context
```

---

# 22. Supporting Skills That Are Not Part of the Main Wayfinder Route

## `/ask-matt`

Use `/ask-matt` when the correct entry point is unclear.

It acts as a router across the skill collection.

Examples:

* Should this start with `/wayfinder` or `/grill-with-docs`?
* Is this a `/triage` issue or a direct implementation?
* Should this be handled through `/diagnosing-bugs`?
* Is a prototype appropriate?

It is not a project phase.

## `/triage`

Use `/triage` for raw external issues, bug reports or feature requests that were not created through `/to-tickets`.

Wayfinder decision tickets and `/to-tickets` implementation tickets should not normally be triaged again.

## `/diagnosing-bugs`

Use `/diagnosing-bugs` when the starting point is a difficult defect rather than a new project.

Its primary objective is to build a tight, red-capable feedback loop before theorising about the cause.

A sufficiently large architectural response discovered through debugging may later become a new project that enters `/grill-with-docs` or `/wayfinder`.

## `/improve-codebase-architecture`

Use this for codebase maintenance and architectural opportunities rather than as a mandatory part of every feature.

A selected improvement becomes a new idea and should re-enter the appropriate planning route:

```text
/improve-codebase-architecture
        ↓
Choose one justified improvement
        ↓
/grill-with-docs or /wayfinder
```

---

# 23. Practical Operating Rules

## Rule 1: Wayfinder is for fog, not merely size

A project may be large but clear. In that case, `/to-spec` and `/to-tickets` may be sufficient.

Use Wayfinder when the route contains unresolved dependent decisions.

## Rule 2: Wayfinder tickets produce decisions

Do not use Wayfinder tickets as disguised implementation tasks.

Their outputs are:

* decisions;
* evidence;
* prototypes;
* prerequisite facts.

## Rule 3: `/to-tickets` produces implementation work

Only after the project has a coherent specification should it be divided into production slices.

## Rule 4: Use the correct skill for the uncertainty

* Human decision → `/grilling`
* Ambiguous terminology → `/domain-modeling`
* Missing external facts → `/research`
* Need something concrete to react to → `/prototype`
* Prerequisite action → Wayfinder task ticket

## Rule 5: Preserve primary decisions

The Wayfinder tickets contain the original reasoning.

The specification is a synthesis. An implementation agent should be able to follow a link back to the underlying decision when the summary is insufficient.

## Rule 6: Use fresh implementation sessions

Each `/implement` ticket should normally start with clean context and rely on the ticket, specification and repository rather than the accumulated Wayfinder conversation.

## Rule 7: Treat the specification as temporary coordination

Matt describes the specification as a destination document for multi-session implementation, not necessarily as permanent documentation.

Once the specified behaviour exists in tested code, the specification issue can be closed rather than maintained as a competing representation of the system.

## Rule 8: Stop Wayfinding when the route is clear

The goal is not to remove all uncertainty.

The goal is to reach the point where implementation can proceed without rediscovering major decisions.

---

# 24. Final Lifecycle

The complete Wayfinder-led method is:

```text
1. /setup-matt-pocock-skills
   Configure tracker and domain documentation.

2. /wayfinder
   Define the destination and chart the decision map.

3. /wayfinder + /grilling + /domain-modeling
   Resolve human and domain decisions.

4. /wayfinder + /research
   Resolve factual uncertainty.

5. /wayfinder + /prototype
   Resolve questions requiring concrete feedback.

6. /wayfinder task tickets
   Complete prerequisites that unblock decisions.

7. Repeat /wayfinder per decision ticket
   Advance the frontier and clear the fog.

8. /to-spec
   Convert the resolved map into a buildable specification.

9. /to-tickets
   Convert the specification into vertical implementation tickets.

10. /implement
    Build each available ticket in a fresh session.

11. /tdd
    Implement through observable red-green feedback loops.

12. /code-review
    Review Standards and Spec as separate dimensions.

13. Commit, PR, CI and deploy
    Use the repository’s release process.

14. Verify operational behaviour
    Confirm that the delivered capability works in real use.
```

The governing idea is:

> Wayfinder manages uncertainty across sessions. Its supporting skills resolve the different types of uncertainty. `/to-spec` collapses the decisions into a build destination. `/to-tickets` converts that destination into vertical slices. `/implement`, `/tdd` and `/code-review` then turn those slices into reviewed production behaviour.
