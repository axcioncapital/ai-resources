---
task: work-loop-v2-resource-capability-plan
turn: codex
---

## Objective and scope

Create one evidence-backed, operator-reviewable implementation plan for the smallest Work Loop v2
change that would make development and improvement of AI resources, repository capabilities and
features systematic without reproducing specialist workflows or introducing unnecessary process
machinery.

The plan must cover creation, improvement, replacement and retirement; preserve Direct Work for
small settled changes; use Matt Pocock's current grill/Wayfinder/spec/ticket/implementation
philosophy proportionately; and keep technical completion separate from operational adoption.

Scope is planning only. Claude may create the plan at
`plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` and update this state file.
Excluded: implementation; edits to commands, skills, the executable core, templates, hooks, settings,
tests or existing plans; a new command, skill, agent, registry, lifecycle record or state system;
installing or updating Matt skills; changing Work Loop v1 or retiring any current resource.

## Lane and unit

Standard. Implementation mode. Unit 1 — inspect current ownership and contracts, then write the
bounded implementation plan.

Named reason for the loop: the proposed lifecycle crosses Work Loop routing, durable-resource
development, capability ownership and Matt specialist flows; its scope must be bounded against live
repository reality, and Codex must assess the resulting plan against this session's settled context
before it can guide implementation.

Plan justification: the operator has now explicitly requested a plan, using Work Loop v2, after
settling the intended philosophy and boundary in this session. This unit creates that draft plan
only. It does not amend the approved Work Loop v2 MVP proposal, treat the active mode-contract task
as closed, or authorize any build.

## Brief

This plan is needed because the high-level direction is now clear but repository ownership is not
yet reconciled end to end: Work Loop v2 has an intake router and a live candidate mode contract;
`/develop-ai-resource` and `capability-development` still carry Work Loop v1-specific seams; and the
Matt workflow must be used through its owners rather than copied into another Axcíon SOP. The plan
should turn that context into the smallest evidence-backed build sequence, including a legitimate
no-build or reconciliation-only result if the existing system already covers the need.

### Operator objective and settled design constraints

The operator wants Work Loop v2 to support a standard, proportionate way to develop **and improve**
AI resources, capabilities and repository features while preventing overbuilding,
overengineering, drift and over-governance. Examples include Work Loop v2 dispatchers, supervisor
features and failure-mode controls.

Treat the following as governing decisions for this planning unit:

1. Start from the operating outcome or observed behaviour gap, never from “create a skill,” “add a
   dispatcher” or another assumed mechanism.
2. Cover the full lifecycle: create, improve, replace and retire.
3. Direct, settled and reversible improvements stay light. Planning depth must be earned by
   uncertainty, not importance, file count or theoretical consequence.
4. Preserve three distinct concepts:
   - Work Loop **mode** classifies one admitted Standard unit from what is uncertain now.
   - A project or capability may have its own lifecycle or phase model.
   - Matt skills are specialist owners or phases reached at their own boundaries.
   Do not turn Discovery, Implementation and Adoption modes into a sequential project lifecycle.
5. Use Matt Pocock's current philosophy:
   - ordinary unresolved work may begin with `grill-with-docs`;
   - `wayfinder` is the alternative planning owner for dependent uncertainty too foggy for one
     effective session, not a mandatory stage and not a synonym for “large”;
   - a runnable design unknown may detour through `prototype`;
   - `to-spec` synthesizes an already-resolved thread or Wayfinder map;
   - `to-tickets` creates complete tracer-bullet implementation slices when several are needed;
   - `implement` owns building from the accepted spec or ticket and drives its TDD and code-review
     method;
   - bugs and architecture-health work keep their specialist on-ramps;
   - fresh implementation context is preferred per ticket, while mandatory handoff artifacts are
     not.
6. Apply Matt's method semantically to non-code AI resources. Code can use literal
   red-green-refactor; a skill, prompt, command or workflow document needs a representative
   behavioural or invocation case capable of failing, not ceremonial code tests.
7. Work Loop routes and manages progression. It does not reproduce a specialist's method, wrap the
   specialist in a second Work Loop state system, or return a simultaneous stack of owners.
8. `/develop-ai-resource` owns whether and how a durable AI artifact should exist. A settled,
   narrowly scoped existing-skill improvement may still use the direct `/improve-skill` route under
   the current authority; uncertain, contested or materially expanded work is qualified first.
9. The operating project or capability owns real-use success and adoption. A well-made AI resource
   may still be rejected operationally. Project-local adoption does not automatically authorize
   graduation to shared infrastructure.
10. Failure-mode governance enters first through an existing unit's constraint, repository claim,
    evidence requirement or stop condition. Promote it to permanent machinery only when the
    existing complexity budget is satisfied. A detector without a closure channel does not ship.
11. Prefer one deep capability with a small public seam over several shallow commands, agents and
    documents. No new load-bearing component may be proposed without stating what it replaces or
    why separation is necessary, how it is invoked, and how it reduces total complexity or answers
    cited failure evidence.
12. The final operating test is demonstrated usefulness: did the process clarify the need, produce
    the smallest useful behaviour, prove it through the real seam and make the next lifecycle
    decision easier?

### Source dispositions

**Governing for Work Loop process and current operator intent**

- This state file's operator objective and settled design constraints.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` for roles, admission, unit kinds,
  modes, state shape, evidence and stop rules.
- `.agents/skills/work-loop-v2/SKILL.md` for current Codex routing, specialist ownership and brief
  preparation.
- `.claude/commands/work-loop-v2.md` for Claude's current execution boundary.
- `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md` only within its approved MVP scope.
  This new plan must not silently amend or reinterpret it.

**Applicable specialist authority to inspect and reconcile, not copy**

- `.claude/commands/develop-ai-resource.md`
- `skills/ai-resource-builder/SKILL.md` and only the directly relevant references it routes to
- `docs/ai-resource-creation.md`, especially the complexity budget and creation/improvement routing
- `skills/capability-development/SKILL.md`
- `templates/capability-record.md`
- `docs/work-loop.md` only as the current Work Loop v1 contract needed to identify v1-specific
  dependencies; do not promote v1 behaviour into v2 by default
- `docs/repo-architecture.md` for placement and resource-class boundaries

**Authoritative current-state candidates to verify before relying on them**

- `logs/work-loop/work-loop-v2-intake-router.md`
- `logs/missions/work-loop-v2-mvp.md`
- any current v2 plan-of-record or decision source directly referenced by those files

**Non-governing context and design evidence**

- `plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md`
- `plans/work-loop-v2-v0.2/context-engineering/matt-pocock-style-principles.md`
- `plans/work-loop-v2-v0.2/context-engineering/matt-pocock-wayfinder-led-project-development-lifecycle.md`
- The earlier supplied Work Loop Standard Operating Model and AI-resource lifecycle drafts. Their
  useful ideas are already summarized in the settled constraints above; their duplicated unit
  mechanics, mandatory risk sections and single-entry claims do not govern.

Material reclassifications to preserve visibly in the plan:

- The three Work Loop modes are already present in the live filesystem and are the subject of an
  active Work Loop task. They are repository reality to verify, not missing scope to plan again and
  not completed authority to assume before that task closes.
- The seven-step fallback progression spine is diagnostic when a project has no phase model. It is
  not a universal sequence, artifact schema or second lifecycle state system.
- The Matt-style principles and Wayfinder guide are derived context. The installed/current Matt
  skill definitions govern their actual routing and method.
- The current `/develop-ai-resource` upstream contract and capability record are tied explicitly to
  Work Loop v1. Their compatibility with v2 is an open repository question, not an approved
  migration direction.

### Verify against the repository before planning

1. Open and validate this task-state file first. Confirm its `task:` matches its filename and
   `turn:` is `claude`.
2. Establish the live status of `logs/work-loop/work-loop-v2-intake-router.md`: whether the mode
   contract is active, handed back, accepted or closed. Inspect the core, Codex skill and Claude
   command to distinguish implemented filesystem content from accepted/closed work.
3. Verify what Work Loop v2 already does for:
   - ordinary-language owner selection;
   - Direct versus Standard admission;
   - Discovery, Implementation and Adoption mode classification;
   - project progression and specialist ownership;
   - real-use evidence and lifecycle decisions.
4. Trace new and existing AI-resource routes through `/develop-ai-resource`, `/create-skill`,
   `/improve-skill`, the builder and graduation. Identify the exact current rules for a new
   resource, a settled improvement, an uncertain/material improvement, a project-local artifact and
   shared graduation.
5. Trace the v1 capability-development seam end to end: which live resources invoke it, where its
   capability record lives, how it hands an artifact to `/develop-ai-resource`, where the
   disposition returns and who owns adoption. Bound every absence claim to the paths and patterns
   searched.
6. Inspect the current installed Matt definitions or the repository's verified inventory for
   `grill-with-docs`, `wayfinder`, `prototype`, `to-spec`, `to-tickets`, `implement`, `tdd`,
   `code-review`, `diagnosing-bugs` and `improve-codebase-architecture`. Do not infer their current
   method from the contextual essays when the installed definition is reachable.
7. Identify every live authority, command, skill, template, documentation consumer and test that
   would actually need modification for the minimum recommended design. Do not inflate the list
   with sources that need no behavioural change.
8. Check `docs/ai-resource-creation.md` complexity-budget requirements against every proposed new
   component, gate, always-loaded rule or persistent artifact. A proposal that does not clear the
   budget must be removed, made conditional, folded into an existing owner or recorded as requiring
   an explicit operator exception.

A false premise is a useful outcome. If repository reality shows that the desired capability is
already fully covered, write a no-build or reconciliation-only plan rather than inventing work.

### Required plan

Write `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` as a **Draft — not
approved and not authorized for implementation**. It must be self-contained enough for a fresh
Claude session to implement one approved unit later without reopening this design session.

The plan must:

1. State the observable destination and the concrete current failure or gap it addresses.
2. Give a verified current-state and ownership map. Use one owner at each boundary and distinguish
   Work Loop progression, project/capability ownership, AI-artifact ownership and Matt specialist
   methods.
3. State the recommended minimum design and the strongest rejected alternative. Prefer
   reconciliation or extension over a new workflow component.
4. Define the proportional entry routes for at least:
   - a small settled improvement;
   - an ordinary unresolved feature or resource change;
   - a large/foggy initiative with dependent decisions;
   - a difficult defect;
   - an architecture-health concern;
   - a new AI resource supporting an existing operating capability;
   - a non-AI capability or repository feature;
   - later shared-resource graduation.
   These are routes, not a mandatory stack or lifecycle checklist.
5. Explain how create, improve, replace and retire are represented without making “build” the
   default outcome.
6. Explain how Work Loop modes relate to, but do not replace, project phases and Matt's planning and
   implementation flows.
7. Define the smallest implementation units as vertical, independently verifiable slices. For each
   unit state:
   - its outcome and why it is needed now;
   - the one owner;
   - exact owned paths;
   - prerequisites and what it deliberately holds outside;
   - repository claims to verify before mutation;
   - fail-capable acceptance evidence through the real seam;
   - risk-aware review requirement, if any, based on current repository authority;
   - rollback or retirement boundary;
   - the operator decision, if any, that must precede it.
8. Sequence units by dependency and uncertainty. Resolve a load-bearing seam before planning broad
   edits; do not create a Wayfinder network for a route that is already clear.
9. Include a migration/reconciliation treatment for Work Loop v1-specific capability and
   `/develop-ai-resource` contracts without silently deciding whether to port, retain or retire
   them. If repository evidence settles the answer, cite it. Otherwise isolate the exact operator
   decision before any affected implementation unit.
10. Include a test matrix that would expose misrouting, double ownership, duplicate state,
    build-bias, mandatory-Wayfinder drift, ceremonial TDD, technical-completion-as-adoption and
    detector-without-closure failures.
11. Include explicit no-build conditions, exclusions, deferred work with evidence-based reopening
    triggers, and a stopping condition for the overall build.
12. Include one adoption proof using real or representative operation and an explicit lifecycle
    decision. Do not call static plan or file checks operational proof.
13. End with an operator approval boundary identifying what approval would authorize and what would
    remain unapproved.

### Required evidence for Codex QC

Return evidence that lets Codex compare the plan with this session rather than trusting the plan's
own narrative:

- A source table naming each inspected governing/current-state file, its verified status and the
  plan consequence.
- A traceability table mapping all twelve settled design constraints above to a plan section,
  implementation unit or explicit no-build/exclusion disposition.
- A current-versus-proposed component count for commands, skills, mandatory stages/gates,
  always-loaded rules and persistent state artifacts. Any increase must cite the complexity-budget
  prong it satisfies.
- A one-owner scenario matrix covering all eight proportional entry routes required above, with the
  first owner only and the condition that ends that owner's responsibility.
- A v1/v2 seam map identifying every dependency the plan would keep, adapt, replace or leave for an
  operator decision.
- At least three deliberate counterexample walkthroughs:
  1. speculative failure-mode governance with no cited failure;
  2. one verified dispatcher failure with a known seam;
  3. an existing project capability that needs a new AI resource and later real-use adoption.
  The plan must produce different, proportionate outcomes for them.
- A plan-boundary check confirming the plan created no implementation change and modified only the
  plan and this state file.

The evidence is fail-capable if it can reveal an uncovered constraint, an owner collision, a
proposed component that fails the complexity budget, a v1-only assumption, a non-vertical unit or a
scenario whose route is ambiguous. A table that merely repeats the plan's headings is not evidence.

### Completion and stop conditions

Completion: the draft plan exists at the required path; every verify-first claim is dispositioned;
the required QC evidence is recorded in this state file; the plan changes no implementation
surface; Claude commits only the plan and this state file by explicit pathspec; `turn: codex`; stop
for assessment.

Stop and hand back to Codex if a load-bearing repository premise is false but still permits an
evidence-backed reframe; if current overlapping work makes the plan's current-state baseline
unreliable; if the required evidence cannot distinguish a minimal design from added ceremony; or if
the plan cannot be written without changing an excluded path.

Stop for the operator if proceeding requires deciding whether to retain, migrate or retire a
consequential v1 capability system; materially changes the approved Work Loop v2 MVP objective or
scope; adopts a new permanent command, skill, state system or always-loaded governance layer; or
accepts a risk that current authority reserves for the operator. Record the exact question, set
`turn: operator`, commit only the plan if it remains useful plus this state file, and stop.

## Latest result

Reproduced all four frozen findings by inspection before correcting any of them. All four reproduce.

- **Finding (1) REPRODUCES.** Searched `~/.claude/skills/wayfinder/SKILL.md` for `tracker`: line 25
  reads "Consult the tracker doc's 'Wayfinding operations' section for how _this_ repo expresses them.
  **If no tracker has been provided, default to the local-markdown tracker.**" Searched
  `~/.claude/skills/to-tickets/SKILL.md` for `scratch`: line 62 specifies the local form — "**Local
  files** → write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`". My
  blocker was **false**. Its cause is stated plainly rather than excused: I read only the first 12
  lines of each skill, saw "The issue tracker should have been provided to you — run
  `/setup-matt-pocock-skills` if not", and inferred a hard dependency from a sentence whose very next
  clause supplies the fallback. That is a read-scope failure, and the plan carried a preparatory unit
  built entirely on it.
- **Finding (2) REPRODUCES.** Searched `skills/capability-development/SKILL.md` for its headings:
  it owns **the intervention ladder** (`:108`), **owner selection and the seam** (`:127`, `:129`,
  `:145`), **the five phases** (`:160`), **trial design and its stop condition** (`:226`), **slice
  standards** (`:245`), **evidence to claim** (`:261`), **adjudicating findings** (`:297`) and
  **lifecycle decisions** (`:313`), whose status table at `:326` reads "`retired` | TERMINAL |
  Withdrawn from use | The machinery removed, and a record of what was removed". Adoption mode is one
  decision point (core `:126`). Having the same four options is not coverage of a method. Separately,
  core § 4 defines the state file as current truth for one task and reduces it to four sections at
  closure, so it does **not** hold `retirement condition` (`templates/capability-record.md:83`),
  `real-use result` (`:131`) or `lifecycle status` (`:136`) past a task's close. Both claims in the
  finding are correct; the plan asserted equivalence it had not established.
- **Finding (3) REPRODUCES.** Searched `templates/capability-record.md` for `retire`: `:7` places
  `retired` in the TERMINAL set, `:83` makes a *retirement condition* a required element of the
  implementation package, `:136` records it with the lifecycle status. With
  `capability-development:326` and `:340` ("Retirement that leaves the machinery in place is not
  retirement. Remove it, and record what was removed."), retirement **is** defined — for operating
  capabilities, in the layer that cannot run. "Represented nowhere" was false.
- **Finding (4) REPRODUCES**, including the specific contradiction it names: § 3 move 2 read "Retire
  the v1 doctrine that cannot execute" while § 8 and § 13 reserved that disposition to the operator.
  The plan recommended the decision it also claimed not to make.

Result: all four findings corrected in the plan; nothing else touched. Section by section:

**Finding 1** — § 2c now cites `wayfinder:25` and `to-tickets:62` and states that the skills degrade
to a local-markdown tracker rather than refusing. **Unit 0 is deleted entirely.** Route 3 in § 4 is no
longer marked blocked, and its note now says setup is not a prerequisite. The § 11 deferral is
rewritten from "configuring a tracker" to "configuring a *non-default* tracker", triggered only if the
fallback proves insufficient during a real run. The proportional rule is stated where the temptation
sits: configuration is handled at the specialist boundary, by the specialist, if and when its own
definition asks — never in advance.

**Finding 2** — § 3's recommended design no longer recommends retiring anything. Move 2 is now
"establish, by inspection, what the v1 method contains that nothing in v2 covers — and hand that gap
analysis to the operator". Two new paragraphs state the limits explicitly: a decision point does not
replace a method, and the task-state file does not replace the capability record, with core § 4 cited
for why. The rejected alternative is re-grounded on **sequencing and cost** rather than on v1 being
redundant, and now says the right answer may well be to *keep* the v1 content. § 2a gained a stated
limit so row 5 cannot be over-read downstream. The component arithmetic dropped its "≤ −4 documents
retired" line — nothing is counted as removed, because nothing is recommended for removal. § 8's
`capability-development` row no longer asserts a covered half; § 7's Unit 4 is rebuilt as a
**per-section** gap analysis whose evidence explicitly may not treat "Adoption mode has four options"
as coverage.

**Finding 3** — § 1 replaces "represented nowhere" with the citations above. § 5 gains a per-class
table: **operating capability** — defined but unreachable, deferred to Unit 4; **durable AI
artifact** — genuinely unowned, Unit 3's narrow target; **non-AI repository feature** — no candidate
owner, stated as an open ownership question and carried to § 11 with a reopening trigger. Unit 3 is
retitled "for durable AI artifacts only", its exclusions name the other two classes, and it gains a
second fail-capable case: if the amended verdict reads as though it covered capability retirement, the
unit has overreached. No retirement component is added for symmetry.

**Finding 4** — the contradiction is gone (verified below), and the evidence is re-run.

### Re-run evidence, against the corrected recommendation

**1. Source table — corrections only.** Three rows changed; the rest stand as previously recorded.

| Source | Corrected status | Corrected plan consequence |
|---|---|---|
| `~/.claude/skills/wayfinder/SKILL.md` | `:25` **provides a local-markdown default** when no tracker is configured | Route 3 is operable today. Unit 0 deleted. |
| `~/.claude/skills/to-tickets/SKILL.md` | `:62` specifies the local form, `.scratch/<feature-slug>/issues/` | Confirms the fallback is concrete, not nominal |
| `skills/capability-development/SKILL.md` | Nine substantive method sections (`:108`–`:340`), incl. a lifecycle status table | **Not** asserted as covered by Adoption mode. Per-section comparison moved into Unit 4. |
| `templates/capability-record.md` | `:7`, `:83`, `:136` define `retired` and hold durable state the task file discards at closure | Capability retirement stays with v1's definition pending Unit 4; § 5 says so |
| `docs/agents/issue-tracker.md` | Still absent — but **absence is not a blocker** | Row's former consequence ("Unit 0 exists solely because of this") is withdrawn |

**2. Constraint traceability — the two rows the corrections moved.**

| # | Settled constraint | Corrected landing site |
|---|---|---|
| 2 | Full lifecycle: create, improve, replace, retire | § 5 **per-class table** — one owner, one deferral, one open question. Unit 3 covers the AI-artifact class only. |
| 5 | Matt philosophy used through its owners | § 2c (fallback cited); § 4 routes 3–5 **unblocked**. The former "Unit 0 — operability correction" landing site is withdrawn. |

The other ten rows are unchanged and were re-checked against the edited sections.

**3. Component count — unchanged and now internally consistent.** All classes still **0**, and the
v1-doctrine row no longer claims a prospective `≤ −4`: it reads *5 → 5, disposition open (Unit 4)*.
This matters because the earlier row was itself a quiet recommendation to retire, expressed as
arithmetic. Prong **(a)** is now claimed on holding every count flat while restoring capability, not
on a removal the plan does not recommend; prong **(b)** still holds independently on `0516bf6` and
`logs/improvement-log.md:2823`.

**4. One-owner scenario matrix.** Eight routes, unchanged in count. Route 3 no longer carries a
blocked marker. No owner collision was introduced: Unit 3's narrowing to AI artifacts *removes* a
potential collision, since the previous wording would have had `/develop-ai-resource` implicitly
owning capability retirement alongside the v1 layer.

**5. v1/v2 seam map.** Ten dependencies. Three rows corrected: `docs/work-loop.md` is now "superseded
**for process**" rather than "replaced"; `capability-development` asserts **no** covered half;
`templates/capability-record.md` moves from "keep while a live record exists" to "**keep**", with the
durable-state reason stated. Operator decisions rise from four to five — the capability method's
disposition is now explicitly one, where before it was half-decided in § 3.

**6. Counterexamples.** Re-walked against the corrected text; all three still produce different
outcomes, and none depended on Unit 0 or on retiring v1 (verified by search — zero hits for `Unit 0`
or `retire` inside § 10).

**7. Plan boundary — unchanged.** Still exactly two files: the plan and this state file. No
implementation surface touched. Verified by `git status --porcelain` before committing.

**8. Contradiction sweep (finding 4's explicit ask).** Searched the corrected plan for each retracted
claim: `Unit 0` — **0 hits**; `blocked today` / `cannot run` / `neither can run` — **0**;
`represented nowhere` / `Nothing owns it` — **0**; `Retire the v1 doctrine` / `already does the
load-bearing` / `v2's state file *is* that state` — **0**; `≤ −4` — **0**. The § 3-versus-§ 8/§ 13
contradiction is resolved by removing the recommendation, not by softening the reservation.

### Why this correction's evidence can fail

Each finding was reproduced against a **named line that could have read otherwise**. Had
`wayfinder:25` carried no fallback clause, finding 1 would not have reproduced and the blocker would
have stood. Had `capability-development` turned out to be a thin wrapper over the same four lifecycle
options, finding 2 would have failed. Had `templates/capability-record.md` lacked `retired`, finding 3
would have failed. The contradiction sweep is a search that returns a count: it reads `0` now and read
non-zero before the edits, so it distinguishes a corrected plan from an uncorrected one.

## Blocker

None.

The previous `## Blocker` content is **withdrawn**, not carried forward: it asserted that settled
constraint 5 was inoperable, and finding 1 disproved that. Withdrawing it is part of the correction.

**Accepted limitation, still standing.** `.agents/skills/work-loop-v2/SKILL.md` carried uncommitted
modifications at inspection time (unattended-run and courier-mode work, not touching routing,
admission or mode). Nothing was committed from it.

**Nothing newly noticed entered this round as work.** Two candidate deferrals recorded and **not**
implemented, per core § 3:

1. **The read-scope failure behind finding 1 may not be isolated.** I established two other skills'
   behaviour from their opening lines during Unit 1. Those conclusions happened to survive, but the
   method that produced them is the one that failed here. A re-check of the § 2c skill claims against
   full definitions is a bounded unit of its own, outside this frozen scope.
2. The three deferrals recorded in Unit 1's hand-back (`work-loop-spec.md` size, the stale "yet" at
   `develop-ai-resource.md:67`, the two unmerged worktrees) are unchanged and still not implemented.

## Next action

Codex: run the closure check on the four frozen findings only.

1. Is the Matt-operability blocker gone, Unit 0 removed, and the proportional rule preserved — setup
   handled only at the specialist boundary, if the installed skill asks then?
2. Does the plan now avoid claiming the task-state file replaces a durable capability record, avoid
   claiming Adoption mode replaces the capability method, and leave the v1 disposition as an
   evidence-first operator decision?
3. Is retirement coverage honest across all three object classes — one owner, one deferral, one
   precisely stated open ownership question — with no component added for symmetry?
4. Is the QC evidence re-run, and is the § 3-versus-§ 8/§ 13 contradiction gone?

And the second closure question only: did the correction break anything? The plan remains a **draft
authorizing nothing**; anything newly noticed is a deferral, not a second correction round.
