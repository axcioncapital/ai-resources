# Inbox Triage — 2026-05-27

Ranking of 4 active resource briefs in `ai-resources/inbox/`. This is a build-order recommendation, not a commitment. Each build is a separate `/create-skill` session.

---

## Ranked queue

### #1 — `workflow-diagnosis` (recommend NEXT)

**Brief:** [inbox/workflow-diagnosis.md](../inbox/workflow-diagnosis.md) — requested 2026-05-19 (8 days old).
**Shape:** 3-phase command (Clarify → Diagnose → Handoff) + 1 canonical skill at `skills/workflow-diagnosis/SKILL.md` + possibly 1 agent.
**Build cost:** 1 substantial session + 1 QC session. Mid-complexity.
**Why first:**
- Methodology is codified in a real reference execution (`projects/nordic-pe-macro-landscape-H1-2026/report/diagnostics/1.1/r1-workflow-diagnosis-2026-05-19.md`) — de-risks the build.
- Closes a paired improvement-log entry: "2026-05-22 — workflow-diagnosis skill brief overlaps improvement-analyst — document the boundary before building" (`Status: logged (pending)`). The boundary-doc edit to `docs/ai-resource-creation.md` rides in the same `/create-skill` session.
- Smaller scope than #2 — single command + single skill.
- Complements audit-workflow direction (artifact-defects → workflow-locus). Building workflow-diagnosis first gives Patrik one half of a complete diagnostic toolkit before tackling the larger #2.
**Pre-conditions:** none — brief is build-ready.

---

### #2 — `audit-workflow-pipeline`

**Brief:** [inbox/audit-workflow-pipeline.md](../inbox/audit-workflow-pipeline.md) — requested 2026-05-27 (today, freshest).
**Shape:** `/audit-workflow` orchestrator command + 3 net-new skills (`workflow-remediation-verifier`, `workflow-generalization-fitness`, `workflow-template-fitness`) + optional `workflow-audit-aggregator` skill. Composes 5 existing canonical audits in Pass 3. 0 net-new agents.
**Build cost:** 1–2 sessions to author all components + 1 QC session + verification on a real workflow.
**Why second:**
- Reference execution completed today in nordic-pe-macro — methodology and output shape are fresh and concrete (~2,700 lines across 10 files).
- Largest scope of the four briefs — better to land the smaller workflow-diagnosis first to preserve session budget.
- Opposite direction from workflow-diagnosis (workflow-infrastructure → graduation/fix readiness). Together they form the complete workflow-maintenance toolkit.
- Brief is exceptionally detailed (8 open design questions for `/create-skill` already enumerated).
**Pre-conditions:** none — brief is build-ready. Risk-check gate at the end (new command + new skills + cross-existing-resource composition).

---

### #3 — `codex-second-opinion` (pilot)

**Brief:** [inbox/codex-second-opinion-brief.md](../inbox/codex-second-opinion-brief.md) — drafted 2026-04-13 (44 days old).
**Shape:** Single `/codex-dd` pilot command + one wrapper prompt template + a few lines of shell invocation. No new skills, no new agents, no framework modifications.
**Build cost:** ~1 small session for the command. Run cost unknown until the Codex probe completes.
**Why third:**
- Smallest build of the four — but exploratory, with a real chance of negative result (Claude and Codex may converge, killing the hypothesis).
- High strategic novelty value — addresses the structural blind-spot that every audit/QC pass is executed by the same model family. Genuine value if it works.
- Greenfield — no existing references to "codex" in the workspace, no migration needed.
- Why not #1 or #2: the pilot is run-then-decide. Even if built, the value-confirming run is its own operator-driven step. Resource-build velocity is higher on #1 and #2 because their value is known.
**Pre-conditions:**
- Verify `codex login` status before invocation.
- Run a throwaway probe (e.g., `codex exec -C <small repo> -s read-only "List top-level directories"`) to measure cost/latency before the real run.
- Hard rule: wrapper prompts for Codex are paths + schema only, no editorial framing (contamination avoidance).

---

### #4 — `repo-review`

**Brief:** [inbox/repo-review-brief.md](../inbox/repo-review-brief.md) — drafted 2026-04-06 (~52 days old; no `Requested:` field).
**Shape:** `/repo-review` command for periodic operational health assessment. Judgment layer atop `/repo-dd`. Specifies: feature criticality, context management assessment, friction/improvement synthesis, functional pipeline testing.
**Build cost:** Multiple sessions. Larger scope than the others — pipeline testing is destructive-ish (creates temp projects, needs worktree isolation or cleanup).
**Why last:**
- Largest scope of the four. Multiple distinct sub-capabilities (criticality dependency graph, context-load assessment, pipeline functional testing).
- Lowest reference-execution maturity — no ad-hoc run to draw from. Design considerations are enumerated but no methodology codified.
- Benefits from #2 (audit-workflow) landing first — `/repo-review` could compose `/audit-workflow` for the workflow-specific portion.
- Significant overlap with `/friday-checkup` monthly tier + `/audit-repo` — boundary clarification needed before build.
**Pre-conditions:**
- Boundary clarification vs. `/friday-checkup` monthly tier and `/audit-repo` (which already does workspace health audit).
- Decision on pipeline-testing isolation (worktree vs temp project cleanup).
- Land #2 (audit-workflow) first so `/repo-review` can compose it rather than duplicate workflow-audit logic.

---

## Suggested next-session sequence

1. **Next build session:** `/create-skill` against `inbox/workflow-diagnosis.md` → ships canonical skill + command + boundary-doc edit.
2. **Follow-up:** `/create-skill` against `inbox/audit-workflow-pipeline.md` → ships `/audit-workflow` orchestrator + 3 skills.
3. **Exploratory:** Codex pilot — start with auth check + throwaway probe in a session that has 30–60 min budget remaining after other work; build `/codex-dd` if the probe succeeds.
4. **Defer to monthly cadence:** `/repo-review` build — revisit after #2 lands and the boundary vs. `/friday-checkup` monthly tier is clear.

---

## Notes

- None of the 4 briefs has a hard deadline.
- The 2 nordic-pe-derived briefs (#1 workflow-diagnosis + #2 audit-workflow) are complementary: building both gives a complete forward+backward workflow-maintenance toolkit. Sequencing #1 before #2 lets Patrik validate the diagnosis-side methodology in production before committing to the larger audit-side build.
- This triage file is a build-order *recommendation* — Patrik may reorder based on actual session availability or upstream project needs.
