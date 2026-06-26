---
mission_id: settings-path-portability
mission_name: Make committed Claude Code settings machine-portable and close the root cause
status: active
started: 2026-06-25
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create`. Frozen at creation like a /contract-check contract:
  the Goal / In-Out scope / Validation contract sections are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` are
  meant to change over the mission's life, both edited via `/mission` — never hand-edited
  from inside a working session, and never written to by /session-start.

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: settings-path-portability` mandate bullet.
-->

## Goal

Every tracked (committed) Claude Code `settings.json` across the Axcíon workspace and its submodules is machine-portable — it contains no machine-specific absolute path; machine-specific config lives only in gitignored `settings.local.json` — and the repo-scaffolding source plus a written invariant prevent any new repo from reintroducing the defect.

## In scope / Out of scope

- **In:**
  - All tracked `settings.json` in the workspace's git repos and nested submodule vaults / knowledge-bases.
  - Three defect groups found 2026-06-25:
    - **G1** — Patrik's absolute path in `additionalDirectories` of shared files (8 files; the verified `../..`-style relative fix; correct depth per repo; 2 are in submodule vaults).
    - **G2** — Daniel's absolute path leaked into shared files (reverse direction; 2 knowledge-base submodules).
    - **G3** — absolute paths baked into permission-rule globs (`Read()`/`Edit()`/`Write()`), where relative-path support is NOT yet verified (workspace-root `settings.json` — local-only, non-shared — and `ai-resources/.claude/settings.json` — shared).
  - The root-cause close: an invariant doc in `ai-resources/docs/`, and fixing whatever scaffolds new repos (the `templates/` project-settings fragment and/or `/new-project`) so clones are born portable.
- **Out:**
  - Gitignored `settings.local.json` files — the correct home for machine paths; never edited by this mission.
  - Throwaway audit copies under `ai-resources/audits/working/`.
  - Any change to project/strategic CONTENT — this mission is config hygiene only.
  - Rewriting permission allow/deny semantics beyond removing the absolute-path portability defect.

## Validation contract

> Written now, at mission creation — before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, `/qc-pass`) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete:
- [ ] A workspace-wide grep for `/Users/<name>/` absolute paths in tracked `settings.json` returns zero hits, excluding `audits/working/` and gitignored `settings.local.json`.
- [ ] Each fixed path uses a machine-portable form (relative `additionalDirectories`, or `/`/`//`-anchored permission globs) that is **portable-by-construction** — its form resolves identically wherever the repo sits in an Axcíon workspace — and is confirmed to resolve on Daniel's machine. Direct testing on Patrik's machine is NOT required; portability is established by the path form, not by per-machine testing.
- [ ] Group 3's fix approach is verified before any Group 3 file is edited — relative-path support for permission globs is either confirmed, or a documented portable alternative is chosen.
- [ ] An invariant is written in `ai-resources/docs/`: committed `settings.json` must never contain machine-specific absolute paths; per-machine config lives only in gitignored `settings.local.json`.
- [ ] The repo-scaffolding source (`templates/` settings fragment and/or `/new-project`) emits portable settings, so a freshly scaffolded repo has no absolute path.

**Non-negotiables** — boundaries no session may cross, even if locally convenient:
- Never edit a gitignored `settings.local.json` as part of this mission.
- Never touch project/strategic content — config files only.
- Run `/risk-check` before the first batch of settings edits (permissions-surface structural change).
- All pushes to shared remotes are operator-gated; Patrik gets a heads-up before any shared-repo or submodule push lands in his history.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):
- Editing anything other than tracked settings files, the invariant doc, and the scaffold source.
- Rewriting permission allow/deny rules beyond the absolute-path fix.
- Pushing to a shared remote without operator approval.
- Mass-committing across all repos in one session, bypassing the staged verify-first sequence.

## Open threads

> Resume pointer (2026-06-26): APPROACH PIVOT. The relative-and-tracked plan was rejected — `/risk-check` returned RECONSIDER and the System Owner concurred (strengthened to primary). Both flagged that (a) relative-and-tracked contradicts the canonical `permission-template.md` decision (grant must be REMOVED from tracked files, not made relative), (b) the relative form's resolution in the VS Code launch context is unconfirmed and can silently break cross-repo visibility, and (c) fixing leaf files without fixing the `/new-project` generator is AP-9 (symptom, not root cause). **Operator chose the canonical fix on 2026-06-26.** Evidence: `ai-resources/audits/risk-checks/2026-06-26-settings-additionaldirectories-relative-path-portability.md` + `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-26-settings-additionaldirectories-portability.md`. The Goal (above) already specifies this approach — only these Open threads had drifted toward relative paths; corrected below.

- [x] **Verify whether permission-rule globs accept relative paths.** DONE 2026-06-25; **the relative-`additionalDirectories` finding here is SUPERSEDED 2026-06-26** (relative-and-tracked rejected — see resume pointer). The glob-form facts remain valid for the Group 3 decision: `//path` = absolute, `~/path` = home, `/path` = project-root-relative, `path` = cwd-relative. The existing Group 3 entries use a single leading slash, are read as project-root-relative, **match nothing (inert) on either machine**, and under `bypassPermissions` are redundant → Group 3 remains a delete-or-rewrite decision.
- [x] **Re-run `/risk-check` on the canonical plan** (REMOVE + generator fix) → **PROCEED-WITH-CAUTION**, 2026-06-26 (`ai-resources/audits/risk-checks/2026-06-26-settings-additionaldirectories-removal-canonical-plus-generator-fix.md`). Empirical correction: the 4 vault/KB dirs are NOT submodules on Daniel's checkout (`git submodule status` empty) — each is tracked by its parent project repo, so NO pointer bumps; `axcion-ai-system-owner` and `repo-documentation` commit project + vault together.
- [x] **Remove `additionalDirectories` from the 11 tracked `settings.json` files** (7 project-level + 2 vault + 2 KB). DONE 2026-06-26 — all 11 parse valid, zero `/Users/` paths remain. Committed per-repo (see session notes). The grant, where a machine needs it, now lives only in gitignored `settings.local.json` — recovery snippet at `ai-resources/docs/settings-local-recovery.md`.
- [ ] Decide Group 3 disposition with Patrik: delete the two inert `Edit()`/`Write()` lines in `ai-resources/.claude/settings.json` (lean) vs rewrite to a real `//**` grant; same call for the workspace-root `settings.json` (local-only, non-shared). Blocked on Patrik's intent for the two lines.
- [x] **Fix the `/new-project` generator.** DONE 2026-06-26 — Step 3 now writes the `additionalDirectories` grant to the gitignored `settings.local.json`, never the tracked `settings.json`; Step 2 note + final-report line updated. `templates/project-settings.json.template` already carried no `additionalDirectories` (no edit needed).
- [ ] **TWO MORE GENERATORS re-introduce the defect (found by risk-check 2026-06-26 — partial close-out):** (a) `/permission-sweep` **Rule 8** still ADDS `additionalDirectories` to the tracked `settings.json` (line ~211) and audits for its absence — needs a semantic redesign (drop the rule, or redirect the grant to `settings.local.json` and flip Rule 8 to flag a *tracked* `additionalDirectories` as the defect); (b) `/deploy-workflow` (lines ~207–229) writes it unconditionally to the tracked file — same redirect as `/new-project`. Each is its own `/risk-check` (canonical command edit). Until both are fixed, the root-cause close is **partial**.
- [x] **Write the per-machine recovery snippet.** DONE 2026-06-26 — `ai-resources/docs/settings-local-recovery.md` (how a machine re-adds the workspace-root grant to its gitignored `settings.local.json`).
- [ ] Write the invariant doc in `ai-resources/docs/`: committed `settings.json` must never contain machine-specific absolute paths; per-machine config lives only in gitignored `settings.local.json`. (The recovery doc above is adjacent but narrower — the invariant is a standalone rule + `/permission-sweep` reference.)
- [x] **Draft the Patrik heads-up.** DONE 2026-06-25 — saved to `ai-resources/logs/missions/settings-path-portability/patrik-heads-up.md` (status DRAFT).
- [ ] Send the Patrik heads-up; get his read on the two inert lines (feeds the Group 3 thread above).
- [ ] Obtain operator approval for each shared-remote push (per the non-negotiables).
