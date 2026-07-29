# Risk Check — 2026-07-16

## Change

Page-parameterized the project-local Design Studio screenshot renderer `apps/website/scripts/refine-capture.mjs` and relaxed the `/refine-page` command's Stage 0 capability gate. The renderer previously hardcoded `home` (handoffDir, outRoot, and a fixed PROTOTYPES list of `Home Page*.dc.html`). It now requires a `<page>` slug in both modes (`baseline <page>` / `page <page> <url> <set>`), derives `handoffDir=design-handoff/<page>/` and `outRoot=output/refinement/<page>/screenshots/` from it, and discovers prototype `.html` files from the handoff folder by filename (desktop/tablet/mobile classification). `<page>` is required with no default (no silent home fallback); a slug-validation guard (`/^[a-z0-9][a-z0-9-]*$/i`) rejects path traversal. The `.claude/commands/refine-page.md` Stage 0 gate changed from an unconditional home-only hard-stop to a real capability check (the `design-handoff/{page}/` folder + at least one prototype `.html` must exist). Verified this session: arg guards (missing arg / bad slug `../home` / missing dir) exit 2/2/1 correctly; a real `baseline for-investors` capture rendered the for-investors prototypes to `output/refinement/for-investors/` with the manifest tagging `"page": "for-investors"`; home path derivation unchanged (`baseline home` → same handoffDir/outRoot as the old hardcoded version, so the immutable ratified home reference is unaffected — and I did NOT run `baseline home`). Only consumer is the `/refine-page` command (project-local Design Studio). Not production site code; not imported by the built website. Change is additive + trivially reversible (git revert). Not yet committed.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/refine-capture.mjs — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/commands/refine-page.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/probe.mjs — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-scoped, thoroughly self-verified capability build (all "verified this session" claims independently re-derived and confirmed) whose residual risk is two Medium findings — orphaned generated output on a hypothetical revert, and an implicit reliance on external design-handoff filename conventions — neither of which is a High and both of which have concrete mitigations.

## Consumer Inventory

Search terms used: `refine-capture` (script basename), `refine-capture.mjs` (full filename), `refine-page` (command name/token), `refine-capture.mjs baseline` (old no-arg call-site pattern). Grepped `apps/website/scripts/`, `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `.agents/`, `.codex/`, `AGENTS.md`, `apps/website/package.json`, `logs/`, `output/`, `design-handoff/` inside `projects/axcion-website`, plus the full workspace root and `ai-resources/` (excluding `axcion-website` itself) for cross-repo hits.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/refine-page.md` | invokes | yes — already co-edited within this same change (Stage 0 gate text + both `refine-capture.mjs` invocation lines updated to the new `<page>`-first signature) |
| `apps/website/scripts/probe.mjs` | documents (comment: "mirrors refine-capture.mjs CANONICAL") | no — no invocation, unaffected by the signature change |
| `output/refinement/home/ticket-ledger.md` | documents (historical finding record) | no |
| `output/refinement/home/refinement-report.md` | documents (historical write-up) | no |
| `output/refinement/home/freeze-record.md` | documents (mentions `/refine-page`) | no |
| `output/refinement/for-sell-side/refinement-report.md` | documents (narrates the old home-only renderer + the mid-pass parameterization by a parallel session) | no |
| `logs/session-notes.md` | documents (S7-d29, S8-127 session entries) | no |
| `logs/decisions.md` | documents (S6-862, S7-d29 decision entries) | no |
| `logs/innovation-registry.md` | documents (`/refine-page` registry row) | no |

**Total: 9 consumers, 1 must-change (already resolved within this same change).** No hits in `apps/website/package.json`, any CI/workflow YAML, `.claude/hooks/`, `.claude/agents/`, `.agents/`, `.codex/`, `AGENTS.md`, or anywhere in the workspace root / `ai-resources/` outside `projects/axcion-website` — confirming the change description's "only consumer is `/refine-page`" claim rather than merely inheriting it. No stale no-arg (`baseline` with no page, or `page <url> <set>` with no page) call sites survive anywhere in the tracked or untracked repo tree; every remaining doc reference already uses the `{page}`-first form.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file touched — `refine-page.md` is a project-local slash command invoked on demand, not auto-loaded (confirmed: no reference to it in either CLAUDE.md read in Step 1).
- No hook registered or modified — `grep -rniI "refine-capture\|refine-page" .claude/hooks/` returned zero hits.
- No skill added, no `@import` chain introduced, no subagent brief expanded — the change is confined to a CLI script's argument parsing/path derivation and the corresponding command doc's prose.
- Pay-as-used: the renderer only runs when an operator explicitly invokes `/refine-page <page>` or the underlying `node scripts/refine-capture.mjs` command.

### Dimension 2: Permissions Surface
**Risk:** Low

- `apps/website/.claude/settings.json` was not touched by this change (confirmed by reading the file: `git status --porcelain` shows only the two source files as modified).
- The project already runs `defaultMode: bypassPermissions` with `Bash(*)` and unscoped `Write`/`Edit` in `allow` — the new per-page output directories (`output/refinement/<page>/screenshots/`) fall inside an already-unrestricted Write footprint; no new capability class (shell, cross-repo write, external API, MCP) is introduced.
- No `deny` rule removed or narrowed.

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: 9 total consumers, 1 `invokes` (`refine-page.md`), 8 `documents`-only (historical logs/reports that narrate the old vs. new behavior but do not execute against it).
- The one `invokes` consumer required modification to keep working (the CLI argv signature changed: `baseline` → `baseline <page>`; `page <url> <set>` → `page <page> <url> <set>`), and it was already updated within this same bundled change — verified via `git diff` showing both `refine-page.md` invocation lines (`refine-capture.mjs baseline {page}`, `refine-capture.mjs page {page} <url> <set>`) already reflect the new signature.
- Exhaustive grep (project root, workspace root, `ai-resources/`, `.agents/`, `.codex/`, `AGENTS.md`) found zero additional live callers — the CLI contract change has a synchronized single caller, not an orphaned one.
- Shared build-state concern (the pre-existing Stage-0 mitigation for `generate.sh`/`astro build` touching `src/content/`) is unaffected — this change does not touch `generate.sh` or the Astro build pipeline (`grep -n "refine" apps/website/scripts/generate.sh` returned zero hits).

### Dimension 4: Reversibility
**Risk:** Medium

- The two source-file edits are uncommitted working-tree changes (`git status --porcelain` shows `M` on both) — a plain `git checkout --` or, post-commit, a `git revert`, fully restores the prior code.
- However, running the new code this session already produced a new, untracked artifact tree: `output/refinement/for-investors/screenshots/reference/{7 PNGs, manifest.json}` (confirmed via `find`; `manifest.json` confirmed to contain `"page": "for-investors"`, mtimes dated today). Reverting the two source files would not remove this generated output — it is a sibling directory tree, not a diff hunk, and git revert does not touch it.
- This matches the canonical Medium case: "revert works but requires one extra cleanup step (delete a generated artifact)." In this instance the artifact is also the session's intended deliverable (`logs/session-notes.md:1316` lists `output/refinement/for-investors/` as a required output), so in the *expected* path it gets committed, not deleted — but if the renderer change itself is judged wrong and rolled back, the already-rendered for-investors captures become stale/orphaned output requiring a manual `rm -rf` rather than being cleaned up by git alone.
- No push, no external-system write, no cron/hook automation added — the propagation is confined to the local working tree.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- `discoverPrototypes()` introduces an implicit but documented convention: any `.html` file whose lowercased name contains the substring `mobile` is classified mobile, `tablet` is classified tablet, and anything else is classified desktop. This is an assumption about the *external* Claude-Design-handoff export's naming discipline (a process this codebase does not control), generalized from the single working `home` case to four different vendor-exported filename sets (`For Investors (Tablet).dc.html`, `Our Focus (mobile).dc.html`, `Our Focus.html`, etc.).
- It is documented at the change site — both in the script's own comment block (`refine-capture.mjs:90-94`) and in `refine-page.md § Page support` ("One assumption: exactly one non-tablet/mobile `.html` per handoff folder... the renderer warns loudly if it sees more than one") — and it has a partial safeguard (`desktopCount > 1` triggers a loud `WARNING`, verified present in the code at `refine-capture.mjs:113-115`).
- The safeguard is one-sided: a file that coincidentally contains "tablet" or "mobile" as a substring while being desktop-intended (or a tablet/mobile file whose name happens not to contain those substrings) would silently misclassify with no warning — the loud-failure path only catches the "too many desktop files" case, not a wrong-bucket classification.
- The new `"page"` key added to `manifest.json`'s top-level shape is an additive, backwards-compatible field (verified: `refine-page.md` Stage 1.3 only reads `consoleErrors`/`failed` counts from the manifest, not the top-level `page`/`set` keys) — this specific addition is not a coupling risk.
- No functional overlap with an existing mechanism, no unexpected auto-firing — the renderer only runs when explicitly invoked.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read directly; present and used as primary source).

- **DR-7 / OP-9 / AP-7 (generalize only on a second confirmed consumer / no speculative abstraction).** This is the central check for a parameterization change, and it is satisfied rather than violated: the change was not built ahead of demand. A second consumer already exists and was exercised for real this session — `baseline for-investors` actually ran and produced verified output (`output/refinement/for-investors/screenshots/reference/manifest.json`, `"page": "for-investors"`). A third and fourth consumer (`for-sell-side`, `our-focus`) already have approved `design-handoff/` folders on disk (confirmed via `ls design-handoff/`) and `for-sell-side/refinement-report.md` explicitly names the home-only renderer as the thing that blocked it. This is completing declared, already-waiting demand, not speculative infrastructure for an absent Phase-2 consumer.
- **OP-5 (advisory vs. enforcement).** The Stage 0 gate change is not an advisory→enforcement upgrade. It replaces a blanket `page !== 'home'` hard-stop with a more precise hard-stop gated on an actual filesystem check (`design-handoff/{page}/` + at least one prototype `.html`) — still a hard-stop, just a more accurate one. No enforcement authority was newly granted.
- **OP-2 (automate execution, gate judgment).** No judgment call was automated — the Tier-C visual-direction gate (Stage 6, operator sign-off) is untouched by this change; only the pre-flight capability check's logic changed.
- **OP-11 / OP-3 (loud revision).** No principle is being revised here, so the loud-revision requirement does not apply; nothing to flag.
- **DR-1 / DR-3 (placement).** Not implicated — this edits two already-existing, already-correctly-placed project-local files (a project script, a project-local command), not a new-resource placement decision.
- **DR-8 (structural changes in gated classes require `/risk-check`).** This change (a project-local command's capability gate + its backing script) is exactly the class DR-8 requires a risk-check for — this review's existence is compliance with, not tension against, that rule.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Not applicable in the classic sense — this is not a defect-fix claim to begin with. The "renderer previously hardcoded `home`" framing describes a known, previously-scoped, deliberately-deferred limitation, not a hidden or newly-discovered bug: `logs/decisions.md` (S7-d29, 2026-07-15) records "Renderer page-parameterization... DECLINED as a backlog entry per operator ('we have done enough'); not lost — documented... as the named prerequisite / next gated work unit," and `logs/session-notes.md:1312` (S8-127 mandate, read directly) states the mandate in the operator's own words: "page-parameterize refine-capture.mjs so /refine-page works on non-home pages... done when: refine-capture.mjs takes a `<page>` argument and `/risk-check` has cleared the edit." This is an operator-directed capability build against a previously-documented, consciously-deferred gap — not an inferred or asserted defect.
- **Consequence — traced or assumed?** N/A — no defect consequence is being claimed or needs tracing.
- **Re-derivation vs. the change description:** None — all claims re-derived and confirmed. Specifically re-run/re-checked independently: (1) `node scripts/refine-capture.mjs baseline` with no page → exit 2, matching claim; (2) `node scripts/refine-capture.mjs baseline "../home"` → exit 2, matching claim; (3) `node scripts/refine-capture.mjs baseline nonexistent-page-xyz` → exit 1, matching claim; (4) `output/refinement/for-investors/screenshots/reference/manifest.json` read directly — contains `"page": "for-investors"`, 7 `capturedShots`, sourced from the three `For Investors*.dc.html` files, matching the claim; (5) `output/refinement/home/screenshots/reference/` file mtimes are all dated 2026-07-15, none today — confirming `baseline home` was not re-run this session, matching the claim; (6) the regex `/^[a-z0-9][a-z0-9-]*$/i` is present verbatim in the code, matching the claim; (7) cross-repo/workspace grep confirmed "only consumer is `/refine-page`" — no hits anywhere else.
- **Not defect-justified — no premise to verify.** This is a capability addition executed against an explicit, logged operator mandate (`logs/session-notes.md:1312`), not a claim that something is currently broken, missing-as-a-surprise, unwired, stale, failing, or inconsistent. Risk: Low.

## Mitigations

- **Reversibility (Medium):** Before or immediately after landing this change, note in `logs/session-notes.md` / `logs/decisions.md` that `output/refinement/for-investors/` is a new generated artifact tied to this specific renderer change and is currently untracked. If the renderer parameterization is later judged wrong and reverted, explicitly `rm -rf output/refinement/for-investors/` (or archive it) as a manual follow-up step — it will not be removed by `git revert`/`git checkout --` of the two source files alone.
- **Hidden Coupling (Medium):** Keep the `discoverPrototypes()` filename-classification assumption under a human glance rather than full trust: when running `/refine-page` Stage 0 on a page for the first time, print or eyeball the discovered file list (which files were classified desktop/tablet/mobile) before proceeding — the existing `desktopCount > 1` warning only catches the "too many desktop" failure mode, not a wrong-bucket misclassification (e.g., a stray file with "tablet"/"mobile" in its name that isn't actually that breakpoint). This costs one extra visual check per new page onboarded and closes the one-sided gap in the current safeguard.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
