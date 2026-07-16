# Risk Check — 2026-07-16

## Change

Executed change set (already implemented and tested this session, not proposed): (1) NEW script apps/website/scripts/ratify-reference.mjs — writes/verifies output/refinement/{page}/screenshots/reference/RATIFIED.json, pinning design-handoff prototype hashes; future /refine-page runs treat this as authority and STOP on hash mismatch. (2) MODIFIED apps/website/scripts/refine-capture.mjs — replaced a texture-limit-based tall-page segmentation theory (disproven by live test) with a per-shot timeout + reactive reduced-scale fallback; added a known-prototype-noise classifier for console/failed-request evidence. (3) MODIFIED .claude/commands/refine-page.md Step 1 — ratification recipe now calls the new script instead of raw shasum, and the prototype glob changed from *.dc.html to *.html (the old glob silently missed design-handoff/our-focus/Our Focus.html). (4) Wrote RATIFIED.json for all 4 pages (home, for-investors, for-sell-side, our-focus) at commit 0cfc1bc, ratified via explicit operator blanket approval. No website presentation source (apps/website/src/**) was touched. Consumers: /refine-page (this project's only command that reads RATIFIED.json), any future capture run via refine-capture.mjs. Verified via a live tamper test (modified a prototype, confirmed verify caught the drift with exit 1, restored the file byte-exact) and via re-running full 10-viewport captures on the two previously stall-affected pages (10/10 both).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/ratify-reference.mjs — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/refine-capture.mjs — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/commands/refine-page.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/refinement/home/screenshots/reference/RATIFIED.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/refinement/for-investors/screenshots/reference/RATIFIED.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/refinement/for-sell-side/screenshots/reference/RATIFIED.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/refinement/our-focus/screenshots/reference/RATIFIED.json — exists

## Verdict

GO

**Summary:** A well-evidenced, project-local, single-consumer fix — every defect claim was independently re-derived (file read, live script execution, git diff) and confirmed true, blast radius and permission surface are both minimal, and the only elevated finding is a Medium-level implicit-coupling gap in how the new guard is enforced.

## Consumer Inventory

Search terms derived from the change: `ratify-reference` (script basename + command token), `refine-capture` (script basename), `refine-page` (command name), `RATIFIED.json` (new contract/filename convention), `.dc.html` (the glob being changed), `probe.mjs` (sibling script named in the same command). Grepped across `{AI_RESOURCES}`, the workspace root, and `projects/axcion-website` (the only project touched).

- No hits for `ratify-reference`, `refine-capture`, `refine-page`, or `RATIFIED.json` anywhere outside `projects/axcion-website` — confirmed via `grep -rniI` from the workspace root and `{AI_RESOURCES}` separately from the project-scoped search. This is a fully project-local change with zero cross-project or ai-resources exposure.
- Within `projects/axcion-website`, functional (code) references to `refine-capture`/`ratify-reference` are limited to: `.claude/commands/refine-page.md`, `apps/website/scripts/ratify-reference.mjs` (self), `apps/website/scripts/refine-capture.mjs` (self), and `apps/website/scripts/probe.mjs` (one comment only, no invocation). No `package.json` script, hook, or other command references either script (`grep -n "refine-capture\|ratify-reference\|dc\.html" apps/website/package.json` → 0 hits; `find .claude -type f | xargs grep -l` → only `refine-page.md`).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/refine-page.md` | invokes (Stage 1 calls both `ratify-reference.mjs verify/write` and `refine-capture.mjs baseline/page`) | no — already co-updated in this same change set (item 3), verified via `git diff` to match the new recipe exactly |
| `apps/website/scripts/probe.mjs` | documents (one comment: "mirrors refine-capture.mjs CANONICAL") — no functional dependency on the changed glob or RATIFIED.json contract | no |
| `logs/decisions.md`, `logs/session-notes.md`, `logs/improvement-log.md`, `logs/scratchpads/2026-07-16-15-30-scratchpad.md` | documents (session narrative recording the same-day decision and defect) | no |
| `output/refinement/STALE-EVIDENCE.md`, `output/refinement/{home,for-investors,for-sell-side,our-focus}/screenshots/reference-superseded-2026-07-16/STALE.md`, `output/refinement/responsive-visual-contract-PROPOSED.md` | documents (cite RATIFIED.json as the new authority / mark prior evidence stale) | no |

**Total: 1 functional consumer found (`refine-page.md`), 0 must-change** (the one functional consumer was already updated inside this same change). 6 additional documentation-only references, all consistent with the change, none requiring further edits. No consumer outside `projects/axcion-website` exists — this is an isolated, project-local change with no ai-resources or cross-project footprint.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No workspace or project `CLAUDE.md` was touched by this change (confirmed by the change description's own file list and by the absence of `CLAUDE.md` in the consumer-inventory grep).
- `.claude/commands/refine-page.md` is an on-demand slash command (`argument-hint: <page>`, invoked explicitly), not an auto-loaded file or hook — it costs tokens only when `/refine-page` is run.
- No new hook (SessionStart/PreToolUse/Stop) was registered; `projects/axcion-website/.claude/settings.json` (read directly) shows only the pre-existing `auto-sync-shared.sh`, `check-permission-sanity.sh`, and `boundary-leakage-check.sh` hooks — unchanged by this diff.
- `refine-page.md` frontmatter (`model: opus`) is unchanged — no model-tier or subagent-brief expansion.

### Dimension 2: Permissions Surface
**Risk:** Low

- `projects/axcion-website/.claude/settings.json` (read directly) already grants `"defaultMode": "bypassPermissions"` plus `Bash(*)`, `Write`, `Edit`, `MultiEdit` at the allow level — the new script's `execSync('git rev-parse --short HEAD')` call and its `fs.writeFileSync(ratFile, …)` write are both already-authorized capability classes, not new ones.
- No `settings.json`/`settings.local.json` file was modified by this change (absent from the change description's file list; `git status --porcelain` on the project shows no settings diff).
- No new deny-rule removal, scope change (project→user), or external/cross-repo capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 2 scripts (1 new: `ratify-reference.mjs`; 1 modified: `refine-capture.mjs`) + 1 command doc (`refine-page.md`) + 4 new data files (`RATIFIED.json` × 4 pages) = 7 files.
- Per the Step 1.5 inventory: 1 functional consumer (`refine-page.md`), 0 must-change (already co-updated in this same change, confirmed via `git diff` matching the new recipe verbatim). No other command, hook, script, or `package.json` entry depends on either script.
- The new `RATIFIED.json` schema and the `*.html` glob are a **brand-new** contract (no prior `RATIFIED.json` ever existed anywhere in the repo, confirmed by git history absence and the change's own `?? ` untracked status) — there is no backward-compatibility question because there was no prior consumer of the old (non-existent) contract to break.
- The Step 1.5 inventory surfaced no unanticipated consumer beyond what `CHANGE_DESCRIPTION` itself named ("/refine-page … this project's only command") — that self-assessed claim is confirmed correct, not a gap.

### Dimension 4: Reversibility
**Risk:** Low

- All changes are file-level and uncommitted-to-unpushed at review time (`git status --porcelain` shows the new/modified files as `??`/` M`, no push has occurred — push is gated to session end per workspace `CLAUDE.md` § Push behavior). A `git revert`/`git reset` of this change's eventual commit fully restores the prior tree state within the same working tree.
- No cron, hook, or symlink was added that could fire between landing and a potential revert — `ratify-reference.mjs` only runs on explicit invocation via the `/refine-page` recipe.
- One nuance, not a cost: reverting would restore the pre-fix state (no `RATIFIED.json`, `*.dc.html` glob) — i.e., it un-fixes the defect. That is ordinary, expected revert semantics for a defect-fix, not an extra manual cleanup step.
- No external writes (no push, no PR, no Notion/API POST) are part of this change.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Duplicated classification logic across two files.** `ratify-reference.mjs`'s `roleOf()` (lines 49–54) must classify each prototype filename identically to `refine-capture.mjs`'s `discoverPrototypes()` (lines 163–185) — both match case-insensitive `"mobile"`/`"tablet"` substrings, with "neither" defaulting to desktop. The dependency is explicitly commented ("matching refine-capture.mjs discoverPrototypes() exactly," `ratify-reference.mjs:48`) but is not structurally enforced — there is no shared function; a future independent edit to either file's matching rule (e.g., a new handoff naming convention) can silently desynchronize the pinned set from the rendered set with no automated check to catch the drift.
- **The overwrite guard lives in the command's prose recipe, not in the script with the destructive capability.** `refine-capture.mjs`'s `baseline` mode (`main()`, lines 359–374) writes directly to `output/refinement/{page}/screenshots/reference/` with **no check** for an existing `RATIFIED.json` before overwriting. The protection against silently clobbering a ratified reference set exists only as a STOP instruction inside `refine-page.md` Stage 1 ("Do not run `refine-capture.mjs baseline` — it would overwrite the approved evidence"). A direct/manual invocation of `node scripts/refine-capture.mjs baseline {page}` outside the `/refine-page` recipe — the same class of action that caused the original for-investors overwrite this change is fixing — still succeeds silently, undetected until someone happens to next run `ratify-reference.mjs verify`.
- This is a documented (not silent) dependency at the change site, and it is narrower than the original defect (the primary, previously-undocumented failure mode — a full `/refine-page` run with no ratification convention at all — is now closed). It is a real residual gap, not a fabricated one, which is why it is Medium rather than Low.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` (read directly).

- **OP-11 / OP-3 (loud revision, never silent drift).** The glob correction (`*.dc.html` → `*.html`) and the discarded texture-limit theory are both recorded as explicit, rationale-bearing decisions in `logs/decisions.md` (2026-07-16, "Reference ratification, capture-tooling defect correction, and stale-evidence disposition," Decisions 1 and 3), each naming the prior (wrong) convention/theory, why it was wrong, and the alternative considered. This is the textbook correct use of OP-11 — a recorded correction, not drift.
- **OP-12 (closure before detection).** The new verify capability is detection (hash-mismatch) paired with an actual closure loop already specified in `refine-page.md` Stage 1: DRIFT → STOP → re-render → re-present → re-approve → re-`write`. The change does not ship a bare detector with no closure path.
- **DR-7 / OP-9 / AP-7 (no speculative abstraction).** `ratify-reference.mjs` is project-local, has exactly one real, already-existing consumer (`/refine-page`, confirmed by the Step 1.5 inventory), and was not generalized into `ai-resources/` or given a second hypothetical consumer. Nothing here is "hooks for later."
- **OP-2 (automate execution, gate judgment).** The mechanized part is bookkeeping (hashing, writing, verifying); the judgment (whether the captures faithfully represent the approved design) stays operator-gated — `ratify-reference.mjs write` requires `--by`/`--basis`, and the four pages were ratified "via explicit operator blanket approval" per the change description, corroborated by the `ratificationBasis` field quoting the operator directly in each `RATIFIED.json`.
- **DR-1 / DR-3 (placement).** `ratify-reference.mjs` sits alongside its sibling scripts `refine-capture.mjs`/`probe.mjs` in `apps/website/scripts/` — correct project-local placement for a project-local, single-consumer tool.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Observed, independently, for all three defects claimed:
  - *No RATIFIED.json ever existed / silent for-investors overwrite* — corroborated by `logs/decisions.md:754` ("Stage 1 read-only audit found no `RATIFIED.json` had ever existed despite four refinement reports citing 'the ratified baseline'") logged the same day, and confirmed structurally: no `RATIFIED.json` exists anywhere in git history for this project before this change (all four are currently `??` untracked).
  - ***.dc.html glob misses Our Focus's desktop prototype*** — directly re-derived, not inherited: `ls design-handoff/our-focus/` shows `Our Focus.html` (no `.dc` infix) alongside `Our Focus (Tablet).dc.html` and `Our Focus (mobile).dc.html`. A `*.dc.html` glob against that directory would return only 2 of the 3 files. Confirmed.
  - *Tall-page capture stall / texture-limit theory* — the original wrong diagnosis is independently readable at `logs/improvement-log.md:137` (S8-127, predicting for-sell-side and our-focus "will bite… next"); the disproof is recorded with measured numbers in `logs/decisions.md:765` (8–9k CSS px measured vs. the claimed 15–20k; a 750×16656 dsf2 shot capturing in 222ms; zoom200 capturing at 43,676px).
- **Consequence — traced or assumed?** Traced, with live reproduction, not merely asserted:
  - I ran `node scripts/ratify-reference.mjs verify {page}` myself for all four pages and got `"ratified and matching"` for each — the exact command the change claims to have verified.
  - I independently computed `shasum -a 256 "design-handoff/our-focus/Our Focus.html"` and it matches the hash recorded in `RATIFIED.json` exactly (`66613474219b63753c41501cfbcb5b155b2b44633d43d71b215d7a7db1cee7a9`).
  - I ran `git diff -- .claude/commands/refine-page.md` and confirmed the prior recipe was literally `shasum -a 256 design-handoff/{page}/*.dc.html | sort` — matching the change description's claim about what was replaced, word for word.
  - I read `output/refinement/{for-investors,for-sell-side}/screenshots/audit-2026-07-16/manifest.json` directly and confirmed `capturedShots: 10, failedShots: []` for both — matching the claimed "10/10 both" re-capture result exactly.
- **Re-derivation vs. the change description:** None — all counts, paths, and quoted claims in `CHANGE_DESCRIPTION` were independently re-derived (file listing, live script execution, git diff, direct hash computation, manifest read) and confirmed true. No discrepancy found.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, live command execution, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
