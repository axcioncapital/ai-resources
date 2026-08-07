---
task: work-loop-v2-intake-router
turn: codex
---

## Objective and scope

Codex can receive an ordinary-language request, recognise the operator's current core capabilities,
and select exactly one appropriate route without requiring the operator to remember skill names.
When Work Loop v2 owns the request, Codex also classifies the active mode as Discovery,
Implementation or Adoption and records it inside `## Lane and unit`.

The router must cover the approved Axcíon command set and every relevant installed Matt Pocock
skill. The task closes only when the router and mode contract are implemented and representative
ordinary-language cases can expose a wrong route.

## Lane and unit

Standard. Implementation mode. Unit 3 — implement the Discovery, Implementation and Adoption mode
contract across the Work Loop core, both runtime instructions and the evidence harness.

Named reason for the loop: this changes the shared operating contract between Codex and Claude,
affects how evidence is judged, and must preserve the existing lane, unit and state-file protocols.

Plan justification: Unit 2 delivered and proved the approved router inventory. The task exit
condition remains unmet because the router still explicitly defers mode classification; adding the
mode contract is now the smallest observable change justified by the operator's stated objective.
Fresh natural-language routing proof remains a separate later unit.

## Brief

Unit 2 is accepted: the ordinary-language router now selects one owner from the approved 50-entry
index, preserves Direct Work and Continue, and correctly hands Claude-only routes to Claude. This
unit adds only the missing operating-mode contract. It must not reopen the accepted inventory or
turn the three modes into another workflow, lane or state system.

### Accepted result and dispositions

- The current router implementation in `.agents/skills/work-loop-v2/SKILL.md` is the accepted
  starting point. Codex independently reran the full harness: **222 passed, 2 failed, exit 1**;
  all 39 `ridx` assertions passed and the same two pre-existing `unexpected_worklog_files`
  assertions failed.
- The `/grill-me` factual refinement is accepted. Axcíon `/grill-me` delegates to the
  Axcíon-owned `skills/grill-me/SKILL.md`; it is not a wrapper over Matt `grill-me`. The existing
  product-plus-purpose disambiguation remains correct.
- The Unit-1 deferral to test state-file classification is carried into this mode unit because
  correct mode text must be proven inside `## Lane and unit`.
- The two unrelated worklog-inventory failures are not part of this task. Preserve and report them;
  do not repair, allowlist or convert them into another unit here.
- The fresh natural-language routing proof is deliberately held outside this unit because mode
  semantics must exist before representative operation is assessed. This is Codex's sequencing
  decision, not an additional operator requirement.

### Governing authority and boundaries

- **Governing operator decision:** record the active mode inside `## Lane and unit`; add no state
  field.
  - **Discovery:** use when the problem, requirement, ownership boundary or solution remains
    uncertain. Evidence resolves a question through inspection, comparison, research or
    experimentation; it does not produce the target implementation.
  - **Implementation:** use when the objective, authority and boundaries are sufficiently settled.
    Evidence demonstrates the failing case, implemented result and relevant regression protection.
  - **Adoption:** use when a capability already exists and the question is whether it should enter
    normal operations. Evidence covers real or representative operation, reliability, burden,
    failure conditions, usefulness and the lifecycle decision.
- The operator's examples are required classification cases: Email OS is largely Discovery, CRM
  corrections are Implementation, and the CRM operating trial is Adoption.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` remains authoritative for roles,
  the two lanes, the existing unit vocabulary, the five-field active-state ceiling and exact
  headings. Mode must fit that contract rather than silently replacing it.
- `.agents/skills/work-loop-v2/SKILL.md` owns Codex's classification and brief-writing behavior.
  `.claude/commands/work-loop-v2.md` owns Claude's execution and evidence hand-back behavior.
- The attached Axcíon Work Loop Operating Specification is labelled `Status: Draft`; it is
  non-governing background except where the operator separately made the mode instruction above.

### Required outcome

1. Define mode as one classification of the currently open Standard unit. It is orthogonal to
   lane, owner, project phase and unit number: it is not a third lane, a new unit type, a project
   phase or a second workflow.
2. Record exactly one of `Discovery mode`, `Implementation mode` or `Adoption mode` inside
   `## Lane and unit` for every open Standard unit, alongside the lane and unit. Add no heading,
   frontmatter key or parallel state file. Direct Work opens no state file, and specialist-owned
   work remains outside the Work Loop, so neither gains a synthetic mode record.
3. In Codex routing, classify mode only after one owner has been selected and Work Loop admission
   has succeeded, then choose and brief the bounded unit. Preserve the intake result's existing
   four-part contract; mode must not become a fifth simultaneous owner or output stack.
4. Make Discovery operational: the brief names the uncertainty and the question the evidence must
   resolve; Claude inspects or experiments and hands back evidence without implementing the
   eventual target. Preserve the core's discovery-unit boundary.
5. Make Implementation operational: the brief proceeds only when objective, authority and
   boundaries are sufficiently settled; its evidence covers a failing case, the implemented
   result and regression protection relevant to the change. Do not require irrelevant ceremonial
   tests where no meaningful regression check exists; the evidence must explain that boundary.
6. Make Adoption operational: the capability already exists, the named unknown is whether it
   should enter normal operations, and the evidence addresses real or representative operation,
   reliability, operator burden, failure conditions, usefulness and an explicit lifecycle
   decision — adopt, revise, continue the trial or stop.
7. Fit Adoption honestly into the core's existing unit vocabulary; do not invent an “adoption
   unit.” The current Codex skill says operating evidence from real use is a discovery unit. If
   the operator's real-or-representative-operation requirement cannot coexist with the core's
   discovery-unit no-target-implementation boundary, hand back the precise conflict rather than
   weakening either rule silently.
8. Make both runtimes agree on who classifies the mode, where it is recorded, what each mode
   requires, and what evidence Claude returns. Keep the executable core as the semantic authority
   and avoid copying whole procedures between the core, skill and command.
9. Replace all “mode is deferred/later/unimplemented” language with the implemented contract while
   preserving the accepted router index, Continue behavior, courier boundaries, admission rules
   and exact state-file headings.
10. Keep the resources attention-efficient. The current 320-line Codex-skill ceiling was a Unit-2
    implementation check, not operator authority; preserve it if meaning remains clear. If the
    mode contract requires a small increase, replace it only with a bounded, evidence-backed limit
    and report the exact before/after count rather than deleting the guard.

### Check before acting

1. Confirm the core still defines exactly two lanes and its current execution/discovery unit
   distinction, and that `## Lane and unit` remains the exact field intended to hold lane and unit.
2. Confirm the Codex skill still contains the accepted 50-entry router and explicitly defers mode
   classification rather than implementing it.
3. Confirm the Claude command contains no independent mode contract that would conflict with this
   unit.
4. Reproduce the full harness baseline and distinguish the two known
   `unexpected_worklog_files` failures from any new failure.
5. Confirm no overlapping uncommitted change exists in the core, Codex skill, Claude command or
   harness. If one exists, hand back rather than overwrite it.
6. Confirm the three mode definitions can be added without a new state field, third lane, new unit
   type or renaming a project's own phases. If not, hand back the exact incompatibility.

### Required evidence

Build a change-specific block red before implementation and green after. It must be capable of
showing failure and cover:

- one valid active-state example for each mode with the mode recorded inside `## Lane and unit`;
- a failing state-file case for a missing mode, two modes, an unknown mode and a separate
  mode-specific heading or frontmatter key;
- a classification case for each operator example: Email OS → Discovery, CRM correction →
  Implementation, CRM operating trial → Adoption;
- a failing wrong-classification case for each mode, based on the defining uncertainty or
  completion condition rather than keyword matching alone;
- Discovery evidence resolves a named question and does not implement the eventual target;
- Implementation evidence demonstrates the failing case, implemented result and relevant
  regression protection;
- Adoption evidence covers real or representative operation, reliability, burden, failure
  conditions, usefulness and a lifecycle decision;
- Adoption creates no third lane or unit type and does not rename project phases;
- mode is classified only after Work Loop ownership and admission, and no mode state is opened
  around Direct Work or a specialist flow;
- both runtimes and the core agree on the mode vocabulary and state location;
- no deferred-mode wording remains;
- the accepted `ridx`, Continue, live-seam, admission and correction checks retain their outcomes.

Demonstrate red cases through isolated fixtures or mutated copies so the live state and accepted
router are not doctored. Run the relevant author self-check and a focused misinterpretation check:
prove a reader cannot treat modes as sequential phases, a third lane, three simultaneous labels,
or permission to implement during Discovery.

Run the full harness last and report totals and exit status honestly, separating pre-existing
failures from regressions. Static evidence proves the contract and state shape, not whether a fresh
Codex session makes a good natural-language judgment; preserve that as the precise remaining exit
condition.

### Scope and stop conditions

Allowed:

- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`
- `.agents/skills/work-loop-v2/SKILL.md`
- `.claude/commands/work-loop-v2.md`
- `logs/scripts/work-loop-v2-slice-1.test.sh`
- the minimum necessary fixtures under `logs/work-loop/`
- this state file

Excluded: changes to the accepted 50-entry inventory except the minimum integration needed to
remove deferred-mode wording; other commands or skills; user-level installations; catalogues,
prompts or registries; a new state field, lane, unit type, phase model or artifact; Work Loop v1;
`wl2-probe`; the two unrelated worklog-inventory failures; fresh live-routing operation;
installation, propagation, automation, v1 retirement and broader v0.2 work.

Stop and hand back if a premise is false; an allowed path has overlapping changes; the mode
definitions conflict materially with the executable core; Adoption cannot be represented honestly
without a new unit type or weakening the discovery boundary; correct work requires an excluded
edit; evidence cannot expose a wrong classification; or an operator-owned decision about intent,
authority or risk is required.

Completion: Claude commits only the allowed paths by explicit pathspec; every premise is
dispositioned; red/green evidence and the honest full-harness result are summarized in
`## Latest result`; the remaining fresh-session proof is stated precisely; `turn: codex`; stop for
assessment.

## Latest result

Reproduced both frozen findings by inspection before correcting either.

- Finding (1) REPRODUCES — searched `logs/scripts/work-loop-v2-slice-1.test.sh`; line 1104 carried
  `check "ridx  mode classification is deferred, not implemented here"` with the predicate
  `routing_res | grep -qi 'mode' && routing_res | grep -qi 'later'`. Searched the skill's routing
  section for `later`: the only occurrence is "a flow's **later** phases are reached by its owner"
  in the intake-result contract — nothing to do with mode. The section meanwhile reads
  "**Classify the mode** … **only once admission has succeeded**", so the assertion's own claim was
  false while the assertion stayed green.
- Finding (2) REPRODUCES — `logs/work-loop/fixture-mode-implementation.md` line 15 read "the change
  is small but its result is asserted by the acceptance harness, so it needs assessing by someone
  other than whoever wrote it". Core § 2 line 51 reads "If the work is small and reversible, it is
  Direct Work even when one of those is tempting." The fixture named as its qualifying reason the
  exact reason the core excludes, so it was not a valid Standard unit.

Result: both findings corrected, and nothing else touched.

**Finding 1** — the stale assertion is replaced by two that read the boundary actually implemented.
`ridx  mode is classified after admission, never at intake` reads the routing steps **positionally**
and requires the Classify-the-mode step to fall after the admission step; `ridx  only an admitted
Work Loop unit acquires a mode` requires the exclusion sentence. Order is the claim, so reordering
the steps turns it red — which loose word-matching could never do.

**Finding 2** — the fixture's named reason is rewritten to core § 2's second qualifying reason, and
it is factually true rather than decorative: the scope needs bounding because `fixture-target-3.md`
is the live-seam target whose `Seam-step-1:`/`Seam-step-2:` lines the seam assertions read at
specific commits, so "add a line to it" reaches into what those assertions depend on. The
Implementation completion condition is unchanged, and the fixture still classifies as Implementation.
Three new assertions stop the contradiction recurring: every mode fixture must state a named reason,
no mode fixture's reason may defeat its own admission, and the same check runs against this live
task's own reason.

Evidence: full harness **275 passed, 2 failed, exit 1** — up from 271/2, with the two failures the
same pre-existing `unexpected_worklog_files` pair, still unrepaired and unallowlisted. No other
block changed outcome.

*Finding 1's required demonstration — the old predicate passes for the wrong reason, the corrected
one cannot.* Run against the corrected skill and two mutated copies:

| Artifact | Old predicate | Corrected predicate |
|---|---|---|
| the corrected skill | PASS | PASS |
| mutant A — mode classification reverted to the Unit-2 deferral | **PASS** | fail |
| mutant B — Classify-the-mode moved *before* the admission step | **PASS** | fail |

The old predicate cannot tell the three apart: it is green whether mode is classified after
admission, before it, or not at all. That is the defect, shown rather than asserted.

*Finding 2's required demonstration.* The admission-honesty check is green on the corrected fixture
and red on a copy with the original wording reinstated — `RED — defeats its own admission`. It reads
the named reason only, so it fails on the contradiction itself rather than on any fixture identity.

Newly noticed, recorded and **not** implemented: Finding 1 is an instance of a class, not a one-off.
At least one other assertion I wrote has the same looseness — `ridx  /leverage-idea is named as
excluded, with its router-within-router reason` conjoins a real check with `grep -qi 'router'`, a
word that appears throughout the file, and `mode  Implementation does not demand ceremonial tests`
is a disjunction where a conjunction was meant. A sweep for predicates that can pass for an
unrelated reason is a bounded unit of its own; it is out of this frozen scope and is a candidate
deferral for the closure check.

## Blocker

None.

## Next action

Final tightly-bounded fix:

The two frozen findings are resolved, but their correction accidentally removed the
`## Latest result` heading and the end of the Brief's Completion sentence, leaving the result
embedded inside `## Brief`. Codex has restored only that exact state-file boundary so the interface
is valid again.

Claude: verify this file now has exactly one each of the five active headings, that the correction
result sits under `## Latest result`, and that the Brief's Completion sentence is complete. Change
nothing unless that exact structural repair is still incomplete; commit only this state file by
explicit pathspec, set `turn: codex`, and hand back for the final-fix closure check. Do not alter the
runtime, harness, fixtures or the accepted correction.
