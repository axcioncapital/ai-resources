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

- `ai-resources/.claude/commands/prime.md` — Steps 8a.3.a / 8b.3.a / 8c.3 (writes BOTH the shared file and the per-session-id identity oracle `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`, plus orphan-prune of stale per-id files) and Step 8c.8 (auto-mode plan write).
- `ai-resources/.claude/commands/session-start.md` — Step 3 (header location; resolves marker per-id-first).
- `ai-resources/.claude/commands/session-plan.md` — Step 0 (header gate) and Step 7 (plan write).

**Read-only auxiliary consumers** (tolerate marker absent/stale):

- `ai-resources/.claude/commands/contract-check.md` — Step 2b (plan source resolution).
- `ai-resources/.claude/commands/drift-check.md` — Step 3 (locate plan), Step 6 (mandate disambiguation), Step 7 (no-mandate abort), Step 8 (conflict reporting).
- `ai-resources/.claude/commands/open-items.md` — table rows for `session-plan-*.md` glob scan.
- `ai-resources/.claude/agents/fix-repo-issues-scanner.md` — table rows + read-only list.
- `ai-resources/.claude/commands/decide.md` — Step 2 prior-decision read.

### Doc references (narrative, not consumers)

Documentation that references `session-plan-{marker}.md` in operator-facing or scaffolding text. Updates required for consistency, but no runtime behavior depends on these:

- `ai-resources/.claude/commands/new-project.md` — scaffolding command reference.
- `ai-resources/.claude/commands/prime.md` (additional sites beyond writer-step entries) — operator-facing chat strings.
- `ai-resources/docs/repo-architecture.md` — canonical file table.
- `ai-resources/docs/compaction-protocol.md` — operator-facing target-file note.
- `ai-resources/.claude/hooks/backup-session-plan.sh` — comment text + regex cap. Regex widened to `{0,6}` (2026-06-05) to cover date-qualified names (`session-plan-YYYY-MM-DD-S{N}.md` = 4 segments, +1 for pass2 = 5); canonical + research-pe project copies both updated.
- `ai-resources/docs/heavy-read-discipline.md` — narrative reference.
- `ai-resources/docs/weekly-cadence.md` — Phase D scope-separation narrative.

If you rename `.session-marker` or change the file-naming scheme, update each of these too.

---

## Why this protocol exists

See `ai-resources/logs/improvement-log.md` entry "2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files" (lines 73-138). Three commands previously read shared log files, made decisions based on the read, and later wrote back — between read and write, an arbitrary number of conversation turns elapsed during which a concurrent session could write to the same file invisible to the first session's point-in-time mtime guard. Classic TOCTOU race. The structural fix (this protocol) eliminates the shared mutable file: every session writes to its own marker-scoped file; downstream readers either resolve the marker and target only the matching file (writers + targeted consumers) or scan the glob for read-only aggregation.

The Phase 2-only spec attempted a staged rollout with a `logs/session-plan.md` symlink as a Phase-2-to-Phase-3 bridge — that spec received PROCEED-WITH-CAUTION on Hidden Coupling High at risk-check (`audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-phase-2-full-spec.md`). System-owner advisory recommended Option A (atomic Phase 2+3 in one commit, no symlink), which is the design shipped here.

---

## Concurrent-session detection (proactive early-warning layer)

The marker protocol above makes per-session writes safe **structurally**. Two reactive guards detect a foreign write *after* it lands: `session-start.md` Step 0.5 (mtime guard at mandate-read) and `wrap-session.md` Step 3.5 (foreign-write guard at notes-write). As of Option 2′ (2026-06-01), `wrap-session.md` Step 3.5 resolves its marker from the **per-session-id identity oracle** (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`), which a concurrent `/prime` cannot clobber — so the guard's own-contribution attribution is no longer vulnerable to the original clobber race. (`session-start.md` Step 0.5 reads `logs/.prime-mtime`, a different marker, and is outside the Option 2′ oracle.)

`.claude/hooks/detect-concurrent-session.sh` (SessionStart hook, shipped 2026-06-01, DR-8 gate) adds a **proactive** layer: at session start it warns the operator if another Claude Code session is already running, *before* any write can collide. It supplements — does not duplicate — the two reactive guards (different trigger timing: session-open vs. per-command-write; different mechanism: OS process signal vs. file mtime).

**Read-only by design.** The hook maintains NO state file of its own. A registry built to detect races would itself be a shared-mutable file that races (`principles.md § AP-10`). It reads an OS signal instead: `pgrep -f 'native-binary/claude'` counts running Claude Code CLI sessions (the current session is always in the count, so `>= 2` means `>= 1` other). It reads `logs/.session-marker` only as read-only enrichment context (to note whether THIS project has a `/prime` marker today) — never as the detection signal, so it cannot inherit the clobber bug.

**Contract:** non-blocking, every path `exit 0`; loud one-line skip notice if `pgrep` is unavailable (`principles.md § OP-3`, no silent rot). Wired in `.claude/settings.json` SessionStart array alongside `friday-checkup-reminder.sh`.

**Known limitation:** the process count is machine-wide, not project-scoped — a session running in an unrelated project also counts toward the warning. Accepted best-effort tradeoff for a non-blocking warning. Future enhancement: scope by cwd via `lsof`.

**If you change the detection signal** (`pgrep` pattern, the process-name discriminator `native-binary/claude`, or the marker-read enrichment), update the hook header comment AND this section. The `native-binary/claude` discriminator was verified against the live process table on 2026-06-01; it excludes the Claude.app desktop helper.

## When to update this doc

- A new consumer command starts reading marker-scoped files → add to the registry (writer or read-only auxiliary).
- A consumer's marker handling changes (writer ↔ tolerate-absence) → update its registry entry.
- The marker format changes (e.g., longer than `S{N}`) → update the file-format section AND every consumer body.
- The per-machine vs shared classification changes → update the gitignore and file-naming notes.
