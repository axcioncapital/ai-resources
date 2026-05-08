---
date: 2026-05-08
type: investigation
status: design-complete-pending-implementation
sources:
  - projects/global-macro-analysis/logs/friction-log.md (2026-05-07 14:28 event)
  - projects/global-macro-analysis/logs/improvement-log.md (2026-05-08 entries 1+3)
  - ai-resources/audits/friday-journal-2026-05-08.md (J16)
risk_check_required: yes (Hook edits + Shared-state automation per audit-discipline.md)
implementation_owner: next session (separate from this investigation)
---

# Concurrent-session guardrail — investigation and design

## 1. Why this exists

On **2026-05-07 14:28**, two Claude Code sessions were active in `projects/global-macro-analysis/` simultaneously. One session ran `/kb-synthesize central-bank-credibility`. Between its Read of `_synthesis.md` and its subsequent `cp` to `_history/`, the other session wrote a complete regenerated synthesis to the same path. The archive step (`cp` via Bash) captured the externally-written content under the original date filename. Claude Code's built-in "file modified since read" check then blocked the follow-on Write tool call, so disk state recovered, but only because:

1. The write tool fired after the cp tool (cp is unprotected; Write is protected).
2. The original 2026-05-06 synthesis was recoverable from `git show HEAD:macro-kb/central-bank-credibility/_synthesis.md`.

If the order had been reversed, or if the conflicting write had landed via Bash, work would have been silently lost.

This is **not** a hypothetical. Workflow patterns now produce the race regularly: `/kb-synthesize` and `/kb-populate` are both long-running, theme-scoped, and operator-parallelizable. The friction was logged as IL entry #1 (in-command hash check) and IL entry #3 (concurrent-session hook) in `projects/global-macro-analysis/logs/improvement-log.md`.

## 2. Threat model — what actually races

### 2.1 Claude Code's built-in protection covers Edit/Write tool calls only

Claude Code tracks the mtime of files the current session has read. If an Edit/Write tool call targets a file whose on-disk mtime advanced after the read, the tool errors with "file modified since last read." This protection has three blind spots:

1. **Bash subprocess writes** (`cp`, `mv`, `cat > file`, `echo >>`, `sed -i`). Built-in tracking is per-session; subprocess output via Bash is not checked against the read-mtime.
2. **Cross-session writes**. Each session tracks its own reads only. Session A's Read does not register in Session B's mtime table.
3. **First-write-wins on new files**. If two sessions both create the same file (no prior Read by either), neither built-in check fires.

### 2.2 Race surfaces in the global-macro-analysis KB workflow

| Command | Read paths | Write paths | Race vector |
|---|---|---|---|
| `/kb-synthesize` | `<theme>/_synthesis.md`, all `<theme>/*.md` entries | `<theme>/_synthesis.md`, `<theme>/_history/{date}.md` | The fired race: cp archive captures wrong content; Write blocked but archive corrupted. |
| `/kb-review` | `_staging/batch-*.yaml` | theme folders (mv), `_meta/index.json`, `_meta/changelog.md`, `_meta/changelog.json` | Two sessions reviewing different batches concurrently both append to `index.json` / `changelog.*` — last-write-wins on shared metadata. |
| `/kb-populate` | `_inbox/`, taxonomy | `_staging/*` | Concurrent ingests can both write `batch-{date}-NNN.yaml` if NNN auto-increments without a lock. |
| `/kb-ingest`, `/kb-cross-theme`, etc. | varies | `_meta/*` shared metadata | Same shared-metadata last-write-wins risk. |

### 2.3 Risk severity ranking

- **HIGH** — `/kb-synthesize` archive race (silent corruption of `_history/` is the worst case; recoverable only via git).
- **MEDIUM** — `/kb-review` and `/kb-populate` shared-metadata last-write-wins (data loss is small per write — one entry, one changelog line — but accumulates silently).
- **LOW** — read-only commands (`/kb-query`, `/kb-audit`, `/kb-stale`). Not race vectors.

## 3. Guardrail options evaluated

The operator's J16 brief proposed three options: (a) file-system advisory lock, (b) session-id stamp in shared JSON, (c) warn-only SessionStart hook. Two more options surfaced during analysis: (d) in-command hash check (already proposed in IL #1), (e) PreToolUse mtime hook for KB write paths. Option (f) "detect-and-recover only" is the no-op baseline.

### Option A — File-system advisory lock (flock-style)

**Mechanism.** Before any write to shared KB state, a hook acquires an exclusive lock file under `macro-kb/_meta/.locks/{theme-or-meta}.lock`. The lock contains `session-id + pid + timestamp`. On conflict, abort with "Another session holds this lock." Locks are released by a Stop hook or by a stale-age check (>10 min idle).

**Pros.** True mutual exclusion. Covers both Edit/Write and Bash cp via PreToolUse hook. Standard Unix mechanism.

**Cons.**
- **Lock-lifecycle mismatch.** Claude Code's PreToolUse hook fires once per tool call; there is no "session holds this lock for the duration of /kb-synthesize" semantic. Re-acquiring per tool call defeats the purpose. Holding past tool-call boundaries requires a Stop hook to release — but Stop hook does not fire on Claude Code crashes, leaving stale locks.
- **Stale-lock complexity.** Operator-facing failure mode "lock held by session that died" is more confusing than the original race.
- **Granularity trade-off.** Theme-level locks miss cross-theme `_meta/index.json` collisions. Repo-level locks block legitimate parallel work.

**Verdict.** Reject. Implementation cost high; operator-facing failure modes worse than the disease.

### Option B — Session-id stamp in shared `.claude/active-sessions.json`

**Mechanism.** SessionStart hook writes `{session-id, pid, project-path, started-at}` to `~/.claude/active-sessions.json`. Stop hook removes the entry. Before every Edit/Write/Bash, a PreToolUse hook reads the JSON; if other entries match the current project-path, warn or block.

**Pros.** Cross-session visibility. Listing other active sessions is actionable for the operator.

**Cons.**
- **TOCTOU race.** Check passes at hook-fire time; Session B starts after the check, before the write. Hook does not actually prevent the race it claims to.
- **Stale entries on crash.** Same problem as Option A — no Stop hook on crash.
- **Per-tool overhead.** Every Edit/Write/Bash reads and parses a JSON file. At scale this is observable cost.

**Verdict.** Reject as a primary defense. Has no advantage over Option C (warn-only) without taking on Option A's lock-lifecycle costs.

### Option C — Warn-only SessionStart hook

**Mechanism.** SessionStart hook runs `pgrep -af claude` (or platform equivalent) and reports count of other Claude Code processes whose cwd matches this project. If count > 0, emit a banner:

```
[concurrent-session] Another Claude Code session is active in this project (PID 12345, started 14:25). Concurrent writes to macro-kb/ shared state can race silently. Recovery: git show HEAD:<path>.
```

**Pros.**
- Zero state files. No locks. No JSON to maintain.
- No new race window introduced.
- Operator-awareness benefit: most concurrent-session events are accidental and the operator simply did not realize they had two terminals open.
- Trivial to implement and to disable per-project.

**Cons.**
- Does **not** prevent the race.
- `pgrep` matching is fragile across platforms (works on macOS; Linux Claude Code may have different process names).

**Verdict.** Accept as a secondary defense. Cheap, additive, no risk of making things worse.

### Option D — In-command hash check (per-command surgical fix)

**Mechanism.** In each command that writes shared state, add a step:

1. After Read, compute SHA-256 of the file content as read.
2. Immediately before any destructive write (cp, Edit, Write), recompute SHA-256 from disk.
3. On mismatch, abort with: `concurrent write detected on <path> — another session modified this file between this command's Read and Write. Recovery: git status; git restore <path> if needed.`

For `/kb-synthesize` Step 5, this means:
- 5a. Read `_synthesis.md`, capture SHA at read time.
- 5b. Recompute SHA from `_synthesis.md` on disk; abort if mismatch.
- 5c. Cp `_synthesis.md` → `_history/{date}.md`.

For `/kb-review` shared-metadata writes (`_meta/index.json`, `_meta/changelog.json`):
- Read file, capture SHA.
- Before append, recompute SHA. On mismatch, abort.

**Pros.**
- **Surgical and effective.** Closes the exact race that fired.
- **No global state.** Each command checks only the files it touches.
- **Loud failure.** Aligns with operator preference (SO Rec 2: prefer loud failure over silent continuation).
- **Generalizable pattern.** The same `read-SHA / verify-before-write` template applies to any KB command.

**Cons.**
- Per-command implementation. Each KB command that writes shared state must be edited.
- Doesn't catch races introduced by future commands unless the pattern is added.

**Verdict.** Accept as the primary defense. This is the durable fix.

### Option E — PreToolUse hook for KB write paths (mtime check)

**Mechanism.** PreToolUse hook intercepts Edit/Write/Bash. For tool calls that target paths under `macro-kb/**`, check on-disk mtime against a session-start marker file. If mtime > session-start AND this session did not write it, abort.

**Pros.** Generalizes across all KB write paths without per-command edits. Catches Bash cp.

**Cons.**
- **Implementation complexity.** The hook must track which files this session has written (otherwise its own writes trip the check). That requires per-session state, which puts us back into Option A/B territory.
- **False positives.** Legitimate sequence "Session edits file in editor, then Claude resumes" trips the check.

**Verdict.** Reject. Complexity exceeds Option D for marginal coverage gain.

### Option F — Detect-and-recover only (no-op baseline)

**Mechanism.** Accept races. Document the recovery one-liner (`git show HEAD:<path>`) in CLAUDE.md.

**Pros.** Zero infrastructure. Already partially in place — the 2026-05-07 event recovered cleanly via git.

**Cons.** Operator must remember discipline. The friction event happened anyway because the failure was silent until the secondary safety check fired.

**Verdict.** Already in place implicitly. Make it explicit as a CLAUDE.md note alongside Option D, but do not rely on it as the sole defense.

## 4. Recommendation — composite defense (D + C + F-as-doc)

The right answer is not a single option but a **layered defense** with clear roles per layer:

| Layer | Option | Role | Effort |
|---|---|---|---|
| 1. Prevent (primary) | **D — in-command hash check** | Closes the fired race surgically and verifiably. | Low per command; ~2 commands matter (`/kb-synthesize`, `/kb-review`). |
| 2. Detect (secondary) | **C — warn-only SessionStart hook** | Awareness for accidental concurrent-session situations. | Low; one shell script + settings.json wiring. |
| 3. Recover (tertiary) | **F — git-based recovery** | Documented as the operator-facing recovery procedure. | Trivial; one CLAUDE.md addition. |

Reject A, B, E. None of them is cheaper than D for the actual race that fired, and all three introduce operational baggage (lock files, stale-entry cleanup, per-tool overhead).

## 5. Pilot plan

Pilot Layer 1 (Option D) and Layer 2 (Option C) **in `projects/global-macro-analysis/` only**. Do not graduate to ai-resources or other projects until ≥4 weeks of usage shows the pattern is stable.

### 5.1 Layer 1 — Option D in `/kb-synthesize`

Edit `projects/global-macro-analysis/.claude/commands/kb-synthesize.md` Step 5:

```
5. **If existing synthesis exists:**
   a. Read the current `_synthesis.md`. Capture SHA-256 of its on-disk content
      via `shasum -a 256 macro-kb/{theme}/_synthesis.md` and store in memory as
      sha_at_read.
   b. Extract `last_updated` from frontmatter.
   c. Recompute SHA-256 of `macro-kb/{theme}/_synthesis.md` on disk.
      If sha_at_read != sha_now: abort with
        "concurrent write detected on macro-kb/{theme}/_synthesis.md —
         another session modified this file. Recovery: git status; git
         restore <path> if needed."
   d. Copy current `_synthesis.md` → `macro-kb/{theme}/_history/{last_updated}.md`.
   e. Announce: "Archived previous synthesis to _history/{date}.md"
```

Apply the same pattern at Step 12 (final Write) — recompute SHA before write, abort on mismatch.

### 5.2 Layer 1 — Option D in `/kb-review`

Edit `projects/global-macro-analysis/.claude/commands/kb-review.md` Steps 7c, 8, 9 (writes to `index.json`, `changelog.md`, `changelog.json`). Pattern: capture SHA at first read of each shared file; recompute before each append; abort on mismatch.

### 5.3 Layer 2 — Option C SessionStart hook

Create `projects/global-macro-analysis/.claude/hooks/check-concurrent-session.sh`:

```bash
#!/usr/bin/env bash
# SessionStart hook — warn if another Claude Code session is active in this project.
project_path="$(pwd)"
my_pid=$$
# pgrep -af outputs "PID full-command-line"; filter to claude processes
# in this project_path that aren't us.
others=$(pgrep -af "claude" | grep -F "$project_path" | grep -v "^$my_pid " || true)
if [ -n "$others" ]; then
    cat >&2 <<EOF
[concurrent-session] Another Claude Code session appears active in this project:
$others
Concurrent writes to macro-kb/ shared state can race silently.
Recovery if a race fires: git status; git show HEAD:<path>; git restore <path>.
EOF
fi
```

Wire in `projects/global-macro-analysis/.claude/settings.json` under `hooks.SessionStart`.

### 5.4 Layer 3 — CLAUDE.md doc addition

Add a short section to `projects/global-macro-analysis/CLAUDE.md`:

```
## Concurrent-session safety

The KB workflow has shared-state write paths (`_synthesis.md`, `_history/`,
`_meta/index.json`, `_meta/changelog.*`). Two concurrent sessions writing
to these can race silently.

Defenses in place:
- /kb-synthesize and /kb-review check SHA at read+write boundaries
  (in-command guard).
- SessionStart hook warns if another Claude Code session is active in
  this project (advisory only).

If a race fires (e.g., wrong content in _history/<date>.md), recover via
git: `git show HEAD:<path>` to inspect, `git restore <path>` to revert.
```

## 6. Effort and risk gating

| Item | Effort | /risk-check required? |
|---|---|---|
| Option D in `/kb-synthesize` | 30 min | No (command-edit only, no permission/architecture change) |
| Option D in `/kb-review` | 30 min | No (same) |
| Option C SessionStart hook | 45 min | **Yes** — Hook edits class per audit-discipline.md |
| Settings.json wiring | 15 min | Bundled with hook /risk-check |
| CLAUDE.md doc addition | 15 min | No (project CLAUDE.md, not workspace) |
| **Total implementation** | ~2.5 hours | One bundled /risk-check (Hook edits + Shared-state automation) |

## 7. Post-pilot review checkpoints

After 4 weeks of pilot use in `projects/global-macro-analysis/`, evaluate at the next monthly Friday cadence:

1. Did Option D ever abort a real race? How many times? (Count in friction-log.)
2. Did Option C ever surface another active session? Did the operator find it useful? (Operator self-report.)
3. Were there false positives on Option D (legitimate edits flagged as races)? If yes, refine the SHA-check semantics.
4. Are other projects' workflows showing the same shared-state race vector? (e.g., `buy-side-service-plan` if it has analogous shared-metadata writes.) If yes, graduate the pattern to `ai-resources/skills/` or `ai-resources/.claude/hooks/`.

## 8. What this investigation does NOT cover

- **Multi-tenant repo coordination beyond Claude Code.** External editor edits are still uncoordinated. The git workflow already covers this.
- **Claude Code internal session-isolation features.** If Anthropic ships a built-in concurrent-session detector, this guardrail can be retired. Check at next quarterly cadence.
- **Implementation in projects other than global-macro-analysis.** Out of scope for the pilot. Re-enter at the 4-week review.

## 9. Next steps

1. Schedule a separate implementation session (≤3 hours) covering all four pilot items above.
2. Run `/risk-check` at the start of that session for the bundled "Hook edits + Shared-state automation" change.
3. After implementation, log the pilot start date so the 4-week review trigger is anchored.
4. Remove the J16 reminder memory (`memory/project_j16_today_reminder.md`) once this investigation is filed — its purpose (surface J16 today) is now met.
