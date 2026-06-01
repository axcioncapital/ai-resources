# Risk Check — 2026-06-01

## Change

Add a new SessionStart hook `.claude/hooks/detect-concurrent-session.sh` to ai-resources that detects concurrent Claude Code sessions and warns the operator. Design (Option A): the hook reads `session_id` from its stdin JSON, maintains a per-machine registry file `logs/.active-sessions` (one `{session_id} {epoch}` line per session), prunes entries older than an 8-hour TTL, appends the current session, and if ≥1 other distinct session_id survives pruning, emits a loud non-blocking `systemMessage` warning (always exit 0). Changes: (1) new hook script under `.claude/hooks/`; (2) add `logs/.active-sessions` to `.gitignore`; (3) wire the hook into `.claude/settings.json` SessionStart array alongside the existing friday-checkup-reminder; (4) register the hook + state file in `docs/session-marker.md`. The registry is deliberately independent of the existing `.session-marker`/`.prime-mtime` shared-mutable files (which suffer a clobber-bug) so it cannot inherit that poisoning. This is a proactive early-warning layer that supplements — does not duplicate — the existing reactive per-write guards in session-start.md Step 0.5 and wrap-session.md Step 3.5. Full plan: logs/session-plan-S1.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/.active-sessions — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friday-checkup-reminder.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-S1.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A self-contained, non-blocking SessionStart hook with clean reversibility and low usage cost; the only elevated dimension is hidden coupling on the undocumented `session_id` stdin contract and a write-side concurrency window in the registry file, both addressable with specific paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook is a SessionStart hook — it fires once per session, not per tool call. Evidence: it is wired into `.claude/settings.json` `SessionStart` array (lines 122-133), the same class as the existing `friday-checkup-reminder.sh`, not into `PreToolUse` (lines 41-64).
- No token cost is added to always-loaded files. The change adds zero content to either CLAUDE.md (workspace or repo) and adds no `@import`. The hook's `systemMessage` only emits text when ≥1 other live session is detected; the common single-session path is silent (`exit 0` with no output), per the Option A design in `logs/session-plan-S1.md` line 27 and the friday-checkup-reminder.sh silent-path precedent (lines 28-30).
- The registry file `logs/.active-sessions` is a runtime state file, not a context input — it is gitignored and never read into a session prompt.
- Calibration: SessionStart-once + conditional-only output is at or below the "Medium = once per session" line; because output is suppressed on the dominant single-session path, net ongoing cost is effectively Low.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` entry changes. The `.claude/settings.json` edit adds only a hook entry to the existing `SessionStart` array (lines 122-133); the `permissions` block (lines 2-35) is untouched.
- The hook requires no capability the repo does not already grant. `settings.json` already allows `Bash(*)` (line 4), and the hook's reads/writes target `logs/.active-sessions` inside the project tree already covered by `Write(/Users/.../Axcion AI Repo/**)` (line 21).
- `jq` (used to parse stdin JSON, per plan line 19 referencing `log-write-activity.sh`) is present at `/usr/bin/jq` — no new tool dependency introduced beyond what existing hooks already use (`log-write-activity.sh` line 13 uses `jq`).
- No scope escalation (project → user); the registry stays per-machine inside the repo's `logs/`, not `~/.claude/`.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 4 — the new hook (`detect-concurrent-session.sh`), `.gitignore`, `.claude/settings.json` (one array entry), `docs/session-marker.md` (one registry entry). No existing hook or command body is modified.
- No contract that existing callers depend on is changed. The `SessionStart` array gains a sibling entry; the existing `friday-checkup-reminder.sh` entry is left intact (settings.json lines 124-131). Hooks in a SessionStart array run independently — adding one does not alter the others' behavior.
- Enumeration of references:
  - `grep -rl "session-marker.md"` across repo `.md` files → 23 matches. These reference the *doc*; the change appends one registry entry to that doc and does not alter the existing marker contract (`docs/session-marker.md` lines 84-113), so none of the 23 require modification to keep working.
  - `grep -rl "settings.json"` across `.claude/commands`, `.claude/agents`, `docs` → 36 matches. These are narrative/management references (e.g., `permission-template.md`); the change adds a hook entry, not a permission or schema change, so none break.
  - `grep -rl ".active-sessions"` → 5 matches, all in audit/log/archive files (`audits/2026-05-08-concurrent-session-guardrail-investigation.md`, `logs/decisions-archive-2026-05.md`, `logs/session-notes-archive-2026-05.md`, `audits/friday-journal-2026-05-08.md`, and `logs/session-plan-S1.md` itself) — historical/planning context, zero runtime consumers.
- Shared infra: the hook writes a *new* state file (`logs/.active-sessions`) that no existing component reads. It deliberately does not touch the clobbered `.session-marker` / `.prime-mtime` files (`logs/session-plan-S1.md` lines 27, 66), so it adds no new reader/writer to existing shared-mutable state.

### Dimension 4: Reversibility
**Risk:** Low

- Clean four-step revert, all within the working tree: delete the hook file, remove the `settings.json` SessionStart entry, remove the `.gitignore` line, remove the `docs/session-marker.md` registry entry. A `git revert` of the landing commit restores all four; no data migration (plan confirms this, `logs/session-plan-S1.md` line 65).
- The one residue is `logs/.active-sessions` itself — but it is gitignored (so never committed) and self-expiring via the 8-hour TTL, so a leftover file is inert and clears on its own. Deleting it is a trivial optional cleanup, not a required rollback step.
- No state propagates beyond the local repo: the registry is per-machine, nothing is pushed, no external API or Notion write occurs.
- The added automation is the hook itself — but it is non-blocking (`exit 0` on every path, plan line 33 / line 63) and only emits an advisory message, so even if it fires between landing and revert, its effect is a chat warning, not a state mutation. (See Dimension 5 for the registry write-window caveat.)

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Undocumented stdin contract (one implicit dependency on an external convention).** The hook depends on Claude Code's SessionStart hook stdin JSON carrying a `session_id` field (plan line 27: "SessionStart hook stdin JSON carries `session_id`"). This is a harness-provided contract not documented in any repo SKILL.md/CLAUDE.md; if the harness omits or renames the field, the hook would register empty/garbage session ids and either over-warn or silently fail to detect. The existing `log-write-activity.sh` parses a different field (`.tool_input.file_path`, line 13), so this `session_id` dependency is new to the repo and unverified against a live SessionStart payload. The mitigation (jq-absent / empty-field guard) must be present.
- **Registry write-window concurrency (the very class this change targets).** Two sessions starting near-simultaneously both read, prune, and append to `logs/.active-sessions`; a naive read-then-write (non-atomic) can drop one session's line — a write race in the file meant to detect races. This is a self-coupling risk: the detector can be undermined by the same concurrency it watches for. Not a blocker (a dropped line only weakens detection, never breaks session start because of `exit 0`), but it warrants an atomic-append approach.
- **Functional-overlap check — PASSES (not a coupling concern).** The change does not duplicate the two existing guards: `session-start.md` Step 0.5 is a reactive point-in-time mtime check on `logs/session-notes.md` (session-start.md lines 26-49), and wrap-session.md Step 3.5 is a reactive foreign-write check at wrap. Both are per-write/per-command and trust the clobbered marker; this hook is proactive at session start and uses an independent registry (plan lines 25-27). Different trigger timing, different mechanism, separate state file — no two-systems-handling-one-concern overlap.
- **Two-end contract is honored at the change site.** The plan registers the hook + state file in `docs/session-marker.md`'s two-end registry (plan line 35; doc registry at lines 84-113), so the new state file will not be orphaned. This documents the contract at the relevant location, which is the correct mitigation posture — but the `session_id` *source* contract (harness stdin) remains external and undocumented, which is why this dimension is Medium not Low.

## Mitigations

- **Dimension 5 (hidden coupling — stdin contract):** Before landing, add a defensive guard in the hook: if `jq` is absent OR the parsed `session_id` is empty, `exit 0` immediately without writing the registry (mirrors the `log-write-activity.sh` `// empty` pattern and the friday-checkup-reminder.sh silent-exit pattern). Verify the field name against one real SessionStart payload (log the raw stdin once during the plan's Step 6 reproduction test) rather than assuming `session_id` — confirm the actual key before shipping.
- **Dimension 5 (hidden coupling — registry write race):** Implement the prune+append as an atomic-replace (write the pruned+appended content to a temp file, then `mv` into place) or use `flock` on the registry, so two near-simultaneous SessionStarts cannot drop each other's line. Document the chosen approach in the hook header so the concurrency assumption is explicit.
- **Dimension 5 (defensive non-blocking):** Confirm every code path ends in `exit 0` (including the jq-absent, empty-field, and write-failure paths), so a malformed payload or a read-only `logs/` can never break session start — this is already specified in the plan (lines 33, 63) and must be verified in the executed hook, not just intended.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to `.claude/settings.json`, `.gitignore`, `docs/session-marker.md`, `friday-checkup-reminder.sh`, `session-start.md`, `log-write-activity.sh`, `logs/session-plan-S1.md`; grep counts for cross-references; `which jq` confirmation). The two `not yet present` files (the hook script and `logs/.active-sessions`) were evaluated from the described intent in CHANGE_DESCRIPTION and `logs/session-plan-S1.md`, not read — noted under Dimensions 1, 4, and 5. No training-data fallback was used.
