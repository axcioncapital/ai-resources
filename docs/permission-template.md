# Permission Templates — Canonical Shapes

This document is the **single source of truth** for Claude Code permission configurations across the workspace. Referenced by `/permission-sweep` (diagnose + remediate) and `/new-project` (Post-Pipeline Enrichment step 2).

If the templates below change, `/permission-sweep` picks up the new shapes on the next run. `/new-project` uses the project-level template inline — update both if the project shape changes.

---

## Why these shapes exist (the four root causes)

Between 2026-04-18 and 2026-04-24, six reactive patch commits fixed permission prompts one case at a time. Four structural root causes were identified:

1. **`settings.local.json` files wholly shadow the sibling `settings.json`'s `defaultMode`** — they do not merge. A local file without `defaultMode` silently disables the parent's `bypassPermissions`.
2. **`**` glob does not match dotfile path components by default.** `Edit(foo/**)` does not cover `foo/bar/.claude/baz`. Explicit `Edit(**/.claude/**)` is required.
3. **Project-level `.claude/settings.json` files without `defaultMode` inherit unpredictably** across harness versions.
4. **Bare tool grants (`Edit`, `Write`, `MultiEdit`, `Bash(*)`) must accompany scoped patterns.** Scoped patterns alone leave gaps for absolute-path edits.

Each template below addresses these causes at its appropriate layer.

---

## Layer A — User-level (`~/.claude/settings.json`)

Applies: every Claude Code session on this machine, regardless of project.

Canonical shape (liberal — this is your personal machine):

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Edit(**)", "Write(**)", "Bash(*)",
      "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)"
    ]
  }
}
```

**Key assertions:**
- `defaultMode: "bypassPermissions"` — acts as the universal floor when all narrower layers fail to cover a case.
- Bare `Edit(**)` and `Write(**)` — covers absolute paths globally.
- `Bash(*)` — covers arbitrary shell commands.
- Deny floor: `rm -rf` and `sudo` only. Narrow `rm` is allowed (Delete/Remove prompts are fixed at this layer).

---

## Layer B — Workspace root (`.claude/settings.json` at `Axcion AI Repo/`)

Applies: sessions opened at the workspace root (not inside a project or `ai-resources/`).

Canonical shape:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch",
      "Edit(**/.claude/**)", "Write(**/.claude/**)",
      "Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)",
      "Bash(git reset --hard *)", "Bash(git checkout *)"
    ]
  }
}
```

**Key assertions:**
- `defaultMode: "bypassPermissions"` — primary gate.
- Dotfile-path glob: `Edit(**/.claude/**)` and `Write(**/.claude/**)` — covers nested `.claude/` directories across all projects (root cause #2).
- Absolute-path fallback: `Edit(/Users/.../**)` — covers edits via absolute paths regardless of session CWD.
- `Bash(rm *)` in allow — fixes Delete/Remove prompts. `rm -rf` still denied.
- Additional denies for destructive git ops (workspace-root-specific safeguards).

---

## Layer B′ — Workspace `settings.local.json`

Applies: local-only overrides at the workspace root (gitignored).

Canonical shape — **must include `defaultMode` explicitly**:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Edit", "Write", "MultiEdit", "Bash(*)"
    ]
  }
}
```

**Key assertion:** If a `settings.local.json` declares any `permissions` block, it MUST include `defaultMode: "bypassPermissions"` (root cause #1). Otherwise, the local file shadows the parent's bypass and prompts resume.

**Alternative:** Omit the `permissions` key entirely. If the local file has no `permissions` block, the sibling `settings.json` applies unmodified. This is the cleanest form unless local-only overrides are genuinely needed.

---

## Layer C — `ai-resources/.claude/settings.json`

Applies: sessions opened inside `ai-resources/` (skill/command/agent development).

Canonical shape:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch",
      "Edit(**/.claude/**)", "Write(**/.claude/**)",
      "Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)",
      "Read(archive/**)",
      "Read(logs/*-archive-*.md)", "Read(inbox/archive/**)",
      "Read(**/deprecated/**)", "Read(**/old/**)"
    ]
  }
}
```

**Note on `audits/working/`:** the canonical Layer C shape deliberately omits `Read(audits/working/**)` from `deny`. Rationale: the directory is gitignored at `ai-resources/.gitignore`, and the corresponding "main session reads summary only" discipline lives in `ai-resources/CLAUDE.md` § Subagent Contracts. Adding the deny rule mechanically blocks main-session reads of the auditor's `*.summary.md` files (which `/permission-sweep` Step 4 explicitly requires), so the deny was retired 2026-04-28. Do not restore it.

**Key assertions:**
- Must have `Bash(*)` in allow (root cause #4 — ai-resources previously had only narrow bash grants).
- Same dotfile-path and absolute-path patterns as workspace root.
- **Hardcoded absolute paths in `allow` are intentional and canonical.** `Edit(/Users/patrik.lindeberg/...)` and `Write(/Users/patrik.lindeberg/...)` cannot be replaced with env-var references or relative paths — Claude Code permission pattern matching is literal (no env-var expansion). Audit tools that flag these as "stale hardcoded paths" are producing a false positive against this layer. Document such findings as resolved without action. (See `logs/decisions.md` 2026-05-16.)
- `Bash(rm *)` in allow.
- `Bash(git push*)` in deny — force explicit operator step for push.
- Read-denies on archival paths (preserves token-audit discipline).

---

## Layer D — Project-level (`projects/{name}/.claude/settings.json`)

Applies: sessions opened inside a project directory.

**Emitted by `/new-project` Post-Pipeline Enrichment step 2 — read from `ai-resources/templates/project-settings.json.template`.** That template is the single source of truth; `/new-project` extracts the `permissions` block and the two `hooks.SessionStart` entries from it at deploy time. When updating this template, also update `ai-resources/templates/project-settings.json.template` (and vice-versa) — the two files express the same canonical shape and must agree.

Canonical shape:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch",
      "Edit(**/.claude/**)", "Write(**/.claude/**)",
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)",
      "Read(archive/**)", "Read(**/*.archive.*)",
      "Read(**/deprecated/**)", "Read(**/old/**)"
    ],
    "additionalDirectories": [
      "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"
    ]
  }
}
```

**Key assertions:**
- **No `"model"` field.** Model defaults are prohibited at every settings layer (see workspace `CLAUDE.md` § Model Tier). A declared model blocks the operator's in-session `/model` switch. Audit recommendations that suggest adding a "canonical model baseline" must be rejected.
- `defaultMode: "bypassPermissions"` (root causes #1, #3).
- Dotfile-path glob `Edit(**/.claude/**)` (root cause #2).
- `Bash(rm *)` in allow — fixes Delete/Remove prompts.
- `additionalDirectories` granting workspace root — required for ai-resources symlinks to resolve.
- The `deny` list includes Read-deny patterns for archival and deprecated paths (`archive/**`, `**/*.archive.*`, `**/deprecated/**`, `**/old/**`). These suppress permission prompts on stale content directories. Apply to any project that has an `archive/` or `deprecated/` structure; omit for projects that do not.

---

## Layer D′ — Project `settings.local.json`

Same rule as Layer B′: if present and declares `permissions`, must include `defaultMode: "bypassPermissions"`. Otherwise omit `permissions` entirely.

---

## Intentional-narrow exceptions

Some projects intentionally have narrow permissions for data safety. These are **not errors** and must not be "healed" by `/permission-sweep`.

**Current known exception:** `projects/obsidian-pe-kb/vault/.claude/settings.json`

Shape (illustrative — preserve actual file contents):

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep", "Bash(ls:*)",
      "Edit(wiki/**)", "Edit(templates/**)",
      "Edit(_setup-notes.md)", "Edit(CLAUDE.md)",
      "Edit(_integrity-report-*.md)"
    ],
    "deny": [
      "Write(raw/**)", "Edit(raw/**)",
      "Bash(rm:*)", "Bash(mv raw/**)", "Bash(git push:*)"
    ]
  }
}
```

**Detection heuristic:** a file is INTENTIONAL-NARROW if BOTH are true:
1. The `allow` list contains specific path-scoped entries (e.g., `Edit(wiki/**)`) and NO bare `Edit`/`Write` entry.
2. The `deny` list contains specific path-scoped denies (e.g., `Write(raw/**)`) paired to the allow scopes.

When `/permission-sweep` encounters a file matching this heuristic, it tags findings as `INTENTIONAL-NARROW` and **skips remediation** unless invoked with `--fix-narrow`.

---

## Intentional-template exceptions

Settings files that are **workflow templates** (not deployed project settings) may contain `{{PLACEHOLDER}}` values in path-type fields such as `additionalDirectories`. These are intentional — they are filled in at deploy time by `/deploy-workflow`. They are **not Rule 8 violations** (missing or stale `additionalDirectories`) and must not be flagged as stale or broken paths.

**Detection heuristics (two signals — file is template-class if EITHER fires):**

1. **Path-class signal:** the file path matches `**/workflows/*/.claude/settings.json` (template source under the workflow library).
2. **Value-class signal:** the triggering value matches `{{[A-Z_]+}}` in any path-type field (`additionalDirectories`, or a path argument inside `allow`/`deny`).

**Outcome by signal combination:**

- **Both signals fire (path-class file with placeholders intact)** — canonical template state. `/permission-sweep` **silences** Rule 8 and Rule 9 entirely for this file (no finding emitted at any severity, including ADVISORY).
- **Only path-class signal fires (template file with placeholders REPLACED by literal paths)** — `/permission-sweep` emits a **HIGH `Template integrity`** finding. Remediation: restore the placeholder; do not "fix" the literal path. `/deploy-workflow` fills placeholders at deploy time.
- **Only value-class signal fires (placeholder appears in a non-template file)** — `/permission-sweep` emits an **ADVISORY** noting the unexpected location. Operator verifies intent.

**Current known template file:** `ai-resources/workflows/research-workflow/.claude/settings.json`

**Why silence instead of downgrade?** A 2026-05-11 remediation pass (`permission-sweep Bundle 1`, commit `0514590`) treated an ADVISORY-tagged placeholder as actionable and replaced `{{WORKSPACE_ROOT}}` with a literal absolute path, breaking the research-workflow template. ADVISORY findings are insufficient protection against this regression mode; the placeholder case is now silenced entirely while the path-class signal actively detects the failure mode (template file whose placeholders have been replaced).

---

## Hook wiring for prevention

Every project's `.claude/settings.json` should wire two SessionStart hooks: `auto-sync-shared.sh` (which symlinks shared commands/agents from ai-resources into the project) and `check-permission-sanity.sh` (which nudges on permission drift). Both use the **upward-walk idiom** — they discover ai-resources by walking parent directories from `$CLAUDE_PROJECT_DIR` rather than relying on hardcoded paths. This keeps projects portable across workspace moves and nesting depths.

Canonical SessionStart hook block #1 — `auto-sync-shared.sh`:

```json
{
  "type": "command",
  "command": "d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '/' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\" ] && { \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\"; exit; }; done",
  "timeout": 10,
  "statusMessage": "Syncing shared commands from ai-resources..."
}
```

Canonical SessionStart hook block #2 — `check-permission-sanity.sh`:

```json
{
  "type": "command",
  "command": "d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '/' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/check-permission-sanity.sh\" ] && { \"$d/ai-resources/.claude/hooks/check-permission-sanity.sh\"; exit; }; done",
  "timeout": 5,
  "statusMessage": "Permission sanity check..."
}
```

Both hooks are invoked directly from ai-resources — do not copy `auto-sync-shared.sh` or `check-permission-sanity.sh` into the project's hooks directory.

---

## PostToolUse[Write] fan-out wiring taxonomy (reference)

Projects with a multi-stage pipeline can chain several `PostToolUse[Write]` hooks to fan out post-write side-effects. The pattern below was first observed in `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` and is documented here as a reference wiring shape — apply selectively per project need, not as a default.

Canonical block (apply hooks in this order):

```json
{
  "matcher": "Write",
  "hooks": [
    { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/log-write-activity.sh\"",  "timeout": 5, "statusMessage": "Logging write activity..." },
    { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/detect-innovation.sh\"",   "timeout": 5, "statusMessage": "Checking for innovation..." },
    { "type": "command", "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/auto-qc-nudge.sh",      "timeout": 5, "statusMessage": "Checking for significant artifact writes..." },
    { "type": "command", "command": "bash $CLAUDE_PROJECT_DIR/.claude/hooks/check-claim-ids.sh",    "timeout": 5, "statusMessage": "Checking citation tags..." }
  ]
}
```

**Hook roles:**
- `log-write-activity.sh` — appends a per-write line to the project's write-activity log (timestamp, file, stage). Cheap audit trail.
- `detect-innovation.sh` — pattern-matches the written path against the innovation-detection rules; flags new commands/agents/hooks/skills for `/innovation-sweep` review.
- `auto-qc-nudge.sh` — if the write is a "significant artifact" (chapter prose, decision document, plan), nudges the session toward `/qc-pass`.
- `check-claim-ids.sh` — for citation-pipeline projects, scans the written file for unresolved claim-ID tags (`[CITATION NEEDED]`, `[CLAIM-ID-?]`).

**Auto-commit hook deliberately excluded.** A fifth hook observed in nordic-pe-macro auto-commits every Write event. This conflicts with the workspace **Commit Rules** (operator-approved commits, no `--no-verify`, no bypass) and is kept project-local per the loose-end verdict in `audits/innovation-sweep-2026-05-16.md` (LE3). Do **not** include the auto-commit hook in any project that follows workspace commit policy.

**When to apply this wiring:** projects with a multi-stage research/synthesis pipeline, where stage transitions produce structured artifacts the operator wants tracked, QC-prompted, and citation-checked at write time. Skip for lightweight projects — the per-write overhead is non-trivial.

---

## Detection rulebook (used by `/permission-sweep`)

### CRITICAL — cause live Edit/Delete prompts

1. `settings.local.json` missing `defaultMode: bypassPermissions` where parent `settings.json` has it (or parent is one of Layers A–D and the local file contains a `permissions` block).
2. Project/workspace `settings.json` missing `defaultMode` entirely.
3. Broad glob `Edit(X/**)` or `Write(X/**)` without dotfile-path companion (`Edit(**/.claude/**)` or `Edit(X/**/.claude/**)`).
4. Missing bare-tool entries (`Edit`, `Write`, `MultiEdit`) alongside scoped patterns.
5. Missing `Bash(*)` in files that allow narrow bash commands only (e.g., `Bash(git add *)` without catch-all).

### HIGH — Delete prompts or future Edit prompts

6. No `Bash(rm *)` in allow (Delete/Remove failure mode, separate from Edit).
7. Deny-shadows-allow (same tool-path pattern on both lists). Flag but don't auto-fix — sometimes intentional.
8. Missing or stale `additionalDirectories` in project files (should include workspace root absolute path).
9. Absolute-path allow entries with stale workspace paths (path no longer exists on disk).

### MEDIUM — coverage gaps

10. MCP tools (`mcp__*`) not covered by any allow entry in files that otherwise have a tool allowlist.
11. User-level vs workspace divergence in critical rules (flags the divergence; operator decides which wins).

### ADVISORY — hygiene

12. `settings.local.json` tracked by git (should be gitignored per Claude Code convention).
13. Typos / duplicate entries / syntax form inconsistencies (`Bash(foo *)` vs `Bash(foo:*)` — prefer the former).
14. `Read(<dir>/**)` deny entry where `<dir>` is a single concrete directory (not a glob pattern like `**/...`) and `<dir>/` does not appear in the appropriate `.gitignore` (same repo as the settings file). Audit/scan commands writing into denied scratchpad directories pollute `git status` when the directory is not gitignored — e.g., `Read(inbox/archive/**)` paired with `inbox/archive/` in `ai-resources/.gitignore`. Canonical fix: add `<dir>/` to the `.gitignore` at the same repo root as the settings file declaring the deny.

---

## Update protocol

When these templates change:

1. Update this file.
2. Update `ai-resources/templates/project-settings.json.template` — `/new-project` reads its `permissions` block and `hooks.SessionStart` entries from there (Post-Pipeline Enrichment step 2). The literals no longer live inline in `new-project.md`; they are extracted via `jq -c` at deploy time.
3. Run `/permission-sweep --dry-run` across all scopes to surface which existing files drift from the new template.
4. Apply corrections via `/permission-sweep` with approval.
5. Commit as one change per step (template → pipeline → sweep run → remediation) so each can be reviewed independently.
