# Project Retirement / Archive Backlog

Portfolio-hygiene queue: projects assessed (2026-07-17) as ready to move out of the
active `projects/` folder, with the prep each needs before `/archive-project` will pass.
Work through one project per run. This is a checklist, not an index — the permanent
record of completed archives is `archived-projects.md`.

Assessment basis: per-project read of CLAUDE.md + latest session notes + deliverables +
git state. `/archive-project` hard-blocks on: dirty tree, unpushed commits, and no remote
(no upstream = block). Resolve blockers first.

## Queued — RETIRE (superseded / dissolved)

- [ ] **strategic-os** — Dissolve + archive. Explicit 2026-07-07 decision (`logs/decisions.md`)
  to consolidate strategic-os + management-os into one and archive the dissolved repo;
  retire-prep commit already made (2026-07-09). `state/live/` was populated then superseded.
  Prep: remove/gitignore the untracked `.backup-untracked/` dir; remote OK.
- [ ] **management-os** — Retire pair with strategic-os. **GATE: confirm survivor intent first** —
  it was the *intended survivor* of the merge yet also got a "before project retirement"
  commit. If the merged OS lives on, reclassify KEEP-ACTIVE and pull from this queue.
  Prep: tree already clean, remote OK — archive-ready once the survivor question is settled.

## Queued — ARCHIVE (shipped one-shots)

- [ ] **axcion-ai-system-redesign** — Fable-5 design window shipped complete (target arch +
  90-day roadmap + impl packets); also practically superseded by systems-builder's fresh
  `rehaul/`. Prep (all three fire): **no git remote — create one + push first**; clean dirty
  tree (untracked `.codex/`, `AGENTS.md`, two output/ files); set upstream.
- [ ] **axcion-brand-book** — Build complete (9/9 modules locked), quiet ~2 wk. Live brand-
  governance reference — archive but keep readable. Prep: commit/clean dirty tree (23 paths);
  push 3 commits; remote OK.
- [ ] **marketing-positioning** — Deliverables A + B shipped, QC GO, residuals handed to
  axcion-copy-factory. Cleanest candidate. Prep: resolve dirty tree only (M CLAUDE.md +
  ~30 untracked scratchpads); remote OK, in sync.
- [ ] **positioning-research** — Single-section report at final-v1.0, pipeline ran through the
  claim-permission gate. Prep: **no git remote — create one + push first**; clean dirty tree
  (~40 untracked `.claude/agents/*.md`).
- [ ] **research-pe-regime-shift-advisory-gap** — Thesis final shipped, delivery-readiness QC
  passed. **Caveat: confirm no further report sections are intended** (config lists only 1.1;
  a 2026-07-14 "before the next section" marker reads as protective). Prep: **no git remote —
  create one + push first**; clean dirty tree (~40 untracked agent files).

## Queued — CLEANUP (not an /archive-project job)

- [ ] **personal** — Empty directory, no files, no `.git`. Plain `rmdir` / manual removal,
  outside `/archive-project`'s reach.

## Operator-decide (not queued)

- **interpersonal-communication** — Dormant 7 wk mid-Phase-5, not shipped, not superseded.
  Too incomplete to archive, too stalled to call active. Retire only if the capability is
  deprioritized. If retired later: branch is **ahead 6 / behind 67** vs origin — reconcile
  with the remote before any archive gate would pass.

## Stale-infra flags (keep, but not "ongoing" as labelled)

Not retirement candidates — persistent infrastructure — but their activity is stale; resume or
explicitly park:
- **global-macro-analysis** — "weekly ongoing" label stale ~8 wk (KB content last changed 2026-05-21).
- **obsidian-pe-kb** — idle ~2 mo; 5 deferred setup gates (D1–D5) still open.
- **ai-development-lab** — idle ~7 wk; one converged `/develop-memo` plan awaits Approve/Revise/Reject.

## Not touched (active / infra)

Active builds: axcion-website, axcion-copy-factory, axcion-sector-intelligence,
axcion-systems-builder, axcion-design-studio, buy-side-service-plan, nordic-pe-screening-project,
corporate-identity (idle but 5/14 done, feeds live website).
Infrastructure: axcion-ai-system-owner, repo-documentation, project-planning.
