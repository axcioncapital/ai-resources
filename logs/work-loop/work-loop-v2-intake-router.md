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

Standard. Implementation mode. Unit 2 — implement the ordinary-language router index in the
Codex-side Work Loop v2 skill and prove its routing boundaries.

Named reason for the loop: this changes the shared front door for meaningful repository work,
contains cross-product handoffs, and needs independent assessment before it becomes operational.

Plan justification: Unit 1 established the live inventories and resolved the ownership boundaries.
The router index is now the smallest observable change. The Discovery / Implementation / Adoption
mode contract remains a separate later unit and must not be absorbed here.

## Brief

Unit 1 established what the router must know and the correction closure check passed: all four
frozen findings are resolved, the checks pass, and no new breakage was reported. Implement that
accepted inventory as a concise routing index inside the existing Work Loop v2 Routing section.
Do not create a second router, catalogue or prompt.

### Accepted discovery result

- The runtime insertion point is `.agents/skills/work-loop-v2/SKILL.md`'s existing Routing section.
- The router selects one owner and stops. A multi-phase flow is entered through its current owner,
  not returned as a simultaneous skill stack.
- The index names **25 Matt skills**, classified once each:
  - **13 primary:** `grill-with-docs`, `grill-me`, `wayfinder`, `diagnosing-bugs`, `triage`,
    `implement`, `prototype`, `research`, `resolving-merge-conflicts`, `wizard`,
    `to-questionnaire`, `teach`, `improve-codebase-architecture`.
  - **6 phase/supporting:** `to-spec`, `to-tickets`, `tdd`, `code-review`, `grilling`, `handoff`.
  - **6 helper/reference:** `setup-matt-pocock-skills`, `domain-modeling`, `codebase-design`,
    `writing-for-agents`, `wait-what`, `ask-matt`.
- These **12 Matt skills are Claude-side only** and remain advertised with that marker:
  `ask-matt`, `codebase-design`, `diagnosing-bugs`, `grill-with-docs`, `handoff`,
  `improve-codebase-architecture`, `resolving-merge-conflicts`, `to-questionnaire`, `triage`,
  `wait-what`, `wizard`, `writing-for-agents`.
- The approved Axcíon index names **16 primary commands**:
  `/work-loop-v2`, `/develop-ai-resource`, `/scope-project`, `/new-project`,
  `/project-next-steps`, `/consult`, `/pm`, `/tech-consult`, `/open-items`,
  `/resolve-repo-problem`, `/resolve-incident`, `/repo-dd`, `/analyze-workflow`, `/lean-repo`,
  `/implementation-triage`, `/reconcile`.
- It also names **9 narrow specialist destinations**, selected only when the request names their
  purpose: `/audit-repo`, `/architecture-review`, `/systems-review`, `/token-audit`,
  `/permission-sweep`, `/pipeline-review`, `/blindspot-scan`, `/contract-check`, `/expert-check`.
- Disambiguate collisions by product plus purpose, never a bare name:
  - Matt `triage` = incoming issues and PRs; Axcíon `/triage` = review Claude's suggestions.
  - Matt `handoff` = portable file for another agent/directory; Axcíon `/handoff` = session state or
    scoped child session.
  - Matt `grill-me` = stateless interview; Axcíon `/grill-me` = structured mandate brief.
- Excluded: `/leverage-idea`; six workspace-root-only commands; the six operator-excluded
  design/motion skills; Work Loop v1 and `wl2-probe`; platform-owned skills; remaining Axcíon
  lifecycle, conversational, session, cadence, deployment, cleanup, logging and fix commands as
  competing first routes.
- No maintained catalogue. The index carries names, trigger boundaries and handoffs, never copied
  procedures.

### Required outcome

1. Expand the skill description so an ordinary-language request for meaningful repository work can
   invoke this routing judgment even when the operator does not name Work Loop v2. Preserve Direct
   Work as the default for small reversible work.
2. Generalise the existing “continue this project” router rather than leaving two routing systems.
   Route in this order:
   interpret desired outcome and object → choose one owner → if Work Loop owns it, apply
   Direct-versus-Standard admission → choose the bounded unit. Mode classification is deferred to
   the later mode-contract unit.
3. Add one compact routing index that explicitly accounts for all 25 Matt skills and the 25
   approved Axcíon primary/specialist commands. State only trigger, boundary and handoff; link to or
   name the owner instead of copying its method.
4. Every intake result contains exactly:
   - interpreted outcome;
   - one owner;
   - one short reason;
   - one actionable next instruction.
   It may identify excluded tempting routes when that prevents a likely mistake, but must not emit a
   default supporting stack.
5. When the owner is Claude-side only, Codex names the skill, labels it `Claude-side only`, and tells
   the operator to invoke that exact skill in Claude. It does not open a Work Loop state file around
   the specialist flow.
6. Preserve the owner-first boundary: operator decisions stop for the operator; specialist-owned
   work routes to the specialist without a second state system; ordinary meaningful work with no
   specialist owner goes through Work Loop admission.
7. Preserve the existing Continue behavior and project-phase orientation. A “continue” request is
   one ordinary-language intake case, not a parallel router.
8. Keep the skill attention-efficient. Do not copy `ask-matt`, command procedures, the executable
   core, or the discovery report into the skill.

### Check before acting

1. Confirm the skill still has one Routing section and the accepted insertion point has not moved.
2. Confirm every accepted Matt name still resolves under `~/.claude/skills/` and every approved
   Axcíon command still resolves under `ai-resources/.claude/commands/`.
3. Confirm the three colliding names still carry the materially different definitions stated above.
4. Confirm no overlapping uncommitted change exists in the skill or harness. If one exists, hand
   back rather than overwrite it.
5. Run the current full Work Loop harness before editing and record totals and exit status. Preserve
   unrelated known failures; do not repair or allowlist them.
6. If a concise index cannot explicitly account for all 50 approved names, hand back rather than
   silently dropping entries.

### Required evidence

Build a change-specific block red before implementation and green after. It must be capable of
showing failure and cover:

- one-owner output with the four required parts;
- Direct Work for a small reversible request;
- Work Loop for meaningful repository work with no specialist owner;
- a representative request for each Axcíon primary family and each narrow specialist family;
- Matt main-flow entry, huge/foggy work, bug diagnosis, codebase health, prototype, research,
  implementation, direct TDD, direct code review, learning, questionnaire and human-only wizard;
- all six phase/supporting skills with their direct-use boundaries;
- all six helper/reference skills with their non-route or direct-use boundaries;
- all 12 Claude-side-only markers and their exact Claude handoff;
- all three product-plus-purpose collision labels;
- no `/leverage-idea`, excluded design/motion skill, root-only command, v1 or probe promoted as a
  route;
- every accepted Matt and Axcíon name present exactly where its class requires;
- existing Continue and live-seam checks unchanged.

Demonstrate at least one failing omission case, one duplicate-classification case, one missing
Claude-only marker, one ambiguous bare collision name, and one two-owner output before showing the
implemented cases green.

Run the skill's author self-check and a focused misinterpretation check: prove a reader does not
interpret “all skills are represented” as “run them all,” does not wrap a specialist in Work Loop,
and does not confuse a supporting phase with a default co-owner.

Report the final full-harness totals honestly. Static checks prove inventory and wording, not fresh
natural-language judgment; identify the smallest live Codex routing proof still needed after this
unit.

### Scope and stop conditions

Allowed:

- `.agents/skills/work-loop-v2/SKILL.md`
- `logs/scripts/work-loop-v2-slice-1.test.sh`
- the minimum necessary test fixtures under `logs/work-loop/`
- this state file

Excluded: the executable core; `.claude/commands/work-loop-v2.md`; all other commands and skills;
user-level installations; catalogues, prompts or registries; Mode definitions or state-format
changes; Work Loop v1; `wl2-probe`; unrelated harness repairs; installation, propagation,
automation, v1 retirement and broader v0.2 work.

Stop and hand back if a premise is false; an allowed path has overlapping changes; correct work
requires an excluded edit; a name cannot be disambiguated without changing the underlying
capability; the index cannot remain concise; evidence cannot expose omission, duplication,
multi-owner or wrong-product routing; or the work expands into the later mode unit.

Completion: Claude commits only the allowed paths by explicit pathspec; every premise is
dispositioned; the red/green evidence and honest full-harness result are summarized in
`## Latest result`; remaining live proof is precise; `turn: codex`; stop for assessment.

## Latest result

Inspected (2026-08-06):

- Claim (1) the skill still has one Routing section and the insertion point has not moved: HOLDS —
  grepped `.agents/skills/work-loop-v2/SKILL.md` for `^#{1,4} `; exactly one heading matched
  `^## Routing` (`Routing a "continue" request — who owns the next move`), file 190 lines.
- Claim (2) every accepted name still resolves: HOLDS — tested all 25 Matt names for
  `~/.claude/skills/<name>/SKILL.md` and all 25 approved Axcíon names for
  `ai-resources/.claude/commands/<name>.md`; 50/50 resolved, none missing.
- Claim (3) the three colliding names still carry materially different definitions: HOLDS, **with
  one factual refinement**. Read all six definitions. Matt `triage` = move incoming issues and
  external PRs through a triage state machine; Axcíon `/triage` = independent review of suggestions
  Claude just proposed. Matt `handoff` = compact the conversation into a portable document; Axcíon
  `/handoff` = save session state or fork a scoped child session. Matt `grill-me` = relentless
  interview; Axcíon `/grill-me` = interview producing a structured mandate brief. **The refinement:**
  Unit 1 recorded Axcíon `/grill-me` as a wrapper over the Matt primitive. It is not — its body
  reads `Read \`skills/grill-me/SKILL.md\``, which resolves to the **Axcíon-owned**
  `ai-resources/skills/grill-me/SKILL.md`, not `~/.claude/skills/grill-me/`. All three collisions
  are therefore fully independent definitions. This strengthens the disambiguation rather than
  changing any membership, so no membership was altered.
- Claim (4) no overlapping uncommitted change exists in the skill or harness: HOLDS — `git status
  --porcelain` before editing showed neither `.agents/skills/work-loop-v2/SKILL.md` nor
  `logs/scripts/work-loop-v2-slice-1.test.sh` modified. Two unrelated dirty paths were present and
  left untouched: `logs/friction-log.md` (kept modified by a `PostToolUse` hook) and two untracked
  dispatcher run logs under `plans/work-loop-v2-v0.2/`.
- Claim (5) the full harness baseline: RECORDED — ran it before editing.
  **183 passed, 2 failed, exit 1.** Both failures are the same `unexpected_worklog_files` predicate.
  **They are unrelated and were preserved, not repaired or allowlisted:** 14 live task-state files
  sit outside `KNOWN_WORKLOOP_FILES`, only one of which is this task's. The condition long predates
  this unit.
- Claim (6) a concise index can explicitly account for all 50 approved names: HOLDS — it does, in
  50 bullets across five classes, within a 314-line file against a 320-line ceiling. No hand-back
  was needed.

Result: the intake router is implemented in `.agents/skills/work-loop-v2/SKILL.md`, inside the
existing Routing section rather than as a second router. The section is generalised from a
"continue" router to an ordinary-language intake router routing in the required order — interpret
the desired outcome and object → choose one owner → apply Direct-versus-Standard admission only
where the Work Loop is that owner → choose the bounded unit — with mode classification explicitly
left to a later unit. The frontmatter description now offers routing first, so an ordinary-language
request reaches this judgment without the operator naming Work Loop v2, and still names Direct Work
as the default for small reversible work. The intake result contract fixes exactly four parts and
forbids a default supporting stack. The index carries 16 Axcíon primary + 9 narrow specialist
commands and all 25 installed Matt skills classified once each (13 owners, 6 phases, 6 helpers),
with a direct-use boundary on every supporting and helper entry, `[Claude-side only]` on the 12
Codex cannot invoke, product-plus-purpose labels for the three collisions, and the non-route classes
named by class rather than enumerated. Continue and the project-phase orientation are preserved as
one intake case. The mode contract was **not** implemented and no excluded path was touched.

Three findings from the repo's own Step 6 author self-check and Misinterpretation Check were fixed
in place: `The seam`'s Next-line table had no row for a specialist owner (a reader routing to
`/repo-dd` would have fallen through to the Direct Work row and dropped the named owner); "never a
default supporting stack" was abstract, so it now carries the concrete counter-example
(`implement` alone, not `implement` + `tdd` + `code-review`); and the index now states in one line
that it is a menu to select one entry from, closing the "all skills are represented" → "run them
all" misreading. The third misreading tested — wrapping a specialist in a Work Loop unit — was
already closed by the specialist bullet's "do not wrap" and needed no rewrite.

Evidence: 39 new `ridx` assertions in `logs/scripts/work-loop-v2-slice-1.test.sh`, run red before
the implementation and green after.

- **Red run** (block written, skill untouched): **189 passed, 35 failed, exit 1** — 33 of the 39
  router assertions red. The 6 that were green are preservation guards (Direct Work retained, "do
  not wrap" retained, one Routing heading, no `ask-matt` prose copied, line ceiling) and are
  green in both states by design.
- **Green run** (after implementation): **222 passed, 2 failed, exit 1** — all 39 router assertions
  green, the 2 remaining failures the same pre-existing pair as the baseline. Net +39 assertions,
  no regression, and the existing Continue, live-seam, Slice 1–3 and `rout` blocks all unchanged in
  outcome.
- The one existing line touched is `routing_res()`'s anchor, widened from
  `^## Routing a "continue" request` to `^## Routing` because the heading generalised. All six
  `rout` assertions are unchanged and still green.

**Six failing cases, each against a mutated copy via `WL2_ROUTER_FILE` so the real file was never
doctored** — the required five plus one:

1. *Omission* — deleted `research` from the Matt owner list → `the 13 Matt primary routes are
   indexed as owners`, `all 25 installed Matt skills are classified exactly once`, and 3 more, red.
2. *Duplicate classification* — added `tdd` a second time as an owner → `no indexed name is
   classified twice` red.
3. *Missing Claude-only marker* — stripped `[Claude-side only]` from `wizard` → `exactly the 12
   Claude-side-only skills carry the marker` and `the marked set matches the live installations` red.
4. *Ambiguous bare collision name* — removed `(Matt — incoming issues and PRs)` from the `triage`
   bullet → `the Matt \`triage\` bullet is qualified by product, not bare` red.
5. *Two-owner output* — rewrote part 2 as "Owners — the owner and any supporting skills" and
   removed the no-stack rule → all three intake-contract assertions red.
6. *Excluded name promoted* — added `/leverage-idea` as an Axcíon owner → `the index holds 50
   entries, none of them excluded names` red.

Two of the marker assertions read the **live installations** (`comm -23` over `~/.claude/skills` and
`~/.codex/skills`) rather than the frozen list, so a skill installed or removed on either side
breaks them instead of drifting silently — the failure mode that left the README wrong for five
days.

A defect in my own first draft of the block, found and fixed before the green run: three set
assertions passed vacuously on an empty index, and three predicates used bare `exit` inside
`check`'s `eval`, which killed the harness at assertion 19 and returned exit 0 with no summary.
Every negative is now conjoined with a positive count, and the loops run in subshells.

**What static checks cannot prove, and the smallest live proof still owed.** Everything above reads
structure, inventory and wording. None of it exercises fresh natural-language judgment, so none of
it shows that a real request routes correctly. The smallest sufficient live proof is **one hop**:
give a fresh Codex session one ordinary-language request, with no task id and no capability named,
whose correct owner is a **Claude-side-only Matt skill**. That single case exercises interpretation,
one-owner selection, the `[Claude-side only]` marker, the "invoke that exact skill in Claude"
hand-off and the no-state-file rule together — and it is the only combination that no static
assertion here can reach. A second, cheaper case worth adding if one hop is affordable twice: a
request whose correct owner is an Axcíon narrow specialist, proving the router does not wrap a
specialist in a unit.

## Blocker

None.

## Next action

Codex: assess Unit 2 — the router index against the accepted discovery result and the eight required
outcomes, and the red/green evidence against what it claims.

Three things to disposition that are not corrections:

1. **The `/grill-me` refinement** (claim 3). Unit 1's "wrapper and primitive" caveat was wrong; the
   Axcíon command delegates to an Axcíon-owned skill. No membership changed. Accept or correct.
2. **Two Unit-1 deferrals were not carried into Unit 2's brief** and are currently recorded nowhere
   but Git history: the router's one-line answer for a Claude-side-only owner — now *implemented*
   in `### When the owner is Claude-side only`, so it is discharged rather than deferred — and
   folding the Unit-1 state-file classification checks into the harness, which was **not** done and
   remains open. Record or drop at closure.
3. **The two failing harness assertions are unrelated and were preserved.** 14 live task-state files
   sit outside `KNOWN_WORKLOOP_FILES`. Repairing that is not this task's work; deciding whether it
   becomes one is yours.

The task's exit condition is not yet met: the mode contract is unimplemented, and the live routing
proof named at the end of `## Latest result` has not run. Both are later units, not this one.
