# Placement Verifier — Canonical Procedure

> **When to read this file:** When a canonical creation pipeline reaches a placement-decision boundary — either before its first `Write` (plan-time) or before its final commit-prompt (end-time). The procedure is consumed *on demand* by pipelines; it is not always-loaded and does not auto-fire.
>
> **Why this exists:** `/placement` returns a routing recommendation in chat, then pipelines `Write` files independently. Without verification, recommendation and write can diverge silently — the file lands somewhere other than the recommended canonical home, and no gate catches the mismatch. This procedure closes that gap. It is the structural counterpart to `/placement`: `/placement` advises, this procedure verifies.
>
> **Scope at v1:** Integrated into `/graduate-resource` only (the highest-leverage pipeline per the originating plan). Extension to `/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project` is deferred to `/friday-act` triage gated on observed placement misses, per `principles.md § DR-7` (generalize only when a second confirmed consumer exists).

---

## Inputs

The calling pipeline supplies:

- **`PLANNED_PATH`** — the absolute or repo-relative path the pipeline intends to write (plan-time gate), OR the path it just wrote (end-time gate).
- **`ARTIFACT_TYPE`** — one of: `skill`, `slash command`, `agent`, `hook`, `process doc`, `operational log`, `audit artifact`, `standalone prompt`, `workflow template`, `style reference`, `workspace rule`, `ai-resources rule`, `project rule`, `permission template`, `manifest`, `deployable fragment`.
- **`GATE`** — `plan-time` or `end-time`.

---

## Method

1. **Load the canonical-home table.** Read `ai-resources/docs/repo-architecture.md § Canonical homes by artifact type` (anchored by section heading, not line number — the table moves with edits to the doc).

2. **Look up the canonical home pattern** for `ARTIFACT_TYPE` in the table's "Canonical home" column. Each entry is a path pattern (e.g., `ai-resources/skills/<name>/SKILL.md`, `ai-resources/.claude/commands/<name>.md`).

3. **Normalize `PLANNED_PATH`** to a repo-relative form. Strip any absolute prefix above `~/Claude Code/Axcion AI Repo/`.

4. **Compare** `PLANNED_PATH` against the canonical-home pattern. Match rules:
   - Replace `<name>` and similar placeholders with `*` (single path segment).
   - Match by structural shape: directory prefix + filename pattern.
   - A path is `MATCH` if it conforms to the pattern.
   - A path is `MISMATCH` if it does not.

5. **Check project-local exceptions** (`repo-architecture.md § Canonical homes by artifact type` — the "Project-local exceptions" sub-section under the table). A `MISMATCH` may be a `MATCH-WITH-EXCEPTION` if it falls under one of:
   - Pipeline-stage commands tightly coupled to one project's workflow (e.g., `pipeline-stage-3a.md` for `/new-project`).
   - Project evaluator agents.
   - Project-specific commands not intended for reuse.
   - Files listed in the project's `.claude/shared-manifest.json` under `commands.local` / `agents.local`.

   For `MATCH-WITH-EXCEPTION`, name the specific exception that applies.

6. **Return** one of:
   - `MATCH`
   - `MISMATCH` (include the canonical home pattern + the actual path for the chat block)
   - `MATCH-WITH-EXCEPTION` (include the named exception)

---

## On MISMATCH — loud-failure handling

When the result is `MISMATCH`, the calling pipeline **halts** and emits this chat block:

```
## ⚠ Placement verifier — MISMATCH

**Gate:** {plan-time | end-time}
**Artifact type:** {ARTIFACT_TYPE}
**Canonical home:** {canonical pattern from repo-architecture.md}
**Planned/actual path:** {PLANNED_PATH}
**Source of truth:** ai-resources/docs/repo-architecture.md § Canonical homes by artifact type

The pipeline stopped because the path does not conform to the canonical home for this artifact type. Resolve before continuing.

**Operator options:**
1. **Redirect** — accept the canonical home; the pipeline rewrites the target path and resumes.
2. **Override** — accept the non-canonical path as deliberate (e.g., a project-local exception not yet documented); state the reason in one line. The pipeline records the override in its own logging and resumes.
3. **Log + override** — invoke `/friction-log` to record this as a friction event before resuming. Use this when the MISMATCH reveals a recurring gap that the canonical home documentation should be updated to cover.
```

The verifier procedure itself writes nothing. Logging is delegated to `/friction-log` (the canonical writer for friction events per `repo-architecture.md § Q6`), invoked by the operator if the MISMATCH warrants it. This avoids any direct-write violation of two-end contracts on log schemas.

---

## On MATCH and MATCH-WITH-EXCEPTION

`MATCH` — the calling pipeline continues silently. No chat output is required.

`MATCH-WITH-EXCEPTION` — the calling pipeline continues. The pipeline may emit a one-line confirmation noting the exception (e.g., "Placement verifier: MATCH-WITH-EXCEPTION — project-local pipeline-stage command per repo-architecture.md") for operator visibility, but is not required to.

---

## Two-gate firing model — by analogy to `/risk-check`

This procedure mirrors `/risk-check`'s plan-time + end-time firing pattern (`ai-resources/docs/audit-discipline.md § When to fire`). The reason for two gates here is the same as for `/risk-check`: a plan-time gate catches placement errors before tokens are spent on the wrong-place write; an end-time gate catches drift between what the pipeline planned and what it actually wrote.

- **Plan-time** fires after the pipeline has decided what path(s) to write, before the first `Write`.
- **End-time** fires after the pipeline has finished writing, before the operator-facing commit prompt.

A pipeline that writes only one file at a known canonical home may skip the end-time gate (the plan-time gate alone suffices). A pipeline that writes multiple files, transforms paths mid-flow, or accepts operator overrides should run both gates.

---

## Out of scope

- **Hook-based auto-fire on every `Write`** — rejected by the originating plan and System Owner advisory. Would tax every Write with a check the common case does not need.
- **Direct writes to `friction-log.md`** — rejected; that log is written by `/friction-log` only (`repo-architecture.md § Q6`). Operator-invoked logging via `/friction-log` is the canonical path.
- **Multi-pipeline integration** — at v1, only `/graduate-resource` integrates this procedure. Extension to other pipelines is gated on observed placement misses.

---

## Maintenance

- If `repo-architecture.md § Canonical homes by artifact type` is reorganized, this procedure stays valid because it anchors by section heading, not line number.
- If a new `ARTIFACT_TYPE` is added to the canonical-home table, this procedure handles it automatically — no edit needed here.
- If the two-gate pattern in `audit-discipline.md § When to fire` changes, review whether the analogy still holds and update the cross-reference above.
