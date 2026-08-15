---
model: sonnet
---

# /new-project — Project Pipeline Orchestrator

You are the orchestrator for Axcíon's project pipeline. This pipeline discovers approved planning artifacts (context pack, project plan, optional technical spec) from the `projects/project-planning/` workspace and produces a fully configured Claude Code setup through a series of staged gates, starting at Stage 3a (Repo Snapshot).

## Scope Validation

This command serves **any Axcíon need that arrives asking for a project** — building AI resources (skills, workflows, agents), setting up a research project, configuring a new workspace, or any other work where Claude Code is the execution environment. It equally serves needs that turn out **not** to warrant a project: ordinary one-time work, and work an existing repository already owns. Step 0 decides which.

Before doing anything else, check that the input describes Axcíon work with a deliverable behind it. Reject only genuinely off-scope input — a bare question with nothing to produce, or a request belonging to a different tool entirely. **Do not reject an input because it may not need a repository, or may not be built or run through Claude Code.** Those are Step 0 dispositions, not scope failures.

**CWD guard:** Check if the current working directory is the `ai-resources` repo itself (i.e., the CWD contains a `skills/` directory and a `CLAUDE.md` with "Axcion AI Resource Repository" at the root level). If so, stop and tell the user:

> "This command should be run from a project repo or the Axcíon AI workspace root, not from ai-resources directly. Open your target repo and run `/new-project` from there."

**Note:** Running from the Axcíon AI workspace root (the parent directory that contains `ai-resources/`, `projects/`, etc.) is valid — the guard only blocks running from inside `ai-resources/` itself.

## Step 0 — Qualify

Most needs that arrive here do not require the full pipeline. Decide what the need actually warrants **before** any provisioning runs. Nothing in this step is recorded as a route, mode, classification or state — the disposition is a judgment you state in chat and then act on.

**Input.** `$ARGUMENTS` — the need in ordinary language. If it is empty, ask exactly one question and wait:

> "What do you need? One or two lines is enough."

**Immediate fallthrough.** If the input reads as *resume*, *continue*, *next stage* or similar on work already under way, skip the rest of Step 0 and go straight to `## First Run vs. Continuation`.

### 0.1 State the need

Reflect the need back in three lines: the practical outcome wanted, who uses it, and what would show it worked. Ask only business questions that genuinely cannot be inferred from the input and the repository. Ask no technical questions — architecture, tooling and structure are yours to decide, not the operator's.

### 0.2 Inspect existing ownership

Find out whether something already owns this responsibility. **Do not assume a project has a `CLAUDE.md`** — inspect whichever authority surface is actually present.

1. `ls projects/` to get the candidate set.
2. Pick at most **three** plausible owners, by name and by what the need is about.
3. For each, `ls` its top level, then read **whichever of these exists**, in this order: `README.md` → `PROJECT.md` → `CLAUDE.md`.
4. If none exists, judge from the directory's own structure — subdirectory names, and the two or three most recent files under `output/`, `docs/` or equivalent. If the directory is empty, that is *insufficient evidence to judge* — say so rather than guessing.
5. **Read budget: 10 files total.** Exceeding it is a finding to report, not a licence to keep reading.

State each candidate as **owns it** / **owns part of it** / **adjacent but different**, giving the path and the specific file the judgment rests on.

### 0.3 Choose one disposition

State the disposition and the reason in one line before acting, so the operator can redirect in a sentence.

| Disposition | Condition | What happens | Files created |
|---|---|---|---|
| **A — No repository** | one-time or ordinary work; no durable responsibility | Do the work now. Deliver in chat, or write one file **only** into a location the operator names, or an existing project's `output/`. Never invent a top-level directory. | 0 (or 1 named file) |
| **B — Existing owner** | an existing repository already holds the responsibility | Name the owner, its path, and the file the judgment rests on. Return a qualified handoff in chat. Do **not** modify that repository. | 0 |
| **C — Small durable document project** | durable, unowned, and there is an immediately useful document to write now | Run 0.4 in order. | 1–3 |
| **Fallthrough** | anything else — software, automation, an AI resource, shared infrastructure, a multi-session build, or any need you cannot confidently place | Say so in one line, then continue to `## Pre-Flight Validation` unchanged. | legacy behaviour |

Ambiguity resolves toward fallthrough, never toward A, B or C.

### 0.3a Project `CLAUDE.md` outcome — decide before anything is created

Every path below this point creates files. Decide **now**, before the first `mkdir`, which of three outcomes this need gets, and state the outcome and the reason in one line. This decision binds disposition C (0.4), the engineered path (First Run step 6) and the Direct Route alike — none of them may create a project directory before it has been made.

**First, the specialist-template check — it stops this command.** If the need is a **Research Workflow** project (research execution, source-class analysis, staged research reports — the workflow under `ai-resources/workflows/research-workflow/`), this command does **not** scaffold it and does **not** create the project directory. That workflow owns a specialist project `CLAUDE.md`, stored inert as `CLAUDE.md.template` and activated at deploy time by `/deploy-workflow` (`docs/repo-architecture.md` § Non-active filenames for specialist templates). Scaffolding here would create a second, wrong `CLAUDE.md` at the deploy target.

> Stop. Create nothing — no directory, no files, no git init. Report: *"This is a Research Workflow project. `/new-project` does not scaffold it — run `/deploy-workflow` instead, which deploys the workflow's own specialist `CLAUDE.md` along with the rest of the workflow."* Then end the run.

Otherwise choose exactly one:

| Outcome | When | What gets written |
|---|---|---|
| **1 — Specialist template** | a workflow owns the project `CLAUDE.md` for this kind of need | nothing here — hand off to that workflow's deploy command (today: Research Workflow → `/deploy-workflow`) |
| **2 — Minimal project file** | a durable project: everything on the engineered path, and every direct-route project | `templates/project-claude-md.md` (title + description), plus the route line on the direct path, plus **only** project-specific sections that earn their place |
| **3 — No project file** | a genuinely short-lived document project — disposition C, where the deliverable is the point and no session-governing rule is needed | no `CLAUDE.md` at all. **Report the two consequences below.** |

**What earns a project-specific section (outcome 2).** A section belongs in a project `CLAUDE.md` only if it states a rule that applies to *every turn* in that project's sessions and can live nowhere else — the workspace `## CLAUDE.md Scoping` rule. Concretely: the project's own pipeline stages, its own routing map, a confidentiality boundary, a domain constraint. **Never copy a workspace rule into it.** Input-file handling, commit and push behaviour, compaction, session boundaries, QC discipline and model tiering are workspace-level and already load in every session; restating them per project is exactly the duplication that was stripped from 26 project files on 2026-07-27. If you cannot say why a section must be project-local, it does not go in.

**Outcome 3 — the two consequences, reported explicitly.** A project with no `CLAUDE.md` is not merely thinner; it is invisible to two subsystems. Name both in the report rather than letting the operator find out later:

1. **`/refresh-project-state` skips it entirely.** That command enumerates projects with `Glob projects/*/CLAUDE.md` and *silently skips* any candidate directory without one (`refresh-project-state.md` Step 2, and §9). The project therefore receives **no Strategic Context Snapshot** in the `knowledge-bases/strategic-os/` vault and never appears in cross-project strategic queries.
2. **The Context Engine never runs for it.** `/session-start` Step 2.4 skip condition 3 tests `! [ -f "<project-root>/CLAUDE.md" ]` and skips the `context-discovery` agent before it is invoked. Sessions in that project get **no context pack**, and their mandate's `Files in scope` stays `(inferred)`.

Neither is a one-way door — adding a `CLAUDE.md` later restores both. Choose outcome 3 when the project genuinely ends with its document; choose outcome 2 if in doubt.

### 0.4 Disposition C — ordered sequence

**Preconditions 1–4 run first. All four must pass before anything is created. Any failure stops the path, creates nothing, and reports. None is auto-corrected.**

1. **Name validation.** Must match `^[a-z0-9]+(-[a-z0-9]+)*$` and be ≤ 64 characters — no spaces, dots, slashes, or leading/trailing hyphen. On failure, propose a corrected name and ask the operator to confirm it. Do not silently normalise.

2. **Target path validation.** Resolve the workspace root by walking up to the nearest ancestor containing **both** `ai-resources/` and `projects/`. Assert the target resolves to exactly `<workspace-root>/projects/<name>`. Reject any path containing `..`. Reject the case where `projects/` is itself a symlink.

3. **Non-existence.** `[ -e "<target>" ]` must be false — file, directory or symlink alike. If anything exists there, **stop**. Do not write into it, reuse it, merge with it, or rename around it. Report the collision and the operator's options.

4. **Root `.gitignore` is committable.** Determine all three:

   ```bash
   grep -Fxq "projects/<name>/" "<workspace-root>/.gitignore"      # entry already present?
   git -C "<workspace-root>" diff        --quiet -- .gitignore     # unstaged changes?
   git -C "<workspace-root>" diff --cached --quiet -- .gitignore   # staged changes?
   ```

   - Entry **present** → pass. Nothing will need writing to `.gitignore` later.
   - Entry **absent** and `.gitignore` **clean** against HEAD → pass.
   - Entry **absent** and `.gitignore` **dirty** (staged or unstaged) → **STOP HERE.** Do not `mkdir`. Do not write any file. Do not stage or commit anything. Report a **paused** disposition naming: the pre-existing modification to `.gitignore`, why the line cannot be appended into a contested file, and the two ways forward — commit or stash the pending `.gitignore` change and re-run, or proceed without ignoring and accept an untracked project tree in the root repo. The operator decides.

5. **Create the directory.** `mkdir "<target>"` — non-recursive, so it fails if something appears between check and create.

6. **Write the deliverable and any justified companions.**
   - `projects/{name}/{deliverable}.md` — **always.** The document itself; this is the point of the disposition.
   - `projects/{name}/PROJECT.md` — **only when work continues past this session.** Exactly these four headings:

     ```markdown
     # Project

     ## Outcome and scope

     ## Current work and next action

     ## Verification and disposition
     ```

   - `projects/{name}/README.md` — **only when a durable explanation of purpose is needed beyond the document itself.** For a single-document project, normally no.

7. **Verify and correct — a final pass, completed before any mutating Git command runs.**

   Do all content editing first. Then, when you believe the files are finished, run this pass:

   1. **Re-read every file you created, from disk.** Not from memory of what you wrote — open each one again. This is the step that catches what drafting missed.
   2. **Compare the final contents against all four of:** the need as stated in 0.1; the authority sources you actually relied on; the scope and exclusions you set; and the practical-use requirement — can the intended user use this as it stands?
   3. **Resolve every known factual, scope or usability concern before committing.** Fix what is wrong.
      - If an unresolved concern **materially affects factual accuracy or practical usability**, pause before any mutating Git command and ask the unresolved business question, or report the missing evidence. **Do not commit.**
      - A genuinely **non-blocking** limitation may be disclosed clearly in the document and in your report.
   4. If `PROJECT.md` was written, confirm its next action matches what the document actually leaves open.
   5. **State explicitly that this final verification is complete** before any mutating Git command, including `git init`, `git add` or `git commit`. Read-only Git inspection required by the earlier preconditions — for example precondition 4's `git diff --quiet -- .gitignore` checks — remains permitted.

   **Nothing is staged, committed or initialised until step 7 has finished**, so the first commit records a verified deliverable rather than a draft plus a fix-up.

   **After the project's initial commit is created, do not modify project content or create a corrective commit during the same run. If a new content defect is discovered after committing, report the result as paused and stop.** Leave the commit as it stands and name the defect in the report — the operator decides what happens next. The remedy for an unverified commit is a more careful step 7, not a second commit.

8. **Initialise the project repository.**

   ```bash
   git -C "projects/{name}" init
   git -C "projects/{name}" add .
   git -C "projects/{name}" commit -m "init: {name} — {one-line purpose}"
   ```

   **No remote** — do not ask for a GitHub URL; one can be added later. **No push.**

9. **Ignore the project in the root repo** — follow 0.5.

10. **Report** one of *delivered and closed* / *created and ready for use* / *paused*. Name every file created, and report each commit **actually** created. Always report the project's initial-commit SHA. Report a root `.gitignore` commit SHA **only when this run created one**; if the entry already existed and no root commit was made, say so explicitly.

**Prohibited on this path.** Do not create: a `.claude/` directory, `settings.json`, `settings.local.json`, hooks, agents, symlinks, `pipeline/`, `pipeline-state.md`, `decisions.md`, `sources.md`, `logs/`, a `Model Selection` section, a project `CLAUDE.md`, an `**Execution route:**` line, copied planning artifacts, or any empty directory.

### 0.5 Root `.gitignore` — isolated, recoverable commit

The one write this path makes outside the new project.

**Step 1 — re-check, cheaply.** Re-run precondition 4's three tests immediately before writing; state can have changed. If the entry is now present → skip to the report. If `.gitignore` has become dirty → **stop**: the project exists and is committed, the ignore line is pending, and the report says so with the recovery options. Never append into a file that has become contested.

**Step 2 — append.** Confirm the file's last byte is a newline; if not, append one first so the new entry cannot be glued onto the previous line. Then append exactly one line: `projects/{name}/`. **Append only** — do not sort, dedupe, reflow, or group it with other `projects/` entries. Every existing byte is preserved.

**Step 3 — commit that path alone, by pathspec.**

```bash
git -C "<workspace-root>" commit -m "chore: ignore projects/{name}/ — project has its own repo" -- .gitignore
```

The pathspec form commits the working-tree content of `.gitignore` only; it does not consult or disturb the index for any other path, so unrelated modified and untracked files cannot be swept in. Record the resulting SHA. **No push** — pushes stay batched and gated.

**Step 4 — forbidden.** Never `git add -A`, `git add .`, `git add -u`, `git commit -a`, or any commit without a pathspec. Never stage or commit any path other than `.gitignore`.

**Recovery.** `git -C "<workspace-root>" revert <sha>` — one file, one added line, so the revert is clean. If the line ends up uncommitted, remove exactly that line with a targeted edit. **Never** `git checkout -- .gitignore` or `git restore .gitignore` — either would discard any other uncommitted change to that file.

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

   # Execution route — read from the brief. ONLY the exact literal `direct` activates the
   # lightweight path; `engineered`, absent, or malformed all fall through to the engineered
   # (full) path (fail-safe). See ai-resources/docs/control-pack-schema.md §7(d). Resolved in step 4b.
   ROUTE=$(grep -m1 -oE '^\*\*Execution route:\*\* *(direct|engineered)\b' "$SRC/context-pack.md" 2>/dev/null | grep -oE '(direct|engineered)$')

   # Latest project-plan — REQUIRED for the engineered path; OPTIONAL for direct (a brief suffices).
   # sort -V handles v10+ correctly (ls -v is GNU-only, not portable to macOS BSD).
   LATEST_PLAN=$(ls "$SRC"/project-plan-v*.md 2>/dev/null | sort -V | tail -n 1)
   if [ "$ROUTE" != "direct" ]; then
     [ -n "$LATEST_PLAN" ] || { echo "ERROR: No project-plan-v*.md in $SRC. Cannot proceed (engineered route requires an approved plan)."; exit 1; }
   fi

   # Latest tech-spec — optional
   LATEST_SPEC=$(ls "$SRC"/tech-spec-v*.md 2>/dev/null | sort -V | tail -n 1)

   # QC verdicts — advisory. Match both double-bold (**PASS**) and single-bold (PASS-WITH-FINDINGS) forms.
   #
   # Two-end contract with /plan-evaluate AND /spec-evaluate (project-planning pipeline):
   # - This grep block reads the first-line `**Verdict:** {TOKEN}` from plan-qc-verdict.md
   #   and spec-qc-verdict.md.
   # - Token set (closed): PASS | PASS-WITH-WAIVER | BLOCK-DRIFT | FAIL.
   # - The regex `^\*\*Verdict:\*\*\s+\**PASS` matches PASS and PASS-WITH-WAIVER (PASS-prefix);
   #   BLOCK-DRIFT and FAIL correctly fall through to the WARN branch below.
   # - Do not extend or modify this regex without coordinating with the verdict-write step in
   #   BOTH producers: projects/project-planning/.claude/commands/plan-evaluate.md (Step 6)
   #   AND projects/project-planning/.claude/commands/spec-evaluate.md (Step 6).
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

4b. **Resolve the execution route and branch — do this before any scaffolding.** Using `ROUTE` from step 4:
   - If `ROUTE` is empty (the brief carried no valid `**Execution route:**` line) **and** `projects/{project-name}/CLAUDE.md` already exists with an exact `**Execution route:** direct` line, set `ROUTE=direct` (a re-run / continuation of a direct project).
   - If `ROUTE` is still empty, **ask the operator once:** *"Execution route for {project-name}? `direct` = lightweight (deliverables + minimal support; no pipeline, no architecture/spec/testing stages) or `engineered` = full pipeline. Choose `engineered` only if the project needs durable engineering machinery or material technical risk — shared state, integrations, deployment, coordinated testing, or comparable lifecycle complexity; executable code alone is not a reason."* Default on no clear answer: `engineered` (fail-safe).
   - **If `ROUTE == direct` → go to the `## Direct Route` section and do NOT execute steps 5–12 or any staged pipeline.** That section is self-contained (it asks for the GitHub URL, scaffolds, enriches leanly, and inits git).
   - **Otherwise (`engineered`, the fail-safe default) → continue with step 5 below** — the full pipeline, unchanged.

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

12. **Spawn the Stage 3a subagent** (`pipeline-stage-3a`). Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

### Continuation

1. Read the pipeline state file for the project.
2. Find the stage that is `in_progress`, or the first `pending` stage whose predecessor is `completed` (or `skipped`).
3. Announce: "Resuming pipeline at [stage name]. Last completed: [previous stage]."
4. Spawn the corresponding stage subagent. Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

**Agent name mapping:** Stages 3a–5 use the `pipeline-stage-{N}` naming convention. Stage 6 (Session Guide) uses the `session-guide-generator` agent instead.

**Legacy pipeline-state migration.** If a pipeline-state.md still lists Stage 2 or 2.5 as `in_progress` or `pending` (from before this change), stop and tell the operator they have two options: (a) manually edit the state file to remove those rows and set Stage 3a to `in_progress` (confirming the project's plan and tech spec exist in `projects/project-planning/output/{name}/`), or (b) abandon the in-progress pipeline and re-run `/new-project` from scratch. Do not auto-migrate.

## Direct Route (execution_route == `direct`)

Reached from First Run step 4b when the resolved route is exactly `direct`. Produces a **lightweight** project — the requested deliverables plus only explicitly-justified support — and **nothing else**. There is no pipeline, no stages, and no architecture/spec/testing machinery. Everything here is deliberately smaller than the engineered path; do not add machinery the operator did not request.

**Do NOT create for a direct project:** a `pipeline/` directory or anything under it (`context-pack.md` / `project-plan.md` copies, `sources.md`, `pipeline-state.md`, `decisions.md`, `repo-snapshot.md`, `architecture.md`, `implementation-spec.md`, `implementation-log.md`, `test-results.md`). **Do NOT** spawn Stages 3a–5 or the Architecture Gate. **Do NOT** emit the `/repo-dd` + `/analyze-workflow` baseline reminder. **Do NOT** pre-create `logs/decisions.md`. **Do NOT** install `shared-manifest.json` or wire the auto-sync SessionStart hook.

All steps are idempotent — re-running `/new-project` on an existing direct project makes no destructive change and adds no machinery.

1. **Ask for the GitHub repository link** (as engineered step 5) — used for git setup in step 7.

2. **Create the project directory** — `projects/{project-name}/` only. **No `pipeline/` subdirectory.** The brief is NOT copied in; it stays in the planning workspace (git and that workspace already preserve it).

3. **Minimal `CLAUDE.md` (Step 0.3a outcome 2).** Render `templates/project-claude-md.md` with `{{NAME}}` / `{{PROJECT_DESCRIPTION}}` substituted — the same mechanics as enrichment step 4, **including its never-overwrite guard** — then write one line immediately under the description:

   ```
   **Execution route:** direct
   ```

   That is the whole file: title, description, route line — five lines including the blanks. **Do not** append any workspace-rule section, **do not** add a `## Model Selection` section, and **do not** add a `/reconcile` pointer. The route line must match the canonical predicate exactly (`docs/session-marker.md` § Direct-route detection): literal `**Execution route:** direct`, at line start, lower-case `direct`. `/prime`, `/session-start` and `/session-plan` all key on it, so a stylistic variation silently reverts the project to the engineered route.

4. **`settings.json` — permissions + the permission-sanity hook ONLY (no auto-sync hook).** Merge the canonical permissions block and the **permission-sanity** SessionStart hook from the template, but **omit the auto-sync hook** — direct projects are not wired for full-library sync. Locate the template by the same walk-up idiom as enrichment step 2.

   ```bash
   command -v jq >/dev/null || { echo "ERROR: jq required for settings merge"; exit 1; }
   SETTINGS="projects/{project-name}/.claude/settings.json"
   mkdir -p "$(dirname "$SETTINGS")"
   [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

   d="$(cd projects/{project-name} && pwd)"; AI_RES=""
   while [ "$d" != "/" ]; do d=$(dirname "$d"); [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break; done
   [ -n "$AI_RES" ] || { echo "ERROR: ai-resources not found in any ancestor"; exit 1; }
   TEMPLATE="$AI_RES/templates/project-settings.json.template"
   [ -f "$TEMPLATE" ] || { echo "ERROR: canonical settings template missing at $TEMPLATE"; exit 1; }

   CANONICAL_PERMS=$(jq -c '.permissions' "$TEMPLATE")
   SANITY_HOOK=$(jq -c '.hooks.SessionStart[1].hooks[0]' "$TEMPLATE")   # [1] = permission-sanity; [0] = auto-sync (omitted for direct)

   jq --argjson perms "$CANONICAL_PERMS" --argjson sanity "$SANITY_HOOK" '
     (if (.permissions.allow // []) | length > 0 then . else .permissions = $perms end)
     | .hooks = (.hooks // {})
     | .hooks.SessionStart = (.hooks.SessionStart // [])
     | (if (.hooks.SessionStart | any(.hooks? // [.] | .[]? | .command == $sanity.command))
        then . else .hooks.SessionStart += [{"hooks":[$sanity]}] end)
   ' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
   ```

5. **`settings.local.json`** — write the `additionalDirectories` grant exactly as enrichment step 3 (per-machine, gitignored, absolute path).

6. **Fixed core symlink set (no auto-sync).** Symlink the minimum core commands and the workspace-wide repository-problem skill directly from ai-resources into the project. Do not install `shared-manifest.json` and do not run `auto-sync-shared.sh`. Other specialists remain reachable on demand via the `additionalDirectories` grant; to opt into full sync later, add the auto-sync hook (enrichment step 2) and re-run `/new-project`.

   ```bash
   # Recompute AI_RES here — each Bash block is a fresh shell, so a value from step 4 does not persist.
   d="$(cd projects/{project-name} && pwd)"; AI_RES=""
   while [ "$d" != "/" ]; do d=$(dirname "$d"); [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break; done
   [ -n "$AI_RES" ] || { echo "ERROR: ai-resources not found in any ancestor — cannot symlink core commands"; exit 1; }

   CORE="prime wrap-session session-start session-plan open-items clarify scope recommend"
   mkdir -p "projects/{project-name}/.claude/commands"
   for c in $CORE; do
     SRCCMD="$AI_RES/.claude/commands/${c}.md"
     LNK="projects/{project-name}/.claude/commands/${c}.md"
     [ -f "$SRCCMD" ] || { echo "WARN: core command missing in ai-resources: ${c}.md"; continue; }
     [ -e "$LNK" ] || ln -s "$SRCCMD" "$LNK"
   done
   mkdir -p "projects/{project-name}/.agents/skills"
   SKILL_SRC="$AI_RES/.agents/skills/diagnose-and-fix"
   SKILL_LNK="projects/{project-name}/.agents/skills/diagnose-and-fix"
   [ -d "$SKILL_SRC" ] || { echo "ERROR: core skill missing: diagnose-and-fix"; exit 1; }
   REL_SKILL_SRC=$(python3 -c 'import os, sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$SKILL_SRC" "$(dirname "$SKILL_LNK")")
   [ -e "$SKILL_LNK" ] || [ -L "$SKILL_LNK" ] || ln -s "$REL_SKILL_SRC" "$SKILL_LNK"
   echo "Core command set and repository-problem skill symlinked (no auto-sync hook installed — direct project)."
   ```

7. **Git repository setup** — exactly as engineered step 5b (init the project's own repo, untrack from workspace root, add to root `.gitignore`, initial commit, **no push**), using the GitHub URL from step 1 (direct projects have no `pipeline-state.md` to read it from).

8. **No `logs/decisions.md` yet.** Create `logs/` and `logs/decisions.md` **lazily** — only when the first durable decision is actually recorded (`/wrap-session` and `/prime` both tolerate its absence). Do not pre-create the register.

   **But when `logs/` is created — lazily or otherwise — provision `logs/scripts/` with it**, using the same copy block as engineered step 4a. `/wrap-session` Step 3 calls `logs/scripts/check-archive.sh` on a plain relative path with no walk-up, so a direct project that grows a `logs/` directory without `scripts/` fails that step at every wrap and never archives. Deferring the *register* is deliberate; deferring the *archiver* just reproduces the gap this rule exists to close.

9. **Report and hand off.** Report: route = direct; project directory created (no `pipeline/`); lean `CLAUDE.md` written with the route line; `settings.json` (permissions + sanity hook, no auto-sync); `settings.local.json` grant; core command set symlinked (N of 10); `diagnose-and-fix` skill symlinked; git initialized, initial commit left unpushed. Skipped by design: pipeline, Stages 3a–5, Architecture Gate, the `/reconcile` pointer, and the `/repo-dd` / `/analyze-workflow` reminder. Then **author the requested deliverables directly** — research, drafting, and review still happen; they produce deliverables, not governance artifacts.

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
     "agents": { "local": [ ... ] },
     "skills": { "local": [], "shared": [] }
   }
   ```

2. **`projects/{name}/.claude/settings.json`** — wire the SessionStart hook **and** ensure the project inherits a tool-permissions baseline so the operator does not get approval prompts on routine Edit/Write/Grep calls.

   **Requires `jq` on PATH.** If `jq` is not available, stop and report the missing dependency — do not attempt string-level JSON manipulation.

   **Canonical permissions block** (mirrors `ai-resources/docs/permission-template.md` Layer D). Three structural additions compared to the pre-2026-04-24 template, driven by four root causes surfaced in the permission-sweep design doc:

   - `"defaultMode": "bypassPermissions"` — without this, projects default to prompt-on-allow regardless of their allow list (the primary cause of recurring Edit/Delete prompts).
   - `Edit(**/.claude/**)` and `Write(**/.claude/**)` — `**` globs do not match dotfile path components by default, so broad `Edit(X/**)` rules leave nested `.claude/` paths uncovered.
   - `Bash(rm *)` — narrow `rm` in allow (destructive `rm -rf` stays on deny). Fixes Delete/Remove prompts.

   Note: `additionalDirectories` is **not** included in this canonical block and is **never written to the tracked `settings.json`** — it is a machine-specific absolute path and belongs only in the gitignored, per-machine `settings.local.json`. Step 3 below writes it there (a separate jq merge against the local file), keeping committed settings portable-by-construction.

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

   # Locate canonical templates via walk-up to ai-resources/ (load-bearing per review 2026-05-25 mitigation #2)
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

3. **Grant ai-resources filesystem visibility (per-machine, in gitignored `settings.local.json`)** — Claude Code sandboxes each project to its own directory by default. Shared skills under `ai-resources/skills/` and symlinks into `ai-resources/.claude/{commands,agents}/` are unreachable until the workspace root is added to `permissions.additionalDirectories`. **This grant must NOT be written to the tracked `settings.json`** — per `ai-resources/docs/permission-template.md`, committed settings must never carry a machine-specific absolute path (a recurring portability defect; see the `settings-path-portability` mission, 2026-06-26). It belongs in the gitignored, per-machine `.claude/settings.local.json`. This step writes it there. **Note:** `additionalDirectories` is the *only* thing this pipeline writes to `settings.local.json` — a `"model"` field must never be written there (or to any settings layer) per workspace `CLAUDE.md` § Model Tier.

   The walk to locate the workspace root mirrors the idiom in `ai-resources/.claude/hooks/auto-sync-shared.sh` (walk upward until an ancestor contains `ai-resources/`). Use an **absolute** path, not a relative one — Claude Code resolves `additionalDirectories` relative to session CWD, which varies by how the project is opened, so a relative form is unsafe. An absolute path is safe to write here precisely because `settings.local.json` is gitignored and never leaves this machine.

   **Load-bearing jq semantics:** `settings.local.json` may not exist yet, or may already hold other per-machine keys. jq's `=` operator on the leaf path `.permissions.additionalDirectories` synthesizes any missing parent objects automatically and preserves every other top-level key, so a single idempotent jq call is sufficient — if jq is ever replaced (Python, Node, yq), that tool must do the same parent-object auto-creation and key preservation.

   ```bash
   command -v jq >/dev/null || { echo "ERROR: jq required for additionalDirectories merge"; exit 1; }

   LOCAL="projects/{name}/.claude/settings.local.json"   # gitignored, per-machine — NOT the tracked settings.json
   [ -f "$LOCAL" ] || echo '{}' > "$LOCAL"

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
       "$LOCAL" > "$LOCAL.tmp" && mv "$LOCAL.tmp" "$LOCAL"
   fi
   ```

   `settings.local.json` is gitignored (workspace + project `.gitignore`), so this machine-specific path is never committed. On any **other** machine the operator re-runs this same grant (or applies the snippet in `ai-resources/docs/settings-local-recovery.md`) — it is a per-machine step.

   Report in the step output:
   - whether `additionalDirectories` was added to `settings.local.json`, already present, or skipped (walk failed)
   - the absolute workspace path that was added

4. **`projects/{name}/CLAUDE.md`** — write the minimal project file (Step 0.3a **outcome 2**), then add **only** project-specific sections that earn their place.

   **Skip this step entirely if Step 0.3a chose outcome 1 or outcome 3.** Outcome 1 hands off to the workflow's own deploy command; outcome 3 creates no file, and its two consequences are reported per 0.3a.

   **Never overwrite an existing file.** If `projects/{name}/CLAUDE.md` already exists, leave it byte-for-byte as it is and report *"CLAUDE.md already present — left unchanged"*. A rerun of `/new-project` against an existing project changes nothing here. There is no per-section append and no backfill: this command writes a project's `CLAUDE.md` once, at creation.

   **No workspace rules are copied.** The four canonical section fragments (`## Input File Handling`, `## Commit Rules`, `## Compaction`, `## Session Boundaries`) were removed on 2026-07-27. Those rules are workspace-level and already load in every session; restating them per project is the duplication that was then stripped back out of 26 project files. Do not reintroduce them here or in the Direct Route. The same applies to `## Model Selection` — see the note at the end of this step.

   **Canonical content source.** The skeleton is `ai-resources/templates/project-claude-md.md` — title and description only, carrying the mustache placeholders `{{NAME}}` and `{{PROJECT_DESCRIPTION}}`. It is the single source of truth for the created file's opening; to change what a new project starts with, edit the template, not this command. The mustache syntax is deliberately distinct from the single-brace `{name}` / `{project-description}` tokens the calling agent substitutes into this bash source, so the agent's global substitution pass cannot corrupt the python search strings. See `ai-resources/templates/README.md` for the consumer contract.

   **Procedure:**

   ```bash
   CLAUDE_MD="projects/{name}/CLAUDE.md"

   # Locate the canonical template via walk-up to ai-resources/ (same idiom as step 2)
   d="$(cd projects/{name} && pwd)"
   AI_RES=""
   while [ "$d" != "/" ]; do
     d=$(dirname "$d")
     [ -d "$d/ai-resources" ] && AI_RES="$d/ai-resources" && break
   done
   [ -n "$AI_RES" ] || { echo "ERROR: ai-resources not found in any ancestor — cannot locate the canonical CLAUDE.md template"; exit 1; }

   SKELETON="$AI_RES/templates/project-claude-md.md"
   [ -f "$SKELETON" ] || { echo "ERROR: canonical CLAUDE.md skeleton missing at $SKELETON"; exit 1; }

   if [ -f "$CLAUDE_MD" ]; then
     # Idempotency guard: an existing project CLAUDE.md is never rewritten, appended to, or backfilled.
     echo "CLAUDE.md already present at $CLAUDE_MD — left unchanged"
   else
     # Substitution mechanics — read this before editing:
     # The calling agent processes this bash source as text and replaces {name} + {project-description} GLOBALLY
     # before the Bash tool runs. To survive that, the substitution targets must appear EXACTLY ONCE each — on the
     # PROJECT_NAME= / PROJECT_DESCRIPTION= lines below. The python3 step then does a literal string-replace on the
     # skeleton's content using PROJECT_NAME / PROJECT_DESCRIPTION as values; argv-passing avoids all shell-quoting
     # hazards (apostrophes, ampersands, backslashes, dollar signs in the project description are safe).
     #
     # python3 is on macOS by default and is already an implicit dependency of other ai-resources tooling. If the
     # python3 dependency becomes a concern, awk with `-v` (which also passes vars without shell interpretation)
     # is the closest alternative; sed is NOT safe here because `&` in PROJECT_DESCRIPTION expands to the match.
     # The skeleton uses mustache-style placeholders {{NAME}} and {{PROJECT_DESCRIPTION}} — distinct from the
     # agent's single-brace {name} / {project-description} tokens, so the agent's global text-substitution pass
     # over this bash source never touches the python search strings or the template content.
     PROJECT_NAME="{name}"
     PROJECT_DESCRIPTION="{project-description}"
     python3 -c "
import sys
with open(sys.argv[1]) as f: content = f.read()
sys.stdout.write(content.replace('{{NAME}}', sys.argv[2]).replace('{{PROJECT_DESCRIPTION}}', sys.argv[3]))
" "$SKELETON" "$PROJECT_NAME" "$PROJECT_DESCRIPTION" > "$CLAUDE_MD" \
       || { echo "ERROR: python3 substitution failed"; exit 1; }
     echo "CLAUDE.md created from the minimal skeleton at $CLAUDE_MD"
   fi
   ```

   **Then, and only then, consider project-specific sections** — added by hand, one at a time, each with a justification you can state in one line. Apply the 0.3a test: does this rule apply to every turn in this project's sessions, and can it live nowhere else? Most projects need none at creation; a project needing three is unusual. If the answer is "none", the file stays at title and description — that is a correct result, not an incomplete one.

   **Do not write a `## Model Selection` section, and do not ask the operator for a model preference.** Model defaults are prohibited at every layer (workspace `CLAUDE.md` § Model Tier); the operator selects the session model with `/model`, and commands, agents and skills bind their own tier in frontmatter. An absent section is the normal and expected state, and nothing reads for one — `/prime`'s model-alignment check was retired 2026-07-30; `/session-plan` Step 2 is the only model check left, and it compares the session model against the *task*, never against a project section.

   Report in the step output:
   - CLAUDE.md created from skeleton / already present, left unchanged
   - project-specific sections added, each with its one-line justification (or "none — title and description only")

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

   **Also provision `logs/scripts/`.** `/wrap-session` Step 3 runs `CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh` on a **plain relative path** — there is no walk-up fallback at that call site. A project without `logs/scripts/` therefore fails that step at every wrap and its logs are never archived. This was true of 13 projects before 2026-07-26, some with session notes over 1800 lines.

   **Copy, do not symlink.** Per-project copies are the established topology and are deliberately customised in several projects (`axcion-brand-book` runs 1500/700 line thresholds against canonical 500/400). A symlink would silently remove that ability.

   ```bash
   SCRIPTS_DIR="$LOGS_DIR/scripts"
   CANON_SCRIPTS="ai-resources/logs/scripts"
   mkdir -p "$SCRIPTS_DIR"
   for s in check-archive.sh split-log.sh; do
     if [ ! -f "$SCRIPTS_DIR/$s" ]; then
       cp "$CANON_SCRIPTS/$s" "$SCRIPTS_DIR/$s" && chmod +x "$SCRIPTS_DIR/$s"
       echo "Created $SCRIPTS_DIR/$s"
     else
       echo "$SCRIPTS_DIR/$s already present — skipping"
     fi
   done
   ```

   `check-archive.sh` locates `split-log.sh` as a sibling in its own directory, so both must be copied together — copying only the first yields a script that fails at the point it tries to archive.

   Report in the step output:
   - created `logs/decisions.md` / already present
   - created `logs/scripts/{check-archive,split-log}.sh` / already present

5. **Initial sync** — run the hook once now so the project starts with all shared commands/agents already linked, instead of waiting for the next session start:

   ```bash
   CLAUDE_PROJECT_DIR="projects/{name}" bash ai-resources/.claude/hooks/auto-sync-shared.sh
   ```

5a. **Canonical command verification.** After the initial sync, verify the minimum-required canonical commands are present in `projects/{name}/.claude/commands/`. The auto-sync hook should have installed all of these — this step is a safety-net that catches regressions in the hook's exclusion logic or in the project's `shared-manifest.json`.

   Required canonical commands (every project must have these on session 1):
   - `prime.md` — session orientation
   - `wrap-session.md` — session closeout
   - `session-start.md` — Phase-3 mandate capture
   - `session-plan.md` (writes `logs/session-plan-{YYYY-MM-DD}-{marker}.md` per `docs/session-marker.md`) — session-orchestration planning
   - `open-items.md` — backlog inventory
   - `clarify.md` — request-clarification structured prompt
   - `scope.md` — scope-summary generator
   - `recommend.md` — operator-defers-to-Claude self-decision path

   ```bash
   MISSING=()
   for cmd in prime wrap-session session-start session-plan open-items clarify scope recommend; do
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

Co-Authored-By: Claude <noreply@anthropic.com>
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

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
   ```

   Report in the step output:
   - GitHub remote: set to `{url}` / WARN (not found in pipeline-state — set manually)
   - Workspace root index: cleaned up N files / already untracked
   - `.gitignore`: updated / already present
   - Project repo: initialized, initial commit with N files
   - **Push:** do NOT push here. Per the workspace gated-push rule (inverted 2026-05-29), the initial commit stays local — pushes are batched to session end and confirmed via a single operator prompt at `/wrap-session` (or an explicit "ship it"). Report: "Initial commit created locally and left unpushed. It will be pushed at `/wrap-session` with the rest of the session's batch (the operator confirms the push then). If the GitHub repo does not exist yet, create it before wrap so the push target resolves."

### Report

Report what was created: manifest path, settings.json modifications (permissions block, SessionStart hook), the `additionalDirectories` grant written to the gitignored `settings.local.json`, CLAUDE.md state (created from skeleton / already present, left unchanged) together with any project-specific sections added and their justification, `logs/decisions.md` scaffold (created / already present), the list of files the initial sync symlinked, the canonical command verification result (all 10 present / N missing), and the git setup result (remote, initial commit, workspace root `.gitignore`, and that the initial commit was left **unpushed** — it ships at `/wrap-session` with the gated-push batch). From this point on, any new command added to `ai-resources/.claude/commands/` will be available in this project on the next session start automatically, and skills under `ai-resources/skills/` are reachable via the filesystem grant.

**Then add the `/reconcile` maintenance notice to the report — in the report only, never written into the project's `CLAUDE.md`.** This is guidance for the operator at hand-off, not a standing instruction the project carries forever (moved here on 2026-07-27; it previously shipped as a paragraph inside every engineered project's `CLAUDE.md`). Engineered route only — the Direct Route omits it by design.

> Once this project produces real deliverables, run `/reconcile` after each major output to judge it against the project mandate (mandate-compliance, resource activation, genericness). `/reconcile` is canonical in `ai-resources` and is symlinked into this project by the sync above. It needs `context/mandate-rubric.md` and `context/resource-activation-map.md` to run — when the first deliverable approaches, scaffold both with `/reconcile-activate`, then author and ratify them (replacing the `{{AUTHOR:}}` placeholders) before the first `/reconcile`.

## Key Rules

- Never advance a stage without user confirmation (`NEXT`)
- Never modify decisions.md without user confirmation
- Always announce which stage is running and what it expects as input
- When spawning any subagent, always include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"
- The `pipeline/pipeline-state.md` file is the source of truth for pipeline progress — always read it before taking action, always update it after state changes. Pipeline artifacts live in `pipeline/`: `context-pack.md`, `project-plan.md`, and (optionally) `technical-spec.md` are **discovered inputs** copied from `projects/project-planning/output/{name}/` at First Run; `repo-snapshot.md`, `architecture.md`, `implementation-spec.md`, `implementation-log.md`, and `test-results.md` are **pipeline-generated outputs**. Provenance for the discovered inputs is recorded in `pipeline/sources.md`. Only the project's working files live at the project root.
- If the project involves creating new skills, inform the user that new-skill work is qualified through `/develop-ai-resource`, which hands a qualified brief to `/create-skill`. Both are canonical ai-resources commands. Connecting `ai-resources` via `--add-dir` grants file access but does **not** register its slash commands — `--add-dir` loads `.claude/skills/` only, never `.claude/commands/`. The commands are available in this project only once they are present in its own `.claude/commands/`, which the shared-resource sync provides as symlinks. If they are absent, run the sync (or work from a directory that already has them) rather than assuming `--add-dir` exposed them.
