---
task: work-loop-v2-resource-capability-plan
status: closed
turn: operator
---

## Outcome

Codex accepts the corrected planning unit and closes the task.

One evidence-backed, operator-reviewable draft plan exists at
`plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md`, covering how AI resources,
repository capabilities and features are developed and improved under Work Loop v2. It ran as one
Standard unit in Implementation mode, plus one bounded correction round on four frozen findings, all
four of which were reproduced by inspection before being corrected.

The accepted minimum is **reconciliation before construction**: repair the two dangling Work Loop v1
routes, add retirement ownership only for durable AI artifacts, and run an evidence-first v1
capability gap analysis before any keep / fold / retire decision. The correction did not break the
plan's one-owner routing, its no-new-machinery constraint, or its plan-only boundary.

## Decisions that matter

- **The plan remains a draft.** Closing this task accepts it as an operator-reviewable plan. It does
  **not** approve or authorize Units 1–4; § 13 of the plan states what approval would and would not
  authorize.
- **No new machinery is proposed.** No new command, skill, agent, mode, gate, registry, always-loaded
  rule or persistent state system. Every component class stays flat.
- **Matt's planning methods stay specialist-owned and proportional.** Wayfinder is selected by
  dependent fog, not by size or importance. Its local-markdown fallback
  (`~/.claude/skills/wayfinder/SKILL.md:25`) means no advance tracker-setup unit is needed; setup is
  handled at the specialist boundary, if and when the installed skill asks.
- **The Work Loop state file is one task's interface, not a substitute for durable capability state.**
  Core § 4 reduces it at closure, so retirement conditions, real-use results and lifecycle statuses
  have nowhere to live in it. Adoption mode is a decision point, not a capability-development method.
- **Retirement is mapped by object class, not asserted as one gap.** Operating capability — defined at
  `skills/capability-development/SKILL.md:326`/`:340` and `templates/capability-record.md:7`, but in
  the layer whose executor was deleted. Durable AI artifact — genuinely unowned; Unit 3's narrow
  target. Non-AI repository feature — no candidate owner.

**Deferrals, each with its reason and reopening trigger:**

- **Ownership for retiring a non-AI repository feature stays open.** Reason: no component is added for
  symmetry. Reopens when a real retirement case demonstrates the gap.
- **The v1 capability method and its one live record stay undispositioned.** Reason: unreachable is not
  the same as redundant, and the comparison that would settle it has not been made. Reopens at Unit
  4's per-section gap analysis, then the operator's decision.
- **The possible read-scope weakness in other Matt-skill claims is not audited now.** Reason: it sits
  outside the four frozen findings, and a general audit is disproportionate. Reopens only if one of
  those claims becomes load-bearing for an implementation unit.

## Evidence

- Plan: `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md`
- Unit 1 — inspection of 8 verify-first claims, and the draft plan: `8985562`
- Correction round — four frozen findings reproduced and corrected: `6af280e`

The two load-bearing repository findings, both established by inspection rather than recall: `/work-loop`
(v1) was deleted at `0516bf6`, leaving 7 referencing lines in `.claude/commands/develop-ai-resource.md`
and 7 in `.claude/commands/leverage-idea.md`, an unreachable `skills/capability-development/SKILL.md`
(`disable-model-invocation: true`), and one live capability record with no executor. The retirement
commit's own message, and `logs/improvement-log.md:2823`, both record the rewiring as a v2-stream
design decision — which is what this plan answers.

## Accepted limitations

- **The plan was assessed against a working-tree version of `.agents/skills/work-loop-v2/SKILL.md`**
  while unrelated courier and unattended-run changes to it were uncommitted. The cited routing,
  admission and mode sections were unaffected and nothing was committed from that file. Recheck those
  sections if they change before implementation begins.
