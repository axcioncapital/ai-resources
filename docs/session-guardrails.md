# Session Guardrails

> **When to read this file:** For the full trigger enumeration, exempted-command list, and tuning procedure behind the four advisory flags. The flag names and one-line purposes live in workspace CLAUDE.md; details live here.

Four advisory flags surface session-risk signals in chat. These are self-enforcement rules — no hook, no hard gate, no named confirmation phrase. **All four are advisory: emit the named flag in a single line and continue working — do not stop for a response** (workspace `CLAUDE.md` § Session Guardrails). The flag is a visible signal the operator can act on if they choose; it is not a gate.

The one exception is `[AMBIGUOUS]`, which self-resolves from available context and blocks **only** when the assumption genuinely cannot be resolved and guessing would materially change the output.

Flag tags are stable, parseable strings: `[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]`. Use them verbatim so future telemetry can count fire rates.

**Exempted commands** (for `[HEAVY]` and `[COST]` only — these commands are intentionally context-heavy or multi-subagent by design, and flagging their internal execution is flag-fatigue without signal):
`/token-audit`, `/repo-dd`, `/audit-repo`, `/analyze-workflow`, `/cleanup-worktree`, `/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`, and research-workflow pipeline commands (`run-preparation`, `run-execution`, `run-cluster`, `run-analysis`, `run-synthesis`). When executing inside one of these commands, do not fire `[HEAVY]` on its internal reads/greps/subagent spawns, and do not fire `[COST]` on its internal fan-out.

## `[HEAVY]` — pre-heavy-tool-call and pre-delegation

Fire *before* the tool call, not after. Triggers:
- `Read` with no `limit` on a file known to exceed 500 lines
- `Grep` with a broad pattern, no `glob`/`type` filter, and no `head_limit` below 100
- `Bash` that enumerates a large directory (`ls -R`, recursive `find`, unfiltered `git log`)
- Spawning ≥3 subagents in parallel in a single turn
- A subagent brief that inlines >3 large files or whose expected output exceeds ~10k tokens

Skip outside the exemption list when the action is clearly routine (targeted Grep, single known small file Read, one Explore subagent on a scoped question).

Flag format: `[HEAVY] About to {action}. Signal: {which trigger}. Estimated cost: ~{tokens or "large"}.` Emit and continue — do not wait for a response.

## `[SCOPE]` — scope-creep against the exit condition

Fire when work is drifting past the exit condition set at `/prime`. Triggers:

*Operator-initiated extension:*
- Operator introduces a new task mid-session ("also do X", "while you're at it")
- You propose work outside the exit condition's scope
- A mid-session scope extension has already happened once (second extension = flag harder)

*Claude-initiated drift (no operator ask):*
- You are about to write or edit a file in a project or directory not covered by the exit condition, and no operator turn in the current session named it
- The session mandate is advisory or read-only in character (audit, review, analysis, consultation) but you are about to execute a write, edit, or commit

`[SCOPE]` only fires when an exit condition is logged in `ai-resources/logs/session-notes.md` for the current session. If `/prime` was not run (ad-hoc work), `[SCOPE]` is inactive — do not invent an exit condition to flag against.

Flag format: `[SCOPE] Exit condition was "{X from session notes}". New request: "{Y}". Proceeding — say the word to narrow or defer.` Emit and continue — do not wait for a response.

**Escalation to `/drift-check`:** `[SCOPE]` is a single-signal nudge. When it fires repeatedly in the same session, or when the deviation feels structural (actual work shape no longer matches the mandate) rather than incidental (one extra ask), escalate to `/drift-check` for a full mandate-vs-trajectory comparison with ALIGNED / MINOR-DRIFT / MAJOR-DRIFT verdict.

## `[AMBIGUOUS]` — missing load-bearing specifics at task-naming

Fire at `/prime` step 6 or any task-naming moment if the brief is missing:
- A defined output (target file, success condition, acceptance criterion)
- A count/scope bound on plural nouns ("fix the issues", "update the skills")
- Definitions for terms whose interpretation materially changes scope

Default recovery: flag the assumption inline, attempt self-resolution from project files and loaded context, and proceed. Stop only if the interpretation cannot be determined from available context and guessing would materially change the output. Do not wait for a one-word response unless genuinely unresolvable.

Flag format (default): `[AMBIGUOUS] Assuming: {interpretation}. Proceeding — stop me if wrong.`
Flag format (blocking — only when genuinely unresolvable): `[AMBIGUOUS] Cannot determine: {X}. Needs operator input before proceeding.`

## `[COST]` — cost-escalation mid-session

Fire when the session has already consumed significant budget and more work is being queued. Deterministic triggers only (Claude cannot reliably self-measure token % from inside the model):
- Session has spawned ≥4 subagents (excluding subagents spawned inside exempted commands)
- Session has crossed ~20 turns
- Session has written ≥8 artifacts

`[COST]` handles *when to flag*; the "Pre-compact checkpoint" bullet in workspace CLAUDE.md handles *what to do* (scratchpad + `/clear` over `/compact`).

Flag format: `[COST] Session has spent {subagent count} subagents / {turn count} turns / {artifact count} artifacts. Continuing — checkpoint + /clear + restart is available if you want it.` Emit and continue — do not wait for a response.

## `friction-log: true` — per-command auto-log opt-in

This is a **command frontmatter flag**, not one of the four advisory flags above. The opening paragraph's "Four advisory flags" count is unchanged — this is a separate mechanism documented here because it is structurally adjacent (a session-side behavioral hook).

When a command file (`.claude/commands/<name>.md`) declares `friction-log: true` in its frontmatter, the `PreToolUse` hook `.claude/hooks/friction-log-auto.sh` auto-creates a `## Session —` block in `logs/friction-log.md` the first time that command fires in any 30-minute window. The hook fast-exits silently for any command without the flag, so adding new opt-ins is zero-cost on the per-turn path.

Block shape written by the hook is the canonical:

```
## Session — {YYYY-MM-DD HH:MM}

### Friction Events

#### Write Activity
```

— byte-identical to what `/friction-log` and `/note friction:` emit. The 30-minute dedup window (constant `DEDUP_MINUTES=30` in the hook) prevents double-blocks within the same session window and is a private heuristic, not a load-bearing contract.

**Current opt-in commands:** `cleanup-worktree.md`. **To opt in another command:** add `friction-log: true` to that command's frontmatter — no hook edit required.

## Tuning

Log false positives and missed fires to `ai-resources/logs/improvement-log.md`. After 5–10 sessions, review and tighten or loosen thresholds, or extend the exemption list. If `[HEAVY]` proves unreliable as a self-enforcement rule, promote it to a `PreToolUse` hook in a dedicated session — do not add hooks preemptively.
