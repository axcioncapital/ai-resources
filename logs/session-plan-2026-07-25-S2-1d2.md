# Session Plan — 2026-07-25

## Intent
Fix two verified defects of mission `repo-integrity-repairs-2026-07`: symlink the 3 canonical commands root `/prime` instructs invoking into the workspace-root `.claude/commands/` (thread 11, narrowed 33 → 3), and correct the false `warn-settings-change.sh` premise in the 5 live system-owner-v2 plan files (thread 13, narrowed ~17 → 5).

## Model
sonnet — → `/model sonnet` (currently opus). The work is *doing*, not *deciding*: three symlink creations plus five targeted text corrections whose content is already determined. Advisory only; the judgment calls (which references are live plans vs. historical records) were settled before this plan was written, so no tier change is required mid-session.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-integrity-repairs-2026-07.md` — threads 11 (`:94`) and 13 (`:96`); the `## Validation contract` (`:53-76`) is the reference standard
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/` — symlink target directory; 62 existing entries establish the pattern (`../../ai-resources/.claude/commands/<name>.md`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md`, `.../session-plan.md`, `.../concurrent-session-check.md` — the three canonical link targets, all verified present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/Project Plans/system-owner-v2/` — the 5 live plan files (`context-pack.md`, `per-unit-plan.md`, `synthesis.md`, `control-pack/execution-roadmap.md`, `control-pack/technical-design.md`), all verified present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — risk-check change classes (new symlinks)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/search-canary.sh` — header records the 2026-07-18 finding that closes thread 5

## Findings / Items to Address

1. **Thread 11 — 33 canonical commands unreachable from a workspace-root session.** Anchor: mission `:94`. Verified this session by execution: 90 canonical commands vs 63 at root; `comm -23` gives exactly 33 missing. Root `prime.md` is a **symlink** to the canonical file, which references `session-start` / `session-plan` **40 times**, and neither exists at root — so a root session that runs `/prime` and picks a task walks into a missing command, silently. The workspace root **is** a live session folder: `logs/session-notes.md` there carries 19 session headers, most recent 2026-07-20.
2. **Thread 11 scope correction — link 3, not 33.** Several of the 33 are deliberately project-scoped (`explore-section.md` is Design Studio-local; `pm.md`, `archive-project.md`, `scope-project.md`, `project-next-steps.md` are project-flow commands). Blanket-linking would import project commands into the root namespace. The three that root `/prime` actually instructs — `session-start.md`, `session-plan.md`, `concurrent-session-check.md` (the last named in the brief `/prime` emits) — are the bounded fix. All three verified **absent** at root, so no file is shadowed.
3. **Thread 13 — `warn-settings-change.sh` deleted while dependents still assert it exists.** Anchor: mission `:96`. Verified: `find` returns **zero** hits workspace-wide. The deletion was **deliberate** — `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-14-repo-repair-pilot-v1.md:5` lists it as part of an approved change. So the defect is not a missing file; it is a build plan never updated when the file was removed on purpose.
4. **Thread 13 scope correction — 5 live files, not ~17.** The other ~12 references are point-in-time records: `projects/repo-documentation/` phase-1 inventories and repo snapshots, `vault/` component docs, an `_integrity-report-2026-05-01.md`, June consultation outputs, `artifacts/merged-os-context/`. Editing them would falsify the record of what was true when written. Only the system-owner-v2 files are forward-looking instructions.
5. **Thread 13's two load-bearing sites.** `control-pack/technical-design.md:34` labels the script's existence *"**Fact** [source: ground-truth pack §1.G]"*; `per-unit-plan.md:37` is row **S2.1 of an executable build order** instructing a future session to "Wire the existing-but-unwired `warn-settings-change.sh`". These two are the ones that would actively misdirect work. `context-pack.md:31`/`:43`, `synthesis.md:57`/`:87` and `control-pack/execution-roadmap.md:30` carry the same premise in supporting prose.
6. **Thread 5 — dropped, with a disposition.** Scoped as "add the `command grep` antibody to 4 audit agents"; verification showed `token-audit-auditor.md`, `diagnostics-scanner.md` and `fix-repo-issues-scanner.md` contain **zero** occurrences of `grep`, and `repo-dd-auditor.md`'s single occurrence is prose, not a scan site. `logs/scripts/search-canary.sh`'s header records the same 2026-07-18 measurement and its deliberate conclusion: *"no site edits were made: editing immune sites would be churn with no consequence."* Disposition: close thread 5 as already-correctly-decided. No edits.

## Execution Sequence

1. **Plan-time `/risk-check` (thread 11 only).** New symlinks are a structural change class. Run the lightest satisfying form — the change replicates an established pattern with 62 identical siblings, creates no new behaviour, and shadows nothing. *Verify:* a verdict is recorded before any symlink is created.
2. **Create the 3 symlinks.** From the workspace-root `.claude/commands/`, using the exact relative form the existing 62 use: `../../ai-resources/.claude/commands/<name>.md`. *Verify:* `test -L` **and** `test -e` pass on all three (a symlink that exists but does not resolve is the failure mode this checks for), and `readlink` matches the sibling pattern.
3. **Re-run the reachability count.** *Verify:* root command count rises 63 → 66; `comm -23` missing-set drops 33 → 30; the 30 remaining are the deliberately project-scoped ones, not the three just linked.
4. **Correct the 2 load-bearing thread-13 sites** (`technical-design.md:34`, `per-unit-plan.md:37`). Each must state that the script was deliberately deleted on 2026-07-14 and that stage S2/B3's premise is void — not merely soften the wording. *Verify:* neither file asserts the script exists or instructs wiring it.
5. **Correct the 3 supporting sites** (`context-pack.md`, `synthesis.md`, `execution-roadmap.md`). *Verify:* per-file re-grep returns no surviving existence claim.
6. **Whole-scope re-verification by execution.** *Verify:* `command grep -rn "warn-settings-change" "projects/project-planning/Project Plans/system-owner-v2/"` returns only corrected lines; the ~12 historical records are untouched (`git status` shows no modification outside the 5).
7. **Update the mission file via `/mission`** — close thread 5 with its disposition, tick threads 11 and 13. The mission contract forbids hand-editing `## Open threads` from inside a working session, so use the sanctioned command path. *Verify:* the three threads carry their new state and a cited reason.
8. **Commit both repos separately** — `ai-resources` (session notes, plan, mission file) and the workspace root (the 3 symlinks, the 5 plan-file corrections live under `projects/`, which is in the root repo). *Verify:* each repo's commit contains only its own scope.

## Scope Alternatives

- **Min** — step 2 only: create the 3 symlinks. Closes the silent-failure path in root `/prime`; leaves the false build-plan premise live.
- **Recommended** — steps 1–8: both threads, mission updated, both repos committed. This is the mandate.
- **Max** — additionally audit whether any of the remaining 30 root-missing commands *should* be reachable at root, and sweep the ~12 historical `warn-settings-change.sh` references for a header note marking them as superseded. Deferred: the first is a genuine design question that deserves its own session, and the second risks exactly the record-falsification this plan excludes.

## Autonomy Posture
Gated

**Stop points:**
- Before step 2 — `/risk-check` verdict on the new symlinks must be recorded. On RECONSIDER or NO-GO, do not create them; thread 13 (steps 4–6) is independent and may still proceed.
- Before step 7 — if any of the 5 plan files turns out on inspection to be a historical record rather than a live plan, stop and re-scope rather than editing it.

## Risk
**Structural change class present: new symlinks** (thread 11). Run `/risk-check` after this plan is approved (plan-time gate) and again before commit (end-time gate) — though the end-time gate is skippable per the workspace rule if plan-time cleared it with mitigations applied, drift stayed bounded, and the skip is documented in the wrap note.

Thread 13 touches no structural class — it is prose correction in five project documents, with no runnable infrastructure created or rewired.

**Environment-fit check: not applicable.** Neither thread produces an executable or launcher; the symlinks are resolved by Claude Code's own command loader, not by a terminal entrypoint, so the VS Code launch baseline does not bite here.

**Blind-spot scan:** fires on this plan (new symlinks = runnable infrastructure being wired). Its distinctive question — *will this actually run and get used in the real environment?* — has a concrete answer here: the workspace root is a live session folder with 19 logged sessions, and root `/prime` is a symlink to the canonical file that references the two missing commands 40 times. The wiring is used by an existing, documented flow that currently breaks.
