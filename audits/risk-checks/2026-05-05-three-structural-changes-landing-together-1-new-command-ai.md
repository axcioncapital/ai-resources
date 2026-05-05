# Risk Check — 2026-05-05

## Change

Three structural changes landing together: (1) New command `ai-resources/.claude/commands/session-start.md` — reads logs/session-notes.md, appends a Mandate line, accepts operator mandate text. (2) Patch to `.claude/commands/wrap-session.md` — inserts Step 2b between Steps 2 and 3: reads today's session-notes entry for a **Mandate:** line, if found auto-generates a 6-field Phase 3 session report from conversation context, asks operator 2 questions, appends a ### Session Report subsection. Fully conditional/backward-compatible (no Mandate line = skip silently). (3) New top-level directory `harness-prep/` at workspace root containing 5 active template/log files and 2 Phase-5 placeholder files. No changes to hooks, settings.json, or CLAUDE.md.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness-prep/` — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Two of three changes are low-risk additions, but the new `/session-start` command collides with an existing `session-start.sh` SessionStart hook and an existing `mandate-parser` skill, and the wrap-session patch is described against an ambiguous file path that maps to two different on-disk files with different step numbering — both ambiguities must be resolved before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New `/session-start` command is invoked on demand only — no auto-load hook, no `@import`, no CLAUDE.md inclusion. Pay-as-used (description: "appends a Mandate line, accepts operator mandate text").
- Patch to `wrap-session.md` adds Step 2b that runs only inside the existing `/wrap-session` invocation (already an on-demand command). Increment is "read today's entry, conditional auto-generate ~6-field block" — bounded, fires at most once per wrap.
- `harness-prep/` is described as a new top-level directory of files. Description does not state any auto-loading mechanism (no `@import`, no hook, no SessionStart inclusion). Files sit on disk until referenced. Token cost is therefore zero per session unless a future change wires them in.
- Conditional/backward-compatible nature of Step 2b — "no Mandate line = skip silently" — means the cost is at most one `Read` of today's session-notes entry per wrap, which already happens at Step 1 of the existing wrap-session flows (workspace `.claude/commands/wrap-session.md` line 8 reads session-notes.md last 5 lines; ai-resources version line 23 same).

### Dimension 2: Permissions Surface
**Risk:** Low

- Description explicitly states "No changes to hooks, settings.json, or CLAUDE.md."
- New command and new directory operate within existing permitted patterns. `.claude/settings.json` already contains `Edit(**)`, `Write(**)`, `Edit(harness/**)`, `Edit(logs/**)`, `Bash(*)` — verified at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` lines 18–55. New `harness-prep/` directory writes are covered under the wildcard `Edit(**)` and `Write(**)`.
- No new tool families, no glob widening beyond what is already in place, no deny-rule removal.

### Dimension 3: Blast Radius
**Risk:** Medium

Enumeration of existing components touched or implicated:

- **Two `wrap-session.md` files exist on disk** — the change description writes `.claude/commands/wrap-session.md`, which is ambiguous between:
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md` (real file, 24 lines, dated 2026-04-22 — verified by `file` command).
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` (real file, 363+ tokens, dated 2026-04-30, model: sonnet frontmatter).
  - Step numbering differs between the two (workspace: Step 2 at line 9, Step 3 at line 16; ai-resources: Step 2 at line 24, Step 3 at line 25 with later sub-steps 2b, 12b already present in ai-resources). Patching the wrong one will diverge the two further.
- **Existing `session-start.sh` SessionStart hook** at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/session-start.sh` already writes `harness/session/startup-state.json` and emits `additionalContext` instructing Claude to "Run mandate-parser skill" (line 62). A new `/session-start` slash command with overlapping name and overlapping responsibility (mandate handling) creates two systems with similar names doing similar work.
- **Existing `mandate-parser` skill** at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md` already implements "Phase A (Session Startup) for Agent Harness sessions. Reads the operator's session mandate ... writes mandate.json, appends to mandate-history.jsonl" (lines 3–8). The new `/session-start` command's "appends a Mandate line" overlaps this capability without referencing it.
- **Other callers grep'd:** 5 `.md` files reference `session-start.sh` outside of worktrees; 7 `.md` files reference `Mandate` outside of worktrees (most in `harness/schemas/` and `mandate-parser` skill). No existing slash command matches `/session-start`.
- **Wrap-session referencers:** workspace and ai-resources CLAUDE.md both reference `/wrap-session` as an end-of-session ritual (workspace CLAUDE.md line 149, ai-resources CLAUDE.md line 70). Adding Step 2b is backward-compatible per the description, so existing callers are unaffected — but only if the patch lands on the file that is actually invoked.
- **`harness-prep/` directory** does not appear in any existing `.md` file outside worktrees (grep found no references). It is genuinely net-new and isolated; the existing `harness/` directory is a separate and already-active component.

### Dimension 4: Reversibility
**Risk:** Medium

- The new command file (`session-start.md`) is a single file — `git revert` removes it cleanly.
- The wrap-session patch is a single-file edit — `git revert` cleanly restores prior state.
- The new `harness-prep/` directory contains 7 files per description (5 active + 2 placeholder). `git revert` of the creation commit removes the tracked files; if any of those files are written/appended to during a session before revert, revert will lose those mid-session additions. Two of the seven files are described as "active log files," meaning state will accumulate in them — append-only log mutations cannot be cleanly reverted by git alone.
- If `/session-start` is invoked in even one session before revert, it will have appended a `Mandate:` line to `logs/session-notes.md`. That line then triggers the new Step 2b in `/wrap-session`, which appends a `### Session Report` subsection. Both mutations land in `logs/session-notes.md` — an append-only log. After revert of the command/patch files, the session-notes.md entries remain, requiring manual cleanup.
- Verdict: revert works for the code but not for the log-state propagation downstream. One extra cleanup step per session-notes entry that contains a `Mandate:` line or `### Session Report` subsection.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Naming collision with existing SessionStart hook.** A slash command named `/session-start` and a hook script named `session-start.sh` are functionally distinct (one is an operator-invoked command, the other is an automatic hook), but the name overlap creates operator confusion: which `session-start` runs at which moment? The description does not name the existing hook or explain the relationship. This is the textbook "two systems both trying to handle the same concern" pattern flagged in the Dimension 5 rubric.
- **Functional overlap with existing `mandate-parser` skill.** The mandate-parser skill is the canonical Phase A startup writer (writes `mandate.json`, `mandate-history.jsonl`, `session-log.json`). The new `/session-start` command also accepts operator mandate text and appends a Mandate line. Two paths now exist for "operator gives mandate at session start," with no documented relationship between them. Either the new command supersedes the skill (in which case the skill needs deprecation) or it is a parallel lightweight path (in which case the boundary needs to be documented at both call sites).
- **Implicit contract: `Mandate:` marker format.** Step 2b's auto-generation depends on detecting a "**Mandate:** line" inside today's session-notes entry. The contract (exact marker syntax — bold-colon vs colon-only, position within the entry, leading whitespace tolerance) is not stated in the description and is not pre-existing in `logs/session-notes.md` (grep returned zero matches for `Mandate:` in current `logs/`). Wrap-session must agree with session-start on the exact regex; if the contract is documented in only one of the two files (or neither), drift is inevitable.
- **Implicit contract: 6-field Phase 3 session report.** The description names "6-field Phase 3 session report" but does not enumerate the fields. `harness-prep/` is presumably the source of truth for that schema, but no referenced file documents it from the change description alone. Field-name drift between the wrap-session patch and the harness-prep templates is a real failure mode.
- **Two `wrap-session.md` files on disk.** The patch landing on only one of them (per the ambiguous path) will silently leave the other version unpatched. Operators in different invocation contexts will then see different wrap behaviors, with no error surface.
- **Path semantics of `harness-prep/` vs existing `harness/`.** Workspace already has a top-level `harness/` directory (the active harness system with `session/`, `schemas/`, `learning/`, `reports/` subdirs — verified by `ls`). A sibling `harness-prep/` directory creates a naming pattern that suggests "scratch/staging area for harness work," but the relationship to the canonical `harness/` is undefined. Future operators (or future Claude sessions) may misroute writes between the two.

## Mitigations

- **Dimension 5 — name collision (HIGH):** Before landing, either rename the new command (e.g., `/mandate-set`, `/session-mandate`, `/harness-prep-start`) to eliminate the `session-start` naming overlap with the existing hook, OR add a one-paragraph "Relationship to existing components" section at the top of the new `session-start.md` that names both the existing `session-start.sh` hook and the existing `mandate-parser` skill and states the boundary explicitly (when each fires, which writes which file).
- **Dimension 5 — implicit `Mandate:` contract (HIGH):** Before landing, document the exact marker syntax (verbatim regex or literal string) in BOTH the new `session-start.md` (under a "Contract with /wrap-session" subsection) AND in the patched wrap-session.md Step 2b (under "Marker format expected"). Identical wording in both files. Without this, future edits to either side will silently drift.
- **Dimension 5 — 6-field schema undefined (HIGH):** Before landing, enumerate the 6 fields by name in the wrap-session Step 2b body (not by reference to "the schema"). If the schema lives in a `harness-prep/` template, quote it inline so the wrap-session command does not depend on a sibling file's stability.
- **Dimension 3 — wrap-session path ambiguity (MEDIUM):** Before landing, restate the change description with the absolute path of which `wrap-session.md` is being patched (workspace root vs `ai-resources/.claude/commands/`). If both are intended, land both patches as one change and verify Step numbering matches in each. If only one is intended, document why the other is excluded.
- **Dimension 4 — log-state propagation (MEDIUM):** Add a one-line operator note to the new command and the patched wrap-session step: "If reverted, `Mandate:` lines and `### Session Report` subsections in `logs/session-notes.md` from prior sessions remain and must be removed by hand." This aligns operator expectations with the actual revert behavior.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. Per the Step 1 rule, files tagged `not yet present` (`session-start.md`, `harness-prep/`) were evaluated based only on intent described in CHANGE_DESCRIPTION, with that limitation reflected in mitigation wording (schema/contract enumeration cannot be cross-checked against artifact text).
