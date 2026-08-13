# The Work Loop, Explained: The Complete System

> **AUTHORITY NOTICE (added at commit time, not part of the source document).** This file is **destination reference only**. It is **not** a requirements document and must never be used to justify building anything beyond the MVP scope defined in `work-loop-v2-mvp-proposal-v0.4.md`. See `README.md` in this folder for the authority order.

**Version:** v0.2 (replaces v0.1, which described only the MVP)
**What this is:** a plain-English, self-contained description of the **full Work Loop as it is meant to work when complete**: every role, capability, rule, and constraint from the original operating specification, adjusted only where the v1 failure review and this session's decisions explicitly corrected it. You can read this without opening any other document.

**How it relates to the MVP:** the MVP (covered by the Proposal and Playbook) builds the smallest working subset of this system first and proves it on real work. This document is the destination that subset grows toward. Where a capability is deliberately not in the MVP, this document still describes it, because it remains part of the goal state; it simply arrives later, triggered by demonstrated need rather than by schedule.

---

## 1. Purpose: why this system exists

The Work Loop is the standard operating model for substantial repository work done with two AI systems. Its purpose is to let you run several projects at the same time without personally carrying every implementation detail, without reconstructing past decisions from memory, and without manually moving instructions between the tools.

The division of labour, which everything else in this document elaborates:

- **Codex ensures the right work is being done, for the right reason, with the right context, and knows when it should stop.**
- **Claude Code ensures the work is technically correct in the live repository.**
- **Evidence establishes what is actually true.**
- **You determine what ultimately matters.**

One warning is built into the system's foundations, because it is how version 1 died: the Work Loop exists to produce useful project outcomes. It must never become an orchestration, governance, documentation, or review system that generates work for itself. Fast, successful execution is a sign of health. Complexity of process is not evidence of quality.

---

## 2. The six-stage rhythm

Every piece of Work Loop activity follows the same mental model:

**Orient → Choose the next unit → Execute → Prove → Assess → Continue or stop.**

In plain terms: understand the objective, the current project state, and which approved workflow governs the work. Pick the smallest unit of work that would genuinely move the project forward. Have Claude verify reality and do that unit. Have Claude demonstrate what actually happened with evidence. Have Codex judge whether the result is correct, proportionate, and genuinely valuable. Then decide what happens next: progress, one bounded correction, more investigation, more evidence, deferral, acceptance of a limitation, an operator decision, a reframing, or closure.

The default assumption at every boundary is **not** that another unit should happen. Codex must ask, honestly: does this work still deserve another unit of attention?

---

## 3. Admission: not everything gets the loop

The Work Loop must never be used just because it exists. At the entrance stands a question: does this work actually need it?

**Direct Work is the default.** If a task is bounded, understandable, reversible, and low-consequence, it is done directly: execute, verify, commit or close. No persistent state, no dedicated context checking, no formal review, no handoff machinery.

**The loop is entered only for a named reason,** one or more of: previous project or session context materially affects the work; the need, problem, or solution is genuinely uncertain; several meaningful Claude units are likely; the work has real operational, technical, or business consequence; important shared repository behaviour is affected; an approved multi-phase workflow governs it; independent assessment could materially reduce risk; or the work must survive across several sessions.

Admission also runs in reverse. Lane classification is reassessed at natural boundaries: discovery may reveal a trivial fix, a scary-looking task may turn out bounded, a loop task may become Direct Work after inspection. Escalation and de-escalation are both normal. Governance depth can go down, not only up.

---

## 4. The three lanes

When work does enter the loop, governance depth follows demonstrated consequence, uncertainty, and reversibility, always starting with the lightest plausible route.

**The Fast lane** is for bounded, understandable, reversible, low-consequence loop work. One prepared request, one execution with evidence, one assessment, close. It normally omits separate context checking, formal review, architecture review, running state updates, and multiple corrections.

**The Standard lane** is the normal route for meaningful development: real uncertainty, several affected files, important workflow behaviour, or non-trivial implementation choices. It adds stronger context preparation, explicit verification of the brief's premises, a concise persistent state file, structured evidence, and at most one bounded correction pass. Heavier controls remain triggered capabilities, not automatic steps.

**The Consequential lane** exists only where failure has meaningful downside: broad shared infrastructure, destructive or hard-to-reverse changes, source-of-truth or ownership changes, Git and permission and security mechanisms, migrations affecting important consumers, confidential or operationally critical systems, technically uncertain changes with a large blast radius, or areas with demonstrated prior failure. It may add dedicated context quality-control, stronger negative testing, a fresh-context independent review, rollback and recovery verification, and explicit operator approval at consequential boundaries.

The Consequential lane must remain uncommon. If most tasks seem to qualify, the classification has grown too broad and must be tightened.

---

## 5. The four roles, precisely

**You, the operator,** own the intended business outcome, project priorities, approved plans, material scope changes, information the models cannot have, genuine trade-offs, adoption decisions, and consequential approvals. You should never need to remember detailed repository history, reconstruct state after a session ends, list the files Claude should inspect, copy anything between the tools, arbitrate technical claims, or maintain continuity yourself. You may interrupt at any time, and you receive genuine decisions, never unresolved model disputes.

**Controller Codex** is the operator-side control room. It continuously asks: are we doing the right work, with the right context, at the right quality, for the right reason, and should we still be doing it? It prepares and prioritises the next justified work unit, protects alignment with the approved project objective, and assesses whether evidence supports progression. Its ordinary assessment is a concise progression decision, not a strategic reinterpretation after every result. Codex manages progression; it is not sovereign over the project or over repository reality, and it does not determine technical truth by assertion.

**Claude Code** is the repository-side engineering environment. It owns live inspection, technical investigation, design within approved boundaries, implementation, refactoring, testing, runtime verification, Git-level evidence, verification of Codex's findings, and technical corrections. Claude independently verifies repository-dependent claims rather than treating the brief as unquestionable truth. Claude is not a conformance engine.

**Independent Reviewer Codex** is a separate, escalation-only role. Normal Controller assessment is not independent review. Where consequence genuinely warrants independence, a fresh Codex context is used, receiving only what it needs: the original need, the governing authority, the defined review object, the relevant repository state or diff, and Claude's evidence. It deliberately does not inherit the Controller's accumulated reasoning and preferences. For ordinary and Standard work, one builder and one reviewer, Claude building and Controller Codex reviewing, is normally sufficient. Freshness is a tool for named risks, not a default and not a quality guarantee in itself.

---

## 6. Codex duty one: protect the objective

Codex constantly checks the work against the operator-approved plan, the current objective, the intended business outcome, settled decisions, current priorities, and the governing workflow. The question is never only "did Claude satisfy the brief?" but always also "did this materially move the project toward the approved goal?"

Codex actively watches for: project drift, scope creep, work that locally optimises the wrong thing, technically impressive work with little project value, work that used to matter but no longer does, premature implementation, and repository polishing displacing higher-value project work.

Before any meaningful new unit, Codex must be able to answer: What project goal does this advance? Why does it matter now? What becomes meaningfully better if it succeeds? Is it currently more valuable than the obvious alternatives? Weak answers mean the work gets challenged, not continued.

---

## 7. Codex duty two: prepare the context

Codex owns context engineering. The governing principle: **raw context is source material, not execution context.** Whatever the source, your messages, GPT output, earlier sessions, research, repository notes, old plans, READMEs, archives, Codex retrieves it, refines it, reconciles it, classifies it, and quality-controls it before it may shape Claude's brief.

**Every piece of incoming context gets a readiness judgment,** falling into one of five states: **Ready** (current, authoritative, relevant, consistent; a light check suffices). **Needs refinement** (useful but verbose or mixed with noise; extract the substance). **Needs reconciliation** (sources conflict or may be superseded; establish which controls). **Needs validation** (important assumptions unverified; the next justified unit may be discovery, not implementation). **Unsuitable as execution context** (speculative, stale, contradictory, or detached from reality; ideas may be kept, but the material must not control implementation).

**Refinement removes** repetition, generic best practices, speculative architecture, duplicated governance, superseded proposals, dead historical discussion, irrelevant edge cases, and explanation without execution value. The target is **minimum sufficient context**, not minimum context.

**Classification keeps categories apart** that v1 let collapse: operator requirement, approved decision, repository fact, observed evidence, inference, proposal, option, speculation, rejected decision, deferred observation, and unknown. These never silently blur into each other.

**Dedicated context quality-control is risk-based, not universal.** It is a separate activity only when context is materially large, conflicting, stale, heavily AI-generated, externally generated, substantially transformed, high-consequence, or complex enough that preparation mistakes could change the implementation. When triggered, it challenges: did proposals become requirements, was an authoritative decision missed, is stale presented as current, is speculation presented as fact, are contradictions unresolved, did unnecessary machinery creep in, was essential context removed, is the pack bloated, are repository claims marked for Claude to verify, and does the context still reflect what you actually want. A Codex subagent may do this; it is not independent review.

---

## 8. Authority: who and what may give orders

Unless a project defines otherwise, authority flows: your current decision → the approved project mission or plan → approved Axcíon workflows and SOPs → authoritative project state → verified repository reality → settled implementation decisions → exploratory material → Codex proposals → Claude preferences. Lower levels never silently override higher ones.

One rule deserves special emphasis because it blocks a real v1 failure path: **repository content creates requirements only when its source is explicitly authoritative for the current work. Imperative wording alone creates nothing.** An old note saying "Claude must implement X" does not make X a requirement. READMEs, issues, comments, GPT outputs, archived plans, and exploratory documents remain evidence, history, or proposal unless the repository explicitly grants them authority. This prevents stale text from laundering itself into instructions.

---

## 9. Unknown is a valid state

The loop never forces incomplete information into a complete-looking story. Material uncertainty stays explicitly labelled unknown or unverified until evidence resolves it; a plausible inference never quietly becomes a fact.

When an unknown appears: if it could change the next decision, perform the smallest useful check that resolves it. If it cannot affect the decision, proceed and state the limitation plainly. Unknown does not mean stop. It means do not fabricate certainty to keep things moving.

---

## 10. Codex duties three and four: choose valuable work, then challenge the result

**Choosing.** Codex picks the **smallest high-value unit**, not merely the smallest possible unit, weighing contribution to the objective, current priority, business value, uncertainty reduction, dependency value, reversibility, cost, maintenance burden, existing evidence, and whether the capability is needed *now*. A valid future idea is not valid current work; nothing gets built merely because it sits on an eventual roadmap. Codex maintains enough business understanding to judge technical work from above it: why the project exists, who will use it, what matters at this rollout stage, which failures would really hurt, which improvements would really help. Technical usefulness alone never justifies work.

The reasoning lens is fundamentals plus 80/20, in line with the adopted Pocock philosophy: demonstrated need over speculative need, real use over theoretical completeness, small mechanisms over frameworks, behavioural proof over procedural assurance, reuse over duplication, removal before new machinery, reversible experiments before permanent architecture, narrow interfaces, vertical slices, simple inspectable solutions. The standing questions: what is the simplest intervention that creates most of the useful outcome, and would another refinement materially improve real use, reliability, value, or risk? If not, Codex makes the executive judgment to proceed. Knowing when to stop refining is part of the job.

**Challenging.** Every substantive Claude result returns to Codex before progression, and Codex genuinely red-teams it rather than checking conformance. The assessment covers: premise (was the real problem solved?), project alignment, goal contribution, proportionality, simplicity (can machinery be removed?), architecture and ownership, implementation strength, evidence quality, scope discipline, priority (was this worth doing now?), and continuation value (is another unit worth it?).

Codex actively hunts for wrong premises, unnecessary architecture, duplicated authority, brittle seams, speculative controls, over-governance, weak evidence, work that is technically fine but operationally poor, missing simpler approaches, underbuilt solutions, requirements simplified away, drift, and low-value work. It may propose alternatives when a material weakness exists, a meaningfully simpler solution exists, a better ownership boundary exists, the implementation cannot meet the need, or new evidence invalidates the approach. It may **not** demand change because another implementation is merely aesthetically cleaner or more theoretically complete. Strengthen work where it matters; never manufacture refinement work where it does not.

**Unexpected breadth is a signal, not a verdict.** If three files were expected and seventeen changed, that is neither automatically wrong nor automatically fine; it is evidence that an assumption about scope, dependencies, ownership, or approach may have been wrong, and Codex inspects the reason before treating the result as routine.

**The two opposite failures are guarded equally.** Overbuilding: speculative infrastructure, premature automation, excessive abstraction, duplicated workflows, governance systems, needless documentation, future-proofing without need. Underbuilding: brittle shortcuts, missing safeguards, inadequate support for realistic operation, insufficient testing, satisfying the literal brief while failing the real need. The target is always the smallest solution that sufficiently solves the important real need without disproportionate future cost.

---

## 11. Findings, corrections, and closing the review

Codex classifies findings into exactly three kinds. **Blocking:** the result does not meet the approved need, violates a material constraint, or cannot safely progress. **Bounded correction:** the approach is valid but contains a contained problem. **Non-blocking improvement:** a potentially useful refinement unnecessary for the current outcome, which does not enter current scope.

Every finding must also state its category honestly: an approved requirement not met, new evidence invalidating the approach, a bounded implementation defect, an accepted-risk decision, or an optional improvement. Only the first three can justify current correction. This is what stops reviews from quietly adding new requirements after scope was approved.

Claude adjudicates material findings rather than implementing them on Codex's authority: it may accept, reject with evidence, defer, simplify differently, accept as a limitation, or escalate a decision to you.

**The correction discipline** (the session's refinement of the spec, replacing v1's rigid budget): the review's material findings freeze the correction scope. Claude corrects exactly those. The closure check verifies the frozen findings and any blocking regression the correction caused, and nothing else; it never restarts a broad review that discovers a new list. If one correction proves insufficient, Codex chooses once, on value and risk rather than a round counter, among: accept a disclosed limitation, permit one final tightly bounded fix (no new broad review; checked only against its own scope), revert, reframe, or stop. Genuine risk acceptance escalates to you. The menu is the exit from correction, not a door back into it.

**Where a formal review occurs, the reviewed candidate is frozen by exact Git commit.** Any later change creates a new candidate and makes the review stale; approval attaches to reviewed bytes, never to a name. This precise rule exists at consequential decision points only; it does not spread commit-fingerprinting across ordinary work.

**When the two models disagree technically,** the question is: what observable evidence would distinguish the claims? Then someone inspects or tests it. Argument chains are not the mechanism; repository reality is. Only genuine business, priority, maintenance, or accepted-risk trade-offs reach you unresolved.

---

## 12. Codex duty five: know when to stop, including stopping governance itself

**The default governance budget:** fast work gets one preparation, one implementation, one assessment. Meaningful work gets one preparation, one implementation, one bounded correction if required. Consequential work gets additional governance only where a specific demonstrated risk justifies it.

**Before another substantive cycle,** Codex must answer: which acceptance condition remains unsatisfied, what evidence shows the failure, why it blocks progression, why it was not resolved earlier, whether the remaining change is bounded, why another cycle beats accepting a limitation or reverting or reframing, whether the review is smuggling in a new requirement, and whether the expected value exceeds the added complexity, delay, and maintenance. Weak answers mean stop refining.

**Before adding any governance,** another reviewer, context pass, test layer, planning pass, document, review, or correction cycle, four questions must have clear answers: what specific risk does this address, what evidence says that risk is material, what decision could it realistically change, and is that value greater than the delay and complexity it introduces? No clear answers, no addition. A safeguard is normally absorbed into ordinary Codex or Claude work before it may become a separate stage, and Codex simplifies or stops governance when coordination overhead becomes disproportionate to the work.

**The continuation test** runs at every natural boundary: does this still deserve another unit? Valid reasons to stop include: the useful objective is achieved, the problem was smaller than expected, remaining issues are cosmetic, further improvement has low value, the next step is disproportionate, real-world evidence does not justify more, priorities changed, or something more valuable now exists. The loop must be able to kill its own work.

---

## 13. The three modes of work

**Discovery** is used when the problem, requirement, or right solution is materially uncertain: frame the question, inspect reality, return evidence, interpret, then continue, stop, or reframe. Never implement against an unverified load-bearing premise.

**Implementation** is used when need and boundaries are sufficiently established: brief, verify the premise, implement, prove, assess, one bounded correction if justified, decide.

**Adoption** is used when the capability exists and the question is whether it enters normal operations: operate or demonstrate it, collect evidence, assess reliability and value, and then you decide its lifecycle state. Technical completion never automatically means adoption.

---

## 14. Specialist workflows own the method

The Work Loop does not replace your specialist workflows (the Project Development Lifecycle, Diagnose and Fix, AI Resource Development Lifecycle, Capability Proving, Independent Review, research workflows, and others). Those define the method. Codex determines which workflow governs, which phase is active, what that phase means in this project, what the highest-value bounded unit is now, and what evidence is required before progression, translating the workflow into the actual task rather than copying it into every brief. The workflow owns methodology; Codex owns situational interpretation; Claude owns execution. The Work Loop supplies orientation, progression, and assessment around a specialist workflow and never layers a second review or state system on top of one that has its own.

---

## 15. The brief

Codex writes Claude's work request into shared task state, containing only what the unit requires: the objective; why it matters; the minimum prepared context; the governing sources Claude should inspect; the repository claims Claude must verify rather than assume; the scope Claude is authorised to touch; the exclusions; the important constraints without unnecessary technical prescription; the required evidence; the completion condition; the stop conditions (when Claude reports rather than improvises); and Claude's explicit authority to challenge inaccurate premises and choose the technically appropriate implementation within the approved objective. The brief is never a disguised implementation specification.

---

## 16. How Claude executes

Claude begins by verifying relevant repository reality: repository, branch, worktree, authority sources, implementation state, affected consumers, dependencies, and the validity of the brief's claims. It then works in vertical, independently verifiable slices: demonstrate or reproduce, implement, verify, refactor, commit.

Claude does not: redesign adjacent systems without demonstrated need, add speculative machinery, silently expand scope, treat Codex proposals as implementation authority, reopen settled decisions for convenience, or claim success without evidence. Local reversible decisions stay local, made in-session and noted; only discoveries that materially change objective, scope, ownership, architecture, or operator policy return to planning.

**Claude must challenge Codex** when repository reality shows a false assumption, stale context, inappropriate direction, conflict with actual architecture, needless complexity, or a request that cannot meet its own stated objective. The challenge returns what was inspected, what was observed, why the premise fails, and the technically suitable alternative within the approved objective. Codex's context advantage never makes it authoritative about the repository.

---

## 17. The evidence rules

**Verify when verifiable.** A material claim that can reasonably be checked against primary evidence gets checked, never inferred from documentation, memory, or the other model's statement. Is the command actually invoked, does the dependency exist, is the worktree clean, does the test actually run, does the hook actually fire? Depth stays proportionate; not every minor statement becomes an investigation.

**Absence claims state their search boundary.** "Unused," "absent," "no consumer," "never invoked": each supports only "not found in the searched scope." For consequential absence claims, the search method should also show it can find a known positive example. The conclusion never exceeds the boundary.

**Evidence must be capable of exposing failure.** A passing checklist proves nothing by itself. Where consequence warrants, evidence means realistic invocation, representative scenarios, negative cases, reproduction of the original failure, recovery testing, independent observation, or comparison against a known positive control. The practical question is always: what is the cheapest reliable evidence that would make this claim credible? Narrative confidence is not evidence.

**Proving a result** means Claude leaves a bounded record Codex can assess: what reality was verified, which assumptions were confirmed, rejected, or remain unknown, what was completed and changed, what was tested and observed, what remains limited, where Claude departed from the brief and why, and what it recommends next. Claims of correctness, completion, safety, compatibility, or readiness always require evidence proportionate to the claim.

---

## 18. Stability of scope and success criteria

Once implementation begins, the approved problem, scope, exclusions, and acceptance conditions stay stable. Success criteria never silently change during execution or assessment. A material change is justified only when new evidence invalidates the framing, the work is explicitly reframed, or you deliberately change scope. This protects against both failure directions at once: Claude redefining success around what it happened to build, and Codex introducing new requirements during review. New evidence may change the plan; new preference alone may not.

---

## 19. State, memory, and continuity

**Conversation is temporary; the repository is durable.** Each substantive active task maintains one concise authoritative current-state artifact containing only what a future session needs and cannot reconstruct elsewhere. While active, at most: the objective and why it matters, the governing project, the active workflow and phase, the approved scope, the authoritative context sources, material settled decisions, current status, the latest material result, any blocker, meaningful deferrals, and the exact next action. It describes current authoritative reality; it is never a conversation diary. On closure, only the outcome, important decisions, the final commit and evidence pointer, and accepted limitations remain.

**Mechanical state is derived, not copied.** Branch, HEAD, worktree, changed files, and history come from Git and tooling at the moment of use; prose never duplicates what tools can reliably provide.

**Updates are event-driven,** happening when authoritative reality materially changes: scope changes, a major assumption is disproved, implementation completes, a material decision lands, work moves sessions, the task pauses or closes. Never continuous rewriting.

**The standing continuity test:** could a fresh Codex and a fresh Claude continue correctly using repository state and Git alone, with no conversational memory? If not, the state is incomplete.

**Session handoffs** happen proactively, before context degradation creates decision or implementation risk: when a phase closes, a unit finishes, history accumulates, compression threatens important distinctions, or a fresh session would materially improve precision. Before any handoff, the state artifact is brought current, so the next session can determine the goal, the why, the phase, the scope, the sources, the settled decisions, the completed work, the evidence, the unresolved items, the deferrals, and exactly what happens next. The repository, never the old conversation, is the continuation mechanism, and sessions on both sides must be replaceable without losing continuity.

---

## 20. Isolation and the single writer

Substantive implementation normally uses an isolated task workspace where practical, with a known base, a clear active writer, shared visibility for both tools, isolation from unrelated work, a bounded diff, clean review, and clean abandonment if needed. A task worktree is the preferred model where appropriate; the exact mechanism is a technical implementation matter, not part of the operating model.

Single-writer ownership, one session working on a task at a time, is stated honestly as an operating assumption, never falsely presented as software-enforced. An enforceable ownership mechanism is built only for consequential multi-session work and only after real conflicts demonstrate the need.

---

## 21. Deferred work

Useful ideas stay findable without becoming automatic future scope. **Task-level deferrals** matter only to the active task and are recorded only where useful for its continuation. **Project-level deferrals** go into the project's existing authoritative continuation location, stating the idea, why it is not needed now, and what evidence would justify reopening it. No new backlog or decision-register system gets created just to hold deferrals, and a non-blocking observation never spawns another execution cycle.

---

## 22. What you see and decide

Codex keeps you oriented in plain language without low-level noise. A useful update tells you: what was established, what Claude actually found, whether the original premise survived, whether the work still aligns with the plan, what materially changed, what Codex believes should happen next and why, and whether your input is needed. Routine continuation inside settled boundaries does not require repeated approval; you supervise direction rather than acting as a gatekeeper for mechanics. Decisions reach you only at consequential boundaries: outcome, priority, scope, accepted risk, adoption, and material business trade-offs. Repository mechanics get resolved between the models through evidence.

---

## 23. When a unit is done

A unit is complete when: the approved need is sufficiently addressed; the acceptance conditions being assessed are still the agreed ones; no blocking defect remains; evidence is proportionate and meaningful; the result aligns with the approved plan and materially contributes to the intended outcome; the applicable workflow was followed at the right depth; no unnecessary complexity entered and no necessary requirement was simplified away; remaining observations are genuinely non-blocking; deferrals are preserved; the state artifact reflects reality; and the next state is explicit.

Completion explicitly does **not** require: eliminating every unknown, implementing every improvement, solving hypothetical futures, building permanent mechanisms for speculative needs, producing another review just because one is available, theoretical perfection, or continued polishing after the useful objective is achieved. A disclosed limitation is a legitimate, respectable outcome, and the working quality standard is a sufficiently strong result, roughly 90%, not completeness.

---

## 24. The automation boundary

This entire system describes behaviour, not transport. It deliberately does not define hooks, polling, session identifiers, file watchers, retry logic, automatic session creation, crash recovery, or application automation. The required interface is only this: Codex produces a bounded work request; Claude produces a bounded result; both exchange authoritative state through the repository. Automation may later implement that interface, and the operating model must survive the replacement of any underlying tool. Until automation earns its place through a demonstrated bottleneck, invocation is manual, and the handoff is a commit either way.

---

## 25. The success standard: what "working" means

The complete Work Loop is functioning correctly when you can hand it an objective and whatever material exists, and the system reliably: decides whether the loop is needed at all; picks a proportionate depth; understands why the project matters; identifies the approved objective and priorities; refines and validates context; separates decisions from proposals and facts from speculation; preserves unknowns; identifies the governing workflow; chooses the smallest high-value unit and explains its value to you; briefs Claude with minimum sufficient context; lets Claude verify the live repository and challenge false premises; verifies material claims directly; never mistakes an incomplete search for proof of absence; keeps scope and success criteria stable unless evidence justifies reframing; proves behaviour with evidence capable of revealing failure; red-teams for correctness, simplicity, maintainability, alignment, and real value; separates blocking defects from optional improvements; resolves disagreement through evidence; runs no more cycles than demonstrated risk requires; recognises trivial, premature, or low-value work; makes the executive call to proceed when the result is strong enough; preserves deferrals without expanding scope; maintains concise durable state for clean handoffs; and stops both implementation and governance when further work no longer materially improves the outcome.

The intended end state, in one sentence: **you remain firmly in control without being the memory system, the transport layer, the technical reviewer, or the day-to-day orchestrator. Codex protects what should happen and whether it should continue. Claude protects how it is executed. Evidence protects what is true. You protect what matters.**
