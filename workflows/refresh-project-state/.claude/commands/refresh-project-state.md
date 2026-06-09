---
name: refresh-project-state
description: "Refresh the Strategic Context Snapshot for every targeted Axcíon project — fan out one read-only snapshot agent per project, two-pass confidentiality scrub, then one atomic write of all snapshots into the knowledge-bases/strategic-os/ vault. Operator-triggered, on-demand. Read-only toward projects; writes only the vault's project-state/ folder."
model: sonnet
---

> **DEV ARTIFACT — not yet graduated.** This command lives in `ai-resources/workflows/refresh-project-state/` during build (Session 1 of the two-session split). It is NOT symlinked into projects and MUST NOT be run for real until: (a) `/risk-check` on the vault governance amendment returns GO, (b) the vault `project-state/` folder + template + `_index.md` exist, and (c) the amendment (spec §15) has landed. See `projects/strategic-os/docs/project-state-workflow-spec.md` §14 for the gated build order. Graduation home: `ai-resources/.claude/commands/refresh-project-state.md`.

You orchestrate an on-demand refresh of every targeted project's **Strategic Context Snapshot** and collect the results into the `knowledge-bases/strategic-os/` Obsidian vault. You are the single orchestrator in a fan-out-then-collect workflow. You dispatch; the per-project agents read; the scrub-verifier checks; you perform the one atomic vault write.

This automates the manual prompt at `projects/strategic-os/docs/project-context-snapshot-prompt.md`. Full design: `projects/strategic-os/docs/project-state-workflow-spec.md` (the spec is the contract — read §3, §4, §5 before changing this command).

## Hard rules (load-bearing)

1. **Read-only toward projects.** No agent and not you may `Write`/`Edit`/`Bash`-mutate any file inside a scanned project. The workflow writes ONLY the vault's `project-state/` folder (and a staging area under `ai-resources/audits/working/`).
2. **Confidentiality is gated at generation + verification, not at a human review step.** Because the OS reads the vault directly, the per-project scrub (§4.3) plus the two-pass scrub-verifier are the ONLY gate between a project's raw content and the OS. A snapshot that fails verification is NOT written.
3. **Atomic vault write.** Notes + `project-state/_index.md` + `_master-index.md` update as one unit (§5.2). Partial failure rolls back — no index drift.
4. **A failed project never aborts the batch.** It drops to a recorded skip; its prior snapshot (if any) is retained.

## Inputs

- **Argument (optional):** a comma-separated project-scope filter, e.g. `/refresh-project-state nordic-pe-screening,buy-side-service-plan`. No argument = all eligible projects.

## Step 1 — Enumerate eligible projects

1. Resolve `WORKSPACE` = the workspace root (the directory whose children include `projects/`, `ai-resources/`, `knowledge-bases/`).
2. `Glob projects/*/CLAUDE.md` → each match is an eligible project (its folder name is the project key). A candidate directory with no `CLAUDE.md` is silently skipped (not a project — §9).
3. If a scope argument was supplied, intersect the eligible set with it. Report any scope token that matched no project.
4. Print the resolved target list (project keys) in chat and let the operator narrow before fan-out — mirror the confirmed-set gate used for the roadmap. Default to the full list if the operator does not narrow.

## Step 2 — Fan out: one snapshot agent per project

For each target project, dispatch the **`project-state-snapshot-agent`** (Task tool) with:

- `PROJECT_DIR` — absolute path to the project folder.
- `PROJECT_KEY` — the project folder name (becomes the snapshot filename `project-state/<PROJECT_KEY>.md`).
- `STAGING_PATH` — `ai-resources/audits/working/project-state/<run-stamp>/<PROJECT_KEY>.md` (the agent writes its snapshot here, NOT into the project; create `<run-stamp>` once with a `date +%Y%m%d-%H%M%S` value at the start of the run).

Concurrency: bounded fan-out (the runtime caps concurrent subagents). Each agent is scoped to its own project directory; no agent reads another project.

Collect each agent's returned summary + staging path. An agent that fails or times out → record `{project, status: skip, reason}` and continue (§9). Do **not** retry inline more than once.

## Step 3 — Two-pass confidentiality verification

Dispatch the **`project-state-scrub-verifier`** (Task tool) ONCE over the whole staged batch:

- `STAGING_DIR` — `ai-resources/audits/working/project-state/<run-stamp>/`.
- It runs (a) a deterministic marker/keyword scan and (b) a lightweight semantic pass, per spec §4.3, and writes a per-snapshot verdict report to the staging dir.

Read the verifier's summary. Partition the staged snapshots into **PASS** (eligible to write) and **FAIL** (withheld). Every FAIL is surfaced to the operator with its reason; it is NOT written to the vault.

## Step 4 — One atomic write into the vault

> This step only runs for real once the vault `project-state/` scaffold + the §15 amendment exist (Session 2). Until then, STOP after Step 3 and report the staged + verified result.

Perform a single atomic update set (§5.2) for all PASS snapshots:

1. Write each `knowledge-bases/strategic-os/project-state/<PROJECT_KEY>.md` (overwrite — one rolling snapshot per project, not append; §5.1).
2. Rewrite `project-state/_index.md` so its table holds one row per current snapshot (note · status · last_updated · summary) — matching the `findings/_index.md` shape.
3. Update `_master-index.md`: the `## Project State` section link + the `Recent updates` line.

All-or-nothing: stage the writes, and if any single write fails, roll back the others so no index drifts from content. If the vault submodule/repo is dirty or detached, abort the write step with a clear message — do not force (§9).

## Step 5 — Report

Print a compact result table: project · written | withheld | skip · reason. State the run-stamp and the staging dir path. Remind the operator that the OS reads these snapshots directly (no promotion step) and that stale snapshots are flagged OS-side via `source_commit` vs project HEAD (§6.2).

## Failure modes (§9)

- Agent fail/timeout → recorded skip; prior snapshot retained; batch continues.
- Verifier flags a snapshot → withheld + surfaced; others proceed.
- Atomic write fails midway → full rollback, no index drift.
- No `CLAUDE.md` in a candidate dir → skipped silently.
- Vault dirty/detached → abort write step, clear message, no force.
