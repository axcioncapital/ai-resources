# Risk Check — 2026-06-19

## Change

Rewrite apps/website/scripts/generate.sh to implement the two-key transform (read manifest.yaml allowed_sources, write to src/content/generated/ only if manifest entry + public_release: true + status: approved), add inline python3 schema enforcement, and add --dry-run mode. Also bump owner/status to required: true on all 11 source-of-truth/schemas/*.yaml (schema_version 1.0 → 1.1) and drop .optional() from owner/status in apps/website/src/content/config.ts v0BaseSchema. Log both schema bumps in logs/decisions.md. All per output/build-specs/2026-06-18-content-pipeline-hardening-spec.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/scripts/generate.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/source-of-truth/manifest.yaml — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/src/content/generated/ — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/source-of-truth/schemas/ — exists (11 YAML schema files)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/apps/website/src/content/config.ts — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/output/build-specs/2026-06-18-content-pipeline-hardening-spec.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-specified, recorded-decision implementation of the always-intended two-key transform plus the overdue CP-1 schema graduation; risk is concentrated in a non-backwards-compatible schema-version bump (V1 required-field flip) across 12 files that must land atomically with config.ts, and in append-only-contract / boundary discipline — all addressable with paired mitigations the spec mostly already names.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| apps/website/scripts/build.sh | invokes | no |
| apps/website/scripts/validate.sh | co-edits | no (own deferral, items #9/#10) |
| apps/website/src/content/config.ts | co-edits | yes |
| source-of-truth/schemas/*.yaml (11 files) | co-edits | yes |
| .claude/hooks/boundary-leakage-check.sh | parses | no (compatible; W1.4 facet #9 separate) |
| source-of-truth/manifest.yaml | parses | no (empty `allowed_sources: []`; shape unchanged) |
| logs/decisions.md | documents | yes (append two bump entries) |
| projects/axcion-website/CLAUDE.md (Two-key + Append-only rules) | documents | no |
| pipeline/architecture.md, implementation-spec.md, technical-spec-content-model-and-boundary.md | documents | no |
| apps/website/src/content/generated/ (README marker today) | co-edits | no (transform overwrites) |

Total: ~10 distinct consumers, of which **3 classes must-change** (config.ts; the 11 schema YAMLs; decisions.md). build.sh invokes generate.sh by exit-code contract (continues to hold: empty-manifest path still exits 0 per AC-10). The manifest is confirmed empty today (`allowed_sources: []`, manifest.yaml:18), so the runtime blast radius of the transform itself is near-zero at land time; the schema bump is the part with real downstream reach. No unanticipated consumer surfaced — the spec's own consumer list matches the grep.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. The change touches build-time shell, YAML schemas, and a Zod config — none are `@import`ed into a CLAUDE.md or loaded per turn.
- No new hook registered. The PreToolUse/pre-commit hook is the existing `boundary-leakage-check.sh` (unchanged by this work) — boundary-leakage-check.sh:36-43.
- `generate.sh` runs at build time only ("Build-time-only source-of-truth → generated transform", generate.sh:2), not per session or per tool call. Pay-as-used.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json change described. Inline validation is `python3 -c "..."` with "no new packages, no network calls (NFR-3)" — spec line 30 / FR-5.
- python3 confirmed present on the host (Python 3.14.3); no new tool family introduced — Bash + python3 are build-script-local, not a harness permission grant.
- No `deny` rule touched, no scope escalation. The transform writes only to `apps/website/src/content/generated/` (generate.sh:24), which is gitignored (AD-6 / PC-6) — same write target as the existing scaffold.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: ~10 consumers, **3 classes must-change** (config.ts, 11 schema YAMLs, decisions.md). This exceeds the Low band (0–2 callers) but every must-change consumer is named and co-edited in the same work block (spec Stage-5 workstream 1).
- **Contract change is NOT backwards-compatible.** Flipping `owner`/`status` to `required: true` (schema YAMLs) and dropping `.optional()` in `v0BaseSchema` (config.ts:24-25) is a required-field addition — any existing content item lacking those fields now fails validation. This is the High trigger ("a contract change that is not backwards-compatible"). Mitigated in practice: `allowed_sources: []` is empty (manifest.yaml:18) and no V0 content has been approved, so zero live items are broken today — the break is latent, not active. This is what holds the dimension at Medium rather than High.
- `build.sh` invokes generate.sh by exit-code (build.sh:38-44); AC-10 requires the empty-manifest path still exits 0, preserving the caller contract.
- `validate.sh` `validate_schemas()` does structural-presence only today (validate.sh:58-87; decisions.md item #10 defers per-file enforcement to W1.4) — it does not parse `required:`, so the schema bump does not break it.
- The boundary hook reads `manifest.yaml` and `prohibited-language.yaml` (boundary-leakage-check.sh:76-77), not the schemas; its manifest-source-existence facet is deferred (decisions.md #9). No hook contract is broken.

### Dimension 4: Reversibility
**Risk:** Medium

- The shell rewrite, config.ts edit, and 11 schema edits are all in-tree and clean under `git revert`.
- **`logs/decisions.md` is an append-only log** — the change appends two bump entries. A `git revert` of the commit removes them, but project convention treats the log as forward-only (cf. boundary hook fail-on-leak "Entries are forward-only", boundary-leakage-check.sh:23-26). If the code revert and the log are decoupled, a stale "schema_version 1.1" entry can survive a code rollback to 1.0 — one extra manual cleanup step. This is the Medium trigger.
- `generated/` is gitignored, so reverting leaves no committed artifact to clean. `--dry-run` writes nothing (AC-9), so no state leaks from dry runs.
- No state pushed beyond git: no deploy, no external write, no Notion/API call. Reversible within the working tree with one log-consistency step.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Two-net field-name agreement is an implicit contract.** The YAML schemas (`source-of-truth/schemas/`) and the Astro Zod schema (`config.ts` `v0BaseSchema`) must agree on field names and required-sets, or "the two nets disagree" (spec line 90; workstream 3 explicitly says "reconcile any mismatch"). This coupling is real but is named in the spec and in config.ts:7-8 — a documented contract, hence Medium not High.
- **YAML-parse exact-match dependency.** NFR-4 / AC-5 require `status: aproved` (typo) to read as *not* approved. The inline python3 parser must compare against the exact enum (`['draft','in-review','approved','archived']`, config.ts:25). A loose substring/`grep` match would silently coerce a typo to approved — a publication-boundary failure. This is a coupling on parser exactness; the spec calls it out (AC-5) but it lives in code yet to be written.
- **`set -e` loop-abort coupling.** FR-5 requires the python3 validation to run in a subshell so `set -euo pipefail` (generate.sh:16) does not abort the accumulation loop on first failure. A naive implementation would exit on item 1 and never reach FR-7's "accumulate then non-zero exit." Named in the spec, but an easy implementation trap.
- Manifest entry-key shape is still unpinned (decisions.md #9: "the entry source-path KEY NAME is unpinned"). generate.sh's transform is now the authoritative parser that pins it — downstream the deferred hook facet (#9) must match whatever key name this transform adopts. New convention introduced here that a future consumer must honor.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); checks applied against frozen IDs.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — PASS.** The transform is not built for an absent consumer: it "implements the consumer that was always intended" (spec line 49), the manifest two-key contract is pre-existing (manifest.yaml:5-9, CLAUDE.md Boundary-Discipline Rule 1), and W1.4 copy work is the confirmed near-term consumer that is blocked without it (decisions.md "W1.4 cannot publish without the transform"). The spec actively *rejects* speculative scope: claim-severity tagging → W1.5, `last_reviewed` hard enforcement → CP-3, CMS/preview UI → "out of scope forever" (spec lines 84-86).
- **OP-12 (closure before detection) — PASS / serves it.** The change adds detection (schema enforcement, dry-run BLOCKED reporting) *paired with* a working closure channel (the transform that publishes, the dry-run that reports why an item is blocked). It is not detection ahead of closure.
- **OP-5 (advisory vs enforcement) — note, not a violation.** `--dry-run` is advisory ("it is a report, not a gate", FR-6). The required-field flip *is* an enforcement upgrade (build fails on invalid approved item, FR-7) — but this is the explicitly recorded CP-1/V1 contract (config.ts:7-8 "graduate to required() at V1"; decisions.md 2026-06-18 entry), not a silent upgrade. Loud and recorded → OP-11 satisfied.
- **OP-11 (loud revision) — PASS.** Both schema bumps are required to be logged in decisions.md (NFR-5, Stage-5 workstream 1); the direction itself is already a recorded decision (decisions.md "2026-06-18 — Content-pipeline hardening direction").
- **DR-1 / DR-3 (placement) — PASS.** All artifacts stay in their canonical project-local homes (`apps/website/scripts/`, `source-of-truth/schemas/`, `apps/website/src/content/`). No tier or home error.

## Mitigations

- **Dimension 3 (Blast Radius — non-backwards-compatible contract):** Land the schema bump atomically — all 11 schema YAMLs (`schema_version` → 1.1, `owner`/`status` → `required: true`), config.ts `v0BaseSchema` (drop `.optional()` on `owner`/`status` only; leave `last_reviewed`), and the two decisions.md entries in **one commit** (spec Stage-5 workstream 1; QA checklist lines 98-100). Before committing, confirm zero items currently require the new fields: `allowed_sources: []` must still be empty and no `source-of-truth/` content item is approved (manifest.yaml:18) — verify so the latent break stays latent. Run AC-10 (empty-manifest path exits 0) to prove no W0.4 regression to build.sh's caller contract.
- **Dimension 4 (Reversibility — append-only log):** If this is ever reverted, revert code and decisions.md together in the same operation, or add a superseding decisions.md entry noting the rollback (do not silently delete the 1.1 entry while leaving 1.0 schemas) — keep the forward-only log consistent with the on-disk `schema_version`.
- **Dimension 5 (Hidden Coupling — parser exactness + set -e):** During implementation, prove AC-5 (`status: aproved` → BLOCKED, never published) and the `set -e` subshell behaviour (FR-5: a validation failure does not abort the loop; failures accumulate and exit non-zero per FR-7) against the `__test__` fixture set before tear-down. Reconcile config.ts field names against the YAML schemas (spec workstream 3 / QA checklist line 100) so the two nets agree. Pin and document the manifest entry-key shape this transform adopts so the deferred hook facet (decisions.md #9) can match it.
- **Process:** This change is in a `/risk-check` gated structural class (new shared-state automation logic + cross-file contract bump); route through independent `qc-reviewer` acceptance (AC-12) and `/qc-pass` on the implementation before commit, per the spec's own Stage-6 gate and project QC Independence Rule.

## Recommended redesign

(Omitted — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to generate.sh, config.ts, manifest.yaml, the schema YAML, build.sh, validate.sh, boundary-leakage-check.sh, decisions.md, the build spec; grep counts for consumer inventory; principle IDs from principles-base.md). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Concur with PROCEED-WITH-CAUTION** — the verdict is correctly calibrated and the recommended path is right. Endorsed without modification, plus three additions.

**Routing:** Lands entirely project-local in `axcion-website` (script, schemas, `config.ts`, decision log). Risk-topology § 2 shows `axcion-website` in no shared-infra reverse map; § 5 places it in the project-local safe zone. Correct home, no relocation. This graduates a documented design (project CLAUDE.md § Boundary-Discipline Rule 1) into its enforcing code — not new architecture (DR-7 satisfied; the second consumer, `config.ts` runtime validation, already exists).

**Architectural commentary:**
- Atomic landing is a **CP-1 checkpoint event**, not just "commit together." Per the project's § Append-Only rule, a required-field flip is reserved for a checkpoint with a logged `schema_version` bump. The 11 schema bumps + `config.ts` `.optional()` drop + `decisions.md` entry must be one commit, with downstream consumers (Worker load path, template embed) confirmed.
- `--dry-run` is the right D4 reversibility hedge (rollback is forward-only — migrations are monotonic). Keep it first-class.

**Risk the dimension review missed (the material one):**
- **The `boundary-leakage-check.sh` hook interaction is outside the six-dimension frame.** `generate.sh` changes how manifest coverage is computed and what gets written into `src/content/generated/`. The hook (project's commit-time enforcer) also checks manifest coverage — this is a **third two-end contract** beyond the two nets the review names. If the two diverge on entry-key shape, the atomic commit gets rejected at commit time, or passes while disagreeing. Add to the proof set: confirm `generate.sh`'s manifest read and the hook's coverage check agree on entry-key shape before landing. Verify against the actual hook source.
- Two smaller: AC-5 must assert the *python3-exits-nonzero → abort-before-write* path specifically (POSIX command-substitution / pipeline exit rules can let `set -e` fail open). Make the entry-key pin a **loud `--dry-run` assertion** (OP-3), not a documented convention — an unpinned silent mismatch is a fail-open on the boundary.

**Position:** Proceed along the recommended path with those three additions. No conflict with documented principles — the change strengthens the boundary the project exists to protect.
