# Session Plan — 2026-08-06

## Intent
Evaluate the project-progression-protocol original proposal (plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md) against the live Work Loop v2 system — core, Codex skill, Claude command, mission state, and EmailOS/Systems Builder pipeline evidence — and deliver a chat-only recommendation (verdict, evidence-backed reasoning, minimum scope, non-goals, affected seams, bounded two-month trial, operator decisions needed). No implementation and no repo file changes this pass; do not assume the solution belongs in /work-loop-v2; do not run the investigation under Work Loop v2 itself.

## Model
opus-tier judgment work (evaluation/design triage) — match (active session model `claude-fable-5[1m]`, operator-selected frontier tier).

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md (the candidate proposal)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md (the live executable core — the contract)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md (Claude command — head already read)
- Codex-side skill: location not yet confirmed (not under ~/.codex/skills). Resolve from the core's own references during execution; if genuinely absent, that absence is itself evidence.
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md (mission state incl. post-MVP threads)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/work-loop-v2-production-readiness-policy.md (open unit) plus closed task-state files as behavioral evidence
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-7-pilot-log.md (pilot evidence incl. the v0.2 rework decision)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder/ and /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-email-os/ (project-pipeline evidence: how projects actually progress or stall)

## Findings / Items to Address
Seven determinations, all from the operator's brief (this session's mandate block, logs/session-notes.md § 2026-08-06 S2-2de):
1. What real progression problem is currently unsolved — derive from pipeline evidence, not from the proposal's framing.
2. Which proposal elements to keep / revise / reject.
3. What existing Work Loop behavior already covers.
4. Where any new behavior belongs: executable core, Codex skill, Claude command, or nowhere.
5. Smallest useful change to trial in the next two months.
6. What evidence would show genuine improvement in project progression.
7. Which decisions require operator approval.

## Execution Sequence
1. Read the proposal end-to-end. Verify: element list extracted with the seven-state lifecycle treated as a hypothesis, not authority.
2. Read the live core (work-loop-v2-executable-core-v0.1.md) and the rest of .claude/commands/work-loop-v2.md; locate and read the Codex-side skill. Verify: current admission rules, unit cycle, roles, and stop conditions captured; Codex skill path confirmed or its absence recorded.
3. Read mission state (work-loop-v2-mvp.md, post-MVP threads), the pilot log's exit decision, and the open/closed task-state files in logs/work-loop/. Verify: what the pilot's own evidence says about progression (incl. the Direct Work bypass negative result) is captured.
4. Read EmailOS and Systems Builder project state (plans/status/logs at top level). Verify: at least one concrete progression stall or hand-off gap per project is identified, or its absence recorded.
5. Analyze: map proposal elements against unsolved problems and existing coverage; test each against the mandate's boundary list; identify the smallest trialable change and its placement seam. Verify: every kept/revised element traces to observed evidence, not proposal prose.
6. Deliver the chat recommendation with all seven components. Verify: each component present; no repo file changed by the analysis.

## Scope Alternatives
Single scope — the operator fixed both the inspection surfaces and the deliverable; no min/max variants.

## Autonomy Posture
Full autonomy

**Stop points:**
- Mandate stop-if only: halt if the evaluation cannot proceed without a repo write or without routing the work through Work Loop v2 itself.

## Risk
No structural change classes apparent — read-only analysis with a chat deliverable; re-size the review if scope changes. (Recommendation-only pass; any later implementation gets its own sizing.)
