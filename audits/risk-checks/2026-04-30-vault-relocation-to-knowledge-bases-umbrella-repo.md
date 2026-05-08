# Risk Check — 2026-04-30

## Change

Proposed structural change: separate the PE-KB vault content into its own git repo (the new umbrella `obsidian-knowledge-base` GitHub repo, intended to host all future Axcíon KB vaults as siblings), and physically relocate it on disk to make room for future siblings.

## Change components

1. **Filesystem move.** `projects/obsidian-pe-kb/vault/` → `knowledge-bases/pe-kb-vault/` (new top-level `knowledge-bases/` folder under workspace root, sibling to `projects/`). One `mv`. Vault internals (raw/, wiki/, templates/, CLAUDE.md, .obsidian/, .claude/, skills/) move together.

2. **Path-reference updates** in build-project files (vault is no longer nested inside the build project):
   - `projects/obsidian-pe-kb/CLAUDE.md` — multiple references to `vault/`
   - `projects/obsidian-pe-kb/.gitignore` — currently `vault/*`, `!vault/.claude/settings.json` (the file no longer exists at this path)
   - `projects/obsidian-pe-kb/.claude/settings.json` — any vault-path permission patterns
   - SessionStart auto-sync hook — likely hardcodes `vault/`
   - `pipeline/next-vault-session-runbook.md` — launch command
   - `shared-manifest.json` files (project + vault levels)

3. **Symlink depth correction inside the moved vault.** New location is one level shallower (workspace-root → knowledge-bases → pe-kb-vault, vs. workspace-root → projects → obsidian-pe-kb → vault). Symlinks like `../../../ai-resources/` need to become `../../ai-resources/`. Affects vault/skills/, vault/.claude/commands/, vault/.claude/agents/ (~70+ symlinks total).

4. **Git repo init in `knowledge-bases/`.** Add remote `https://github.com/axcioncapital/obsidian-knowledge-base`. Existing project-repo origin (`obsidian-kb.git`) stays untouched and separate — no rename, no replace.

5. **`.gitignore` for the new umbrella repo.** Exclude OS noise (.DS_Store), Obsidian workspace state (.obsidian/workspace.json, .obsidian/cache), symlink directories (skills/, .claude/commands/, .claude/agents/) — these will be recreated per-machine by the existing auto-sync SessionStart hook rather than committed as raw symlinks. Tracked content: raw/, wiki/, templates/, CLAUDE.md, _setup-notes.md, vault-level .claude/settings.json.

6. **First commit + remote push.** Push is operator-gated per workspace autonomy rules.

## Existing project repo (build-project repo) impact

The project repo at `projects/obsidian-pe-kb/` retains its `obsidian-kb.git` origin and stays the home for build-project state (pipeline/, logs/, reports/, decisions.md). Its tracked files do not move. Only the path references inside its tracked files update (CLAUDE.md, .gitignore, settings.json, hook, runbook).

## Out of scope (deferred)

- Migrating macro-vault, axcion-vault content (those KBs don't exist yet)
- Updating historical references in `logs/session-notes.md`, `decisions.md`, `pipeline/*.md` — these stay as-is as history
- `--add-dir` argument the operator uses to launch Claude Code at the build project — operator will adjust their launch command after the move

## Why this rather than rename-in-place

Operator intent: one umbrella repo holding many KB vaults as siblings. Renaming `vault/` → `pe-kb-vault/` in place would put the umbrella repo's working directory inside the PE-build project, which makes it impossible to add macro-vault later as a true sibling without redoing this move. Doing it once now avoids a second relocation later.

## Concurrent-session disclosure

No concurrent Claude Code session known to be active on this repo.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.gitignore` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/pipeline/next-vault-session-runbook.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/` — exists (the directory being moved)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/.claude/settings.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/.claude/shared-manifest.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/skills/` — exists (symlink directory, 68 entries)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/.claude/commands/` — exists (symlink directory, 43 entries)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/vault/.claude/agents/` — exists (symlink directory, 18 entries)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/knowledge-bases/` — not yet present (target umbrella directory to create)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh` — exists (SessionStart hook; verified path-agnostic)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The move is mechanically sound and most of the feared coupling does not exist (the auto-sync hook walks UP the filesystem and does not hardcode `vault/`; commands/agents symlinks are absolute, not relative, so they survive the move untouched), but two High-rated dimensions — Blast Radius (8 build-repo files reference the old path; permission scope, additionalDirectories anchor, and hook command are all entangled) and Reversibility (gitignored vault content moves to a NEW git repo, decoupling it from any single revert and entangling Obsidian workspace state) — require paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No new always-loaded content. The move relocates two CLAUDE.md files (project-level 32 lines, vault-level 183 lines) but does not add lines to either; only path references inside the project-level file are edited. Verified by reading both files end-to-end.
- No new SessionStart, PreToolUse, Stop, or UserPromptSubmit hook is registered. The existing auto-sync hook is reused unchanged: `auto-sync-shared.sh` is already path-agnostic (walks UP from `$CLAUDE_PROJECT_DIR` until it finds `ai-resources/.claude/hooks/`, see hook source lines 22–32).
- No new `@import` chain. The vault CLAUDE.md does not currently use `@`-imports (architecture decision recorded in `pipeline/implementation-log.md` line 190: "Do NOT add `@`-imports to `vault/CLAUDE.md`. Self-sufficiency is non-negotiable").
- No new subagent definitions or skills are introduced. Symlinks regenerate to the same canonical targets in `ai-resources/`.

### Dimension 2: Permissions Surface
**Risk:** Medium

- `projects/obsidian-pe-kb/.claude/settings.json` line 32–34 declares `additionalDirectories: ["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` (absolute path — survives the move untouched). No widening proposed.
- `vault/.claude/settings.json` line 4 declares `additionalDirectories: ["../../../"]` — RELATIVE, three levels up from `vault/.claude/`. Resolves to workspace root today (`vault/.claude/` → `vault/` → `obsidian-pe-kb/` → `Axcion AI Repo/`). After the move, `pe-kb-vault/.claude/` → `pe-kb-vault/` → `knowledge-bases/` → `Axcion AI Repo/` — same target. **Three levels up still resolves to workspace root.** No correction needed for additionalDirectories specifically — the relative depth happens to be invariant under the move (both old and new locations are 3 levels deep from workspace root).
- The vault settings.json deny rules (`Write(raw/**)`, `Edit(raw/**)`, `Bash(rm:*)`, `Bash(mv raw/**)`, `Bash(git push:*)`) are path-relative to the working directory, which becomes `pe-kb-vault/` after the move. Deny semantics preserved — `raw/**` still matches the same content.
- The vault settings.json allow rules (`Write(wiki/**)`, `Write(templates/**)`, `Write(_setup-notes.md)`, `Write(CLAUDE.md)`, etc.) are likewise working-directory-relative. Preserved.
- New surface introduced: a new git remote `https://github.com/axcioncapital/obsidian-knowledge-base` for the umbrella repo. This is a new external write target, but push is operator-gated (workspace Autonomy Rules pause-trigger #2 "External/shared-state writes — `git push`"). Authorization is unchanged.
- D1 deny test (Op 6 runbook) was previously validated against the existing path. After the move, D1 must be re-run against `raw/pe-research/_raw-deny-test.md` from the new working directory to confirm deny still fires. Plan does not explicitly include this re-validation step.

Verdict driver: the relative `additionalDirectories: ["../../../"]` is robust to this specific move by coincidence of depth, but the contract is fragile — a future move to a different depth (e.g., `knowledge-bases/sub-domain/pe-kb-vault/`) would silently widen or narrow workspace scope. Worth surfacing.

### Dimension 3: Blast Radius
**Risk:** High

Enumeration of build-repo files referencing the old vault path (grep `vault/` in `projects/obsidian-pe-kb/` excluding `/vault/` self-references):

| File | References | Type | Touched by plan |
|---|---|---|---|
| `projects/obsidian-pe-kb/CLAUDE.md` | 3 (lines 5, 15, 31) | Path-prose in always-loaded file | YES (component 2) |
| `projects/obsidian-pe-kb/.gitignore` | 4 lines (`vault/*`, `!vault/.claude`, `vault/.claude/*`, `!vault/.claude/settings.json`) | Active gitignore rules | YES (component 2) |
| `projects/obsidian-pe-kb/.claude/settings.json` | None (verified — no `vault/` patterns in allow/deny) | Permission scope | NO (no edit needed) |
| `projects/obsidian-pe-kb/pipeline/next-vault-session-runbook.md` | 1 (launch command line 8) | Operator-facing runbook | YES (component 2) |
| `projects/obsidian-pe-kb/pipeline/technical-spec.md` | 1 (line 385: `additionalDirectories: ["../../../"]` rationale) | Technical spec history | NO (historical — left as-is per plan) |
| `projects/obsidian-pe-kb/pipeline/architecture.md` | 3 (lines 213–215: gitignore design rationale) | Architecture spec | NO (historical — left as-is per plan) |
| `projects/obsidian-pe-kb/pipeline/implementation-log.md` | ~30 (every `vault/...` filesystem entry) | Implementation history | NO (historical — left as-is per plan) |
| `projects/obsidian-pe-kb/.claude/settings.json` SessionStart hook command | The `command:` is `d="$CLAUDE_PROJECT_DIR"; while [ "$d" != '/' ]; do d=$(dirname "$d"); [ -x "$d/ai-resources/.claude/hooks/auto-sync-shared.sh" ] && { "$d/ai-resources/.claude/hooks/auto-sync-shared.sh"; exit; }; done` — verified PATH-AGNOSTIC. Walks UP from `$CLAUDE_PROJECT_DIR`, no hardcoded `vault/` reference. | YES per change description, but in reality NO edit needed | Plan over-specifies |

The change description in component 2 lists "SessionStart auto-sync hook — likely hardcodes `vault/`" as a path-update target. This is incorrect: both the hook script (`auto-sync-shared.sh` lines 22–32, walks up looking for `ai-resources/.claude/commands`) AND the hook invocation in both `settings.json` files (`d="$CLAUDE_PROJECT_DIR"; while ...`) are path-agnostic. **No hook edit is required for the move.** The plan asserts a problem that does not exist. Whether this is a harmless safety check or a sign the plan was authored without inspecting the hook is ambiguous; flagging as evidence the plan has NOT been validated against the actual hook source.

Symlink count and breakdown (verified by `ls | wc -l` and `readlink`):

| Directory | Count | Symlink form | Survives move? |
|---|---|---|---|
| `vault/skills/*` | 68 | RELATIVE (`../../../../ai-resources/skills/...`) | NO — depth changes from 4-up to 3-up |
| `vault/.claude/commands/*` | 43 | ABSOLUTE (`/Users/.../ai-resources/.claude/commands/...`) | YES |
| `vault/.claude/agents/*` | 18 | ABSOLUTE (`/Users/.../ai-resources/.claude/agents/...`) | YES |

The change description claims "~70+ symlinks total" need depth correction across all three directories. Verified count: only the 68 `skills/` symlinks actually need correction (`../../../../` → `../../../`). The 61 absolute commands+agents symlinks survive untouched, AND will be regenerated per-machine by the auto-sync hook on first session start (since component 5's `.gitignore` excludes them from the repo). Net effect: skills/ symlinks need to either be regenerated (by what mechanism? — there is no `auto-sync-skills.sh` analog) or fixed in bulk via `find -type l -exec readlink ... | sed | ln -sf`.

**Open question — surfaced explicitly.** No automation regenerates `vault/skills/*` symlinks. The auto-sync hook only handles `.claude/commands/` and `.claude/agents/`. If skills/ is gitignored in the new umbrella repo (per component 5), it will be EMPTY after a fresh clone on a second machine, and the operator will have nothing to symlink-restore from. This is a coupling the plan does not address.

D2 Check 5 (`wc -l {vault-root}/CLAUDE.md` under 600) is unaffected — the file moves with the directory, line count unchanged at 183.

The build project's `.gitignore` rule `!vault/.claude/settings.json` (component 4 of the .gitignore) targets a file that will no longer exist at that path after the move. The change description explicitly raises this in focus area (d). After the move, the project repo's `.gitignore` no longer needs `vault/` exclusion at all — the directory is gone. Either delete all four lines or convert to a comment placeholder; the plan correctly identifies this but does not commit to one form.

### Dimension 4: Reversibility
**Risk:** High

- The `vault/` directory is gitignored (`projects/obsidian-pe-kb/.gitignore` line 1: `vault/*`). All vault content is currently UNTRACKED in the build-project repo — `git revert` of the build-project repo cannot restore it.
- After the move, the vault becomes a NEW git repo at `knowledge-bases/pe-kb-vault/` with its own first commit and a new remote `obsidian-knowledge-base.git`. The vault content lives in TWO distinct git histories: the new umbrella repo (where it is born at commit 1) and the build-project repo (where it never lived). To revert the move, the operator must:
  1. `mv knowledge-bases/pe-kb-vault projects/obsidian-pe-kb/vault` — physical move back.
  2. Manually delete the `knowledge-bases/` directory and its `.git/`.
  3. `git revert` the path-reference updates in `projects/obsidian-pe-kb/CLAUDE.md`, `.gitignore`, runbook (component 2 changes).
  4. Manually fix the 68 `skills/` symlinks back from `../../../` to `../../../../` (or rebuild from scratch).
  5. Manually unwind any operator launch-command muscle memory (the `cd` path in the runbook becomes stale).
  6. If `git push` to `obsidian-knowledge-base.git` happened, the remote retains the commit history — revert is local-only.

That is a 5–6 step manual rollback. Not a clean `git revert`.

- `.obsidian/workspace.json` (6463 bytes per `ls -la`) stores Obsidian's last-opened files, panel layout, recent-files cache, and per-pane state. These contain absolute paths (`Application Support/obsidian/...` references workspace.json by absolute vault root). Obsidian uses POSIX path-relative refs internally for the vault, so the move should survive — but the change description's focus area (b) flags this as "worth flagging" and offers no validation step. If `.obsidian/workspace.json` carries absolute paths to vault files (e.g., recent-files entries), Obsidian will silently lose state.
- Component 5 of the plan excludes `.obsidian/workspace.json` from the new umbrella repo. This is correct (workspace state is per-machine), but it means the operator's current Obsidian state is non-versioned and loss is unrecoverable from git.
- The push step (component 6) is operator-gated. As long as the operator does not push before validating the move, reversibility is bounded to local state. After push, the new umbrella repo's commit history is durable on GitHub and any local revert leaves a divergent remote.

Verdict driver: the new-repo-init pattern is fundamentally not reversible by a single `git revert`. This is inherent to "split content into a new repo," not a fixable defect — but it elevates the dimension to High because the rollback path requires multiple manual steps and any post-push commit is permanently visible on the remote.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Auto-sync hook contract is documented and the plan misreads it.** The hook's contract is: walk up from `$CLAUDE_PROJECT_DIR` looking for `ai-resources/.claude/{commands,agents}`. The plan's component 2 lists the hook as needing path-update; verified false (hook lines 22–32 are path-agnostic). Coupling is documented in `auto-sync-shared.sh` script comment lines 1–17. Risk: the plan was authored without inspecting the hook, suggesting other "likely hardcodes" assertions in the plan may be similarly unvalidated.
- **`additionalDirectories: ["../../../"]` couples to current path depth.** Documented in `pipeline/technical-spec.md` line 385: "grants the vault session read access to the workspace root (`Axcion AI Repo/`)... Without this field the symlinks fail silently". Today: 3 levels up from `vault/.claude/` lands at workspace root. After move: 3 levels up from `pe-kb-vault/.claude/` lands at workspace root (coincidentally invariant). A future sub-categorization move (e.g., `knowledge-bases/pe/pe-kb-vault/`) would silently break this. The contract is undocumented at the change site (the plan does not call this out).
- **Symlink regeneration contract is asymmetric.** The auto-sync hook regenerates `.claude/commands/` and `.claude/agents/` symlinks per session if missing (covered by `shared-manifest.json` plus baked-in EXCLUDE lists in the hook). It does NOT regenerate `skills/` symlinks. Component 5 of the plan ignores this asymmetry: it gitignores all three symlink directories on the assumption the auto-sync hook will recreate all of them, but only 61/129 will actually be recreated. The 68 `skills/` symlinks will be missing after a fresh clone.
- **Operator launch-command muscle memory.** The runbook line 7–11 specifies `cd /Users/.../projects/obsidian-pe-kb/vault` plus two `--add-dir` arguments. After the move, this becomes `cd /Users/.../knowledge-bases/pe-kb-vault` plus the same `--add-dir`s (which themselves are absolute and survive). The change description acknowledges this in "Out of scope" — operator adjusts manually. Acceptable but introduces a brief window where stale launch commands fail silently.
- **Two repos, one filesystem, no enforced separation.** The build-project repo at `projects/obsidian-pe-kb/` no longer contains `vault/` but its `pipeline/` artifacts continue to reference the path historically (architecture.md, implementation-log.md, technical-spec.md). The plan correctly leaves these as history. Future operators reading those documents will see paths that no longer exist on disk — confusing but not a bug. A redirect note at the top of the build-project CLAUDE.md ("vault content lives at `knowledge-bases/pe-kb-vault/` since 2026-04-30") is implicit in component 2 but not specified.
- **D2 dry-run gates are still queued.** Per `pipeline/next-vault-session-runbook.md` line 16–24, gates D1, D3, D4, D5, D2, and Bridge step B.1 have not yet run. The move would invalidate any prior partial PASS records in `_setup-notes.md` (none yet recorded — the file is dated 2026-04-22 but only contains setup friction). D1 deny test must be re-run against the new path before any further work proceeds.

## Mitigations

- **Mitigation for Dimension 3 (Blast Radius):** Before executing the `mv`, run `grep -rn "vault/\|projects/obsidian-pe-kb/vault" projects/obsidian-pe-kb/ --include="*.md" --include="*.json" --include="*.sh"` and produce an explicit edit-list keyed by file. Confirm only the 4 files in the "touched" column above (`CLAUDE.md`, `.gitignore`, `next-vault-session-runbook.md`, plus `shared-manifest.json` if any path references) actually need changes. Do NOT edit `auto-sync-shared.sh` or the SessionStart hook command in either settings.json — they are path-agnostic. Confirm the build-project's `.claude/settings.json` allow/deny lists contain no `vault/` patterns (verified above: none).

- **Mitigation for Dimension 3 (Blast Radius):** Add an explicit symlink-regeneration step to the plan for `skills/`. Three options: (a) keep `skills/` symlinks tracked in the new umbrella repo (commit them as raw symlinks — git preserves symlink targets); (b) write a one-shot `regenerate-skills-symlinks.sh` script and run it at first session start manually; (c) extend `auto-sync-shared.sh` to also walk `ai-resources/skills/` and symlink to `.claude/skills/` (architectural change — out of scope for this move). Operator chooses one before the move; otherwise a fresh clone has 0 of 68 skills available.

- **Mitigation for Dimension 3 (Blast Radius):** Re-run D1 (raw/ deny test) and D3 (Obsidian round-trip) from the new path immediately after the move and before any vault-mode work resumes. Record PASS/FAIL in `_setup-notes.md` with the new absolute path. The runbook gates have been validated only at the old path.

- **Mitigation for Dimension 4 (Reversibility):** Stage the move in two commits in the build-project repo: commit A updates `.gitignore` only (removes `vault/` exclusion lines and `!vault/.claude/settings.json` exception); commit B updates path references in `CLAUDE.md` and `next-vault-session-runbook.md`. This lets revert pick exactly one half if the issue is `.gitignore`-shaped vs. prose-shaped. Plan-stated component 2 is currently a single edit batch.

- **Mitigation for Dimension 4 (Reversibility):** Do NOT push to `obsidian-knowledge-base.git` until D1, D3, D4, D5 PASS records are in `_setup-notes.md` from the new path AND the operator has run at least one ingestion-mode operation end-to-end. Rationale: push converts the move from "locally reversible with manual steps" to "remote retains history of an aborted experiment." Push-gating is already operator-controlled by Autonomy Rules pause-trigger #2; this mitigation just ties the push trigger to dry-run completion.

- **Mitigation for Dimension 4 (Reversibility) — Obsidian state:** Before the `mv`, copy `vault/.obsidian/workspace.json` to a sibling backup file (`workspace.json.pre-move-backup`). If Obsidian loses state after the move, restore from backup. Verifies focus area (b) without depending on filesystem-relative-path assumption.

- **Mitigation for Dimension 5 (Hidden Coupling):** Add a one-line note to `vault/CLAUDE.md` (or `_setup-notes.md`) recording that `additionalDirectories: ["../../../"]` is depth-coupled to "two levels below workspace root" and any future relocation must preserve that depth or the field must be updated. Documenting the implicit contract at its current home prevents the silent-break failure mode on the next move.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (build-project CLAUDE.md lines 5/15/31, .gitignore lines 1–4, settings.json lines 32–34/37–48, vault settings.json lines 4/24–30/32–45, hook script lines 22–32, runbook lines 7–11/16–24, technical-spec.md line 385); grep counts (8 build-repo files reference vault/, 30+ historical references in pipeline/implementation-log.md); symlink counts via `ls | wc -l` (68 skills/, 43 commands/, 18 agents/); symlink form via `readlink` (relative for skills/, absolute for commands/agents/); filesystem inspection (`knowledge-bases/` confirmed not yet present, `.obsidian/workspace.json` confirmed 6463 bytes). No training-data fallback was used on fetch/read failures.
