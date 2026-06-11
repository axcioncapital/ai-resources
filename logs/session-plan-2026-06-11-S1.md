# Session Plan — 2026-06-11 S1

## Intent
Build the deferred concurrent-session coverage fix (P1–P4 from the 2026-06-10 audit): register the
two ai-resources guard hooks at user level so all ~17 checkouts are protected, close the Fix 2
fail-open blind spot, and port the wrap-time marker teardown to workspace-root wrap-session.md.

## Model
opus 4.8 [1m] — match. Structural-change-class work with /risk-check gates; deciding load on the P1
hook-registration design and the P3 fail-open escalation warrants Opus.

## Source Material
- `audits/2026-06-10-concurrent-session-coverage-audit.md` §6 — the sequenced P1–P5 fix plan (authoritative).
- `logs/scratchpads/2026-06-10-S3-concurrent-coverage-audit-scratchpad.md` — resume point + ruled-out list.
- `logs/improvement-log.md` — umbrella PENDING entry + ids 467/477/501/216 (the residuals P3/P4/P5 close).
- `~/.claude/settings.json` — user-level hooks; already runs `detect-innovation.sh` by absolute path (P1/P2 feasibility proof).
- `.claude/hooks/check-foreign-staging.sh` — the commit-time block (P1 target; resolves repo_root via git rev-parse, degrades open).
- `.claude/hooks/detect-concurrent-session.sh` — the SessionStart nudge (P2 target).
- workspace-root `.claude/commands/wrap-session.md` — P4 target (port Step 13 marker teardown).

## Findings / Items to Address
- **P1 (CRITICAL, hard block):** `check-foreign-staging.sh` is wired only in ai-resources (0/15 project
  repos). Register it at user level (`~/.claude/settings.json`, PreToolUse(Bash)) by absolute canonical
  path → one registration guards all checkouts, zero per-project drift. Build wrinkle: user-level hooks
  can't use `$CLAUDE_PROJECT_DIR`; use the machine-absolute path. Confirm reachable when no ai-resources
  session is open.
- **P2 (HIGH, soft nudge):** Register `detect-concurrent-session.sh` at user level the same way, so all
  projects + workspace-root get the concurrency heads-up. Lighter (non-blocking SessionStart).
- **P3 (MEDIUM, soft block):** Escalate `check-foreign-staging.sh` from "warn + allow" to stop-and-confirm
  when a gated git verb runs with no concrete footprint AND a live foreign session is present. Folds in
  improvement-log 467 (minimum-guard) + 501 (/clarify-first case).
- **P4 (LOW, nuisance):** Add per-id marker teardown (`rm -f logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`)
  to workspace-root wrap-session.md so workspace-root sessions stop leaving stale markers (improvement-log 477).
- **Out of scope / do not revive:** P5 (wrap-lite, 216) stays deferred; Fix 4(b) log namespacing (declined)
  and the SessionStart *block* (un-buildable) are not revisited.

## Execution Sequence
1. **/risk-check (plan-time gate)** — covers the whole P1–P4 structural bundle (PreToolUse + SessionStart
   hook registration at user scope, edit to a live blocking hook, paired-copy command edit). On NO-GO for
   P1: stop per the mandate.
2. **P1** — read `check-foreign-staging.sh` to confirm repo-agnostic resolution; add a PreToolUse(Bash)
   entry to `~/.claude/settings.json` pointing at the absolute canonical path; verify JSON validity.
3. **P2** — add a SessionStart entry for `detect-concurrent-session.sh` to `~/.claude/settings.json`,
   same absolute-path pattern.
4. **P3** — edit `check-foreign-staging.sh`: in the no-footprint + live-foreign-session branch, escalate
   from warn+allow to a stop-and-confirm (loud-block). QC the branch logic.
5. **P4** — port the marker-teardown line into workspace-root wrap-session.md Step matching the
   ai-resources Step 13.
6. **/qc-pass** on the hook-logic change (P3) and the settings edits; commit per-P or batched.

## Scope Alternatives
- **Full P1–P4 (recommended, this plan).** Delivers the coverage fix + the last data-loss blind spot + cleanup.
- **P1+P2 only.** The coverage fix alone — ~all marginal safety; defer P3/P4. Fallback if context runs short.
- **P1 only.** The single critical hard-block registration; everything else re-deferred. Minimum viable.

## Autonomy Posture
Gated. Harness-config change (user-level settings.json) + hook-logic edit (P3) + paired command-copy edit
(P4) are structural change classes. Plan-time /risk-check is mandatory (Step 1). Commit directly per
workspace rules; push batched to wrap.

## Risk
- User-level settings.json edit affects every session on the machine (and is per-machine — Daniel's clone
  differs). Mitigation: absolute path to the canonical hook; both hooks already degrade open outside a repo.
- P3 turns a currently-advisory branch into a hard stop — risk of false-fire friction. Mitigation: gate it
  narrowly (no-footprint AND live-foreign-session only), QC the branch.
- JSON edit to user settings could break the harness if malformed. Mitigation: validate JSON after edit.
