# Session Plan — 2026-05-29 — S5

## Intent

Run 4 picked menu items from `/prime` auto-mode in order: (1) FL-1+FL-6 friction-log hook unification + docs convention; (2) C-1+C-2 consult/system-owner agent edits (canonical agent body + project-local copy); (3) improvement-log archive sweep; (4) intake of two inbox briefs via `/create-skill`. All four items sequenced under one combined approval gate (`/prime` Step 8c.6 — confirmed `go`).

## Model

Active: claude-opus-4-7[1m] — match. Recommended for the session: opus (multi-item with structural Item 1 hook edit + structural Item 3 canonical agent edit; both pipelines call for /risk-check; Item 5's /create-skill runs its own internal gates). No /model switch needed.

## Source Material

- **Item 1 (FL-1 + FL-6):** `audits/pipeline-reviews/friction-log-2026-05-29.md` (the cycle-2 memo defining the unification spec and the docs-convention scope).
- **Item 3 (C-1 + C-2):** `audits/pipeline-reviews/consult-2026-05-29.md` (the cycle-2 memo defining the ≤30-line summary + on-disk advisory contract and the project-local-copy drift fix).
- **Item 4:** `logs/improvement-log.md` (active entries) + `logs/improvement-log-archive.md` (archive destination). Apply `/resolve-improvement-log` skill rules.
- **Item 5:** `inbox/context-engine-brief.md` + `inbox/context-engine-session-pairing.md` (the two new briefs).
- **Cross-cutting:** `docs/audit-discipline.md` § Risk-check change classes (defines what triggers plan-time /risk-check); `ai-resources/CLAUDE.md § Subagent Contracts` (the ≤30-line cap C-1 enforces); `principles.md § OP-3` (loud over silent, FL-1 grounding); `risk-topology.md § 3` (hook-edit + canonical-agent-edit blast radius).
- **Live writers (FL-1):** `.claude/hooks/friction-log-auto.sh` lines 41-46; `.claude/commands/friction-log.md` Step 2; `.claude/commands/note.md` Step A.2 (including the false byte-identical claim at note.md:16).
- **Live writers (C-1, C-2):** `.claude/commands/consult.md` Step 4 brief; `.claude/agents/system-owner.md` Phase 5 Function A/B; `projects/axcion-ai-system-owner/.claude/agents/system-owner.md` (project-local copy).

## Findings / Items to Address

### Item 1 — FL-1 + FL-6 (friction-log hook unification + docs convention)

- **FL-1.A — Three-writer contract drift.** The hook at `friction-log-auto.sh:41–46` emits `### Session: $NOW — Trigger: /$SKILL_NAME` (three-hash, colon). Both commands emit `## Session — {YYYY-MM-DD HH:MM}` (two-hash, em-dash). The contract assertion in `note.md:16` ("byte-identical to what `/friction-log` writes") is false on the literal-string read; only the second-level invariant (detection keys on `### Friction Events`) holds it together. The moment any consumer (e.g., `/friday-checkup` Step 313, `/open-items` line 35) keys on the session-header pattern, hook-written entries become invisible.
- **FL-1.B — Unification fix.** Rewrite the hook so the appended block matches `## Session — {YYYY-MM-DD HH:MM}` + `### Friction Events` + `#### Write Activity` exactly. Preserve trigger info as a body line only if it earns its keep.
- **FL-1.C — Downstream verification.** Update `friction-log.md` Step 2 and `note.md` Step A.2 as needed; correct the false byte-identical claim in `note.md:16`.
- **FL-6 — Frontmatter convention.** Only `cleanup-worktree.md` declares `friction-log: true`; the hook is silently dormant for every other command. Document the flag in `docs/session-guardrails.md` (or a new short doc) so future command authors know it exists and what it triggers.
- **Structural class:** hook edit + cross-cutting two-end contract repair. `/risk-check` plan-time AND end-time required per `risk-topology.md § 3`.

### Item 3 — C-1 + C-2 (consult return-size cap + project-local agent symlink fix)

- **C-1.A — Sub-30-line summary + on-disk advisory.** Extend `system-owner` agent Phase 5 Function A (general consultation) and Function B (pre-change advisory) to write the full advisory to `output/consultations/consult-{DATE}-{slug}.md` and return a ≤30-line structured summary to the main session. Function A's "free-form structured answer, target under 60 lines" can sometimes converge below the cap, in which case the on-disk write is skipped; only the return-summary contract is mandatory. Update `consult.md` Step 4 brief to mandate the sub-30-line return contract.
- **C-1.B — Friction-log signal.** This drip has been logged for 5+ consecutive sessions (`logs/usage-log.md` lines 159, 162, 171, 232, 261, 282, 292). Per `principles.md § AP-11`, the proper response is to pause content work, fix the drafter, resume — this session is that fix.
- **C-2 — Project-local copy drift.** `projects/axcion-ai-system-owner/.claude/agents/system-owner.md` differs from canonical at two lines: the project-local copy ends `description:` with "Project-local to projects/axcion-ai-system-owner/ at v1." and the agent body opens with "You are project-local to `projects/axcion-ai-system-owner/` at v1." — both factually wrong as of 2026-05-29. Cleanest fix: delete the project-local copy and replace with a symlink to canonical (matches `DR-1` and the workspace-root pattern). Alternative: update both stale sentences in place.
- **C-1 + C-2 sequencing:** apply C-1 first (canonical agent body), then C-2 (project-local symlink swap) so the symlink targets the updated canonical.
- **Structural class:** canonical agent edit (six-consumer shared agent per consult memo § Cross-resource #2) + symlink swap. `/risk-check` plan-time required per `audit-discipline.md` § Risk-check change classes.
- **QC after edits:** /qc-pass against the unchanged consumer commands (`/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`) to confirm no contract regression.

### Item 4 — Improvement-log archive sweep

- **Current active count:** ~16 entries; soft cap is 7 (per the recurring soft-cap rule).
- **Archive criteria:** `Status: applied + Verified` entries are eligible. `logged (pending)` and `applied (unverified)` stay active.
- **Archive destination:** `logs/improvement-log-archive.md` (yesterday's Item 3 companion commit `97f4ddf` landed pre-existing auto-archive additions; archive file is well-shaped).
- **No /risk-check needed.** Log content move only.

### Item 5 — Inbox brief intake (/create-skill)

- **Brief 1:** `inbox/context-engine-brief.md` — read first to understand scope.
- **Brief 2:** `inbox/context-engine-session-pairing.md` — read first to understand scope.
- **Pipeline:** `/create-skill` per `skills/ai-resource-builder/SKILL.md`. The pipeline runs its own internal gates (Step 3 design review, Step 7 QC). No separate session-level /risk-check needed for the new-skill structural class because the pipeline IS the sanctioned gating mechanism.
- **Post-skill move:** both briefs go to `inbox/archive/` after their corresponding skill directories land.
- **Possible scope branch:** if the two briefs describe one skill or a skill + a pairing-rule, route accordingly (one skill vs. two).

## Execution Sequence

### Stage 1 — Item 1 (FL-1 + FL-6) plan-time /risk-check
Run `/risk-check` on the FL-1+FL-6 hook+command edits. Five dimensions per the canonical reviewer. On GO → Stage 2. On RECONSIDER → revise plan inline + re-check. On NO-GO → pause auto mode, retain mandate + plan on disk.

### Stage 2 — Item 1 execution
- Edit `.claude/hooks/friction-log-auto.sh` lines 41-46: emit canonical `## Session — {date}` block.
- Verify `friction-log.md` Step 2 unchanged or aligned.
- Edit `note.md:16` false byte-identical claim.
- Edit `note.md` Step A.2 if needed for consistency.
- FL-6: add `friction-log: true` frontmatter documentation to `docs/session-guardrails.md` (or new short doc).
- `/qc-pass` against the hook + both commands to verify the three-writer contract is unified.
- End-time `/risk-check` per FL-1 memo (hook-edit class).
- Commit (one atomic commit for FL-1 + FL-6).

### Stage 3 — Item 3 (C-1 + C-2) plan-time /risk-check
Run `/risk-check` on the canonical `system-owner` agent edit + project-local symlink swap. Five dimensions. On GO → Stage 4. On RECONSIDER → revise plan inline + re-check. On NO-GO → pause auto mode, retain mandate + plan on disk; Items 4 and 5 remain executable independently.

### Stage 4 — Item 3 execution
- Apply C-1: edit `.claude/agents/system-owner.md` Phase 5 Function A and Function B for sub-30-line summary + on-disk write; edit `consult.md` Step 4 brief to mandate the return contract.
- Apply C-2: replace project-local copy with symlink to canonical.
- `/qc-pass` against the five unchanged consumer commands (`/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`).
- Commit (one atomic commit for C-1 + C-2).

### Stage 5 — Item 4 execution
- Read `logs/improvement-log.md` end-to-end.
- Identify entries eligible for archive (`Status: applied + Verified`).
- Move them to `logs/improvement-log-archive.md` (preserving chronology).
- Confirm active count is back under 7.
- Commit.

### Stage 6 — Item 5 execution
- Read `inbox/context-engine-brief.md` and `inbox/context-engine-session-pairing.md`.
- Determine whether the briefs describe one or two skills.
- Invoke `/create-skill` per brief.
- After each skill lands, move the source brief to `inbox/archive/`.
- Commits per `/create-skill` Step 9 (one commit per skill).

### Stage 7 — Session wrap
After all four items close, output the completion banner per `/prime` Step 8c.11 and remind the operator to run `/wrap-session`.

## Scope Alternatives

- **Lower-cost alternative — Item 1 only.** If context becomes constrained or /risk-check reveals deeper concerns, Item 1 alone closes the highest-leverage structural fix on the deferred-stack. Items 3, 4, 5 can defer.
- **Mid-cost alternative — Items 1 + 3 only.** Both /risk-check-gated items shipped; defer the log sweep + inbox intake to a separate, simpler session.
- **Higher-cost — full mandate.** All four items; this is the picked default. Risk: late-session context pressure on Item 5 (/create-skill) when ~3-4 hours of execution have already accumulated.
- **Order alternative — items 4 + 5 first.** Risk: lower-priority work absorbs early-session context budget while the structural items still wait. Rejected — sequence kept at 1 → 3 → 4 → 5 per writer-stability rule (Item 3 must follow Item 1).

## Autonomy Posture

**Gated.** Two /risk-check gates (Items 1 and 3). Between gates, full autonomy per workspace `Autonomy Rules` (no operator confirmation between Stages 2-3, 4-5, 5-6). Between-gate summaries emitted at each item boundary per workspace `Between-gate summaries` rule. `/qc-pass` runs inline on substantive artifacts.

## Risk

**Plan-time risks (carried into Stage 1 and Stage 3 /risk-checks):**

- **Item 1 — Hook edit blast radius.** Three writers, one log; the unification must converge on a single canonical shape without breaking any of the three current writers or the four downstream consumers (`/friday-checkup` Step 313, `/open-items` line 35, the two commands themselves). Mitigation: end-time /risk-check verifies post-edit state; `/qc-pass` against all three writers verifies contract unity.
- **Item 3 — Canonical agent edit blast radius.** Six consumers depend on `system-owner` Phase 5 output shape (`/consult`, `/architecture-review`, `/implementation-triage`, `/systems-review`, `/friday-so`, `/so-monthly`). Any change to the return-shape contract ripples through all six. Mitigation: read each consumer command's expected return-shape before editing; /qc-pass against all five non-consult consumers post-edit.
- **Item 5 — New-skill structural class.** /create-skill is the sanctioned pipeline; its internal gates (Step 3 design review, Step 7 QC) are the structural gating mechanism.
- **Session-level risk — late-session context pressure.** Four items + two /risk-checks + per-item /qc-pass + four commits ≈ a long session. Per workspace `Context constraint deferral` rule, if context is clearly constrained mid-execution, defer remaining items + flag in chat — do not rush.
- **TOCTOU foreign-session collision.** Yesterday's session telemetry flagged this as recurring. The TOCTOU Phase 2+3 atomic mitigation shipped on 2026-05-29 covers same-day marker-scoped session writes. This session is S5 — third concurrent same-day session structurally tolerated.

**End-time risks** (verified post-execution by end-time /risk-check on Item 1 + final session wrap):

- **Item 1 end-time gate (mandatory per FL-1 memo).** Verify unified contract holds post-edit; no consumer breaks.
- **Wrap-time risk-check.** Session-wide end-time /risk-check at wrap covers cumulative drift across all four items.
