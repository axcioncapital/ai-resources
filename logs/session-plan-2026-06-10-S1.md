# Session Plan — 2026-06-10 S1

## Intent
Build **Fix 1** of the concurrent-session isolation fix-plan: make a second Claude Code session in the **same checkout** a hard stop at session start (within the SessionStart hook's mechanism limits), closing Failure A "at the door," while leaving valid cross-project concurrency untouched. Source: `audits/2026-06-09-concurrent-session-isolation-fix-plan.md` § Fix 1 (build-order step 2; Fix 2 shipped in S5).

## Model
**opus** — match (session is on `claude-opus-4-8[1m]`). This is a *deciding* task: the central question (how strongly a SessionStart hook can "block," given the zero-permission-prompt / bypassPermissions floor) is a design decision, not a mechanical edit.

## Source Material
- `audits/2026-06-09-concurrent-session-isolation-fix-plan.md` § Fix 1 — the spec: upgrade the same-checkout path from soft nudge → blocking decision; keep machine-wide-only warning soft; tighten the own-wrapped-session false-fire.
- `.claude/hooks/detect-concurrent-session.sh` — the target hook (read; currently non-blocking by contract, every path `exit 0`; same-checkout SHARP nudge at lines 97–100).
- `.claude/settings.json` SessionStart array — current wiring (friday-checkup-reminder + detect-concurrent-session, both timeout 5).
- `.claude/hooks/check-foreign-staging.sh` (S5 / Fix 2) — precedent for "block via exit-2-to-model, not a permissionDecision prompt," consistent with the zero-prompt floor.
- `docs/session-marker.md` — two-end contract registry; the hook is registered here (must stay in sync).
- `docs/parallel-sessions-playbook.md` § 4 — the manual playbook Fix 1 automates; link back, do not restate.

## Findings / Items to Address
1. **The hook is non-blocking by deliberate contract.** Header lines 48–51: "non-blocking. Every path ends in `exit 0`." The same-checkout case (lines 97–100) already emits a SHARP nudge but still `exit 0`s via `emit()`. Fix 1 changes this contract for *one* path only.
2. **SessionStart cannot hard-block like PreToolUse.** A SessionStart hook runs as the session is already starting; it has no `permissionDecision: deny`. The realistic "block" is the strongest *forceful stop instruction* — agent-facing (so the agent halts and refuses to proceed with `/prime`/work) + operator-facing (systemMessage) — analogous to Fix 2's exit-2-to-model, adapted to SessionStart's output channel. **This mechanism fact must be verified authoritatively before implementing** (claude-code-guide) — it determines whether Fix 1 is buildable as a "block" or must be re-scoped to "maximally forceful nudge + agent-halt instruction."
3. **False-fire heuristic (the load-bearing tightening).** Lines 41–46 + 97–100: a prior *wrapped* session also leaves a today-marker, so the SHARP path fires even when this is the only live session here. Before a path is made forceful, it MUST distinguish "live other session in this checkout" from "my own earlier wrapped session today." Candidate signals: the S5 per-session identity-oracle marker files (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`) — count distinct today-dated id-markers; or compare live `pgrep` session count against the number of distinct today id-markers. Must degrade safe (a missed tighten → occasional over-fire, never a wrong block of a solo relaunch that prevents legitimate work).
4. **Zero-permission-prompt floor is non-negotiable.** Whatever "block" mechanism is chosen must NOT introduce a permission prompt or contest `bypassPermissions` (operator floor; memory `feedback_zero_permission_prompts`). Exit-2-to-model / forceful additionalContext is the only compatible shape.
5. **Two-end contract sync.** `docs/session-marker.md` registers this hook's non-blocking contract; if the contract changes for the same-checkout path, that doc must be updated in the same commit.

## Execution Sequence
1. **Verify the SessionStart mechanism authoritatively** — spawn a `claude-code-guide` agent: what can a SessionStart hook do to halt/deter a starting session (exit-code semantics, `additionalContext`, `systemMessage`, any deny path)? Resolve Finding #2 before writing any code.
2. **Design the same-checkout block path** from the verified mechanism: forceful stop message (agent-halt + operator nudge to `/new-worktree-session`), keeping the machine-wide-only path soft and unchanged.
3. **Design + implement the false-fire tightening** (Finding #3) using the per-session id-marker oracle, so the forceful path fires only on a genuine live-other-session same-checkout condition. Degrade-safe fallback when the oracle is unavailable.
4. **Edit `detect-concurrent-session.sh`** — add the tightened detection + the forceful same-checkout path; preserve the OP-3 loud-skip guard and the soft machine-wide path.
5. **Update `docs/session-marker.md`** (two-end contract) and add a one-line link from/to `docs/parallel-sessions-playbook.md` § 4. Settings.json wiring only changes if the timeout/registration needs it (likely unchanged).
6. **Plan-time `/risk-check`** (Autonomy Rule #9 — hook edit + SessionStart behavior change). System-owner second opinion if blast radius is High.
7. **Dry-run test** the detection logic in isolated temp conditions (own-wrapped vs live-other vs solo-relaunch vs cross-project) before relying on it.
8. **`/qc-pass`** on the edited hook + docs; resolve to GO.
9. **Commit** (`update: detect-concurrent-session.sh — Fix 1 ...`). Push deferred to wrap.

## Scope Alternatives
- **Full (planned):** forceful same-checkout block + false-fire tightening + doc sync. Recommended.
- **Lean subset:** false-fire tightening only (Finding #3), leaving the message soft — lower risk, but does NOT deliver Fix 1's "block at the door" guarantee; would leave Failure A only partially closed. Offer only if risk-check flags the block mechanism as unsafe/unsound.
- **Re-scope (fallback):** if claude-code-guide confirms SessionStart genuinely cannot deliver a meaningful agent-halt, Fix 1 becomes "maximally forceful nudge + tightened heuristic" and the mandate's "block" wording is amended — surfaced to operator before proceeding (mandate `Stop if`).

## Autonomy Posture
**Gated** — structural change class (hook edit + SessionStart behavior change). Plan-time `/risk-check` is mandatory (already disclosed at the auto-mode approval gate). Within the gate, full autonomy on implementation.

## Risk
- **Blast radius:** the hook fires at *every* SessionStart in this repo. A too-aggressive forceful path that false-fires on a solo relaunch would obstruct legitimate work every session — this is why Finding #3 (false-fire tightening) is a hard prerequisite, not an enhancement.
- **Mechanism risk:** "block" may be unachievable at SessionStart; mitigated by Step 1 (verify first) and the re-scope fallback.
- **Floor risk:** must not introduce a permission prompt; mitigated by reusing Fix 2's exit-2-to-model shape.
- **Reversibility:** high — single hook file + two docs; revert is one commit. No shared-state migration.
