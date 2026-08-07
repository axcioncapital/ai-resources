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

Inspected (2026-08-07). Every verify-first item checked by opening the file or running the search.

- Claim (1): HOLDS — this file's `task:` is `work-loop-v2-resource-capability-plan`, matching its
  filename; `turn:` was `claude`. Validated read-only before anything else.
- Claim (2): HOLDS, with the status sharpened — `logs/work-loop/work-loop-v2-intake-router.md` is
  **open**, `turn: claude`, and its `## Next action` opens `Final tightly-bounded fix:`. The mode
  contract is **implemented** in all three artifacts (core `:95–140`; `.agents/skills/work-loop-v2/
  SKILL.md:91–103`; `.claude/commands/work-loop-v2.md` § The unit's mode) and asserted in
  `logs/scripts/work-loop-v2-slice-1.test.sh`. It is **not closed**, so it is repository reality, not
  accepted authority. The brief's reclassification was correct.
- Claim (3): HOLDS — all five named v2 behaviours are already implemented. Owner selection
  (skill `:71–201`, 25 Axcíon commands + 25 Matt skills); Direct/Standard admission (core § 2, both
  runtimes); mode classification (above); project progression and specialist ownership (skill
  `:83–89`, **adopted** 2026-08-06 per `logs/missions/work-loop-v2-mvp.md:90`); real-use evidence and
  lifecycle decisions (Adoption mode, core `:126`).
- Claim (4): HOLDS — `/develop-ai-resource` (`:30–172`) qualifies and routes to `/create-skill`,
  `/improve-skill`, `/migrate-skill`; `/improve-skill` stays directly reachable for a settled
  improvement (`ai-resource-creation.md:21`); `/request-skill` writes to `inbox/` (4 briefs queued);
  `/graduate-resource` owns shared graduation with consumer consent (`:23`).
- Claim (5): HOLDS, and is **materially worse than the brief states**. The seam is not merely
  "v1-specific" — it is **dangling**. `.claude/commands/work-loop.md` was **deleted** at commit
  `0516bf6` ("batch: retire /work-loop (v1) — superseded by /work-loop-v2"); searched the working tree
  and `git ls-files` for `work-loop.md` under `.claude/commands/` — absent from both. Its dependants
  survive: `develop-ai-resource.md` names `/work-loop` on 7 lines (8 occurrences), `leverage-idea.md`
  on 7 lines, searched with `grep -o "/work-loop[^-a-z]"` which excludes every `/work-loop-v2` form.
  `skills/capability-development/SKILL.md` carries `disable-model-invocation: true` and states "Never
  invoked directly … developed through `/work-loop`", so it is now structurally unreachable. One live
  capability record exists — searched `projects/*/development/*.md`, exactly one match,
  `axcion-ai-system-owner/development/prime-runtime-delegation.md` — with no executor. The retirement
  commit's own message names this as "a v2-stream design decision", and `logs/improvement-log.md:2823`
  logs it pending.
- Claim (6): HOLDS for installation, **FALSE for operability** — see Blocker. All ten Matt definitions
  were read from the installed files at `~/.claude/skills/`, not inferred from the contextual essays.
  Six carry `disable-model-invocation: true` (`grill-with-docs`, `wayfinder`, `to-spec`, `to-tickets`,
  `implement`, `improve-codebase-architecture`) and are operator-invoked only; four are freely
  invocable (`prototype`, `tdd`, `code-review`, `diagnosing-bugs`).
- Claim (7): HOLDS — the minimum design needs exactly two command files, plus possibly one line of
  `docs/ai-resource-creation.md`. The list was deliberately not inflated: the core, the Codex skill,
  the Claude command and the harness need **no** behavioural change.
- Claim (8): HOLDS — `docs/ai-resource-creation.md:27–46` carries the two prongs, the five questions,
  the inflow rule and OP-12. Applied to every proposal in the plan; none adds a component.

Result: the draft plan exists at `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md`
(13 sections, marked Draft — not approved). Its recommended design is **reconciliation, not
construction**: repoint two dangling command routes at Work Loop v2, give `retire` an owner inside an
existing verdict list, and hand the v1-doctrine disposition to the operator as evidence rather than
deciding it. **No new command, skill, agent, mode, gate, registry, lifecycle record or state system is
proposed**, and the strongest rejected alternative (a v2 capability route with its own register) is
recorded with the reason — it would be the second state system core § 1 forbids.

### Evidence

**1. Source table.**

| Source | Verified status | Plan consequence |
|---|---|---|
| `work-loop-v2-executable-core-v0.1.md` | Present, 456 lines; header still "draft for operator approval"; § 4 courier clause separately approved | Governing for mechanics; § 2b warns against reading courier approval as approval of the rest |
| `.agents/skills/work-loop-v2/SKILL.md` | Present, 331 lines; **uncommitted modifications present** (see Limitations) | Established that all five named v2 behaviours already exist |
| `.claude/commands/work-loop-v2.md` | Present, 136 lines | Confirms Claude's boundary needs no change |
| `work-loop-v2-mvp-proposal-v0.4.md` | Present, 170 lines; § 3 ten settled decisions, § 7 deferred list | Plan proposes nothing inside either; not amended |
| `logs/work-loop/work-loop-v2-intake-router.md` | **Open**, `turn: claude`, mid-final-fix | Mode is reality, not closed authority — § 2b |
| `logs/missions/work-loop-v2-mvp.md` | Present; progression **adopted** 2026-08-06; Step 8 and v0.2 rework open | Progression safe to depend on; rework excluded |
| `.claude/commands/develop-ai-resource.md` | Present, 182 lines; 7 dangling lines | Unit 1 target |
| `.claude/commands/leverage-idea.md` | Present; 7 dangling lines | Unit 2 target |
| `skills/capability-development/SKILL.md` | Present, 442 lines; **unreachable** (`disable-model-invocation`, deleted invoker) | Unit 4 evidence |
| `templates/capability-record.md` | Present, 140 lines; cited by `develop-ai-resource.md:55` as status authority | Keep while a live record exists |
| `docs/work-loop.md` / `docs/work-loop-spec.md` | Present, 260 / 360 lines; describe a deleted command | Unit 4 operator decision |
| `docs/ai-resource-creation.md` | Present, 84 lines; rule #7 complexity budget | Applied to every proposal |
| `docs/repo-architecture.md` | Present, 289 lines; Q1–Q8 placement heuristics | No new artifact class proposed, so no placement question arises |
| Ten Matt skills at `~/.claude/skills/` | All present; six model-invocation-disabled | § 2c; Unit 0 |
| `docs/agents/issue-tracker.md` | **ABSENT** — searched `docs/agents/` (directory absent), repo-wide for the filename, and for `.scratch/` | Unit 0 exists solely because of this |

**2. Constraint traceability — all twelve dispositioned.**

| # | Settled constraint | Where it lands |
|---|---|---|
| 1 | Start from the outcome, never an assumed mechanism | § 5 (ten-rung ladder, building last); § 10A ends in no build |
| 2 | Full lifecycle: create, improve, replace, retire | § 5 table; retire is the only gap → Unit 3 |
| 3 | Depth earned by uncertainty, not importance | § 4 route 1 (Direct Work); § 6 mode table; § 9 row 5 |
| 4 | Keep mode / project phase / Matt flow distinct | § 6, the whole section; § 9 rows 2 and 7 |
| 5 | Matt philosophy used through its owners | § 2c; § 4 routes 3–5; **Unit 0** — operability correction |
| 6 | Matt method applied semantically to non-code | § 6 closing paragraph; § 9 row 6 (ceremonial TDD) |
| 7 | Work Loop routes; it does not reproduce a specialist | § 2 map; § 6 three boundaries; § 3 rejected alternative |
| 8 | `/develop-ai-resource` owns whether an artifact exists | § 2 map; § 4 route 6; § 5 improve row |
| 9 | The operating project owns real-use adoption | § 4 route 6→7 seam; § 10C three owners; § 12 |
| 10 | Failure-mode governance enters via an existing unit | § 10A (**no build**); § 9 row 8 (OP-12) |
| 11 | One deep capability, small public seam | § 3 (zero new components); § 13 boundary |
| 12 | Final test is demonstrated usefulness | § 12 adoption proof — real requests, not static checks |

**3. Component count — current versus proposed.**

| Class | Current (verified) | Proposed | Delta |
|---|---|---|---|
| Axcíon commands (`.claude/commands/*.md`) | 88 | 88 | **0** |
| Agents (`.claude/agents/*.md`) | 40 | 40 | **0** |
| Repo skills (`skills/*/`) | 81 | 81 | **0** |
| Codex skills (`.agents/skills/*/`) | 7 | 7 | **0** |
| Mandatory stages / gates | unchanged | unchanged | **0** |
| Always-loaded rules | unchanged | unchanged | **0** |
| Persistent state artifacts | task-state file only | task-state file only | **0** |
| v1 doctrine documents | 5 (1,321 lines) | 5, pending Unit 4 | **0 now; ≤ −4 later, operator-decided** |

No increase in any class, so no complexity-budget prong needs to be cited for an addition. The plan
clears prong **(a)** (net-simplification, since it can only reduce) and independently clears prong
**(b)** on cited evidence (`0516bf6`; `logs/improvement-log.md:2823`).

**4. One-owner scenario matrix — eight routes, first owner only.** Plan § 4 carries the table. Every
row returns exactly one owner and states the condition that ends its responsibility. Route 3
(`wayfinder`) is marked **blocked today** rather than removed, so the dependency stays visible.

**5. v1/v2 seam map.** Plan § 8 — ten dependencies, each marked keep / adapt / replace / operator
decision. Four are operator decisions and none is pre-empted.

**6. Three counterexample walkthroughs.** Plan § 10, producing three different outcomes:
A speculative governance → **no build** (stops at owner 1); B verified dispatcher failure → **one
bounded Implementation unit** (never reaches an artifact owner); C capability needing a new resource →
**three owners in sequence**, each ending cleanly, with adoption last and separate.

**7. Plan-boundary check.** `git status --porcelain` was run. This unit created exactly one file —
`plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md` — and modified exactly one —
this state file. Both are committed by explicit pathspec. **No implementation surface was touched**:
no command, skill, agent, core, template, hook, setting or test file changed.

### Why this evidence can fail

It is not a restatement of the plan's headings. Each table could have read differently: the source
table could have shown a missing or closed source (claim 2 nearly did); the traceability table could
have left a constraint with no landing site (constraint 5 forced Unit 0 into existence); the component
count could have shown an increase requiring a budget prong; the seam map could have shown a
dependency with nowhere to go; the counterexamples could have collapsed into one route, which would
have proven the design a funnel. Claim 5 was returned **worse** than the brief stated, and claim 6 was
returned **partly false** — neither outcome is available to evidence that merely echoes its own plan.

## Blocker

None blocking the plan. One **premise correction** to record, which changed the plan rather than
stopping it:

**Settled design constraint 5 is not operable in this repository today.** It treats `wayfinder` as an
available planning owner and `to-tickets` as available when several slices are needed. All three of
`wayfinder`, `to-spec` and `to-tickets` require a configured issue tracker recorded at
`docs/agents/issue-tracker.md` — searched `docs/agents/` (the directory does not exist), searched the
repo for the filename (no match), searched for a `.scratch/` convention (no match). `setup-matt-pocock-
skills` has never run here. The constraint's philosophy stands; its operability does not. The plan
records this in § 2c, keeps route 3 visible-but-blocked in § 4, and opens **Unit 0** as a Discovery
unit to resolve it — rather than silently dropping the route or writing units that would fail at
execution.

**Accepted limitation, reported rather than smoothed.** `.agents/skills/work-loop-v2/SKILL.md` carries
**uncommitted modifications** (48 insertions, 2 deletions) at the time of inspection. I read the
working-tree state. The diff is unattended-run and courier-mode work; it does not touch the routing,
admission or mode sections the plan cites. Nothing was committed from it. If that change lands
differently, § 2a should be re-checked against the committed version.

**Newly noticed, recorded and not implemented** (candidate deferrals, per core § 5):

1. `docs/work-loop-spec.md` is 360 lines specifying a deleted command — larger than the contract it
   specifies. Folded into Unit 4's scope rather than actioned.
2. `develop-ai-resource.md:67` says "No executable component emits these fields **yet**". With the
   producer deleted, "yet" is now false. Carried as Unit 1 content, not fixed here.
3. Two stale worktrees (`ai-resources-active-unit-routing`, `ai-resources-g1-reviewed-plan`) hold v1
   capability work on unmerged branches. Out of scope entirely; noted because a future v1 retirement
   would need to account for them.

## Next action

Codex: assess the draft plan against this session's settled context.

The four judgments that matter, in order: (1) is **reconciliation rather than construction** the right
minimum, given that § 2a shows all five named v2 behaviours already implemented; (2) is **Unit 0**
justified, or should the tracker finding simply be recorded as a limitation and route 3 dropped;
(3) is the **v1-doctrine disposition** correctly left to the operator in Unit 4, rather than
recommended here; (4) does the evidence above genuinely discriminate — could it have exposed an
uncovered constraint, an owner collision or a budget failure.

The plan is a **draft and authorizes nothing**. Do not read this hand-back as approval to open Units
0–4; § 13 states what operator approval would and would not authorize.
