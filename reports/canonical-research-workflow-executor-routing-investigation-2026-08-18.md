# Canonical Research Workflow Executor Routing — Investigation Report

**Date:** 2026-08-18  
**Status:** Deferred fix input — investigate now, change only after the currently planned canonical Research Workflow improvements are complete  
**Primary target:** `ai-resources` canonical Research Workflow  
**First known consumer exposing the defect:** `projects/axcion-sector-intelligence`  
**Change authorization:** None. This report records the problem and bounds a later repair; it does not authorize implementation.

## Executive conclusion

Axcíon has installed an **operator-guided executor-routing surface**, but it has **not** installed an autonomous router that receives a prompt and dispatches it to Codex, a CustomGPT, Perplexity, or another tool.

The installed surface has three parts:

1. the canonical [`execution-manifest-creator`](../skills/execution-manifest-creator/SKILL.md), which classifies research questions and writes an operator-reviewed Execution Manifest;
2. the canonical Research Workflow's Stage-2 instructions and `/run-execution` command, which invoke that skill and tell the operator how to execute the resulting sessions; and
3. Sector Intelligence's project-local [`executor-routing-guide.md`](../../projects/axcion-sector-intelligence/reference/executor-routing-guide.md), which was added on 2026-08-04 to decide between Research GPT and Codex and to constrain Perplexity's role.

These parts no longer agree. The canonical skill and workflow still encode a pre-Codex routing model centered on Research GPT, a lighter Research CustomGPT, and Perplexity. Sector Intelligence adopted Codex as its sole primary gatherer under Decision 23 on 2026-07-26, with Perplexity optional and supplementary. The project-local guide added later nevertheless preserved the older Research-GPT-first default and a Germany-specific routing example. One Sector unit corrected the guide locally on 2026-08-15, but that correction has not become a consumer-neutral canonical contract and has not propagated to the other units.

The later fix should therefore **repair and simplify the canonical routing contract** and then redeploy it deliberately. It should not create an autonomous router, API relay, central queue, or second generic research-planning layer.

## 1. What is actually installed

### 1.1 Canonical manifest-planning skill

[`skills/execution-manifest-creator/SKILL.md`](../skills/execution-manifest-creator/SKILL.md) is the canonical routing logic. It:

- reads a Research Plan and Answer Specs;
- assigns every surviving question to an execution tool;
- groups questions into sessions and waves;
- records dependencies, source plans, language passes, paywall exposure, and stop conditions; and
- writes an Execution Manifest for operator approval.

Its current tool model is internally inconsistent:

- the description presents Research GPT, Perplexity, and a Research CustomGPT as available routes (lines 4–9);
- its primary criteria split questions between Research GPT and CustomGPT (lines 38–61);
- a second selector chooses between Research GPT and Perplexity, with Research GPT as the default (lines 63–67);
- the output self-check requires every routed question to land on Research GPT or CustomGPT (line 202); and
- Codex is not a route anywhere in the skill.

The companion [`manifest-template.md`](../skills/execution-manifest-creator/references/manifest-template.md) repeats the Research-GPT/CustomGPT model and includes Perplexity only as a Research GPT session tool. It also contains no Codex route.

This is a **planning skill**, not a dispatcher. Its output protocol explicitly preserves an operator-review gate before execution.

### 1.2 Canonical Research Workflow wiring

The canonical [`reference/stage-instructions.md`](../workflows/research-workflow/reference/stage-instructions.md) wires the skill into Stage 2:

- Step 2.0 routes questions to “Research Execution GPT or Perplexity” and requires operator review;
- Step 2.1 creates prompts under Research Execution GPT session assumptions; and
- Step 2.2 tells the operator to run Research Execution GPT and Perplexity sessions manually.

The deployed project command [`run-execution.md`](../../projects/axcion-sector-intelligence/.claude/commands/run-execution.md) has the same shape: it invokes the canonical skill through a subagent to produce a manifest. It does not call Codex, CustomGPT, or Perplexity and does not dispatch any prompt automatically.

The canonical workflow therefore has a **manifest planner plus manual operator execution**, not an autonomous router.

### 1.3 Sector Intelligence executor-routing guide

Sector Intelligence added [`reference/executor-routing-guide.md`](../../projects/axcion-sector-intelligence/reference/executor-routing-guide.md) in commit `7701839` on 2026-08-04. The same commit added a pointer in the project's [`CLAUDE.md`](../../projects/axcion-sector-intelligence/CLAUDE.md).

The guide's v1 routing model is:

- Research GPT is the default session executor;
- Codex is eligible only for bounded, URL-led, repetitive, or mechanical work; and
- Perplexity is supplementary discovery, freshness checking, or gap filling, never evidence of record.

This is the closest installed artifact to the “router” remembered by the operator. It remains a reference document that a human or planning agent must read and apply. No executable hook or script enforces it.

### 1.4 Sector's actual adopted operating model

Sector Intelligence's later authoritative workflow decisions use a different model. [`roadmap/parallelisation-plan-v2.md`](../../projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v2.md) §4 records Decision 23:

- Claude designs the manifest and prompts;
- **Codex is the primary Stage-2 gatherer** and writes Evidence Packs directly to disk;
- **Perplexity is optional and supplementary**, used sparingly for blind-spot diversity and routed gap fills;
- Claude merges and performs the judgment-grade verification; and
- a fresh Codex session performs only the mechanical citation spot-check within verification.

[`roadmap/research-roadmap-v1.md`](../../projects/axcion-sector-intelligence/roadmap/research-roadmap-v1.md) records the empirical basis:

- Codex replaced the Research Execution GPT CustomGPT as primary gatherer;
- Perplexity is useful for selective diversity but not required as a routine gatherer; and
- the CustomGPT comparison was inferred from Codex's absolute performance, not established through a head-to-head run.

This Codex-first mapping is project evidence, not yet a consumer-neutral canonical rule for every Research Workflow deployment.

## 2. Current defect map

### D1 — The canonical routing skill does not know about the adopted Codex lane

The canonical `execution-manifest-creator` cannot faithfully express Sector's adopted architecture because Codex is absent from its route vocabulary. The skill emits Research-GPT/CustomGPT lanes that the project must reinterpret manually at the manifest gate.

Sector tracks this as **P7 — `execution-manifest-creator` retired-lane mapping** in [`pre-batch-propagation-checklist.md`](../../projects/axcion-sector-intelligence/roadmap/pre-batch-propagation-checklist.md).

**Failure mode:** a correct project decision is silently converted into a retired tool lane and must be repaired by operator memory.

### D2 — The canonical workflow and the project guide assert incompatible defaults

The canonical Stage-2 instructions route to Research Execution GPT or Perplexity. Sector's current project-local guide and `CLAUDE.md` say Research GPT is the default and Codex the exception. Decision 23 says Codex is the primary and, for the affected Sector unit, sole gathering lane.

Sector tracks this as part of **P11 — executor-routing surface contradiction**.

**Failure mode:** whichever file an executor reads first can determine the route, even though all files appear authoritative.

### D3 — The installed guide is a project instance presented as a reusable standard

The v1 guide names German statistics offices, legal surfaces, procurement portals, and a Germany WFM worked example. It was copied into Finnish Sector units as a standard project reference.

**Failure mode:** a unit can route on another country's source-access assumptions without any stale question number revealing the defect.

### D4 — Perplexity has three different implied roles

Across the surfaces, Perplexity is variously:

- a question-level primary execution tool in the canonical manifest skill;
- an operator-run Stage-2 session tool in canonical stage instructions; and
- an optional supplementary discovery/gap-fill lane in the adopted Sector architecture.

These are materially different authorities. Sector evidence supports the third role for that project, but the canonical contract does not make the role project-configurable or consistently defined.

**Failure mode:** Perplexity output can be treated as evidence of record in one path and as leads requiring reopening and verification in another.

### D5 — CustomGPT capability assumptions are embedded as routing rules

The canonical skill assumes a Research CustomGPT is available and is the preferred route for well-sourced or borderline work. The corrected Sector v2 guide records three project-specific disqualifiers for using that CustomGPT as the executor: it is unpiloted there, cannot write the required Pack to disk without a lossy paste relay, and cannot perform the load-bearing native-language pass.

Those findings should not automatically become global claims about every CustomGPT. They do show that a canonical router cannot treat “CustomGPT available” or “CustomGPT preferred” as an unconditional fact.

**Failure mode:** tool-specific delivery limits become attached to question classes, and a project routes work to a tool that cannot produce the required artifact.

### D6 — The routing authority is duplicated and no agreement check exists canonically

The routing decision is spread across:

- the manifest skill;
- its output template;
- canonical Stage-2 instructions;
- deployed `/run-execution` commands;
- project `CLAUDE.md` cross-model rules;
- project-local executor-routing guides; and
- roadmap decisions that supersede some of the above.

Sector added a project-local E1 check requiring the guide and Stage-2 lines to be re-cut together. The canonical workflow has no equivalent single authority or deterministic agreement check.

**Failure mode:** normal deployment and project evolution create silent contract drift.

### D7 — Deployment state is split across branches and units

As inspected on 2026-08-18:

- `main` and the active `codex/florian-demo-continue` branch carry guide v1;
- nine remote Sector unit branches carry v1;
- `origin/unit/risk-security-compliance-services` carries a corrected v2; and
- `origin/unit/industrial-software` does not carry the guide.

The v2 correction names Codex as sole gatherer, repurposes the routing test to diagnose search-led versus URL-led work and discovery-pass need, and treats CustomGPT/Perplexity as supplementary lead sources. It is intentionally unit-specific and therefore cannot be copied wholesale back into the canonical workflow.

**Failure mode:** fixing one branch creates local safety without repairing the canonical source or the remaining consumers.

## 3. Why this should wait until the currently planned canonical fixes are complete

The 2026-08-17 [`research-workflow-near-term-strategic-improvements`](../plans/research-workflow-near-term-strategic-improvements-2026-08-17.md) plan already changes adjacent canonical surfaces: retrieval rules, a Targeted Research contract, reusable evidence, Deep judgment, and relay behavior.

That plan explicitly:

- defers auto-routing and API-platform expansion;
- rejects a second planning/routing layer inside the Research Workflow;
- keeps caller ownership of the decision to research and the approved scope; and
- treats Codex as Sector's current primary gatherer and Perplexity as supplementary.

Repairing routing before those changes settle would increase collision risk in the same Stage-2 files and could encode a contract around an artifact chain that is already scheduled to move. The routing defect is real, but it is not currently the right first edit.

## 4. Boundary for the later canonical repair

The later repair should answer one bounded question:

> How should the canonical Research Workflow express and verify a project's approved execution-tool mapping so that the Execution Manifest, prompts, Stage-2 instructions, and operator handoff agree—without introducing autonomous dispatch or a second planning layer?

### In scope

- establish one canonical authority for the approved execution-tool mapping;
- make the manifest skill consume or faithfully follow that authority;
- distinguish **execution role** from **product name**, at minimum:
  - primary evidence gatherer;
  - supplementary discovery/freshness/gap-fill provider;
  - no-research/mechanical executor;
  - independent verifier where applicable;
- make artifact-delivery requirements part of route eligibility: disk write or lossless handoff, native-language capability, full-source access, audit-log support, and required output schema;
- reconcile the canonical skill, template, Stage-2 instructions, SOP naming, setup/deployment instructions, and relevant project configuration;
- preserve an operator approval gate before research execution;
- provide an explicit degradation/stop rule when no configured tool can meet the mandatory controls;
- define how consumer-specific source surfaces and worked examples are instantiated without entering the canonical template as global facts; and
- audit and deliberately redeploy affected consumers after the canonical contract is corrected.

### Out of scope

- autonomous prompt classification and dispatch;
- direct invocation of CustomGPT, Perplexity, or Codex APIs from the manifest skill;
- a Perplexity Agent API relay;
- a central research queue, research agenda, capability graph, or embeddings router;
- a second generic `/research` router;
- hard-coding Sector Intelligence's Codex-first decision as a universal default for every future Research Workflow project; and
- resolving unrelated Evidence-Pack, judgment-layer, or broader pipeline-simplification work already covered by the current canonical plan.

## 5. Recommended design posture for the later repair

This section records constraints, not an approved implementation design.

### 5.1 Route by approved role and capability, then bind the tool

The canonical workflow should reason first about what the session requires—search-led discovery, URL-led verification, native-language coverage, full-page/PDF access, direct artifact writing, repetitive volume, or mechanical transformation. The project-approved configuration should bind those roles to actual tools.

This avoids two current mistakes:

- treating a product name as if it guarantees a capability; and
- treating a capability limitation observed in one project as a universal property of every deployment.

### 5.2 Keep routing declarative and operator-gated

The minimal sufficient fix is a coherent manifest contract. The workflow does not need a service that intercepts arbitrary prompts. The manifest remains the explicit, reviewable record of tool assignment, reasoning, dependencies, and execution waves.

### 5.3 Separate primary execution from supplementary leads

The canonical schema should not use one `Execution tool` field to blur:

- the tool responsible for producing evidence of record; and
- a supplementary engine that surfaces candidate URLs or freshness leads.

Those should be separate fields with separate evidence permissions and handoff rules.

### 5.4 Make absence fail visibly

If the approved primary tool is unavailable or cannot meet a mandatory control, the workflow should stop or request an operator override. It should not silently fall back to a tool whose output cannot satisfy the artifact contract.

### 5.5 Keep consumer instantiation out of the canonical facts

Country-specific domains, languages, demonstrated reach, and session examples belong in the deployed project instance. The canonical workflow should supply the fillable contract and checks, not a German or Finnish worked example presented as universal routing truth.

## 6. Candidate canonical files for the later change

This is an investigation inventory, not an instruction to edit every file.

| Surface | Why it is implicated |
|---|---|
| [`skills/execution-manifest-creator/SKILL.md`](../skills/execution-manifest-creator/SKILL.md) | Owns question-to-tool planning but omits Codex and encodes retired/default lanes |
| [`skills/execution-manifest-creator/references/manifest-template.md`](../skills/execution-manifest-creator/references/manifest-template.md) | Hard-codes Research GPT/CustomGPT output sections and distribution |
| [`workflows/research-workflow/reference/stage-instructions.md`](../workflows/research-workflow/reference/stage-instructions.md) | Defines Stage-2 planning, prompt creation, and operator execution vocabulary |
| [`workflows/research-workflow/CLAUDE.md.template`](../workflows/research-workflow/CLAUDE.md.template) | Deployed project authority and cross-model behavior |
| [`workflows/research-workflow/SETUP.md`](../workflows/research-workflow/SETUP.md) | Deployment/configuration contract for executor SOPs and project differences |
| [`workflows/research-workflow/docs/project-config-schema.md`](../workflows/research-workflow/docs/project-config-schema.md) | Possible existing home for project-approved executor bindings; avoid a new artifact unless this cannot hold the contract |
| [`workflows/research-workflow/docs/required-reference-files.md`](../workflows/research-workflow/docs/required-reference-files.md) | Currently characterizes the routing guide as operator-facing and not command-read |
| [`workflows/research-workflow/reference/sops/research-executor-gpt.md`](../workflows/research-workflow/reference/sops/research-executor-gpt.md) | SOP behavior is now used by Codex in Sector despite product-specific naming |
| Canonical/deployed `.claude/commands/run-execution.md` | Must pass the approved routing authority into manifest creation and preserve the gate |

Before implementation, re-run the reference inventory after the planned canonical changes; some paths or responsibilities may have moved.

## 7. Acceptance criteria for the later fix

The repair is complete only when all of the following are true:

1. **One authority:** a reviewer can identify one canonical source for the project's approved executor-role mapping.
2. **No contradictory defaults:** the manifest skill, template, Stage-2 instructions, project `CLAUDE.md`, and routing guide do not assert different primary executors.
3. **Codex expressible:** a Codex-primary project can generate a correct manifest without operator reinterpretation of a Research-GPT or CustomGPT label.
4. **CustomGPT conditional:** a CustomGPT route exists only when the deployed project declares it available and capable of satisfying the artifact contract.
5. **Perplexity role explicit:** primary execution and supplementary lead discovery are separate fields; evidence permissions are unambiguous.
6. **Capability gates enforced:** full-source access, native-language needs, audit logging, output-schema production, and lossless artifact delivery affect eligibility.
7. **Fail-visible fallback:** if no configured executor qualifies, the workflow stops for the operator rather than silently substituting.
8. **Operator gate preserved:** manifest approval remains mandatory before execution.
9. **No autonomous router introduced:** the fix does not add prompt interception, API dispatch, a queue, or a new routing service.
10. **Consumer-neutral canonical template:** no project's country surfaces, measured reach, or worked sessions are presented as universal facts.
11. **Deployment verified:** a fresh canonical deployment and at least one existing consumer produce the same approved tool mapping from the same test inputs.
12. **Drift test included:** a check or acceptance test fails when the declared default/tool mapping disagrees across the governing surfaces.
13. **Sector cleanup planned explicitly:** `main` and every live Sector unit receive a deliberate disposition—redeploy, re-cut, or document why the unit is exempt.

## 8. Suggested regression scenarios

Use a small table-driven test set rather than a new benchmark programme:

| Scenario | Expected routing behavior |
|---|---|
| Search-led, open-ended census; Codex configured primary; supplementary engine configured | Codex remains evidence executor; supplementary discovery recorded separately if false-negative cost is material |
| URL-led frozen entity verification | Configured primary executor; no supplementary pass by default |
| Native-language evidence is load-bearing; configured CustomGPT lacks that capability | CustomGPT ineligible; use a qualified executor or stop |
| Full-page/PDF access unavailable | Session stops; snippets cannot become evidence of record |
| Mechanical consolidation with no research | Mechanical executor role; no research tool or supplementary pass |
| Perplexity returns candidate citations | Leads recorded and underlying sources reopened by the evidence executor before use |
| No qualifying primary executor configured | Operator stop with the failed controls named |
| Country-specific project instantiated from canonical template | Project domains/languages appear; no inherited worked example or foreign-country surface remains |

## 9. Recommended later sequence

1. Finish and verify the already approved canonical Research Workflow improvements.
2. Re-run the routing-surface inventory against the post-change workflow.
3. Decide the one canonical authority for executor-role bindings, preferring an existing project configuration surface over a new artifact.
4. Repair the manifest skill and template first, then reconcile Stage-2 instructions, commands, setup, SOP naming, and deployed project pointers.
5. Test the acceptance scenarios on a fresh deployment.
6. Reconcile Sector Intelligence deliberately: preserve its validated Codex-first evidence while removing Germany-specific and retired-lane assumptions.
7. Audit other deployed Research Workflow consumers for the same stale vocabulary before declaring the canonical fix complete.

## 10. Evidence and provenance

- Canonical routing skill: [`skills/execution-manifest-creator/SKILL.md`](../skills/execution-manifest-creator/SKILL.md)
- Canonical output template: [`skills/execution-manifest-creator/references/manifest-template.md`](../skills/execution-manifest-creator/references/manifest-template.md)
- Canonical Stage-2 contract: [`workflows/research-workflow/reference/stage-instructions.md`](../workflows/research-workflow/reference/stage-instructions.md)
- Sector guide v1: [`projects/axcion-sector-intelligence/reference/executor-routing-guide.md`](../../projects/axcion-sector-intelligence/reference/executor-routing-guide.md), added by commit `7701839` on 2026-08-04
- Sector adopted architecture: [`roadmap/parallelisation-plan-v2.md`](../../projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v2.md) §4, Decision 23, 2026-07-26
- Sector empirical tool decision: [`roadmap/research-roadmap-v1.md`](../../projects/axcion-sector-intelligence/roadmap/research-roadmap-v1.md) lines 81–87
- Sector defect/propagation record: [`roadmap/pre-batch-propagation-checklist.md`](../../projects/axcion-sector-intelligence/roadmap/pre-batch-propagation-checklist.md), P7 and P11
- Corrected unit-specific guide: commit `dd4bdd2` on `origin/unit/risk-security-compliance-services`, 2026-08-15
- Current strategic boundary: [`plans/research-workflow-near-term-strategic-improvements-2026-08-17.md`](../plans/research-workflow-near-term-strategic-improvements-2026-08-17.md), especially §§1, 4, and 6

## Final disposition

**DEFERRED, DOCUMENTED, AND BOUNDED.**

Do not build an autonomous router. After the current canonical Research Workflow plan is complete, repair the canonical manifest-routing contract so projects can declare qualified execution roles and tools once, every Stage-2 surface agrees, supplementary discovery is distinguished from evidence execution, and incompatible or unavailable tools fail visibly.
