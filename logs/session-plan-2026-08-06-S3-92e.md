# Session Plan — 2026-08-06

## Intent
Prepare the concrete Work Loop v2 project-progression implementation proposal (Codex-skill ownership-routing wording, Continue core outcome + assessment mechanics + behavioral tests, blast-radius inspection deciding normal vs risk-aware review, trial-project selection), file the accepted direction as a new open thread under work-loop-v2-mvp's post-MVP v0.2 rework entry, present the proposal for operator scope approval, and — once the operator approves the scope — implement it in this session.

## Model
opus — match (session runs Fable 5, at or above the recommended tier)

## Source Material
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.agents/skills/work-loop-v2/SKILL.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop-v2.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/mission.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/work-loop-v2-mvp.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md (lines ~393–437 — the accepted direction and four corrections)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-v0.2/project-progression-protocol-original-proposal.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/step-7-pilot-log.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/work-loop-v2-slice-1.test.sh
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md
- Context pack: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/output/context-packs/architecture-20260806-92e77/pack.md

## Findings / Items to Address
1. Ownership-routing subsection for the Codex skill — route the next move by owner (operator / specialist workflow / Work Loop) before classifying discovery vs delivery; "real-use observation" is a discovery unit, not a new core unit type (decisions.md, correction 1).
2. `Continue` as a fourth assessment outcome — core § 3 steps 5–6 and the hand-off protocol tokens, plus the skill's "Assessing the result" section and a red-then-green behavioral test in work-loop-v2-slice-1.test.sh; Claude's command expected unchanged (decisions.md, correction 2).
3. Review sizing by blast-radius inspection — enumerate consumers of the core and skill; default one coherent-capability Codex review, risk-aware only if the inspection proves structurally high-consequence (decisions.md, correction 3; qc-independence.md § The rule).
4. Records and mission placement — historical Step 6 acceptance record untouched; new candidate/review record when implementation lands; new open thread under the existing post-MVP v0.2 rework entry via /mission update (decisions.md, correction 4).
5. Open items the proposal itself must settle (context-pack missing-context): which EmailOS rehaul directory is the trial target; the second trial project (no native phase model); proposal deliverable form; Continue-edit vs skill-edit sequencing (session-notes.md S2-2de Open Questions).

## Execution Sequence
1. Read the core § 3 assessment/hand-off sections, the skill's assessment + constraints sections, the mission file's post-MVP entry, and the original proposal — verify: the exact insertion points and constraint lines are identified.
2. Resolve trial-target facts: inspect the two rehaul/ directories and candidate projects without a native phase model — verify: one named EmailOS rehaul path and one named second project.
3. Blast-radius/consumer inspection: grep for consumers of the core and the skill across the repo and projects — verify: a written consumer list and a normal-vs-risk-aware verdict with stated reason.
4. Draft the implementation proposal covering all four components plus the sequencing decision and deliverable form — verify: each of the four components has concrete wording or a concrete edit description.
5. File the accepted direction as a new open thread under the post-MVP v0.2 rework entry via /mission update — verify: thread present, frozen prefix byte-identical.
6. Present the proposal in chat and STOP for operator scope approval — verify: explicit operator reply before any implementation edit.
7. (Post-approval) Implement the approved scope: core Continue outcome + mechanics, skill ownership-routing + assessment update, behavioral test added red-then-green — verify: test fails before the behavior exists, passes after.
8. Run the sized Codex review; resolve material findings — verify: review verdict recorded in a new candidate/review record under plans/work-loop-v2-mvp/.
9. Commit per commit rules — verify: commit landed, push left for wrap.

## Scope Alternatives
- Min: steps 1–6 only — proposal delivered and thread filed; implementation deferred if scope is not approved or context runs short.
- Recommended: steps 1–9 — full implementation within this session after approval.
- Max: recommended + drafting the trial-project kickoff briefs for both trial targets (only if context clearly allows).

## Autonomy Posture
Gated

**Stop points:**
- After the proposal is presented (step 6): hard stop for operator scope approval — mandated; no implementation edit before it.

## Risk
Structural change class touched — the core + skill edit is automation with shared-state effects across three consuming projects, so review sizing is decided by the step-3 blast-radius inspection: default one coherent-capability Codex review after deterministic evidence; risk-aware only if the inspection proves structurally high-consequence (qc-independence.md § The rule; operator correction 3 forbids overstating this). No separate gate runs.
