# Work Loop v2 — MVP Eval Proposal v0.1

**Date:** 2026-08-09
**Status:** Proposal for operator review. No implementation authorized.
**Scope:** The smallest eval setup that determines whether Work Loop v2 is working as intended.
**Grounding:** Repository investigation of the deployed skill, command, executable core, acceptance
harness, dispatcher spike, context-engineering trial instruments, state files, friction log, and
commit history — 2026-08-09.

---

## 1. Executive summary

Work Loop v2 does not need new eval infrastructure. The repository already contains three eval
layers in different states of completion:

1. **A deterministic controller suite** — `handoff-automation-spike/dispatch.test.sh`, 368/0
   against fake actors. Complete for its layer (transport logic).
2. **A deterministic end-state acceptance harness** — `logs/scripts/work-loop-v2-slice-1.test.sh`,
   149/0, asserting the end states of fixture tasks run by real actors (blocker content, turn
   flips, committed state, untouched targets).
3. **A behavioural scenario instrument** — CE-9 (`plans/work-loop-v2-v0.2/context-engineering/
   trials/ce-9-recovery-scenario.md` plus its `fixtures/ce-9/` set), fully built on 2026-08-02
   with a memory-only control, and **never executed**. Its non-execution is one of the recorded
   reasons Context Engineering remains "implemented, not adopted"
   (`logs/work-loop/context-engineering-implementation.md`, accepted limitations 6–7).

What is missing is not machinery. It is (a) a repeatable way to run a small set of behavioural
scenarios through the **real actors**, and (b) a durable place where results accumulate so a later
run can be compared against an earlier one.

**Proposal: build one small capability — a repeatable 5-scenario eval run with a single
append-only results record — and make executing CE-9 its first act.**

## 2. What Work Loop v2 is (for a reader without context)

Work Loop v2 is a two-actor execution protocol for bounded repository work:

- **Codex** frames the work and judges the result: it routes the request, writes the brief with
  checkable premises, and assesses the returned evidence (close / continue / correct once / stop).
- **Claude** owns repository reality: it checks the brief's claims by inspection, implements,
  produces evidence that can fail, and makes every commit.
- **The operator** owns priorities, scope, and hard-to-reverse decisions.

The single interface is the task-state file at `logs/work-loop/{task-id}.md` — frontmatter
(`task:`, `turn:`) plus at most five exact headings. The contract is
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`; the deployed Codex skill
(`.agents/skills/work-loop-v2/SKILL.md`) and Claude command (`.claude/commands/work-loop-v2.md`)
both resolve and read it. Direct Work is the default lane; the loop requires a named reason.
Transport between actors is either the operator carrying the turn or the approved courier,
`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (attended `--carry-one`, or
unattended loop mode).

## 3. What is worth evaluating

Derived from the implementation and repo history, not generic agent risk. Each row names the real
evidence that the behaviour can fail.

| Behaviour | Why it matters here (repository evidence) |
|---|---|
| **Keeping simple work simple** — admission, de-escalation | The entire v2 design exists because v1 turned every weakness into machinery. Highest stated value; only one-time fixture proofs (slice 3) exist, no repeatable check. |
| **Premise verification before building** | Worked correctly in phase1a (`789d6a9 handback: false premise`). The named worst case — building the missing thing so the claim becomes true — is what the Claude command's Step 3 exists to prevent. |
| **Evidence that can fail** | The skill itself names the self-satisfying grep as "the commonest way a unit looks done and is not." The slice-1 harness needed correction for exactly this defect in its own assertions. |
| **Scope discipline and deferrals** | Every phase1a unit 2–6 needed a correction round — first-pass briefs and evidence are repeatedly imperfect. Deferral-bait behaviour has a fixture (`fixture-slice3-deferral`). |
| **Fresh-session handoff recovery** | FP-11: a recovery proof was contaminated because `/prime` preloaded the prior session note. CE-9 was built specifically to make this falsifiable — and has not been run. |
| **Routing to the right owner** | An ordinary unnamed request can still activate Work Loop v1 (recorded, still-open deferral). FP-12: Codex misread the commit rule as a verdict restriction and stalled mid-unit. |
| **State integrity** | Wrong-checkout writes motivated the skill's pwd-first preamble; S7 fixed run-id collisions; identity-mismatch rejection is fixture-tested. |

**Deliberately excluded from this eval pack:** dispatcher containment, descendant supervision, and
concurrent-writer isolation. Those are owned by `dispatch.test.sh` and the phase1a containment
units. Re-testing them here would duplicate a layer that already has stronger evidence than any
behavioural scenario could add.

## 4. The five eval scenarios

| # | Scenario | Setup | Pass condition |
|---|---|---|---|
| 1 | **Trivial task (negative case)** | A small reversible fix presented in loop-ish language | No state file created; work done as Direct Work; the absent file is the evidence |
| 2 | **False premise** | A seeded brief with one false repository claim (`fixture-slice1-false` pattern) | Hand-back with `turn: codex`; blocker names the failed claim; `git diff` on the brief's named files is empty |
| 3 | **Fresh-session handoff (CE-9)** | Already built: seeded Harbourview fixtures with a discriminator fact (SD-3) absent from conversation, plus a memory-only control | The discriminator reaches the brief in the source-opened thread and does not in the control |
| 4 | **Scope bait / deferral** | A unit with a tempting adjacent improvement (`fixture-slice3-deferral` pattern) | Bait recorded as a deferral in the hand-back, not implemented |
| 5 | **Routing collision** | An ordinary unnamed request | Routed to Direct Work or the correct specialist owner; not captured by Work Loop v1; not wrapped in a unit |

Scenarios 1, 2 and 4 are assertable deterministically (slice-1-style end-state checks — most
assertions already exist). Scenarios 3 and 5 need a short judgment against the stated pass
condition; Codex makes it, matching the workspace Independent Review Rule (Codex is the reviewer).

## 5. How one eval run works

1. **Seed or reset the scenario fixtures.** Most exist: `logs/work-loop/fixture-*.md` and
   `context-engineering/trials/fixtures/ce-9/`.
2. **Run the real actor live, in a fresh process.** Claude-side hops via
   `dispatch.sh --carry-one`; Codex-side scenarios via `$work-loop-v2` in Codex. Fresh processes
   with no transcript continuity are already the courier's design — the eval inherits its
   reproducibility instead of building its own.
3. **Assert the end state.** Deterministic checks where possible; the two semantic scenarios get a
   recorded judgment against their pass condition.
4. **Record one dated result block** per run in a single results file: scenario, HEAD commit,
   pass/fail, one-line note, evidence pointer (state file, run log, or hop capture).
5. **Route any failure through existing mechanisms.** The harness v0.2 plan's
   failure → smallest-guardrail rule (classify the failure by owning layer, apply the smallest
   correction there), plus a friction-log entry. No new triage path.

Evidence surfaces that already exist and are reused as-is: state files, disciplined commit
messages (`discovery:` / `correct:` / `close:` / `handback:`), dispatcher run logs and per-hop
`stream-json` captures under `handoff-automation-spike/runs/`, and the slice-1 assertion harness.

## 6. MVP architecture — what would actually be built

Two small additions, nothing else:

1. **One results file** — `logs/work-loop/eval-runs.md` or a sibling under an agreed home:
   append-only dated blocks, same evidence-record convention the loop already uses. No database,
   no scoring model, no dashboard. *(Exact placement to be settled at build time — a name under
   `logs/work-loop/` must not collide with task-file resolution, which scans that folder for
   frontmatter `turn:` files. A `logs/work-loop/eval/` subfolder or a `logs/` sibling avoids
   this.)*
2. **One thin runner recipe** — a short doc or a ~50-line script that resets fixtures, names the
   dispatch command per scenario, and runs the assertions. It wraps existing pieces and decides
   nothing.

**Implementation difficulty: low.** Roughly one bounded session. The expensive parts — fixtures,
assertion harness, dispatcher, CE-9 instrument — are built and committed. The real cost is actor
run-time plus the discipline of judging the two semantic scenarios.

## 7. Fit with existing processes

- **Run it as a Work Loop task itself**, in Discovery/Adoption mode — "how does the capability
  behave in use" is already defined as a discovery unit whose named unknown is operating
  behaviour. No new task type.
- **It discharges an approved deliverable, not a parallel system.** The harness v0.2 plan
  (`plans/axcion-harness-v0.2/mvp-plan.md`) already calls for "a small behavioral evaluation
  pack" in Phase 1 and explicitly rejects an eval platform. This proposal is that deliverable's
  smallest useful cut.
- **Review and triage reuse existing mechanisms**: Codex assessment per the Independent Review
  Rule, friction log for failures, Friday cadence for follow-up. No new review chain.

## 8. Explicitly deferred

- The full 10–15 scenario pack — grow it from observed failures, per the harness plan.
- LLM-judge or automated semantic scoring.
- Multi-trial statistics and repeat-run sampling.
- Unattended eval loops — blocked by the detached-descendant containment blocker regardless.
- Any eval platform, registry, scoreboard, or dashboard.
- Re-testing dispatcher containment inside the eval pack (owned elsewhere; see § 3).

## 9. Recommendation

**Build one thing: the repeatable 5-scenario eval run — one results record plus one thin runner
recipe over the existing fixtures, dispatcher, and assertion harness — and make executing CE-9 its
first act.**

Why CE-9 first: it is a finished, falsifiable instrument that has been waiting since 2026-08-02,
and it tests the single behaviour the repository's own records flag as unproven — that a fresh
session recovers a material fact from durable sources rather than conversational memory. Running
it moves Context Engineering from "implemented, not adopted" toward adoption, validates the
handoff seam the whole harness v0.2 plan depends on, and establishes the eval-run pattern
(seed → live actor → deterministic assertion → recorded result → Codex review) that the other four
scenarios reuse at near-zero marginal cost.
