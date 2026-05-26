# Sonnet 200k Session Efficiency — Diagnostic Report

**Date:** 2026-05-25
**Scope:** Full workspace (ai-resources + workspace root + active projects)
**Source:** ChatGPT advisory on Sonnet 200k discipline patterns (10 recommendations)
**Method:** Three parallel Explore agents (session lifecycle, subagent contracts, work-unit / discovery / disk-as-memory) + system-owner consult

---

## Context

ChatGPT produced a 10-point recommendation set on how to use Sonnet 200k more efficiently — treating it as a disciplined executor working from compact file-based control surfaces rather than a persistent large-context system. The recommendations focus on: small active surface, work-unit decomposition, tight mandate files, expensive subagents, disk-as-memory, named compaction checkpoints, discovery-first reads, and Opus reserved for judgment.

This diagnostic maps each recommendation against the current ai-resources infrastructure to determine which are already covered, which represent genuine gaps, and which conflict with documented workspace principles.

---

## Recommendation-by-recommendation findings

### #1 — Session carries only objective + work unit + sources + AC + status

**Status:** Substantially covered.
**Evidence:** `session-start` skill captures `work_scope`, `exit_condition`, `files_in_scope`, `out_of_scope`, `stop_if`; `session-plan` writes intent + phase plan to `logs/session-plan.md`; logs externalize history.
**Gap:** None material. No "active work unit" state field, but it is implicit in Next Steps or scratchpad.

### #2 — Bounded work units with explicit stop conditions

**Status:** Partial — covered in harness sessions only.
**Evidence:** Harness state machine (`pending → in_progress → verified → qc_passed → committed`); `harness/prep/work-unit-checklist.md` enforces before/after-commit verification.
**Gap:** Ad-hoc sessions (using `/prime` + `/session-plan`) have no prescribed work-unit stops. `stop_if` field in session-start exists but is optional and rarely populated.

### #3 — Tight mandate file (objective, allowed inputs, do-not-load list, required outputs, AC, stop condition)

**Status:** Partial — template exists but is not auto-generated outside harness.
**Evidence:** `harness/prep/session-mandate-template.md` defines 5 of the 6 fields; `session-start` captures 4 of them.
**Gap:** `allowed_inputs`, `required_outputs` not captured by `session-start`. **The "do-not-load list" is the speculative item** — no evidence of harm today, and it conflicts with full-autonomy default (workspace CLAUDE.md § Autonomy Rules).

### #4 — Subagents only for independent judgment

**Status:** Already covered.
**Evidence:** `ai-resources/CLAUDE.md` § Subagent Contracts mandates this. All observed subagents perform judgment or bounded analysis (token-audit, repo-dd, qc-pass, refinement-pass, friday-checkup). No routine-execution subagents observed.
**Gap:** None.

### #5 — Force agents to return small outputs

**Status:** Substantially covered, one named exception.
**Evidence:** 30-line cap mandated repo-wide; token-audit (≤20 / ≤30), refinement-reviewer (≤7 findings), findings-extractor (≤30) all enforce caps in agent bodies.
**Gap:** `qc-reviewer` has no explicit output cap. Returns inline. Opus-only mitigation is partial.

### #6 — Use disk as the real memory layer

**Status:** Strong for logs; partial for main-session working notes.
**Evidence:** `logs/session-notes.md`, `logs/decisions.md`, `logs/friction-log.md`, `logs/usage-log.md`, `logs/improvement-log.md` all maintained per-session. Subagent findings consistently written to `audits/working/`.
**Gap:** Main-session partial state is not auto-externalized — relies on optional `/handoff` scratchpad (gitignored). **However:** the system-owner advisory flags continuous externalization of working notes as speculative — no confirmed harm under current architecture.

### #7 — Compact intentionally at named checkpoints

**Status:** Principle exists; checkpoints not named.
**Evidence:** `ai-resources/docs/compaction-protocol.md` requires "write before compacting" and prefers `/clear` + restart over `/compact`.
**Gap:** No named checkpoints (e.g., post-inspection, post-implementation, post-QC, pre-closeout). No schema for checkpoint metadata. **Lowest-cost, highest-leverage gap in the bundle.**

### #8 — Discover before loading

**Status:** Ad-hoc per command; no workspace-wide rule.
**Evidence:** `/deploy-workflow`, `/cleanup-worktree`, `/audit-critical-resources` all define their own discovery step. `supplementary-research-qc` does input validation first.
**Gap:** No global "find/grep before read" rule. **However:** the system-owner advisory flags that a CLAUDE.md-level rule would tension against the documented read-scope floor ("expand when a downstream claim depends on content past the read window"). Right shape: load-on-demand reference doc, not a turn-level rule.

### #9 — Opus for judgment gates only; 90–95% Sonnet

**Status:** Direct conflict with workspace policy.
**Evidence:** Workspace CLAUDE.md § Model Tier prohibits model-default declarations anywhere. Operator memory `feedback_no_model_in_settings_json.md` confirms this is non-negotiable. Per-component frontmatter (`model: opus` / `model: sonnet`) is the only permitted mechanism.
**Gap:** None — the workspace addresses the same concern via per-task tier declaration (principles.md § QS-5: "Is the hard part deciding what should be done → Opus, or doing what has already been decided → Sonnet?"). A 90/10 ratio is downstream of that judgment, not a substitute for it.

### #10 — Mental model framing (Sonnet=executor, Opus=reviewer, Files=memory, Mandate=control, Subagents=specialists, Closeouts=handoff)

**Status:** Substantially encoded as principles.
**Evidence:** principles.md § QS-5 (Sonnet vs Opus), § OP-4 (logs as memory), Subagent Contracts (specialists), session-plan + session-start (mandate as control).
**Gap:** The "Closeouts = handoff" framing is downstream of #7 (compaction checkpoints) and should be evaluated through that, not as standalone framing.

---

## Three conflicts named (system-owner advisory)

1. **#9 vs. workspace CLAUDE.md § Model Tier + operator memory `feedback_no_model_in_settings_json.md`.** The bundle asks for a 90/10 Sonnet/Opus posture; the workspace prohibits any model-default declaration. The principle-level rule (QS-5) addresses the same concern correctly.

2. **#3's "do-not-load list" vs. principles.md § OP-2 (full autonomy default) + § AP-7 (speculative abstraction).** Defensive scaffolding for a problem that has not fired in the audit.

3. **#6's "externalize main-session working state continuously" vs. § DR-7 (no abstraction without second consumer).** Handoff scratchpad + subagent notes already serve this need; a third continuous-write surface lacks a confirmed second consumer.

---

## Two routing corrections (system-owner advisory)

1. **Discovery-first rule** does not belong in workspace CLAUDE.md. Workspace CLAUDE.md is for cross-session turn-level rules; methodology belongs in `ai-resources/docs/` as a load-on-demand reference.

2. **Closeout report template** should not be promoted from `harness/prep/` into a workspace command. The harness/Claude-Code boundary is governed separately (system-doc.md § 1.1). A closeout decision belongs in `ai-resources/docs/` or as a `wrap-session` option, not as a harness-prep promotion.

---

## Net diagnostic summary

The bundle's core insight is correct and largely already encoded. Of the 10 recommendations:

| Disposition | Count | Recommendations |
|---|---|---|
| Already covered (no action) | 3 | #1, #4, #10 |
| Already covered for logs; reject the speculative extension | 1 | #6 |
| Adopt as hardening | 3 | #5, #7, partial #2/#3 |
| Reshape before adopting | 1 | #8 |
| Reject (direct conflict) | 1 | #9 |
| Speculative — defer pending evidence | 1 | #3 "do-not-load list" portion |

**Genuine gaps (the work this implementation plan addresses):**
1. `compaction-protocol.md` has no named checkpoints (#7) — documentation-only edit, zero risk.
2. `qc-reviewer` has no output cap (#5) — single canonical-agent edit, risk-check required.
3. `session-start` does not capture `allowed_inputs` and `required_outputs` mandate fields (#2 + reshaped #3) — workspace skill edit.
4. Discovery-first is not documented as a reusable pattern (#8) — defer until second consumer confirmed (DR-7).

Implementation plan: `ai-resources/plans/sonnet-200k-efficiency-implementation.md`.

---

## Files referenced

- `ai-resources/CLAUDE.md` § Subagent Contracts
- `ai-resources/docs/compaction-protocol.md`
- `ai-resources/docs/repo-architecture.md`
- `ai-resources/.claude/commands/session-start.md` (via Explore agent)
- `ai-resources/.claude/commands/session-plan.md` (via Explore agent)
- `ai-resources/skills/handoff/SKILL.md` (via Explore agent)
- `ai-resources/.claude/commands/wrap-session.md` (via Explore agent)
- `ai-resources/.claude/agents/qc-reviewer.md` (via Explore agent)
- `ai-resources/.claude/references/harness-rules.md` (via Explore agent)
- `harness/prep/session-mandate-template.md` (via Explore agent)
- `harness/prep/session-report-template.md` (via Explore agent)
- Workspace CLAUDE.md § Model Tier, § Autonomy Rules
- System owner advisory (Function B — pre-change advisory, 2026-05-25)
