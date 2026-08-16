# Workflow sync — reconciliation ruling for the 11 sector-unit worktrees

**Date:** 2026-08-13
**Derived in:** `axcion-si-worktrees/building-services-install` (Stage 2 complete, no live pipeline session — chosen deliberately)
**Template assumed:** `research-workflow`. The project `CLAUDE.md` carries no `workflow:` or `template:` line, so `/sync-workflow` Step 1.3's default applies. **Worth fixing** — every unit will re-make this assumption.
**Status:** RULING — nothing applied. Dry-run only.

---

## Why this file exists

`/sync-workflow` is a per-project command, and there are eleven unit worktrees. Run independently in each, it produces eleven separate judgment calls about the same eight files — which is precisely how deployed copies diverge in the first place. **Decide once here; apply per worktree at its own Stage 2 → Stage 3 boundary.** The application is mechanical once the ruling exists.

---

## Scan result

**41 canonical files compared** (`.claude/commands`, `.claude/agents`, `.claude/hooks`, `logs/scripts`). **32 identical, 8 differing, 0 missing, 0 new-in-canonical.**

The drift is small — one to three lines in seven of the eight files. This is **not** a version gap. Both sides carry the 2026-07-14 chassis re-cut including Condition 5.

---

## The ruling, per file

Three distinct causes, and they resolve in opposite directions. Treating all eight as "update available" would break two commands and regress two more.

### A. Instantiated deployment — KEEP PROJECT, never sync

| File | Difference |
|---|---|
| `commands/run-execution.md` | Canonical holds the literal `{{RESEARCH_AREA_PHRASE}}`; project holds the instantiated value ("Finnish and Nordic industrial, technology, and specialist-services sectors…"). |

**Ruling: keep the project copy permanently.** Taking canonical re-introduces an uninstantiated template placeholder into a live Stage-2 command. This file will show as "differing" forever and that is correct. **Do not sync it in any worktree, ever.**

> This is a defect in the *detector*, not the file: `/sync-workflow` has no way to distinguish an instantiated placeholder from stale content. Any file containing `{{…}}` in canonical should be auto-classified as instantiated-deployment and excluded from the update list.

### B. Project is AHEAD — KEEP PROJECT, and back-port to canonical

| File | Difference |
|---|---|
| `commands/create-context-pack.md` | Project writes to `/execution/context-packs/{section}/{section}-context-pack.md`; canonical writes flat to `{section}-context-pack.md`. |
| `commands/review-chapter.md` | Project resolves `/report/chapters/{section}/{section}-chapter-NN.md` and `report/checkpoints/{section}/…`; canonical uses flat, unscoped paths. |

**Ruling: keep the project copies, and back-port both to canonical.** These carry the **one-unit-per-worktree** architecture — `{section}` as a research-unit slug with a per-unit subfolder. Canonical predates parallelisation and still assumes the pilot's flat single-unit layout. Taking canonical would regress every unit into writing over a sibling's paths.

**This is the higher-value half of this whole exercise.** Canonical is behind the deployed reality on the repo's own current architecture, and every new unit deployed from it starts wrong.

### C. Project is STALE — TAKE CANONICAL

| File | Difference |
|---|---|
| `commands/run-sufficiency.md` | Project: "…gated by `/risk-check`". Canonical: "…in review". |
| `commands/run-synthesis.md` | Same one-line substitution. |
| `commands/consult.md` | Canonical adds **Step 3.6 — pre-dispatch premise verification**, adds the premise-check evidence-citation line, and rewrites the `/risk-check` note to record the retirement. Project lacks all three. |

**Ruling: take canonical in all three.** `/risk-check` was **retired 2026-07-30**; canonical reflects it and the project copies do not. Two of the three are Stage-3 commands, which is exactly why the Stage 2 → Stage 3 boundary is the right moment.

> Note: `.claude/commands/risk-check.md` is still present locally (untracked) in this worktree despite the retirement. Removing it is a separate decision — leaving a retired command invocable is its own small trap.

### D. Both sides wrong — HOLD, do not sync either way

| File | Difference |
|---|---|
| `commands/produce-prose-draft.md` | Canonical: "Launch a **qc-gate** sub-agent." Project: "Launch a **qc-reviewer** sub-agent." |
| `commands/produce-formatting.md` | Same substitution in two places. |

**Neither is correct.**
- `qc-reviewer` (project) **does not exist** as an agent. The only matches anywhere are `ai-resources/.codex/agents/qc-reviewer.toml` and two archived copies under `audits/working/`. The command cannot resolve it.
- `qc-gate` (canonical) exists but is `tools: Read` — it **cannot write the report file** these steps instruct it to write. This is the defect already logged pending in `logs/improvement-log.md` ("`/run-execution` Step 2.4 instructs: delegate to qc-gate agent…").

**Ruling: HOLD both until the qc-gate defect is resolved.** If a unit reaches Stage 5 before then, take canonical as the interim — an agent that resolves and then fails on Write is recoverable; an agent that does not resolve at all is not. **Both are Stage 5, so nothing is blocked by holding.**

---

## Findings outside the eight

### 1. `/sync-workflow` cannot see `reference/` — and that is where the known defect lives

Step 2 builds its inventory from `.claude/commands`, `.claude/agents`, `.claude/hooks` and `logs/scripts` only. A direct comparison outside that scope shows **six differing `reference/` files**: `quality-standards.md`, `stage-instructions.md`, `file-conventions.md`, `style-guide.md`, `claim-permission.template.md`, `stage-5-paths.template.md`.

`reference/source-class-hierarchy.md` — the deployment defect logged separately the same day, where every unit carries the precision-components pilot's question numbers — **is invisible to this command**. A project can be reported fully in sync while carrying a reference-file defect that mis-maps nearly every scarce component at Step 2.4.

**Proposal.** Add `reference/*.md` to Step 2's inventory, with the Category-A/B/C heuristic extended: a `.template.md` in canonical whose deployed counterpart differs is instantiated-deployment (Category A-equivalent), not drift.

### 2. 77 of 80 skill symlinks are broken — real, but not a Stage-3 blocker

`reference/skills/` holds 80 entries. **77 point at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/…`** — a different user account *and* a different workspace folder name (`Claude Code`, not `Axcion Claude Code`). Same root cause as the `wrap-session.md` Step 6.6 hardcoded-path entry already in the improvement log.

**Severity is lower than it first looks, and the reason matters.** The pipeline commands do **not** resolve skills through `reference/skills/`. `run-cluster.md` line 13 reads: *"read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md`"* — an absolute path that bypasses the symlinks entirely. So Stage 3 is **not** blocked.

Three commands **do** reference `reference/skills/`: `audit-structure.md`, `audit-repo.md`, `produce-knowledge-file.md`. Those are the ones that will misbehave.

**The fix pattern already exists in-tree.** `repo-health-analyzer` is a working symlink with a *relative* target (`../../../../../ai-resources/skills/repo-health-analyzer`) — the shape landed by commit `bf8a71d`, "Repair broken symlinks to relative worktree-depth targets". Two others (`knowledge-file-producer`, `report-compliance-qc`) are real directories rather than links. Re-point the remaining 77 to relative targets; `/fix-symlinks` exists for this.

### 3. Work Loop ownership prerequisite — both PRESENT ✓

`logs/scripts/work-loop-owner.sh` present and executable; `.gitignore:11` carries the live `logs/work-loop/.owner` rule (confirmed via `git check-ignore -v`). No action.

### 4. No `workflow:` / `template:` declaration in project `CLAUDE.md`

Every `/sync-workflow` run in every unit falls through to the Step 1.3 default. Add an explicit declaration to the project `CLAUDE.md` template so the assumption is recorded rather than re-made eleven times.

---

## Application procedure — per worktree, at its own Stage 2 → Stage 3 boundary

Do **not** apply while a Stage-2 session is live in that worktree: `run-execution.md` is in the differing set, and changing a command under a session running it is the one avoidable risk here.

1. Confirm the unit has exited Stage 2.
2. **Take canonical** for `run-sufficiency.md`, `run-synthesis.md`, `consult.md`.
3. **Keep project** for `run-execution.md`, `create-context-pack.md`, `review-chapter.md` — take no action at all.
4. **Hold** `produce-prose-draft.md`, `produce-formatting.md`.
5. Re-point broken `reference/skills/` symlinks to relative targets (`/fix-symlinks`), or defer — not Stage-3 blocking.
6. Commit per worktree. Do not merge the ruling itself into unit branches.

**Owed centrally, once, not per worktree:** the two back-ports in section B; the `reference/` inventory gap in finding 1; the `qc-gate` resolution in section D; the `CLAUDE.md` template declaration in finding 4.
