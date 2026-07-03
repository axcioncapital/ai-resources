# Session Plan — 2026-07-03

## Intent
Kick off the System Owner v2 build: resolve the 12-piece control pack (Reduce Scope, 2026-07-03) into a per-unit plan, execute build stage S0 (B14 vault refresh + baseline capture), wire the R1 redesign-collision mitigation, and verify/close the 2026-06-02 grounding-corpus backlog entry.

## Model
opus — match (session is on Fable 5, at/above the opus tier; per-unit resolution and stage-S0 judgment are deciding-heavy).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/context-pack.md` (the /plan-draft handoff brief — read)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/scope-mvp-charter.md` (scope authority — wins cross-doc conflicts)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/execution-roadmap.md` (session order + gates — read)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/governance-authority.md` (authority model; B4 grant terms)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/technical-design.md` (mechanisms/schemas)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/output/system-owner-v2/control-pack/risk-assumptions-register.md` (R1 dominant risk)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/system-doc.md` (B14 target 1 — status draft, last_updated 2026-04-29)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/blueprint/blueprint.md` (B14 target 2 — **path correction:** lives under `vault/blueprint/`, not `vault/architecture/` as the context pack implies)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md` (backlog part-2 edit target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md` (v1 agent — read this session; edited in S1)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/` (grounding.md, persona.md, toolkit-relationship.md, rebuild-refinement-notes-2026-06-12.md)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/system-owner-rebuild-ground-truth-2026-06-05.md` (ground-truth pack)
- `/Users/patrik.lindeberg/.claude/plans/make-a-plan-for-sequential-squirrel.md` (approved build plan)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (structural change classes)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (2026-06-02 grounding-corpus entry, ~line 206)

## Findings / Items to Address
1. **12-piece build sequenced S0→S4 ("substrate before power")** — this session covers the per-unit plan plus stage S0 only; S1–S4 are later sessions (execution-roadmap.md § Session sequence).
2. **S0 = B14 input hardening** — both vault grounding docs are stale (`status: draft, last_updated: 2026-04-29`, self-admitted drift); refresh both so later sessions ground on accurate docs (context-pack.md § Facts; verified on disk). Path correction: blueprint.md is at `vault/blueprint/blueprint.md`.
3. **Baseline capture before S1** — one-time numeric counts from existing logs (shared-state collision count, /risk-check skip incidents, share of infra changes lacking an explicit plan) so B15's success metrics are falsifiable (execution-roadmap.md § Baseline-capture; risk R3).
4. **R1 mitigation unwired** — `projects/axcion-ai-system-redesign/inputs/` does not exist; create it, place the v2 context pack there, add the Session-F re-reconcile checkpoint note (context-pack.md § Constraints; risk-assumptions-register.md R1).
5. **Backlog 2026-06-02 (grounding-corpus)** — part 1: verify the grounding corpus restored under `references/` (grounding/persona/toolkit-relationship exist; the entry's original list also named principles.md/risk-topology.md/blueprint.md — reconcile against what the June rebuild actually settled on). Part 2: add the pre-consult grounding existence check to consult.md ("grounding missing — proceed degraded or pause?" as explicit operator decision). Then flip the entry status (improvement-log.md ~206).
6. **Open roadmap decisions adopted per recommendation** — S0 spin-out: yes, run first; B3-into-S1: no, keep in S2 (execution-roadmap.md § Open decisions). Rollback-protocol exact shape confirms at S1, not now.
7. **B4 write-scope grant** — gates stage S3; roadmap advises resolving it during S1/S2. Not this session's work; flag at wrap so it lands on the backlog with a trigger.

## Execution Sequence
1. **Read the remaining control docs** (charter, governance-authority, technical-design, risk register) + ground-truth pack + approved plan + refinement notes. *Verify:* the "settled — do not reopen" list is honored; no plan-time detail contradicts the charter.
2. **Plan-time `/risk-check`** on the structural set: consult.md canonical-command edit; cross-repo vault refresh; R1 wiring into a sibling project. *Verify:* GO or PROCEED-WITH-CAUTION with mitigations applied; on RECONSIDER/NO-GO → stop per mandate.
3. **`/blindspot-scan`** (post-plan, pre-implementation gate — structural classes + >3 files). *Verify:* verdict surfaced; PAUSE-AND-FIX findings resolved before edits.
4. **Write the per-unit plan** for the 12 pieces to `projects/project-planning/output/system-owner-v2/per-unit-plan.md` — every piece (B1–B8, B10, B13–B15) mapped to its session, work units, target files, and gate. *Verify:* 12 pieces covered; deferred B9/B11/B12 explicitly absent; sequencing matches the roadmap.
5. **Stage S0 — B14 refresh** of system-doc.md + blueprint.md (three-repo discipline: this touches only the repo-documentation vault). *Verify:* `last_updated` advanced, drift/staleness markers cleared — matches end-to-end test point 7.
6. **Baseline capture** → `projects/axcion-ai-system-owner/output/v2-baseline-2026-07-03.md`. *Verify:* the three named counts present with source-log anchors.
7. **R1 wiring** — create `projects/axcion-ai-system-redesign/inputs/`, copy the v2 context pack in, add the re-reconcile checkpoint note. *Verify:* files exist; redesign project can see them.
8. **Backlog item** — part-1 verification note; part-2 consult.md edit; status flip in improvement-log.md. *Verify:* check fires on missing grounding; entry status reads resolved with date + evidence.
9. **Independent `/qc-pass`** on the edited set (vault docs, consult.md, per-unit plan). *Verify:* GO, or loop `/resolve`.
10. **End-time `/risk-check`** (end-gate; prior-session re-check is trivially satisfied — this is the first build session). *Verify:* GO.
11. **Commit per-repo, pathspec-scoped** (`git commit -- <paths>` — concurrent-session discipline; S4's marker is still live in this checkout). *Verify:* each commit's file list contains only this session's files.

## Scope Alternatives
- **Min:** per-unit plan only (steps 1–4) — defer S0 + baseline + R1 + backlog to a next session. Use if context runs short.
- **Recommended:** all 11 steps — plan + S0 + baseline + R1 wiring + backlog closure. ← default.
- **Max:** additionally pull B3 (mechanical protected-zone detection) forward into this session. Rejected: roadmap default keeps B3 in S2, and S1 hasn't run; would violate "substrate before power."

## Autonomy Posture
Gated — structural change classes touched (canonical command edit, cross-repo writes) but scope bounded to named items.

**Stop points:**
- Any `/risk-check` RECONSIDER / NO-GO on a structural edit → pause and surface (mandate Stop-if).
- Anything requiring the B4 write-scope grant this session → stop and ask (explicit operator decision).
- QC DISAGREE on an editorial call → pause per Autonomy Rule 4.

## Gate outcomes (recorded 2026-07-03, S5)
- **Plan-time /risk-check: PROCEED-WITH-CAUTION** (Hidden coupling High). Report: `audits/risk-checks/2026-07-03-system-owner-v2-build-stage-s0-change-set-plan-time-gate.md`.
- **SO second opinion (appended to report): concur + defer change 5.** The improvement-log status flip is DEFERRED to a dedicated `/resolve-improvement-log` session — its guards (pathspec + own-commit-boundary) are mutually unsatisfiable while two earlier uncommitted flips sit in the same file. Verification evidence for the 2026-06-02 entry is still recorded this session (part 1: corpus verified on disk under references/ + vault, 2026-07-03; part 2: system-owner.md Phase 1.5 REQUIRED-halt + consult.md Step 5a already implement the proposed check, stronger than proposed).
- **Adopted mitigations:** inputs/ per control-pack R1 + one-line exception note in redesign CLAUDE.md + write-once lifecycle README; per-repo pathspec commits; grounding.md line-count co-edit if drifted; independent QC on the grounding docs.
- **/blindspot-scan: PROCEED-WITH-CONSTRAINTS.** (1) `list-critical-resources.md:84` reads `system-doc.md § 4.5` by section anchor — preserve § 4.5 numbering in the refresh or co-edit that line. (2) SO's "W2.1 auto-rewrites blueprint.md" claim not supported by live evidence (doc-scanner-agent.md has no blueprint.md reference; W2.1 is drift-detection) — a manual-refresh header note suffices. (3) grounding.md count co-edit (same as risk-check mitigation).

## Risk
Run `/risk-check` after this plan (plan-time gate) and again before commit (end-time gate). Structural classes: canonical-command edit (consult.md), automation-adjacent shared-state touches (improvement-log status flip while a foreign session marker is live), cross-repo writes into three sibling repos. Not launch/runtime-gated — all artifacts are docs/commands; the environment-fit check does not apply. Concurrent-session note: session S4 is registered live-but-idle in this checkout; footprints verified non-overlapping by /concurrent-session-check (SAFE, advisory) — keep staging and commits pathspec-scoped.
