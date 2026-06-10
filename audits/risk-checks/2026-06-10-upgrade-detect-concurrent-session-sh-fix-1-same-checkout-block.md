# Risk Check — 2026-06-10

## Change

Upgrade .claude/hooks/detect-concurrent-session.sh (a SessionStart hook, currently non-blocking by contract — every path exit 0) so that the same-checkout concurrency condition (≥2 live Claude Code sessions AND a today-dated marker already present in THIS checkout) returns the strongest available SessionStart stop-and-isolate decision — a forceful agent-halt + operator nudge to /new-worktree-session — instead of today's soft SHARP nudge. The machine-wide-only case (another session in an unrelated project, no today-marker here) stays a soft non-blocking warning, unchanged. Also tighten the false-fire heuristic so the forceful path does NOT fire on the operator's own earlier *wrapped* session today (distinguish "live other session in this checkout" from "my own already-wrapped session") — candidate signal: the per-session identity-oracle marker files logs/.session-marker-${CLAUDE_CODE_SESSION_ID} written by /prime. Constraint: must NOT introduce any permission prompt or contest bypassPermissions (operator's zero-permission-prompt floor); the block must use the exit-2-to-model / forceful-additionalContext shape, mirroring the S5 Fix 2 precedent (check-foreign-staging.sh). This is Fix 1 of audits/2026-06-09-concurrent-session-isolation-fix-plan.md (Fix 2 already shipped, commit f5e013c). Files in scope: .claude/hooks/detect-concurrent-session.sh, .claude/settings.json (wiring, likely unchanged), docs/session-marker.md (two-end contract registry), docs/parallel-sessions-playbook.md (link back). Known open design question for the reviewer to weigh: SessionStart hooks cannot hard-block a session the way a PreToolUse hook can, so "block" may be constrained to a maximally forceful stop instruction rather than literal session prevention.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/2026-06-09-concurrent-session-isolation-fix-plan.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The exit-2-to-model / id-oracle-tightened upgrade is permission-safe and reversible, but two High dimensions — Blast Radius (a SessionStart hook that fires every session, plus two un-synced byte-identical project copies that will silently diverge) and Hidden Coupling (SessionStart exit-2 has no documented forceful-additionalContext contract, and the false-fire tightening rests on an id-oracle the hook does not yet read) — require explicit paired mitigations before landing.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/settings.json | invokes (SessionStart array, line 144) | no (wiring unchanged; in-scope as declared) |
| ai-resources/docs/session-marker.md | documents (§ Concurrent-session detection, lines 195–207: "If you change the detection signal … update the hook header comment AND this section") | yes (two-end contract registry must reflect new exit-2 behavior + id-oracle read) |
| ai-resources/docs/parallel-sessions-playbook.md | documents (Related list line 237; §4 anti-pattern names the same-checkout case) | no (link-back only; narrative, no runtime dep) |
| projects/positioning-research/.claude/hooks/detect-concurrent-session.sh | co-edits (byte-identical real-file copy, 6503 B; WIRED in that project's settings.json) | yes (will run STALE soft-nudge logic until re-copied — silent divergence) |
| projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh | co-edits (byte-identical real-file copy, 6503 B; NOT wired in that project's settings.json) | no-but-divergent (inert until wired, but a stale copy nonetheless) |
| ai-resources/.claude/commands/prime.md | imports (writes logs/.session-marker-${CLAUDE_CODE_SESSION_ID} — the candidate signal the tightening depends on; Steps 8a.3.a/8b.3.a/8c.3 per session-marker.md line 141) | no (already writes both files; hook becomes a new *reader* of its output) |

Total: 6 consumers, 2 must-change (session-marker.md registry; positioning-research wired copy).

Notes:
- The auto-sync hook (`auto-sync-shared.sh`, lines 4–6) syncs only `.claude/commands/` and `.claude/agents/` — **not** `.claude/hooks/`. The two project copies are therefore hand-placed and will **not** self-update. Confirmed byte-identical to canonical via `diff` (both report IDENTICAL).
- The id-oracle files (`logs/.session-marker-*`) are the *contract the tightening introduces a new read against*. The hook today reads only the shared `logs/.session-marker` (hook line 91); it does not yet read the per-id oracle. That new read is a new coupling — see Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook is already registered in the SessionStart array (settings.json line 144); the change edits hook body logic, it does not add a new hook or a new always-loaded file. Per-session cost is unchanged — one `pgrep` + one marker read per session start, same as today.
- No content added to any always-loaded CLAUDE.md, no new `@import`, no new subagent. The token cost is the hook's emitted message only; a forceful message is a few hundred bytes more than the soft nudge on the *fire* path, but it fires conditionally, not every session.
- The token-audit already classes this hook as no-cost: "All are lightweight nudge/log hooks … No token-cost concern from hooks themselves; their stdout is small" (audits/token-audit-2026-06-05-ai-resources.md line 219).

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission entries change. settings.json `permissions` block (lines 2–35) is untouched by the described change; the change is confined to the hook body and the SessionStart array already contains this hook.
- The change is explicitly constrained to NOT introduce a permission prompt or contest `bypassPermissions` (CHANGE_DESCRIPTION: "must NOT introduce any permission prompt or contest bypassPermissions … the block must use the exit-2-to-model / forceful-additionalContext shape"). The S5 Fix 2 precedent it mirrors does exactly this — `check-foreign-staging.sh` lines 16–21 document "exit 2 feeds the foreign-file list back to the AGENT (not a permission prompt to the operator — respects the zero-permission-prompt / bypassPermissions floor)."
- `defaultMode: bypassPermissions` (settings.json line 34) means the hook runs without any operator prompt regardless; exit-2 returns context to the model, not a permission gate.

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Step 1.5 inventory: 6 consumers, 2 must-change, plus the structural fact that this hook fires at **every SessionStart in the repo**.

- **This hook runs on every session start** (settings.json SessionStart array, lines 133–149). A forceful agent-halt on a *mis-fire* therefore obstructs legitimate work at the start of every affected session — the highest-frequency surface in the harness. This is the blast-radius core: the cost of a false-fire is paid session-open, before any work, every time the heuristic is wrong.
- **The current heuristic provably mis-fires on a solo relaunch.** Hook lines 39–43 state plainly: "a prior WRAPPED session also leaves a today marker, so the sharp nudge can fire when this is in fact the only live session here." Today that mis-fire is a soft nudge (degrade-safe, hook line 42: "an occasional unnecessary nudge, never a block"). The change converts that exact mis-fire path into a forceful halt — so the false-fire that is *acceptable today* becomes *obstructive* unless the id-oracle tightening fully closes it (see Dimension 5 for why it does not fully close).
- **Two un-synced project copies (co-edit consumers).** `positioning-research/.claude/hooks/detect-concurrent-session.sh` and `research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` are byte-identical real-file copies (6503 B, `diff` IDENTICAL). `auto-sync-shared.sh` does NOT sync hooks (lines 4–6 sync only commands + agents), so editing the canonical hook leaves these two stale. `positioning-research` **wires** the hook in its settings.json (grep hit) — so that project keeps running the OLD soft-nudge logic until manually re-copied. This is a blast-radius consumer not named in CHANGE_DESCRIPTION's "Files in scope" — a surfaced gap.
- **Contract-doc must-change:** session-marker.md §Concurrent-session detection (lines 195–207) explicitly requires "If you change the detection signal … update the hook header comment AND this section." Adding the id-oracle read and the exit-2 behavior is a detection-signal change → registry update is mandatory, not optional.

### Dimension 4: Reversibility
**Risk:** Low

- Single hook-body edit plus two doc edits — a clean `git revert` restores the prior soft-nudge behavior fully within the working tree. No data/log mutation, no append-only-log edit, no settings permission state to unwind.
- The hook writes **no state of its own** by design (session-marker.md line 201: "maintains NO state file of its own"); reverting the hook leaves nothing behind. The id-oracle files it would newly *read* are written by `/prime` independently and are gitignored per-machine state — a revert does not touch them.
- One caveat keeping this from "trivially Low": the two stale project copies (Dimension 3) mean a revert of the canonical file does not automatically restore the project copies if they were also edited — but if the mitigation re-copies them, the revert must re-copy them too. This is a one-step manual consideration, not a multi-step rollback; it stays Low because the canonical revert is clean and the copies are byte-restorable by re-copy.

### Dimension 5: Hidden Coupling
**Risk:** High

- **SessionStart exit-2 has no documented, verified forceful contract.** The S5 precedent (`check-foreign-staging.sh`) is a **PreToolUse(Bash)** hook — exit 2 there blocks the *tool call* and feeds stderr to the model (its lines 44–48). SessionStart is a different event: CHANGE_DESCRIPTION itself flags this as the "Known open design question … SessionStart hooks cannot hard-block a session the way a PreToolUse hook can." The forceful path is therefore an *additionalContext message at session open*, NOT a literal block. Whether exit-2 vs. a forceful `additionalContext` JSON is the load-bearing mechanism at SessionStart is **unverified in this repo** — no existing SessionStart hook uses exit-2 (settings.json SessionStart array holds only `friday-checkup-reminder.sh` and this hook, both non-blocking emit-and-exit-0). Building on an unverified harness contract is the hidden coupling: if SessionStart silently ignores exit-2, the "forceful halt" is theatre — a strongly-worded `systemMessage` the agent may proceed past, no different in effect from today's sharp nudge.
- **The false-fire tightening introduces a new read-coupling the hook does not have today.** The hook currently reads only the shared `logs/.session-marker` (line 91). The tightening requires it to read the per-id oracle `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` to distinguish "my own wrapped session" from "a live foreign session." But the id-oracle answers "did a per-id marker get written for some session today," NOT "is that session still LIVE." A wrapped-today session leaves its per-id marker on disk (pruned only by the next `/prime`, per session-marker.md line 92 "Pruned by /prime … when not dated today"). So the proposed signal does not, on its own, separate live-foreign from wrapped-own — the residual false-fire the plan worries about (fix-plan line 41) is **not fully closed** by the id-oracle read alone. The only live-vs-wrapped signal the hook has is the `pgrep` process count, which is machine-wide and cannot attribute a process to a checkout (hook lines 28–31).
- **Functional overlap with an existing reader contract.** session-marker.md lines 73–75 document a delicate "no-own-marker rule" and "clobber-safe own-marker recovery" governing how *own vs. foreign* attribution is done from markers — explicitly to avoid silent false-negatives. The hook reading per-id markers to judge own-vs-foreign re-enters that exact attribution problem one layer up, without the both-or-neither invariant protection the wrap guard relies on. Two mechanisms now reason about the same own/foreign distinction from the same marker files.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at projects/strategic-os/ai-strategy/principles-base.md (frozen-ID index available).

- **OP-5 (advisory vs enforcement) — tension, not violation.** The change moves the same-checkout path from advisory ("advises and stops," soft nudge) toward enforcement ("detect and act," forceful halt). OP-5 (principles-base line 43) makes enforcement authority "an explicit per-component Phase-2 decision." Here the upgrade IS explicit and recorded — it is Fix 1 of a written fix-plan (fix-plan §3, lines 37–41) whose own framing is "to **block** (not just warn) the two genuinely-dangerous moves" (fix-plan line 33). Because the enforcement intent is loud and recorded (OP-11, principles-base line 49), this is a legitimate per-component enforcement decision, not silent drift — hence Medium tension, not High. The forceful path is also bounded: it fires only on the same-checkout case the playbook already says "has no legitimate use" (fix-plan line 39), so it removes a foot-gun rather than gating valid work.
- **OP-12 (closure before detection) — aligned / serves the principle.** This is not new detection — the detection (same-checkout condition) already exists and already fires the soft nudge. The change strengthens the *closure* arm (forceful halt + `/new-worktree-session` route) of an existing detector. OP-12 (principles-base line 50) counts strengthening closure *for* a candidate. No new finding-generator is added.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not triggered.** The consumer is confirmed and present: the recurring same-checkout collision class (fix-plan §1 Failure A; the S6 collision, playbook §4 line 107). This is not "a hook for Phase 2" — it hardens an existing, exercised path against a documented live failure. The inventory shows real current consumers, not zero.
- **DR-8 (risk-check gate) — honored.** The change is being routed through `/risk-check` as required for hook + SessionStart-behavior changes (fix-plan line 41), which is itself principle-conformant.

## Mitigations

- **Dimension 3 (Blast Radius) — verify the SessionStart fire-frequency cost is bounded:** keep the forceful path gated behind BOTH `pgrep` count ≥2 AND a positive *live-foreign* discriminator (see Dimension 5 mitigation), never on the today-marker-present condition alone. The soft machine-wide path must stay exit-0. This confines the forceful halt to the genuine same-checkout case and keeps the every-session cost at one cheap `pgrep` + marker read.
- **Dimension 3 (Blast Radius) — re-sync the two project copies in the same commit:** after editing the canonical hook, re-copy it to `projects/positioning-research/.claude/hooks/detect-concurrent-session.sh` (WIRED — runs stale forceful logic otherwise) and `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh`. Add this to the change's "Files in scope" — CHANGE_DESCRIPTION omits them. Confirm `diff` IDENTICAL post-edit. (Auto-sync does not cover hooks — verified at auto-sync-shared.sh lines 4–6.)
- **Dimension 3 (Blast Radius) — update the two-end registry:** edit session-marker.md §Concurrent-session detection (lines 195–207) to record the new exit-2/forceful behavior AND the new per-id-oracle read, per its own "If you change the detection signal … update … this section" contract.
- **Dimension 5 (Hidden Coupling) — verify the SessionStart forceful mechanism empirically before relying on it:** probe in the live CLI whether a SessionStart hook's exit-2 (or forceful `additionalContext` JSON) actually halts/strongly-steers the agent, the way PreToolUse exit-2 does. If SessionStart silently ignores exit-2, drop the "block" framing and ship the strongest non-blocking `systemMessage` instead — and say so plainly in the hook header and the operator-facing message (do not imply a hard block that the harness does not deliver). Document the probe result in session-marker.md alongside the existing `CLAUDE_CODE_SESSION_ID` live-probe note (lines 83–90).
- **Dimension 5 (Hidden Coupling) — close the live-vs-wrapped gap or degrade-loud, don't degrade-aggressive:** the id-oracle read alone cannot distinguish a live foreign session from the operator's own wrapped-today session (a wrapped session's per-id marker persists until the next `/prime` prune). Either add a genuine live-session discriminator (e.g., cross-reference the `pgrep` count against per-id markers, or scope by cwd via `lsof` as the hook header already names as the deferred precise detector, lines 31/43), OR keep the forceful path's wording explicitly conditional ("if the other session already wrapped, this checkout is safe") so a residual mis-fire degrades to an over-strong-but-recoverable nudge, never a hard stop on a solo relaunch. State which path was chosen in the hook header.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (hook line references, settings.json line numbers, session-marker.md contract lines, fix-plan section references, `diff`/`grep`/`ls` results on the two project copies, and principle IDs from the readable principles-base). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), obtained directly via the `system-owner` agent because `/consult` is model-invocation-disabled in this session. Verdict (PROCEED-WITH-CAUTION) stands as the gate result; the commentary is advisory._

**System-owner position:** Concur with PROCEED-WITH-CAUTION *as a gate*, but the verdict is gating a change whose headline guarantee ("block") is **fictional** at the SessionStart event. A SessionStart hook fires after cwd is fixed; it cannot prevent a start. The Fix 2 precedent does NOT transfer — `check-foreign-staging.sh` is **PreToolUse** (real exit-2 deny contract); **SessionStart has no equivalent forceful contract**. Fix 2 already blocks the only dangerous Failure A (shared-index contamination at commit time). Therefore Fix 1 should stay a **pure best-effort soft early-warning** (OP-12: closure before detection; AP-7). Risk the dimension review missed: the forceful path makes a false positive *more* costly — today a mis-fire is one ignorable nudge; under the change it becomes a stop on the normal same-day re-open path, pushing against the hook author's own deliberate deferral of the precise lsof/cwd discriminator (hook lines 43, 46). Mitigation ordering: promote M4 (probe SessionStart exit-2) to FIRST — it decides buildability; M1+M5 are the real fix (precision upgrade to the nudge, kill the false-fire); M3 mandatory; M2 conditional on verifying the copies exist.

**Empirical resolutions (main session, 2026-06-10 — both open questions closed before any build):**

1. **SessionStart exit-2 mechanism (M4) — RESOLVED, confirms the system-owner.** Authoritative `claude-code-guide` answer grounded in current Claude Code hooks docs: *"SessionStart hooks cannot block. On exit code 2, stderr is shown to the user; on any other non-zero exit code, stderr appears only with --verbose. In both cases execution continues."* SessionStart is strictly an advisory/context-injection event (not in the blocking-events set: PreToolUse, UserPromptSubmit, PermissionRequest, ConfigChange, Stop, SubagentStop, WorktreeCreate). The strongest a SessionStart hook can deliver is a forceful **message** (`systemMessage` = visible to user; `additionalContext` = silent to model), never a halt. → The "forceful block" framing of Fix 1 is **not buildable**. The mandate's Stop-if condition has fired.

2. **Grounding-integrity flag (M2 copies) — RESOLVED, confirms the risk-check-reviewer, corrects the system-owner.** `find` across the workspace shows THREE real-file copies: canonical `ai-resources/.claude/hooks/detect-concurrent-session.sh` + two project copies (`projects/positioning-research/...` — WIRED in its settings.json — and `projects/research-pe-regime-shift-advisory-gap/...`). Both project copies are byte-identical to canonical (verified `diff -q`). The system-owner's Glob missed them; the risk-check-reviewer's "two un-synced project copies" claim is **confirmed**. M2 (re-sync in the same commit) is real and required for whatever change lands.

**Net:** The verdict's two High dimensions are both substantiated, and the mechanism probe escalates the finding beyond mitigation — the "block" premise itself is invalid. Re-scope (not just mitigate) is indicated. See main-session surfacing.
