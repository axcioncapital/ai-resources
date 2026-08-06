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

Inspected (2026-08-06):

- Claim (1) the core still defines exactly two lanes, keeps its execution/discovery unit
  distinction, and `## Lane and unit` is the field for lane and unit: HOLDS — searched the core;
  line 57 reads "There is no third lane", line 86 carries "An execution brief is implemented. A
  **discovery unit** is inspected, not implemented", and § 4's field table row for
  `` `## Lane and unit` `` was present as stated.
- Claim (2) the Codex skill still holds the accepted 50-entry router and explicitly defers mode:
  HOLDS — counted 50 `^- \`` index bullets; the deferral was at line 80 ("is not classified here.
  That contract is a later unit") and line 312.
- Claim (3) the Claude command carries no independent mode contract: HOLDS — searched
  `.claude/commands/work-loop-v2.md` for `mode`; the only match was `model: opus` frontmatter.
- Claim (4) the harness baseline: RECORDED — **222 passed, 2 failed, exit 1** before any edit. The
  two failures are the same `unexpected_worklog_files` pair as Unit 2's baseline. Distinguished from
  new failures throughout; not repaired, not allowlisted.
- Claim (5) no overlapping uncommitted change in the core, skill, command or harness: HOLDS —
  `git status --porcelain` over all four returned only this state file (Codex's own brief write).
- Claim (6) the three modes can be added with no new state field, third lane, new unit type or
  renamed project phase: HOLDS by construction, and the harness now asserts each of the four
  separately. Mode sits inside `## Lane and unit`; the five-field ceiling is untouched; each mode
  binds to a unit kind core § 3 step 4 already defines.

Result: the mode contract is implemented across the core and both runtimes.

The core owns it in a new § 3 subsection, *The unit's mode*: every open Standard unit is in exactly
one of Discovery, Implementation or Adoption, recorded inside `## Lane and unit`, and each binds to
an existing unit kind — Discovery and Adoption are **discovery units**, Implementation is an
**execution brief**. No new field, heading, frontmatter key, lane or unit kind was created; § 4's
five-field ceiling and § 5's vocabulary gained one row each (`## Lane and unit`'s description, and
**Mode**). The Codex skill classifies at routing step 4, only once admission has succeeded, and
carries the operator's three worked cases (Email OS → Discovery, CRM correction → Implementation,
CRM operating trial → Adoption) with the trap named: read the uncertainty, not the size. The Claude
command carries what each mode requires of the evidence it returns, and treats a mode that
contradicts its own completion condition as a false premise to hand back. All deferred-mode wording
is gone from all three artifacts.

**Required outcome 7 — Adoption without a new unit type — resolved rather than handed back.**
Adoption's named unknown is whether an existing capability should enter normal operations, which is
evidence about a named unknown, so it is a discovery unit. The apparent conflict is with "real or
representative operation" against the discovery boundary "changing nothing beyond the state file".
The core now resolves it explicitly: where a trial needs the capability actually operated, that
operating is separate work — Direct Work, a specialist flow, or its own unit — and the unit in
Adoption mode reads the evidence it produced. Neither rule is weakened and no "adoption unit"
exists; the harness asserts that string appears in none of the three artifacts.

Evidence: 49 new `mode` assertions, red before the contract and green after.

- **Red run:** 227 passed, 46 failed, exit 1 — 44 of the 49 red. The 5 green were non-invention
  guards (two lanes, five fields, no `## Mode` heading, no `mode:` key, and one control) which must
  hold in both states by design.
- **Green run:** **271 passed, 2 failed, exit 1.** All 49 `mode` assertions green. The 2 failures
  are the same pre-existing `unexpected_worklog_files` pair as the baseline — unchanged, unrepaired.
- **No regression:** `ridx` 39/39, `cont` 25/25, `seam` 5/5, and the Slice 1–3 admission and
  correction blocks all retained their outcomes.

The wrong-classification detector is the load-bearing piece. It never reads the mode name from the
prose: `required_shape()` derives the unit shape the **completion condition** requires, then compares
that with the mode actually recorded. Keyword-matching "discovery" would pass on a mislabelled file,
which is the failure under test. Three mislabelling cases are derived from the valid fixtures and
asserted caught — a Discovery unit relabelled Implementation, an Implementation unit relabelled
Discovery, an Adoption unit relabelled Implementation — plus a discrimination check that the detector
returns three distinct verdicts rather than blanket-rejecting.

Four state-file failing cases are derived the same way, so the fixtures are never doctored. Read at
the record position, they produce: missing → `Standard.`; two modes → `Standard. Discovery mode.
Adoption mode.`; unknown → `Standard. Exploration mode.` (parsed, then rejected as not one of the
three); valid control → `Standard. Discovery mode.` A `## Mode` heading and a `mode:` frontmatter
key are asserted absent from all three artifacts.

Four defects in my own harness block were found and fixed before the green run, three of them the
same lesson: **bare `exit` inside `check`'s `eval`** killed the run at assertion 27 (exit 0, no
summary); one assertion passed vacuously on an absent fixture; and **hard-wrapped prose broke three
separate greps** — the no-copy sentinel spans a line break in the core, the `Completion:` condition
is a paragraph rather than a line, and "Do not\nimplement" straddles a break. Each is now flattened
or paragraph-scoped.

One real design correction came out of the live state file rather than from a fixture. The first
version read the whole `## Lane and unit` field for mode tokens, and Unit 3's own description
legitimately names all three modes in prose — so the live file counted as three records. The record
is now **positional**: core § 3 fixes the shape `Standard. <Mode> mode. Unit N — …`, the mode is the
second sentence, and prose further down the field cannot be mistaken for the record. That is a
contract improvement the harness would not have surfaced against fixtures alone.

The Misinterpretation Check disproved three of the four misreadings the brief names and found one
real gap. Modes-as-a-third-lane and implement-during-Discovery were already closed by the core's own
wording; three-simultaneous-labels is closed by the positional record and "exactly one". **Modes as
sequential phases was open** — the table's order reads as a pipeline (discover → implement → adopt),
and nothing forbade that reading. The core now states that the three are not a sequence: each unit
is classified from what is uncertain now, a task may run every unit in one mode, and a later unit may
return to a mode an earlier one used.

Line counts, per required outcome 10: core 408 → 456, skill **314 → 331**, command 126 → 136. The
skill's 320-line implementation guard was exceeded, so it was **re-based to 340 and kept, not
deleted** — 9 lines of headroom, so the next addition still has to justify itself.

**What static evidence cannot reach, and the exit condition that remains.** Everything above proves
the contract exists in one owner, both runtimes agree with it, the state shape is right, and a
recorded mode that contradicts its own completion condition is caught. None of it shows that a fresh
Codex session *chooses* the right mode for a real request — that is natural-language judgment, and
no assertion here reaches it. The remaining proof is unchanged in kind from Unit 2 and now has two
parts, both needing one fresh session each: a request whose correct owner is a Claude-side-only Matt
skill (proving intake, one-owner selection, the marker and the no-state-file rule together), and a
request whose correct mode is **Adoption** — the newest and least obvious of the three, and the one
whose misclassification as Implementation would license building something that was only meant to be
judged.

## Blocker

None.

## Next action

Codex: assess Unit 3 — the mode contract against the ten required outcomes, and the red/green
evidence against what it claims.

Four things to disposition, none of them a correction request:

1. **Required outcome 7 was resolved, not handed back.** Adoption is a discovery unit about
   operation; where a trial needs the capability operated, that operating is separate work and the
   Adoption-mode unit reads its evidence. Confirm that reading is what you intended, because it is
   the load-bearing sentence of the whole contract.
2. **The record is now positional** — `Standard. <Mode> mode. Unit N — …`. This was not in your
   brief; it came out of your own Unit 3 state file, whose description names all three modes in
   prose. Accept the shape or name a different one.
3. **The skill's line guard was re-based 320 → 340, not deleted**, per required outcome 10. Exact
   counts are in `## Latest result`.
4. **Three new fixtures** were added under `logs/work-loop/` and registered in the harness's
   `KNOWN_WORKLOOP_FILES`. That registration is the harness's designed friction for new fixtures,
   not a repair of the two pre-existing worklog-inventory failures, which remain failing and
   untouched.

The task's exit condition is now one item, not two: the router and the mode contract are both
implemented, and what remains is the fresh-session natural-language proof described at the end of
`## Latest result` — two requests, one for owner selection and one for Adoption-mode classification.
That is a later unit, and it is the last thing standing between this task and closure.
