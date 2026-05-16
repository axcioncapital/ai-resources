# Risk Check — 2026-05-16

## Change

Tier 2 batch (reduced after pre-validation) — 4 mechanical edits:

1. **ADV-1 — workspace permission normalization.** In `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json`, line 19: change `"Bash(git push *)"` → `"Bash(git push*)"` (remove the space before `*`). Per `ai-resources/docs/permission-template.md`, the canonical form is `Bash(git push*)` without the space (Detection rulebook ADV-13). Permission semantics unchanged — both patterns match the same git push commands; this is form normalization only.

2. **ADV-7 — gitignore addition.** Add an explicit `.claude/settings.local.json` entry to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore`. The file is currently covered only by the global `~/.config/git/ignore`. Adds one line. Class-free change (no settings.json or hook touched).

3. **LE4 — broken symlink repoint.** `projects/obsidian-pe-kb/.claude/commands/resolve-improvements.md` is a symlink pointing to `ai-resources/.claude/commands/resolve-improvements.md` which no longer exists (renamed to `resolve-improvement-log.md`). Delete the broken symlink and create a new symlink at the same path pointing to `ai-resources/.claude/commands/resolve-improvement-log.md` (which exists, verified). Restores correct cross-repo command access.

4. **G1 doc edit — extend permission-template.md Hook wiring section.** Currently `permission-template.md` (lines 244–254) documents only the `check-permission-sanity.sh` upward-walk hook block. Add a parallel canonical block for `auto-sync-shared.sh` using the same upward-walk idiom (verified clean in all 8 existing project settings.json files). Doc edit to `ai-resources/docs/permission-template.md` only — no settings.json changes.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/commands/resolve-improvements.md — exists (broken symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md — exists (symlink target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists

## Verdict

GO

**Summary:** Four mechanical, scope-bounded edits with no permission widening, no contract changes, no always-loaded token cost, and clean revertibility; each item is independently grounded against the canonical permission-template.md and verified file state.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Item 1 (settings.json line 19 rewrite) replaces 19 chars with 18 chars in workspace `settings.json`; settings.json is not session-loaded as prompt context, only consulted by the harness for permission resolution — zero token cost in chat.
- Item 2 adds one line to `ai-resources/.gitignore` (file is not auto-loaded into any session context; consulted only by git).
- Item 3 is a filesystem symlink swap — no file content added to any loaded resource.
- Item 4 extends `permission-template.md` Hook wiring section (lines 244–254) by one parallel JSON block. `permission-template.md` is NOT in any always-loaded path (workspace CLAUDE.md and ai-resources CLAUDE.md reference it as `docs/permission-template.md` for `/permission-sweep` and `/new-project` only — pay-as-used). Verified: `ai-resources/CLAUDE.md` § Permission Management references the file but does not `@import` it.
- No hook, subagent brief, skill, or always-loaded CLAUDE.md is touched.

### Dimension 2: Permissions Surface
**Risk:** Low

- Item 1: form normalization only. `Bash(git push *)` and `Bash(git push*)` both match the same `git push ...` commands (the canonical-shape footnote in `permission-template.md` lines 132 and 286 confirms `Bash(git push*)` is the canonical form). No new capability, no narrowed deny, no scope escalation.
- Item 2: gitignore addition tightens VCS hygiene by ensuring `settings.local.json` cannot be accidentally committed. This is a hardening change, not a widening.
- Item 3: symlink repoint to a file in the same `ai-resources/.claude/commands/` directory the old target lived in. No new permission required (Read on `**/.claude/**` already grants access).
- Item 4: doc edit to `permission-template.md`. No `.claude/settings.json` file modified — no permission entry changed in any executing layer. The new hook block being documented is already present in 8 of the project settings.json files (verified via grep — see Blast Radius enumeration); this only catches the doc up to existing state.

### Dimension 3: Blast Radius
**Risk:** Low

- Item 1: 1 file edited (workspace `.claude/settings.json` line 19). No callers depend on the specific space-vs-no-space form — grep across `*.json` in the workspace shows 19 occurrences of `Bash(git push*)` and 2 of `Bash(git push *)` (the workspace root settings.json plus one worktree copy under `.claude/worktrees/`); the latter is an isolated worktree snapshot and not a primary caller.
- Item 2: 1 file edited (`ai-resources/.gitignore`). No callers; gitignore is read by git only.
- Item 3: 1 symlink swapped in `projects/obsidian-pe-kb/.claude/commands/`. Verified target exists: `ls -la` confirms `ai-resources/.claude/commands/resolve-improvement-log.md` is a 7,336-byte regular file (mtime May 8). The broken symlink currently 404s; grep for `resolve-improvements` in ai-resources surfaces only dated audit/registry references that record this broken state as a known issue (innovation-sweep-2026-05-16.md LE4 explicitly prescribes this repoint) — no active command, skill, or hook depends on the old name resolving.
- Item 4: 1 doc file edited (`permission-template.md`). 8 project settings.json files already wire `auto-sync-shared.sh` via the exact upward-walk idiom being documented (grep count above). `new-project.md` references `auto-sync-shared.sh` in 5 places already, and the literal `AUTO_SYNC_HOOK` constant at line 312 is the source-of-truth — the doc addition is catch-up, not a contract change. `/permission-sweep` reads `permission-template.md` but a doc-only insertion of a parallel canonical block does not change its detection rulebook (rules 1–14 unaffected).

### Dimension 4: Reversibility
**Risk:** Low

- Item 1: single-character revert via `git revert` restores prior form.
- Item 2: one-line revert in `.gitignore`; clean.
- Item 3: symlink swap is reversible by recreating the old symlink (though doing so would reinstate the broken state — there is no good reason to revert this one). Either way, `ln -sfn` is idempotent and reversible.
- Item 4: doc-block insertion; `git revert` restores prior `permission-template.md` content fully.
- No external writes (no push, no Notion, no API). No append-only log mutation. No automation fires between landing and a potential revert (the items do not register new hooks or schedules).

### Dimension 5: Hidden Coupling
**Risk:** Low

- Item 1: the canonical-form rule is explicitly documented at `permission-template.md` line 286 (Detection rulebook ADV-13: "Bash(foo *) vs Bash(foo:*) — prefer the former") and the Layer C example at line 132 uses `Bash(git push*)` without the space. Bringing the workspace root into line with the canonical Layer B shape on line 132 of the doc surfaces a pre-existing implicit contract, not a new one.
- Item 2: `.gitignore` is a self-contained mechanism. No coupling to settings/hook/skill behavior; rule 14 in the detection rulebook (line 287) already establishes the convention that deny scopes should be paired with gitignore entries.
- Item 3: symlink target rename was completed previously; this item closes the loop. No silent dependency — the new target name (`resolve-improvement-log.md`) is what every other project already symlinks to (grep confirms 14 active references to `resolve-improvement-log` across audits with no broken targets in those other projects).
- Item 4: the upward-walk idiom being documented is identical to the existing `check-permission-sanity.sh` block at lines 248–255 (same `while`/`dirname`/`-x` shape, same timeout convention) and matches the AUTO_SYNC_HOOK literal at `new-project.md` line 312. No new contract; no functional overlap (the two hooks do different things — sanity check vs. command sync).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). Specific groundings: workspace `settings.json` line 19 content read directly; `permission-template.md` lines 132, 244–254, 286, 287 read directly; symlink state confirmed via `ls -la` (broken source + 7,336-byte target); grep counts for `Bash(git push` patterns across workspace `.json` files (19 canonical, 2 spaced); 8 active project settings.json files already wiring `auto-sync-shared.sh` confirmed via grep. No training-data fallback used.
