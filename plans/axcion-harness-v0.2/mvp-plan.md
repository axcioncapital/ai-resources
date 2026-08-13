# Axcíon Harness v0.2 — Research and MVP Recommendation

**Date:** 2026-08-08  
**Status:** Proposed direction for operator review; no implementation authorized  
**Scope:** Repository evidence, a small set of official primary sources, and an Axcíon-specific MVP plan  
**Input reviewed:** the attached GPT harness proposal; the May harness; Work Loop v2; the approved context-engineering specification; and the current handoff-dispatcher investigation, implementation spike, and evidence logs

## Executive recommendation

Build harness v0.2 as a **consolidation and hardening layer around the current Work Loop v2**, not as a new `.work-loop/` platform.

The attached proposal identifies the right product needs—durable task truth, fresh-model context, checkpoints, deterministic guardrails, Git-backed evidence, conditional isolation, and cross-model review—but its proposed architecture is no longer aligned with the repository. In particular, `contract.yaml`, `state.md`, `decisions.md`, and `handoff.md` would recreate the multi-artifact coordination burden that the current approved context-engineering work explicitly rejects.

The Axcíon-specific MVP should preserve these existing decisions:

- one canonical plan when a durable plan is needed;
- one authoritative Work Loop task-state file for active execution;
- Git as the implementation and evidence substrate;
- Codex for framing, context preparation, and bounded assessment;
- Claude for repository verification, implementation, tests, and commits;
- an external dispatcher as a courier, never as a semantic decision-maker;
- fresh actor processes that reconstruct context from the task state, relevant durable sources, and Git—not from transcript continuity;
- structural validation and containment at the transport boundary;
- one proportionate correction loop, not recursive review;
- worktrees only when concurrency, unattended operation, or task size justifies their cost.

The first milestone is therefore not “build seven new harness modules.” It is: **make one existing Work Loop task run safely from one operator objective to one terminal result, across fresh Codex and Claude processes, without manual context ferrying or a second semantic state system.**

Before unattended use, the current descendant-process escape and shared-worktree/ambient-writer problems must be closed or explicitly contained. The dispatcher spike is valuable evidence, but it should remain a spike until those safety conditions and real-task proof are satisfied.

## The repository already contains three generations of harness thinking

### 1. The May harness proved useful invariants—and the cost of turning them into a framework

The May harness architecture established several durable ideas:

- state belongs on disk;
- transitions should be explicit;
- one writer owns each mutable artifact;
- verification must precede state transition;
- blocked work needs a concrete reason and next action;
- compaction should preserve task truth rather than the transcript.

Its lifecycle was explicit and testable: `pending → in_progress → verified → qc_passed → committed`, with blocked states and verification playbooks layered around it. See [state-machine.md](../../../harness/schemas/state-machine.md) and [current-state-schema.md](../../../harness/schemas/current-state-schema.md).

The later review, however, reached the key conclusion for v0.2: the architecture was directionally right while the execution was overbuilt. It described a documentation-heavy runtime, numerous schemas and skills, brittle couplings, a hardening registry with no proven value, and only one use of the real flow beyond a fixture. Its recommendation was to run real sessions before adding more framework. See [Harness Review — 2026-05-25](../../../harness/reviews/harness-review-2026-05-25.md) and [the May roadmap](../../../harness/prep/harness-roadmap.md).

That history should be treated as experimental evidence, not as a dormant platform to revive. The retained contribution is the invariant set. The retired contribution is the large schema-and-governor surface.

There is an important difference between the intended status and repository reality: the May harness is not yet fully dormant. The workspace-level [`.claude/settings.json`](../../../.claude/settings.json) still registers its `PreCompact`, `PostCompact`, and `SubagentStop` hooks; the compaction hooks append to May's session log, whose mandate and state still describe the old fixture task. The old [`harness-start`](../../../.claude/commands/harness-start.md) entry point and governor/parser/reporter skills also remain discoverable. The same settings file defaults Claude to `bypassPermissions`. That may be an operator convenience outside this project, but v0.2 must never inherit it as an unattended or supervised execution policy.

Phase 0 therefore needs a real runtime retirement, not only a prose designation: remove the legacy hook registrations and normal routing entry points, preserve the May files as historical evidence initially, and verify that no v0.2 launch path can reach the stale session state or a bypass-permissions default.

### 2. Work Loop v2 deliberately shrank the operating model

The approved Work Loop v2 proposal says why v1 failed: every weakness produced more machinery, the operator remained a copy-and-paste transport layer, and the system optimized process rather than time to a sufficient useful outcome. It settled on Direct and Standard modes, one bounded review, a 90% quality target, small planning, and probably one authoritative interface rather than dogma about many artifacts. See [Work Loop v2 MVP proposal v0.4](../../plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md).

Its executable core defines the operating split:

- Codex prepares and prioritizes the unit, writes the brief, and assesses the result;
- Claude verifies repository reality, implements, tests, and supplies evidence;
- the operator owns priorities, scope, and hard-to-reverse choices;
- small Direct work bypasses the loop;
- Standard work proceeds in the smallest useful unit;
- Codex may close, continue, request one correction, or stop;
- the state file is current truth, not a diary.

The deployed Codex skill also makes isolation proportional: separate repositories need no worktree; an ordinary one-writer local task can use the current checkout; concurrent writers, unattended work, and genuinely large work justify deliberate isolation. See [Work Loop v2 executable core](../../plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md), [the deployed Codex skill](../../.agents/skills/work-loop-v2/SKILL.md), and [the Claude command](../../.claude/commands/work-loop-v2.md).

This is already most of the semantic harness. v0.2 should make it easier and safer to execute, not replace it.

Work Loop v1 is also only partially retired. Its Claude command has been removed, but the broad Codex [`work-loop` skill](../../.agents/skills/work-loop/SKILL.md) and older documentation remain, and current implementation evidence notes that an ordinary unnamed request can still activate v1. Harness v0.2 cannot have two plausible semantic routers. Completing v1 retirement—or narrowing its activation so it cannot compete with v2—is another Phase 0 prerequisite.

### 3. The approved context-engineering specification closes the preparation gap without adding state

The approved context-engineering specification defines the post-MVP v0.2 function precisely: operator objective plus supplied materials should become the smallest sufficient, plan-aligned brief, using and updating only the minimum durable sources. It explicitly rejects a separate preparation stage, iterative interview/QC machinery, a context-pack lifecycle, a decision register, a provenance ledger, plan copies, a new log, or a second project-state system. It allows only three durable categories: an optional operator source, one canonical plan, and an existing authoritative current-state surface. See [Context Engineering Specification v0.1](../../plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md).

That means the attached proposal's “Task Contract” and “Context Builder” should be implemented as behavior at the Work Loop entry seam, not as new file types or a generic packing subsystem. Plan alignment should be visible but not become an approval gate. Discovery should start from a relevance-gated source set and expand only when repository evidence creates a reason.

This is not greenfield work. The behavior was integrated in commit `4f3d6ca` and hardened in `daebb0c3`; the current evidence reports a 149/0 deterministic harness. It is still explicitly **implemented but not adopted**, because the required live behavioral proofs and adoption conditions have not all been met. See [Context Engineering implementation evidence](../../logs/work-loop/context-engineering-implementation.md). Harness v0.2 should finish those proofs and consume the existing one-brief seam, not implement another context builder.

### 4. Handoff automation already exists as an evidence-rich spike

The handoff investigation correctly separates transport from judgment. It recommends an external dispatcher that reads the exact task, launches at most one actor, observes the resulting state transition, and stops on operator action, invalid or missing transitions, process failure, timeout, dirty-state ambiguity, or the hop limit. It rejects reciprocal model hooks as an orchestrator because hooks are lifecycle signals, not a durable supervisor. See [Handoff Automation Investigation](../../plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md).

The current spike has moved well beyond a paper design. It exercises exact-task routing, fresh actor processes, bounded hopping, timeouts/deadlines, path allowlists, dry-run/status modes, permission and crash handling, repository-state checks, operator boundaries, and a contained unattended profile. Its evidence includes a successful tracer bullet, safety-gate suites, and single-host containment work. See [the spike README](../../plans/work-loop-v2-v0.2/handoff-automation-spike/README.md), [dispatcher evidence](../../logs/work-loop/work-loop-v2-handoff-dispatcher.md), [safety-gate evidence](../../logs/work-loop/work-loop-v2-dispatcher-safety-gates.md), and [contained unattended profile evidence](../../logs/work-loop/work-loop-v2-contained-unattended-profile.md).

It is nevertheless still a spike. The current evidence explicitly leaves a fully detached descendant/daemon escape as a Phase 2 blocker. A dedicated worktree mechanism has fixture-sized proof, but a production policy is complicated by ambient repository writers such as the friction log. Passing controller tests does not make unattended execution safe when the host-level escape condition remains.

As a local verification check for this investigation, `handoff-automation-spike/dispatch.test.sh` was run inside Codex's restricted sandbox. It reported `pass=322 fail=15`; all 15 failures were in OS process-inspection or teardown cases, and direct `ps` inspection was denied by the sandbox with `Operation not permitted`. This is not a valid host-level containment run and neither replaces nor disproves the spike README's recorded unsandboxed 368/0 suite. It does demonstrate why process-lifetime claims must be reproduced in the intended host environment rather than inferred from a sandboxed aggregate count.

## What the attached GPT proposal gets right—and what should change

| Proposed capability | Verdict for Axcíon v0.2 | Recommended form |
|---|---|---|
| Task contract | Keep the semantics, reject a new contract file | Express objective, why, governing claims, scope, exclusions, evidence, and stop conditions in the existing brief/state interface; use a canonical plan only when durable planning is justified. |
| Persistent task state | Keep one authoritative surface | Continue `ai-resources/logs/work-loop/<task-id>.md` with exact task binding, `turn`, and the current bounded headings. Do not add `decisions.md` or `handoff.md`. |
| Claude/Codex context builder | Keep, but make it the approved context-engineering behavior | One preparation pass, relevance-gated discovery, explicit source authority, and one artifact serving the operator and Claude. Do not build generic context bundles or transcript summaries. |
| Model adapters | Keep thin adapters | Use current scripted interfaces and structured output where helpful; adapters launch and observe but do not decide task truth. |
| Automated checkpoints | Keep at actor handback | A checkpoint is an atomic state handback plus verified Git/evidence state. It is not an extra wrap document. |
| Drift and complexity checks | Keep proportionately | Validate task binding, allowed transitions, scope/path boundaries, expected evidence, and plan-alignment fields. Trigger semantic contract review only when evidence warrants it. |
| Deterministic guardrails | Keep and prioritize | Dirty-tree ambiguity, protected paths, allowlists, exact checkout, timeout/deadline, sandbox, no automatic push/merge/delete, and terminal-event validation belong in the supervisor. |
| Git verification | Keep as ground truth, with a boundary | The supervisor can verify branch, checkout, commit, diff paths, and test exit status; it must not decide that implementation semantics are correct. |
| Automatic skill selection | Do not create a parallel registry | Use native Agent Skills metadata and repository routing. The [Agent Skills specification](https://agentskills.io/specification) already defines progressively disclosed metadata, instructions, scripts, and resources. Add routing rules only where real misrouting is observed. |
| Final cross-model review | Already part of Work Loop v2 | Codex assesses each meaningful unit and may request one correction. Direct work and trivial changes should not be forced through an expensive final review. |
| Worktree per task | Make conditional, not universal | Use a dedicated worktree for concurrent writers, unattended execution, or large isolated work; otherwise preserve the current checkout. Git explicitly supports multiple working trees attached to one repository, but each adds lifecycle cost. See [git-worktree](https://git-scm.com/docs/git-worktree.html). |
| Session/checkpoint log | Keep only operational events | Emit a small machine-readable run event stream or terminal result for observability. Do not make it a competing semantic record or a human-maintained diary. |
| Exclude swarms, databases, DSLs, dashboards, vector stores, and broad eval platforms | Agree | The MVP needs one reliable vertical slice and a small regression pack, not a platform. |

The proposal's most important correction is therefore architectural: **do not create `.work-loop/tasks/<id>/{contract.yaml,state.md,decisions.md,handoff.md}`.** That layout would divide current truth among four surfaces, create ownership and synchronization problems, and directly contradict the current “no fourth durable category” decision.

## Disposition of the adjacent 80/20 proposals

A second proposal considered repository indexes, decision retrieval, context packs, behavioral evals, failure-to-guardrail conversion, skill catalogs, GitHub control planes, dependency graphs, RAG, memory, and MCP. Only three ideas belong in v0.2, and none justifies a new platform component:

1. **A small behavioral evaluation pack.** Keep roughly 10–15 realistic positive and negative scenarios covering admission, relevant-source discovery, false premises, exact handoffs, scope drift, unnecessary machinery, operator stops, fresh-context recovery, and bounded review. This complements deterministic dispatcher tests; it does not become a general eval platform.
2. **Failure → smallest guardrail as an operating rule.** Classify an observed failure as judgment, context, routing, deterministic enforcement, or repository-architecture failure, then apply the smallest correction at the owning layer. Do not respond to isolated incidents by automatically adding instructions, hooks, skills, or durable artifacts.
3. **Prior-decision checking for structural units.** Context preparation must inspect relevant existing decisions and approved plans before proposing a database, registry, workflow stage, routing system, or other permanent machinery. Use `logs/decisions.md`, approved plans, the task state, and governing repository documents. Do not create `.ai/decisions/` or another decision store.

The deterministic-policy principle is already part of the supervisor boundary. Prefer dispatcher validation, sandbox policy, and literal state/Git checks. Add a hook only when a named lifecycle event is necessary for a proven rule; hooks must not become the orchestrator or a generic policy engine.

The following remain deferred until measured failures justify them: a generated knowledge index, a new ADR store, a context-pack artifact, RAG/vector or hybrid retrieval infrastructure, a repository dependency graph, a capability graph, a generated skill registry, GitHub issues or PRs as the control plane, persistent fact memory, a new PR-review skill, and an MCP gateway. Their intended benefits should first be tested against the existing context-engineering seam, native skill metadata, repository search, task state, and Git.

## Target architecture

The smallest coherent architecture has three layers with deliberately different responsibilities.

### Semantic layer: Work Loop v2 and context engineering

This layer owns what the task means:

- Direct versus Standard routing;
- relevance-gated discovery;
- source authority and conflict reconciliation;
- the smallest useful unit;
- plan alignment;
- the task brief;
- the current task state;
- Codex's close/continue/correct/stop judgment;
- operator decisions.

Its durable surfaces are the existing canonical plan and the existing task-state file. It must not depend on the dispatcher to preserve meaning.

### Transport layer: exact-task dispatcher and launch adapters

This layer owns how a turn is carried:

- bind one task ID to one state file and one checkout;
- validate the expected current actor and transition;
- launch a fresh Claude or Codex process;
- enforce one actor at a time;
- apply sandbox, network, tool, path, timeout, deadline, and hop policies;
- detect interruption and supervised descendants;
- stop on ambiguity;
- report a structured terminal condition.

The dispatcher is replaceable. Removing it should leave the semantic loop intact, with the operator able to carry the same `turn` manually.

### Evidence layer: repository facts and bounded assessment

This layer owns what can be demonstrated:

- exact Git checkout and branch;
- clean/dirty preconditions;
- commit existence and allowed diff paths;
- command exit status and named verification results;
- the state transition actually written;
- structured terminal outcome;
- a small scenario/evaluation suite;
- Codex's bounded semantic assessment.

The supervisor may verify structure and repository facts. It must not infer that tests are meaningful, the product decision is correct, or the task satisfies its objective; those remain actor and reviewer judgments.

```text
Operator objective + supplied materials
                  |
                  v
     Codex context engineering / brief
       (plan + current state + repo facts)
                  |
                  v
        one Work Loop task-state file
                  |
                  v
       external exact-task dispatcher
        /                         \
fresh Claude process       fresh Codex process
verify / implement / test   assess / continue / stop
        \                         /
         state handback + Git evidence
                  |
                  v
    structural terminal event to operator
```

## Proposed MVP scope

### Capability 1: one-touch Work Loop intake

Adopt and expose the existing public entry path that accepts an operator objective and optional supplied materials, performs the approved single context-engineering pass, decides Direct versus Standard, and—only for Standard work—creates or updates the canonical task-state surface. The work here is behavioral proof and a stable entry contract, not another context-builder implementation.

The intake must:

- preserve the operator's objective in plain language;
- distinguish governing decisions from source material and technical preferences;
- reconcile conflicts using the existing authority hierarchy;
- identify the smallest justified unit;
- include a short operator-facing introduction and a self-contained actor-facing brief;
- avoid an interview loop unless a missing choice would materially change the work;
- create no routine durable artifact beyond the already-permitted plan/state surfaces.

This is the attached proposal's “Task Contract” and “Context Builder,” compressed into one existing seam.

### Capability 2: strict state and transition validation

Implement a small validator around the current task-state contract, not a new workflow engine. It should check:

- exact task ID in filename and frontmatter;
- exact checkout/repository binding;
- valid `turn` value;
- required bounded headings and their size limits;
- one allowed transition from the observed prior state;
- no silent loss of operator decisions, result, evidence, or next action;
- no unexpected second task-state file becoming authoritative;
- closure compaction when the task is terminal.

Prefer a literal, narrow parser with fixture tests over a general schema language. JSON Schema can validate a structured terminal event or adapter output, but it should not force the human-readable task file into a large machine schema. [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12) is suitable if structured outputs need interoperable validation.

### Capability 3: thin, fresh-process actor adapters

Maintain separate launch adapters for Claude and Codex because the role prompts and execution surfaces differ. Each launch must be fresh, given the exact checkout and task, and reconstruct context from durable sources and Git.

Claude Code officially supports non-interactive `claude -p`, JSON or streaming JSON output, JSON Schema-constrained structured output, session/usage metadata, hooks, permissions, and OS-level sandboxing. Those primitives are enough for a thin adapter; they do not require an invented orchestration protocol. See the [Claude Code CLI reference](https://code.claude.com/docs/en/cli-usage), [hooks](https://code.claude.com/docs/en/hooks), [permissions](https://code.claude.com/docs/en/permissions), and [sandboxing](https://code.claude.com/docs/en/sandboxing).

Codex officially supports `codex exec` for scripted/CI execution, JSONL output, and session continuation. For a later persistent controller, the App Server exposes initialization, thread start/resume/fork, turn start/steer, streamed events, working-directory, sandbox, and approval configuration. The MVP should prefer the simplest stable surface that satisfies supervision; do not adopt App Server merely because it is richer. See [Codex non-interactive mode](https://developers.openai.com/codex/noninteractive/), the [Codex CLI reference](https://developers.openai.com/codex/cli/reference/), and [Codex App Server](https://developers.openai.com/codex/app-server/).

No adapter may decide what the next semantic actor should do beyond reading the explicit `turn`. No adapter may silently resume a hidden conversation whose transcript becomes required context.

### Capability 4: atomic handback checkpoints

Define one checkpoint: the actor has written a valid state handback, the expected repository facts are observable, and the actor process has terminated or yielded cleanly.

For Claude implementation turns, the checkpoint normally includes:

- result and evidence written to the task-state file;
- the exact commit hash or an explicit reason no commit is expected;
- verification commands and outcomes;
- allowed-path and diff checks;
- the next explicit `turn`.

For Codex assessment turns, the checkpoint includes the assessment, disposition, any one bounded correction request, and the next explicit `turn`.

The supervisor should reject partial or contradictory handbacks. It should not generate `handoff.md`, `decisions.md`, or a prose checkpoint summary.

### Capability 5: deterministic containment and Git guardrails

Promote the spike's proven checks into a deliberately small production boundary:

- exact repository, checkout, and branch identity;
- clean-tree preconditions or an explicit allowlist for known ambient writers;
- allowed write paths and protected paths;
- no network or MCP access by default for unattended execution;
- no push, merge, branch deletion, worktree deletion, or other landing action;
- deadline, per-hop timeout, and maximum hop budget;
- at most one active actor for a task;
- process-tree/descendant supervision strong enough to prevent work after timeout or stop;
- stop on invalid transition, no transition, ambiguous Git state, permission denial, actor crash, or operator-required state;
- credentials and sensitive model/tool payloads excluded from run logs.

OpenAI's own guidance recommends sandboxed `workspace-write` execution for unattended Codex and reserves dangerous bypass modes for externally isolated environments. See [Codex CLI reference](https://developers.openai.com/codex/cli/reference/) and [Codex security](https://developers.openai.com/codex/security/). Claude's permission and sandbox systems are likewise complementary defense-in-depth controls, not substitutes for a supervisor boundary.

Hooks must remain signals. Claude Code offers `SessionStart`, `Stop`, and other lifecycle hooks, but the current Axcíon investigation is right not to make reciprocal hooks the orchestrator. A hook does not provide durable global ownership, exact-task serialization, or safe recovery by itself.

### Capability 6: conditional worktree preparation

The harness should choose among three explicit policies:

1. current checkout for attended, single-writer, bounded work;
2. dedicated worktree for concurrent writers, unattended execution, or materially large tasks;
3. stop and ask when ambient writers or dirty state make ownership ambiguous.

The MVP may prepare and validate a worktree mechanically. It must not automatically merge, push, remove the worktree, delete a branch, or reconcile competing user changes. The current friction-log co-writer must be resolved by a declared ownership policy or isolated location before unattended worktree use is considered reliable.

### Capability 7: one structured terminal result and a small evaluation pack

The dispatcher should end with one machine-readable terminal event and a concise operator-facing rendering. A minimal event can contain:

- `task_id`;
- `checkout` and branch;
- `terminal_reason`;
- last valid `turn` and transition;
- hop count and elapsed time;
- actor/process exit facts;
- state-file path;
- commit and changed-path facts when applicable;
- verification summary;
- whether operator action is required.

This is operational output, not semantic shadow state. It can initially be emitted as JSON/JSONL without an observability backend. OpenTelemetry's generative-AI semantic conventions are still evolving, so adopting a tracing platform is premature; a later adapter can map stable fields if real debugging demand appears. See [OpenTelemetry semantic conventions](https://opentelemetry.io/docs/specs/semconv/).

## Safety blocker before unattended promotion

The current detached-descendant result is a release blocker, not an edge-case footnote. Process groups, ancestry tracking, and inherited descriptors improve supervision, but a fully detached process that closes inherited descriptors can continue after the dispatcher believes the turn has stopped. For unattended execution, “the controller returned” must imply “no actor or actor-created workload can continue mutating the task checkout.”

The implementation plan must choose and prove one of these outcomes:

- a host-level containment mechanism that descendants cannot voluntarily escape;
- a dedicated VM/container/worker boundary whose entire lifetime the dispatcher owns;
- or a narrower MVP explicitly limited to attended execution, with unattended mode disabled.

Do not describe signal handling alone as containment. Do not promote `--unattended` based only on passing controller fixtures while a daemon escape remains reproducible.

## What is explicitly out of scope

- a replacement for Work Loop v2;
- `.work-loop/` as a new top-level runtime;
- `contract.yaml`, `decisions.md`, or `handoff.md` as routine task files;
- a second project-state surface;
- a database, vector store, provenance ledger, or decision registry;
- a general workflow DSL, agent graph, or swarm manager;
- model-chosen routing hidden from the task state;
- transcript continuity as required context;
- a generic skill registry or embeddings-based skill router;
- a generated knowledge index, new ADR store, repository dependency graph, or capability graph;
- a separate context-pack artifact or persistent fact-memory store;
- GitHub Issues or pull requests as the harness control plane;
- a dashboard or observability platform;
- automatic pushing, merging, landing, cleanup, or branch deletion;
- automatic semantic judgment by the dispatcher;
- universal worktree creation;
- a mandatory cross-model review for Direct/trivial work;
- MCP as the internal orchestration seam.

MCP remains useful later for external tools, but its specification emphasizes capability negotiation and its security guidance emphasizes least privilege, authorization, and prevention of confused-deputy/token-passthrough failures. It should be added only for a concrete external capability, not to connect two local actors that already have stable scripted interfaces. See the [MCP base protocol](https://modelcontextprotocol.io/specification/2025-11-25/basic) and [MCP security best practices](https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices).

## Evaluation plan

The MVP needs a **small harness regression pack plus real-task trials**, not an evaluation platform. Anthropic's agent-evaluation guidance usefully separates the agent harness from the evaluation harness, distinguishes transcript from outcome, and recommends deterministic code graders where possible, model or human graders for semantic judgments, balanced positive/negative cases, and multiple trials for nondeterministic behavior. See [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents).

### Deterministic scenarios

At minimum, keep fixtures for:

1. Direct work bypasses the dispatcher.
2. A false repository premise is caught before implementation.
3. Task ID, filename, frontmatter, or checkout mismatch stops the run.
4. An actor exits without a valid transition.
5. Dirty or unexpectedly changed repository state stops the run.
6. A write outside the allowlist is denied and reported.
7. A deadline or hop limit terminates the run.
8. An operator-required turn stops without another launch.
9. Actor crash or malformed structured output produces a terminal event.
10. A child, grandchild, and fully detached descendant are all contained after stop.
11. A fresh actor uses a material fact present only in durable sources, not conversation memory.
12. Two isolated task worktrees cannot write into one another and do not share semantic state.
13. A known ambient writer is either explicitly allowed, isolated, or causes a safe stop.
14. The dispatcher cannot push, merge, delete a branch, or delete a worktree.

### Semantic scenarios

Use Codex assessment and operator review for:

- whether context discovery stayed proportionate;
- whether the brief preserved the objective and governing decisions;
- whether a technical preference was incorrectly promoted into a requirement;
- whether the selected unit was the smallest useful one;
- whether evidence actually supports the claimed result;
- whether the correction request, if any, is bounded and necessary;
- whether the harness made correct work arrive sooner than the manual Work Loop.

### Real-task proof

Run three to five representative Axcíon tasks before calling the MVP adopted:

- one Direct task that should bypass automation;
- one bounded documentation or policy change;
- one small code change with tests;
- one task containing a false or stale operator premise;
- one interrupted or operator-stopped task.

For nondeterministic semantic scenarios, repeat at least three times or until a failure pattern is understood. Record outcome, operator interventions, elapsed time, model/tool cost where available, incorrect or redundant source reads, handoff failures, and whether the state file remained sufficient for a fresh continuation.

Existing dispatcher test counts are valuable regression evidence, but they answer “does the current controller behave as encoded?” They do not alone answer “is the product boundary safe and useful on real Axcíon work?”

## Phased MVP plan

### Phase 0 — Reconcile authority and close release blockers

**Goal:** establish one unambiguous target before production code is promoted.

Deliverables:

- an authority map naming the approved Work Loop proposal, executable core, context-engineering spec, dispatcher investigation, and current spike status;
- an explicit disposition for the May harness: evidence archive, not governing runtime;
- removal of the May harness's global hook registrations and normal routing entry points, with its evidence files preserved initially rather than deleted;
- verification that stale `harness/session/*` state and the workspace `bypassPermissions` default cannot govern any v0.2 actor launch;
- completion of Work Loop v1 retirement, or a narrow activation rule proving it cannot compete with v2;
- resolution of the executable-core status mismatch where its header still reads as a draft while the proposal and deployed skills act as current behavior;
- one selected target repository/checkout for the tracer MVP;
- a decision on attended-only versus truly contained unattended scope;
- a reproducible closure or explicit deferral of the detached-descendant blocker;
- a declared policy for ambient writers and worktree cleanliness.

**Exit:** there is no disagreement about governing sources, runtime scope, or whether unattended execution is allowed.

### Phase 1 — Freeze the minimum interfaces in tests

**Goal:** protect the existing semantic contract before changing the dispatcher.

Deliverables:

- fixtures for the current task-state file and allowed transitions;
- a minimal structured terminal-event schema;
- exact-task/checkout/branch/path policy fixtures;
- negative cases for mismatch, no transition, dirty ambiguity, permission denial, crash, deadline, and operator stop;
- fresh-context scenario CE-9/CE-17 proof: a material durable fact absent from conversation must be used with one preparation pass and no manual context ferrying;
- structural-decision scenarios proving that relevant existing decisions are consulted before new permanent machinery is proposed;
- the remaining P-7 live root-compaction witness, or an explicit documented deferral if the current runtime cannot produce the observation; no static grep may be substituted for live continuity evidence;
- descendant-containment fixtures including the fully detached case.

**Exit:** tests express the desired boundary without introducing a new semantic state model.

### Phase 2 — Harden the existing spike into one attended vertical slice

**Goal:** prove the whole loop with the operator present by extracting and simplifying the current dispatcher spike, not by starting a second orchestrator.

Flow:

1. one operator objective enters the context-engineering seam;
2. Codex creates or updates one exact task-state file;
3. the dispatcher launches the explicit actor in a fresh process;
4. Claude verifies premises, implements, tests, commits, and hands back state;
5. the dispatcher validates structural and Git facts;
6. Codex assesses and closes, continues, corrects once, or stops;
7. the dispatcher emits one terminal result.

No new task artifact, hidden session resume, automatic landing, or unattended authority is allowed in this phase.

**Exit:** a real bounded task completes with no operator copy/paste of actor outputs, and a fresh process can continue solely from the task state, relevant durable sources, and Git.

### Phase 3 — Real-task attended adoption trial

**Goal:** determine whether the attended harness improves Axcíon work rather than merely passing fixtures.

Deliverables:

- the real-task set above;
- measured operator interventions and context-ferrying;
- failure and friction evidence tied to decisions, not a new runtime diary;
- a failure-classification record for every material pilot failure, followed by the smallest correction at the owning layer rather than automatic harness expansion;
- an adopt/shrink/stop decision;
- promotion of only the proven minimum out of the spike location into a canonical `ai-resources` home.

**Exit:** the operator can point to three to five representative tasks where v0.2 produced correct work sooner, with less manual transport and no loss of control. If that result is absent, shrink or stop the harness instead of expanding it.

**This is the attended MVP cut line.** A useful v0.2 does not need to claim walk-away autonomy.

### Post-MVP Phase 4 — Add contained unattended execution and conditional worktrees

**Goal:** permit walking away only after the supervisor owns the full execution lifetime. This phase is a separate release gate, not a condition for shipping the attended MVP.

Deliverables:

- non-escapable containment or an external worker lifetime boundary;
- dedicated worktree preparation and exact binding;
- no-network/no-MCP default profile;
- safe interruption and restart from the last valid handback;
- hard deadline, hop budget, and terminal outcome;
- explicit no-push/no-merge/no-delete enforcement;
- parallel two-task proof in separate worktrees without cross-write or state confusion.

**Exit:** interruption, timeout, and dispatcher death cannot leave any workload able to mutate the checkout, and ambiguous ambient writes produce a safe stop.

## MVP acceptance criteria

The v0.2 MVP is complete only when all of the following are true:

- one operator command/objective can start the Standard flow without manual actor-to-actor copy/paste;
- Direct work still bypasses the machinery;
- one canonical plan and one current task-state file remain the only semantic durable surfaces;
- every model turn is fresh and can reconstruct the task from durable sources and Git;
- the dispatcher performs transport and structural validation only;
- false premises are surfaced before implementation;
- actor, task, checkout, and branch binding are exact;
- invalid transitions and dirty ambiguity stop safely;
- implementation evidence is tied to a real commit or an explicit no-commit condition;
- operator-required states stop immediately;
- if unattended mode is later enabled, timeouts, interruption, and supervisor exit leave no mutating descendant behind; otherwise unattended mode remains mechanically disabled;
- worktrees are used only under declared policy and never auto-landed or auto-deleted;
- Codex performs at most one bounded correction loop per meaningful unit;
- one terminal result explains what happened and what the operator must do next;
- three to five real Axcíon trials show lower operator transport and sufficient quality;
- structural proposals consult relevant existing decisions, and the behavioral evaluation pack detects known architectural-amnesia and unnecessary-machinery cases;
- material pilot failures are classified and produce either the smallest justified guardrail or an explicit decision to make no permanent change;
- the production surface is materially smaller than the May harness.

## Principal risks and design tensions

### The state file is intentionally human-readable, which makes parsers tempting to overbuild

Keep its grammar literal and narrow. A validator should protect the handful of fields the dispatcher depends on, not turn Markdown into a general database. If the machine interface grows, that is evidence the transport layer is beginning to own semantics.

### Fresh processes trade context leakage for reconstruction cost

That is the correct trade for reliability, but discovery must stay relevance-gated. Cache or compaction should be considered only after measurement shows repeated source reconstruction is materially expensive. Hidden session reuse would improve apparent speed while weakening reproducibility.

### Worktrees isolate task writes but do not solve shared external writers

A worktree protects branch/index/worktree state, not every process that writes into repository-linked logs or shared resources. Ambient writers need explicit ownership, relocation, or exclusion.

### Controller test success can hide host-level containment failure

The dispatcher has strong functional evidence and still has a meaningful daemon escape. Safety claims must be made against the OS-level postcondition, not the number of passing fixtures.

### Cross-model review can become a latency and cost multiplier

Retain the existing proportionality rules: Direct bypass for small work, one independent Codex assessment for meaningful units, one bounded correction at most, and stop rather than review chains.

### Current source status is slightly inconsistent

The v2 proposal is approved and the skills are deployed, while the executable-core document still presents itself as a draft for approval. The implementation plan should resolve this before building validation against prose that may not formally govern.

## Recommended decisions before implementation

1. **Treat the May harness as archived evidence, not an active base.** Reuse invariants and fixtures selectively; do not port its registry/governor structure.
2. **Make `ai-resources` the first and only tracer repository.** Generalize to the workspace only after one-repository proof.
3. **Keep the existing task-state interface.** Do not create `.work-loop/` or a four-file task directory.
4. **Make v0.2 attended-first unless containment is genuinely closed.** An attended MVP is honest and useful; unsafe unattended labeling is not.
5. **Keep worktrees conditional.** Require them for unattended/concurrent writers, not every task.
6. **Use native skill discovery.** Improve skill descriptions or routing only where a real trial demonstrates failure.
7. **Use structured output at the adapter boundary, not as semantic shadow state.** Validate terminal events and process facts; keep task meaning in the state file.
8. **Do not select App Server, MCP, a database, or an observability backend without an observed requirement.** The stable scripted surfaces are sufficient for the first vertical slice.

## Claude-ready planning brief

The following can be sent to Claude as the next planning request.

```text
We are planning Axcíon Harness v0.2. Do not implement anything in this task. Produce a concrete, repository-grounded implementation plan for operator approval.

Objective

Turn the existing Work Loop v2, approved context-engineering behavior, and handoff-dispatcher spike into the smallest safe MVP that can carry one Standard task from an operator objective to a terminal result across fresh Codex and Claude processes, without manual actor-to-actor copy/paste and without adding a second semantic state system.

Governing direction

- Harness v0.2 is an evolution of Work Loop v2, not a revival of the May harness and not a new `.work-loop/` platform.
- Retire the May harness's active hooks/routing and the competing Work Loop v1 route before promoting v0.2. Preserve historical evidence; do not delete it casually.
- Preserve one canonical plan when needed and one authoritative task-state file at `ai-resources/logs/work-loop/<task-id>.md`.
- Do not add routine `contract.yaml`, `decisions.md`, `handoff.md`, context packs, project-state files, databases, registries, dashboards, or workflow DSLs.
- Codex owns context preparation, unit framing, and bounded assessment.
- Claude owns repository verification, implementation, tests, commits, and evidence.
- The dispatcher is a courier and structural supervisor. It must not choose semantic next steps, judge implementation truth, or create shadow task state.
- Every actor launch is fresh and must recover from the exact task state, relevant durable sources, and Git rather than hidden transcript continuity.
- Direct work must continue to bypass the Standard loop.
- Worktrees are conditional: required for unattended/concurrent/large isolated work, optional otherwise.
- No automatic push, merge, branch deletion, worktree deletion, or landing.
- Unattended mode is not releasable while a fully detached descendant can survive dispatcher stop.
- The attended supervised vertical slice is the MVP cut line; contained unattended execution is a later gated release.
- Include a small behavioral evaluation pack and a failure-to-smallest-guardrail operating rule; do not build an eval platform or guardrail compiler.
- Before proposing permanent structural machinery, consult the relevant existing decisions and plans. Do not add a new decision store or knowledge index.

Read these sources in order and reconcile them explicitly

1. `plans/axcion-harness-v0.2/mvp-plan.md`
2. `.claude/settings.json`, `.claude/commands/harness-start.md`, and the current `harness/session/*` files, to identify still-active legacy runtime coupling.
3. `ai-resources/plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`
4. `ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`
5. `ai-resources/.agents/skills/work-loop-v2/SKILL.md`, `ai-resources/.agents/skills/work-loop/SKILL.md`, and `ai-resources/.claude/commands/work-loop-v2.md`
6. `ai-resources/plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md` and `ai-resources/logs/work-loop/context-engineering-implementation.md`
7. `ai-resources/plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md` and `ai-resources/logs/work-loop/work-loop-v2-proportionality-continuity-implementation.md`
8. `ai-resources/plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md`
9. `ai-resources/plans/work-loop-v2-v0.2/dispatcher-context-material-recommendations-2026-08-06.md`
10. `ai-resources/plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
11. `ai-resources/logs/work-loop/work-loop-v2-handoff-dispatcher.md`
12. `ai-resources/logs/work-loop/work-loop-v2-dispatcher-safety-gates.md`
13. `ai-resources/logs/work-loop/work-loop-v2-contained-unattended-profile.md`
14. For historical evidence only: `harness/reviews/harness-review-2026-05-25.md`, `harness/schemas/state-machine.md`, and `harness/schemas/write-ownership.md`.

Required planning work

1. Verify the current repository and nested-repository state before trusting any document claim. Report branch, dirty state, and relevant current commits without modifying them.
2. Produce an authority and runtime map. Call out the status mismatch between the approved v2 direction/deployed skills and the executable-core document header, the still-registered May hooks/stale session state, the workspace `bypassPermissions` default, and the still-discoverable Work Loop v1 route. Propose the smallest safe retirement sequence.
3. Inventory the current dispatcher spike by capability, separating proven behavior, simulated proof, one-host proof, fixture-only proof, and unresolved blockers. Do not use aggregate passing-test counts as a production-safety claim.
4. Design one attended vertical slice first:
   - operator objective and optional supplied materials;
   - one context-engineering pass;
   - Direct/Standard decision;
   - exact task-state creation/update for Standard work;
   - fresh explicit actor launch;
   - premise verification before action;
   - Claude implementation/test/commit handback;
   - structural and Git validation;
   - fresh Codex assessment;
   - one terminal event.
5. Specify the minimum interfaces precisely:
   - current task-state grammar and allowed transitions;
   - exact task/repository/checkout/branch binding;
   - actor adapter input/output;
   - checkpoint/handback atomicity;
   - terminal-event schema;
   - path, sandbox, network, timeout, deadline, and hop policies;
   - conditional worktree policy;
   - interruption and descendant-containment postcondition.
6. Give an attended MVP path with a precise release cut line and a separate post-MVP contained-unattended path. If the detached-daemon escape is not closed, the latter must remain disabled or require an external lifetime boundary such as a dedicated worker/VM/container.
7. Design tests before implementation changes. Include task mismatch, checkout mismatch, no transition, dirty ambiguity, denied path, actor crash, malformed output, operator stop, deadline, child/grandchild/fully detached descendant containment, fresh-context recovery, ambient writer behavior, and two-worktree isolation.
8. Plan three to five real Axcíon trials, including a Direct bypass, a small code task, a false-premise task, and an interrupted/operator-stopped task.
9. Define a 10–15-scenario behavioral evaluation pack, including structural-decision retrieval, architectural amnesia, unnecessary machinery, skill/routing correctness, scope drift, handoff fidelity, and fresh-context recovery. Keep it separate from deterministic dispatcher tests without creating an eval platform.
10. Define the failure-classification and smallest-correction rule for pilot failures. Show which layer owns judgment, context, routing, deterministic enforcement, and repository-architecture failures; do not propose an automated guardrail compiler.
11. Identify exactly which current spike files would be promoted, rewritten, deleted, or left as evidence after MVP proof. Do not move anything yet.
12. Estimate complexity by phase and identify the smallest cut line that still produces a useful outcome.

Required deliverable

Write one implementation-plan Markdown file in the existing plans/report convention. It must include:

- executive decision;
- authority map;
- current-state evidence table;
- target architecture and ownership boundaries;
- exact file-by-file proposed changes;
- interface definitions;
- test/evaluation matrix;
- safety threat model and blockers;
- phased implementation sequence with entry/exit criteria;
- rollback/stop conditions;
- open operator decisions;
- explicit non-goals.

Constraints

- Planning only; no source edits, dependency installation, commits, branches, worktrees, or process launches beyond read-only diagnostics.
- Preserve the dirty worktree and all user changes.
- Prefer repository evidence and official primary documentation over generic agent-framework patterns.
- If a proposed component cannot explain how it makes correct work arrive sooner, omit it or shrink it.
```

## Primary external sources consulted

- OpenAI, [Harness engineering: leveraging Codex in an agent-first world](https://openai.com/index/harness-engineering/) — repository as system of record, progressive disclosure, structural enforcement, observability, and maintaining agent-legible environments.
- OpenAI, [Symphony specification](https://github.com/openai/symphony/blob/main/SPEC.md) — repository-owned workflow policy, isolated workspaces, one authoritative orchestrator state, structured logs, safety invariants, and explicit non-goals around rich UI/general workflow engines.
- OpenAI, [Codex CLI reference](https://developers.openai.com/codex/cli/reference/) and [Codex App Server](https://developers.openai.com/codex/app-server/) — current scripted and persistent integration surfaces.
- Anthropic, [Claude Code CLI reference](https://code.claude.com/docs/en/cli-usage), [hooks](https://code.claude.com/docs/en/hooks), [sessions](https://code.claude.com/docs/en/sessions), [permissions](https://code.claude.com/docs/en/permissions), and [sandboxing](https://code.claude.com/docs/en/sandboxing) — current launch, structured-output, lifecycle, context, and containment capabilities.
- Anthropic, [Demystifying evals for AI agents](https://www.anthropic.com/engineering/demystifying-evals-for-ai-agents) — evaluation design and the distinction between harness behavior, transcripts, and outcomes.
- [Agent Skills specification](https://agentskills.io/specification) — native progressive-disclosure skill packaging.
- Git, [git-worktree documentation](https://git-scm.com/docs/git-worktree.html) — multiple checked-out working trees and their operational semantics.
- [JSON Schema Draft 2020-12](https://json-schema.org/draft/2020-12) — interoperable validation for bounded structured adapter output.
- Model Context Protocol, [base protocol](https://modelcontextprotocol.io/specification/2025-11-25/basic) and [security best practices](https://modelcontextprotocol.io/docs/tutorials/security/security_best_practices) — capability negotiation and least-privilege security concerns for any later external integration.

## Bottom line

The best v0.2 is not a larger harness. It is the smallest production-quality seam around the Work Loop Axcíon has already designed: one objective, one preparation pass, one state file, one explicit turn, one fresh actor, one verified handback, one bounded assessment, and one terminal result. The design should earn unattended autonomy only after it proves complete process containment and useful real-task outcomes.
