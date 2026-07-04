---
model: opus
argument-hint: "[project-path — defaults to the current project root]"
allowed-tools: Bash(git *), Bash(ls:*), Bash(head:*), Bash(grep:*), Bash(mkdir:*), Read, Glob, Write
---

Scaffold the two reference files `/reconcile` needs — `context/mandate-rubric.md` and `context/resource-activation-map.md` — as **starter drafts** a project operator then edits and ratifies. `/reconcile` is fully built but stays dormant in any project that has not hand-authored both files; authoring them from a blank page is the friction that parks it. `/reconcile-activate` removes the blank page: it derives the structure and everything mechanically derivable (the resource inventory from `context/`, candidate dimension *names* from the mandate/brief), and leaves every judgment cell as an explicit `{{AUTHOR: …}}` placeholder.

It does **not** author the project's quality bar. The judgment content — what "good" means per dimension, which resources are load-bearing for which task type — is the operator's to supply. The output is gated: `/reconcile` refuses to run against a scaffolded file until every `{{AUTHOR:}}` placeholder is replaced and the DRAFT banner is deleted (see `ai-resources/docs/reconcile-report-template.md` § Ratification banner and gate signals — the single source for the banner and gate strings this command writes). This is deliberate: an auto-drafted rubric that ran as-is would make `/reconcile` a pass-everything rubber-stamp.

Input: `$ARGUMENTS` — optional. Path to the target project root. Defaults to the current project.

Examples:
- `/reconcile-activate` — scaffold for the current project
- `/reconcile-activate projects/sell-side-playbook` — scaffold for a named project

---

### Step 1 — Resolve the target project

1. Set `DATE` = today, `YYYY-MM-DD`.
2. Set `PROJECT_ROOT`: if `$ARGUMENTS` is non-empty, use it (resolve relative to the current working directory); else use `$CLAUDE_PROJECT_DIR` if set; else `git rev-parse --show-toplevel`. If the resolved directory does not exist, abort naming the path tried.
3. Set `MANDATE_RUBRIC_PATH` = `{PROJECT_ROOT}/context/mandate-rubric.md`. Set `RESOURCE_MAP_PATH` = `{PROJECT_ROOT}/context/resource-activation-map.md`.
4. Read the canonical banner and gate-signal strings from `{AI_RESOURCES}/docs/reconcile-report-template.md` § "Ratification banner and gate signals" (resolve `AI_RESOURCES` by walking upward from `PROJECT_ROOT` to the nearest `ai-resources/`). Use those exact strings — do not re-invent the banner or the `{{AUTHOR:` token here.

### Step 2 — Overwrite guard (never clobber a ratified file)

5. For each of `MANDATE_RUBRIC_PATH` and `RESOURCE_MAP_PATH`, test existence.
   - If **both** already exist, abort with: "This project already has both reference files. `/reconcile-activate` never overwrites them. If you intend to re-scaffold, move the existing file(s) aside first." Do not read or modify them.
   - If **one** exists, scaffold only the missing one and note in the final report that the existing file was left untouched.
   - If **neither** exists, scaffold both.
6. `mkdir -p {PROJECT_ROOT}/context` if the directory is absent.

### Step 3 — Gather derivation inputs (read-only)

7. Read, where present, and record which were found vs missing:
   - `{PROJECT_ROOT}/CLAUDE.md` — project purpose, stage, constraints.
   - The most recent `**Mandate:**` line in `{PROJECT_ROOT}/logs/session-notes.md` (if the file exists) — the session-mandate echo.
   - A project brief — glob `{PROJECT_ROOT}/context/project-brief.md`, then `{PROJECT_ROOT}/**/project-brief.md`; read the first match if any.
   - The listing of `{PROJECT_ROOT}/context/` (`ls`) — the real resource inventory for the activation map.
8. **Degradation rule (never fabricate).** Any value you cannot derive from a read input above becomes an `{{AUTHOR: …}}` placeholder that names exactly what the operator must supply and why. Never invent a dimension standard, a "weak looks like" example, a banned term, or a resource's purpose. A missing input degrades to a placeholder, never to a silent-empty cell or a plausible-sounding guess.

### Step 4 — Write `MANDATE_RUBRIC_PATH` (if missing)

9. Write the file with this shape (mirrors the proven `projects/buy-side-service-plan/context/mandate-rubric.md`), banner first:
   - **Line 1:** the exact DRAFT banner from the template doc (it contains the plain-ASCII `NOT RATIFIED` string the gate reads), with `{DATE}` filled in.
   - `# Mandate Rubric — {project name} (DRAFT)`
   - `> **What this file is:**` — the standard one-line description (this boilerplate may be written directly; it is not a judgment cell).
   - `## Project context (why these dimensions, not generic ones)` — 2–4 sentences derived from CLAUDE.md / brief if available; otherwise a single `{{AUTHOR: state this project's purpose, stage, and the binding constraint its outputs must respect — pulled from the project brief}}` placeholder.
   - `## Rubric dimensions (required — every reconciliation scores all of these)` — a table `| Dimension | What "good" means here | What "weak" looks like |`. Derive 3–6 candidate dimension **names** from the mandate/brief when the material supports it (e.g. a stated binding constraint → a dimension). Leave **both** the "good" and "weak" cells of every row as distinct `{{AUTHOR: …}}` placeholders. If no dimension names are derivable, emit three `{{AUTHOR: name a dimension …}}` rows.
   - `## Required dimensions (Fail-eligible per reconcile-verdict-definitions.md)` — `{{AUTHOR: state which dimensions are Fail-eligible vs Conditional-Pass-eligible}}`.
   - `## Not yet confirmed (do not invent — flag as a rubric gap if judgment needs one of these)` — carry the buy-side file's guidance verbatim in spirit: instruct that unconfirmed rules (e.g. prohibited-language) must be escalated to the operator, never inferred.
   - `## Version history` — `- v1-DRAFT ({DATE}): scaffolded by /reconcile-activate from {list the inputs actually read}. Not ratified.`

### Step 5 — Write `RESOURCE_MAP_PATH` (if missing)

10. Write the file with this shape (mirrors `projects/buy-side-service-plan/context/resource-activation-map.md`), banner first:
    - **Line 1:** the exact DRAFT banner (as in Step 4), with `{DATE}`.
    - `# Resource Activation Map — {project name} (DRAFT)`
    - `> **What this file is:**` — standard one-line description (boilerplate, may be written directly).
    - `## Resource inventory` — a table `| Resource | Path | What it grounds |`. Populate **Path** from the actual `context/` listing (Step 3). Leave **What it grounds** as `{{AUTHOR: what this resource is the authority for}}` for each real file found. If `context/` is empty besides these two files, emit `{{AUTHOR: list this project's authority resources and their paths}}`.
    - `## Task-type → required-resource mapping` — a table `| Task type | Must consult | Should consult | Evidence a reconciliation should look for |` with 2–4 `{{AUTHOR: …}}` rows (task types are project-specific; do not invent them).
    - `## How /reconcile uses this file` — this explanatory boilerplate may be copied from the buy-side file (it is generic mechanics, not project judgment).
    - `## Version history` — `- v1-DRAFT ({DATE}): scaffolded by /reconcile-activate. Not ratified.`

### Step 6 — Report to operator (no commit)

11. Display in chat:
    - `Scaffolded reconcile reference files — {project name}`
    - For each file: `Wrote: {path} — {N} {{AUTHOR:}} placeholders to fill` OR `Skipped (already exists): {path}`.
    - Ratification instructions: "Replace every `{{AUTHOR: …}}` placeholder with this project's real standard, then delete the top DRAFT banner line from each file. `/reconcile` will run once both files are ratified. Until then it aborts with a ratification notice — by design."
    - Reminder: "These are starter drafts. The dimension standards and task-type mappings are yours to author — the scaffolder deliberately did not guess them."
12. `/reconcile-activate` writes only the two draft files. It does not ratify them, run `/reconcile`, or commit anything.
