# Risk Check — 2026-06-17

## Change

Extend the boundary-leakage pre-commit hook (.claude/hooks/boundary-leakage-check.sh) — fill check (b) manifest-coverage and check (c) prohibited-language scan with real logic, add fail-on-leak logging to logs/friction-log.md; and fill the validate.sh schema-validation step. This is W0.6 — the hook is the mechanical enforcement of the project's load-bearing content boundary. Also part of the same session: apply non-breaking npm audit fixes (open item #8).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/.claude/hooks/boundary-leakage-check.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/validate.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/source-of-truth/manifest.yaml — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/source-of-truth/messaging/prohibited-language.yaml — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/package.json — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A sanctioned, in-design-intent W0.6 fill of an existing scaffolded guard with localized blast radius and clean git reversibility, but it flips a permissive guard into a blocking one and depends on YAML/schema contracts and an `npm audit` mutation that warrant two specific paired mitigations before landing.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-website/.git/hooks/pre-commit (symlink → boundary-leakage-check.sh) | invokes | no |
| projects/axcion-website/.claude/settings.json (PreToolUse Bash hook, `\|\| true`) | invokes | no |
| projects/axcion-website/CLAUDE.md § Boundary-Discipline Rule | documents | no |
| projects/axcion-website/pipeline/architecture.md (hook location/class) | documents | no |
| projects/axcion-website/pipeline/implementation-log.md (W0.4 scaffold record) | documents | no |
| projects/axcion-website/pipeline/project-plan.md §W0.6 (lines 353–379, sufficiency criteria) | documents | no |
| projects/axcion-website/apps/website/scripts/build.sh (chains validate → generate → build; line 26) | invokes | no |
| projects/axcion-website/apps/website/package.json (`validate`, `validate:only` scripts; lines 8–9) | invokes | no |
| projects/axcion-website/apps/website/scripts/generate.sh (reads manifest.yaml two-key control) | parses | no |
| projects/axcion-website/source-of-truth/manifest.yaml (`allowed_sources` / `forbidden_sources` schema the hook (b) will parse) | parses | no |
| projects/axcion-website/source-of-truth/messaging/prohibited-language.yaml (`hard_patterns`/`soft_patterns` the hook (c) will parse) | parses | no |
| projects/axcion-website/apps/website/src/server/intake/validation/prohibitedPatterns.ts (Worker also loads same YAML at init) | parses | no |

Total: 12 consumers, 0 must-change. All consumers are compatible with the change as described: the hook's invocation interface (called with no args / `$CLAUDE_TOOL_INPUT`, communicates via exit code) does not change; only its internal pass/fail logic does. The filling of `prohibited-language.yaml` patterns themselves is explicitly a *later* work unit (W1.6 per the YAML header and prohibitedPatterns.ts line 13), so this change parses an as-yet-empty register — see Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded CLAUDE.md. The change edits two shell scripts and a log file; CLAUDE.md § Boundary-Discipline Rule already describes the hook (`projects/axcion-website/CLAUDE.md:53`) and needs no expansion.
- The PreToolUse(Bash) hook is already registered (`.claude/settings.json:55–67`) — this change does not add a new auto-load hook, it fills the logic of an existing one. No new per-session or per-tool-call cost is introduced; the hook fires today.
- The PreToolUse hook runs per Bash tool call but is `timeout: 10` and ends in `|| true` (`settings.json:61`); the filled checks add bounded git/grep work, not token cost to the model context.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries are added, removed, or widened. `settings.json` permission blocks are untouched by the described change (the change edits hook *logic*, not the settings hook *registration* — `settings.json:55–67` already authorizes the invocation).
- No new tool family, Write path, or external API is introduced. The npm audit fix runs `npm` (a package operation already implied by the build toolchain), and is constrained to "non-breaking" by the description.
- No scope escalation (project → user) and no cross-repo write. The hook reads staged git content and YAML within the execution repo only.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: 12 consumers, 0 must-change. No caller requires modification to keep working — the hook's contract (no-arg invocation, exit-code signalling) is preserved.
- Shared infra IS touched in a behaviour-changing way: the hook is wired at two sites — `.git/hooks/pre-commit` (binding, `git` aborts on non-zero) and `settings.json` PreToolUse (non-blocking). Filling stubs (b)/(c) converts a guard that today exits 0 vacuously (`boundary-leakage-check.sh:124, 139`) into one that can return 1 and *block commits for this repo*. The CHANGE_DESCRIPTION acknowledges this ("makes a currently-permissive guard actually reject commits").
- `build.sh:26` aborts the build on a `validate.sh` non-zero exit. Filling the `validate_schemas` step (`validate.sh:58–71`) means a malformed schema can now abort `npm run build` / `npm run validate` where it previously passed vacuously (`validate.sh:70`). This is the intended W0.6 outcome but widens the set of conditions that fail the build.
- Backwards-compatible at the interface level (contract unchanged), behaviour-changing at the enforcement level — placing this at Medium rather than Low because the enforcement flip affects two workflows (commit + build) even though no consumer file must change.

### Dimension 4: Reversibility
**Risk:** Medium

- The hook and validate.sh edits are single-file content changes that `git revert` restores cleanly — Low on its own.
- Two factors push to Medium: (1) the change appends fail-on-leak entries to `logs/friction-log.md`, an append-only log (`friction-log.md:3` "Append-only, newest at END"). A revert of the *code* will not retract log entries already written by a fired hook; stale entries carry forward. (2) The `npm audit fix` mutates `package.json` and (if present) the lockfile under `apps/website/`; reverting requires restoring both the manifest and lockfile together, one extra coordinated cleanup step beyond a single-file revert.
- The hook is live automation: between this change landing and any revert, a real commit could fire the now-blocking hook (desired) or a false-positive could block a legitimate commit (requires `--no-verify` as an operator workaround). Mitigable, not severe.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- New parse contract on `manifest.yaml`: check (b) will parse `allowed_sources` (`manifest.yaml:18`, currently `[]`) and the generated tree under `apps/website/src/content/generated/`. The hook becomes coupled to the manifest's YAML shape and to `generate.sh`'s output convention (`generate.sh:55–60` describes the same coverage logic). Two components (hook (b) and generate.sh) now both reason about manifest-coverage — a functional overlap to keep aligned.
- New parse contract on `prohibited-language.yaml`: check (c) will parse `hard_patterns`/`soft_patterns` (`prohibited-language.yaml:21–25`). The SAME file is loaded by the Worker via `prohibitedPatterns.ts` (line 21 comment). Two consumers will parse the register; if the YAML's key names or regex semantics shift, both must stay in step. The register is empty today and patterns are authored at W1.6 — so check (c) is being implemented against a contract whose *content* does not yet exist, only its shape.
- Semantic mismatch risk to flag: `prohibitedPatterns.ts` is a deliberate SOFT check (flags, never rejects — lines 8–11), whereas the hook's check (c) is specified to *fail the commit* (project-plan.md:360, "fail the commit on any match"). Same source file, two opposite enforcement postures by design. This is defensible (commit-time vs submission-time are different surfaces) but is a latent coupling: a pattern authored for soft submission-flagging at W1.6 will become a hard commit-blocker via the hook. Document the dual posture at the change site.
- The hook silently relies on `git diff --cached`/`git show :file` and on the generated-dir path convention (`boundary-leakage-check.sh:115`); these are established in-repo conventions, not external — acceptable.

### Dimension 6: Principle Alignment
**Risk:** Low

- Read `principles-base.md` (frozen-ID index, as-of 2026-06-01) successfully; checks applied against OP-12, OP-5, OP-9/AP-7/DR-7, DR-1/DR-3, OP-11.
- **OP-12 (closure before detection):** the change ADDS closure to existing detection rather than detection-without-closure — the hook *rejects* the commit (closes the finding by blocking the leak) and logs it. This aligns with OP-12, counting *for* the change.
- **OP-5 (advisory vs enforcement):** the hook is already designed as enforcement at the binding git layer (`boundary-leakage-check.sh:19–29`); this is not a silent advisory→enforcement upgrade. Enforcement authority was an explicit per-component decision recorded at scaffold (W0.4) and in CLAUDE.md § Boundary-Discipline Rule. No principle drift.
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** the change fills a scaffold for a consumer that *exists* (the content boundary is the project's load-bearing property; the manifest and prohibited-language registers exist as files). It is not "hooks for Phase 2." The one nuance — check (c) parses an empty register whose patterns land at W1.6 — is filling a *committed* contract on the W0.6 critical path (project-plan.md:357–361), not speculative generalization. No violation.
- **DR-1 / DR-3 (placement):** project-local hook stays project-local; no tier or home change. Aligned.
- **OP-11:** no principle is being revised; nothing to surface loudly.

## Mitigations

- **Dimension 3 (enforcement flip):** Before landing, run the three W0.6 sufficiency tests defined at project-plan.md:371 — a test commit containing (a) a `source-of-truth/` path, (b) an unmanifested published file, and (c) a prohibited claim — and confirm each is rejected *independently* AND that a known-good legitimate commit still passes (no false positive). This converts the behaviour-flip from an unverified assumption to a tested guarantee. Keep the W0.6h fresh-context `qc-reviewer` acceptance run as the independent gate.
- **Dimension 4 (npm audit + log mutation):** Run `npm audit fix` WITHOUT `--force` (non-breaking only, as scoped), and commit the `package.json` + lockfile change as a *separate commit* from the hook/validate edits so the security fix and the enforcement change can be reverted independently. Treat any friction-log entries the hook writes as forward-only; do not expect `git revert` to retract them — note this in the W0.6 gate-close session block.
- **Dimension 5 (dual-posture coupling):** Add an in-file comment at the hook's check (c) and at `prohibitedPatterns.ts` recording that the SAME `prohibited-language.yaml` drives a HARD commit-block (hook) and a SOFT submission-flag (Worker), so a future W1.6 pattern author understands a pattern they add becomes commit-blocking. This documents the new contract at the change site (the Dimension-5 Medium→Low condition).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to the two scripts, settings.json, the two YAML registers, package.json, project-plan.md §W0.6, prohibitedPatterns.ts, the `.git/hooks/pre-commit` symlink (verified via `ls -la`), and grep counts across the workspace for the consumer inventory. Principle citations drawn from the readable `principles-base.md` frozen-ID index. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-17-boundary-hook-w06.md

**Concurrence:** Concur with PROCEED-WITH-CAUTION. Dimension scores calibrated right; flipping a today-vacuous guard into a live blocker across two wired surfaces (blocking pre-commit + non-blocking `|| true`) is the two-end-contract elevation signal (risk-topology.md § 5; principles.md § DR-8). Flip is design intent (project CLAUDE.md § Boundary-Discipline; principles.md § OP-5) → principle-alignment Low correct.

**Recommended path:** Endorsed in full, with reinforcements:
- §W0.6 tests + known-good pass + qc-reviewer acceptance before landing — non-negotiable (QS-9, QS-1).
- `npm audit fix` without `--force` — correct (`--force` is a semver-major change class).
- Separate lockfile commit — correct; stronger reason is reversibility of the hook edit.
- Comment `prohibited-language.yaml` at BOTH ends (hard commit-block + soft submission-flag).

**Risks the dimension review missed:**
1. Session-coupling of two unrelated change classes (OP-4 / AP-8) — sequence them: hook fill first with full QC, then npm fix as a clean follow-on (or defer).
2. The `|| true` soft surface can silently mask a true leak (OP-3) — confirm a §W0.6 test covers the soft surface emitting a VISIBLE warning on a true positive.
3. `friction-log.md` write target — confirm project-local log, not canonical ai-resources/logs/friction-log.md. Match existing entry shape.
4. Append-only interaction with `prohibited-language.yaml` — read the YAML defensively so a future append doesn't break the scan at load time.

**Position:** Proceed with the controls, but sequence the two change classes rather than bundling — hook fill first (full QC), npm fix second. Close risks 2 and 3 before landing.
