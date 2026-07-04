# Risk Check — 2026-07-04

## Change

Edit the three nudge (emit) strings in `detect-concurrent-session.sh` to lead with the in-session command `/new-worktree-session` instead of the terminal-first fast-path "from your shell run cc-worktree <unit>", demoting `cc-worktree` to a trailing parenthetical (e.g. "(terminal users: cc-worktree <unit>)"). Rationale: the operator (Patrik) is a non-developer who launches Claude via the VS Code extension by opening a folder in a new window, never a terminal — so the current nudge leads him toward a shell command he cannot use. This is part of a larger "make the worktree flow VS Code-native" change. Scope of THIS hook edit: TEXT-ONLY inside the three `emit "..."` strings (the soft-marker branch at ~L131, the SHARP nudge at ~L153, the SOFT machine-wide nudge at ~L159). No detection logic, no control flow, no shared-state git ops, no permissions, no settings.json touched. The change must be applied to THREE byte-identical copies of the hook (all md5 77883c58…): the canonical `ai-resources/.claude/hooks/detect-concurrent-session.sh` PLUS two real-file (non-symlink) copies in `projects/positioning-research/.claude/hooks/detect-concurrent-session.sh` and `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh`. Note: a pre-scan found those two project copies are NOT registered in their projects' settings.json (currently inert), but they are updated in-sync to prevent drift.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh — exists

## Verdict

GO

**Summary:** A text-only reordering of three advisory nudge strings, with the leading command (`/new-worktree-session`) verified present and reachable and the demoted command (`cc-worktree`) verified still available — no contract, permission, control-flow, or firing-frequency change, zero must-change functional consumers, and a clean `git revert` path; all six dimensions Low.

## Consumer Inventory

Search terms: `detect-concurrent-session.sh` (basename of edit target), `/new-worktree-session` (command the nudge will lead with), `cc-worktree` (demoted script), and the emit systemMessage text / distinctive phrase `from your shell run cc-worktree` (to find any downstream parser of the nudge wording). Grepped across `ai-resources/` and the workspace root one level up.

Registration facts that scope the inventory (verified this session):
- The **canonical** hook is registered in the **user-global** `~/.claude/settings.json` (L74) as a `SessionStart` command, by **absolute path** to `ai-resources/.claude/hooks/detect-concurrent-session.sh`. It therefore fires on **every** session machine-wide and always executes the canonical copy.
- The **two project copies are registered nowhere** — neither project `settings.json` nor `settings.local.json` (repo) nor `~/.claude/settings.json` names them. Their `SessionStart` blocks register only `check-template-drift.sh` / `auto-sync-shared.sh` / a checkpoint-context hook. They are **inert byte-identical mirrors** (md5 `77883c5818007aac7230292a2f5dbc84` on all three — matches the description's `77883c58…`), kept in sync purely for drift-prevention.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/.claude/settings.json (L74, user-global SessionStart) | invokes | no |
| ai-resources/.claude/commands/new-worktree-session.md (command the nudge leads with; symlinked into both touched projects) | invokes | no |
| ai-resources/scripts/cc-worktree.sh (demoted nudge target; real script, stays) | invokes | no |
| ai-resources/.claude/commands/wrap-session.md (Step 13 per-id marker teardown the hook reads) | co-edits | no |
| ai-resources/.claude/commands/prime.md (writes the per-id marker the hook reads) | co-edits | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh (paired PreToolUse guard, same marker signal) | co-edits | no |
| ai-resources/.claude/commands/concurrent-session-check.md (nudge references `/concurrent-session-check`; command documents the hook) | documents | no |
| ai-resources/docs/parallel-sessions-playbook.md (§ 4, pointed to by all three nudges) | documents | no |
| ai-resources/docs/session-marker.md (two-end contract registry) | documents | no |
| ai-resources/docs/daniel-concurrent-session-hooks-setup.md (hook setup guide) | documents | no |
| projects/positioning-research/.claude/hooks/detect-concurrent-session.sh (inert mirror) | co-edits | yes (drift-parity) |
| projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh (inert mirror) | co-edits | yes (drift-parity) |

Total: 12 distinct consumers. Functional must-change = **0** (no consumer depends on the nudge *wording*; the leading and demoted commands both already appear in all three strings today — the edit only reorders emphasis). The two `yes` rows are the inert co-edit mirrors that must be updated **only** to preserve byte-parity per the change's own scope, not for the change to function.

Not counted as live consumers: ~70 historical audit / risk-check / log / session-plan / scratchpad / consultation / pipeline-snapshot files that mention `detect-concurrent-session` or `cc-worktree` as a record of past work. They are documentation-of-history, not invoked or parsed, and require no change. No test harness or file asserts the exact current nudge wording (grep for `from your shell run cc-worktree` outside the hook + historical records: none; no `*detect-concurrent*test*` file; `CC_PROCESS_PATTERN` appears only inside the hook).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Adds **no** new hook registration, always-loaded content, or `@import`. The hook already exists and already fires per-session (`SessionStart`, user-global `~/.claude/settings.json` L74); this edit does not change firing frequency — evidence: change is confined to `emit "..."` string bodies, registration path untouched.
- The `systemMessage` is emitted **only** when concurrency is detected (`SESSION_COUNT >= 2`); the common solo-session path exits at L102 (`[ "$SESSION_COUNT" -le 1 ] && exit 0`) with no output. So the typical session pays zero incremental tokens from this edit.
- Even on the emit path, the token delta is roughly neutral — reordering existing text plus a short parenthetical `(terminal users: cc-worktree <unit>)`; both `cc-worktree` and `/new-worktree-session` already appear in each of the three strings (L131, L153, L159), so no net new tokens of substance.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` change and no new tool-invocation pattern. Change is TEXT-ONLY inside `.sh` emit strings — quote from CHANGE_DESCRIPTION: "No … permissions, no settings.json touched."
- The pre-existing maintenance permissions in `ai-resources/.claude/settings.local.json` (`Bash(bash -n .claude/hooks/detect-concurrent-session.sh)` L6 and the `cp …` sync entry L7) already authorize editing/validating/syncing these copies. They are not modified by this change.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: **3** (the three hook copies). Only the canonical is live; the other two are inert (unregistered) — so the functional footprint is a single file that fires machine-wide via the user-global registration.
- Consumer inventory (above): **12 distinct consumers, 0 functional must-change.** The lone live invoker — `~/.claude/settings.json` L74 — needs no change (it references the hook by unchanged absolute path). Every documents/co-edits consumer references the hook's **marker/liveness contract or its existence**, never its nudge *wording*, which is the only thing this edit changes.
- Contract check: the emit `systemMessage` has **no downstream machine parser** — grep for the distinctive current phrase and for a test harness returned nothing outside the hook itself and historical records. The actual cross-component contract (the per-id `logs/.session-marker-${CLAUDE_CODE_SESSION_ID}` liveness signal, shared with `check-foreign-staging.sh`, `prime.md`, `wrap-session.md`) is untouched. So this is a backwards-compatible, non-contract change.
- Reachability of the new lead command: `/new-worktree-session` exists as a real file at `ai-resources/.claude/commands/new-worktree-session.md` (4967 bytes) and is symlinked into **14** project command dirs, including both touched projects (verified: `positioning-research` and `research-pe-regime-shift-advisory-gap` both hold symlinks back to canonical). The hook fires machine-wide, so wherever it fires the leading command resolves — no dangling command reference introduced. The demoted `cc-worktree` remains a real script at `ai-resources/scripts/cc-worktree.sh`, so demoting it introduces no dangling reference either.
- No Step-1.5 consumer surfaced that the change failed to anticipate; the CHANGE_DESCRIPTION's own pre-scan (two inert project copies) is confirmed accurate.

### Dimension 4: Reversibility
**Risk:** Low

- Single-purpose text edit to three git-tracked files; `git revert` restores the prior wording exactly. No data/log mutation, no append-only-log entry, no external write, no push (push is gated to wrap), no automation added.
- All three copies live in the same working tree and would land/revert in one commit — reverting all three is atomic, no state propagates beyond git.
- Because the canonical fires on every session machine-wide, the only reversibility nuance is verification, not rollback: a malformed edit would surface on every session start until fixed. Advisory (not a gating mitigation): run `bash -n` on all three copies after editing — already permission-whitelisted — and confirm md5 re-parity across the three; the `emit()` function JSON-escapes the message via `python3 json.dumps` at runtime, and the proposed parenthetical contains no `"`, `$`, or backtick, so the bash string literal stays well-formed.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No new contract introduced. The emit text is advisory prose surfaced to the operator/session, not a parsed interface; nothing downstream depends on its shape (confirmed: no parser, no test).
- No **new** implicit dependency: all three current emit strings already reference **both** `cc-worktree` and `/new-worktree-session` (L131, L153, L159). The change only reorders which leads, so it adds no command reference that wasn't already present and already satisfied.
- Pre-existing structural coupling correctly honored: the three byte-identical hand-synced copies mean a partial edit would create drift. This coupling predates the change; the change explicitly commits to updating all three in sync, and the inert mirrors are functionally invisible today (unregistered), so the residual risk is drift-hygiene only — mitigated by the in-scope "update all three" instruction and the md5-parity check noted above.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read this session).

- **OP-12 (closure before detection):** the change adds **no new detection** — it retargets an existing detector's advisory output toward a remedy the operator can actually execute (`/new-worktree-session`, verified reachable). It improves closure of an existing finding rather than adding an unclosed detector; counts **for** the change.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction):** not building for an absent consumer. The fix addresses a **present, confirmed** problem — the operator launches via the VS Code extension and cannot use the shell command the nudge currently leads with (corroborated by the recorded operator-working-style fact: "Patrik launches via VS Code, not terminal … terminal-only tooling sits unused"). The mention of "a larger make-the-worktree-flow-VS-Code-native change" is context; THIS edit is self-contained and non-speculative.
- **OP-10 (system boundary = Claude Code only):** stays entirely within Claude Code (a SessionStart hook nudge pointing at a slash command). The VS Code extension is Claude Code's launch surface, not a separately-governed external tool (GPT/Perplexity/NotebookLM/Notion). No boundary expansion.
- **OP-5 (advisory vs enforcement):** the hook remains advisory/non-blocking (its header documents at length "WHY ONLY A NUDGE — NOT A BLOCK"; every path ends in `exit 0`). The change does not move it toward enforcement.
- **DR-1 / DR-3 (placement):** edits stay in the canonical hook home and its two project mirrors — correct tier and home; no misplacement.
- **OP-11:** no principle is being revised, so no loud-revision obligation is triggered.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: md5 verification of the three copies (`77883c5818007aac7230292a2f5dbc84` ×3), the user-global registration at `~/.claude/settings.json` L74, the absence of the hook from all repo `settings.json`/`settings.local.json` SessionStart blocks and from the two project settings, the symlink resolution of `/new-worktree-session` into both touched projects, the real-file presence of `ai-resources/scripts/cc-worktree.sh`, grep confirmation that no parser/test asserts the nudge wording, and principle IDs quoted from `principles-base.md`. No training-data fallback was used on any read.
