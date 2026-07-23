# Session Plan — 2026-07-23

## Intent
Build Commit 2 of 2 of the `/new-project` direct-route feature — the session-harness lean posture for `direct` projects, so bounded document work does not accumulate committed session-plan files, run-manifest stubs, and full mandate schemas.

## Model
opus — match (active: Opus 4.8 1M). Deciding-dominant: a route-branch design across four shared harness commands with high blast radius (24 consumers, 23 auto-propagating symlinks).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scratchpads/2026-07-23-11-58-scratchpad.md` — the Commit-2 spec + all Codex-ratified decisions (the plan is NOT on disk elsewhere; it lives here)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md` — the `## Direct Route` section + the exact route predicate Commit 2 must mirror
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/control-pack-schema.md` — §7(d), the `execution_route` field contract
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes / risk-check gate
- Edit targets: `.claude/commands/prime.md`, `.claude/commands/session-start.md`, `.claude/commands/session-plan.md`, `.claude/commands/wrap-session.md`

## Findings / Items to Address
1. **Route predicate (scratchpad §Route predicate, `new-project.md` `## Direct Route`).** Each session command reads the project `CLAUDE.md`; lean behavior activates ONLY on the exact literal `**Execution route:** direct`. `engineered` / absent / malformed / wrong-case (`Direct`) → today's full behavior (fail-safe). Commit 1 already writes that line into a direct project's `CLAUDE.md`, so the read signal exists.
2. **`prime.md` (scratchpad §Files, branches 8a/8b/8c).** For a direct project, the `/session-start`→`/session-plan` chain and 8c's run-manifest start-stub (8c.7.5) must NOT write `logs/session-plan-*.md` or `logs/runs/*.json`, and must not emit the full mandate schema. Gitignored markers (Step 8k) MAY still be allocated — do NOT redesign the allocator (out of scope).
3. **`session-start.md` (scratchpad §Files).** Direct: skip the run-manifest start-stub (Step 3.5) and the full mandate schema block.
4. **`session-plan.md` (scratchpad §Files).** Direct: do NOT write the committed `logs/session-plan-*.md`; planning stays in-conversation.
5. **`wrap-session.md` (scratchpad §Files).** Direct: no run-manifest close (Step 12d), no findings-disposition ceremony (Step 12e) unless a review actually produced findings; wrap = commit + summarize + ask about push.
6. **De-risk basis (scratchpad §Why lower-risk, `wrap-session.md:245`).** The harness already treats an absent run-manifest/marker as a routine, supported state — lean = exercising an already-supported path, not a rewrite.

## Execution Sequence
1. **`/risk-check` FIRST** (scratchpad §Resume With step 1) — structural, high-blast-radius, mission-adjacent to `repo-health-backlog-2026-07`'s marker/run-manifest threads. Verify: verdict returned. **On GO → step 2. On RECONSIDER/NO-GO → record the design on disk, build nothing, STOP** (the repo's honored pattern — do not override).
2. Re-read each target command's relevant section against the live file before editing (mission standing rule: re-derive citations; the scratchpad's line references are from the base commit). Verify: each edit point confirmed present.
3. Edit `prime.md` (8a/8b/8c), `session-start.md`, `session-plan.md`, `wrap-session.md` per findings 2–5, fail-safe to current behavior on any non-`direct` route. Verify: each file carries the branch on disk (read-back).
4. Test: the direct predicate rejects `engineered`/absent/malformed/`Direct`; a direct session produces NO committed session-plan/run-manifest by default; engineered path unchanged. Verify by execution, not code-read.
5. Independent `/qc-pass` before commit. Verify: PASS.
6. Commit as "commit 2 of 2". Push batched to wrap (both commits: ai-resources `194a8bd`+commit 2, project-planning `a73da63`).

## Scope Alternatives
Single scope — no alternatives. The Commit-2 spec is fixed and Codex-ratified across three review rounds; the only branch is the `/risk-check` verdict (GO → build; RECONSIDER → record-and-stop).

## Autonomy Posture
Gated.

**Stop points:**
- `/risk-check` verdict — RECONSIDER/NO-GO halts the build (record design, stop); this is the mandate's stated stop condition.
- `/qc-pass` before commit — a FAIL halts the commit.
- Blindspot-scan waived by operator for this build (recorded in the handoff scratchpad §Operator Directives) — noted, not re-fired.

## Risk
Structural change class — shared automation with cross-session shared-state effects (session-plan / run-manifest writes) across four harness commands, reordering operations against shared state. The Step 6 tripwire applies: the "existing-command refactor" framing does NOT exempt it. Run `/risk-check` after this plan (plan-time gate) — it is execution step 1 — and again is not needed pre-commit if plan-time covered it with mitigations applied and drift bounded (per the end-time risk-check skip rule). Non-executable edits (command markdown), so no launch/runtime-environment-fit concern.
