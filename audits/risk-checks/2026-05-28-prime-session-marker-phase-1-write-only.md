# Risk Check — 2026-05-28

## Change

Proposed change: Add Phase 1 of the per-session marker (`logs/.session-marker`) to `ai-resources/.claude/commands/prime.md` — write-only, no consumers yet. Source spec: `ai-resources/logs/improvement-log.md` :183 ("Concurrent sessions cause TOCTOU races on shared log files" / Migration plan / Phase 1).

**Change scope (drafted):**

1. **`/prime` Step 8a.3.a, 8b.3.a, 8c.3** (all three `.prime-mtime` write sites): immediately after the existing `stat ... > logs/.prime-mtime` block, append a new bash block that increments a same-day session marker (or resets to `S1`) and writes `{YYYY-MM-DD} {marker}` to `logs/.session-marker`. Marker scheme per source spec: `S1` … `S9` → `Sa` … `Sz` (35 values/day, then wrap to `S1`). The single-line file format `{date} {value}` is parseable by a one-line awk read; date prefix lets the increment logic detect same-day vs day-rollover without separate stat. Existing today's-header / `.prime-mtime` behavior unchanged.

2. **`ai-resources/.gitignore`:** add one line `logs/.session-marker` (per-machine session state, not committed). Placed next to existing `logs/.prime-mtime` entry.

3. **`ai-resources/logs/improvement-log.md`:** flip entry :183 Status from "logged (pending)" to "Phase 1 applied 2026-05-28" with Verified line; annotate Phases 2–4 as `pending`. Update the supersession-note text at :174 (narrow predecessor entry) to append "Phase 1 of broader entry applied 2026-05-28."

**Explicit deviation from QC'd plan:** the QC'd Wave 3 session plan called for a brief-footer line "Session marker: {value}" in Step 6. Source spec does NOT require it (Phase 1 = "additive, zero risk, no consumers"), and there's a structural timing conflict (Step 6 brief renders BEFORE Step 8's marker write fires). Dropping the footer keeps Phase 1 truly additive; footer naturally lands in Phase 2 alongside the first consumer (`/session-start`).

**Phase scoping:** Phase 1 only. Phases 2 (consumer reads in `/session-start` + `/session-plan`), 3 (downstream consumers `/drift-check` / `/wrap-session` / `/contract-check` / `/qc-pass`), and 4 (legacy-fallback cleanup) are explicitly deferred per source migration plan.

**Concurrent-session context:** Wave 2 just landed (commit `f598ee1`) touching `prime.md` Steps 8a/8b/8c structure. My edits target the marker-write sub-step beneath each, which Wave 2's restructure preserved unchanged. No structural collision expected, but I'll re-read `prime.md` from disk right before applying.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists (Phase 2 consumer, not edited here)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists (Phase 2 consumer, not edited here)

## Verdict

GO

**Summary:** Phase 1 is intentionally additive write-only — no consumers exist on disk, file is gitignored from day one, edits are confined to three already-paired marker-write blocks in `/prime`, and the explicit footer-drop closes the one residual timing risk identified in the QC'd plan.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/prime` is `model: sonnet` (`prime.md`:2) and runs once per session at session-start — not per turn, not per tool call. New always-loaded cost is bounded to the session-start path, not every turn.
- Added content is a small bash block per site, three sites total. Each block is ~10 lines of shell (`increment-or-reset` logic + single `printf` write). Conservative envelope: ~30–50 tokens per site × 3 sites ≈ ~100–150 tokens added to `prime.md`, well under the Medium threshold for an always-loaded file (and `prime.md` is not always-loaded — slash commands load on invocation only).
- No new `@import`, no new hook, no new subagent. Pay-as-used via `/prime` invocation, no compounding.
- No skill trigger keywords or auto-load surface added.

### Dimension 2: Permissions Surface
**Risk:** Low

- New writes target `logs/.session-marker` — same `logs/` directory tree already covered by existing Write permissions used for `logs/.prime-mtime`, `logs/session-notes.md`, etc. No new path category.
- New reads are limited to the same file the same session just wrote. No cross-process or cross-repo read.
- No `Bash(...)` command pattern beyond `stat`, `awk`, `printf`, `cat` — all of which are already used in the surrounding `.prime-mtime` block (`prime.md`:163-164, :187-188, :205-206). No new tool family.
- No deny rule removed or narrowed. No scope change (project / user). No external API.

### Dimension 3: Blast Radius
**Risk:** Low

- Three files touched directly: `prime.md`, `.gitignore`, `improvement-log.md`. The log edit is a status flip plus a one-line supersession-note append — non-structural.
- Consumer enumeration via `grep -rn "\.session-marker"`: zero command/agent/skill files currently read `.session-marker`. Existing matches are all in audit / plan / log / scratchpad files (planning artifacts, not executable consumers). Specifically: `audits/risk-checks/2026-05-28-add-new-command-resolve-incident-mvp.md` line 75 (negative-coupling note: "not touched"), `audits/fix-plans/fix-repo-issues-2026-05-28-1902-wave3-structural.md` (the source plan), `logs/session-plan-pass2.md` (this session's plan), `logs/improvement-log.md` (the source spec), `logs/scratchpads/2026-05-28-19-19-scratchpad.md` (session scratchpad). Caller count: **0 executable consumers**.
- Existing `.prime-mtime` ecosystem (the analog file) is read by 3 commands (`session-start.md`:30/51/53/56, `session-plan.md`:21-25, `wrap-session.md`:76-79/129). Phase 1 does NOT modify these; they continue reading `.prime-mtime`, untouched.
- No contract change: the existing `.prime-mtime` write contract (mtime captured after header append, order-matters) is preserved verbatim. The new `.session-marker` is a sibling write with its own self-contained format — no downstream parse contract exists yet (Phase 2 will define one).
- `.gitignore` add is one line in a category that already exists ("Concurrent-session detection marker" block, .gitignore:30-31). Zero structural change.
- `improvement-log.md` status flip touches one entry's status + one supersession line — no schema or parser dependency.

### Dimension 4: Reversibility
**Risk:** Low

- Single-commit `git revert` cleanly reverses all three file edits (`prime.md`, `.gitignore`, `improvement-log.md`).
- On-disk state to clean up: `logs/.session-marker` itself (created at first post-change `/prime` run). Because the file is gitignored, `git revert` does not remove it — but the file is per-machine session state with no consumers and no semantic weight in the world post-revert. Trivial `rm logs/.session-marker` if cleanup desired; harmless if left.
- No state propagated beyond the local repo. No push, no Notion write, no external API.
- No automation (hook, cron, symlink) added — the marker write fires only when `/prime` runs and reaches Step 8.
- Append-only log (`improvement-log.md`) is touched only as a status flip on an existing entry, not an append of a new permanent log entry. Revert restores the prior "logged (pending)" status cleanly.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Write is fully self-contained within `/prime`. No other command currently knows about the file (verified by `grep -rn ".session-marker"` against `.claude/commands/`, `.claude/agents/`, `skills/`: zero hits in executable resources).
- The explicit footer-drop from the QC'd plan closes a real timing coupling: Step 6 brief renders BEFORE Step 8 marker write, so displaying the marker in the brief would have created a partial-state hazard. Phase 1 by intentionally not showing the marker avoids that coupling entirely. (Quote from CHANGE_DESCRIPTION: *"Step 6 brief renders BEFORE Step 8's marker write fires. Dropping the footer keeps Phase 1 truly additive."*)
- No new contract is created that downstream callers must honor: Phase 1 is write-only, and Phase 2's consumer contract is defined separately at that phase. The file format (`{YYYY-MM-DD} {marker}`) is internal to `/prime`'s same-day increment logic right now.
- No functional overlap with existing mechanisms. `.prime-mtime` and `.session-marker` carry orthogonal signals (mtime vs session identity); both write at the same three sites under the same order-matters discipline.
- Concurrent-session collision risk: Wave 2's recent edits to `prime.md` Steps 8a/8b/8c are restructure-not-content per CHANGE_DESCRIPTION; the marker-write sub-step beneath each is the target. The change author's stated mitigation ("re-read `prime.md` from disk right before applying") is the standard concurrent-session discipline.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (`prime.md`:2, :163-164, :187-188, :205-206; `session-start.md`:30/51/53/56; `session-plan.md`:21-25; `wrap-session.md`:76-79/129; `.gitignore`:30-31; `improvement-log.md`:174, :183, :228, :237), grep counts (zero executable consumers of `.session-marker`), and verbatim quotes from `CHANGE_DESCRIPTION` and source spec (`improvement-log.md` Migration plan Phase 1: "Risk: zero (additive)"). No training-data fallback was used.
