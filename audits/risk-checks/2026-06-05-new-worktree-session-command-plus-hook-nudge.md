# Risk Check — 2026-06-05

## Change

Two batched structural changes implementing the Mode-A structural fix for the concurrent-session collision class. (1) NEW command `.claude/commands/new-worktree-session.md` (Sonnet, disable-model-invocation) — an operator-invoked orchestration wrapper around `git worktree add … -b session/{date}-{unit} main` that creates+prepares an isolated worktree for a parallel session, prints how to enter it (cannot move the operator's shell), cites docs/parallel-sessions-playbook.md as the authority, and points at /cleanup-worktree + /monday-prep for teardown/inventory. No new shared state, no hook, no detection logic. (2) EDIT `.claude/hooks/detect-concurrent-session.sh` (SessionStart hook) — sharpen the existing concurrency warning into a two-branch nudge: when pgrep session count >= 2 AND a today-dated marker already exists in THIS checkout (logs/.session-marker), emit a SHARP actionable nudge naming /new-worktree-session; otherwise keep a SOFTER machine-wide warning. No new detection dependency (uses the two signals the hook already reads), no new state file, emit()/JSON path unchanged, every path still ends exit 0. The project-local byte-identical copy at projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh was synced in lockstep (diff empty). This is the structural follow-up to the Option C+A subset (commit 2e52b22); per-session log namespacing (Option B.1) was deliberately declined per report §9.2.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-worktree-session.md — exists (new this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists (edited this session)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/projects/../projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh — exists (project-local copy, synced)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists (hook registration)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md — exists (cited authority)

> Note on path resolution: the input path for the project-local copy (`ai-resources/projects/../projects/research-pe-regime-shift-advisory-gap/...`) does not normalize to a real file. The actual project copy lives at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` (one level above `ai-resources/`, not under it). Verified present, byte-identical to canonical (`diff` empty), syntax-valid (`bash -n` OK).

## Verdict

GO

**Summary:** Two additive, advisory, fully-reversible changes that close the named Mode-A trigger gap the collision report and System-Owner consultation both identified as required; no permission widening, no new shared state, all consumers compatible, every dimension Low except one Low-bordering-Medium documentation-coupling note that is pre-existing and already logged.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` (L37, L99, L103) | invokes (names `/new-worktree-session` in both emit strings) | no — string only; remains valid whether or not the command exists |
| `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` (L37, L99, L103) | co-edits (byte-identical copy of the edited hook) | yes — synced in lockstep this session (verified `diff` empty) |
| `ai-resources/.claude/settings.json` (L133) | invokes (SessionStart registration of the edited hook) | no — registration line unchanged; hook path/contract identical |
| `ai-resources/docs/parallel-sessions-playbook.md` (L111, L114, L235) | documents (cites `/new-worktree-session` as the § 4 isolated-start command) | no — already written to expect the command; this change makes the reference resolve |
| `ai-resources/logs/improvement-log.md` (L333) | documents (records the command as a planned fast-follow) | no |
| `ai-resources/audits/2026-06-05-concurrent-session-collision-diagnostics-fix.md` (L156, L162, L236, L294) | documents (the originating report's recommendation) | no |
| `ai-resources/docs/session-marker.md` (L184) | documents (registers the hook's proactive layer) | no — hook contract unchanged (emit/JSON/exit-0 preserved) |
| `ai-resources/.claude/settings.local.json` (L6–L7) | invokes (pre-authorizes `bash -n` syntax check + `cp` lockstep-sync of the hook) | no — already present; supports the sync this change performs |
| `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json` | (no SessionStart wiring of the hook — pre-existing) | no — project copy is unwired (DD report 2026-06-02 L139); editing it changes no live behavior there |

Total: 8 distinct consumers, 1 must-change (the project-local hook copy — already synced this session). The new command itself has callers (the hook strings + the playbook + improvement-log) that *named it ahead of its creation*; this change makes those forward-references resolve rather than introducing new dependents. Empty-inventory case does not apply.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New command is pay-as-used and explicitly non-auto-invocable: frontmatter `disable-model-invocation: true` (new-worktree-session.md L4) — it loads only when the operator types `/new-worktree-session`. Zero per-session or per-turn token cost.
- The hook edit adds no new invocation: it is already registered at SessionStart (settings.json L133) and already runs once per session. The change is two extra branches and a `cat` of an existing marker file (detect-concurrent-session.sh L89–L100), not a new auto-load. The 2026-06-05 token audit classifies all SessionStart hooks as "lightweight nudge/log hooks … their stdout is small" (token-audit-2026-06-05-ai-resources.md L219).
- No content added to any always-loaded CLAUDE.md, no new `@import`, no new hook registration, no frequently-spawned subagent.

### Dimension 2: Permissions Surface
**Risk:** Low

- No change to `permissions.allow`, `permissions.deny`, or `defaultMode` in settings.json. The hook runs inside the already-registered, already-authorized SessionStart entry (settings.json L133).
- The command's `git worktree add` and `git worktree remove` run under the existing broad `Bash(*)` allow (settings.json L4) — no new tool family introduced; worktree git is the same git binary already in unrestricted use.
- The lockstep `cp` of the hook to the project copy is already pre-authorized in settings.local.json L7 (`Bash(cp .claude/hooks/detect-concurrent-session.sh "../projects/.../detect-concurrent-session.sh" *)`). No scope escalation, no deny-rule removal, no cross-repo *write* capability introduced beyond what the existing workspace-wide `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` already grants (settings.json L21).

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 3 — the new command, the canonical hook, the project-local hook copy. (Settings.json is unchanged — the registration line already exists.)
- Consumer Inventory (Step 1.5): 8 distinct consumers, **1 must-change** (the project-local hook copy, already synced in lockstep this session; `diff` empty, `bash -n` OK). Every other consumer is `documents` or `invokes` and stays compatible.
- No contract change. The hook's output contract (single `systemMessage` JSON via `emit()`, every path `exit 0`) is preserved verbatim (detect-concurrent-session.sh L56–L65, L99–L103); only the warning *text* and a conditional branch changed. The new command introduces no parse marker, frontmatter key, or filename convention that any consumer parses.
- No unanticipated consumer surfaced: the grep found the command token already written into the hook, the playbook (§ 4), and the improvement-log — these are forward-references the change *satisfies*, not callers it breaks.
- Shared infra (settings.json SessionStart array) is touched only in that the hook it points at changed body; the pointer and contract are identical, so no other SessionStart hook or command is affected.

### Dimension 4: Reversibility
**Risk:** Low

- Both changes are tracked-file edits/additions: `git revert` removes the new command file and restores the prior hook body across both copies cleanly, with no orphaned siblings.
- No data/log mutation: the hook reads `logs/.session-marker` read-only (detect-concurrent-session.sh L92–L95) and writes no state; the command writes no repo state (it creates a *worktree*, which is operator-driven at invocation time, not at landing time).
- No state propagates beyond git: nothing is pushed, no external write, no Notion/API POST.
- One mild operator-memory consideration (not a revert blocker): once the operator learns `/new-worktree-session`, reverting the command would leave the hook (if also reverted) and playbook still naming it. But the two changes can land/revert independently (see note below), so this is a coordination point, not a cleanup cost.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The hook now reads two signals it *already* read — the pgrep process count and the `logs/.session-marker` content (detect-concurrent-session.sh L75, L92–L95). No new detection dependency, no new state file. The change is self-contained within signals already in use.
- The command→hook→playbook relationship is explicit and documented at every site: the hook names the command in prose (L99, L103), the command cites the playbook as authority (new-worktree-session.md L11, L73–74, L102–105), and the playbook names the command (§ 4 L111). No silent contract.
- No functional overlap that duplicates an existing mechanism: the hook remains the *proactive* layer; the command is the *remedy* it points at; the playbook is the *authority*. This matches the deliberate separation documented in session-marker.md L184 and the prior risk-check at audits/risk-checks/2026-06-01-wrap-session-step35-clobber-suspicion-sanity-check.md L65 (no overlap with reactive guards).
- One genuine but pre-existing coupling: the **byte-identical project-local hook copy** must be kept in sync by hand or by the pre-authorized `cp` (settings.local.json L7). This change synced it in lockstep (verified `diff` empty), so no drift was introduced *by this change*. The duplication itself is logged as standing maintenance debt (improvement-log.md L336) and is the same coupling the prior hook-enrichment risk-check flagged (audits/risk-checks/2026-06-05-hook-warning-worktree-enrichment.md L31, L69). The heuristic nature of the sharp-nudge branch (a wrapped-then-left today marker can trigger a false sharp nudge) is documented in-line and degrades safe — never a block, never a missed real collision (detect-concurrent-session.sh L39–L46, L99 closing parenthetical).

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-12 (closure before detection):** the change does NOT add new detection — it sharpens an existing warning AND ships the closure channel (`/new-worktree-session`, the structural remedy the warning points at). This is the textbook OP-12-compliant shape: the detection (sharp nudge) ships *behind* a working closure channel (principles-base.md L50). Counts *for* the change.
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** not violated. The command has a confirmed, named consumer-set *before* it exists — the collision report explicitly recommends it (audits/2026-06-05-...-fix.md L156, L236), the playbook § 4 already cites it as the isolated-start command (parallel-sessions-playbook.md L111), and the System-Owner consultation names the missing worktree trigger as "the Mode-A killer … Without this, Mode A recurs — guaranteed" (consult-2026-06-05-...md L60, L16). This is closing a named gap for a real recurring failure (~5 recurrences in 5 days per the friction log), not building for an absent Phase-2 consumer.
- **OP-5 (advisory vs enforcement):** preserved. The sharpened nudge still *advises and stops* — every path `exit 0`, non-blocking (detect-concurrent-session.sh L48–L51, L99–L103); it does not auto-create the worktree or block the session ("It cannot CREATE+enter the worktree for them … it prompts" — L45–46). No silent advisory→enforcement upgrade.
- **OP-2 (automate execution, gate judgment):** aligned — the command automates the *execution* (the git worktree mechanics) while leaving the *judgment* (whether/how to parallelize, the file-ownership map) operator-gated and routed to the playbook (new-worktree-session.md L102–105, "orchestrates; it does not own the parallel-session discipline").
- **DR-1 / DR-3 (placement):** correct homes — new command in `.claude/commands/`, hook edit in `.claude/hooks/`. Consistent with the System-Owner routing confirmation (consult-2026-06-05-...md L17, "landed in their correct homes … consistent with DR-3").
- **DR-8 (risk-check gating):** this risk-check IS the required gate for the two gated classes touched (new command + hook edit). The deliberately-declined Option B.1 (per-session log namespacing) is the change that would have been a two-end marker-contract edit; declining it (per report § 9.2) avoids that heavier gated class entirely — a leanness-positive choice (OP-12 / DR-7).
- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`); IDs cited from it directly.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts across `ai-resources` and the workspace root, verbatim quotes from CHANGE_DESCRIPTION and referenced files, `diff`/`bash -n` verification of the synced copy, and principle IDs from the readable principles-base). No training-data fallback was used. The one input-path normalization issue (project-copy path) was resolved by `find` and is documented under Referenced files.
