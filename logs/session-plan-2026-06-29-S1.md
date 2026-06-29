# Session Plan — 2026-06-29

## Intent
Decide which of the three SO-vetted `/new-project` builds (#5 Data Model Steward, #4 Interface Contract Generator, #14 Operating Loop Designer) to start, or defer the build — decision only, no implementation this session.

## Model
opus — match (active session is `claude-opus-4-8[1m]`; this is a judgment/decision task → opus tier)

## Source Material
- `/Users/patrik.lindeberg/.claude/plans/frolicking-tinkering-manatee.md` — the SO-vetted 7-function build-recommendation memo (per-function verdicts, build order, corrected homes, per-build gates)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/consultations/consult-2026-06-29-newproject-layer-placement.md` — SO advisory on the planning-layer-vs-build-layer split and the corrected homes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scratchpads/2026-06-29-09-51-scratchpad.md` — continuity scratchpad with the "Resume With" read on build order

## Findings / Items to Address
The three candidate builds, from the plan memo (`frolicking-tinkering-manatee.md`):
1. **#5 Data Model Steward** — highest value; #4 depends on its entity vocabulary; heaviest to build (per SO correction, its home is a dedicated business-systems project *vault* via `/deploy-kb`, NOT `ai-resources/` — OP-10/DR-1). Pays off only when a second operational system needs to share entities.
2. **#4 Interface Contract Generator** — depends on #5's vocabulary; home is `projects/project-planning/`, emitting a conditional contract consumed by `/new-project` Stage 3b. Held to a second-consumer gate.
3. **#14 Operating Loop Designer** — independent quick-win (extends Stage 6); smallest, no deps — but edits the `/new-project` critical command, so needs `/risk-check` at both gates.
4. Scratchpad "Resume With" read: hold the build until close to building the first operational system (CRM / email / buyer DB), since the data dictionary only pays off when a second system shares entities.

## Execution Sequence
1. Read the plan memo + SO advisory + scratchpad resume note (source material above). Verify the per-build dependency chain and the corrected homes are as summarized. — *verify: dependency order (#5 → #4; #14 independent) and homes confirmed against the memo*
2. Weigh three live options: (a) start #5 now, (b) start #14 now as a quick-win, (c) defer all three until the first operational system build is imminent. — *verify: each option has a one-line ROI + timing rationale*
3. Form a recommendation with rationale and surface it to the operator for the pick (decision-point posture — recommend and proceed, but this is the operator's strategic sequencing call). — *verify: recommendation stated in one line with the main alternative*
4. Record the chosen decision (or explicit defer) in `logs/decisions.md` and the session-notes entry. — *verify: a decision line exists on disk naming the choice + rationale*

## Scope Alternatives
Single scope — no alternatives. The session produces one recorded decision; the only degree of freedom is the decision content itself (which is the deliverable, not a scope choice).

## Autonomy Posture
Gated — one stop point.

**Stop points:**
- Present the recommendation and the three options, then let the operator make the strategic sequencing pick before recording the decision. (This is a direction-setting call about when to spend build effort, so the operator decides; I recommend.)

## Risk
No structural change classes apparent this session — the work is a recorded decision only; no command, agent, hook, or settings edit. The builds themselves (if/when started) would each trigger `/risk-check` (notably #14, which edits the `/new-project` critical command) — but those are out of scope this session. Run `/risk-check` if scope changes to include any build.
