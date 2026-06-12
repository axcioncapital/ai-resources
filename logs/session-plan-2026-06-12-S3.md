# Session Plan — 2026-06-12 S3

## Intent
Add a one-line advisory to `/prime`'s brief that nudges the operator to run `/concurrent-session-check` before starting a task — but only when a concurrent session is genuinely live in this checkout. Add the same pointer to `detect-concurrent-session.sh`'s sharp same-checkout nudge so the SessionStart alert also names the planning-time checker.

## Model
opus — short but load-bearing edit to a core command + a safety hook; precise gating logic matters.

## Source Material
- `.claude/commands/prime.md` — Step 1a (concurrency detection block, lines ~90-107) + Step 6 (brief template, lines ~180-190).
- `.claude/hooks/detect-concurrent-session.sh` — the ORACLE-path sharp nudge (line ~153).
- `.claude/commands/concurrent-session-check.md` — the command being pointed at (read-only reference).

## Findings / Items to Address
- `/prime` already detects concurrency via `SIBLING_COUNT` (same-day header count), but that over-fires on already-wrapped same-day sessions — it is NOT a liveness signal. Today S1+S2 both wrapped, so a `SIBLING_COUNT`-gated nudge would false-fire.
- The precise liveness signal already exists and is proven: the per-id marker oracle (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`) used by `detect-concurrent-session.sh`. A today-dated per-id marker OTHER than this session's own = a live (un-wrapped) foreign session in this checkout. `/prime` writes its own per-id marker only at Step 8 (after orientation), so at Step 1a time all today per-id markers are foreign — clean signal.
- The hook's sharp nudge already fires precisely on the same signal but points only at worktree isolation, never at `/concurrent-session-check`.

## Execution Sequence
1. `prime.md` Step 1a — add a `LIVE_FOREIGN_HERE` per-id-marker oracle computation (mirrors the hook), gated to skip silently when `CLAUDE_CODE_SESSION_ID` is unset (old-CLI degrade-safe).
2. `prime.md` Step 6 — add a conditional `⚠ Concurrent session live in this checkout …` brief line, emitted only when `LIVE_FOREIGN_HERE >= 1`, pointing at both `/concurrent-session-check <task>` and the no-arg backlog form.
3. `detect-concurrent-session.sh` — extend the ORACLE-path sharp nudge string with a `/concurrent-session-check` pointer (sharp/live case only; soft machine-wide path untouched).
4. `/risk-check` against the concrete diff.
5. `/qc-pass` on the diff.
6. Commit (in-scope files by explicit path).

## Scope Alternatives
- **Chosen:** precise per-id oracle gate in `/prime` + hook sharp-nudge pointer.
- Cheaper: reuse `SIBLING_COUNT > 1` as the gate (free, no new bash) — rejected: over-fires on wrapped sessions, trains the operator to ignore the line.
- Leaner: hook-only pointer, no `/prime` change — rejected: the operator reads the `/prime` brief when picking a task, which is exactly when the command is useful; the SessionStart hook message is easy to scroll past.

## Autonomy Posture
Gated — structural change class (core command + safety hook). `/risk-check` runs before commit per Autonomy Rule #9.

## Risk
Low. Both edits are advisory, read-only, add no shared-mutable state. The `/prime` addition is one cheap glob+cat loop reusing a proven signal; degrades safe (silent skip) when the session-id var is absent. The hook edit is a message-string extension only — no logic change. Stop-if: `/risk-check` NO-GO.
