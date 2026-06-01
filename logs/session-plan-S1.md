# Session Plan — S1 (2026-06-01)

## Intent

Design and build a **concurrent-session detection hook**: a proactive early-warning layer that, at session start, detects whether another Claude Code session is concurrently active in the same project and surfaces a loud warning before any shared-log write can collide. Closes the recurring TOCTOU race class (3–4 recurrences in 5 days) at the source — operator awareness — rather than adding another reactive per-write guard.

## Model

opus — match (session is on Opus 4.8). Design-heavy: a new hook + the supplement-vs-duplicate boundary decision are deciding-tier work, not mechanical.

## Source Material

- `logs/improvement-log.md` — TOCTOU race-class entries (the marker-clobber false-negative at lines ~216–224; the original 2026-05-28 concurrent-session entry).
- `logs/session-plan-S6.md` Wave 8 (item 22) + `logs/decisions.md` Item 1 — the DR-8 gate definition and SCHEDULE-DEDICATED disposition.
- `docs/session-marker.md` — canonical marker contract; the shared-mutable `.session-marker` / `.prime-mtime` are the poisoned oracles the existing guards trust.
- `.claude/commands/session-start.md` Step 0.5 — existing reactive mtime guard (point-in-time, fires once).
- `.claude/commands/wrap-session.md` Step 3.5 — existing reactive foreign-write guard (the one that suffered the clobber false-negative).
- `.claude/hooks/friday-checkup-reminder.sh` — reference shape for a SessionStart hook (non-blocking, `systemMessage` JSON, always `exit 0`).
- `.claude/hooks/log-write-activity.sh` — reference for reading hook stdin JSON via `jq`.
- `.claude/settings.json` — `SessionStart` hooks array (currently one entry: friday-checkup-reminder).
- Context pack: `output/context-packs/hook-20260601-c4e7a/pack.md` (success-insufficient; 3 missing-context flags).

## Findings / Items to Address

1. **Supplement, not duplicate (core design question — context-engine missing-context #3).** The two existing guards are *reactive per-write* checks at one command's critical moment, and both trust the clobbered shared marker. The hook is a *proactive early-warning* at session start that a concurrent session exists at all — different trigger timing, different mechanism, no overlap. This division is the design's load-bearing justification.

2. **Detection mechanism — session registry/heartbeat.** Claude Code SessionStart hook stdin JSON carries `session_id`. Maintain `logs/.active-sessions` (one `{session_id} {epoch}` line per session). On SessionStart: prune entries older than a TTL, append this session, then if ≥1 *other* distinct session_id survives pruning → emit a loud warning naming the count and age. This is a true concurrency registry, independent of `.session-marker`'s read/write semantics — so it cannot be poisoned by the clobber bug.

3. **Gitignore.** `logs/.active-sessions` is per-machine ephemeral state → must be gitignored (same class as `.session-marker` / `.prime-mtime`). Add to `.gitignore`.

4. **TTL tuning.** Stale entries (crashed/closed sessions) must self-expire. An 8-hour TTL clears abandoned sessions by next day while tolerating long real sessions. Tunable; documented in the hook header.

5. **Non-blocking contract.** Per `principles.md § OP-3` loud-failure and the existing SessionStart-hook convention: the hook warns via `systemMessage`, never blocks (`exit 0` always). It informs the operator; it does not gate.

6. **Two-end contract.** New hook + its state file are a consumer of the concurrent-session machinery → register in `docs/session-marker.md` (or a short companion note) so the registry isn't orphaned.

7. **Structural-change gate.** New hook + `settings.json` edit + shared-state automation = three `/risk-check` change classes (`audit-discipline.md`). Plan-time `/risk-check` runs before any code is written (auto-mode Step 8c.9). End-time gate per the two-gate model before commit.

## Execution Sequence

1. **Plan-time `/risk-check`** on the Option-A design (SessionStart registry hook). GO → continue; RECONSIDER/NO-GO → pause, retain plan.
2. Write `.claude/hooks/detect-concurrent-session.sh` — read `session_id` from stdin JSON; prune `logs/.active-sessions` by TTL; append self; warn if other live sessions remain. Non-blocking, `exit 0`.
3. Add `logs/.active-sessions` to `.gitignore`.
4. Wire the hook into `.claude/settings.json` `SessionStart` array (alongside friday-checkup-reminder).
5. Register the hook + state file in `docs/session-marker.md` two-end contract registry.
6. **Reproduce the race scenario** to verify detection fires: simulate two session_ids writing to `.active-sessions` within the TTL window; confirm the second invocation emits the warning and a single (solo) invocation stays silent.
7. **`/qc-pass`** on the hook + wiring + doc edit. GO → commit; REVISE → fix inline, re-QC if hard gate.
8. Commit directly (no push — batched to wrap).

## Scope Alternatives — UPDATED after risk-check + system-owner second opinion

**CHOSEN: Option B (read-only detector).** Risk-check returned PROCEED-WITH-CAUTION on Option A (registry), Hidden-coupling Medium driven by a non-atomic write window — *a race in the very file built to detect races* (AP-10). System-owner advisory (2026-06-01) recommended Option B: the hook READS an existing OS signal (count of running Claude Code CLI processes via `pgrep -f 'native-binary/claude'`) instead of writing new shared-mutable state. Same detection coverage, no new race surface, no inheritance of the `.session-marker` clobber bug. Strict risk reduction vs Option A → the PROCEED-WITH-CAUTION gate already covers it (no re-gate). Signal verified live 2026-06-01 against the process table (3 concurrent sessions detected; pattern excludes the Claude.app desktop helper).

Option B simplifications vs Option A:
- **No `session_id` dependency** — process-count needs no stdin field (removes the system-owner's top OP-3 concern).
- **No state file** — so NO `.gitignore` change. Change set shrinks to 3 files: hook + settings.json + doc.
- **No atomic-write mitigation** — there is no write.

- **Option A (rejected — was primary):** SessionStart registry `logs/.active-sessions`. Rejected per AP-10: a registry to detect races that itself races.
- **Lighter (rejected):** marker-recency-only — trusts the clobbered `.session-marker` oracle; false positives on same-session `/prime` re-runs. (Marker is used in Option B only as read-only *enrichment* context, never as the detection signal.)
- **Heavier (out of scope):** PreToolUse Write-to-session-notes guard — high firing frequency, overlaps Step 0.5 / wrap 3.5, no proactive early warning.
- **Structural (out of scope per mandate):** TOCTOU Phase 4 — env-var marker + per-marker files + append-only history. Separate scheduled item.

**Known limitation (Option B):** the process count is machine-wide, not project-scoped — a session in an unrelated project also counts. Accepted best-effort tradeoff for a non-blocking warning; documented in the hook header + `docs/session-marker.md`. Future enhancement: scope by cwd via `lsof`.

**Surviving mitigations folded into Option B:** all code paths `exit 0`; loud skip notice if `pgrep` absent (OP-3, no silent rot); signal verified against the real process table before shipping.

## Autonomy Posture

Gated — structural change (new hook + settings.json + shared-state automation). Plan-time `/risk-check` is the gate; the auto-mode approval already covered operator GO. After GO, execute to completion under full autonomy; `/qc-pass` before commit.

## Risk

- **Blast radius:** SessionStart hook fires at *every* session start in this project. A bug that mis-warns is annoying but non-blocking (exit 0 always) — low downside. A bug that crashes the hook must not break session start → defensive `exit 0` on every path, `jq`-absent guard.
- **False positives:** abandoned sessions not pruned → stale-warning. Mitigated by TTL.
- **Reversibility:** fully reversible — remove the settings entry + hook file + gitignore line + doc entry. No data migration.
- **Hidden coupling:** the registry is deliberately independent of `.session-marker` to avoid inheriting the clobber bug — verify no accidental read of the poisoned oracle creeps in.
- Plan-time + end-time `/risk-check` per the two-gate model.
