# Plan — Rename `/route-change` → `/placement` + Add Placement Verifier to Canonical Pipelines

**Date:** 2026-05-28
**Origin:** Operator request "improve route-change command — rename + run through system owner."
**System Owner advisory:** Reviewed and accepted. Verdict: command fundamentally well-designed but structurally incomplete. Top fix: post-write placement verifier inside canonical creation pipelines (SO advisory item #1).
**Operator decision:** Ship rename + #1 (verifier). Defer items #2–#5 to backlog (improvement-log).
**Risk classes (per `docs/audit-discipline.md § Risk-check change classes`):**
- Cross-cutting CLAUDE.md edit (workspace-level)
- Canonical command edit (`/route-change` → `/placement` plus one pipeline edit — see amendment below)
- New process documentation (placement-verifier procedure)

**Plan-time `/risk-check` required before execution.** End-time `/risk-check` required before commit.

---

## Plan amendments (2026-05-28, post `/risk-check` + `/consult`)

`/risk-check` verdict: **PROCEED-WITH-CAUTION** (full report: `ai-resources/audits/risk-checks/2026-05-28-placement-rename-and-verifier.md`). System-owner second-opinion concurred with the verdict but flagged three concerns the dimension review missed (M1, M2, M3 in the report's Architectural Commentary).

**Operator-accepted amendments:**

1. **Scope reduced (M1):** Stage B integrates the verifier procedure into `/graduate-resource` only (the plan's own "highest-leverage" pipeline call). The other four pipelines (`/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`) are deferred to the next `/friday-act` wave alongside SO items #2–#5, gated on observed placement misses per `principles.md § DR-7`. The verifier procedure itself is designed to support all five; this amendment changes only the integration surface.
2. **Friction-log writes re-routed (M2):** End-time MISMATCH entries land in `ai-resources/logs/maintenance-observations.md` (canonical Q6 home for repo-health observations), NOT `friction-log.md`. This avoids the two-end contract violation flagged by SO. Schema is pinned per reviewer mitigation #4 but for the maintenance-observations target.
3. **Workspace CLAUDE.md heading-anchor check added (M3):** Stage A acceptance criteria adds `grep -rn "Placement Discipline" --include="*.md"` to confirm the section heading is not a downstream parser anchor.
4. **File-surface enumeration extended (reviewer mitigation #1):** Stage A touch-list explicitly includes `consult.md`, `risk-check.md`, `docs/ai-resource-creation.md`, `docs/repo-architecture.md`. Historical log entries in `logs/innovation-registry.md` line 87 and `logs/decisions.md` lines 87 and 100 are **preserved as historical names** (operator decision: log entries reflect the name at time of decision).
5. **Symlink cleanup extended (reviewer mitigation #2):** `find` extends to workspace root: `find ~/Claude\ Code/Axcion\ AI\ Repo -name route-change.md -type l -delete`.
6. **Commit message documents symlink asymmetry (reviewer mitigation #3):** Commit message notes that future `git revert` will restore the canonical file but auto-sync will repopulate project symlinks as `placement.md` on next SessionStart.

---

## Stage A — Rename `/route-change` → `/placement`

### Goal
Align command name with workspace terminology ("Placement Discipline" section heading in workspace `CLAUDE.md`) and with the command's own output field ("Routing recommendation" → field "Canonical home" / "Placement recommendation").

### Surface
Two files plus auto-symlinked propagation.

1. **`ai-resources/.claude/commands/route-change.md`** → renamed to `placement.md`.
   - File contents stay structurally identical. Two internal references update:
     - Line 17 — the "This command is **not** auto-wired …" paragraph references `/route-change` by name; update to `/placement`.
     - Line 122 — "If the operator approves the recommendation and proceeds …" references `/route-change`; update to `/placement`.
   - Frontmatter (`model: sonnet`) and Step 1–5 body otherwise unchanged.

2. **`~/Claude Code/Axcion AI Repo/CLAUDE.md`** — workspace-level always-loaded.
   - Line 37: "run `/route-change <one-line description>`" → "run `/placement <one-line description>`"
   - Line 46: "`/route-change` is advisory and non-mutating" → "`/placement` is advisory and non-mutating"
   - `## Placement Discipline` section heading itself is unchanged (already aligns).

3. **Auto-sync side effects** (informational, not edits):
   - `auto-sync-shared.sh` symlinks `ai-resources/.claude/commands/*.md` into each project's `.claude/commands/`. After rename, next session start will symlink `placement.md` into projects. The old `route-change.md` symlinks in projects will become **dangling** (target file deleted).
   - **Mitigation:** Run `find projects/ -name route-change.md -type l -delete` as the last step of Stage A execution to clean up the dangling symlinks proactively. (Project symlinks are file: routes back to ai-resources canonical; safe to delete because the canonical was renamed.)

### Stage A acceptance criteria
- `ai-resources/.claude/commands/placement.md` exists with the renamed contents.
- `ai-resources/.claude/commands/route-change.md` does not exist.
- Workspace `CLAUDE.md` § Placement Discipline references `/placement` (zero occurrences of `/route-change`).
- No dangling `route-change.md` symlinks in `projects/*/.claude/commands/`.
- `grep -rn "route-change" --include="*.md"` returns zero hits outside archived session-notes.

---

## Stage B — Placement Verifier Procedure

### Goal
Close the gap System Owner identified: today `/placement` returns a chat recommendation, then the canonical pipelines write files without checking that the written path matches the recommended canonical home. Verifier confirms placement at two points inside each pipeline.

### Design

**Where the logic lives.** A new file `ai-resources/docs/placement-verifier.md` — a *procedure* (not a SKILL.md; not an agent). Procedure-shaped because (a) it's a constraint check, not a workflow; (b) keeps it out of the always-loaded surface; (c) deferring SKILL.md extraction matches operator decision to defer SO item #2. The verifier file is referenced from each pipeline's relevant step; pipelines load it on demand.

**What the verifier does.** Given a planned or written file path and an artifact-type label:
1. Look up the artifact type's "Canonical home" in `docs/repo-architecture.md § Canonical homes by artifact type` (the table at line 91).
2. Check whether the path matches the canonical-home pattern.
3. Account for the documented project-local exceptions (repo-architecture.md lines 114–118):
   - Pipeline-stage commands tightly coupled to one project's workflow.
   - Project evaluator agents.
   - Project-specific commands not intended for reuse.
   - Files listed in the project's `.claude/shared-manifest.json` under `commands.local` / `agents.local`.
4. Return one of: `MATCH` / `MISMATCH` / `MATCH-WITH-EXCEPTION` (with the exception named).

**Two firing points per pipeline (the "two-gate" pattern, mirrors `/risk-check`):**
- **Plan-time verifier:** runs immediately after the pipeline has decided what file(s) it will create and BEFORE the first `Write`. If `MISMATCH`, halt and ask operator to confirm placement or redirect.
- **End-time verifier:** runs at the end of the pipeline (before commit-prompt), confirming the actual written paths match what was planned and still satisfy the canonical-home check. If `MISMATCH` at this stage, surface a loud chat block and append an entry to `ai-resources/logs/friction-log.md` (the upgrade-signal log named in workspace `CLAUDE.md` § Placement Discipline line 48).

### Pipelines to integrate

Five canonical pipelines write artifacts that have documented canonical homes:

| Pipeline | LOC | Integration point | Notes |
|---|---|---|---|
| `/create-skill` | 132 | After Step 3 (path declaration) + before final commit | Skills always land in `skills/<name>/`; canonical home is the simplest case. |
| `/improve-skill` | 158 | Before any new file write (skill improvement often adds reference docs); end of skill | Most edits stay inside the existing skill folder; verifier mostly passes through. |
| `/migrate-skill` | 119 | After target-path decided + end of migration | Migrating from Chat — canonical destination is `skills/<name>/`. Same simplicity as `/create-skill`. |
| `/graduate-resource` | 96 | After graduation-target chosen + end of graduation | Graduation is precisely a placement decision; verifier is highest-leverage here. |
| `/new-project` | 666 | After Stage 3b (architecture design) + end of Stage 5 (verification) | Largest surface; the verifier integrates into the existing Stage 5 verification step rather than as a new step. |

Per pipeline, the integration is small: one paragraph referencing `docs/placement-verifier.md` at the plan-time firing point, and one paragraph at the end-time firing point. No rewrites of pipeline logic.

### Stage B acceptance criteria
- `ai-resources/docs/placement-verifier.md` exists with the procedure body.
- Each of the five pipelines references the verifier at the two firing points described.
- `grep -rn "placement-verifier" ai-resources/.claude/commands/ | wc -l` returns ≥ 10 (5 pipelines × 2 firing points).
- A dry-run test: invoke `/create-skill` on a synthetic skill brief and confirm the plan-time verifier fires and reports `MATCH`. (Operator-run, not part of plan execution.)

---

## Deliberately out of scope (deferred to improvement-log)

Per operator's "ship #1, defer rest":

- **SO #2** — Extract Q1–Q8 placement logic into a shared SKILL.md. Reason for deferral: requires deeper redesign than the verifier; verifier closes the immediate leak first.
- **SO #3** — Architecture-gap loop: route `/placement` Step 14 gap reports into `maintenance-observations.md` for Friday review. Reason: low-leverage on its own; pairs better with #2.
- **SO #4** — Track `/placement` skip-rate in gate-calibration. Reason: needs invocation-counting infrastructure not yet in place.
- **SO #5** — Tighten Placement Discipline trigger to a constraint-on-Write checklist. Reason: cosmetic vs. verifier's structural fix; can be done in any future workspace `CLAUDE.md` cleanup pass.

**Anti-patterns rejected** (per SO advisory):
- ❌ No `PreToolUse` hook auto-firing `/placement` on every Write.
- ❌ No promotion of `/placement` from advisory to confirmation gate.
- ❌ No embedding `/placement` invocation as Step 0 of `/create-skill`.

These are recorded here so the rejection rationale survives — a future audit should not reintroduce them.

---

## Execution sequence

1. Plan-time `/risk-check` on this plan. (Required before execution per audit-discipline.)
2. Apply Stage A.
3. Apply Stage B.
4. End-time `/risk-check` on the executed change set.
5. Commit per `## Commit Rules` (single-step commit, no pre-commit `git status` / `git diff`).
6. Operator pushes manually if approved.
7. Log SO items #2–#5 to `ai-resources/logs/improvement-log.md` as deferred backlog with cost/value framing.

## Estimated effort

- Stage A: ~10 minutes (mechanical rename + symlink cleanup).
- Stage B: ~40 minutes (write verifier procedure + edit 5 pipelines).
- Risk-checks + commit + improvement-log: ~15 minutes.
- **Total:** ~65 minutes of focused work.

## Estimated risk

- Stage A: low. Rename is mechanical; the dangling-symlink mitigation handles the auto-sync side effect.
- Stage B: medium. Touching five canonical pipelines is high blast-radius. Mitigation: integration points are append-only (new paragraphs referencing the verifier procedure), no rewrites of existing pipeline logic. Each pipeline can be reverted independently if a downstream regression appears.

## Reversibility

- Stage A: trivially reversible (rename back; restore workspace CLAUDE.md lines).
- Stage B: reversible per-pipeline (revert the inserted paragraphs; `docs/placement-verifier.md` can be deleted standalone).
