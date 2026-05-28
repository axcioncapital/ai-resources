# Risk Check — 2026-05-28

## Change

End-time risk-check, batched across the session's executed changes for the project-manager agent + /pm slash command landing.

Executed change set (5 files touched):
1. CREATED: `ai-resources/.claude/agents/project-manager.md` — project-content advisory agent (Opus, Read/Grep/Glob/Task tools declared, advisory-with-strong-precedence ruling format, 4 fallbacks including 5d redirect to /consult). Includes a "Known runtime limitation" note documenting that Claude Code currently does not grant Task tool to subagents — PM ships in degraded mode for structure escalation (DISPATCH FAILED fallback fires deterministically; primary project-content path unaffected).
2. CREATED: `ai-resources/.claude/commands/pm.md` — slash command (Opus, dispatcher-style, includes internal QC step via qc-reviewer with pass cap of 2 — DIVERGENCE from the approved plan per operator direction mid-implementation; the plan said no QC, but operator added it because "PM will be solving quite important issues").
3. EDITED: `ai-resources/.claude/commands/consult.md` — added (a) cross-reference line in intro pointing to /pm for project-content questions, (b) inline two-end-contract comment near Step 2 (lines 42-58, the change-shape classifier list) naming the contract per `risk-topology.md § 5`.
4. EDITED: `ai-resources/docs/agent-tier-table.md` — added one row for `project-manager` (opus, Judgment).
5. EDITED: `ai-resources/logs/improvement-log.md` — three pending entries appended (v1.1 forward-looking review trigger; change-shape classifier extraction; Task-dispatch investigation).

Material findings from execution:
- BLOCKING gate (sub-subagent dispatch trace test) **fired**: PM agent reports Task tool unavailable at runtime despite frontmatter declaration. This was a known Risk #1 in the plan and a load-bearing mitigation in the risk-check plan-time PROCEED-WITH-CAUTION verdict. PM's Phase 4 fallback fires loudly (DISPATCH FAILED) instead of fabricating — per `principles.md § OP-3`. Operator chose to ship in degraded mode (Option 1) with a v1.1 investigation entry logged.
- Symlinks for project-manager.md and pm.md are already created in `projects/nordic-pe-screening-project/.claude/` (auto-sync hook fired during the session). Other projects will pick them up at their next SessionStart.
- Dry-run revert command (`find projects -maxdepth 5 -lname '*project-manager.md' -print` and same for `*pm.md`) verified working syntax against the existing consult.md symlink fan-out plus the Nordic PE freshly-created PM symlinks.

Plan-time risk-check verdict (earlier today): PROCEED-WITH-CAUTION (Low / Low / Medium / Medium / Medium). System-owner Function-B advisory concurred and re-shaped mitigations 2 (two-end contract framing) and 3 (dry-run not just documented). All four mitigations applied as binding gates.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/project-manager.md` — exists (created this session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/pm.md` — exists (created this session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md` — exists (edited this session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md` — exists (edited this session)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — exists (edited this session)
- `/Users/patrik.lindeberg/.claude/plans/i-want-to-build-tidy-lake.md` — exists (approved plan)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/.claude/agents/project-manager.md` — exists (symlink, auto-sync)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/.claude/commands/pm.md` — exists (symlink, auto-sync)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Landed-state risk profile is similar to plan-time (Low / Low / Medium / Medium / Medium) — the four binding mitigations are visibly applied, and the BLOCKING-gate degraded-mode finding is contained by an explicit operator-facing fallback and a logged investigation entry, but the late-added qc-reviewer QC step in `/pm` (plan divergence) introduces an extra Medium on usage cost and one additional hidden-coupling concern that warrants explicit mitigations before commit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- New `/pm` invocation runs `project-manager` (Opus, ~237 lines per `wc -l`) and now ALSO spawns `qc-reviewer` (Opus) on every non-fallback ruling — divergence from plan added at operator direction. Evidence: `pm.md:92-114` Step 4 spawns qc-reviewer with verbatim brief; Step 5 (pass cap 2) can spawn `project-manager` a second time then `qc-reviewer` a second time = up to **4 Opus subagent invocations per non-fallback `/pm` call** (PM #1 → QC #1 → PM #2 → QC #2).
- No always-loaded surface impact: `project-manager.md` and `pm.md` are pay-as-used (not loaded by SessionStart, not `@import`ed by CLAUDE.md). Verified via `grep -rn "project-manager\|/pm" CLAUDE.md ai-resources/CLAUDE.md` returning zero hits.
- Tier-table edit adds 1 line to a read-when-needed file (`agent-tier-table.md:34`); zero always-loaded cost.
- Improvement-log entries (3) appended to a log file, not always-loaded.
- Net: per-invocation cost rose vs plan (1 subagent → up to 4 subagents on REVISE+REVISE path); operator opted in explicitly with the "important issues" rationale. Fallbacks (5a–5d) skip QC per `pm.md:88` ("Skip QC and go directly to Step 6 if PM_RULING is a fallback") — caps the cost on degenerate paths.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edits in the change set (verified by enumerated file list; permissions files not touched).
- Agent declares `tools: - Read, - Grep, - Glob, - Task` (`project-manager.md:5-9`) — declarative only; Task is non-functional at runtime per the BLOCKING-gate finding, so the effective tool surface is Read/Grep/Glob (read-only). No `Write`, `Edit`, `Bash`, or `Skill` declared — explicit boundary at `project-manager.md:19` ("You do NOT have Write, Edit, Bash, or Skill").
- `/pm` command surface is dispatcher-style — no new tool invocation pattern beyond `Task` to spawn `project-manager` and `qc-reviewer` (both already permitted by repo conventions).

### Dimension 3: Blast Radius
**Risk:** Medium

- Files directly modified/created: 5 (per change set).
- Symlink fan-out as of now: 2 projects each contain `project-manager.md` and `pm.md` symlinks. Evidence: `find projects -maxdepth 5 -lname '*project-manager.md' -print` returns Nordic PE + axcion-brand-book; same for `*pm.md`. (Auto-sync will extend to other projects at next SessionStart, but that is bounded by the same `auto-sync-shared.sh` mechanism already in production for `/consult` and other commands.)
- New contracts introduced:
  1. **Two-end contract** with `consult.md` Step 2 lines 42-58 (verbatim duplication of change-shape classifier in `project-manager.md` Phase 3, lines 65-78). Both copies carry the contract-naming comment per mitigation #2. Evidence: `consult.md:46` "Two-end contract — if you edit the change-shape classifier list below, also update the verbatim copy in `ai-resources/.claude/agents/project-manager.md` Phase 3"; mirrored in `project-manager.md:65`.
  2. **Sub-subagent dispatch convention** — `/pm` Step 3 spawns `project-manager` via Task; PM Phase 4 then attempts to spawn `system-owner` via Task. Second hop is broken at runtime (BLOCKING-gate finding), but the convention is documented.
- Existing callers/dependents enumerated:
  - `consult.md` (cross-references `/pm`, line 8) — backwards-compatible reference only.
  - `agent-tier-table.md` (one new row) — additive.
  - `system-owner` agent body (`system-owner.md:14,41,43-44`) — unchanged; PM's Phase 4 brief invokes Function A only.
  - `auto-sync-shared.sh` hook — picks up new files without modification.
- Net blast radius is contained to read-only fan-out and additive contracts. Medium (not Low) because (a) the two-end contract is a known silent-drift hazard explicitly logged for v1.1 extraction (`improvement-log.md:291-298`), (b) the symlink fan-out has already extended to 2 projects with more arriving automatically.

### Dimension 4: Reversibility
**Risk:** Medium

- Single-commit revert handles the 5 ai-resources files cleanly (3 edits + 2 creates).
- Symlinks in Nordic PE and axcion-brand-book are NOT inside the ai-resources commit — they were created by `auto-sync-shared.sh` during the session and live in `projects/*/.claude/`. `git revert` of the ai-resources commit leaves dangling symlinks. Manual cleanup required:
  ```
  find projects -maxdepth 5 -lname '*project-manager.md' -delete
  find projects -maxdepth 5 -lname '*pm.md' -delete
  ```
  Operator verified the dry-run (`-print` only) works per change description; that's mitigation #3 applied.
- Append-only edits to `improvement-log.md` (3 new entries at lines 267, 276, 291) — `git revert` removes them cleanly because they were appended in this session's commit, but if any of those entries are referenced from other future commits before revert, those references go stale.
- `agent-tier-table.md` row addition (line 34) reverts cleanly.
- Net: not a one-step revert (symlinks need separate cleanup), but the cleanup command is verified and documented. Same Medium as plan-time.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Plan divergence: qc-reviewer in `/pm` Step 4 (added at operator direction).** This creates an implicit contract between `/pm`'s pass-cap behavior and `qc-reviewer`'s rubric. Evidence: `pm.md:92-148` (Step 4 brief + Step 5 pass-cap logic). `qc-reviewer` returns GO/REVISE/FLAG-FOR-EXTERNAL-QC verbatim shape — if that contract ever changes, `/pm` Step 5 conditional branching breaks silently. Mitigated partially by `pm.md:167` ("Plan divergence note") which documents the divergence as a binding precedent for future audits. Documented at the change site → Medium (not High).
- **Two-end contract** is now explicit (mitigation #2 applied) and named per `risk-topology.md § 5` at both ends — `consult.md:46` and `project-manager.md:65`. Documented at both sites; converts what would have been silent-drift coupling into a visible-coupling stopgap until v1.1 extraction (`improvement-log.md:291-298` logs the extraction work).
- **Sub-subagent dispatch (Task-from-agent) limitation** is named at `project-manager.md:120` ("Known runtime limitation (as of 2026-05-28)") and the DISPATCH FAILED fallback at `project-manager.md:110-118` fires deterministically. This converts a silent-failure-mode coupling into a loud-failure-mode coupling per `principles.md § OP-3`. Acceptable degradation, documented at the change site.
- **Phase 1 project detection coupling** to `projects/<name>/` directory convention (`project-manager.md:31`). Standard repo convention; documented.
- Net coupling profile: 2 named two-end contracts + 1 documented runtime limitation + 1 new QC dependency (plan divergence). All visible at the change site, all logged. Medium (not High) because every coupling is named explicitly in the change itself.

## Mitigations

- **Dimension 1 (usage cost) — accept and monitor.** Per-`/pm` cost can reach 4 Opus subagent calls on REVISE+REVISE path. Operator opted into this explicitly. No code change required, but: add a usage-tracking note to the existing 2026-05-28 v1.1 review entry in `improvement-log.md` (line 267-274) flagging "review qc-reviewer-pass-rate after first 3 invocations — if QC almost always returns GO on first pass, the second pass and the QC step itself may be removable." This converts a passive cost into a measurable feedback loop.
- **Dimension 3 (blast radius) — explicit two-end-contract sweep added to next Friday cadence.** The `improvement-log.md:291-298` entry already exists for the v1.1 extraction. Confirm the entry's triage cadence is "next Friday `/friday-act` wave" (verified at line 299 — "Triage cadence: next Friday `/friday-act` wave"). No additional mitigation needed for this dimension; the existing entry is the binding gate.
- **Dimension 4 (reversibility) — embed the verified revert command in the commit message.** Per mitigation #3 (re-shaped from "documented" to "DRY-RUN verified"), the commit message must contain the two `find … -delete -print` commands so the revert procedure is recoverable from `git log` alone, not just from the audit trail. This is the binding gate from plan-time mitigation #3 and is the only remaining pre-commit action required.
- **Dimension 5 (hidden coupling, plan-divergence QC step) — document the QC-pass-rate review trigger.** The plan divergence note at `pm.md:167` is already binding for future audits. Strengthen by ensuring the 2026-05-28 v1.1 review entry in `improvement-log.md` (line 267) explicitly names the QC-step removal as a candidate v1.1 simplification if pass-rate data supports it. This converts the silent "may keep, may remove" judgment call into a data-gated decision.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). Symlink fan-out enumerated via `find projects -maxdepth 5 -lname '*project-manager.md' -print`. Always-loaded-surface impact verified via `grep -rn "project-manager\|/pm" CLAUDE.md ai-resources/CLAUDE.md` returning zero hits. No training-data fallback was used on fetch/read failures.
