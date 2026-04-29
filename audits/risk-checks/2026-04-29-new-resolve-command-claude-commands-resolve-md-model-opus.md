# Risk Check — 2026-04-29

## Change

End-time risk check on the change set executed this session: a new `/resolve` slash command + two new shell hooks + a settings.json modification.

1. **New `/resolve` command** at `.claude/commands/resolve.md` (model: opus). Takes QC findings from recent conversation context, translates them into the `triage-reviewer` subagent's input format, runs the existing triage-reviewer, maps Do/Park/Parked-by-scope back to Real/Low-signal/Skip, then has the main session draft concrete fixes for Real items. Operator approves and executes. Step 10 of the command sets a session marker `/tmp/claude-resolve-executing-$PPID` before fix execution and removes it after, so the auto-QC hook can suppress itself during fix execution.

2. **New PostToolUse hook** at `.claude/hooks/auto-qc-nudge.sh` (matcher `Write|Edit`). Fires on every Write/Edit. Skip conditions: `/tmp/claude-resolve-executing-$PPID` exists, file path matches noise regex (`friction-log|improvement-log|session-notes|innovation-registry|usage-log|audits/working/`), file < 50 lines, file dedup sentinel already exists for this session (`/tmp/claude-auto-qc-{cksum-of-path}-$PPID`). When all gates pass: emits `systemMessage` JSON nudging Claude to run `/qc-pass`, also creates `/tmp/claude-qc-ran-$PPID` signal for the auto-resolve hook. Always exits 0.

3. **New Stop hook** at `.claude/hooks/auto-resolve-nudge.sh`. Only fires if `/tmp/claude-qc-ran-$PPID` exists (set by the auto-QC hook). Dedup: one nudge per session via `/tmp/claude-resolve-nudged-$PPID`. Emits `systemMessage` JSON nudging Claude to run `/resolve`. Always exits 0.

4. **settings.json** at `.claude/settings.json` modified to register both hooks: auto-qc-nudge added inside the existing `Write|Edit` PostToolUse block (alongside `log-write-activity.sh`); auto-resolve-nudge added as a third Stop hook group (after the two existing groups: check-stop-reminders + coach-reminder/improve-reminder).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-qc-nudge.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-resolve-nudge.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Architecture is sound and reuses established patterns ($PPID dedup sentinels, systemMessage JSON, advisory exit-0 hooks), but a doc-contract drift in `triage-reviewer.md` and a hook-coupling chain across PostToolUse → Stop introduce one High dimension (Hidden Coupling) that needs a paired mitigation before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New `/resolve` command is pay-as-used — only loads when the operator invokes it. Frontmatter `model: opus` (resolve.md:2) means it's a high-tier command but invocation is operator-initiated, not auto-loaded.
- `auto-qc-nudge.sh` runs PostToolUse on every Write|Edit but is gated heavily: short-circuits on missing path, `/resolve`-executing marker, noise regex, files <50 lines, and per-session per-file dedup sentinel (auto-qc-nudge.sh:8, 11, 14, 19, 25). Worst case it forks bash, runs `jq`, `grep`, `wc`, `cksum`, `awk`, and `touch` — small fixed cost per Write|Edit, no token cost (only the systemMessage at first significant write per file).
- `auto-resolve-nudge.sh` is gated on `/tmp/claude-qc-ran-$PPID` existing (auto-resolve-nudge.sh:12); zero runtime in sessions where no significant write happened. One-shot per session via dedup sentinel (line 15-17).
- No `@import` chains added; no CLAUDE.md edits; no skill/agent description broadening that would auto-match more contexts.
- Triage-reviewer subagent is reused — no new agent brief loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- `settings.json` permissions block (allow/deny/defaultMode) is unchanged in the diff: only the `hooks` object is modified (settings.json:25–119). The pre-existing surface (`Bash(*)` allow, `Bash(rm -rf *)` and `Bash(git push*)` denies, `bypassPermissions` default) is untouched.
- New hooks run via `bash $CLAUDE_PROJECT_DIR/.claude/hooks/...` — same pattern as the eight existing registered hooks; no new tool family invoked.
- `touch /tmp/...` and `rm -f /tmp/...` in `/resolve` Step 10 (resolve.md:41) fall under existing `Bash(*)` allow with `Bash(rm -rf *)` deny — `rm -f` on a single file is permitted and not a deny-list match.
- No cross-repo or external API capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- New files are isolated: 41 lines (resolve.md), 33 lines (auto-qc-nudge.sh), 20 lines (auto-resolve-nudge.sh).
- `settings.json` modification is additive: one entry added inside an existing PostToolUse `Write|Edit` block, one new top-level Stop hook group added — does not modify existing hook entries (settings.json:50–67, 96–105).
- Grep enumeration of references inside `ai-resources/`:
  - `auto-qc-nudge` / `auto-resolve-nudge` — referenced in `settings.json` (registration), in the two hook files themselves (cross-references between PostToolUse and Stop chains via `/tmp/claude-qc-ran-$PPID`), and in `logs/session-notes.md` (descriptive). Outside this set: a single mention in a prior risk-check report (2026-04-29-new-slash-command-session-plan-added). Total non-trivial callers: 0.
  - `/resolve` slash command — referenced by `auto-resolve-nudge.sh` (the nudge text) and `auto-qc-nudge.sh` (the suppression marker name). Pre-existing `resolve-improvements.md` is a separate command (different filename, different purpose) — no naming collision with `resolve.md`.
  - `triage-reviewer` agent — `resolve.md` Step 4 calls it; the agent's frontmatter description currently says "Invoked by /triage. Do not use for other purposes." (triage-reviewer.md:3). This is a doc-contract drift — see Dimension 5.
- No existing command's contract changes. `/qc-pass` is referenced as a prerequisite by `/resolve` but is not modified.
- `/resolve` Step 10 introduces a side-effect contract (touch/rm a file in `/tmp`) but it is internal to the new code and the suppression marker is documented in both the command and the consuming hook (resolve.md:41, auto-qc-nudge.sh:10–11).

### Dimension 4: Reversibility
**Risk:** Low

- `git revert` of the commit cleanly removes the three new files (resolve.md, auto-qc-nudge.sh, auto-resolve-nudge.sh) and restores the prior `settings.json`. No append-only log mutations within the change set itself (logs/session-notes.md is updated descriptively but is an append-log by design).
- After revert, residual `/tmp/claude-{auto-qc,resolve-executing,qc-ran,resolve-nudged}-*` files would persist on disk but are PPID-keyed — they self-evict on reboot and never collide with future PIDs in any meaningful way. Manual `rm /tmp/claude-*-$PPID` is optional, not required.
- Hook registration in settings.json is a JSON config change — git revert restores it textually; Claude Code re-reads settings on next session start.
- No state pushed beyond the local repo (no Notion writes, no git push triggered).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Doc-contract drift on `triage-reviewer`.** The agent's frontmatter description states: *"Independent triage reviewer that prioritizes suggestions from the main conversation. Invoked by /triage. Do not use for other purposes."* (triage-reviewer.md:3). `/resolve` Step 4 (resolve.md:22) now invokes it as a second caller without the doc reflecting that. The constraint in the description is load-bearing — Claude reads the agent description when deciding whether an invocation is sanctioned, and a future audit / `/repo-dd` / `/audit-repo` pass will flag `/resolve`'s use as out-of-contract. The QC-pass output mapping (Findings → `[In-scope]`, Notes → `[Out-of-scope]`) that `/resolve` Step 3 implements *is* compatible with triage-reviewer's input contract (lines 17, 27–29 of the agent), so the runtime behavior is sound — only the documentation is stale.
- **Implicit cross-hook contract via `/tmp/claude-qc-ran-$PPID`.** `auto-qc-nudge.sh` (line 29) writes the sentinel; `auto-resolve-nudge.sh` (line 12) reads it. The contract is documented inline (auto-resolve-nudge.sh:6–9 explicitly notes the false-positive behavior is acceptable because `/resolve` Step 1 self-gates), but the dependency direction (PostToolUse populates a marker that Stop consumes) is a new pattern in this repo — no prior hook chain works this way. The contract is documented at *both* sites, which keeps it Medium-grade rather than High on its own. Combined with the next item it pushes toward High.
- **`$PPID` semantics.** Existing hooks (`coach-reminder.sh:6`, `improve-reminder.sh:6`) already use `$PPID` for session keying, so this is an established convention — Low coupling on its own. However: under nested bash invocation (which Claude Code uses to run hooks via `bash $CLAUDE_PROJECT_DIR/...`), `$PPID` resolves to the immediate parent shell, not the Claude Code session. If the harness changes hook spawn semantics, all four `/tmp/claude-*-$PPID` sentinels lose their session-scoping property and dedup breaks silently. This is a hidden assumption shared with existing hooks but newly leveraged for cross-hook coordination.
- **Functional overlap with `improve-reminder.sh`.** Both `auto-resolve-nudge.sh` (new) and `improve-reminder.sh` (existing, registered in same Stop block — settings.json:88–93) emit `systemMessage` nudges at session-stop. `improve-reminder.sh:23` says *"Significant artifact produced this session. Consider running /improve before wrapping the session."* The new hook says *"QC findings present this session. Run /resolve to assess importance and get ready-to-execute fixes."* In a session that produced a significant artifact AND fired the QC nudge, both nudges land in the same Stop event window. The two are semantically different (improve = suggest /improve; resolve = suggest /resolve) but they compete for the operator's attention at the same moment with no coordinating dedup. Mild overlap, not silent breakage — Medium on its own.
- **`triage-reviewer.md:3` description constraint** is the dominant signal. Without aligning that doc to the new caller, the change introduces a documented-but-violated contract. That alone elevates the dimension to High.

## Mitigations

- **Dimension 5 — triage-reviewer doc alignment (required before landing).** Edit `.claude/agents/triage-reviewer.md:3` description from *"Invoked by /triage. Do not use for other purposes."* to *"Invoked by /triage and /resolve. Do not use for other purposes."* (or equivalent two-caller phrasing). This is a one-line mechanical edit — qualifies for skip-QC under workspace CLAUDE.md "Post-edit QC is mandatory" exception (≤5 lines, mechanical substitution, correct form already validated by /resolve Step 4 working against the agent contract).
- **Dimension 5 — Stop-hook coordination (recommended, not blocking).** Document in either `auto-resolve-nudge.sh` header or `improve-reminder.sh` header that they may both fire in the same Stop window and that this is intentional (different concerns). Alternatively: combine into a single `check-stop-reminders.sh`-style aggregator. The current state ships fine, but a one-line comment prevents a future audit from flagging the overlap as a defect.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file path + line references for every claim (resolve.md:2, 22, 41; auto-qc-nudge.sh:8, 11, 14, 19, 25, 29; auto-resolve-nudge.sh:6–9, 12, 15–17, 19; settings.json:25–119, 50–67, 88–93, 96–105; triage-reviewer.md:3, 17, 27–29; coach-reminder.sh:6, 36; improve-reminder.sh:6, 23). Grep counts performed in `ai-resources/` for `auto-qc-nudge`, `auto-resolve-nudge`, `/resolve`, `triage-reviewer`. No training-data fallback used.
