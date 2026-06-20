# Risk Check — 2026-06-20

## Change

Change set: the 8 QC-PENDING triage files from session S2, now QC-cleared (verdict GO). The change-class edits are: (1) .claude/skills/website-content-source/SKILL.md — new "Authority conflict resolution" section (two-axis model), hardened freshness discipline, claim-vs-wording distinction; (2) .claude/commands/website-source-scan.md — added Last seen commit stamp in step 4; (3) .claude/commands/website-source-pack.md — added live freshness check in step 1 (live git query vs recorded Last seen commit). Plus 5 advisory/data/spec files with no runtime change. This is a skill + two command edit. The three runtime-contract files change how /website-source-scan and /website-source-pack behave when next run.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/skills/website-content-source/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/commands/website-source-scan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/commands/website-source-pack.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/content-source/source-inventory.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/content-source/scan-scope.yaml — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/build-specs/2026-06-19-page-content-drafting-command-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/build-specs/2026-06-20-page-visual-direction-command-spec-v2.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/process-overview/2026-06-20-content-to-design-process-report.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A self-contained hardening of three runtime-contract files whose public verdict contract is preserved and whose only new behaviour (a `git log -1` live freshness query) is already permitted — the one elevated risk is an undisclosed stale mirror (`.agents/skills/website-content-source/SKILL.md`) that drifts on this edit and must be re-synced before landing.

## Consumer Inventory

Search terms: `website-source-scan`, `website-source-pack`, `website-content-source`, `Last seen commit`, `draft-page-content`, `page-source-pack`. Searched `projects/axcion-website/**` and `ai-resources/**` from workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-website/.claude/commands/website-source-scan.md | co-edits (sister command; writes the `Last seen commit` anchor the pack reads) | yes (in scope) |
| projects/axcion-website/.claude/commands/website-source-pack.md | co-edits / invokes the skill; consumes the `Last seen commit` anchor | yes (in scope) |
| projects/axcion-website/.claude/skills/website-content-source/SKILL.md | parses (the governing skill all three files cite) | yes (in scope) |
| projects/axcion-website/.agents/skills/website-content-source/SKILL.md | imports (real-file Codex/AGENTS mirror of the skill; **not** a symlink) | yes — currently DIFFERS from `.claude/` copy (drift) |
| projects/axcion-website/.claude/shared-manifest.json | documents (lists both commands as project-local, sync-skip) | no |
| projects/axcion-website/content-source/source-inventory.md | parses (defines the `Last seen commit` field + live-freshness rule the commands honour) | no (already aligned; field present at line 30) |
| projects/axcion-website/content-source/scan-scope.yaml | invokes (both commands read repo set + `frozen_page_authority` here) | no |
| projects/axcion-website/content-source/README.md | documents (pipeline overview, freshness narrative) | no |
| projects/axcion-website/content-source/page-source-packs/README.md | documents (freshness stamp + verdict contract) | no |
| projects/axcion-website/content-source/decisions-and-overrides.md | invokes (the overrides filter both commands consult) | no |
| projects/axcion-website/output/build-specs/2026-06-20-page-visual-direction-command-spec-v2.md | parses (depends on pack verdict tokens `READY` / `READY_WITH_CANDIDATES`) | no — verdict tokens unchanged |
| projects/axcion-website/output/build-specs/2026-06-19-page-content-drafting-command-spec.md | parses (Build-2 `/draft-page-content` consumes an approved pack) | no — pack output contract unchanged |
| projects/axcion-website/output/process-overview/2026-06-20-content-to-design-process-report.md | documents (process narrative) | no |
| projects/axcion-website/logs/{decisions,session-notes,innovation-registry,session-plan,scratchpads} | documents (session/log artifacts) | no |
| ai-resources/audits/risk-checks/2026-06-20-content-source-pipeline-axcion-website.md | documents (prior risk-check of this pipeline) | no |

Total: 15+ distinct consumers; 4 must-change (3 in scope, 1 — the `.agents/` mirror — NOT named in CHANGE_DESCRIPTION and is the blast-radius surprise). The downstream verdict/pack-output contract that the two build-specs parse is **preserved** by this edit, so those consumers stay compatible.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The three edited runtime files are a skill + two commands — all pay-as-used (load only when `/website-source-scan` or `/website-source-pack` runs), not on every turn. None is imported into project or workspace CLAUDE.md.
- No hook is registered or modified. The only SessionStart hook involved is the pre-existing auto-sync hook referenced in `shared-manifest.json` (line: "auto-sync hook symlinks every other file … on session start"); this change adds nothing to it.
- The SKILL.md grows by ~3 sections (Authority conflict resolution, hardened Freshness discipline, claim-vs-wording bullet) but the skill is `model: opus` and on-demand, not auto-loaded by trigger breadth — its description trigger is narrow ("running /website-source-scan or /website-source-pack", SKILL.md lines 9–10), so no broad auto-load.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission entry is added, removed, or widened. The new behaviour in `website-source-pack.md` step 1 is a live `git -C projects/<repo> log -1 --format=%h -- <path>` query (lines 30–32). `projects/axcion-website/.claude/settings.json` line 5 already allows `Bash(*)`, so the git read is within established permissions.
- No new Write path: `website-source-pack.md` still writes only `content-source/page-source-packs/<page>.md` (line 116); `website-source-scan.md` still writes only within `content-source/` (line 92). Tier-C / `source-of-truth/` / `apps/website/src/` untouched (skill hard rule 5, SKILL.md lines 101–103).
- The git query is read-only on upstream repos — consistent with the command's existing "Read-only on upstream" guardrail (scan command line 92).

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory: 15+ consumers, 4 must-change. Three are in-scope and intended (the two commands + the skill they cite). The fourth — `projects/axcion-website/.agents/skills/website-content-source/SKILL.md` — is the blast-radius surprise: it is a **real-file copy** (12,043 bytes, not a symlink) of the skill for the Codex/AGENTS harness, and `diff` confirms it now DIFFERS from the updated `.claude/` copy. CHANGE_DESCRIPTION does not mention it. A Codex session would load the stale skill (old freshness discipline, no two-axis authority model, no claim-vs-wording rule).
- Contract surfaces the build-specs parse are preserved: the visual-direction spec parses pack verdict tokens `READY` / `READY_WITH_CANDIDATES` (v2 spec lines 150, 229) and the content-drafting spec consumes "an approved pack" — neither token nor pack output shape changes, so both stay compatible. The `Last seen commit` field the pack now reads live was already defined in `source-inventory.md` (line 30), so the inventory consumer is already aligned.
- Shared infra touched only in a self-contained way: the two commands write only inside `content-source/`; no log, hook, or always-loaded file changes behaviour.

### Dimension 4: Reversibility
**Risk:** Low

- The three runtime edits are text edits to tracked files; `git revert` restores prior content fully. No sibling files or directories are created by the change itself.
- No data/log mutation in the change-class edits: `source-inventory.md` remains the empty scaffold (line 46: "_(empty — run /website-source-scan to populate.)_"), so no inventory rows were appended that a revert would orphan. The 5 advisory/data/spec files carry no runtime contract.
- One caveat keeps this from being trivially clean: the `.agents/` mirror is **untracked** (`?? .agents/` in git status), so `git revert` of the `.claude/` edit would not touch it — but that cuts the *other* way (revert leaves the mirror as-is). No state has propagated beyond the local repo; nothing is pushed or written externally by this change.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The live freshness check creates an explicit cross-file contract: `/website-source-pack` (pack command lines 30–38) reads the `Last seen commit` anchor that `/website-source-scan` (scan command lines 59–62) writes. This contract is **documented at every site** — in the scan command (line 60 explains it is "the anchor /website-source-pack's live freshness check compares against"), in the pack command (lines 36–38 "Why live"), in the skill (Freshness discipline, SKILL.md lines 142–153), and in `source-inventory.md` (lines 30, 35–40). Documented coupling is the Medium, not High, profile.
- One genuine hidden coupling: the `.agents/` real-file mirror. Nothing in the `.claude/` change site names it, yet the Codex harness silently depends on it being kept in lockstep. An editor working only from CHANGE_DESCRIPTION would not know to re-sync it — that is an undocumented lockstep dependency.
- The live git query silently assumes each cited source's `<relative-path>` resolves under `git -C projects/<repo>` and that the upstream repo is a git repo at that path. The pack command provides an explicit fallback (lines 31–32: compare `git log -1 --format=%cd` vs `Last scanned` when no `Last seen commit` recorded), which contains this assumption rather than leaving it silent.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks below cite frozen IDs from it.
- **OP-12 (Closure before detection) — served, not violated.** The change adds *detection* (a live staleness check) but ships it behind a working closure channel: a stale result forces `/website-source-scan` (which closes the gap by re-stamping the inventory), and the skill is explicit that "a stale freshness result forces a re-scan before READY" (SKILL.md lines 177–178; pack command line 102). Detection paired with closure counts *for* the change.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — clear.** The `Last seen commit` field and live check have a confirmed present consumer (`/website-source-pack`, in this same change set). This is not a "hook for Phase 2" — it wires an existing field to an existing command, both shipping now.
- **OP-5 (advisory vs enforcement) — clear.** The check stays advisory-with-stop in the existing posture: it withholds `READY` and tells the operator to re-scan; it does not auto-correct or auto-publish. No advisory→enforcement upgrade. Tier-C publish boundary untouched (skill hard rule 5).
- **DR-1 / DR-3 (placement) — clear.** Edits stay in their canonical project-local homes (`.claude/skills/`, `.claude/commands/`); no tier or home change.
- The new "Authority conflict resolution" section *adds* an operator gate for the 01–09-amendment hard edge (SKILL.md lines 71–78) rather than auto-resolving — aligned with OP-2 (gate judgment) and the project's own operator-gate posture.

## Mitigations

- **Dimension 3 / 5 (the `.agents/` mirror):** Before landing the change, re-sync `projects/axcion-website/.agents/skills/website-content-source/SKILL.md` from the updated `.claude/` copy so the Codex/AGENTS harness loads the same hardened skill — OR, if a single source of truth is wanted, replace the real-file copy with a symlink to the `.claude/` version and record that in `shared-manifest.json` / AGENTS.md. Without this, a Codex session silently runs the pre-edit skill (no two-axis authority model, old freshness discipline). This reduces Dimensions 3 and 5 to Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `diff` result on the two skill copies, verbatim quotes from the referenced files and principles-base.md). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-20-risk-check-second-opinion-agents-mirror-drift.md`_

**Concurrence:** Concurs with PROCEED-WITH-CAUTION — but the verdict under-rates the coupling and mis-frames the mirror. The `.claude/`-side change is a clean hardening of three runtime contracts; the live freshness query strengthens OP-3 (loud failure over silent continuation). No objection to the edit itself.

**Risks the dimension review missed:**

1. **The mirror is a corrupting transform, not a stale copy.** `.agents/.../SKILL.md` line 84 cites `workspace AGENTS.md` where the `.claude/` source cites `workspace CLAUDE.md` — produced by a blind `.claude`→`.agents` / `CLAUDE.md`→`AGENTS.md` string swap. A naive re-sync re-applies the swap and re-breaks the citation (OP-3 / AP-1). **Re-syncing = regression, not mitigation.**

2. **No generator, no manifest — and the mirror is already incomplete.** No script produces `.agents/` or `AGENTS.md`; the two command files have no `.agents/` counterpart at all. The Codex harness is already missing the scan→pack freshness contract this change introduces.

3. **The new contract is cross-harness.** The live `git log -1` freshness check lives only in the `.claude/` command (unmirrored). A Codex session would carry the freshness prose with nothing implementing the check.

**Revised mitigation (overrides the Mitigations section above):**
- **Land the 8 `.claude/`-side files now; do NOT re-sync the mirror.** Re-syncing propagates the broken citation.
- **Record the knowingly-stale mirror in `logs/decisions.md`** (knowingly deferred).
- **Mirror strategy is separate, operator-gated work** — symlink is structurally right (DR-1 single source of truth) *if* Codex resolves symlinks and tolerates `CLAUDE.md` semantics in an `AGENTS.md`-named file (`[CITATION NEEDED]`). Hand-maintained mirror = patch; symlink-or-generator = structural fix. This needs a fact the workspace does not yet record: whether Codex resolves symlinks.

**Verdict: concurred — land the 8 files, log the mirror situation, defer the mirror strategy.**
