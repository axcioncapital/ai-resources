# Risk Check — 2026-05-20

## Change

Two new project-local commands created in `.claude/commands/`: `diagnose-kb-update.md` and `apply-kb-update.md`. Session 1 command (`diagnose-kb-update`) reads from `/knowledge-bases/pe-kb-vault/` (cross-project read via `--add-dir`) and writes to `logs/research-updates/`. Session 2 command (`apply-kb-update`) reads an operator-edited diagnostic report and writes new draft versions to `parts/part-2-service/drafts/`. Neither command writes to `parts/part-2-service/approved/` or to the pe-kb vault.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/diagnose-kb-update.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/.claude/commands/apply-kb-update.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Two on-demand commands with no always-loaded token cost and no permission widening, but the `apply-kb-update` write path silently triggers the project's `PostToolUse` auto-commit hook and the commands depend on undocumented vault and directory conventions — both manageable with explicit operator-side steps.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Both commands are pay-as-used slash commands invoked on demand — no always-loaded cost. They are not `@import`ed by any CLAUDE.md and add nothing to workspace or project CLAUDE.md (verified: no reference to either command in project CLAUDE.md, workspace CLAUDE.md, or ai-resources CLAUDE.md).
- Both declare `friction-log: true` in frontmatter (`diagnose-kb-update.md:2`, `apply-kb-update.md:2`). This is opt-in per the project CLAUDE.md "Friction Log Auto-Start" convention — it triggers an existing `PreToolUse` hook only when the command runs, not per session. No new hook is registered.
- Both declare `model: opus` in frontmatter (`diagnose-kb-update.md:3`, `apply-kb-update.md:3`) — a per-command tier, the only permitted out-of-session tier mechanism per workspace CLAUDE.md § Model Tier. No `"model"` field added to any settings file. Compliant.
- `diagnose-kb-update` reads all nine Part 2 approved modules plus N pe-kb articles in one run (`diagnose-kb-update.md:24-25`, Step 2); `apply-kb-update` reads only the diagnostic report plus the affected approved modules. Both are per-invocation reads, not recurring costs.

### Dimension 2: Permissions Surface
**Risk:** Low

- No change to `.claude/settings.json` `permissions` block is part of this change set (the change is two new command `.md` files only). The settings file already grants `Read`, `Write`, `Edit`, `Bash(*)`, and `Write(**/.claude/**)` with `"defaultMode": "bypassPermissions"`.
- The cross-project vault read is already authorized: the pe-kb vault resolves to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/pe-kb-vault/` (verified on disk), which sits inside the workspace root already listed in `settings.json` `additionalDirectories`. The `--add-dir /knowledge-bases/pe-kb-vault` mentioned in `diagnose-kb-update.md:9` is therefore a launch-time convenience, not a new permission grant — the directory is already reachable.
- Both write targets (`logs/research-updates/`, `parts/part-2-service/drafts/`) are inside the project tree, covered by the existing broad `Write` allow entry. No new tool family, no `deny` rule removed, no scope escalation.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 2 new command files only. No existing file is modified by the change set itself.
- Inbound references: `grep -rl "diagnose-kb-update\|apply-kb-update" ai-resources/` returned 0 hits — no skill, agent, command, or hook in `ai-resources/` invokes either command. Within the project, `grep -rln "research-updates"` returned only `logs/session-notes.md` (a log mention, not a code dependency).
- Outbound contract dependencies the commands rely on:
  - `apply-kb-update` parses the diagnostic report's `**Verdict:**`, `**Source:**`, `**Target:**`, `**Notes:**` markers (`apply-kb-update.md:17-19, 44, 53`). The producer of that contract is `diagnose-kb-update`'s own report format block (`diagnose-kb-update.md:74-115`) — the pair is internally consistent and self-contained.
  - The completion message of `apply-kb-update` directs the operator to `/review`, `/challenge`, `/service-design-review` (`apply-kb-update.md:96-98`). All three exist as project commands (verified: `review.md`, `challenge.md`, `service-design-review.md` in `.claude/commands/`). No caller of those commands needs modification — the new command only points at them.
- Shared infrastructure touched indirectly: the project `PostToolUse` Write hook auto-commits any file written under `/(preparation|execution|analysis|report|parts)/`. `apply-kb-update` writes to `parts/part-2-service/drafts/` — every draft it writes is auto-committed by that hook. The hook regex does NOT match `logs/research-updates/`, so diagnostic and implementation-log files written by these commands are NOT auto-committed. This is a pre-existing hook reacting to the new write path; it does not break, but it changes commit behavior silently (see Dimension 5).
- No subagent input schema, frontmatter schema, or hook output shape is altered. Conclusion: isolated 2-file addition, no caller requires modification, but it interacts with shared commit infrastructure — Medium.

### Dimension 4: Reversibility
**Risk:** Medium

- The two command files are new isolated files; deleting them (or `git revert` of their introducing commit) cleanly removes the capability with no stale references, since 0 inbound callers exist.
- The introducing commit `da4de73` named in the input note is NOT present in this repo (`git cat-file -t da4de73` → not found; `git log --all` shows no match). I therefore cannot confirm the commit boundary or what else it bundled. The command files themselves exist on disk and are evaluated as such; the revert path for the actual commit cannot be verified from the inputs. Flagged as an evidence limit, not assumed clean.
- Runtime side effects of *running* the commands are only partially git-reversible:
  - Draft files under `parts/part-2-service/drafts/` are auto-committed by the `PostToolUse` Write hook. Reverting a bad KB-update run means reverting those individual artifact commits, not just discarding working-tree changes — one extra step beyond a plain `git checkout`.
  - Diagnostic and implementation-log files under `logs/research-updates/` are NOT auto-committed (hook regex miss), so they linger as untracked working-tree files until manually staged or deleted — a separate cleanup track from the drafts.
- No external writes (no push, no Notion, no API POST) and no automation is added by the change. Rollback is multi-track (command files + auto-committed drafts + untracked logs) but all within git/working-tree — Medium, not High.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Silent interaction with the auto-commit hook: `apply-kb-update` writes to `parts/part-2-service/drafts/`, which the project `PostToolUse` Write hook matches and auto-commits one-per-file. Neither command file mentions this — an operator reading `apply-kb-update.md` would not know each draft lands as its own commit. The command's own completion message (`apply-kb-update.md:84-99`) implies drafts are merely "created," not committed. Undocumented behavioral coupling at the change site.
- Asymmetric log handling: diagnostic reports and implementation logs go to `logs/research-updates/` (`diagnose-kb-update.md:51`, `apply-kb-update.md:69`), which the same hook does NOT match — so those files are left untracked. The two write destinations of this feature behave differently under the commit hook, and nothing documents the split.
- Vault path convention dependency: `diagnose-kb-update` hardcodes the vault-relative path shape `wiki/{topic}/{slug}.md` and resolves against `/knowledge-bases/pe-kb-vault/` (`diagnose-kb-update.md:9, 16`). The vault's actual top-level layout on disk is `wiki/`, `raw/`, `skills/`, `templates/`, `logs/` — so `wiki/...` is currently valid, but the command depends on the vault keeping that layout, a convention owned by a separate project and not pinned by anything in this project. If the vault reorganizes, the command breaks silently with "unresolvable paths."
- New parse contract is documented at the change site: the `**Verdict:**` / `**Source:**` / `**Target:**` markers consumed by `apply-kb-update` are fully specified in `diagnose-kb-update`'s report-format block — this part is properly documented, reducing what would otherwise be a higher coupling score.
- Directory-creation assumption: `logs/research-updates/` does not yet exist (verified on disk); `diagnose-kb-update.md:51` instructs creating it. First run depends on the command actually performing the `mkdir` — a one-time bootstrap coupling, low-severity but worth noting.

## Mitigations

- **Dimension 3 (Blast Radius) / Dimension 5 (Hidden Coupling) — auto-commit interaction:** Before relying on `apply-kb-update` in routine use, add one line to `apply-kb-update.md` (e.g., under Step 4 or in the completion message) stating that each draft written to `parts/part-2-service/drafts/` is auto-committed individually by the project's `PostToolUse` Write hook, and that diagnostic/implementation-log files under `logs/research-updates/` are NOT auto-committed and must be staged or cleaned manually. This makes the commit behavior visible at the change site.
- **Dimension 4 (Reversibility):** Operator should treat a KB-update run as reversible only via reverting the per-draft artifact commits the hook produces — confirm the introducing commit `da4de73` (not found in this repo) and the per-draft auto-commits are on a feature branch or otherwise easy to identify before running the pair against the live Part 2 model, so a bad run can be reverted as a contiguous set.
- **Dimension 5 (Hidden Coupling) — vault layout dependency:** Add a one-line note in `diagnose-kb-update.md` recording that it depends on the pe-kb vault keeping its `wiki/{topic}/{slug}.md` layout, so a future vault reorganization has a documented breakage point; the existing "halt on unresolvable paths" check (`diagnose-kb-update.md:17`) already fails safely, so no behavioral fix is needed — only the documented dependency.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, on-disk directory checks, or explicit evidence-limit flags — notably the unverifiable commit `da4de73`). No training-data fallback was used on fetch/read failures.
