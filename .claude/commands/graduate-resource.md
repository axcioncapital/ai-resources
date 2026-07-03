---
model: sonnet
---

Graduate a project-level resource to the shared library: $ARGUMENTS

Use this command when you've built something useful in a project (a command, agent, hook, rule, or pattern) and want it available to all future projects.

## Input

The argument should be one of:
- A file path to the resource (e.g., `.claude/commands/optimize-repo.md`)
- A resource name (e.g., `optimize-repo`) — Claude will search `.claude/commands/`, `.claude/agents/`, `.claude/hooks/` for a match
- `inbox` — process the next unprocessed brief from `ai-resources/inbox/`

If no argument is provided, check `logs/innovation-registry.md` for entries with status `triaged:graduate` and offer those as candidates.

## Step 1: Locate and Read the Source

1. Find the source file. If the argument is a name, search in order: `.claude/commands/{name}.md`, `.claude/agents/{name}.md`, `.claude/hooks/{name}.sh`, `.claude/hooks/{name}.md`.
2. Read the source file completely.
3. Determine the resource type: `command`, `agent`, or `hook` (from the directory it lives in).
4. If reading from an inbox brief instead, read the brief and then read the source file it points to.

## Step 2: Check for Conflicts

Search `ai-resources/` for existing resources with similar names or purposes:
1. Check `.claude/commands/`, `.claude/agents/`, `.claude/hooks/` for name matches
2. Check `workflows/*/` for the same
3. If a match exists, present it: "A resource with this name already exists at {path}. Options: (a) update the existing one, (b) rename this one, (c) abort."

**Stop and wait for confirmation if there's a conflict.**

## Step 3: Classify Placement

Present to the operator:

1. **What it does** — 2-3 sentence summary from reading the file
2. **Dependencies** — what other files, skills, agents, or project-specific content it references
3. **Hardcoded references** — any project-specific paths, names, or content that need generalizing
4. **Recommended placement:**
   - **Shared** (`ai-resources/.claude/{commands|agents|hooks}/`) — if useful in any Claude Code project regardless of template
   - **Workflow template** (`ai-resources/workflows/research-workflow/.claude/{commands|agents|hooks}/`) — if useful only in projects deployed from a specific template
5. **Changes needed** — specific list of what needs to be generalized (e.g., "replace `buy-side-service-plan` with generic path", "remove reference to `parts/working-hypotheses/`")

**Stop and wait for the operator to confirm placement and approve the changes list.**

### Step 3a: Plan-time placement verification

After the operator confirms the placement and before any `Write` in Step 4, run the placement verifier (`ai-resources/docs/placement-verifier.md`) with:
- `PLANNED_PATH` = the target location decided in Step 3
- `ARTIFACT_TYPE` = the resource type from Step 1 (command / agent / hook / workflow-template / etc.)
- `GATE` = `plan-time`

On `MATCH` or `MATCH-WITH-EXCEPTION`, proceed to Step 4. On `MISMATCH`, halt and emit the verifier's loud-failure chat block; resume only after the operator selects redirect, override, or log + override.

## Step 4: Generalize

Apply the approved changes:

1. Replace hardcoded project paths with `$CLAUDE_PROJECT_DIR` or relative references
2. Replace project-specific content references with generic equivalents or parameterized placeholders
3. Remove operator-name references (e.g., "Patrik") — use "the operator" instead
4. For commands: ensure the command works without project-specific files (or document required files in a comment at the top)
5. For hooks: ensure `$CLAUDE_PROJECT_DIR` is used consistently for path resolution
6. For agents: remove project-specific analytical lenses unless they're the core purpose

Write the generalized version to the target location determined in Step 3.

## Step 5: Quick Verification

Read the generalized file back and check:

1. **No project-specific references remain** — no hardcoded project names, paths, or domain content
2. **Dependencies resolve** — any referenced files, skills, or agents exist in ai-resources or are documented as requirements
3. **Self-contained** — a fresh Claude encountering this resource in a new project would understand it without context from the source project
4. **Functional** — for hooks, verify the script is executable and the logic is sound

If issues found, fix them. If unfixable without operator input, flag and stop.

### Step 5.5: Generalization-residue verification (fail-and-revise loop)

After Step 5's self-checks pass, run an independent residue scan via a fresh-context subagent. This catches what main-agent self-check misses — project-specific terminology, identifiers, or framing patterns that read as generic to the author but are obvious project-specific residue to a fresh reader. Boundary: this step verifies **generalization**, not **placement** — placement is owned by Step 3a (plan-time) and Step 5a (end-time) via `docs/placement-verifier.md`. If both fire, placement-verifier wins on placement-related findings; this residue check defers.

**Subagent contract (per `ai-resources/CLAUDE.md § Subagent Contracts`):**

- **Type:** `general-purpose` agent, fresh context.
- **Input (passed in the agent prompt):**
  - `GENERALIZED_PATH` — absolute path of the file written in Step 4
  - `SOURCE_PROJECT_CLAUDE_MD_PATH` — absolute path of the source project's `CLAUDE.md` (the project the resource was forked from). Derive from the source file's path captured in Step 1 (`projects/<source-project>/.../<resource>.md` → `projects/<source-project>/CLAUDE.md`); if absent, fall through with a one-line note in the agent prompt.
  - `WORKING_NOTES_PATH` — `audits/working/graduate-residue-{slug}-{YYYY-MM-DD}.md`, where `{slug}` is the generalized resource's filename stem (without extension). Pass-2 writes to `...-{YYYY-MM-DD}-pass2.md` to preserve Pass-1's evidence trail.
- **Procedure (the subagent's mandate):**
  1. Read `SOURCE_PROJECT_CLAUDE_MD_PATH`. Extract: project name(s), hardcoded paths (`projects/<name>/...`), domain-specific terminology (deal types, asset classes, jurisdiction terms, etc.).
  2. Read `GENERALIZED_PATH`. Grep-scan for each extracted token. Capture every match with line number.
  3. Write full findings to `WORKING_NOTES_PATH` (one section per residue class: project names; paths; domain terms; framing).
  4. Return a ≤20-line summary to the main session with: total residue count, residue-class breakdown, top-3 highest-priority residues (one line each: `{line N}: "{snippet}" → suggest replacement`).
- **Output verdict** (last line of summary): exactly one of `RESIDUE: clean` (no findings) or `RESIDUE: {N}` (N residues found, see notes file).

**Fail-and-revise loop (cap: 2 passes — mirrors `docs/qc-independence.md` § QC → Triage Auto-Loop):**

- **Pass 1.** If verdict is `RESIDUE: clean`, proceed to Step 5a.
- If verdict is `RESIDUE: {N>0}`, re-run Step 4 with the residue findings as explicit revision targets. Main agent: read the working-notes file, apply the suggested replacements, write the revised file. Then spawn a second residue-check subagent pass with `WORKING_NOTES_PATH` suffixed `-pass2` (preserves Pass-1 evidence).
- **Pass 2.** If verdict is now `RESIDUE: clean`, proceed to Step 5a. If verdict is still `RESIDUE: {N>0}`, halt the auto-loop and emit the operator-pause block below.

**Operator-pause block (cap-hit shape — mirrors `docs/placement-verifier.md` MISMATCH block):**

```
### Generalization Residue — Cap-Hit Halt

`{GENERALIZED_PATH}` still has {N} residues after 2 auto-revise passes. Residue evidence:

- Pass-1 notes: `{WORKING_NOTES_PATH}` (initial residues)
- Pass-2 notes: `{WORKING_NOTES_PATH}-pass2` (surviving residues after auto-revise)

Top 3 surviving residues:
1. `{line N}`: "{snippet}" — class: {project-name | hardcoded-path | domain-term | framing}
2. `{line N}`: "{snippet}" — class: {...}
3. `{line N}`: "{snippet}" — class: {...}

Pick one:
(a) **Accept as intentional** — the residues are load-bearing for the resource; proceed to Step 5a despite them. Record the reason in the commit message.
(b) **Revise manually** — edit `{GENERALIZED_PATH}` directly to resolve; re-run Step 5.5 manually (single residue-check subagent pass, no further auto-revise).
(c) **Abort the graduation** — the residues indicate the resource is not generalizable in its current shape; revert Step 4 and either redesign or keep the resource project-local.
```

The 2-pass cap is the same discipline as the QC → Triage Auto-Loop — repeated machine fixes hitting the same residues are a structural signal, not a fix-able fault.

### Step 5a: End-time placement verification

After Step 5's checks pass and before Step 6 / Step 7, run the placement verifier (`ai-resources/docs/placement-verifier.md`) with:
- `PLANNED_PATH` = the actual path written in Step 4
- `ARTIFACT_TYPE` = same as Step 3a
- `GATE` = `end-time`

On `MATCH` or `MATCH-WITH-EXCEPTION`, proceed. On `MISMATCH`, halt — the actual write drifted from the plan; emit the verifier's loud-failure chat block and resume only after operator resolution.

### Step 5b: Runtime-dependency check (present-but-inert guard)

Before reporting the graduation as operable, inventory the resource's **per-project runtime dependencies** — files the command/agent reads at runtime that each consuming project must provide (operator-authored reference docs, `context/*.md` inputs, project-local config). Source: the generalized file's own body — grep it for hard-coded relative paths and "read X" instructions.

If at least one per-project runtime dependency exists:

1. Enumerate the consuming projects that will receive the resource (the shared-manifest / symlink set).
2. For each project, check whether the dependency files exist. Report one line per project: `{project}: OPERABLE` or `{project}: INERT (missing: {files})`.
3. State the split in the completion summary. "Broadcast to N projects" is NOT "operable in N projects" — never report the first as the second.
4. If most consumers are INERT, surface the option of scoping the symlink broadcast to the operable subset — operator's call; do not silently gate.

Skip silently when the resource has no per-project runtime inputs (most commands/agents). Origin: 2026-07-03 — `/reconcile` was graduated and broadcast to ~20 projects while its `context/mandate-rubric.md` + `context/resource-activation-map.md` runtime inputs existed in only one, so it shipped present-but-inert in the rest and the completion report did not say so.

## Step 6: Register in Settings (Hooks Only)

If the resource is a hook that should fire for all projects:

1. Check if it's already registered in `~/.claude/settings.json` (user-level)
2. If not, present the hook registration entry and ask the operator to confirm before adding it
3. If it should only fire for template projects, note that the workflow template's `settings.json` needs updating

Skip this step for commands and agents — they're discovered automatically via `--add-dir`.

## Step 7: Update Tracking

1. If the source project has an `logs/innovation-registry.md`, update the entry: status → `graduated`, Graduated To → the target path
2. If an inbox brief exists for this resource, delete it (it's been processed)
3. Commit the new resource in ai-resources:
   - Stage the new file(s)
   - Commit message: `new: {resource-type} {name} — {one-line purpose}` (e.g., `new: command optimize-repo — repository health optimization`)
   - Do NOT push — pushes are batched and gated to the `/wrap-session` confirmation prompt (workspace `CLAUDE.md` § Push behavior; stale "push automatically" instruction corrected 2026-07-03)

## Key Rules

- Never graduate without operator confirmation on placement and changes
- Never modify the source project's copy — graduation creates a new file in ai-resources
- If the resource references skills, check they exist in `ai-resources/skills/` before graduating
- Keep the generalized version as close to the original as possible — don't "improve" it during graduation
