---
name: refresh-project-state
description: "Refresh the Strategic Context Snapshot for every targeted Axcíon project — fan out one read-only snapshot agent per project, two-pass confidentiality scrub, then one atomic write of all snapshots into the knowledge-bases/strategic-os/ vault. Operator-triggered, on-demand. Read-only toward projects; writes only the vault's project-state/ folder."
model: sonnet
---

You orchestrate an on-demand refresh of every targeted project's **Strategic Context Snapshot** and collect the results into the `knowledge-bases/strategic-os/` Obsidian vault. You are the single orchestrator in a fan-out-then-collect workflow. You dispatch; the per-project agents read; the scrub-verifier checks; you perform the one atomic vault write.

This automates the manual prompt at `projects/strategic-os/docs/project-context-snapshot-prompt.md`. Full design: `projects/strategic-os/docs/project-state-workflow-spec.md` (the spec is the contract — read §3, §4, §5 before changing this command).

## Hard rules (load-bearing)

1. **Read-only toward projects.** No agent and not you may `Write`/`Edit`/`Bash`-mutate any file inside a scanned project. The workflow writes ONLY the vault's `project-state/` folder (and a staging area under `ai-resources/audits/working/`).
2. **Confidentiality is gated at generation + verification, not at a human review step.** Because the OS reads the vault directly, the per-project scrub (§4.3) plus the two-pass scrub-verifier are the ONLY gate between a project's raw content and the OS. A snapshot that fails verification is NOT written. The Step 1.5 Read-deny guard is a structural backstop; the **scrub-verifier is the load-bearing control** (a filename deny cannot catch client names embedded in normally-named files).
3. **Atomic vault write.** Notes + `project-state/_index.md` + `_master-index.md` update as one unit (§5.2), via write-temp-then-rename on the indexes (Step 4). Partial failure rolls back — no index drift.
4. **A failed project never aborts the batch.** It drops to a recorded skip; its prior snapshot (if any) is retained.

## Inputs

- **Argument (optional):** a comma-separated project-scope filter, e.g. `/refresh-project-state nordic-pe-screening,buy-side-service-plan`. No argument = all eligible projects.

## Step 1 — Enumerate eligible projects

1. Resolve `WORKSPACE` = the workspace root (the directory whose children include `projects/`, `ai-resources/`, `knowledge-bases/`).
2. `Glob projects/*/CLAUDE.md` → each match is an eligible project (its folder name is the project key). A candidate directory with no `CLAUDE.md` is silently skipped (not a project — §9).
3. If a scope argument was supplied, intersect the eligible set with it. Report any scope token that matched no project.
4. Print the resolved target list (project keys) in chat and let the operator narrow before fan-out — mirror the confirmed-set gate used for the roadmap. Default to the full list if the operator does not narrow.

## Step 1.5 — Confidentiality guard pre-flight (G1 — structural, abort-on-fail)

Before any fan-out, verify the Read-deny that structurally blocks reading `*deal-*` / `*client-*` / `*confidential*` files is **loaded for this session** — not merely present in a settings file. Claude Code permission denies are per-session, resolved from the session-root's settings stack; a deny configured in workspace-root `settings.json` does NOT load if this command runs from a different root, and subagents inherit this session's settings (they do not load a target project's settings). So check live enforcement, not just config:

1. **Config check.** Confirm `$WORKSPACE/.claude/settings.json` `deny` contains all three patterns `Read(**/*deal-*)`, `Read(**/*client-*)`, `Read(**/*confidential*)`. If any is missing → **ABORT**: "Confidentiality guard not configured at workspace-root settings.json. Add the three Read-deny patterns before running (see `projects/strategic-os/docs/project-state-workflow-spec.md` §14 G1)."
2. **Active-load probe (the load-bearing check).** `Write` a throwaway probe file `ai-resources/audits/working/.refresh-guard-probe-confidential.md` (its name contains `confidential`, so a loaded deny blocks **reading** it; Write is not denied). Then attempt to `Read` it.
   - Read is **denied** (permission error) → the guard is ACTIVE. Delete the probe; proceed to Step 2.
   - Read **succeeds** → the guard is NOT loaded for this session (this command was likely run from a non-workspace-root cwd). Delete the probe and **ABORT**: "Confidentiality guard is configured but NOT active in this session — run `/refresh-project-state` from the workspace root so workspace-root `settings.json` loads, or the deny does not protect the snapshot agents' reads. Aborting before fan-out."

This guard is structural, not prompt-adherence: the workflow refuses to fan out unless the deny is provably enforced.

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

Perform a single atomic update set (§5.2) for all PASS snapshots, using **write-temp-then-rename** on the two index files so a crash mid-write leaves the prior indexes intact (G3 structural rollback):

1. Write each `knowledge-bases/strategic-os/project-state/<PROJECT_KEY>.md` (overwrite — one rolling snapshot per project; §5.1). These are per-project content files; a failed individual write drops that project to skip and does NOT touch the indexes.
2. Compute the NEW `project-state/_index.md` content (one row per PASS snapshot now on disk: `| [[project-state/<key>]] | auto | <as_of> | <§6 one-liner> |`) and write it to `project-state/_index.md.tmp`.
3. Compute the NEW `_master-index.md` content (updated `## Project State` link + `Recent updates` line) and write it to `_master-index.md.tmp`.
4. **Atomic pointer-flip (do last, together):** `mv project-state/_index.md.tmp project-state/_index.md`, then `mv _master-index.md.tmp _master-index.md`. `mv` over an existing file on the same filesystem is atomic, so a crash before the `mv` leaves the prior index intact (no drift); a crash between the two `mv`s leaves at most one index ahead — detected by `/kb-integrity` Check D and re-closed by the next run.
5. **Rollback:** if any step 1–3 write fails, delete any `*.tmp` files and abort WITHOUT running the step-4 `mv` — the live indexes never moved, so content and indexes stay consistent. Surface the failure.

If the vault submodule/repo is dirty or detached, abort the write step with a clear message — do not force (§9).

## Step 5 — Report

Print a compact result table: project · written | withheld | skip · reason. State the run-stamp and the staging dir path. Remind the operator that the OS reads these snapshots directly (no promotion step) and that stale snapshots are flagged OS-side via `source_commit` vs project HEAD (§6.2).

## Failure modes (§9)

- Confidentiality guard not loaded → abort before fan-out (Step 1.5); nothing read, nothing written.
- Agent fail/timeout → recorded skip; prior snapshot retained; batch continues.
- Verifier flags a snapshot → withheld + surfaced; others proceed.
- Atomic write fails midway → temp files deleted, no `mv`, no index drift.
- Crash between the two index `mv`s → at most one index ahead; `/kb-integrity` Check D flags it; next run re-closes.
- No `CLAUDE.md` in a candidate dir → skipped silently.
- Vault dirty/detached → abort write step, clear message, no force.
