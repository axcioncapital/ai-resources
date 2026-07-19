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
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)",
      "Bash(git reset --hard *)"
    ]
  }
}
```

**Key assertions:**
- `defaultMode: "bypassPermissions"` — primary gate.
- Dotfile-path glob: `Edit(**/.claude/**)` and `Write(**/.claude/**)` — covers nested `.claude/` directories across all projects (root cause #2).
- **No absolute-path `Edit(/Users/...)` / `Write(/Users/...)` globs** — RETIRED 2026-06-27 as portability defects (mission `settings-path-portability`, Group 3). They were never functional fallbacks: a single-leading-slash glob is project-root-relative (resolves to `<project-root>/Users/...`, matching nothing), and under `defaultMode: bypassPermissions` all allow-rules are ignored anyway. Machine-specific config, where genuinely needed, lives only in gitignored `settings.local.json`. See `docs/settings-portability-invariant.md`.
- `Bash(rm *)` in allow — fixes Delete/Remove prompts. `rm -rf` still denied.
- **`Bash(git checkout *)` RETIRED 2026-07-18** (mission `repo-health-backlog-2026-07` thread 4; risk-check `audits/risk-checks/2026-07-18-narrow-git-checkout-deny-rule-two-settings-layers.md`). It denied by **verb, not by effect** — `git checkout --help`, which cannot modify a byte, was blocked, as were `<branch>`, `-b`, `--ours`/`--theirs`. It stalled work in 5 logged sessions, once freezing both open sessions mid-merge, and `bypassPermissions` cannot waive a deny. **Do not restore it, and do not replace it with an enumerated deny list of destructive forms** — that was attempted 2026-07-14, scored `RECONSIDER`, and is recorded at `logs/improvement-log.md` (2026-07-14) as the wrong shape because the destructive set is open-ended. A 2026-07-18 re-attempt confirmed it by execution: the most common accident form, `git checkout <file>` (bare pathspec, no `--`), is **structurally uncatchable** by any glob, because `git checkout foo` is identical in shape whether `foo` is a branch (safe) or a file (destructive) — only git can resolve which.
- **Accepted residual risk, documented rather than silently shipped.** Destructive checkout forms (`git checkout .`, `-- <path>`, `<tree-ish> -- <path>`, `-f`, `-p`) are now unguarded at this layer. This is a smaller change than it appears: `git restore <file>` — git's own modern replacement for `git checkout -- <file>` — achieves identical discard and has **never** been denied in any layer, so equivalent capability was always one verb away. The blanket rule offered the appearance of protection, not protection. The model-side rule lives in `docs/commit-discipline.md` § Destructive git-checkout forms; real enforcement, if wanted, belongs in a `PreToolUse` hook that can parse the command (queued, not built).
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
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)",
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
- Same dotfile-path pattern as workspace root.
- **No hardcoded absolute `Edit(/Users/...)` / `Write(/Users/...)` paths in `allow`.** RETIRED 2026-06-27 as portability defects (mission `settings-path-portability`, Group 3), **overturning** the prior 2026-05-16 decision that declared them "intentional and canonical" (now archived at `logs/decisions-archive-2026-05.md`, "Reject audit finding: hardcoded absolute paths…"). That decision rested on a premise now **verified false against the official Claude Code permission docs**: it assumed a single-leading-slash glob matches absolute paths via "literal matching." It does not — per [code.claude.com/docs/en/permissions](https://code.claude.com/docs/en/permissions.md), single-leading-slash is **project-root-relative** (`/Users/...` → `<project-root>/Users/...`, matching nothing); absolute paths require a **double** leading slash (`//Users/...`). So the lines were always inert, not functional fallbacks. Under `defaultMode: bypassPermissions` they were redundant on top of inert. An audit tool that flags a hardcoded `/Users/...` path in a tracked `settings.json` is reporting a **real** defect, not a false positive — relocate the grant to gitignored `settings.local.json`. See `docs/settings-portability-invariant.md` and the superseding `logs/decisions.md` 2026-06-27 entry.
- `Bash(rm *)` in allow.
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
      "Bash(rm -rf *)", "Bash(sudo *)",
      "Read(archive/**)", "Read(**/*.archive.*)",
      "Read(**/deprecated/**)", "Read(**/old/**)"
    ]
  }
}
```

**Key assertions:**
- **No `"model"` field.** Model defaults are prohibited at every settings layer (see workspace `CLAUDE.md` § Model Tier). A declared model blocks the operator's in-session `/model` switch. Audit recommendations that suggest adding a "canonical model baseline" must be rejected.
- `defaultMode: "bypassPermissions"` (root causes #1, #3).
- Dotfile-path glob `Edit(**/.claude/**)` (root cause #2).
- `Bash(rm *)` in allow — fixes Delete/Remove prompts.
- **No `additionalDirectories` in the tracked `settings.json`.** The workspace-root grant is **machine-specific** (an absolute path that differs per operator machine) and therefore belongs in the gitignored `settings.local.json` (Layer D′), not in git-tracked config. A tracked path is correct on the machine that deployed it but breaks on every other machine that pulls the repo. See Layer D′ for the canonical home and the migration note. (Changed 2026-06-03 — previously this shape carried a hardcoded `additionalDirectories` path; that produced cross-machine breakage when two operators shared the same git-tracked project.)
- The `deny` list includes Read-deny patterns for archival and deprecated paths (`archive/**`, `**/*.archive.*`, `**/deprecated/**`, `**/old/**`). These suppress permission prompts on stale content directories. Apply to any project that has an `archive/` or `deprecated/` structure; omit for projects that do not.

---

## Layer D′ — Project `settings.local.json`

Same `defaultMode` rule as Layer B′: if present and declares `permissions`, it must include `defaultMode: "bypassPermissions"` (otherwise it shadows the parent's bypass — root cause #1). Beyond that, Layer D′ is the **canonical home for the machine-specific workspace-root grant**.

**`additionalDirectories` lives here, not in the tracked `settings.json` (Layer D).** Claude Code sandboxes each project to its own directory; shared skills under `ai-resources/skills/` and the symlinks into `ai-resources/.claude/{commands,agents}/` are unreachable until the workspace root is added to `permissions.additionalDirectories` with an **absolute** path. That absolute path differs per operator machine, so it must not be committed — it belongs in the gitignored local file.

Canonical shape (this machine's workspace-root path):

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "additionalDirectories": [
      "/Users/<you>/Claude Code/Axcion AI Repo"
    ]
  }
}
```

**Key assertions:**
- `defaultMode: "bypassPermissions"` is **mandatory** whenever this file declares a `permissions` block — including the `additionalDirectories`-only form above. Omitting it shadows the parent's bypass.
- The path is the **absolute** workspace root on *this* machine. Each operator maintains their own local file; the two never collide because the file is gitignored.
- If no local-only override is needed beyond the workspace grant, the `additionalDirectories` + `defaultMode` pair above is the whole file.

**Migration note (per-machine recovery).** When a project that previously carried `additionalDirectories` in its tracked `settings.json` is cleaned up (the tracked grant removed), every operator who pulls the repo must add their own machine's path to their local file once, or ai-resources symlinks stop resolving for them. Ready-to-paste snippet — replace the path with your machine's workspace root:

```json
{ "permissions": { "defaultMode": "bypassPermissions", "additionalDirectories": ["/Users/<you>/Claude Code/Axcion AI Repo"] } }
```

**Generator alignment — RESOLVED (2026-06-26 / 2026-06-27).** All known generators that wrote the `additionalDirectories` grant into the **tracked** `settings.json` have been aligned to write it to the gitignored `settings.local.json` instead: `/new-project` Post-Pipeline Enrichment step 3 (fixed 2026-06-26), and `/deploy-workflow`'s grant sub-step plus the research-workflow template's own `settings.json` and `SETUP.md` (fixed 2026-06-27, all under one risk-check). `/permission-sweep`'s Rule 8 remediation idiom was aligned the same day to write grants to the local file and to relocate any grant still found in a tracked file. Any tracked `additionalDirectories` discovered on an **already-deployed** project (deployed before these fixes) is still treated per Detection Rule 8 (ADVISORY — relocate to local), not a HIGH stale-path finding; retrofitting those pre-existing projects is the one remaining open thread of the settings-path-portability mission.

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
      "Bash(rm:*)", "Bash(mv raw/**)"
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

## PreToolUse[Edit] decision-block pattern

A canonical pattern for blocking Edit tool calls against specified file paths *before* they execute, with an operator-facing reason string. Useful for guarding sensitive content (chapter prose, final outputs, citation-bearing files) from accidental direct edits when a bright-line rule requires deliberate operator approval first.

**Pattern shape:** the hook command runs a `jq` pipeline that reads the Edit tool input from stdin, extracts the target `file_path`, matches it against a path-scoped grep regex, and returns a `{"decision":"block","reason":"..."}` JSON object to Claude Code on a hit. Claude Code honors the `decision: block` directive by refusing to execute the Edit; the `reason` text is shown to the operator.

Canonical block:

```json
{
  "matcher": "Edit",
  "hooks": [
    {
      "type": "command",
      "command": "jq -r '.tool_input.file_path' | { read -r f; echo \"$f\" | grep -qE '/(YOUR_GUARDED_PATH_REGEX)/' && echo '{\"decision\":\"block\",\"reason\":\"YOUR_BRIGHT_LINE_RULE_REASON\"}' || exit 0; }",
      "timeout": 5,
      "statusMessage": "Checking bright-line rule..."
    }
  ]
}
```

**How to adopt:**

1. Identify the file path or pattern that must be guarded (e.g., `report/chapters/`, `final/modules/`, `assets/published/`).
2. Replace `YOUR_GUARDED_PATH_REGEX` with a grep extended-regex segment matching the guarded scope. Use `|` to alternate multiple paths.
3. Replace `YOUR_BRIGHT_LINE_RULE_REASON` with a short string describing the rule. Keep it actionable — the operator sees it when the block fires.
4. Add the hook block under `hooks.PreToolUse` in the project's `.claude/settings.json` next to any other PreToolUse matchers.

**Where it fires:** before any `Edit` tool call. The hook receives the tool input as JSON on stdin; `jq -r '.tool_input.file_path'` extracts the target path. The grep regex is the path-scoping mechanism — Claude Code's `matcher:` field only matches tool names, not paths, so path scoping must happen inside the hook command.

**Reference implementation:** `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` — the PreToolUse `Edit` matcher block guards `/(report/chapters|final/modules)/` paths against direct edits, surfacing the project's BRIGHT-LINE rule (three-question check before editing analytical prose). Locate the block by searching the file for the `"decision":"block"` token (avoids drift from line-number references).

**Caveats:**

- Each block-fire interrupts the session. Reserve the pattern for paths where unintended edits would cause expensive rework or evidentiary harm — not for general "be careful" guidance.
- The `reason` string is the operator's only signal at the moment of friction. Make it specific (what rule, where to log overrides) — generic messages erode the signal over time.
- The pattern uses `jq` and `grep`; both must be available on `PATH`. `grep` is standard on macOS and Linux. `jq` is standard on macOS; on Linux, install via the system package manager if absent.
- `settings.json` is strict JSON (no comments) — AND its schema is strict: top-level `_*` comment keys (e.g. `_decision_block_pattern_doc`) are rejected at session load (verified 2026-05-29 FX-E2 incident, surfaced in `projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md` entry "Settings.json schema rejection of inline _comment keys"). Cross-reference notes belong in a sibling `.claude/PERMISSIONS-NOTES.md` external file alongside `settings.json`, not inline. The reference shape lives at `projects/nordic-pe-macro-landscape-H1-2026/.claude/PERMISSIONS-NOTES.md`. Do not add `//` comments, and do not add top-level `_*` keys.

**When to apply:** projects where one or more directories carry content protected by a bright-line rule that should never be edited directly without an explicit operator decision. Skip if the project has no such guard discipline — the hook overhead is wasted otherwise.

---

## Detection rulebook (used by `/permission-sweep`)

> **Rules 1, 5 and 6 are MERGED-EFFECTIVE predicates, not per-file predicates (corrected 2026-07-18).**
> They exist to predict a *live prompt*, and a session never runs against one settings file — it runs
> against the merged layer stack. Evaluate them against `EFFECTIVE_ALLOW` and `EFFECTIVE_DEFAULT_MODE`
> as computed in `permission-sweep-auditor.md` § Step 2.5, never against a single file's `allow` array.
> Two consequences, both load-bearing:
> - A per-file gap that an **ancestor layer already fills** does not fire. A `settings.local.json` is
>   evaluated together with its sibling `settings.json` — they are two halves of one layer.
> - Where `EFFECTIVE_DEFAULT_MODE` is `bypassPermissions`, an allow-list gap **cannot** produce a
>   prompt, so these three rules do not fire at all.
>
> When a rule would have fired on the file alone but the effective view suppresses it, **demote to
> ADVISORY with a `Suppressed-by:` reason — do not delete it.** Dropping it hides genuine per-file
> drift; leaving it CRITICAL is the false alarm.
>
> *Why this warning exists:* evaluated per-file, Rule 5 emitted a **CRITICAL** against
> `ai-resources/.claude/settings.local.json` ("narrow `Bash(...)` grants, no `Bash(*)`"). True of that
> file in isolation and operationally meaningless — the sibling `settings.json` grants `Bash(*)` at
> `:4` and **both** files set `defaultMode: bypassPermissions` (`:32`, `:9`). Zero prompts were
> possible. The false CRITICAL reached the 2026-07-17 `/friday-checkup` as an actionable HIGH and a
> `/friday-act` remediation item was queued against a correct file. **Scope the suppression to these
> three rules only** — it does not apply to Rules 7, 8 or 9, which are not prompt-causation.

### CRITICAL — cause live Edit/Delete prompts

1. `settings.local.json` missing `defaultMode: bypassPermissions` where parent `settings.json` has it (or parent is one of Layers A–D and the local file contains a `permissions` block). **Merged-effective — see the note above.**
2. Project/workspace `settings.json` missing `defaultMode` entirely.
3. Broad glob `Edit(X/**)` or `Write(X/**)` without dotfile-path companion (`Edit(**/.claude/**)` or `Edit(X/**/.claude/**)`).
4. Missing bare-tool entries (`Edit`, `Write`, `MultiEdit`) alongside scoped patterns.
5. Missing `Bash(*)` in files that allow narrow bash commands only (e.g., `Bash(git add *)` without catch-all). **Merged-effective — see the note above.**

### HIGH — Delete prompts or future Edit prompts

6. No `Bash(rm *)` in allow (Delete/Remove failure mode, separate from Edit). **Merged-effective — see the note above.**
7. Deny-shadows-allow (same tool-path pattern on both lists). Flag but don't auto-fix — sometimes intentional.
8. `additionalDirectories` workspace-root grant absent from BOTH the project's tracked `settings.json` and its gitignored `settings.local.json` (Layer D′) — with no other mechanism granting the workspace root, ai-resources symlinks will not resolve. The canonical home for the grant is `settings.local.json` (machine-specific absolute path; see Layer D′). Presence in the local file fully satisfies this rule; absence of `additionalDirectories` from the tracked `settings.json` is **expected and not a finding**. A tracked `settings.json` that still carries `additionalDirectories` with a foreign-machine absolute path is an **ADVISORY** (relocate to `settings.local.json`), not a HIGH stale-path finding — the path is correct on the machine that deployed it.
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
