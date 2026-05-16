# Risk Check — 2026-05-16

## Change

Item #6 of an improvement-log execution sprint: add a "Read-scope floors" principle to workspace CLAUDE.md (cross-cutting, always-loaded) under "Design Judgment Principles" or "Working Principles" — one short rule stating that N-line read-scope specs in commands are floors not ceilings, and Claude must expand when downstream claims are load-bearing. Simultaneously edit .claude/commands/friday-act.md (and .claude/commands/friday-so.md if the same pattern is found) to add an explicit floor-not-ceiling note in the initial read step. The CLAUDE.md edit is the in-class change; the command file edits are not in class. All edits are additive (new rule text inserted into existing sections); no existing rules removed or restructured.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-so.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Additive workspace-CLAUDE.md rule + one command edit; small but real always-loaded token cost, and the new principle creates a soft contract that interacts with at least 8 other commands using line-peek patterns — friday-so does not contain the targeted pattern in its initial-read step so the second command edit should be dropped.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Workspace CLAUDE.md is always loaded for every session in the workspace. Current size 163 lines (`wc -l` on `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`).
- Change description says "one short rule" — single bullet under an existing section. Estimated 60–120 tokens added (a one-bullet principle line is typically ~30–60 tokens; description hedges between "Design Judgment Principles" and "Working Principles" so framing prose may add overhead).
- This crosses the Medium threshold (~50–150 tokens) for always-loaded files. Cost is paid every session in the workspace, including sessions that never touch a command with a line-peek pattern.
- Command file edits (friday-act, friday-so) are pay-as-used — only loaded when the command runs — so they do not contribute to baseline cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` change. No `allow`/`deny`/`ask` additions. No new tool family, no new shell pattern, no scope escalation.
- Change is pure prose edits to two markdown files.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touches: 2 (workspace CLAUDE.md + friday-act.md). The change description proposes a third (friday-so.md) conditional on finding the pattern there.
- **Pattern enumeration across commands** (grep for `30-line\|first 30 lines\|peek\|N-line\|line peek\|read-scope` in `.claude/commands/`): 8 files match — `friction-log.md`, `friday-journal.md`, `friday-checkup.md`, `note.md`, `audit-critical-resources.md`, `innovation-sweep.md`, `permission-sweep.md`, `friday-act.md`.
- **friday-so.md does NOT match the pattern.** Verified via two greps: (a) `grep -l "first 30 lines\|30-line peek\|line peek" .claude/commands/*.md` returns only `friday-act.md`; (b) friday-so Step 3 reads "the full contents of the report" (line 20) — no N-line read-scope spec exists to annotate as a floor. The conditional clause in the change description ("and .claude/commands/friday-so.md if the same pattern is found") correctly self-resolves to "do not edit friday-so."
- New principle in workspace CLAUDE.md creates a soft contract that all 8 line-peek-using commands inherit by reference — even though those commands are not edited in this change, future operators reading those commands will be expected to apply the new floor rule. This is the medium-blast-radius signal: the rule's reach is wider than the files it touches.
- No contract change to a parseable schema, hook output shape, or command-invocation syntax. Backwards-compatible.

### Dimension 4: Reversibility
**Risk:** Low

- Pure markdown edits to two files in the same working tree. `git revert` cleans up fully.
- No sibling files, no log/data appends, no settings.json mutation, no external state propagation.
- No automation registered (no hook, no cron, no symlink).
- Soft "muscle memory" risk only — operator may internalize the new principle and apply it informally even after a revert — but this is not a state-restoration issue.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- New principle introduces a contract — "N-line read-scope specs are floors not ceilings" — that depends on every command-author and Claude inferring (a) which N-line specs in commands qualify as "read-scope specs" (vs. e.g., display caps or output truncations), and (b) when downstream claims are "load-bearing" enough to trigger expansion. Both terms are judgment-loaded and not defined at the change site per the change description ("one short rule").
- Functional overlap risk: friday-act.md Step 16a (lines 158–179) already encodes a richer pattern — targeted section reads with explicit fallback to 30-line peek and a documented rationale (Notes line 419). A blanket "floor not ceiling" rule in CLAUDE.md may double-up with command-local nuance, or conflict with commands like `audit-critical-resources.md` / `permission-sweep.md` where a 30-line cap may be a deliberate cost control rather than a placeholder floor.
- The change description does not state where the principle lives ("Design Judgment Principles" OR "Working Principles") — a small implicit decision, but it affects how the rule is grouped with sibling principles and therefore how Claude weights it against `## Decision-Point Posture`, `## Completion Standard`, etc.
- One mitigation already in description: the friday-act edit makes the floor explicit at one of the highest-traffic call sites, reducing reliance on the global rule alone.

## Mitigations

- **Dimension 1 (usage cost):** Keep the new CLAUDE.md bullet to a single line — one declarative sentence, no examples, no parenthetical. Target ≤ 30 tokens added to the always-loaded file. If wording cannot fit in one line, place the full rule in a referenced doc (e.g., `ai-resources/docs/read-scope-floors.md`) and leave a one-line pointer in CLAUDE.md per the established `## Cross-Model Rules` / `## QC Independence Rule` pattern (workspace CLAUDE.md lines 23–25 and 40–42).
- **Dimension 3 (blast radius):** Drop the friday-so.md edit from scope — grep confirms the pattern does not exist there (Step 3 reads full contents). Edit only workspace CLAUDE.md + friday-act.md. Note in the commit message that the other 7 line-peek-using commands (friction-log, friday-journal, friday-checkup, note, audit-critical-resources, innovation-sweep, permission-sweep) inherit the new floor rule by reference and are deliberately not edited in this change to keep the diff minimal.
- **Dimension 5 (hidden coupling):** In the workspace CLAUDE.md bullet, name the trigger explicitly — e.g., "when a downstream step's correctness depends on content past the read window" — to reduce judgment ambiguity. Place the bullet under "Working Principles" rather than "Design Judgment Principles": the latter section is reserved for conflict-surfacing / analytical-output rules per the existing two bullets (lines 37–38), while Working Principles already hosts operational mechanics (versioning, compaction). Decide and state the placement choice in the commit message so it doesn't drift in a future audit.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file paths and line counts (workspace CLAUDE.md 163 lines, friday-act.md 425 lines, friday-so.md 58 lines), verbatim quotes from friday-act.md (lines 158, 164, 170, 416, 419), grep counts (8 commands match line-peek patterns; 1 command — only friday-act — matches the literal "first 30 lines / 30-line peek / line peek" phrasing; friday-so does not match), and verbatim quotes from CHANGE_DESCRIPTION. No training-data fallback was used.
