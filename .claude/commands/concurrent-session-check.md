---
description: Pre-flight advisory — check whether a task (or the open-items backlog) is safe to start given live concurrent session(s), by file-ownership overlap. Operator-invoked, read-only, never blocks.
model: sonnet
disable-model-invocation: true
argument-hint: "[task description — omit to scan the backlog]"
---

Decide whether it is safe to **start** a new task while another session is already live
in this repo, by comparing the new task's file footprint against what the live session(s)
have already **declared**. This is the planning-time *checker* — the missing piece upstream
of detection (`detect-concurrent-session.sh` nudges that a session is live) and isolation
(`/new-worktree-session` makes a separate checkout).

**What this fixes:** the recurring ad-hoc-second-session collision (Mode A) — every collision
in `audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` came from starting a
second session while one was live, with no check that the two would stay in separate files.

**The key enabler:** a session that ran `/session-start` already wrote its footprint to
`logs/session-notes.md` (the `- Files in scope:` mandate bullet) and `/session-plan` wrote a
plan file. So this command **reads** the live footprint rather than guessing it.

**Read-only and advisory.** This command writes nothing — no markers, no logs, no commits —
and never blocks. It mirrors `/build-context`'s no-write, no-chain posture. A SAFE verdict is
a best-effort recommendation, not a guarantee (see § Honest limits). The operator decides.

**The two modes:**
- **Mode 1 — `/concurrent-session-check <task>`** — test one named task against the live footprints.
- **Mode 2 — `/concurrent-session-check`** (no argument) — scan the `/open-items` backlog and
  return which items are safe to start vs which would collide.

---

## Step 1 — Parse mode

- `$ARGUMENTS` non-empty → **Mode 1**. `TASK = $ARGUMENTS` (verbatim — do not paraphrase).
- `$ARGUMENTS` empty → **Mode 2** (backlog scan).

## Step 2 — Resolve repo + detect live sessions

```bash
REPO_ROOT=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)
[ -z "$REPO_ROOT" ] && { echo "[/concurrent-session-check] Not inside a git repo — cd into the target repo first."; exit 0; }
TODAY=$(date '+%Y-%m-%d')
```

Detect this repo's active sessions from **read-only** signals (never write):

1. **Per-id markers** — `logs/.session-marker-*` whose content starts with `${TODAY}`. Each
   gives a session marker (`S{N}`). These are sessions that primed in this checkout today.
2. **Marker-bearing headers** — `## ${TODAY} — Session S*` headers in `logs/session-notes.md`.
3. **Liveness context** — the machine-wide count `pgrep -f 'native-binary/claude' | wc -l`
   (the same signal `detect-concurrent-session.sh` uses). This tells you *how many* sessions
   are live on the machine, but **not which checkout** — process args carry no cwd, so the
   count can include sessions in unrelated repos. Use it only as context, never as identity.

Exclude this session's own marker (`logs/.session-marker-${CLAUDE_CODE_SESSION_ID}`) from the
"other sessions" set — you are not a collision risk to yourself.

**Graceful — no other session detected.** If no other today-dated session is found, emit and stop:

> No concurrent session detected in this checkout — nothing to collide with; safe to start.
> (If you will run parallel work anyway, still isolate it with `/new-worktree-session` so you
> are not sharing a checkout.)

## Step 3 — Gather LIVE footprints (the declared side)

For **each** other live session detected in Step 2, build its declared footprint. Call that
session's marker `${FOREIGN_MARKER}` — read it from the marker file's contents, do **not** assume a
shape. **Two grammars are live on disk:** the legacy `S{N}` (e.g. `S7`) and the current
`S{N}-{id3}` (e.g. `S7-a4f`, where `id3` is 3 characters of that session's id). Take the marker
token whole; never re-derive it by matching `S` + digits, which truncates `S7-a4f` to `S7` and
silently points every lookup below at the wrong session.

- **Mandate bullet** — under its `## ${TODAY} — Session ${FOREIGN_MARKER}` header in
  `logs/session-notes.md`, read the `- Files in scope:` bullet (the `/session-start` Step 3 parse
  contract; see `docs/session-marker.md` registry).
- **Plan file** — read `logs/session-plan-${TODAY}-${FOREIGN_MARKER}.md` if present; take its
  declared source/scope file list. *(This line previously hardcoded the literal
  `logs/session-plan-${TODAY}-S{N}.md`, which finds nothing once a session's marker carries a
  suffix — the check then reports a live session as having declared no scope, which reads as
  "safe to touch anything". Fixed 2026-07-14 S8.)*
- The session's footprint is the **union** of concrete paths from both.

**HARD GATE — UNKNOWN-SCOPE, never SAFE.** A session can hold a marker (and even a plan file)
but no *resolvable* footprint — `/prime` writes the marker while `/session-start` writes
`- Files in scope:` as a **separate, later** step (`docs/session-marker.md § Asymmetric contract`).
A **primed-but-not-planned** session, or one whose bullet reads `(inferred)` / `(none stated)`
with no concrete paths and no plan-file scope, has declared nothing. **This is the session most
likely to collide and the one this checker is blindest to** — it is the documented #1 failure
(`docs/parallel-sessions-playbook.md § 4`, the 2026-06-05 S6 collision).

→ If **any** live session yields no resolvable footprint, that session is **UNKNOWN-SCOPE**.
A candidate cannot be certified SAFE against an UNKNOWN-SCOPE session. Surface it explicitly:

> Session S{N} is live but has not declared its scope yet (marker present, no readable
> `Files in scope`). Cannot certify safety against it — wait until it has a plan, or coordinate
> by hand. Absence of a declared footprint is **not** an all-clear.

## Step 4 — Predict the CANDIDATE footprint (the predicted side)

- **Mode 1.** Invoke the `context-discovery` agent (same call as `/build-context` Step 3):
  `TASK_DESCRIPTION = TASK`, `CWD_PROJECT = REPO_ROOT`, `INVOCATION_MODE: manual`. Take the
  pack's `files_in_scope` as the candidate footprint. One precise engine call.
- **Mode 2.** Gather candidates via the existing `/open-items` scan (reuse it — do not
  reinvent the backlog read; note `/open-items` is **cwd-scoped**, so the candidate set is
  this project's backlog, not repo-global). For each candidate, predict its footprint by
  **lightweight name-extraction**: most backlog items name their target file or command
  directly (e.g. "fix `/session-start` Step 0.5" → `session-start.md`). Map named commands to
  their `.claude/commands/<name>.md` path and named files to their paths. An item too vague to
  map → mark **footprint unclear**, do not guess. (Engine escalation for a single ambiguous
  high-value item is allowed but not the default — N engine calls is the cost to avoid.)

## Step 5 — Classify overlap (shape-aware)

For each shared path between the candidate footprint and a live session's footprint, classify
by **shape** (`docs/parallel-sessions-playbook.md § 2` table):

| Shape | Files | Verdict contribution |
|-------|-------|----------------------|
| **No shared path** | — | SAFE (this pair) |
| **Append-only log** | `session-notes.md`, `decisions.md`, `usage-log.md`, `improvement-log.md`, `coaching-data.md` | **Expected-shared — not a conflict.** Governed by the marker + append discipline; both sessions' entries survive. Note it, don't flag it. |
| **Content-shaped** | command / doc / skill `.md`, backlog `next-up.md`, indexes (`_master-index.md`) | **Real conflict — flag it** (which file, which session). "Keep both" is the wrong merge rule here. |

**Verdict resolution (per candidate):**
- Any content-shaped overlap with a live session → **COLLIDES**.
- Else if any live session is **UNKNOWN-SCOPE** (Step 3 gate) → **UNKNOWN-SCOPE** (cannot certify).
- Else (every live footprint positively readable **and** positively non-overlapping) → **SAFE**.

SAFE requires *positive* evidence of non-overlap against *every* live session. Absence of
evidence never resolves to SAFE.

## Step 6 — Report (advisory, never blocks)

**Mode 1** — one verdict for the task:
- **SAFE** — no content overlap with any live session, all live footprints readable. Then nudge:
  > Safe by file-ownership against the live session(s). Now isolate the checkout: run
  > `/new-worktree-session` so you are not sharing a working tree (file-safe ≠ checkout-safe).
- **COLLIDES** — name the file(s), the session(s), and the shape.
- **UNKNOWN-SCOPE** — name the undeclared live session(s); cannot certify.

Always show the **predicted candidate footprint** so the operator can correct it before trusting
the verdict.

**Mode 2** — three groups from the backlog: **Safe to start**, **Would collide** (annotated with
file + session), and **Footprint unclear** (could not map — treat as unknown, not safe). Show the
live session(s) and their footprints the split was computed against.

**Both modes:**
- State plainly that the verdict is **advisory and best-effort** — predicted footprints (and
  Mode-2 name-extraction especially) can under-predict; a live session can also wander past its
  declared `Files in scope` (it is a floor, not a ceiling — though when the Context Engine ran
  the footprint is concrete paths, not the degraded `(inferred)` case). Verify before parallel work.
- For the *staging* side of concurrent safety (explicit-path `git add`, no wildcards while another
  session is open), point at `docs/commit-discipline.md § Concurrent-session staging discipline` —
  do not restate it.

## Step 7 — Wait. Never chain, never block, never write.

Like `/build-context`: do not chain into `/new-worktree-session`, `/session-start`, or any
session-init flow. Do not begin the candidate work. The command writes nothing. The operator
decides what to do with the verdict.

---

## Honest limits (state these in the output, do not hide them)

1. **"Safe" = safe per what the live session *declared*.** A session can edit files it never
   listed. Strong advisory, not a guarantee.
2. **The candidate footprint is a prediction** — shown so the operator can correct it.
3. **File-safe ≠ checkout-safe** — a non-overlapping task still shares one working tree if run in
   the same checkout. Always nudge to a worktree on SAFE.
4. **Liveness is machine-wide, identity is marker-based.** The `pgrep` count can include unrelated
   repos; session identity comes only from this checkout's today-dated markers.

---

**This command checks; it does not own the parallel-session discipline and does not spawn
worktrees.** `docs/parallel-sessions-playbook.md` is the authority for decomposition,
file-ownership maps, landing, and teardown. `/new-worktree-session` does the isolation;
`detect-concurrent-session.sh` does the live nudge at session start. This command is the
planning-time checker upstream of all three. It adds **no** shared-mutable state — it reads
existing signals and writes nothing (the rejected "session-registry" anti-pattern is exactly
what this is not).
