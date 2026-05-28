# Risk Check — 2026-05-28

## Change

FX-E2 — Graduate `decision: block` permission pattern to canonical documentation.

**Proposal:**
1. Add a new named section to `ai-resources/docs/permission-template.md` documenting the `decision: block` PreToolUse Edit hook pattern as a canonical permission shape. The pattern uses a jq pipeline inside a hook command to return `{"decision":"block","reason":"..."}` JSON, which causes Claude Code to block the Edit tool call before it runs. Path-scoped via grep regex inside the jq pipeline.
2. Add a brief cross-reference comment inside the Nordic PE `.claude/settings.json` (next to the existing `decision: block` jq pipeline at the PreToolUse Edit matcher) pointing to the new canonical section in `permission-template.md`.

**Current state:**
- The pattern exists ONLY in `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (lines 60–70). It guards `report/chapters/` and `final/modules/` paths from direct Edit via a BRIGHT-LINE rule reason string.
- `ai-resources/docs/permission-template.md` documents permission-template canonical shapes (allow/deny lists across layers A–D, hook wiring blocks for prevention, PostToolUse fan-out wiring) but contains NO section on PreToolUse hook-based blocking patterns.
- The new section would be a sibling to the existing "PostToolUse[Write] fan-out wiring taxonomy" section — likely placed after it, before "Detection rulebook".

**What is NOT in this proposal:**
- No change to `settings.json` files anywhere (only a small explanatory comment near the existing pattern; the existing block stays functional and project-local).
- No change to `/permission-sweep` (the new section is documentation; the sweep does not need to mechanically detect this pattern for other projects until they opt in).

**Context:**
- Plan source: `projects/nordic-pe-macro-landscape-H1-2026/plans/graduate-phase-plan-v1.md` Step 4 (lines 137–143).
- Plan-intent: a **documentation** graduation, not a settings.json change. Pattern documented in canonical so other projects can adopt the same shape when guarding sensitive paths from direct Edit.
- The reason string in the existing implementation references Nordic PE's BRIGHT-LINE rule. The canonical doc section will describe the pattern generically (use cases, jq pipeline shape, how to swap the regex for different guarded paths) — the project-specific reason text stays local.

**Structural class:** permission-changes (canonical permission-template doc edit).

**Reversibility:** trivial — `git revert` the doc edit and the project comment.

**Blast radius:** documentation-only for the canonical layer. Project settings get a one-line comment. No mechanical behavior change in any file. Future projects opting in would each be their own decision.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/plans/graduate-phase-plan-v1.md` — exists

## Verdict

GO

**Summary:** Documentation-only graduation of an existing project-local hook pattern to a canonical reference section, with no settings.json semantics change and a one-line cross-reference comment as the only behavior-adjacent edit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `permission-template.md` is not always-loaded — it is read by `/permission-sweep` and `/new-project` on invocation, not on every session. Confirmed by reading `permission-template.md` line 3: "Referenced by `/permission-sweep` (diagnose + remediate) and `/new-project` (Post-Pipeline Enrichment step 2)" — both are pay-as-used commands.
- The doc currently sits at 352 lines / ~19 KB (Bash: `wc -l docs/permission-template.md` → 352; `ls -la` → 19062 bytes). A new section sibling to "PostToolUse[Write] fan-out wiring taxonomy" (lines 284–310, ~27 lines) is a comparable addition — roughly +25–50 lines / +1–3 KB. This raises per-invocation cost only, not ongoing per-session cost.
- The Nordic PE `settings.json` comment is a single line of explanatory text. JSON files are not auto-loaded into the model context except when explicitly read by a session/command. No per-turn cost.
- No new hook, no new `@import`, no CLAUDE.md edit, no new always-loaded surface.

### Dimension 2: Permissions Surface
**Risk:** Low

- The change explicitly states: "No change to `settings.json` files anywhere (only a small explanatory comment near the existing pattern; the existing block stays functional and project-local)." Verified against the existing pattern at lines 60–70 of Nordic PE `settings.json` — the jq pipeline already exists and continues to operate unchanged.
- No new `allow` or `ask` entry. No `deny` removed or narrowed. No new tool invocation pattern authorized.
- The `decision: block` mechanism itself is a *narrowing* behavior (it blocks Edit calls in a path scope), not a widening one. Documenting it does not change any permission grant.
- The canonical doc gains descriptive text only — no machine-readable permission grants are introduced or modified.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 2 — `ai-resources/docs/permission-template.md` (new section) and `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (one-line comment).
- Consumers of `permission-template.md` enumerated via grep across `ai-resources/`: 7 referrers — `.claude/commands/deploy-workflow.md`, `.claude/commands/permission-sweep.md`, `.claude/commands/new-project.md`, `.claude/commands/placement.md`, `.claude/commands/session-plan.md`, `.claude/agents/permission-sweep-auditor.md`, `.claude/agents/innovation-triage-auditor.md` (grep result above).
- All 7 referrers consume `permission-template.md` as a *read-only reference* — they read the file to learn canonical shapes, not to pattern-match on a specific section name. Confirmed: `permission-sweep-auditor.md` line 23 reads the file as `TEMPLATE_PATH` for "canonical shapes and the detection rulebook"; no consumer references "PostToolUse[Write] fan-out wiring" or other section names by exact title. Adding a new sibling section is additive and compatible with all 7 consumers.
- No contract change: the doc's structure (named sections under `##`) is preserved. No frontmatter schema, output shape, or invocation syntax altered.
- The `decision: block` pattern itself is unique to Nordic PE (grep across whole repo: only matches in `CLAUDE.md` documents about harness rules, plus `logs/session-notes.md` and `harness/schemas/current-state-schema.md` — no other settings.json contains the jq pipeline). No other project depends on it.
- `templates/project-settings.json.template` does NOT contain the pattern (confirmed via grep) — so the canonical template chassis is unaffected.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file revert restores prior state cleanly for both edits. `git revert` of the doc-section addition removes the lines verbatim; revert of the Nordic PE settings.json comment removes the inline comment.
- No append-only log entry, no archive write, no external state push, no automation registered.
- The change does not push state beyond the local repo prior to operator-approved push (Autonomy Rule #2).
- No cached permission state, no operator muscle-memory dependency on a new command or flag — the new section is reference content, not a command invocation.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change is self-contained. The new doc section describes the existing Nordic PE jq pipeline shape; the cross-reference comment names the canonical doc path. Both ends of the cross-reference are explicit.
- No silent auto-firing — the documentation does not create or register any hook, listener, or trigger. The existing PreToolUse Edit hook in Nordic PE remains the only active instance.
- No functional overlap with existing mechanisms: the doc adds reference content sibling to "PostToolUse[Write] fan-out wiring taxonomy" (lines 284–310), which is a parallel hook-pattern reference. The two sections describe distinct hook events (PreToolUse Edit vs PostToolUse Write) with no overlap.
- One implicit dependency worth naming: the new section will reference Nordic PE settings.json lines 60–70 as the live example. If those lines later move or are renumbered, the cross-reference comment in settings.json still points to the canonical doc (one-way reference) — the doc, if it cites line numbers, may drift. **Advisory only** (not a risk-elevator): cite the pattern by feature (PreToolUse Edit matcher with jq-decision-block pipeline), not by line numbers, in the new section.
- Settings.json `//` comments are non-standard JSON. JSONC-style comments break strict JSON parsers. **Advisory only**: verify Claude Code's settings loader tolerates inline `//` comments before adding one — if not, use a sibling `_comment` key or a separate `.md` sibling note instead. (The Nordic PE settings.json currently contains no comments, suggesting comments may not be supported; verify before applying.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line references to `permission-template.md` (line 3 for consumer enumeration; lines 284–310 for the sibling-section comparator), Nordic PE settings.json lines 60–70 for the existing pattern shape, file size (`wc -l`: 352 lines; `ls -la`: 19062 bytes), grep counts (7 referrers to permission-template across `.claude/commands` and `.claude/agents`; 0 occurrences of the `decision: block` pattern in `templates/project-settings.json.template`; only Nordic PE settings.json contains the active pattern), and verbatim quotes from the CHANGE_DESCRIPTION and the graduate-phase-plan-v1.md Step 4 block. No training-data fallback was used.
