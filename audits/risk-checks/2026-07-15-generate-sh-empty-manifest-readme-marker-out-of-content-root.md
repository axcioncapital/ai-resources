# Risk Check — 2026-07-15

## Change

Proposed change (axcion-website, item 1 of an auto-mode bundle): Fix the site-wide build blocker in apps/website/scripts/generate.sh. Currently the empty-manifest branch (lines ~193-205) writes a README marker to "$GENERATED_DIR/README.md" where GENERATED_DIR="$WEBSITE_ROOT/src/content" (line 33) — i.e. it lands at the Astro content-collection ROOT (apps/website/src/content/README.md). Astro's content scanner rejects a stray .md at the collection root ("README.md must live in a content/... collection subdirectory"), so `astro check` and `astro build` cancel site-wide. It regenerates on every run because the source-of-truth manifest is currently empty (ENTRY_COUNT -eq 0 branch). Proposed fix: relocate that empty-manifest README marker so it no longer lands at the content-collection root — the minimal variant that provably passes `astro check` (candidates, to be chosen empirically against the installed Astro version during execution: underscore-prefix the marker file so Astro's content layer ignores it; write it into a dedicated gitignored generated/ subdir; or write it outside src/content/ entirely). Constraints: MUST NOT touch the two-key content-boundary control (public_release / manifest allowed_sources / status gate); MUST NOT restructure the src/content/website-*/ collection layout or the existing .gitignore guard (line 47 checks for "apps/website/src/content/website-"); scoped to the marker-file write path only. Consumers: the Astro build (astro check/build), git/.gitignore coverage, and any concurrent website-build session that also runs generate.sh. No commits this session (concurrent-build hold).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/generate.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/src/content/ — exists (Astro content root)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/source-of-truth/manifest.yaml — exists (the two-key control the change must NOT touch)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The defect and its catastrophic consequence are both independently confirmed by direct reproduction (not just plausible-sounding — actually run, with matching exit codes and stack traces), the fix is technically narrow and backwards-compatible, but the file sits at the center of a large, mostly-documentary blast radius and touches infrastructure shared by concurrently-running build sessions, so it should land with explicit sequencing care and a pinned (not "TBD") target path.

## Consumer Inventory

Search terms used: `generate.sh` (basename), `GENERATED_DIR` (the shared variable the fix touches), `apps/website/src/content/README` / the marker write site, `apps/website/src/content/website-` (the protected .gitignore guard pattern), `apps/website/src/content/generated/` (the documented-but-not-actually-used canonical output path). Grepped across the axcion-website checkout (per task instruction, this project is the designated consumer-search scope) plus a spot-check of the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| apps/website/scripts/build.sh | invokes (Step 2/3 of the build chain calls generate.sh directly; aborts the chain on generate.sh's non-zero exit) | no |
| apps/website/package.json | invokes (`"generate": "./scripts/generate.sh"` npm script entry) | no |
| .gitignore (repo root) | parses (contains the protected guard pattern `apps/website/src/content/website-*/`, checked by generate.sh:47; also already contains an unused `apps/website/src/content/generated/` entry — see Dimension 5) | no for the protected line-47 pattern (explicitly out of scope); possibly yes for a new ignore line, conditional on which relocation candidate is chosen |
| .claude/hooks/boundary-leakage-check.sh | documents (references `apps/website/src/content/generated/` as the two-key enforcement boundary; does not reference the marker file) | no |
| .codex/hooks/boundary-leakage-check.sh | documents (mirrored copy of the above hook) | no |
| apps/website/astro.config.mjs | documents (comment: "The only Astro-visible content is apps/website/src/content/generated/") | no |
| pipeline/architecture.md | documents (build-pipeline entrypoint description; canonical-output-path description) | no |
| pipeline/technical-spec-content-model-and-boundary.md | documents (extensively — canonical output path, reproducibility contract, fail-closed rule) | no |
| pipeline/implementation-spec.md | documents (verification checklist citing `apps/website/src/content/generated/`) | no |
| pipeline/technical-spec-design-system.md | documents (consumer-spec citing the generated tree as its input) | no |
| pipeline/technical-spec-lead-intake-and-reliability.md | documents (cites generated CTA/messaging paths) | no |
| pipeline/implementation-log.md | documents (historical build log entries) | no |
| CLAUDE.md (project) | documents (Boundary-Discipline Rule 1, cites generate.sh's write target) | no |
| AGENTS.md | documents (mirrored copy of the CLAUDE.md text) | no |
| source-of-truth/manifest.yaml | documents (header comment: "generate.sh checks all three conditions before writing to apps/website/src/content/generated/") | no |
| logs/improvement-log.md | documents — **two separate open entries already describe this exact defect** ("2026-07-15 — Site-wide build blocker..." wrap: S5-21e, and "...(f2c)") | no code change; recommend closing both entries when the fix lands |
| logs/session-notes.md | documents (multiple entries recording a prior session hitting this defect and manually deleting the stray file to unblock) | no |
| output/refinement/home/diagnosis-notes.md | documents (names `src/content/README.md` as the offending marker) | no |
| output/refinement/home/ticket-ledger.md | documents — open ticket **F1** tracks this exact defect ("npm run build self-breaks") | no code change; recommend closing/cross-referencing F1 |
| 3 live `astro dev` processes (confirmed via `ps aux`, PIDs 87425/84913/54259, started 12:30/2:21/2:25 PM) | co-edits (chokidar file-watchers on `apps/website/src/content/`; shared runtime state with any concurrent `generate.sh`/`build.sh` run) | no code change; timing/sequencing awareness only |

**Total: 20 consumers, 0 must-change.** The functional (invokes) blast radius is genuinely narrow (2 callers, both exit-code-only integrations, both compatible regardless of which relocation candidate is chosen). The large consumer count is driven almost entirely by documentation/log references to the same `GENERATED_DIR`/`apps/website/src/content/generated/` convention — none of which require edits for this fix, but their volume, plus the confirmed presence of concurrently-running build sessions, is exactly why Dimension 3 grades High (see below) despite 0 must-change.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No change to any always-loaded file (workspace or project CLAUDE.md) — confirmed by reading both; neither is a target of this change.
- No hook registration (SessionStart/Stop/PreToolUse/UserPromptSubmit) — the change is confined to `apps/website/scripts/generate.sh`, an on-demand build script invoked only via `npm run build`/`npm run generate`, never per-turn or per-session.
- No `@import`, no new skill, no new subagent brief.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched — this is a bash-script content edit, not a settings.json change.
- generate.sh already has unrestricted write authority within `apps/website/` (it already writes to `$GENERATED_DIR/$COLLECTION/` at line 414 today); relocating one marker-file write within that same already-writable tree introduces no new capability. Even the "write it outside src/content/ entirely" candidate stays within the already-writable `apps/website/` tree per the script's existing `mkdir -p`/`cat >` pattern (generate.sh:56, :196).

### Dimension 3: Blast Radius
**Risk:** High

- Per the Step 1.5 inventory: **20 consumers found, 0 must-change.** This exceeds the rubric's ">5 dependent callers" High trigger on raw count, even though every one of the 20 stays compatible with the fix as scoped.
- The two functional (`invokes`) callers — `apps/website/scripts/build.sh` and `apps/website/package.json`'s `"generate"` script — are both exit-code-only integrations; neither cares which of the three relocation candidates is chosen.
- The `.gitignore` guard the change must not touch (line 47, `apps/website/src/content/website-`) is explicitly protected by the change's own stated constraint — confirmed present and unchanged at generate.sh:47.
- Shared-infra-under-concurrency finding (not anticipated in detail by CHANGE_DESCRIPTION beyond a passing mention): `ps aux` confirms **3 live `astro dev` processes are running right now** (PIDs 87425, 84913, 54259, started 12:30/2:21/2:25 PM today), and `git status` shows uncommitted work from what are evidently multiple concurrent sessions (S4-972, S5-21e per `logs/runs/`, plus edits to `HeroSection.astro`, `for-investors.astro`, `for-sell-side.astro`). This corroborates the change description's own "concurrent-build hold" framing — it is not a hypothetical concern, it is the observed current state of this repo.
- `logs/improvement-log.md` and `output/refinement/home/ticket-ledger.md` already carry duplicate open findings for this exact defect (two separate improvement-log entries, plus ticket F1) — landing this fix without closing them leaves stale duplicate tracking.

### Dimension 4: Reversibility
**Risk:** Low

- `apps/website/scripts/generate.sh` is currently clean/unmodified in git (not listed in the pre-session `git status` diff) — this is a fresh edit to a tracked file; a straight `git revert`/`git checkout` fully restores prior behavior.
- No sibling files are created by the fix itself (the regenerated marker file, wherever it lands, is build-time-only output — gitignored or newly ignored, never committed).
- No data/log file mutation is inherent to the fix (closing the two `improvement-log.md` entries is a recommended follow-up, not a revert-blocking side effect — reverting generate.sh does not require reverting those log entries).
- No state propagates beyond git (no push, no external API write) — the task explicitly holds all commits this session.
- One minor candidate-dependent nuance: if the chosen relocation target needs a new `.gitignore` line, that is a second small, cleanly revertible file change.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Shared-variable coupling, confirmed at generate.sh:33/196/414.** `GENERATED_DIR` is used for both the marker write (line 196, the target of this fix) and every real collection's output directory (`OUTPUT_DIR="$GENERATED_DIR/$COLLECTION"`, line 414). A correct fix must special-case only the marker's write site without perturbing the `GENERATED_DIR`-derived path used for collection output — the change description is aware of this (it explicitly cites line 414 in its own "Relevant code context"), so this coupling is *documented at the change site*, which is why it grades Medium rather than High.
- **Pre-existing, unresolved code/spec mismatch (not caused by this fix, but adjacent to it and left untouched).** generate.sh's own header (line 7: "Writes typed tree into apps/website/src/content/generated/") and at least six other authoritative sources — `apps/website/astro.config.mjs:32`, `CLAUDE.md`/`AGENTS.md` (Boundary-Discipline Rule 1), `source-of-truth/manifest.yaml:9`, and four `pipeline/*.md` specs — all describe the canonical output tree as `apps/website/src/content/generated/`. The actual `GENERATED_DIR` (line 33) is `$WEBSITE_ROOT/src/content` — no `/generated` suffix — so today's real collection output lands at `src/content/website-homepage/`, not the documented `src/content/generated/website-homepage/`. The proposed fix explicitly does not resolve this (its own constraint: "MUST NOT restructure the src/content/website-*/ collection layout"), so after landing, the marker-only fix should not be read as having closed this broader mismatch — worth one explicit line in the commit/PR note so a future reader does not conflate the two.
- **Undecided contract at review time.** The exact relocation target is deferred to "chosen empirically... during execution" rather than pinned now — three named candidates, no committed choice. This is explicitly named (not silently hidden), which again keeps this at Medium rather than High, but the chosen candidate should be written into generate.sh's comment once picked (see Mitigations).
- No functional overlap found — no other mechanism in the repo currently tries to handle a stray content-root file.

### Dimension 6: Principle Alignment
**Risk:** Low

- Grounded against `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` (read; present).
- **OP-9/AP-7/DR-7 (speculative abstraction):** Not applicable — this is a targeted remediation of already-in-use, already-load-bearing infrastructure (generate.sh is invoked on every build), not a hook or generalization built for an absent future consumer. No new component is created.
- **DR-8 (structural changes in gated classes require `/risk-check`):** This is exactly why this change is being risk-checked — generate.sh is the mechanical enforcement point named in the project CLAUDE.md's Boundary-Discipline Rule ("the single most load-bearing property of this project"). Routing it through this gate is the correct mechanism, not a bypass of one.
- **OP-2 (automate execution, gate judgment):** The fix itself is mechanical/low-judgment (a path relocation within an existing script), appropriate for autonomous execution once the target path is pinned; it does not silently automate a judgment call.
- **Two-key control preserved:** The change description explicitly excludes `public_release`/`allowed_sources`/`status` gate logic and the existing `.gitignore` guard check from scope — confirmed both are untouched by the fix as described, and I independently re-read `source-of-truth/manifest.yaml` and generate.sh's gate logic (lines 373-391) to confirm neither is implicated by a marker-path relocation.
- **OP-10/OP-12/OP-5:** Not applicable — no cross-tool boundary expansion, no new detection mechanism without closure, no advisory-to-enforcement upgrade.
- One noted tension (not a violation): because this file is explicitly called out as the project's most load-bearing boundary-enforcement point, any edit to it carries elevated scrutiny purely by location — this is a Dimension 3/5 concern (already captured above), not a principle violation, since the fix explicitly carves the boundary mechanism out of scope.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Observed, at two independent levels. (1) Source-level: I independently re-read `apps/website/scripts/generate.sh` lines 33, 47, 193-207, 414 and confirmed every line number and quoted behavior in CHANGE_DESCRIPTION exactly — `GENERATED_DIR="$WEBSITE_ROOT/src/content"` (line 33), the empty-manifest branch writes `cat > "$GENERATED_DIR/README.md"` (line 196), and `source-of-truth/manifest.yaml` line 18 confirms `allowed_sources: []` (so the empty-manifest branch fires on every run, as claimed). (2) Live reproduction: I created the exact marker file generate.sh would write at `apps/website/src/content/README.md`, then ran `npx astro check` and `npx astro build` directly.
- **Consequence — traced or assumed?** Traced and reproduced, not assumed. `npx astro check` with the marker present: exit code **1** (vs. exit **0** and a clean "Result (89 files): 0 errors, 0 warnings, 31 hints" on a baseline rerun with the marker removed) — printed `[WARN] [content] README.md must live in a content/... collection subdirectory.` and then the diagnostic phase never ran at all. `npx astro build` with the marker present: exit code **1**, with an explicit fatal error — `[UnknownContentCollectionError] Unexpected error while parsing content entry IDs and slugs.` thrown from `node_modules/astro/dist/content/vite-plugin-content-virtual-mod.js:350:34`. Both commands were re-run clean immediately after removing the test file, confirming the marker file is the sole cause (A/B comparison). I additionally validated the proposed remedy direction: writing the same content to an underscore-prefixed `_README.md` (one of the three candidate fixes) produced a clean `npx astro check` exit 0, matching baseline exactly — confirmed via `node_modules/astro/dist/content/utils.js:287-292`'s `hasUnderscoreBelowContentDirectoryPath` check, which causes Astro to classify the file as `"ignored"` before it ever reaches the code path that throws. All test files were deleted immediately after each check; `git status` confirms no residual tracked-file changes from this verification.
- **Re-derivation vs. the change description:** None — all claims (line numbers, quoted error text, empty-manifest trigger condition, `.gitignore` guard behavior) re-derived and confirmed. One correction of scope, not of fact: CHANGE_DESCRIPTION says "regenerates on every run" — true of the *script's logic*, but the file was NOT actually present on disk at the start of this review (confirmed via `ls`), consistent with `logs/session-notes.md`'s record that a prior session already manually deleted it this same day after hitting the identical failure.

## Mitigations

- **Dimension 3 (High — blast radius / concurrent-session collision):** Before landing the generate.sh edit, confirm no concurrent `astro dev`/`astro build`/`generate.sh` process is mid-run (check `ps aux | grep astro` and other active sessions' `logs/session-notes.md` entries) — the fix is a self-contained, 0-must-change file edit, so the residual risk is purely one of timing collision with a concurrently-running build, not code incompatibility. After landing, close the two duplicate `logs/improvement-log.md` entries ("2026-07-15 — Site-wide build blocker..." wrap: S5-21e, and the "(f2c)" entry) and update `output/refinement/home/ticket-ledger.md` ticket F1 to reference the fix, so stale duplicate findings do not persist post-fix.
- **Dimension 5 (Medium — hidden coupling):** Pin the chosen relocation candidate explicitly rather than leaving it as an execution-time choice — update generate.sh's line-7 header comment (and add a one-line inline comment at the new write site) to state the actual chosen marker location, and note explicitly that this fix does not change `GENERATED_DIR` itself or the still-unresolved mismatch between the documented `apps/website/src/content/generated/` path (asserted in 6+ other files) and the script's real `apps/website/src/content` output root, so a future reader does not conflate "marker relocated" with "the documented output path is now correct."

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references independently re-read in `apps/website/scripts/generate.sh`, `source-of-truth/manifest.yaml`, `.gitignore`, `apps/website/src/content/config.ts`, `apps/website/astro.config.mjs`, and Astro's own installed source (`node_modules/astro@4.16.19/dist/content/types-generator.js`, `.../utils.js`, `.../core/sync/index.js`, `.../content/vite-plugin-content-virtual-mod.js`, `node_modules/@astrojs/check/dist/index.js`); live command reproduction (`npx astro check`, `npx astro build`, with and without the marker file, plus the underscore-prefix candidate) with exact exit codes and stack traces recorded above; `ps aux` process enumeration for concurrent-session verification; and grep-based consumer inventory across the axcion-website checkout. All test artifacts created during verification were deleted immediately after use; `git status` was re-checked post-verification and shows no residual changes beyond the pre-existing session state. No training-data fallback was used on fetch/read failures.
