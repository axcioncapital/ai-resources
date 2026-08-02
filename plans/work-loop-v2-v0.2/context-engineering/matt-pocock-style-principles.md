## Matt Pocock–Style Principles for the Axcíon Development Process

The following is an inferred translation of Matt Pocock’s published engineering approach into the Axcíon capability-development lifecycle. It is not presented as a direct statement from him. It aligns closely with the uploaded SOP, particularly its emphasis on verified needs, observable behaviour, vertical slices and real use. fileciteturn0file0

### 1. Understand the problem before producing the plan

Do not allow the agent to generate a polished implementation plan immediately. Interrogate the idea until the operator and agent share the same understanding of the users, workflow, constraints, edge cases and unresolved decisions.

Planning should begin only after the important branches of the design tree have been explored. This reflects Pocock’s `/grill-me` method, which deliberately prevents Claude from prematurely converting an incomplete idea into a plan. citeturn818813search1

### 2. Let the repository answer repository questions

Do not ask the operator questions that can be answered by inspecting the codebase, existing documentation, Git history or current implementation.

The agent should investigate technical reality itself. The operator should provide business intent, practical constraints and judgment—not perform repository discovery on the agent’s behalf. citeturn818813search1

### 3. Separate understanding from specification

The conversation is where the problem is explored and decisions are resolved. The specification should then record the resulting shared understanding.

Do not use the specification-writing stage to reopen the entire discovery process. A specification is a synthesis of settled decisions, not a substitute for thinking. citeturn818813search1

### 4. Define behaviour before architecture

Start by stating what a user must be able to do and what observable result the system must produce.

Do not begin with commands, agents, folders, schemas or orchestration. Internal architecture should follow from required behaviour and clearly identified testing seams.

### 5. Design the public seam deliberately

Every meaningful capability should expose a small, understandable interface:

- what goes in;
- what comes out;
- what behaviour is guaranteed;
- what errors are visible;
- what side effects occur;
- where the behaviour is tested.

The operator and reviewer should be able to reason about the capability through this interface without understanding every internal implementation detail.

### 6. Prefer deep capabilities with small interfaces

Avoid decomposing one responsibility into numerous shallow commands, agents and helper files that must be understood together.

Group related complexity behind a clear boundary. Pocock describes this as using deep modules: substantial implementation controlled through a simple interface. The interface is designed carefully; the internal implementation can then be delegated more safely to the coding agent. citeturn818813search0

### 7. Build tracer bullets, not horizontal layers

The first implementation should be a thin, complete path through the real system.

Do not build all schemas, then all services, then all commands, and only later discover whether the workflow functions. Build one real input passing through the real interface and producing one demonstrable result.

Each implementation unit should be small enough to understand but complete enough to demonstrate independently. citeturn818813search3turn818813search5

### 8. Use early slices to expose unknowns

The first slices should test the riskiest assumptions and integration points, not merely complete the easiest technical work.

Their purpose is to discover:

- whether the proposed boundaries are correct;
- whether the necessary data actually exists;
- whether external dependencies behave as expected;
- whether the workflow is useful;
- whether the chosen architecture survives contact with reality.

### 9. Implement one behaviour at a time

Use a disciplined red–green–refactor loop:

1. Define one observable behaviour.
2. Write or reproduce a failing case.
3. Make the smallest change that passes.
4. Refactor without changing the behaviour.
5. Commit the coherent slice.

Pocock presents TDD as one of the most reliable ways to improve agent-produced code because it gives the agent a continuous feedback loop rather than relying on a large implementation followed by retrospective review. citeturn818813search1turn818813search16

### 10. Test at the boundary where the behaviour matters

Tests should verify the public behaviour of the capability, not merely the internal functions the agent happened to create.

Do not extract artificial helpers simply because they are easy to unit-test while leaving the real invocation path untested. Integration boundaries, module interfaces and consequential runtime paths deserve the strongest evidence.

### 11. Optimize the feedback loop before adding intelligence

When agent performance is weak, first improve how quickly and clearly the agent learns whether its work is correct.

Useful feedback mechanisms include:

- focused tests;
- type checking;
- linting;
- visible runtime errors;
- representative evaluation cases;
- small diffs;
- short implementation cycles.

Do not respond first by adding more agents, longer prompts or elaborate orchestration. Pocock’s AI-engineering guidance consistently prioritises feedback loops and evaluations as the mechanism for making probabilistic systems more predictable. citeturn943209search11turn818813search11

### 12. Climb the complexity ladder slowly

Try the simplest credible intervention first. Move to more complex solutions only after simpler approaches have been tested and shown to be insufficient.

A reasonable sequence is:

1. clarify the instruction;
2. improve the existing workflow;
3. add a focused example or test;
4. adjust the prompt or skill;
5. improve the interface or module boundary;
6. add deterministic tooling;
7. introduce additional orchestration only when evidence requires it.

Pocock explicitly recommends beginning with inexpensive, simple interventions and moving toward complex techniques only when the simpler options have been exhausted. citeturn943209search5

### 13. Treat agents as capable engineers with no memory

Every new Claude or Codex session should be treated like a competent engineer joining the project without prior memory.

The repository must therefore make the following easy to discover:

- what the system does;
- where each responsibility belongs;
- which decisions are authoritative;
- how to run and test the system;
- what work is currently active;
- what must not be changed.

Important decisions, specifications and handoff state should live in repository artifacts rather than only in chat history.

### 14. Make the codebase carry more context than the prompt

Do not try to compensate for confusing architecture with increasingly long `CLAUDE.md` files or repeated instructions.

Clear folder boundaries, explicit interfaces, well-named concepts, colocated tests and navigable domain modules guide agents more reliably than a large permanent system prompt. Pocock argues that codebase structure is often a greater influence on agent output than prompt-level guidance. citeturn818813search0

### 15. Maintain one shared language

Define important domain terms before implementation and use them consistently across specifications, code, schemas, tests and documentation.

Ambiguous language produces ambiguous boundaries. When two people or agents use the same term differently, implementation errors are likely even when the code itself is technically competent.

### 16. Keep skills narrow and high-leverage

A skill should encode one useful engineering behaviour clearly. It does not need to become a long procedural handbook.

Prefer a small set of strong skills for activities such as:

- interrogating an idea;
- creating a specification;
- dividing work into tracer bullets;
- implementing through TDD;
- reviewing code;
- diagnosing defects.

Do not create a new skill for every variation of a workflow. Pocock’s own `/grill-me` example demonstrates that a very short instruction can materially affect agent behaviour when it is applied at the correct point in the process. citeturn818813search1

### 17. Separate planning, implementation and review

Use distinct working contexts for materially different cognitive roles:

- planning establishes what should be built;
- implementation executes the accepted slice;
- review challenges the implementation and evidence.

Do not allow the implementing agent’s accumulated reasoning to become the sole basis for evaluating its own work. Independent review is most useful when it examines a bounded diff, clear intended behaviour and visible test evidence.

### 18. Keep the human at consequential seams

The operator should make decisions concerning business outcome, acceptable trade-offs, scope, user experience and adoption.

The agent should handle repository investigation, technical design, implementation details and test selection. Human involvement should be concentrated where judgment materially changes the product—not distributed across constant approval of low-level technical choices.

### 19. Do not expand scope while implementing

When an agent discovers an adjacent improvement, record it separately rather than silently adding it to the current change.

Each implementation session should have a bounded destination. Uncontrolled adjacent improvements weaken reviewability, enlarge diffs and make it harder to determine whether the original behaviour was actually delivered.

### 20. Prefer demonstration over declarations of completion

A capability is not complete because its files exist or its implementation plan has been followed.

Completion should be demonstrated through:

- a real invocation;
- an observable output;
- passing behavioural tests;
- a reviewable diff;
- a representative use case;
- confirmation that the intended user can operate the result.

This directly supports the SOP’s shift from specification conformance toward demonstrated operational effect. fileciteturn0file0

### 21. Ship the smallest useful version and learn from use

Do not attempt to anticipate the complete future system.

Release the first coherent version, use it on a real case, inspect what failed and allow operating evidence to determine the next slice. This is consistent with both tracer-bullet development and Axcíon’s principle that permanent infrastructure should follow demonstrated use. citeturn818813search3

### 22. Refactor architecture when it impairs agent performance

When agents repeatedly struggle to navigate, test or modify a part of the repository, treat that as possible architectural evidence.

Look for:

- responsibilities spread across many files;
- unclear module ownership;
- hidden coupling;
- interfaces that expose too much;
- tests that cannot be written without understanding internals;
- concepts represented differently in several locations.

Correct the underlying boundary rather than permanently compensating with additional prompt instructions.

### 23. Keep the process strict but the system small

Pocock’s approach is process-disciplined, but that does not require a large governance architecture.

The strictness should come from a repeatable sequence:

> understand → specify → slice → test → implement → review → demonstrate
> 

It should not come from dozens of overlapping commands, registers, mandatory reports and review stages. The repository should encode the few behaviours that consistently improve results and remove machinery that does not contribute to the feedback loop.

### 24. Judge the process by what it ships

The ultimate measure is not how complete the planning package appears. It is whether the process repeatedly produces maintainable, testable and useful working software.

For Axcíon, the equivalent standard should be:

> Did this process help us understand the real need, build the smallest useful behaviour, demonstrate that it works, and make the next decision easier?
> 

That principle is consistent with the broader redesign objective of preserving useful engineering discipline while avoiding the document-heavy, self-maintaining architecture that caused the previous repository to fail. fileciteturn0file3 fileciteturn0file4