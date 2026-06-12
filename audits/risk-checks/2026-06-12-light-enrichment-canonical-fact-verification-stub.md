# Risk Check — 2026-06-12

## Change

Light-enrichment of the canonical research-workflow fact-verification stub. Two files edited in lockstep: (1) ai-resources/workflows/research-workflow/reference/sops/fact-verification-prompt.md — currently a bare {{FACT_VERIFICATION_SYSTEM_PROMPT}} placeholder stub; add a domain-agnostic guidance-scaffolding block (3 generic rules: sourced+dated, evidence≠interpretation, category-leakage generalized to "subject entity"; plus a fixed output format Claim/Claim ID/Issue type/Recommended correction + APPROVED), while KEEPING the placeholder as the operator-fill slot for domain-specific framing; also reword the line-3 REQUIRED-SETUP comment from "replace this file's content" to "fill the placeholder, keep the scaffolding". (2) ai-resources/workflows/research-workflow/SETUP.md Step 8b (line 126) — reword from "replace the placeholder content" to "fill the placeholder, keep the supplied scaffolding". This is P4 of a workflow-promotion manifest; P1/P2/P3 already landed. Blast radius: every future research-workflow template instantiation inherits the enriched stub. Source material is the positioning-research project's already-filled fact-verification-prompt.md (3 rules + output format).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/sops/fact-verification-prompt.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/reference/sops/fact-verification-prompt.md — exists (read-only source)

## Verdict

GO

**Summary:** Two-file, content-only enrichment of a template-stub SOP and its matching SETUP instruction; no contract change, no permission/hook/always-loaded surface touched, the sole functional consumer (canonical `/verify-chapter` Step 2) reads the file as free text, and the change actively serves OP-12 / DR-7 — every dimension Low.

## Consumer Inventory

Search terms: basenames `fact-verification-prompt.md`, `SETUP.md`; the placeholder/contract marker `{{FACT_VERIFICATION_SYSTEM_PROMPT}}`; the consumer token `/verify-chapter`. Grep run across `ai-resources/` and the workspace root. Audit/log/scratchpad/archive hits and context-pack snapshots are non-functional (they describe or snapshot the file, they do not consume it at runtime) and are excluded from the consumer rows below; the only runtime reader of the *canonical* stub is the canonical `/verify-chapter` command.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/workflows/research-workflow/.claude/commands/verify-chapter.md | invokes (Step 2 / line 39: "read fact verification prompt from `/reference/sops/`") | no |
| ai-resources/workflows/research-workflow/SETUP.md | co-edits (Step 8b / line 126 names the file's setup convention) | yes |

Total: 2 consumers, 1 must-change.

Notes on the must-change consumer: `SETUP.md` is the *second file in this same lockstep change* — it is "must-change" by the change's own design, not an unanticipated dependency. The change description already pairs it.

Notes on what is deliberately *not* a consumer of the canonical stub:
- Project-local `/verify-chapter` commands (`projects/positioning-research/`, `projects/research-pe-regime-shift-advisory-gap/`, `projects/buy-side-service-plan/`) each read their own *project-local* `reference/sops/fact-verification-prompt.md`, not the canonical template file. They are downstream *inheritors at instantiation time*, not live consumers of the canonical file. The change does not retro-edit any already-instantiated project copy (confirmed: the positioning-research copy is the read-only *source*, not a target).
- The canonical `/verify-chapter` consumes the file as a free-text system prompt fed into the GPT-5 API call (verify-chapter.md line 39) — it does **not** parse `## System Prompt`, the `{{...}}` token, or any structured marker. So no parse-contract row exists; adding scaffolding text changes only the content the operator is expected to fill around, not a shape the command depends on.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded surface touched. The edited file is a workflow-template SOP read on-demand only by `/verify-chapter` Step 2 (verify-chapter.md:39), and the file is `/compact`-dropped immediately after use (verify-chapter.md:42: "▸ /compact — verification prompt … no longer needed"). It is not `@import`ed into any CLAUDE.md and registers no hook.
- The enrichment adds roughly a dozen lines (3 rules + a 5-field output format) to a 25-line file. Per the archived token audit, the current file is ~150 tokens (`archive/.../03-token-audit.md:119`); the addition is on the order of ~80–120 tokens, paid only when a project actually runs `/verify-chapter`, never per session or per turn.
- SETUP.md edit is a one-line reword (line 126) — no token-cost change; SETUP.md is read by a human operator at scaffold time, not auto-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change is content-only inside two markdown files. No `settings.json` / `settings.local.json` touched; grep of the change scope shows no `allow`/`ask`/`deny` entry, no new Bash/Write/external-API pattern, no scope move between settings layers.
- No new tool-invocation pattern introduced — the GPT-5 API call path already exists in `/verify-chapter` and is unchanged by this edit.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 2 (the SOP stub + SETUP.md), exactly as described.
- Consumer Inventory (Step 1.5) found **2 consumers, 1 must-change**. The one must-change (`SETUP.md`) is the second leg of this same lockstep edit — anticipated by the change, not a surprise. The other consumer (canonical `/verify-chapter`) is compatible without modification.
- No contract change. The `parses` row is empty: `/verify-chapter` reads the file as free text (verify-chapter.md:39), so neither the `## System Prompt` heading, the `{{FACT_VERIFICATION_SYSTEM_PROMPT}}` token (which the change *keeps*), nor the output-format block is a marker any caller parses. Adding guidance text is backward-compatible by construction.
- Shared infra: none. The file is a per-template SOP, not a log, hook, or shared script. The "every future instantiation inherits the enriched stub" reach noted in the change is a *forward* inheritance at scaffold time — it does not retro-mutate existing project copies (the inventory confirms project-local copies are independent files; the positioning-research copy is the read-only source).
- No consumer surfaced by the inventory was unanticipated by the change description.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are in-tree content edits to tracked files; a single `git revert` of the landing commit fully restores the prior stub and the prior SETUP line. No sibling files or directories are created.
- No data/log mutation, no `settings.json` change, no external write, no automation (hook/cron/symlink) added that could fire between landing and revert.
- One forward-inheritance caveat (does not raise the level): any project scaffolded from the template *after* this lands and *before* a hypothetical revert would carry the enriched stub in its own project-local copy; reverting the canonical file would not retro-edit those. But that is the normal, intended template-inheritance behavior, the operator fills/overwrites that file at setup anyway (SETUP Step 8b), and it requires no cleanup — so revert of the canonical change itself remains clean.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Self-contained. The enrichment introduces no parse marker, filename convention, or YAML key that a caller must honor — `/verify-chapter` consumes the file as opaque prompt text (verify-chapter.md:39).
- No silent auto-firing: the SOP is read only inside an explicit `/verify-chapter` run, and the change adds no new event reaction or cross-session side effect.
- No functional overlap with an existing mechanism — there is exactly one fact-verification SOP and one command that reads it; the change enriches that single pair.
- The two edits are coupled to each other (SOP scaffolding ↔ SETUP wording), and that coupling is explicit and documented at both sites (the change rewords SETUP Step 8b to match the kept-placeholder posture). Coupling that is named at the change site is the Low/Medium boundary case resolved Low here because it is internal to the change, not an implicit dependency on an unnamed third component.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`); cited by frozen ID below.
- **DR-7 / OP-9 / AP-7 (speculative abstraction):** Not violated, and arguably served. The enriched stub has a **confirmed live consumer today** — the canonical `/verify-chapter` command already reads this exact file (verify-chapter.md:39). This is not "scaffolding for an absent Phase-2 consumer"; it raises the quality floor of an already-wired path. The generalization is *specific-to-generic promotion* sourced from a real filled instance (positioning-research), and the change explicitly drops the domain-specific rules (keeps only the 3 domain-agnostic ones), which is the correct DR-7 posture: generalize only the part with a second confirmed use.
- **OP-12 (closure before detection):** Served, not strained. The change adds *guidance for an existing closure channel* (fact-verification feeds corrections back into the chapter via `/verify-chapter` Steps 3–4), not a new free-floating detector. No new finding-generator ships ahead of a closure path.
- **OP-5 (advisory vs enforcement):** Unchanged. `/verify-chapter` remains advisory-with-operator-gate (verify-chapter.md:54: "PAUSE — Present all corrections to the operator"); the scaffolding adds an output format, not auto-correction authority.
- **DR-1 / DR-3 (placement):** Correct tier and home. The canonical SOP and its SETUP instruction both live in `ai-resources/workflows/research-workflow/` — the canonical template tier — which is exactly where a reusable workflow SOP belongs.
- **OP-11 (loud revision):** No principle is being revised; nothing to surface.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references: verify-chapter.md lines 39/42/54, SETUP.md line 126, fact-verification-prompt.md line 8, archived token-audit line 119; grep counts and consumer enumeration for the inventory; principle IDs DR-7/OP-9/AP-7/OP-12/OP-5/DR-1/DR-3/OP-11 cited from the readable principles-base; verbatim quote from CHANGE_DESCRIPTION). No training-data fallback was used on any read.
