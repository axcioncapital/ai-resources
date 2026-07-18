# Session Plan — 2026-07-18

## Intent
Make the hook wiring versioned and installable from the repo — a tracked source-of-truth for the 7 registrations in `~/.claude/settings.json` plus `cleanup-session-marker.sh`'s body, and an idempotent installer that merges them in with a timestamped backup — so a fresh clone actually gets the concurrency-safety layer firing instead of scripts that only look installed. (Mission `repo-health-backlog-2026-07`, thread 3.)

## Model
opus — match (design judgment under a twice-RECONSIDER'd risk profile; the failure mode is a silently-inert guard, which is exactly what shallow execution produces here)

## Source Material
- `/Users/patrik.lindeberg/.claude/settings.json` — the unversioned wiring target (verified this session)
- `/Users/patrik.lindeberg/.claude/hooks/cleanup-session-marker.sh` — unversioned hook body, 6785 bytes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` — repo-level hooks (10, all quoted; item 1 of the 2026-07-15 set landed)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-15-four-part-urgent-hook-wiring-log-fix-set.md` — the RECONSIDER that scoped this out; carries the redesign path
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-07-14-S8.md` (lines 129–144) — the Phase 1 installer spec, built+tested but never landed
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md` — thread 3 and the mission's validation contract
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change classes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical settings shapes per layer
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.test.sh` — the in-repo test idiom to mirror for the installer's tests

## Findings / Items to Address

1. **`~/.claude` is not a git repo** — confirmed this session by `git rev-parse` returning `fatal: not a git repository`. Nothing under it travels with a clone.
2. **7 script registrations live only there** (verified by parsing the file's `hooks` block, not recalled): `check-foreign-staging.sh` + `check-destructive-liveness.sh` (PreToolUse/Bash), `detect-concurrent-session.sh` + `warn-fable-model.sh` (SessionStart), `detect-innovation.sh` ×2 (PostToolUse Write + Edit), `cleanup-session-marker.sh` (SessionEnd). Two further entries are `afplay` sound commands, not repo scripts, and are **out of scope** — they are machine-local preference, not a safety layer.
3. **The 2026-07-15 risk-check undercounted this at 3 registrations** (`…-four-part-urgent-hook-wiring-log-fix-set.md:15` names only check-foreign-staging, check-destructive-liveness, cleanup-session-marker). The real scope is 7. Surfacing the discrepancy rather than inheriting it.
4. **6 of the 7 hardcode `/Users/patrik.lindeberg/...`** — `session-plan-2026-07-14-S8.md:137` states they "resolve on no other machine." Re-confirmed by direct read of the command strings. So versioning the wiring verbatim would ship a manifest that is already machine-specific; the installer must derive the repo root at install time.
5. **`cleanup-session-marker.sh`'s body is itself unversioned** — it exists only at `~/.claude/hooks/` (`session-plan-2026-07-14-S8.md:133-134`). Confirmed by `ls`: `~/.claude/hooks/` holds exactly that script plus its log.
6. **The installer scored High/High (Permissions/Reversibility) twice** — `…-2026-07-15…:78-99` grades it High on both, citing two earlier RECONSIDERs on the same capability. Its named redesign conditions: an explicit **timestamped backup** before the merge (the S8 spec had it; the 2026-07-15 description had dropped it), and landing as **its own change with its own `/risk-check`**.
7. **`"model": "opus[1m]"` must survive untouched** — operator-DECLINED 2026-07-13. Confirmed present in the file's top-level keys this session. A wholesale write would destroy it; only a key-scoped merge is acceptable.
8. **A detection hook needs its own known-positive** — `session-plan-2026-07-14-S8.md:143-144`: a probe that exits 127 reports "all clear", so `check-hook-wiring.sh` must be proven to fail *loudly* against a deliberately-unwired settings file before it is trusted. OP-12 (closure before detection) is satisfied because the installer ships in the same change as the detector.
9. **Neither artifact exists yet** — `logs/scripts/install-hooks.sh` and `.claude/hooks/check-hook-wiring.sh` both confirmed ABSENT this session. The S8 build is gone.

## Execution Sequence

**Stage 0 — Plan-time gates (before any file is written).**
Run `/risk-check` (Autonomy rule #9; this is the "its own risk-check" the 2026-07-15 redesign demanded). Pass the verified inventory above into the dispatch brief as *given state* so the reviewer scores it rather than rebuilding it (S7-bb5 telemetry). Then run `/blindspot-scan` — this plan creates a new hook and a new installer, and the scan's distinctive question ("will this actually run in the real environment?") is literally thread 3's subject matter, so it is not stacked ceremony here.
*Verify:* both verdicts recorded; on RECONSIDER or NO-GO, stop per the mandate's `Stop if`.

**Stage 1 — Bring the hook body under git.**
Copy `~/.claude/hooks/cleanup-session-marker.sh` to `.claude/hooks/cleanup-session-marker.sh`. Do not delete the original yet — the live SessionEnd registration still points at it.
*Verify:* `git ls-files` shows the new path; `diff` against the original is empty.

**Stage 2 — Write the wiring manifest.**
A tracked declaration of the 7 registrations with the repo root as a substitutable token, not a literal path. Placement decided against `docs/repo-architecture.md` at implementation time; leading candidate `.claude/hooks/hook-wiring.json`.
*Verify:* the manifest round-trips — rendering it with the current repo root reproduces the 7 live command strings byte-for-byte, modulo the `cleanup-session-marker.sh` path which moves to the repo copy.

**Stage 3 — Build `logs/scripts/install-hooks.sh`.**
python3, idempotent, key-scoped. Contract: (a) timestamped backup of `~/.claude/settings.json` before any write; (b) merge **only** the `hooks` key; (c) derive the repo root dynamically; (d) touch no other top-level key, `model` above all.
*Verify by execution:* run it twice — second run is a no-op (`diff` of the file across runs is empty); `python3 -c` confirms all 10 original top-level keys still present and `model` unchanged; the backup file exists and parses as JSON.

**Stage 4 — Build `.claude/hooks/check-hook-wiring.sh` + its known-positive.**
Detects unwired state, names the installer in its message, wired into `ai-resources/.claude/settings.json` with a **quoted** path (an unquoted probe is dead on arrival — the exact bug this subsystem already shipped once).
*Verify by execution:* point it at a deliberately-unwired fixture settings file and confirm it reports the gap loudly; confirm it does not report "all clear" on a non-zero exit.

**Stage 5 — Prove it on a second checkout.**
The mission's acceptance assertion is explicit: *"demonstrated by execution on a real second checkout, not by reading the settings file."* Clone or worktree into a scratch path, run the installer against a fixture HOME, and observe a hook actually fire.
*Verify:* a hook's own side-effect (log line, marker file) is observed in the second checkout. Reading the settings file does not count.

**Stage 6 — Close the loop.**
Tick thread 3 via `/mission update` (the sanctioned path thread 6 built — do not hand-edit). Flip the 2026-07-14 improvement-log entry citing what shipped. Commit. Do not push.
*Verify:* `/mission read` shows thread 3 checked; the log entry's Status line no longer reads OPEN.

## Scope Alternatives

- **Min** — Stages 1–3 only: version the hook body and ship the installer, no detection hook. Closes the portability hole; leaves "is it wired *right now*" unanswered. Fallback if `/risk-check` pushes back on adding a SessionStart hook (Dimension 1 graded that Medium last time).
- **Recommended** — Stages 0–6 as written. Installer + detector + second-checkout proof. This is the only variant that satisfies the mission's acceptance assertion as written.
- **Max** — adds retrofitting the workspace-root `.claude/settings.json` hooks into the same manifest, and removing the now-redundant `~/.claude/hooks/` copy. Deferred: it widens blast radius into a second settings layer mid-change, and the mission thread does not ask for it.

## Autonomy Posture
Gated

**Stop points:**
- After Stage 0 — `/risk-check` verdict. RECONSIDER a second time or NO-GO halts the session per the mandate.
- Before Stage 3's first write to `~/.claude/settings.json` — confirm the backup landed and is parseable before the merge touches anything.
- If the design cannot preserve the operator-DECLINED `model` field, stop and surface rather than working around it.
- If Stage 5 cannot be run for real (no viable second checkout), stop and report the assertion as unmet rather than substituting a file read — the mission's non-negotiables forbid closing a thread on a code read.

## Risk

Run `/risk-check` after this plan is approved (plan-time gate) and again before commit (end-time gate). Structural classes touched: **hook edits**, **permission-surface changes** (user-level settings), **new automation with shared-state effects**, **a new hook registration**.

Known profile from precedent, carried forward rather than rediscovered: Permissions **High** (an automated write to a user-level config file outside git, previously only hand-edited); Reversibility **High** (`git revert` of the installer does not undo what it wrote — the timestamped backup is the only rollback path, which is why it is a hard precondition, not a nicety).

**⚠ Environment-fit flag (Step 6 check — this is a live mismatch, not a formality).** The operator launches Claude Code via the **VS Code extension, not a terminal**. A `logs/scripts/install-hooks.sh` that must be run from a shell prompt will ship inert — the exact 2026-06-10 `cc-worktree.sh` failure, where a terminal launcher passed the full gate chain and delivered zero value. Mitigation to settle during Stage 3: the installer must be invocable **in-session** (run by Claude on request, or fronted by a slash command), with the bare script as the portable fallback for the fresh-machine case it exists to serve. Do not ship it as terminal-only.

**Scope-honesty note.** The 2026-07-15 risk-check's item 4 named 3 registrations; the live file holds 7. This plan works from the verified 7. The reviewer should be told the earlier figure was low so it is not treated as a regression.
