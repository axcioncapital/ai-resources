# Session Marker Protocol

Single-source contract for the per-session identity marker (`.session-marker`) and the marker-scoped log file naming used by `/prime`, `/session-start`, `/session-plan`, and their downstream consumers.

Shipped: 2026-05-29 atomic Phase 2+3 commit (Option A per system-owner advisory). Phase 1 (write-only marker) precedent: commit `ea93d62` (2026-05-28). Replaces the pre-Phase-2 shared `logs/session-plan.md` and bare `## YYYY-MM-DD` session-notes headers — each session now writes to its own marker-scoped plan file and under its own marker-bearing header.

Source proposal: `ai-resources/logs/improvement-log.md` lines 73-138 ("Concurrent sessions cause TOCTOU races on shared log files").

---

## Marker file

**Path:** `logs/.session-marker` (cwd-relative, in the git root of the active project / ai-resources).

**Format:** one line: `{YYYY-MM-DD} S{N}` — e.g., `2026-05-30 S1`.

**Gitignore:** YES. Per-machine session state, not committed. Already present in `.gitignore` (from Phase 1 commit `ea93d62`).

**Lifetime:** written by `/prime` at session start. Overwritten by `/prime` on same-day re-invocation (`S1` → `S2` → ...). A new day resets to `S1`.

---

## Marker resolution (canonical pattern — every consumer uses this shape)

```bash
TODAY=$(date '+%Y-%m-%d')
if [ -f logs/.session-marker ]; then
  CONTENT=$(cat logs/.session-marker)
  FILE_DATE="${CONTENT%% *}"
  if [ "$FILE_DATE" = "$TODAY" ]; then
    MARKER="${CONTENT##* }"
  else
    MARKER=""  # stale (different day)
  fi
else
  MARKER=""  # absent
fi
```

If `MARKER` is empty after this block, the consumer chooses handling per role (see asymmetric contract below).

---

## Asymmetric writer/reader contract

**Writers** (must HARD-FAIL on marker absent/stale):

- `/prime` — only command authorized to create the marker.
- `/session-start` — appends mandate under marker-bearing header.
- `/session-plan` — writes marker-scoped plan file.

Hard-fail shape (single loud line per `principles.md § OP-3`):

> `[/{command} Step {N}] HARD-FAIL: logs/.session-marker absent or stale. Run /prime to populate the marker for this session, then retry.`

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
| Session plan (canonical) | `logs/session-plan.md` | `logs/session-plan-${MARKER}.md` |
| Session plan (re-invocation fork) | `logs/session-plan-pass2.md` | `logs/session-plan-${MARKER}-pass2.md` |
| Session notes header | `## YYYY-MM-DD` | `## YYYY-MM-DD — Session ${MARKER}` |
| Session notes file | `logs/session-notes.md` (shared) | `logs/session-notes.md` (shared; marker disambiguates by header) |

The session notes file remains shared across sessions; the marker disambiguates by header text, not by filename. `^## YYYY-MM-DD` greps still match marker-bearing headers (unanchored at end of line); existing consumers that scan by date continue to work.

**Tracking policy:** `logs/session-plan-S*.md` files are tracked in git (per-session plan history, parallel to `logs/session-notes.md`'s tracking). Not gitignored.

---

## Two-end contract registry

Every place the marker contract is consumed must point back to this doc. Adding or changing a consumer requires updating this list.

**Writers** (hard-fail on marker absent/stale):

- `ai-resources/.claude/commands/prime.md` — Steps 8a.3.a / 8b.3.a / 8c.3 (marker write + header) and Step 8c.8 (auto-mode plan write).
- `ai-resources/.claude/commands/session-start.md` — Step 3 (header location).
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
- `ai-resources/.claude/hooks/backup-session-plan.sh` — comment text. Behavior already marker-aware via regex.
- `ai-resources/docs/heavy-read-discipline.md` — narrative reference.
- `ai-resources/docs/weekly-cadence.md` — Phase D scope-separation narrative.

If you rename `.session-marker` or change the file-naming scheme, update each of these too.

---

## Why this protocol exists

See `ai-resources/logs/improvement-log.md` entry "2026-05-28 — Concurrent sessions cause TOCTOU races on shared log files" (lines 73-138). Three commands previously read shared log files, made decisions based on the read, and later wrote back — between read and write, an arbitrary number of conversation turns elapsed during which a concurrent session could write to the same file invisible to the first session's point-in-time mtime guard. Classic TOCTOU race. The structural fix (this protocol) eliminates the shared mutable file: every session writes to its own marker-scoped file; downstream readers either resolve the marker and target only the matching file (writers + targeted consumers) or scan the glob for read-only aggregation.

The Phase 2-only spec attempted a staged rollout with a `logs/session-plan.md` symlink as a Phase-2-to-Phase-3 bridge — that spec received PROCEED-WITH-CAUTION on Hidden Coupling High at risk-check (`audits/risk-checks/2026-05-29-plan-time-gate-for-toctou-mitigation-phase-2-full-spec.md`). System-owner advisory recommended Option A (atomic Phase 2+3 in one commit, no symlink), which is the design shipped here.

---

## When to update this doc

- A new consumer command starts reading marker-scoped files → add to the registry (writer or read-only auxiliary).
- A consumer's marker handling changes (writer ↔ tolerate-absence) → update its registry entry.
- The marker format changes (e.g., longer than `S{N}`) → update the file-format section AND every consumer body.
- The per-machine vs shared classification changes → update the gitignore and file-naming notes.
