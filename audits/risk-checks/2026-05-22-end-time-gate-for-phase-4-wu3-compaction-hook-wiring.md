# Risk Check — 2026-05-22

## Change

End-time gate for Phase 4 WU3 — compaction-hook wiring. Executed change set: (1) .claude/hooks/precompact.sh and (2) .claude/hooks/postcompact.sh rewritten from Phase 1 stubs (exit 0) to append a compaction_event entry to harness/session/session-log.json via jq + atomic mv, capturing the trigger field (manual/auto) from hook stdin; both minimal and fail-open (exit 0 on every path). (3) .claude/settings.json — PreCompact and PostCompact hook events registered, each running its script with timeout 10 and a trailing "; exit 0", mirroring the existing SessionStart hook. Structural change class: hook registration. Plan-time /risk-check already ran (PROCEED-WITH-CAUTION, 6 mitigations); M5 (hook bodies minimal + fail-open) is the WU3-relevant mitigation. Verify the executed change matches the evaluated scope and M5 was satisfied.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/precompact.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/postcompact.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/session/session-log.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists

## Verdict

GO

**Summary:** The executed change matches the evaluated scope exactly, M5 (minimal + fail-open hook bodies) is satisfied on every code path, and the only structural addition is two observability hooks that conform to hard rule 6 and the established SessionStart pattern.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change adds no content to any always-loaded file. `precompact.sh` and `postcompact.sh` are shell scripts, not context-loaded files; `.claude/settings.json` is harness config, not turn context.
- The two new hooks fire only on a compaction event (`PreCompact` / `PostCompact`), not per turn and not per tool call — far rarer than even a SessionStart hook. Cost is pay-as-used.
- Each hook does not emit `hookSpecificOutput` / `additionalContext` (verified: `precompact.sh:34` and `postcompact.sh:34` end with a bare `exit 0`, unlike `session-start.sh:64` which prints a `hookSpecificOutput` JSON block). No context is injected into the session, so there is zero token cost even when the hooks fire.
- No `@import`, no skill, no subagent brief touched.

### Dimension 2: Permissions Surface
**Risk:** Low

- No change to the `permissions` block of `.claude/settings.json`. The git diff of `settings.json` touches only the `hooks` object — `allow`, `deny`, and `defaultMode` are unchanged (verified: diff hunk is confined to lines 47+ inside `"hooks"`).
- The hooks invoke `jq`, `mktemp`, `mv`, `rm`, `date`, `cat`, `git rev-parse` — all already covered by the existing `Bash(*)` allow entry (`settings.json:17`). No new tool family is introduced.
- The hooks write only to `harness/session/session-log.json` inside the repo via atomic `mv` of a `mktemp` temp file — within the repo's existing `Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)` scope. No cross-repo write, no external API, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched by this change set: 4 — `.claude/hooks/precompact.sh`, `.claude/hooks/postcompact.sh`, `.claude/settings.json`, plus log files `harness/logs/innovation-registry.md`, `harness/logs/session-notes.md`, `logs/innovation-registry.md` (the last three are session bookkeeping, not part of the evaluated structural change). Verified via `git status --short`.
- Enumeration — grep of the repo for `precompact`/`postcompact`/`PreCompact`/`PostCompact` (sources only): the hook scripts themselves, `.claude/settings.json` (registration), `.claude/references/harness-rules.md` (hard rule 6 — descriptive, no code dependency), `.claude/skills/session-governor/SKILL.md` (Phase C, lines 519–521), `harness/logs/session-plan.md` (the WU3 plan entry). Plus log/notes/decisions files (bookkeeping).
- Grep for `compaction_event`: the two hook scripts, `harness/schemas/session-log-schema.md` (line 29 — the entry type is already a defined log-entry type), `session-governor/SKILL.md`, plus plan/notes/report files. The `compaction_event` type pre-exists in the schema; this change is the first *producer* of it — no consumer requires modification.
- No caller requires a change. `session-governor/SKILL.md:519–521` already states the hooks "log `compaction_event` … for observability — they do **not** drive control … the governor does not depend on those events for recovery." The governor reads `current-state.json` for rehydration, never the hook events — so wiring the hooks cannot break the governor.
- The append entries (`component: "precompact-hook"` / `"postcompact-hook"`, `event: "compaction_event"`, `payload: {phase, trigger}`) conform to the four-field session-log shape (`session-log-schema.md:7–12`). The new `component` values are new but the schema does not enumerate a closed component set, so this is schema-compatible, not a contract break.

### Dimension 4: Reversibility
**Risk:** Low

- All three structural files are tracked and modified in place (`git status` shows `M` for each). A `git revert` (or checkout of the prior blob) of `precompact.sh`, `postcompact.sh`, and `settings.json` fully restores the Phase 1 stub state — no sibling files or directories are created.
- No state has propagated beyond the local repo: the change is uncommitted in the working tree, not pushed, no external write.
- One minor caveat, not risk-elevating: if a compaction fires between landing and a hypothetical revert, the hooks will have appended `compaction_event` rows to `session-log.json` (an append-only log). Reverting the hook scripts does not retroactively remove those rows. This is inherent to any append-only log producer and is the normal, expected behavior of an observability log — the stale rows are correctly-typed schema entries, not corruption, and crash detection (`session-start.sh` Indicator 2) keys on `session_completed`, not `compaction_event`, so leftover rows are inert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The hooks' contract is explicitly documented at the relevant locations: `harness-rules.md` hard rule 6 ("`PreCompact`/`PostCompact` hooks log events but do not drive control") and `session-governor/SKILL.md:519–521` (the governor does not depend on these events). The change honors that documented contract — the hooks are observability-only and emit no `hookSpecificOutput`.
- No silent reliance on a fragile convention. The hooks resolve `PROJECT_DIR` via `CLAUDE_PROJECT_DIR` with a `git rev-parse` then `pwd` fallback (`precompact.sh:7`), and degrade cleanly: if `session-log.json` is absent or `jq` is unavailable, the hook logs nothing and exits 0 (`precompact.sh:22–32`). `jq` is confirmed present on this host (`/usr/bin/jq`, jq-1.7.1).
- No functional overlap. The hooks are the first and only producer of `compaction_event`; the governor explicitly does not write it (`session-plan.md:36` — "appending `compaction_event` via the governor is NOT an equivalent option … keep this a hook-wiring task"). Two systems do not contend for this concern.
- The `trigger` field is read from hook stdin via `jq -r '.trigger // "unknown"'` — if Claude Code's `PreCompact`/`PostCompact` stdin shape ever changes, the hook degrades to `trigger: "unknown"` rather than failing. This is a graceful, documented fallback (`precompact.sh:11–17`), not a hidden hard dependency.

### M5 verification (plan-time mitigation, WU3-relevant)

M5 = hook bodies minimal + fail-open. Verified satisfied:
- **Minimal:** each hook is 35 lines; the only side effect is appending one log entry. No control output, no `hookSpecificOutput`, no veto path.
- **Fail-open on every path:** `precompact.sh` and `postcompact.sh` both end with an unconditional `exit 0` (line 34); the registration in `settings.json` additionally appends `; exit 0` after the script call (lines 56, 68) and pipes stderr to `/dev/null` — mirroring the SessionStart registration (`settings.json:44`). Every internal failure (`mktemp` empty, `jq` failure, empty temp file, missing log) is guarded and falls through to `exit 0`. A `PreCompact` hook cannot block compaction; a `PostCompact` hook has no decision control. M5 is satisfied.

### Scope-match verification

The executed change set matches the plan-time-evaluated scope exactly: two hook scripts rewritten from `exit 0` stubs to `compaction_event` emitters, and `PreCompact`/`PostCompact` registered in `.claude/settings.json` with `timeout 10` + trailing `; exit 0`. No scope creep — `stop.sh` was correctly left untouched (it is outside the evaluated set per `session-plan.md` Decision 1). The git diff of `settings.json` is confined to the two new hook-event blocks.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, git diff output, grep counts, verbatim quotes from the referenced and context files). The hook bodies, `settings.json` diff, session-log schema, harness rule 6, governor SKILL.md Phase C, and the WU3 plan entry were all read directly. `jq` availability was confirmed by execution. No training-data fallback was used.
