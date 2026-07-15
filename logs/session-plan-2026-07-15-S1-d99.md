# Session Plan — 2026-07-15 S1-d99

## Intent

Close the four urgent backlog items surfaced at `/prime`, in dependency order, each fix **proven by execution** rather than by reading the diff. The three hook-related items (1, 3, 4) form one subsystem and are done together; item 2 is three independent smaller fixes.

## Model

opus (session is on Opus 4.8 — match). This is architectural hook-wiring / cross-checkout / distribution work; the model heuristic puts it firmly in the "deciding" tier.

## Source Material

- Item 1 — `logs/improvement-log.md` 2026-07-14 "Nine repo-level hooks have NEVER fired (sentinel installed)"; decisive evidence `logs/sentinel-hook-probe.log`.
- Item 2 — `logs/improvement-log.md` 2026-07-14 three entries: the class-level wrap-session queue gap; `/risk-check` wrong-checkout write; "Logs written in shapes their own readers cannot parse (usage-log still broken)".
- Item 3 — `logs/improvement-log.md` 2026-07-14 "SessionEnd marker teardown does NOT fire on a cleanly-wrapped session".
- Item 4 — `logs/improvement-log.md` 2026-07-14 "Hook BODIES are versioned; hook WIRING is not"; installer spec in `logs/session-plan-2026-07-14-S8.md` Phase 1.

## Findings / Items to Address

### Item 1 — Nine dead repo-level hooks (cause PROVEN)

- Sentinel result (today, 09:46 SessionStart): `ABS` fired, `CPD_QUOTED` fired, `CPD_UNQUOTED` did **not** fire, `CLAUDE_PROJECT_DIR` is set. Per the S8 decode key this is unambiguously **cause (1): word-splitting** on the unquoted `$CLAUDE_PROJECT_DIR` expansion in a workspace path containing spaces.
- Confirmed live instance: `ai-resources/.claude/settings.json:136` (`bash $CLAUDE_PROJECT_DIR/.claude/hooks/friday-checkup-reminder.sh`, unquoted) and `:152` (sentinel CPD_UNQUOTED, unquoted).
- Fix: quote every hook command string that expands a spaced-path variable unquoted. First **grep every settings file** for the unquoted pattern so no dead hook is missed — the "nine" figure must be reconciled to an actual enumerated list, not trusted.
- Then remove the sentinel: delete `.claude/hooks/sentinel-hook-probe.sh`, delete `logs/sentinel-hook-probe.log`, remove the three sentinel wiring blocks from `settings.json`.
- Proof obligation: the quoted form is already proven to fire (sentinel, today). The fix is proven by (a) reading back the quoted settings and (b) a direct spaced-path execution test of one revived hook.

### Item 2 — Three this-week fixes (premises verified pre-gate; scope corrected)

- (a) **ALREADY FIXED — status flip only, not a build.** Both `wrap-session.md` copies already carry the core-path findings-disposition step (canonical Step 12e, workspace-root Step 4.8: "every finding queued or explicitly declined, no silent third option"). The `logs/improvement-log.md` entry (L927) was never marked applied. Action: read Step 12e, confirm it satisfies the entry, flip the entry to applied/verified. Do **not** re-implement.
- (b) `/risk-check` report path — **confirmed** `risk-check.md:50` sets `REPORT_DIR = {AI_RESOURCES}/audits/risk-checks/`, hard-coded to the canonical main repo, so a worktree session's report lands in the wrong checkout (and `check-foreign-staging.sh` exempts that dir, so a bare commit folds it in silently). Fix: resolve `REPORT_DIR` against the current checkout (`git rev-parse --show-toplevel`). Confirm the `{AI_RESOURCES}` definition first.
- (c) `usage-log.md` ordering — **confirmed** the S2 entry was prepended (L9, under `<!-- entries below -->`) while the reader (`/prime` Step 1, `tail -n 30`) reads the tail, so it is invisible. Fix: (i) move the prepended entry to the tail; (ii) add a cheap format-assertion script under `logs/scripts/` that checks the newest entry matches the reader's shape, called at wrap. Per the entry's own lesson: verify by running the reader, not by trusting the writer.

### Item 3 — SessionEnd teardown never fires on a clean wrap

- Hypothesis (to confirm by execution): `/wrap-session` is a slash command, not an actual session-termination event, so the `SessionEnd` hook (`~/.claude/settings.json:147`, correctly quoted, script present) simply does not fire on wrap — the marker persists until the *next* real session end.
- Fix: `/wrap-session` deletes its own markers as its last step (belt-and-braces, model-side), so a marker corpse is not the default outcome; correct the false trustworthiness claim at `close-worktree-session.md` L127–131.

### Item 4 — Hook wiring is unversioned

- Confirmed: `check-foreign-staging.sh`, `check-destructive-liveness.sh` (PreToolUse) and `cleanup-session-marker.sh` (SessionEnd) are wired only in unversioned `~/.claude/settings.json`. A fresh clone gets the scripts, not the wiring — guards silently absent.
- Fix: build `logs/scripts/install-hooks.sh` (idempotently writes the wiring into user settings, using the **quoted** form per item 1) + `.claude/hooks/check-hook-wiring.sh` (detects unwired state and reports). Rebuild from the S8 Phase 1 spec.

## Execution Sequence

- **Stage 1 — Item 1 (hooks):** grep all settings for unquoted spaced-path hook commands → enumerate → quote them → remove sentinel (file, log, 3 wirings) → prove one revived hook fires under a spaced path.
- **Stage 2 — Item 3 (SessionEnd):** confirm the "wrap is not a session-end event" hypothesis by execution → add the belt-and-braces teardown to both `wrap-session.md` copies → correct the false claim in `close-worktree-session.md`.
- **Stage 3 — Item 4 (installer):** build `install-hooks.sh` + `check-hook-wiring.sh` encoding the quoted wiring from Stage 1 → prove idempotent + falsifiable (planted unwired state detected). Post-edit QC on the installer (substantive new script).
- **Stage 4 — Item 2:** (a) status-flip only — confirm Step 12e satisfies the entry, mark applied (no build); (b) fix `risk-check.md` `REPORT_DIR` to resolve against the current checkout; (c) repair usage-log ordering + add a format-assertion script called at wrap. Two real fixes + one status flip, not three builds.
- No operator pause between stages — the single approval gate covers all four. Between-stage summaries emitted per workspace rule.

## Scope Alternatives

- **Full (recommended):** all four items / six fixes this session, if context holds with proper QC.
- **Hook cluster only (1, 3, 4):** defer item 2's three independent fixes to a separate focused session. Fallback if context tightens.
- **Item 1 only (minimal):** the proven, cheapest, highest-reach fix — revives nine hooks across 24 checkouts with one quoting change. The irreducible must-do if the session is cut short.

## Autonomy Posture

Gated. Structural change classes present: hook edits, `settings.json` wiring, a new installer script, automation with shared-state effects, cross-cutting command edits (`wrap-session.md` symlinked widely). `/risk-check` runs before execution (mandatory, Autonomy Rule #9). `/blindspot-scan` runs post-plan — the new installer + rewired hooks are its exact "will this actually run in the real environment?" trigger.

## Risk

- Blast radius: `settings.json` and `wrap-session.md` are versioned and reach ~24 checkouts; the installer touches unversioned user settings. High-reach, so gate discipline is warranted.
- Reversibility: all edits are git-tracked and revertible; the installer must be idempotent and non-destructive to existing user settings (append/merge, never overwrite).
- Premise risk: item 1's cause is proven; items 3's cause is a hypothesis to confirm before fixing. Do not ship item 3's fix until the "wrap is not a session-end event" hypothesis is confirmed by execution.
- Stop condition: if a revived hook does **not** fire under the quoted form on test, the premise is wrong — report and stop item 1 rather than ship an unproven fix (the exact failure the S8 session exists to end).
