# Session Marker Protocol

Single-source contract for the per-session identity marker (`.session-marker`) and the marker-scoped log file naming used by `/prime`, `/session-start`, `/session-plan`, and their downstream consumers.

Shipped: 2026-05-29 atomic Phase 2+3 commit (Option A per system-owner advisory). Phase 1 (write-only marker) precedent: commit `ea93d62` (2026-05-28). Replaces the pre-Phase-2 shared `logs/session-plan.md` and bare `## YYYY-MM-DD` session-notes headers — each session now writes to its own marker-scoped plan file and under its own marker-bearing header.

Source proposal: `ai-resources/logs/improvement-log.md` lines 73-138 ("Concurrent sessions cause TOCTOU races on shared log files").

---

## Marker files

Two files, written together by `/prime`. The per-session-id file is the **identity oracle**; the shared file is the **same-day `S{N}` counter** plus back-compat (Option 2′, shipped 2026-06-01).

### Identity oracle — `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` (PRIMARY)

**Path:** `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` (cwd-relative). `CLAUDE_CODE_SESSION_ID` is injected into every Bash tool call by the harness.

**Format:** one line: `{YYYY-MM-DD} S{N}` — e.g., `2026-06-01 S5`.

**Gitignore:** YES — `logs/.session-marker-*`. Per-machine, per-session state, not committed.

**Why it exists:** the shared `logs/.session-marker` is a single mutable file — a concurrent `/prime` in another session **overwrites** it, and any reader (the wrap guard especially) then resolves the *wrong* marker silently. Keying the marker by the session id removes the shared-mutable oracle: a concurrent session writes a *different* file (different id), so it cannot clobber this session's marker. The silent false-negative the wrap guard exists to catch can no longer occur, because the oracle is no longer the thing being clobbered. See `logs/improvement-log.md` "Option 2′" entry and `audits/option2-marker-redesign-2026-06-01.md`.

**Lifetime:** written by `/prime` at session start, alongside the shared file. Pruned by `/prime` (orphan cleanup) when not dated today.

### Same-day counter — `logs/.session-marker` (RETAINED, back-compat + S{N} lookup)

**Path:** `logs/.session-marker` (cwd-relative, in the git root of the active project / ai-resources).

**Format:** one line: `{YYYY-MM-DD} S{N}` — e.g., `2026-05-30 S1`.

**Gitignore:** YES. Per-machine session state, not committed. Present in `.gitignore` from Phase 1 commit `ea93d62`.

**Lifetime:** written by `/prime` at session start. Overwritten by `/prime` on same-day re-invocation (`S1` → `S2` → ...). A new day resets to `S1`.

**Role at v1:** still serves the same-day `S{N}` increment lookup and back-compat / loud-fallback. It is **no longer the identity oracle** — removing it entirely is a separable later change (DR-7/AP-7), deliberately deferred. Concurrent same-day `/prime`s can still race on the *number* here (both compute S2), but that is a benign cosmetic collision — identity comes from the per-id file, so attribution is never corrupted.

### Both-or-neither writer invariant (BLOCKING)

**Any marker-setup path MUST write the shared file (`logs/.session-marker`) and the per-id identity oracle (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`) together — never one alone.** The two are a single atomic write unit: the shared file carries the `S{N}` counter, the per-id file carries un-clobberable identity. Writing only the shared file leaves the session with no identity oracle.

**Why it is load-bearing:** the `no-own-marker rule` (below) reads "`CLAUDE_CODE_SESSION_ID` set + per-id file absent" as "this session authored zero tracked headers." That inference is correct for a genuine no-`/prime` session, but **wrong for a session whose marker setup was partial** — it ran `/prime`'s header append yet wrote only the shared file. The wrap guard (`/wrap-session` Step 3.5) then mis-attributes that session's *own* header as foreign, producing a `NO_OWN_MARKER` false-positive.

**Observed:** 2026-06-05 (S6) — a hand-rolled marker setup wrote only `logs/.session-marker`, not the per-id file. The Step 3.5 guard would have flagged S6's own header as foreign (near-miss, caught by a manual `FOREIGN=0` verification). See `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` § 4 (tertiary contributor).

**Canonical writers already comply.** `/prime` Steps 8a.3.a / 8b.3.a / 8c.3 each write both files together (shared `echo` immediately followed by the `[ -n "${CLAUDE_CODE_SESSION_ID}" ] && echo … > "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"` line) plus the orphan-prune. This invariant exists so that any **deviation** — a hand-rolled or alternate setup that writes one file — is recognised as a contract violation, not treated as a valid degraded state. Do not author a marker-setup path that writes the shared file without the paired per-id write.

---

## Marker resolution (canonical pattern — every consumer uses this shape)

Resolve the **per-session-id identity oracle first**; fall back **loudly** to the shared file only if the oracle is unavailable (older CLI without the harness var, or per-id file missing/stale).

```bash
TODAY=$(date '+%Y-%m-%d')
MARKER=""
# PRIMARY — per-session-id identity oracle (un-clobberable by a concurrent /prime).
if [ -n "${CLAUDE_CODE_SESSION_ID}" ] && [ -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" ]; then
  CONTENT=$(cat "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}" 2>/dev/null)
  [ "${CONTENT%% *}" = "$TODAY" ] && MARKER="${CONTENT##* }"
fi
# LOUD FALLBACK (principles.md § OP-3) — var absent (old CLI) OR per-id file missing/stale, but shared file present.
if [ -z "${MARKER}" ] && [ -f logs/.session-marker ]; then
  echo "[marker] Note: CLAUDE_CODE_SESSION_ID-keyed marker unavailable — falling back to shared logs/.session-marker (clobber-vulnerable)."
  CONTENT=$(cat logs/.session-marker 2>/dev/null)
  [ "${CONTENT%% *}" = "$TODAY" ] && MARKER="${CONTENT##* }"
fi
```

If `MARKER` is empty after this block (both oracles absent/stale), the consumer chooses handling per role (see asymmetric contract below). The loud-fallback line makes the degraded path visible — silent regression to the clobberable shared file cannot happen quietly.

**No-own-marker rule for own-contribution readers (clobber false-negative fix, 2026-06-04).** A reader that attributes *this session's own contribution* (the `/wrap-session` Step 3.5 pre-write guard) must NOT take the loud fallback when `CLAUDE_CODE_SESSION_ID` is SET but the per-id file is absent. That state means the session ran neither `/prime` task-selection nor `/session-start`, so it authored zero tracked headers/mandates — there is nothing of its own to subtract. Falling back to the shared `logs/.session-marker` there would read a concurrent session's clobbered marker and miscount the *foreign* session's header as own, zeroing the foreign delta (silent `FOREIGN=0` false-negative). The rule: var SET + per-id file absent → `OWN_HEADERS_SUBTRACT=0`, `OWN_MANDATES_SUBTRACT=0`, and skip BOTH the shared-marker fallback and the `PRIME_RAN`/`.prime-mtime` path. The loud fallback is restricted to the genuine old-CLI case (var unset). Pure-`MARKER`-resolution consumers (e.g. `/prime`, `/session-plan`) are unaffected — this rule is specific to own-contribution subtraction.

**Clobber-safe own-marker recovery (reader-side complement to the both-or-neither invariant, 2026-06-05 S9).** The no-own-marker rule above is conservative-by-design: it claims zero own-contribution whenever the per-id file is absent, which *false-positives* (its own header flagged FOREIGN) for a **partial-setup** session that wrote the shared file but not the per-id file. The `/wrap-session` Step 3.5 reader closes that gap *before* claiming zero — it recovers the marker from the shared `logs/.session-marker` **only when provably own**: the shared marker is dated today/yesterday, **no** per-id file (`logs/.session-marker-*`, for any session) claims that `{date} S{N}`, **and** a matching `## {date} — Session S{N}` header exists. This is safe *conditional on* the both-or-neither invariant — a **compliant** foreign author of `S{N}` would have left a per-id file claiming it, so a per-id claim suppresses recovery (the compliant foreign-clobber case stays a correct `FOREIGN≥1`). On any non-match the reader falls through to the conservative zero-claim unchanged. **Precise safety statement (do not overstate):** the recovery fires **only in invariant-violation space** — a compliant session resolves its per-id marker at the oracle step above and never reaches here — so within compliant operation it is inert. It removes the own-partial-setup false-positive, and adds **no** false-negative **provided foreign sessions honour the both-or-neither invariant**. **Residual false-negative (accepted, narrower than the false-positive removed):** a *single* non-compliant **foreign** partial-setup session (wrote shared `.session-marker` + header `S{N}`, no per-id) running concurrently with a *genuine* no-own-marker reader (e.g. a `/fix-repo-issues` session) — the reader cannot distinguish that from own-partial-setup and will recover `S{N}`, zeroing the foreign delta (silent `FOREIGN=0`). It needs only *one* invariant-violator, not two. This is **not eliminable reader-side** (no per-session signal separates own- from foreign-partial-setup once the per-id file is absent); it is closed at the **writer layer** by the both-or-neither invariant so partial setup never occurs. Note the trade: pre-recovery `NO_OWN_MARKER` fails *safe* (loud false-positive) in this case; the recovery substitutes a fail-*unsafe* guess, justified only because the triggering state is itself an invariant violation.

---

## Harness-var dependency — `CLAUDE_CODE_SESSION_ID`

The identity oracle depends on a harness-injected environment variable. This crosses the deliberately-held `OP-10` harness boundary, so it is governed explicitly here (`OP-11`: treat a CLI upgrade as a re-verify event).

**Two assumed properties** (both probed live in the running CLI on 2026-06-01):

1. **Stable within a session** — the same value is returned across separate Bash tool calls in one session (each tool call is a fresh shell, yet the var persists because the harness re-injects it). Verified: two separate Bash calls returned `bd44a70e-a522-4d0c-879d-ab4db87284f6` identically.
2. **Distinct across sessions** — each session gets a unique id, so a concurrent session writes a different per-id file and cannot clobber this one.

**The loud fallback bounds *absence*, not *changed meaning*.** If a future/older CLI lacks the var, resolution falls loudly to the shared file (current behavior restored, visibly). But the fallback does NOT protect against the var's *meaning* changing — e.g., a `/compact` resume that re-keys the session to a new id. In that case the earlier per-id file is orphaned and resolution falls through to the loud fallback. **This is an expected loud-fallback path, not a bug** — document any new resume-rekeying behavior here if observed.

**Re-verify trigger:** on any Claude Code CLI upgrade, re-probe that `CLAUDE_CODE_SESSION_ID` is still present and stable-within / distinct-across. The var is treated as contractual based on the live probe, not on a published guarantee.

**Orphan accumulation:** per-id files accumulate (one per session). `/prime` prunes `logs/.session-marker-*` not dated today at session start. Files are small and gitignored, so worst-case harm is negligible.

---

## Asymmetric writer/reader contract

**Writers** (must HARD-FAIL on marker absent/stale):

- `/prime` — only command authorized to create the marker.
- `/session-start` — appends mandate under marker-bearing header.
- `/session-plan` — writes marker-scoped plan file.

Hard-fail shape (single loud line per `principles.md § OP-3`):

> `[/{command} Step {N}] HARD-FAIL: session marker unresolved (logs/.session-marker-${CLAUDE_CODE_SESSION_ID} and shared logs/.session-marker both absent or stale). Run /prime to populate the marker for this session, then retry.`

**Read-only auxiliary consumers** (tolerate marker absent/stale by falling through to alternate sources):

- `/contract-check` — falls through to mandate line or `$ARGUMENTS` source.
- `/drift-check` — falls through to session-notes-only mandate resolution.
- `/open-items` — uses glob `logs/session-plan-*.md` scan; no marker resolution required.
- `fix-repo-issues-scanner` agent — same glob.
- `/decide` — same glob.

Rationale: writers produce session state — operating without a marker means writing to an ambiguous location. Read-only auxiliary consumers may be invoked post-session (no active marker is normal) and must keep working in that mode.

---

## File naming

| Resource | Pre-Phase-2 (bare path) | Phase 2+3 atomic (marker-scoped) |
|----------|------------------------|----------------------------------|
| Session plan (canonical) | `logs/session-plan.md` | `logs/session-plan-${YYYY-MM-DD}-${MARKER}.md` |
| Session plan (re-invocation fork) | `logs/session-plan-pass2.md` | `logs/session-plan-${YYYY-MM-DD}-${MARKER}-pass2.md` |
| Session notes header | `## YYYY-MM-DD` | `## YYYY-MM-DD — Session ${MARKER}` |
| Session notes file | `logs/session-notes.md` (shared) | `logs/session-notes.md` (shared; marker disambiguates by header) |

The session notes file remains shared across sessions; the marker disambiguates by header text, not by filename. `^## YYYY-MM-DD` greps still match marker-bearing headers (unanchored at end of line); existing consumers that scan by date continue to work.

**Tracking policy:** `logs/session-plan-*.md` files are tracked in git (per-session plan history, parallel to `logs/session-notes.md`'s tracking). Not gitignored. Date-qualified filenames (`session-plan-YYYY-MM-DD-S{N}.md`) are the canonical form; bare-marker files (`session-plan-S{N}.md`) from pre-date-qualify sessions are also tracked.

---

## Two-end contract registry

Every place the marker contract is consumed must point back to this doc. Adding or changing a consumer requires updating this list.

**Writers** (hard-fail on marker absent/stale):

- `ai-resources/.claude/commands/prime.md` — Steps 8a.3.a / 8b.3.a / 8c.3 (writes BOTH the shared file and the per-session-id identity oracle `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, plus orphan-prune of stale per-id files) and Step 8c.8 (auto-mode plan write). **Lockstep triplet:** the marker-resolution logic that computes `S{N}` (the `if [ -f logs/.session-marker ] … else … fi` block, including the 2026-07-03 absent-marker fallback that resumes `N` from the highest today-dated `## <today> — Session S{N}` header via `grep -oE "^## ${TODAY} — Session S[0-9]+" … | grep -oE '[0-9]+$' | sort -n | tail -1`) is **triplicated byte-identical across these three steps**. Any change to it must land in all three in the same edit and be diff-verified byte-identical — a divergence would make the numbered-pick (8a), free-text (8b), and auto-mode (8c) paths resolve `N` differently. The absent-marker fallback matches the em-dash `—` **literally** (an ASCII hyphen silently matches nothing and regresses to `N=1`) and takes the **numeric** max (so `S10 > S9`); verify by execution, not review.
- `ai-resources/.claude/commands/session-start.md` — Step 3 (header location; resolves marker per-id-first).
- `ai-resources/.claude/commands/session-plan.md` — Step 0 (header gate) and Step 7 (plan write).

**Per-id marker teardown** (liveness-signal lifecycle, added 2026-06-10 — Fix 1):

> **The harness-enforced teardown below is the RELIABLE path. The two model-executed teardowns after it are now redundant fast paths, retained only as belt-and-braces.** Before 2026-07-13 the liveness signal depended entirely on a model remembering to run an `rm` at the end of a long command, and it was being forgotten in practice — see the SessionEnd entry for the evidence. Do not add a fourth model-executed teardown site; if a new session-ending path needs coverage, it is already covered by the hook.

- `~/.claude/hooks/cleanup-session-marker.sh` — **user-level `SessionEnd` hook (added 2026-07-13; the reliable teardown).** Fires when the CLI process ends — normal exit, `/clear`, `/quit` — parses `session_id` + `cwd` from the SessionEnd stdin JSON payload (falling back to `CLAUDE_CODE_SESSION_ID` / `CLAUDE_PROJECT_DIR`), and removes `<cwd>/logs/.session-marker-<session_id>`. Registered in `~/.claude/settings.json` under `hooks.SessionEnd`.
  - **Why it exists.** The two model-executed teardowns below were being **skipped in practice**. On 2026-07-13, of three wrapped sessions (S1/S2/S3) only S2's marker was removed — `/wrap-session` Step 13 is the final action of a ~300-line command, after the commit, which is exactly where a model stops. Stale markers make **wrapped** sessions look **live**, so `/prime` Step 1a and `detect-concurrent-session.sh` false-fire the same-checkout warning on every second-or-later session of any day → alarm fatigue on the one warning guarding a real data-loss mode. Predicted verbatim by `logs/friction-log.md` (2026-07-12, line 321): *"wrapped sessions leave ghost markers… Any fix must make teardown reliable (or make liveness derivable from something other than a file the dying session is trusted to delete)."*
  - **Why USER-level, not repo-level.** `prime.md` is symlinked into every project from `ai-resources`, so per-id markers are written in **every** repo — but a hook in `ai-resources/.claude/settings.json` only fires when ai-resources is the open folder, and `positioning-research` runs a **forked** `wrap-session` with no teardown step at all. `~/.claude/` is the only layer covering ai-resources + all projects + future projects. Operator decision, 2026-07-13, over the ai-resources-only and template+per-project alternatives.
  - **Coverage gap (accepted).** `SessionEnd` does **not** fire on `SIGKILL` / hard crash. **`/prime`'s next-day orphan prune remains the required backstop and must not be removed.** Degrades safe — a crashed session leaves a stale marker until the next day (an occasional over-nudge), never a *missed* live collision.
  - **Safety contract.** The hook deletes a file, so it is guarded: `session_id` must be ≥8 chars and match `[A-Za-z0-9_-]` only (rejects empty ids, and rejects `/` and `.` so no traversal is constructible); `cwd` must be a real directory **containing a `logs/` subdirectory** (this is what makes the hook a genuine no-op in non-Axcíon folders — enforced by logic, not by luck); the target must exist as a regular file before `rm`. Every path exits 0 — `SessionEnd` cannot block, and this must never be why a session fails to close. Verified against all six cases (valid / empty-id / both-sources-empty / traversal-id / no-`logs/`-dir / env-fallback) before landing; gated by `audits/risk-checks/2026-07-13-user-level-sessionend-hook-marker-cleanup.md` (PROCEED-WITH-CAUTION, all four mitigations applied).
  - **Self-probe.** The exact SessionEnd payload schema could not be verified from docs at build time, so the hook does not assume it: it logs the payload's key set on every fire to `~/.claude/hooks/cleanup-session-marker.log` (bounded to 100 lines) and **no-ops loudly** rather than deleting the wrong thing if the schema differs. Inspect with `tail ~/.claude/hooks/cleanup-session-marker.log`.
  - **Not in git.** `~/.claude/` is unversioned. A timestamped backup of the settings file (`~/.claude/settings.json.bak-2026-07-13`) is the revert path.

- `ai-resources/.claude/commands/wrap-session.md` — Step 13 (final wrap action: `rm -f logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`). This completes the per-id marker lifecycle — `/prime` creates it, `/wrap-session` removes it — so the today-dated per-id marker set means **un-wrapped ≈ live sessions in this checkout**, which is the signal `detect-concurrent-session.sh` reads to suppress the same-checkout false-fire on this operator's own already-wrapped session. Removal runs **last**, after every marker-dependent read (Step 3.5 attribution, Step 7a mandate read). The shared `logs/.session-marker` is NOT removed (it is the date-pruned `S{N}` increment oracle). A crashed/aborted session that never reaches Step 13 leaves a stale per-id marker until `/prime`'s next-day orphan prune — accepted degrade. **PAIRED CONTRACT** with the workspace-root `wrap-session.md` copy — port the teardown there in lockstep on the next sync.
- `ai-resources/skills/handoff/SKILL.md` — continuity-mode Step C3 (final continuity action: same `rm -f logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, added 2026-06-12). A session that ENDS via direct `/handoff` (notably a QC-PENDING deferral) never reaches `/wrap-session` Step 13, so before C3 its per-id marker survived and false-flagged the next same-checkout session's commit as a live concurrent collision (observed 2026-06-11 S1→S2). C3 closes that gap. **Scoped to direct `/handoff` only** — explicitly SKIPPED when `/wrap-session` Step 0.5 inlines continuity Steps C1–C2, because wrap owns its own Step 13 teardown that must run after its marker-dependent Steps 3.5/7a; a C3 teardown at Step 0.5 would run too early and break them. On resume after `/clear`, `/prime` rewrites the per-id marker, so the teardown is safe whether the session ends or resumes.

**Read-only auxiliary consumers** (tolerate marker absent/stale):

- `ai-resources/.claude/commands/contract-check.md` — Step 2b (plan source resolution; glob `logs/session-plan-*${MARKER}.md`).
- `ai-resources/.claude/commands/drift-check.md` — Step 3 (locate plan; glob `logs/session-plan-*${MARKER}.md`), Step 6 (mandate disambiguation), Step 7 (no-mandate abort), Step 8 (conflict reporting).
- `ai-resources/.claude/commands/wrap-session.md` — Step 6.4 mandate-resolution chain (plan source for the independent outcome check; glob `logs/session-plan-*${MARKER}.md`). **PAIRED CONTRACT** with the workspace-root copy below — edit both in lockstep.
- `/.claude/commands/wrap-session.md` (workspace-root paired copy) — Step 4.4 mandate-resolution chain (same glob). Lockstep with the canonical copy above.
- `ai-resources/.claude/commands/open-items.md` — table rows for `session-plan-*.md` glob scan.
- `ai-resources/.claude/agents/fix-repo-issues-scanner.md` — table rows + read-only list.
- `ai-resources/.claude/commands/decide.md` — Step 2 prior-decision read.
- `ai-resources/.claude/commands/concurrent-session-check.md` — Steps 2–3 (reads today-dated per-id markers `logs/.session-marker-*` to detect live sessions, and globs `logs/session-plan-${TODAY}-S{N}.md` plus the `- Files in scope:` mandate bullet to read each live session's declared footprint). Read-only; writes nothing.

**Runtime non-command consumers** (load-bearing parse logic — a silent non-match degrades behavior with no error):

- `ai-resources/.claude/hooks/backup-session-plan.sh` (+ project-local copies, e.g. `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/backup-session-plan.sh`) — PreToolUse Write hook; line-20 regex must match every plan filename form or backups silently stop. Regex cap widened to `{0,6}` (2026-06-05) to cover date-qualified names (`session-plan-YYYY-MM-DD-S{N}.md` = 4 segments, +1 for pass2 = 5). **Both the canonical and every project-local copy must be updated in lockstep on any filename-format change.**
- `ai-resources/.claude/hooks/detect-concurrent-session.sh` (+ byte-identical project copies: `projects/positioning-research/.claude/hooks/`, `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/`) — SessionStart hook; reads the today-dated per-id marker set (`logs/.session-marker-*`, excluding this session's own) as a **liveness signal** to fire the same-checkout sharp nudge only when an un-wrapped foreign session exists here. Depends on the teardown above to keep the signal accurate — **as of 2026-07-13 that dependency is on the `SessionEnd` hook (harness-enforced), not on `/wrap-session` Step 13 (model-executed, and demonstrably skipped)**; falls back to the legacy shared-marker heuristic when the per-id oracle is unpopulated. **All three copies must be updated in lockstep** (auto-sync does NOT cover hooks). A silent non-match degrades to the soft machine-wide warning, never a block (SessionStart cannot block — see the hook header).

### Doc references (narrative, not consumers)

Documentation that references the plan filename in operator-facing or scaffolding text. Updates required for consistency, but no runtime behavior depends on these:

- `ai-resources/.claude/commands/new-project.md` — scaffolding command reference.
- `ai-resources/.claude/commands/prime.md` (additional sites beyond writer-step entries) — operator-facing chat strings.
- `ai-resources/docs/repo-architecture.md` — canonical file table.
- `ai-resources/docs/compaction-protocol.md` — operator-facing target-file note.
- `ai-resources/docs/heavy-read-discipline.md` — narrative reference.
- `ai-resources/docs/weekly-cadence.md` — Phase D scope-separation narrative.

If you rename `.session-marker` or change the file-naming scheme, update each of these too.

## Mandate-line bullet contract (`- Mission:` split — added 2026-06-09)

The `**Mandate:**` block written under each marker-bearing header (by `session-start.md` Step 3 and `prime.md` Step 8c.7) carries a fixed set of load-bearing labelled bullets (`- Out of scope:`, `- Files in scope:`, `- Stop if:`, `- Allowed inputs:`, `- Required outputs:`) plus two **informational pass-through** bullets that most readers ignore: `- Context pack:` and `- Mission:`.

The **`- Mission: <id>`** bullet (mission-contract subsystem) has a deliberately **split contract**:

- **Pass-through (the fixed-label readers):** `wrap-session.md` Step 7a, workspace-root `wrap-session.md` Step 2b, `contract-check.md` Step 2.5c, and `concurrent-session-check.md` Step 3 — all use fixed-label extraction and silently ignore the bullet. (`monday-prep.md` writes a separate bold-header week-mandate and does not parse this bullet schema at all, so it is unaffected a fortiori.) Adding the bullet cannot break any of them (verified via the `- Context pack:` precedent, DR-9 reader check 2026-06-09).
- **Load-bearing (exactly 1 reader):** **`drift-check.md` Step 7a** reads `<id>`, locates the mission file (`<repo>/logs/missions/<id>.md`, then `ai-resources/logs/missions/<id>.md`), and judges trajectory against its `## Validation contract` as a *second* reference standard. **Degrade-loud contract:** if the id names no readable mission file, `/drift-check` emits one visible notice and falls back to mandate-only — never hard-fails, never silently ignores.
- **Writers:** `session-start.md` Step 1 (strips the `{mission:<id>}` arg prefix passed by `/prime` Step 8m) and `prime.md` Step 8c.7 (auto mode). The bullet originates only from `/prime` Step 8m binding. **No command writes the mission file from inside a session** — only `/mission` mutates `logs/missions/`; this keeps the session hot path free of any concurrent-write to the mission file (risk-check mitigation, `audits/risk-checks/2026-06-09-plan-time-gate-for-the-mission-contracts-subsystem-build.md`).

Changing the `- Mission:` label or the mission-file location requires updating `drift-check.md` Step 7a, both writers, and `/mission`.

---

## Why this protocol exists

See `ai-resources/logs/improvement-log.md` entry "2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files" (lines 73-138). Three commands previously read shared log files, made decisions based on the read, and later wrote back — between read and write, an arbitrary number of conversation turns elapsed during which a concurrent session could write to the same file invisible to the first session's point-in-time mtime guard. Classic TOCTOU race. The structural fix (this protocol) eliminates the shared mutable file: every session writes to its own marker-scoped file; downstream readers either resolve the marker and target only the matching file (writers + targeted consumers) or scan the glob for read-only aggregation.

The Phase 2-only spec attempted a staged rollout with a `logs/session-plan.md` symlink as a Phase-2-to-Phase-3 bridge — that spec received PROCEED-WITH-CAUTION on Hidden Coupling High at risk-check (`audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-phase-2-full-spec.md`). System-owner advisory recommended Option A (atomic Phase 2+3 in one commit, no symlink), which is the design shipped here.

---

## Concurrent-session detection (proactive early-warning layer)

The marker protocol above makes per-session writes safe **structurally**. Two reactive guards detect a foreign write *after* it lands: `session-start.md` Step 0.5 (mtime guard at mandate-read) and `wrap-session.md` Step 3.5 (foreign-write guard at notes-write). As of Option 2′ (2026-06-01), the Step 3.5 detector resolves its marker from the **per-session-id identity oracle** (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`), which a concurrent `/prime` cannot clobber — so the guard's own-contribution attribution is no longer vulnerable to the original clobber race. (`session-start.md` Step 0.5 reads `logs/.prime-mtime`, a different marker, and is outside the Option 2′ oracle.)

> **Detector externalized (2026-07-04 leanness refactor).** The Step 3.5 detector logic described throughout this doc — marker-aware own-contribution attribution (per-id oracle, shared-marker fallback, NO_OWN_MARKER guard, clobber-safe recovery, PRIME_RAN legacy path), the CONCURRENT/REMNANT/MIXED/UNKNOWN classifier, and the id-14 date-rollover grace window — no longer lives inline in the two `wrap-session.md` copies. It is now a single source, **`ai-resources/logs/scripts/foreign-session-guard.sh`**, that both copies (canonical Step 3.5, workspace-root Step 1.5) invoke by walking up to `ai-resources/` (the same ancestor-walk `auto-sync-shared.sh` uses). References below to "the Step 3.5 reader/guard" mean that script. The script's header now carries the PAIRED CONTRACT; the format dependencies on `prime.md` / `session-start.md` / `check-archive.sh` are unchanged. The script writes no files — it reads the caller-cwd `logs/session-notes.md` and echoes the `GUARD:` diagnostic for the command to interpret.

`.claude/hooks/detect-concurrent-session.sh` (SessionStart hook, shipped 2026-06-01, DR-8 gate) adds a **proactive** layer: at session start it warns the operator if another Claude Code session is already running, *before* any write can collide. It supplements — does not duplicate — the two reactive guards (different trigger timing: session-open vs. per-command-write; different mechanism: OS process signal vs. file mtime).

**Read-only by design.** The hook maintains NO state file of its own. A registry built to detect races would itself be a shared-mutable file that races (`principles.md § AP-10`). It reads an OS signal instead: `pgrep -f 'native-binary/claude'` counts running Claude Code CLI sessions (the current session is always in the count, so `>= 2` means `>= 1` other).

**Same-checkout liveness discriminator (2026-06-10 — Fix 1).** To decide between the SHARP same-checkout nudge and the SOFT machine-wide warning, the hook reads the today-dated per-id marker set (`logs/.session-marker-*`, excluding this session's own `${CLAUDE_CODE_SESSION_ID}` file). Because `/prime` creates the per-id marker and `/wrap-session` Step 13 (or `/handoff` continuity Step C3, for a handoff-ended session) removes it, a today-dated foreign per-id marker means an **un-wrapped ≈ live foreign session in THIS checkout** → SHARP. This replaced the original signal (a today-dated *shared* `logs/.session-marker`), which is DATE-pruned not LIVENESS-pruned and therefore stayed set after this operator's OWN earlier session wrapped — false-firing the sharp nudge on every solo same-day re-open. When the per-id oracle is unpopulated the hook falls back to the legacy shared-marker heuristic so the safety net is never lost. Both reads are read-only; the hook still inherits no clobber bug.

**Contract:** non-blocking, every path `exit 0`; loud one-line skip notice if `pgrep` is unavailable (`principles.md § OP-3`, no silent rot). Wired in `.claude/settings.json` SessionStart array alongside `friday-checkup-reminder.sh`. Two byte-identical project copies (`positioning-research`, `research-pe-regime-shift-advisory-gap`) must be re-synced in lockstep on every edit — auto-sync does NOT cover hooks.

**Why it stays a nudge, not a block (verified 2026-06-10 vs the Claude Code hooks docs).** A SessionStart hook CANNOT block a session: on exit code 2 stderr is shown to the user but execution continues, and SessionStart is not among the hook events that can block (`PreToolUse`, `UserPromptSubmit`, `PermissionRequest`, …). The session's cwd is also fixed before any hook runs. So this hook's strongest action is a forceful message the operator can still pass. The actual block of the dangerous move — a cross-session COMMIT that ships a foreign session's staged files — lives in `check-foreign-staging.sh` (a PreToolUse hook, Fix 2). This detector PAIRS WITH that commit-time block as the best-effort early heads-up; it does not replace it.

**Known limitation:** the process count is machine-wide, not project-scoped — a session running in an unrelated project also counts toward the machine-wide signal. The per-id liveness discriminator narrows the SHARP path to genuine same-checkout cases, but the SOFT machine-wide warning is still best-effort. The precise lsof/cwd detector remains deliberately deferred as brittle.

**If you change the detection signal** (`pgrep` pattern, the process-name discriminator `native-binary/claude`, or the marker-read enrichment), update the hook header comment AND this section. The `native-binary/claude` discriminator was verified against the live process table on 2026-06-01; it excludes the Claude.app desktop helper.

## When to update this doc

- A new consumer command starts reading marker-scoped files → add to the registry (writer or read-only auxiliary).
- A consumer's marker handling changes (writer ↔ tolerate-absence) → update its registry entry.
- The marker format changes (e.g., longer than `S{N}`) → update the file-format section AND every consumer body.
- The per-machine vs shared classification changes → update the gitignore and file-naming notes.
