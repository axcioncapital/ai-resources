# Session Plan — 2026-07-01

## Intent
Design a `scope-cross-project-scan` agent that scans sibling `projects/*` and returns a ranked `{project → relevant files → why}` list feeding `/scope-project`'s synthesis, then run `/risk-check` + `/blindspot-scan` on the design.

## Model
opus — match (design/judgment work; hard part is deciding the agent's shape, reach, and authorization model)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/scope-project.md` — orchestrator; where the new agent plugs in (Stage 1 intake vs Stage 2 synthesis)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-synthesis-agent.md` — the Stage-2 consumer whose input this scan would enrich
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-architecture-agent.md` — sibling agent contract reference
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/scope-qc-evaluator.md` — sibling agent contract reference
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/context-discovery.md` — the WITHIN-project analogue to contrast against (this new agent is its cross-project sibling)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/project-scoping/SKILL.md` — methodology the agent serves
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/control-pack-schema.md` — artifact contract; where the scan's output fits
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md` — tiering rules + registration target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural-change classes (new agent)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md` + `blindspot-scan.md` — the two gates to run
- Context pack: `output/context-packs/agent-20260701-b7e2a/pack.md`

## Findings / Items to Address
Three design questions the context engine surfaced (from `output/context-packs/agent-20260701-b7e2a/pack.md` — must be resolved by the design, not deferred):
1. **Plug-in point ambiguity** — "Stage-1 synthesis" is loose. In `scope-project.md`, Stage 1 is intake (no agent) and Stage 2 is the synthesis agent. The design must pin exactly where the cross-project scan runs and which downstream agent consumes its output.
2. **Scan reach** — `projects/*` are separate git repos not mounted in an ai-resources session. The design must define how the agent actually reaches sibling-project files (path assumptions, `--add-dir`, workspace-root traversal, or an operator-supplied target list).
3. **Authorization gap** — no existing rule permits a scoping agent to read other projects' files. This is a live cross-project read-surface concern that `/risk-check` must weigh (confidentiality, blast radius, hidden coupling).

## Execution Sequence
1. **Read source material** — `scope-project.md` (locate the Stage-1/Stage-2 seam), `scope-synthesis-agent.md`, `context-discovery.md` (contrast), `control-pack-schema.md`, `agent-tier-table.md`. Verify: the exact plug-in point and consumer are identified with line anchors.
2. **Draft the design** to `audits/working/` — agent name, tier (likely sonnet: scan-and-return), toolset, input contract, the ranked `{project → files → why}` output schema, plug-in point, scan-reach mechanism, and authorization posture. Resolve all three findings above explicitly. Verify: design doc exists and each of findings 1–3 has a stated resolution.
3. **Run `/risk-check`** on the design (new-agent structural class + cross-project read surface). Verify: verdict recorded to `audits/risk-checks/`.
4. **Run `/blindspot-scan`** on the design. Verify: verdict recorded.
5. **Report** verdicts inline; if both clear, the build becomes a candidate for a follow-on session (build is out of scope here).

## Scope Alternatives
- **Min:** Design doc only; defer both gates to the build session. (Rejected — mandate requires the gates.)
- **Recommended:** Design doc + both structural gates run, verdicts recorded, build deferred. ← this plan
- **Max:** Design + gates + build the agent + wire into `scope-project.md`. (Out of scope — mandate is design-only; build is a separate session.)

## Autonomy Posture
Full autonomy — additive design work + advisory gates; no files edited outside the new design doc and gate reports.

**Stop points:**
- `/risk-check` returns NO-GO or `/blindspot-scan` returns PAUSE-AND-FIX → pause, report, do not advance to a build recommendation.

## Risk
New agent = structural change class, and the design introduces a **cross-project read surface** (authorization finding #3). Running `/risk-check` and `/blindspot-scan` on the design IS the core deliverable, so both gates run this session by mandate. No executable/launcher artifact — the agent is invoked in-session by `/scope-project`, so the VS Code launch-environment check does not apply.

## Gate Results (2026-07-01 S3)
- **`/risk-check`: PROCEED-WITH-CAUTION** (report `audits/risk-checks/2026-07-01-add-scope-cross-project-scan-agent-design.md`). High: Hidden coupling. SO second opinion **concurs**. Three required mitigations: (1) pre-read exclusion of confidentiality-sensitive projects by identity — load-bearing; (2) active deny-load probe (abort if not live); (3) SKILL.md authorization line (OP-11 loud decision).
- **`/blindspot-scan`: PROCEED-WITH-CONSTRAINTS** — three open findings carried into the design and to the build session:
  1. **Deny-probe is a backstop, not the guarantee** (`refresh-project-state.md:14`): filename-deny cannot catch client names embedded in normally-named CLAUDE.md bodies — the agent's exact read target. Mitigation 1 (exclusion by project identity) is the SOLE load-bearing confidentiality control; demote the deny-probe to backstop.
  2. **Base workflow unproven** — `/scope-project` has zero real runs; sequence this build AFTER its live dry-run (menu task 2), pair them.
  3. **Dual launch prerequisite** — reachability (workspace-root mount) AND deny-activity both require workspace-root launch; VS Code folder-open can open `ai-resources/` directly. Fold both as hard-abort preconditions.
- **SO-added refinements folded into the design:** exclusion must cover EVERY output section (incl. "Scanned but not relevant" / "Reach notes"), not just the ranking; register the three deny patterns as a two-end contract (`risk-topology.md § 5`) so `/permission-sweep` can't silently stale the probe.
- **Verdicts are advisory and non-blocking** (neither is a NO-GO / PAUSE-AND-FIX stop point). Build remains deferred; re-run `/risk-check` end-time gate before commit.
