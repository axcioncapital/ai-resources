# Risk Check — 2026-06-05

## Change

Message-only enrichment of .claude/hooks/detect-concurrent-session.sh — extend the final `emit "CONCURRENT SESSIONS …"` SessionStart warning string to also recommend starting a git worktree (pointer to docs/parallel-sessions-playbook.md § 4) as the structural remedy, in addition to the existing "coordinate (finish or /clear one)" advice. No change to detection logic (still pgrep -f native-binary/claude), no new state file, no change to the emit() JSON-escaping path, every code path still ends in exit 0. Scope: the warning text only. This is item 4 (A.2-lite) of the concurrent-session-collision low-risk subset; full same-checkout-vs-worktree detection via lsof is explicitly deferred.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md — exists

## Verdict

GO

**Summary:** A single-line, text-only enrichment of an existing non-blocking SessionStart warning with no logic, state, schema, or permission change — clean `git revert`, no caller depends on the string content, and the change actively serves OP-12 (closure, not new detection).

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json (L133) | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh | co-edits | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md (L184) | documents | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/parallel-sessions-playbook.md (L84, L235) | documents | no |
| Operator (human reading the SessionStart `systemMessage`) | invokes (reads output) | no |

Total: 5 consumers (4 file + 1 human reader), 0 must-change.

- The only consumer that *invokes* the hook is `.claude/settings.json` SessionStart array (L133) — it shells the script and consumes whatever `{"systemMessage": "..."}` JSON the script prints. It is content-agnostic: a longer warning string is fully compatible (settings.json L131-136 specifies `command`, `timeout`, `statusMessage` only — no expectation about message text).
- **Project copy is a co-edit consumer, not a symlink.** `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` is a real file (4394 bytes, `-rwxr-xr-x`), byte-identical to the canonical (verified `diff` = IDENTICAL). It does not *break* if the canonical changes, but it will silently drift to an older warning text. Flagged under Hidden Coupling and Blast Radius.
- `docs/session-marker.md` L184 and `docs/parallel-sessions-playbook.md` L84/L235 *document* the hook ("proactively warns at session start"); none quote the warning string verbatim, so none parses it. No must-change.
- **No consumer parses the warning string.** Literal-string grep for the existing advice fragment `coordinate (finish or /clear one)` returns only the hook itself and its project copy — nothing greps or pattern-matches the message text. The emit() JSON shape (`{"systemMessage": ...}`) is the only contract, and it is untouched.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook is a SessionStart hook (settings.json L122-138) — it runs once per session, and only when `SESSION_COUNT >= 2` does it emit (script L68: `[ "$SESSION_COUNT" -le 1 ] && exit 0`). The common single-session case still exits silently.
- The change adds a handful of words to one `systemMessage` string (script L83) shown only on the concurrency path. It adds nothing to any always-loaded CLAUDE.md, registers no new hook, adds no `@import`, and expands no subagent brief.
- The token cost is a few extra words in a `systemMessage` that already runs; it is not added to per-turn or always-loaded context. Token audit (`audits/token-audit-2026-06-05-ai-resources.md` L219) classifies these SessionStart hooks as "lightweight nudge … their stdout is small" — this change keeps it small.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json `permissions` change. The change touches only the warning string inside an already-registered, already-authorized script (settings.json L133 wires the existing `bash $CLAUDE_PROJECT_DIR/.claude/hooks/detect-concurrent-session.sh`).
- No new tool family, no Bash pattern, no Write path, no external API, no deny-rule removal, no scope change. Detection still `pgrep -f native-binary/claude` (per CHANGE_DESCRIPTION and script L59-60), which already runs.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (the canonical hook script). The change is confined to the single string literal at script L83.
- Consumer Inventory (Step 1.5): 5 consumers, **0 must-change**. The sole invoker (settings.json L133) is content-agnostic; the two doc references describe the hook without quoting its text; the human reader simply gets a longer, more actionable warning.
- No contract change: the `{"systemMessage": ...}` output shape is explicitly unchanged (CHANGE_DESCRIPTION: "no change to the emit() JSON-escaping path"), and the `parses` row count in the inventory is zero — nothing pattern-matches the warning text.
- One inventory finding worth naming: the byte-identical project copy (`projects/research-pe-regime-shift-advisory-gap/.claude/hooks/`) will drift to stale text if not co-updated. It does not *break* and is not on the must-change list (the copy keeps working), so it does not raise blast radius above Low — but it is a known divergence (see Dimension 5).

### Dimension 4: Reversibility
**Risk:** Low

- Single-line edit to one tracked file; `git revert` (or re-editing the string) fully restores prior state within the working tree. No sibling files or directories created.
- No data/log mutation (innovation-registry, improvement-log, session-notes), no settings.json change, no state file (CHANGE_DESCRIPTION: "no new state file"), no push or external write. Nothing propagates beyond the local repo.
- The hook fires only at SessionStart, so there is no automation firing mid-window between landing and a potential revert in a way that mutates state — it only prints a string.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new contract introduced is a pointer to `docs/parallel-sessions-playbook.md § 4`. Verified the target exists and § 4 ("Operating procedure (once you have decided to parallelize)", playbook L105-122) is the correct anchor for the worktree remedy — it contains the `git worktree add` recipe (L113-117) and the same-checkout anti-pattern callout (L107). The pointer is documented at the change site (the warning text itself) and resolves to real, on-topic content. This is the Medium "one new contract documented at the change site" case at most — but the dependency is on a stable, already-related doc the hook ecosystem already cross-references (playbook L84/L235 point back at the hook), so it is reciprocal and self-consistent → Low.
- One genuine coupling: the **byte-identical project copy** at `projects/research-pe-regime-shift-advisory-gap/.claude/hooks/detect-concurrent-session.sh` (verified IDENTICAL via diff). Editing only the canonical leaves the project copy showing the old advice — silent text drift, not a break. This is a pre-existing duplication (the copy already exists at the same content), not introduced by this change; the change merely widens the existing gap by one line.
- No silent auto-firing in unexpected contexts (SessionStart only), no functional overlap created — the change does not add a competing mechanism; it enriches one existing warning. Session-marker.md L184 already records this hook as supplementary-not-duplicative to the two reactive guards.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`, 12919 bytes) — checks grounded against frozen IDs.
- **OP-12 (closure before detection, L50) — actively served.** This change adds *no new detection* (CHANGE_DESCRIPTION: "no change to detection logic"). It improves the *closure* arm of an existing detector by routing the operator to a concrete structural remedy (worktree, playbook § 4) rather than only "coordinate / clear one." Per OP-12, "new detection that does not close findings counts against a candidate" — this is the opposite: pure closure improvement, counts for the change.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction, L47/L31/L60) — not triggered.** No generalization, no new hook, no "hooks for Phase 2." The deferral of lsof same-checkout detection (CHANGE_DESCRIPTION: "explicitly deferred") is the *correct* DR-7 posture — it does not build the bigger detector ahead of need. The worktree pointer references an existing, in-use playbook, not a speculative consumer.
- **OP-5 (advisory vs enforcement, L43) — preserved.** The hook stays advisory: non-blocking, every path `exit 0` (script L49, L64, L68; CHANGE_DESCRIPTION confirms). No move toward enforcement/auto-correction.
- **OP-10 (system boundary, L48) — not touched.** Change stays inside Claude Code; no cross-tool reach.
- **OP-11 / OP-3 (loud revision, L49/L41) — n/a.** No principle is revised or relaxed; nothing to surface.
- **DR-1/DR-3 (placement) — correct home.** The edit stays in the existing hook in its established `.claude/hooks/` location; the doc it points to is already the canonical parallel-sessions authority.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `diff` verification, verbatim quotes from CHANGE_DESCRIPTION and the referenced files, and principle IDs read from principles-base.md). No training-data fallback was used on fetch/read failures.
