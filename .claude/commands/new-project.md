---
model: sonnet
---

# /new-project — Project Pipeline Orchestrator

You are the orchestrator for Axcíon's project pipeline. This pipeline discovers approved planning artifacts (context pack, project plan, optional technical spec) from the `projects/project-planning/` workspace and produces a fully configured Claude Code setup through a series of staged gates, starting at Stage 3a (Repo Snapshot).

## Scope Validation

This pipeline is for **any Axcíon project that requires Claude Code** — whether that's building AI resources (skills, workflows, agents), setting up a research project, configuring a new workspace, or any other project where Claude Code is the execution environment. Before doing anything else, check whether the user's input describes work that will be built or run through Claude Code. If not, stop and explain that this pipeline is for Claude Code-based projects.

**CWD guard:** Check if the current working directory is the `ai-resources` repo itself (i.e., the CWD contains a `skills/` directory and a `CLAUDE.md` with "Axcion AI Resource Repository" at the root level). If so, stop and tell the user:

> "This command should be run from a project repo or the Axcíon AI workspace root, not from ai-resources directly. Open your target repo and run `/new-project` from there."

**Note:** Running from the Axcíon AI workspace root (the parent directory that contains `ai-resources/`, `projects/`, etc.) is valid — the guard only blocks running from inside `ai-resources/` itself.

## Pre-Flight Validation

Before starting the pipeline, verify all required agent files exist in `ai-resources/.claude/agents/`:
- `pipeline-stage-3a.md`, `pipeline-stage-3b.md`, `pipeline-stage-3c.md`, `pipeline-stage-4.md`, `pipeline-stage-5.md`, `session-guide-generator.md`

Check with: `ls ai-resources/.claude/agents/pipeline-stage-*.md ai-resources/.claude/agents/session-guide-generator.md 2>&1`

If ANY file is missing, list all missing files and stop. Do not start the pipeline.

## Planning Artifact Requirement

Planning artifacts (context pack, project plan, optional technical spec) are produced upstream in the `projects/project-planning/` workspace via `/plan-draft` → `/plan-refine` → `/plan-evaluate` (and the equivalent spec cycle). The `/new-project` pipeline consumes approved artifacts from `projects/project-planning/output/{project-name}/` — it does not accept ad-hoc context packs pasted into the conversation.

**If the planning artifacts do not exist for a given project name, stop and direct the operator to run the planning workflow first.** See First Run step 3 below for the exact abort message.

## First Run vs. Continuation

**Determine which mode you're in:**

1. Look for `projects/*/pipeline/pipeline-state.md` files first. If none found, fall back to `projects/*/pipeline-state.md` (legacy layout).
2. If no pipeline state files exist → **First Run**
3. If pipeline state files exist → **Continuation** (if multiple projects have pipeline state files, ask the user which project to resume). Note whether the state file is in `pipeline/` (new layout) or at root (legacy layout) — use the same layout for all subsequent artifact paths in that project.

### First Run

1. **Ask for the project name.** Use lowercase-with-hyphens format (e.g., `context-aware-skill-router`). The name must match the directory name in `projects/project-planning/output/`.

2. **Locate the planning workspace.** Walk upward from the current working directory until an ancestor contains `projects/project-planning/`. Use the absolute path — Claude Code resolves paths relative to session CWD, which varies. The walk idiom mirrors the one used to locate `ai-resources/` in post-pipeline enrichment (see step 3 further down).

   ```bash
   d="$(pwd)"
   PLANNING_WORKSPACE=""
   while [ "$d" != "/" ]; do
     if [ -d "$d/projects/project-planning" ]; then PLANNING_WORKSPACE="$d"; break; fi
     d=$(dirname "$d")
   done
   [ -n "$PLANNING_WORKSPACE" ] || { echo "ERROR: projects/project-planning/ not found in any ancestor of $(pwd). Cannot locate planning artifacts."; exit 1; }
   ```

3. **Verify the planning output directory exists** at `$PLANNING_WORKSPACE/projects/project-planning/output/{project-name}/`. If not, stop with:

   > "No planning artifacts found at `projects/project-planning/output/{project-name}/`. Run `/plan-draft`, `/plan-refine`, `/plan-evaluate` (and optionally the spec cycle via `/spec-draft`, `/spec-refine`, `/spec-evaluate`) in the project-planning workspace first, then re-run `/new-project`."

4. **Discover artifacts** inside `$PLANNING_WORKSPACE/projects/project-planning/output/{project-name}/`:

   ```bash
   SRC="$PLANNING_WORKSPACE/projects/project-planning/output/{project-name}"

   # Context pack — required
   [ -f "$SRC/context-pack.md" ] || { echo "ERROR: $SRC/context-pack.md not found. Cannot proceed."; exit 1; }

   # Latest project-plan — required. sort -V handles v10+ correctly (ls -v is GNU-only, not portable to macOS BSD).
   LATEST_PLAN=$(ls "$SRC"/project-plan-v*.md 2>/dev/null | sort -V | tail -n 1)
   [ -n "$LATEST_PLAN" ] || { echo "ERROR: No project-plan-v*.md in $SRC. Cannot proceed."; exit 1; }

   # Latest tech-spec — optional
   LATEST_SPEC=$(ls "$SRC"/tech-spec-v*.md 2>/dev/null | sort -V | tail -n 1)

   # QC verdicts — advisory. Match both double-bold (**PASS**) and single-bold (PASS-WITH-FINDINGS) forms.
   if [ -f "$SRC/plan-qc-verdict.md" ]; then
     grep -qE "^\*\*Verdict:\*\*\s+\**PASS" "$SRC/plan-qc-verdict.md" || echo "WARN: plan-qc-verdict.md does not show PASS — proceeding anyway; confirm v{n} is the approved version."
   else
     echo "WARN: plan-qc-verdict.md missing — proceeding anyway; confirm the project plan is approved."
   fi
   if [ -n "$LATEST_SPEC" ] && [ -f "$SRC/spec-qc-verdict.md" ]; then
     grep -qE "^\*\*Verdict:\*\*\s+\**PASS" "$SRC/spec-qc-verdict.md" || echo "WARN: spec-qc-verdict.md does not show PASS — proceeding anyway; confirm v{n} is the approved version."
   fi
   ```

   QC verdict checks are advisory-only: if a verdict is missing or non-PASS, emit a warning and continue. Hard-blocking on a missing verdict file (e.g., operator deleted it while iterating) would create false-abort friction; the operator gate-keeps the planning workflow itself.

5. **Ask for the GitHub repository link.** The user should provide the URL of the project's GitHub repo (e.g., `https://github.com/axcion-ai/project-name`).

6. **Create the project directory** at `projects/{project-name}/` and the pipeline artifact subdirectory at `projects/{project-name}/pipeline/`.

7. **Copy the discovered artifacts** into the target pipeline directory at canonical names (downstream stages read canonical paths):

   ```bash
   cp "$SRC/context-pack.md"   "projects/{project-name}/pipeline/context-pack.md"
   cp "$LATEST_PLAN"            "projects/{project-name}/pipeline/project-plan.md"
   [ -n "$LATEST_SPEC" ] && cp "$LATEST_SPEC" "projects/{project-name}/pipeline/technical-spec.md"
   ```

8. **Write `projects/{project-name}/pipeline/sources.md`** to record provenance (satisfies the workspace "legitimate copying" exception: downstream tool requires canonical path, source recorded):

   ```markdown
   # Pipeline Input Sources — {project-name}

   | Canonical path | Source path | Source version | Copied on |
   |----------------|-------------|----------------|-----------|
   | pipeline/context-pack.md | {abs-source-path}/context-pack.md | — | {YYYY-MM-DD} |
   | pipeline/project-plan.md | {abs-source-path}/project-plan-v{n}.md | v{n} | {YYYY-MM-DD} |
   | pipeline/technical-spec.md | {abs-source-path}/tech-spec-v{n}.md | v{n} | {YYYY-MM-DD} |
   ```

   Omit the `technical-spec.md` row if no tech spec was discovered.

9. **Create `projects/{project-name}/pipeline/decisions.md`** with this template:

```markdown
# Decisions — {project-name}

| # | Stage | Decision | Rationale | Decided By |
|---|-------|----------|-----------|------------|
```

10. **Create `projects/{project-name}/pipeline/pipeline-state.md`** to track pipeline progress:

```markdown
# Pipeline State — {project-name}

## Metadata
- **GitHub:** {github-url}
- **Planning source:** projects/project-planning/output/{project-name}/

| Stage | Status | Artifact |
|-------|--------|----------|
| 3a — Repo Snapshot | in_progress | — |
| 3b — Architecture Design | pending | — |
| 3c — Implementation Spec | pending | — |
| 4 — Implementation | pending | — |
| 5 — Testing | pending | — |
| 6 — Session Guide | pending | — |
```

11. **Announce what was discovered and copied.** Include: source directory, picked versions (e.g., `project-plan-v3.md`), whether a tech spec was found, any QC-verdict warnings. State that Stage 3a is starting. No separate confirmation gate before copy — the announcement names every file, `sources.md` records provenance, and any wrong picks are reversible via the existing `ABORT` gate.

11a. **Scaffold the project's Model Selection section.** Every project declares its own default model. Ask the operator one question:

    > Project task profile?
    > (a) Heavy execution → Sonnet 1M (`claude-sonnet-4-6[1m]`) default. Most repo work, KB ops, operational projects.
    > (b) Heavy judgment → Opus 4.7 (`claude-opus-4-7`) default. Plan/spec drafting, identity drafting, strategic projects.
    > (c) Mixed → Sonnet 1M default with Opus opt-ins. Most projects; commands/agents declare `model: opus` where judgment is needed.

    **Pre-flight identifier verification.** Before writing the chosen identifier into the project CLAUDE.md, confirm the canonical strings against a live source: read `projects/buy-side-service-plan/CLAUDE.md` for the Opus 4.7 form, and the system-prompt model context for the Sonnet 4.6 1M form. If any string fails to match the precedent, abort scaffolding and surface the discrepancy — do not write a non-resolvable model ID into a new project. Sonnet identifiers must include the `[1m]` suffix to force 1M context (bare `claude-sonnet-4-6` resolves to 200k).

    **Append a `Model Selection` section to `projects/{project-name}/CLAUDE.md`** (insert just before any `## Commit Rules` section, or before the final section if no Commit Rules section exists). Format matching the buy-side-service-plan precedent:

    ```
    ## Model Selection

    Default model for this project is {Sonnet 1M | Opus 4.7} (`{full-form identifier}`, set in `.claude/settings.local.json`, which is gitignored — each operator applies the default manually per machine). Reason: {one-line rationale tied to the chosen profile}. {Optional: one line about which commands/agents opt out of the default and why.}.
    ```

    Confirm the section was written by reading the file back and showing the operator the appended text. Do not write `.claude/settings.local.json` automatically — that is a per-operator manual step (gitignored).

12. **Spawn the Stage 3a subagent** (`pipeline-stage-3a`). Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

### Continuation

1. Read the pipeline state file for the project.
2. Find the stage that is `in_progress`, or the first `pending` stage whose predecessor is `completed` (or `skipped`).
3. Announce: "Resuming pipeline at [stage name]. Last completed: [previous stage]."
4. Spawn the corresponding stage subagent. Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

**Agent name mapping:** Stages 3a–5 use the `pipeline-stage-{N}` naming convention. Stage 6 (Session Guide) uses the `session-guide-generator` agent instead.

**Legacy pipeline-state migration.** If a pipeline-state.md still lists Stage 2 or 2.5 as `in_progress` or `pending` (from before this change), stop and tell the operator they have two options: (a) manually edit the state file to remove those rows and set Stage 3a to `in_progress` (confirming the project's plan and tech spec exist in `projects/project-planning/output/{name}/`), or (b) abandon the in-progress pipeline and re-run `/new-project` from scratch. Do not auto-migrate.

## Gate Protocol

After each stage subagent completes:

1. Update `pipeline-state.md`: set the current stage to `completed` and record the artifact path.
2. Wait for the user's command:
   - **`NEXT`** → Set the next stage to `in_progress` in `pipeline-state.md`. If context has grown from the prior stage, suggest `▸ /compact` before spawning. Spawn the next stage subagent. **Exception — the 3b→3c transition:** run the Architecture Gate (below) before spawning `pipeline-stage-3c`.
   - **`SKIP`** → Valid after Stage 5 only (skips Stage 6 — marks it `skipped`, announces pipeline complete). Not valid at other stages.
   - **`ABORT`** → Mark all remaining `pending` stages as `cancelled` in `pipeline-state.md`. Announce abort. Do not delete project artifacts.

## Stage 3b → 3c Architecture Gate

The transition from Stage 3b (Architecture Design) to Stage 3c (Implementation Spec) carries a system-owner review of the architecture *before* any line-level spec is written. This is the only stage transition with an extra gate; all others use the generic Gate Protocol above.

When the operator says `NEXT` after Stage 3b is marked `completed`:

1. **Read the Stage 3b artifact path** from `pipeline-state.md` (the `3b — Architecture Design` row's Artifact column — normally `projects/{name}/pipeline/architecture.md`).
2. **Run implementation triage.** Invoke `/implementation-triage` via the Skill tool — in this workspace slash commands are dispatched as skills, so the Skill tool resolves `.claude/commands/*.md` command files — with this `$ARGUMENTS`:
   > `Triage the Stage 3b architecture for project {name} before Stage 3c (implementation-spec) writing begins. Read the architecture document at {absolute path to architecture.md} and judge whether the architecture as designed is worth proceeding to implementation. Assess ROI, perfectionism / scope-creep risk, and downstream impact on the project's Claude Code setup.`
3. **Parse the first line of the verdict** — one of `WORTH-DOING`, `MARGINAL`, `NOT-WORTH-DOING`, or `DECLINE — {reason}`.
4. **Act on the verdict:**
   - **`WORTH-DOING`** → Proceed automatically. Set Stage 3c to `in_progress`, suggest `▸ /compact` if context has grown, spawn `pipeline-stage-3c`.
   - **`MARGINAL` or `NOT-WORTH-DOING`** → Do NOT spawn Stage 3c. Surface the full triage rationale in chat and pause. State the operator's options: (a) revise the architecture and re-run Stage 3b (`NEXT` re-enters this gate), (b) override and proceed to Stage 3c anyway, (c) `ABORT` the pipeline. Wait for the operator's decision.
   - **`DECLINE`** (or any unparseable first line) → The system owner could not ground a judgment. Surface the decline reason, treat as non-blocking, and proceed to Stage 3c as for `WORTH-DOING`.
5. **If `/implementation-triage` itself errors or cannot run** (e.g., the `system-owner` agent's references are unreachable from the current working directory) — surface the error, note that the Architecture Gate was skipped, and proceed to Stage 3c. The gate is an advisory safeguard; its own failure must not block the pipeline.

The gate runs once per pipeline. The 3c→4 and 4→5 transitions use the generic Gate Protocol unchanged.

## Post-Stage 5 Behavior

After Stage 5 completes successfully, announce:

> "Pipeline core stages complete. Say NEXT to generate a Session Guide (Stage 6 — a step-by-step execution playbook for running this project), SKIP to finish the pipeline without one, or ABORT to cancel."

If the user says NEXT, spawn the `session-guide-generator` agent. If SKIP, mark Stage 6 as `skipped` and announce the pipeline is complete. After Stage 6 completes (or is skipped), announce: "Pipeline complete. All artifacts saved to projects/{project-name}/."

Then remind the operator:

> **Next steps:** Run `/repo-dd` and `/analyze-workflow` against the new project to establish a baseline audit and infrastructure inventory.

## Error Handling

If a stage subagent reports failure:
- Do NOT update the stage to `completed` in `pipeline-state.md`
- Report the failure to the user
- Offer options: retry the stage, abort the pipeline, or fix manually and resume

## Post-Pipeline Enrichment

After the pipeline completes (all stages done or final stage skipped), set the project up for **ongoing** sync with ai-resources. The mechanism is the SessionStart hook `ai-resources/.claude/hooks/auto-sync-shared.sh`, which symlinks every command/agent in `ai-resources/.claude/{commands,agents}/` into the project on session start, except files declared as project-local in the manifest and a small baked-in meta exclusion list. New commands added to ai-resources after this point flow into the project automatically — no re-enrichment needed.

### What to install

If a `.claude/shared-manifest.json` already exists in the project (created by a workflow template via `/deploy-workflow`), do nothing — the workflow template already wired everything up. Skip to the "Report" step.

Otherwise, install the three pieces:

1. **`projects/{name}/.claude/shared-manifest.json`** — declares project-owned files. Identify which commands and agents this project created locally during the pipeline (pipeline-specific commands, project-specific evaluator agents, etc.) and list them under `commands.local` / `agents.local`. Anything not listed will be auto-synced from ai-resources. Template:

   ```json
   {
     "_doc": "Lists project-owned files under .local. The auto-sync hook symlinks every other file from ai-resources/.claude/{commands,agents}/ on session start.",
     "commands": { "local": [ ... ] },
     "agents": { "local": [ ... ] }
   }
   ```

2. **`projects/{name}/.claude/settings.json`** — wire the SessionStart hook **and** ensure the project inherits a tool-permissions baseline so the operator does not get approval prompts on routine Edit/Write/Grep calls.

   **Requires `jq` on PATH.** If `jq` is not available, stop and report the missing dependency — do not attempt string-level JSON manipulation.

   **Canonical permissions block** (mirrors `ai-resources/docs/permission-template.md` Layer D). Three structural additions compared to the pre-2026-04-24 template, driven by four root causes surfaced in the permission-sweep design doc:

   - `"defaultMode": "bypassPermissions"` — without this, projects default to prompt-on-allow regardless of their allow list (the primary cause of recurring Edit/Delete prompts).
   - `Edit(**/.claude/**)` and `Write(**/.claude/**)` — `**` globs do not match dotfile path components by default, so broad `Edit(X/**)` rules leave nested `.claude/` paths uncovered.
   - `Bash(rm *)` — narrow `rm` in allow (destructive `rm -rf` stays on deny). Fixes Delete/Remove prompts.

   Note: `additionalDirectories` is **not** included in this canonical block because each project's entry is computed dynamically at enrichment time — see step 3 below, which adds the ai-resources workspace root via a separate jq merge so projects with existing `permissions.allow` arrays (which skip this canonical merge) still receive the grant.

   The `Read(...)` denies target archival-only paths that no active command routinely reads. Per the workspace `## Applying Audit Recommendations` rule, these four entries are the safe universal set. Project-shape-specific denies (e.g., `Read(output/**)`, `Read(reports/**)`) are **not** included in the canonical block — they should be added per-project after confirming no active command reads from them.

   ```json
   {
     "defaultMode": "bypassPermissions",
     "allow": [
       "Bash(*)",
       "Read",
       "Edit",
       "Write",
       "MultiEdit",
       "Agent",
       "Skill",
       "TodoWrite",
       "Glob",
       "Grep",
       "WebFetch",
       "WebSearch",
       "NotebookEdit",
       "ToolSearch",
       "Edit(**/.claude/**)",
       "Write(**/.claude/**)",
       "Bash(rm *)"
     ],
     "deny": [
       "Bash(git push*)",
       "Bash(rm -rf *)",
       "Bash(sudo *)",
       "Read(archive/**)",
       "Read(**/*.archive.*)",
       "Read(**/deprecated/**)",
       "Read(**/old/**)"
     ]
   }
   ```

   **Auto-sync SessionStart hook entry** (added to `hooks.SessionStart`):

   ```json
   {
     "type": "command",
     "command": "d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '/' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\" ] && { \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\"; exit; }; done",
     "timeout": 10,
     "statusMessage": "Syncing shared commands from ai-resources..."
   }
   ```

   **Permission-sanity SessionStart hook entry** (added to `hooks.SessionStart`) — surfaces a nudge when the project's `settings.json` or `settings.local.json` lacks `defaultMode: "bypassPermissions"`, the primary cause of recurring Edit/Delete permission prompts:

   ```json
   {
     "type": "command",
     "command": "d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '/' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/check-permission-sanity.sh\" ] && { \"$d/ai-resources/.claude/hooks/check-permission-sanity.sh\"; exit; }; done",
     "timeout": 5,
     "statusMessage": "Permission sanity check..."
   }
   ```

   Both hooks are invoked **directly from ai-resources** — do not copy the scripts into the project's hooks directory.

   **Predicate for "already has a permissions allowlist":** parsed JSON has `.permissions.allow` *and* that array is non-empty. If true, leave `permissions` alone (protects projects that intentionally have a narrower block). Otherwise, merge the canonical block in.

   **Merge procedure:**

   The canonical permissions block and both hooks are read from `ai-resources/templates/project-settings.json.template` — single source of truth across `/new-project`, `/permission-sweep`, and any future consumer. The template is located via walk-up to the nearest ancestor containing `ai-resources/` (same idiom used by `auto-sync-shared.sh` and by step 3 below); this is load-bearing — a relative path would hard-fail on any invocation from outside `ai-resources/` because the CWD guard at the top of this command rules out running inside `ai-resources/`.

   ```bash
   command -v jq >/dev/null || { echo "ERROR: jq required for permissions merge"; exit 1; }

   SETTINGS="projects/{name}/.claude/settings.json"
   mkdir -p "$(dirname "$SETTINGS")"
   [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

   # Locate canonical templates via walk-up to ai-resources/ (load-bearing per /risk-check 2026-05-25 mitigation #2)
   d="$(cd projects/{name} && pwd)"
   AI_RES=""
   while [ "$d" != "/" ]; do
     d=$(dirname "$d")
     [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break
   done
   [ -n "$AI_RES" ] || { echo "ERROR: ai-resources not found in any ancestor — cannot locate canonical templates"; exit 1; }

   TEMPLATE="$AI_RES/templates/project-settings.json.template"
   [ -f "$TEMPLATE" ] || { echo "ERROR: canonical settings template missing at $TEMPLATE"; exit 1; }

   CANONICAL_PERMS=$(jq -c '.permissions' "$TEMPLATE")
   AUTO_SYNC_HOOK=$(jq -c '.hooks.SessionStart[0].hooks[0]' "$TEMPLATE")
   SANITY_HOOK=$(jq -c '.hooks.SessionStart[1].hooks[0]' "$TEMPLATE")

   jq --argjson perms "$CANONICAL_PERMS" --argjson sync "$AUTO_SYNC_HOOK" --argjson sanity "$SANITY_HOOK" '
     (if (.permissions.allow // []) | length > 0 then . else .permissions = $perms end)
     | .hooks = (.hooks // {})
     | .hooks.SessionStart = (.hooks.SessionStart // [])
     | (if (.hooks.SessionStart | any(.hooks? // [.] | .[]? | .command == $sync.command))
        then .
        else .hooks.SessionStart += [{"hooks":[$sync]}]
        end)
     | (if (.hooks.SessionStart | any(.hooks? // [.] | .[]? | .command == $sanity.command))
        then .
        else .hooks.SessionStart += [{"hooks":[$sanity]}]
        end)
   ' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
   ```

   Report in the step output:
   - whether `permissions` was added, already present, or skipped
   - whether the auto-sync SessionStart hook was added or already present
   - whether the permission-sanity SessionStart hook was added or already present

3. **Grant ai-resources filesystem visibility** — Claude Code sandboxes each project to its own directory by default. Shared skills under `ai-resources/skills/` and symlinks into `ai-resources/.claude/{commands,agents}/` are unreachable until the workspace root is added to `permissions.additionalDirectories` in the project's `.claude/settings.json`. This step performs that grant.

   The walk to locate the workspace root mirrors the idiom in `ai-resources/.claude/hooks/auto-sync-shared.sh` (walk upward until an ancestor contains `ai-resources/`). Use an absolute path, not a relative one — Claude Code resolves `additionalDirectories` relative to session CWD, which varies by how the project is opened.

   **Load-bearing jq semantics:** for projects where step 2 skipped the permissions merge (because `.permissions.allow` was already non-empty) OR for projects where step 2 added the canonical block without `additionalDirectories`, jq's `=` operator on the leaf path `.permissions.additionalDirectories` synthesizes any missing parent objects automatically. This is the only reason a single idempotent jq call is sufficient here — if jq is ever replaced with another tool (Python, Node, yq), that tool must do the same parent-object auto-creation.

   ```bash
   command -v jq >/dev/null || { echo "ERROR: jq required for additionalDirectories merge"; exit 1; }

   SETTINGS="projects/{name}/.claude/settings.json"
   [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

   d="$(cd projects/{name} && pwd)"
   WORKSPACE=""
   while [ "$d" != "/" ]; do
     d=$(dirname "$d")
     [ -d "$d/ai-resources" ] && WORKSPACE="$d" && break
   done
   [ -n "$WORKSPACE" ] || { echo "WARN: ai-resources not found in any ancestor — skipping additionalDirectories grant"; }

   if [ -n "$WORKSPACE" ]; then
     jq --arg dir "$WORKSPACE" \
       '.permissions.additionalDirectories = ((.permissions.additionalDirectories // [] | map(select(startswith("{{") | not))) + [$dir] | unique)' \
       "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
   fi
   ```

   Report in the step output:
   - whether `additionalDirectories` was added, already present, or skipped (walk failed)
   - the absolute workspace path that was added

4. **`projects/{name}/CLAUDE.md`** — ensure the project CLAUDE.md contains four canonical sections: `## Input File Handling`, `## Commit Rules`, `## Compaction`, and `## Session Boundaries`. These guarantee that projects opened without the parent workspace CLAUDE.md loaded still see the load-bearing behavioral rules.

   Each section is a short-form mirror — not a verbatim copy of the workspace-level text — so it satisfies the workspace `## CLAUDE.md Scoping` rule ("short pointer acceptable; verbatim duplication is not") while preserving the 2026-04-13 "Commit Rules propagate by explicit copy" decision (inheritance alone proved unreliable in practice, so the rule must appear in-context).

   **Policy (per section, applied independently):**
   - If `projects/{name}/CLAUDE.md` does not exist → render `templates/project-claude-md/header.md` (with `{name}` and `{project-description}` substituted) followed by the four canonical fragments. `{name}` and `{project-description}` are passed into the bash block as `PROJECT_NAME` / `PROJECT_DESCRIPTION` env vars by the calling agent (substituted into the assignment lines below); the python3 step at runtime does the literal-string replace inside `header.md` content, so apostrophes / ampersands / backslashes in `{project-description}` are safe.
   - If `projects/{name}/CLAUDE.md` exists and already contains a given heading → leave that section alone. Report "{section} already present, skipping."
   - If `projects/{name}/CLAUDE.md` exists but has no given heading → append that canonical fragment to the end of the file (preceded by a blank line).

   **Canonical content source.** The four canonical sections (and the `# {name}` / `{project-description}` header used only on fresh creation) live as individual fragment files under `ai-resources/templates/project-claude-md/` — `header.md`, `input-file-handling.md`, `commit-rules.md`, `compaction.md`, `session-boundaries.md`. These files are the **single source of truth** for the canonical wording. To update what gets written into project CLAUDE.md files, edit the template fragments — not this command. The procedure below reads them at runtime via walk-up to `ai-resources/` (same idiom as the settings merge in step 2). See `ai-resources/templates/README.md` for the consumer contract and the 2026-04-13 KEEP verdict on the workspace-inheritance workaround.

   **Procedure:**

   ```bash
   CLAUDE_MD="projects/{name}/CLAUDE.md"

   # Locate canonical templates via walk-up to ai-resources/ (same idiom as step 2)
   d="$(cd projects/{name} && pwd)"
   AI_RES=""
   while [ "$d" != "/" ]; do
     d=$(dirname "$d")
     [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break
   done
   [ -n "$AI_RES" ] || { echo "ERROR: ai-resources not found in any ancestor — cannot locate canonical CLAUDE.md templates"; exit 1; }

   FRAG_DIR="$AI_RES/templates/project-claude-md"
   for f in header.md input-file-handling.md commit-rules.md compaction.md session-boundaries.md; do
     [ -f "$FRAG_DIR/$f" ] || { echo "ERROR: canonical CLAUDE.md fragment missing at $FRAG_DIR/$f"; exit 1; }
   done

   if [ ! -f "$CLAUDE_MD" ]; then
     # Fresh creation: render header.md with {name} / {project-description} substituted, then concat the four canonical sections.
     #
     # Substitution mechanics — read this before editing:
     # The calling agent processes this bash source as text and replaces {name} + {project-description} GLOBALLY
     # before the Bash tool runs. To survive that, the substitution targets must appear EXACTLY ONCE each — on the
     # PROJECT_NAME= / PROJECT_DESCRIPTION= lines below. The python3 step then does a literal string-replace on
     # header.md content using PROJECT_NAME / PROJECT_DESCRIPTION as values; argv-passing avoids all shell-quoting
     # hazards (apostrophes, ampersands, backslashes, dollar signs in the project description are safe).
     #
     # python3 is on macOS by default and is already an implicit dependency of other ai-resources tooling. If the
     # python3 dependency becomes a concern, awk with `-v` (which also passes vars without shell interpretation)
     # is the closest alternative; sed is NOT safe here because `&` in PROJECT_DESCRIPTION expands to the match.
     # header.md uses mustache-style placeholders {{NAME}} and {{PROJECT_DESCRIPTION}} — distinct from the agent's
     # single-brace {name} / {project-description} tokens, so the agent's global text-substitution pass over this
     # bash source never touches the python search strings or the template content.
     PROJECT_NAME="{name}"
     PROJECT_DESCRIPTION="{project-description}"
     python3 -c "
import sys
with open(sys.argv[1]) as f: content = f.read()
sys.stdout.write(content.replace('{{NAME}}', sys.argv[2]).replace('{{PROJECT_DESCRIPTION}}', sys.argv[3]))
" "$FRAG_DIR/header.md" "$PROJECT_NAME" "$PROJECT_DESCRIPTION" > "$CLAUDE_MD" \
       || { echo "ERROR: python3 substitution failed"; exit 1; }
     {
       echo
       cat "$FRAG_DIR/input-file-handling.md"
       echo
       cat "$FRAG_DIR/commit-rules.md"
       echo
       cat "$FRAG_DIR/compaction.md"
       echo
       cat "$FRAG_DIR/session-boundaries.md"
     } >> "$CLAUDE_MD"
   else
     # Idempotent per-section append: each section appended only if its heading is absent.
     for pair in \
       "## Input File Handling|input-file-handling.md" \
       "## Commit Rules|commit-rules.md" \
       "## Compaction|compaction.md" \
       "## Session Boundaries|session-boundaries.md"; do
       HEADING="${pair%|*}"
       FRAG="${pair#*|}"
       SECTION_NAME="${HEADING#\#\# }"
       if grep -q "^${HEADING}" "$CLAUDE_MD"; then
         echo "${SECTION_NAME} already present in $CLAUDE_MD — skipping"
       else
         echo "" >> "$CLAUDE_MD"
         cat "$FRAG_DIR/$FRAG" >> "$CLAUDE_MD"
       fi
     done
   fi
   ```

   Report in the step output:
   - created new CLAUDE.md / appended Input File Handling / appended Commit Rules / appended Compaction / appended Session Boundaries / already present (per section)

4a. **Scaffold `projects/{name}/logs/` with `decisions.md`.** Every project tracks session-level decisions in `logs/decisions.md` (mirror of the ai-resources logs convention; consumed by `/prime` Step 4 and `/wrap-session`). Create the directory and a minimal scaffold file. Idempotent — skip the write if the file already exists, but still ensure the directory is present.

   ```bash
   LOGS_DIR="projects/{name}/logs"
   mkdir -p "$LOGS_DIR"

   if [ ! -f "$LOGS_DIR/decisions.md" ]; then
     cat > "$LOGS_DIR/decisions.md" <<'EOF'
# Decisions — {name}

Cross-session decisions log. Newest entries at the bottom (append-only).

Each entry uses the canonical shape:

```
## YYYY-MM-DD — {one-line decision title}

**Context.** {what prompted the decision; one short paragraph}

**Decision.** {what was decided; one or two sentences}

**Rationale.** {why this choice over alternatives; one paragraph}

**Alternatives considered.**
- *{alternative 1}:* {one line on why not}
- *{alternative 2}:* {one line on why not}
```
EOF
     # Note: `{name}` is substituted by the calling agent before this bash block
     # executes — same convention as all other `{name}` references in this file.
     echo "Created $LOGS_DIR/decisions.md"
   else
     echo "$LOGS_DIR/decisions.md already present — skipping"
   fi
   ```

   Report in the step output:
   - created `logs/decisions.md` / already present

5. **Initial sync** — run the hook once now so the project starts with all shared commands/agents already linked, instead of waiting for the next session start:

   ```bash
   CLAUDE_PROJECT_DIR="projects/{name}" bash ai-resources/.claude/hooks/auto-sync-shared.sh
   ```

5a. **Canonical command verification.** After the initial sync, verify the minimum-required canonical commands are present in `projects/{name}/.claude/commands/`. The auto-sync hook should have installed all of these — this step is a safety-net that catches regressions in the hook's exclusion logic or in the project's `shared-manifest.json`.

   Required canonical commands (every project must have these on session 1):
   - `prime.md` — session orientation
   - `wrap-session.md` — session closeout
   - `session-start.md` — Phase-3 mandate capture
   - `session-plan.md` — session-orchestration planning
   - `open-items.md` — backlog inventory
   - `qc-pass.md` — independent QC pass
   - `resolve.md` — QC-finding triage and resolution
   - `clarify.md` — request-clarification structured prompt
   - `scope.md` — scope-summary generator
   - `recommend.md` — operator-defers-to-Claude self-decision path

   ```bash
   MISSING=()
   for cmd in prime wrap-session session-start session-plan open-items qc-pass resolve clarify scope recommend; do
     if [ ! -L "projects/{name}/.claude/commands/${cmd}.md" ] && [ ! -f "projects/{name}/.claude/commands/${cmd}.md" ]; then
       MISSING+=("${cmd}.md")
     fi
   done

   if [ ${#MISSING[@]} -gt 0 ]; then
     echo "WARN: ${#MISSING[@]} canonical command(s) missing after initial sync:"
     printf '  - %s\n' "${MISSING[@]}"
     echo ""
     echo "Re-run the auto-sync hook manually:"
     echo "  CLAUDE_PROJECT_DIR=\"projects/{name}\" bash ai-resources/.claude/hooks/auto-sync-shared.sh"
     echo ""
     echo "If the commands remain missing after the manual re-run, investigate:"
     echo "  - projects/{name}/.claude/shared-manifest.json — check commands.local for accidental inclusions"
     echo "  - ai-resources/.claude/hooks/auto-sync-shared.sh — check the baked-in exclusion list"
   else
     echo "All 10 canonical commands present."
   fi
   ```

   Report in the step output:
   - canonical commands status: all present / N missing (named) + remediation hint emitted

5b. **Git repository setup** — initialize a standalone git repo for the project, untrack it from the workspace root, and wire the remote. This enforces the workspace convention: each project has its own repo; the workspace root tracks only cross-project supporting files (CLAUDE.md, settings, harness, etc.).

   Read the GitHub URL from the pipeline-state file:

   ```bash
   GITHUB_URL=$(grep -m1 '^\- \*\*GitHub:\*\*' "projects/{name}/pipeline/pipeline-state.md" | sed 's/.*\*\* *//' | tr -d '\r')
   [ -n "$GITHUB_URL" ] || { echo "WARN: GitHub URL not found in pipeline-state.md — set remote manually after init"; }
   ```

   Remove from workspace root index if tracked, update `.gitignore`, commit:

   ```bash
   # $WORKSPACE is the workspace root path already computed in step 3
   GITIGNORE="$WORKSPACE/.gitignore"

   # Remove from workspace root index (if Stage 4 committed files there)
   if git -C "$WORKSPACE" ls-files --error-unmatch "projects/{name}/" >/dev/null 2>&1; then
     git -C "$WORKSPACE" rm --cached -r "projects/{name}/"
     echo "Removed projects/{name}/ from workspace root index."
   else
     echo "projects/{name}/ was not tracked in workspace root — no index cleanup needed."
   fi

   # Add to .gitignore if not already present
   if ! grep -qF "projects/{name}/" "$GITIGNORE" 2>/dev/null; then
     LAST_LINE=$(grep -n "^projects/" "$GITIGNORE" 2>/dev/null | tail -1 | cut -d: -f1)
     if [ -n "$LAST_LINE" ]; then
       awk -v n="$LAST_LINE" -v entry="projects/{name}/" \
         'NR==n{print; print entry; next}1' "$GITIGNORE" > "$GITIGNORE.tmp" && mv "$GITIGNORE.tmp" "$GITIGNORE"
     else
       echo "projects/{name}/" >> "$GITIGNORE"
     fi
     echo "Added projects/{name}/ to workspace root .gitignore."
   else
     echo "projects/{name}/ already in .gitignore — skipped."
   fi

   # Commit workspace root changes
   git -C "$WORKSPACE" add .gitignore
   git -C "$WORKSPACE" diff --cached --quiet || git -C "$WORKSPACE" commit -m "$(cat <<'EOF'
chore: add projects/{name}/ to workspace root .gitignore

Project now has its own standalone repo per workspace convention.

Co-Authored-By: Claude Sonnet 4.6 (1M context) <noreply@anthropic.com>
EOF
)"
   ```

   Initialize the project's own git repo and make the initial commit:

   ```bash
   git -C "projects/{name}" init
   [ -n "$GITHUB_URL" ] && git -C "projects/{name}" remote add origin "$GITHUB_URL"
   git -C "projects/{name}" add .
   git -C "projects/{name}" commit -m "$(cat <<'EOF'
init: initial commit — {name} project

Establishes standalone repo via /new-project pipeline.

Co-Authored-By: Claude Sonnet 4.6 (1M context) <noreply@anthropic.com>
EOF
)"
   ```

   Report in the step output:
   - GitHub remote: set to `{url}` / WARN (not found in pipeline-state — set manually)
   - Workspace root index: cleaned up N files / already untracked
   - `.gitignore`: updated / already present
   - Project repo: initialized, initial commit with N files
   - **Push reminder:** "Create the GitHub repo at `{github-url}` (if not done yet), then push: `git -C projects/{name} push -u origin main`"

### Report

Report what was created: manifest path, settings.json modifications (permissions block, SessionStart hook, `additionalDirectories` grant), CLAUDE.md state (created / appended / already present), `logs/decisions.md` scaffold (created / already present), the list of files the initial sync symlinked, the canonical command verification result (all 10 present / N missing), and the git setup result (remote, initial commit, workspace root `.gitignore`). Do not push — that is the operator's manual step after creating the GitHub repo. From this point on, any new command added to `ai-resources/.claude/commands/` will be available in this project on the next session start automatically, and skills under `ai-resources/skills/` are reachable via the filesystem grant.

## Key Rules

- Never advance a stage without user confirmation (`NEXT`)
- Never modify decisions.md without user confirmation
- Always announce which stage is running and what it expects as input
- When spawning any subagent, always include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"
- The `pipeline/pipeline-state.md` file is the source of truth for pipeline progress — always read it before taking action, always update it after state changes. Pipeline artifacts live in `pipeline/`: `context-pack.md`, `project-plan.md`, and (optionally) `technical-spec.md` are **discovered inputs** copied from `projects/project-planning/output/{name}/` at First Run; `repo-snapshot.md`, `architecture.md`, `implementation-spec.md`, `implementation-log.md`, and `test-results.md` are **pipeline-generated outputs**. Provenance for the discovered inputs is recorded in `pipeline/sources.md`. Only the project's working files live at the project root.
- If the project involves creating new skills, inform the user that skill creation must use the `/create-skill` command from ai-resources. Ensure ai-resources is connected via `--add-dir` so the command is available.
