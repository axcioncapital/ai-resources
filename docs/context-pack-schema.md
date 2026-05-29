# Context Pack Schema

Canonical format for context packs produced by the **Context Engine** — the read-only discovery layer that, given a vague task description, identifies load-bearing repo files for a pre-change repo modification and assembles a cited brief for the next agent.

This doc defines the **pack contract**: file layout, frontmatter fields, body sections, citation rules, authority hierarchy, and the handoff prompt that closes every pack. Both consumers — the `/build-context` command (manual entry) and the engine pre-steps in `/session-start` Step 2.4 and `/prime` Step 8c.4.5 (auto entry) — produce packs that conform to this schema.

This is distinct from the **research context packs** produced by the three project-local `/create-context-pack` instances (at `projects/buy-side-service-plan/`, `projects/nordic-pe-macro-landscape-H1-2026/`, and `ai-resources/workflows/research-workflow/`). Those packs target human readers for domain research with a 5-section schema (Purpose / Background / Key Terminology / Content Map / Scope Boundaries) and write to `execution/context-packs/`. This engine writes for agent consumers, at a different path (`output/context-packs/`), with structured frontmatter. No naming or path collision.

---

## 1. File layout

```
{cwd-project}/output/context-packs/{slug}/pack.md
```

- `{cwd-project}` — the absolute path of the project the pack is produced in (`git rev-parse --show-toplevel` from the working directory).
- `{slug}` — deterministic, collision-resistant identifier: `{task_type}-{YYYYMMDD}-{5-char random hex}`, lowercase, hyphenated. Example: `command-20260529-a3f9c`.
- `pack.md` — the pack itself. Single file, no sidecar.

The `{slug}/` subdirectory exists so future Phase 2 work can co-locate sidecar artifacts (e.g., follow-up packs from the same task, refresh logs) without renaming. MVP only writes `pack.md`.

**Per-project `output/` git-tracking is heterogeneous.** Some projects track `output/`; others gitignore it. The engine writes regardless; persistence is the project's policy. Operators who want guaranteed pack persistence should whitelist `output/context-packs/` in the project's `.gitignore` (`!output/context-packs/`). The pack itself never asserts persistence — it cites by file path and timestamps its creation, so a discarded pack is reproducible if needed.

---

## 2. Frontmatter

YAML frontmatter at the top of every pack. All fields are required unless marked optional.

```yaml
---
slug: {task_type}-{YYYYMMDD}-{5-char hex}
consumer: human | agent | session-input
task_type: architecture | command | agent | skill | hook | project | documentation | incident | qc
created: {ISO 8601 timestamp}
sufficient_to_plan: true | false
sufficient_to_implement: true | false
files_in_scope:
  - {workspace-relative path}
  - ...
allowed_inputs:           # optional — background sources, not load-bearing
  - {path}
required_outputs:         # optional — files the consumer is expected to produce
  - {path}
cited_paths:              # superset of files_in_scope + allowed_inputs; everything cited anywhere in the pack body
  - {path}
missing_context:          # optional — concrete gaps the engine identified but could not fill
  - kind: {one of: rule | decision | dependency | conflict | unknown-scope}
    description: {one short sentence naming what's missing}
---
```

### Field semantics

**`slug`** — must match the `{slug}` in the file path. Identity check.

**`consumer`** — declares who the pack is *for*. Three values:
- `human` — the operator reads the pack to orient before opening a task. Used by manual `/build-context` invocations with no downstream agent yet.
- `agent` — a downstream sub-agent (QC reviewer, refinement reviewer, custom builder) consumes the pack. Used when the operator chains the pack into another command.
- `session-input` — the pack feeds into `/session-start` Step 2.4 (or `/prime` Step 8c.4.5) for mandate pre-population. Default for the auto path.

This field is a Phase 2 hook — Phase 2 consumer behaviors (pre-edit check enforcement, drift-relative-to-pack, closeout-against-contract) will dispatch differently per consumer. In Phase 1 the field is informational only.

**`task_type`** — one of 9 taxonomy values (architecture / command / agent / skill / hook / project / documentation / incident / qc). The engine's classification step (`context-discovery` agent Step 1) assigns this. Drives routing in Step 3.

**`created`** — ISO 8601 timestamp with timezone, captured at pack-write time. Used downstream to detect staleness (a pack assembled days ago may reference moved or deleted files).

**`sufficient_to_plan` / `sufficient_to_implement`** — booleans. The engine declares each separately because the planning bar and the editing bar are not the same — an agent can often plan with partial context but must not edit with partial context. The engine sets these honestly:
- `sufficient_to_plan = true` only when the pack covers enough authoritative sources to draft an approach.
- `sufficient_to_implement = true` only when the pack covers every file the implementation would touch *plus* the rules / decisions / conflicts that govern those files.
- If either is `false`, `missing_context` MUST name what's missing.

These are Phase 2 hooks — Phase 2 consumers (pre-edit check) will block edits when `sufficient_to_implement: false`. Phase 1 surfaces the values without enforcement.

**`files_in_scope`** — concrete workspace-relative paths the consumer is expected to edit or substantively reference. Union of all load-bearing files surfaced in the pack body. Replaces the `(inferred)` placeholder in `/session-start` Step 2's mandate when the engine has produced a concrete list. Empty list = engine ran but found nothing — this is a valid (and informative) result.

**`allowed_inputs`** (optional) — background paths the consumer may read but is not expected to edit. The `Background sources` section of the pack body. Maps directly to the `Allowed inputs:` bullet in `/session-start` Step 3's mandate line. Omitted entirely when no background sources are surfaced (no `(none stated)` placeholder).

**`required_outputs`** (optional) — files the engine inferred the consumer must produce. Derived from `task_type`:
- `command` → `.claude/commands/{name}.md`
- `agent` → `.claude/agents/{name}.md`
- `skill` → `skills/{name}/SKILL.md`
- `hook` → `.claude/hooks/{name}.sh`
- `documentation` → `docs/{topic}.md`
- `architecture` / `project` / `incident` / `qc` → no default; engine leaves absent unless the task description names a concrete output.

When the engine cannot resolve `{name}` from the task description, `required_outputs` is omitted (no guess-write). Operators correct via `/session-start` Step 2's `r:` correction syntax.

**`cited_paths`** — every file path that appears anywhere in the pack body (Authoritative sources, Background sources, Conflicts surfaced, Missing context). Superset of `files_in_scope` and `allowed_inputs`. Used by downstream tools to enumerate the pack's provenance without re-parsing prose.

**`missing_context`** (optional) — concrete gaps. Five kinds:
- `rule` — a governing rule should exist (or seems to be implied) but the engine could not find it.
- `decision` — a prior accepted/rejected decision is referenced but no `logs/decisions.md` entry explains it.
- `dependency` — a file or component the task depends on, but the engine could not locate it.
- `conflict` — two sources disagree on a load-bearing point and the engine cannot tell which is current.
- `unknown-scope` — the task description is ambiguous in a way the engine cannot self-resolve.

Each entry is one short sentence. The engine surfaces these — it does NOT silently fill them or guess.

---

## 3. Body sections

Every pack body has these six sections, in this order. Empty sections are written explicitly with `*(none)*` rather than omitted — visibility over compactness.

### Task brief
One paragraph: the task description received by the engine, rephrased as a brief the next agent can act from. No interpretation beyond what the description states.

### Authoritative sources
The load-bearing files. Each entry includes path, one-line relevance summary, and authority tier (see §4). Format:

```
- **{workspace-relative path}** *(tier {N})* — {one-line relevance summary}
```

This section IS the `files_in_scope` justification. Every path here appears in the `files_in_scope` frontmatter array.

### Background sources
Files relevant for context but not load-bearing — supporting evidence, adjacent documentation, prior session notes. Same format as Authoritative sources. Maps to `allowed_inputs`.

### Conflicts surfaced
Two-or-more sources disagreeing on a load-bearing point. Each entry names the conflicting sources, summarizes the disagreement in one sentence, and explicitly does NOT arbitrate. Per workspace `CLAUDE.md` § Design Judgment Principles — "Conflicts must be surfaced, not silently resolved." If no conflicts: `*(none)*`.

### Missing context
Same structure as the `missing_context` frontmatter array, rendered in prose. Each entry names the kind, what's missing, and (when possible) why the engine could not fill it.

### Handoff prompt
A ready-to-act prompt block the next agent runs from. Includes:
- Restated task.
- The mandate fields the consumer should populate (`files_in_scope`, `allowed_inputs`, `required_outputs`) verbatim from frontmatter.
- A reminder that `sufficient_to_implement` is `false` if so — the consumer should not begin edits without resolving the named missing context.

This block is the operator-actionable artifact. Everything above is its justification.

---

## 4. Authority tier hierarchy

When two or more sources surface for the same task and disagree, the engine ranks them by tier — higher tier wins on cross-cutting questions. Within-tier conflicts surface explicitly under "Conflicts surfaced" rather than being arbitrated.

| Tier | Source class | Rationale |
|---|---|---|
| 1 | cwd-project `CLAUDE.md` | Project-specific governance; declares the project's own routing map, scope, and conventions. |
| 2 | Workspace-root `CLAUDE.md` | Cross-project rules; overrides only when project CLAUDE.md is silent. |
| 3 | `ai-resources/CLAUDE.md` | Shared-resource governance; applies to all projects via inheritance. |
| 4 | Process docs in `docs/` (workspace, ai-resources, or project) | Detailed methodology; subordinate to CLAUDE.md but authoritative for the procedures they cover. |
| 5 | Command / skill / agent frontmatter and SKILL.md bodies | Per-resource contract; authoritative for the resource's own behavior. |
| 6 | `logs/decisions.md` entries | Historical accepted decisions; authoritative until superseded. |
| 7 | Generated outputs (`output/`) | Working artifacts; informative but not governing. |
| 8 | Transcripts and memos | Source material; not yet codified as rules. |

**This hierarchy is new design judgment introduced by this MVP**, not documenting prior convention. It formalizes the implicit precedence the operator and existing commands already follow (CLAUDE.md beats `docs/` beats `logs/`), but the exact ordering of tiers 4–8 may need recalibration after Phase 1 evaluation. Calibration data: when a pack's authority ranking produces a wrong selection, log to `ai-resources/logs/improvement-log.md` and review on the next Friday checkup.

**Tier assignment is mechanical, not semantic.** The engine assigns tier from path patterns (`CLAUDE.md` → tier 1 or 2 by location; `docs/` → tier 4; `logs/decisions.md` → tier 6, etc.) — it does not infer authority from prose content. This keeps the engine deterministic and falsifiable.

---

## 5. Citation rules

Every claim in the pack body cites by workspace-relative file path. No paraphrased assertions without a citation; no claims sourced to "the repo" or "convention" without a concrete file.

- File paths in inline prose use Markdown link syntax: `[session-start.md](ai-resources/.claude/commands/session-start.md)`.
- File paths in bullet structures use **bold** for the path: `- **ai-resources/.claude/commands/session-start.md** *(tier 5)* — ...`.
- Line numbers when needed: `[session-start.md:184](ai-resources/.claude/commands/session-start.md#L184)`.
- The `cited_paths` frontmatter array must contain every path that appears in body prose (excluding the file path of the pack itself).

If a claim cannot be cited, it goes in **Missing context** as kind `rule` or `decision`. The engine MUST NOT invent assertions or summarize "general repo practice" without a file pointer.

---

## 5b. Agent → caller summary parse contract

The `context-discovery` agent returns a fixed-template markdown summary to its caller (`/build-context`, `/session-start` Step 2.4, `/prime` Step 8c.4.5). The summary's role is operator-visible chat display; the **pack file on disk is the source of truth** for structured fields.

Callers extract two things from the summary:

1. **`pack_path`** — from the first line: `**Pack:** {absolute pack_path}`. Regex-extractable.
2. **Outcome class** — one of:
   - `success-enriched` — `Pack:` present + both readiness booleans `true`
   - `success-insufficient` — `Pack:` present + at least one readiness boolean `false`
   - `engine-skipped` — first line is `**Pack:** (skipped — {reason})`
   - `engine-error` — first line is `**Pack:** (none — engine failed)`

Callers that need structured fields beyond outcome (e.g., `files_in_scope`, `allowed_inputs`, `required_outputs`) **Read the pack file** and parse its YAML frontmatter — they do NOT parse the markdown summary list items. This keeps the parse contract concrete (YAML schema) rather than fuzzy (markdown extraction).

The exact summary template the agent emits:

```
**Pack:** {absolute pack_path} | {tracked | untracked}
**Task type:** {task_type}
**Slug:** {slug}
**Consumer:** {consumer}

**Sufficient to plan:** {true|false}
**Sufficient to implement:** {true|false}

**files_in_scope** ({count}):
- {path}
- ...

**allowed_inputs** ({count | absent}):
- {path}

**required_outputs** ({count | absent}):
- {path}

**Conflicts surfaced:** {count | none}
**Missing context:** {count | none}
{when count > 0:}
- {kind}: {description}
```

The `tracked | untracked` token after `pack_path` declares whether the pack's path is git-tracked in the current project (informational for the operator — see §1 on heterogeneous persistence).

Lines beyond this template are not part of the contract; callers ignore them. The 30-line ceiling applies to total output.

## 6. Handoff prompt block

The pack closes with a ready-to-act prompt. Template:

```markdown
## Handoff prompt

**Task:** {restated task description}

**Mandate fields ready for /session-start:**
- `files_in_scope: {list verbatim from frontmatter}`
- `allowed_inputs: {list verbatim from frontmatter, or "absent"}`
- `required_outputs: {list verbatim from frontmatter, or "absent"}`

**Pack readiness:**
- Sufficient to plan: {true/false}
- Sufficient to implement: {true/false}

{If sufficient_to_implement is false:}
**Before any edit:** resolve the items in "Missing context" above. The engine could not fill them. Suggested resolution path: {one sentence per missing-context entry, naming who/what to consult — operator, another file, another command}.

{If consumer is "session-input":}
The mandate fields above will pre-populate `/session-start` Step 2's confirmation. The operator can still correct via `b:` / `a:` / `r:` / `f:` syntax.
```

The prompt is the consumer-facing surface — it states the task in the consumer's frame, surfaces the readiness booleans, and (when implementation readiness is false) names the explicit blocker resolution path. No interpretation beyond what the body sections support.

---

## 7. What the schema does NOT carry

For clarity, the following are out of scope for this schema:

- **Workspace-root invocations.** The engine requires a project `CLAUDE.md` as routing input. When the session is opened at the workspace root (no project CLAUDE.md) or in a fresh repo without one, the engine silently skips — auto-invoking callers see `**Pack:** (skipped — no CLAUDE.md at cwd)` and proceed without a pack. This is intentional, not a defect; cross-project work conducted at workspace root is outside MVP scope.
- **Sufficiency enforcement.** `sufficient_to_implement: false` is informational in MVP. Phase 2 will introduce a pre-edit check that blocks Edit/Write tools when a session's active pack has `sufficient_to_implement: false`. The schema field is the hook; the enforcement is later.
- **Drift detection.** Comparing actual session reads/writes against `files_in_scope` and `allowed_inputs` is `/drift-check`'s job, not the pack's.
- **Closeout validation.** Comparing session output against `required_outputs` is `/contract-check`'s job, not the pack's.
- **Multi-pack inheritance.** Each pack is self-contained. A pack for a multi-stage task is one pack, not a graph.
- **Pack versioning.** Re-running the engine on the same task produces a new pack with a new slug, not an update to the prior pack. Old packs persist (when git-tracked) as historical artifacts.
- **Hidden assertions.** Every claim cites a file. The engine has no editorial voice.

---

## 8. Worked example (skeletal)

The following is what a minimal pack looks like end-to-end. Body content is illustrative; the structure is canonical.

```markdown
---
slug: command-20260529-a3f9c
consumer: session-input
task_type: command
created: 2026-05-29T16:14:00Z
sufficient_to_plan: true
sufficient_to_implement: false
files_in_scope:
  - ai-resources/.claude/commands/friday-checkup.md
  - ai-resources/.claude/commands/friday-so.md
allowed_inputs:
  - ai-resources/audits/friday-checkup-2026-05-22.md
required_outputs:
  - ai-resources/.claude/commands/friday-checkup.md
cited_paths:
  - ai-resources/.claude/commands/friday-checkup.md
  - ai-resources/.claude/commands/friday-so.md
  - ai-resources/audits/friday-checkup-2026-05-22.md
  - ai-resources/CLAUDE.md
missing_context:
  - kind: decision
    description: No decisions.md entry explains why friday-so was split from friday-checkup in 2026-05.
---

## Task brief

Improve the Friday checkup workflow — operator-supplied scope: the weekly cadence command that bundles audits across ai-resources, workspace, and named projects.

## Authoritative sources

- **ai-resources/.claude/commands/friday-checkup.md** *(tier 5)* — The command itself; canonical behavior.
- **ai-resources/CLAUDE.md** *(tier 3)* — Cadence rule: "Run /friday-checkup each Friday before starting next week's work." Governs invocation timing.

## Background sources

- **ai-resources/audits/friday-checkup-2026-05-22.md** *(tier 7)* — Most recent checkup output; informs what real invocations produce.

## Conflicts surfaced

*(none)*

## Missing context

- **decision** — No decision-log entry explains why `/friday-so` (System Owner advisory) was split out of `/friday-checkup`. The split was made; the rationale is implicit. Improvements that re-merge or further split the cadence would benefit from operator clarification.

## Handoff prompt

**Task:** Improve the Friday checkup workflow.

**Mandate fields ready for /session-start:**
- `files_in_scope: ai-resources/.claude/commands/friday-checkup.md, ai-resources/.claude/commands/friday-so.md`
- `allowed_inputs: ai-resources/audits/friday-checkup-2026-05-22.md`
- `required_outputs: ai-resources/.claude/commands/friday-checkup.md`

**Pack readiness:**
- Sufficient to plan: true
- Sufficient to implement: false

**Before any edit:** resolve the items in "Missing context" above. Suggested resolution path: ask the operator why /friday-so was split from /friday-checkup before proposing improvements that touch the split boundary.
```

---

## 9. Versioning and changes

This is v1 of the schema. Future versions will be documented in this file under a new `## Version history` section at bottom. Breaking changes (renamed required fields, removed sections) require:
1. An update to the canonical `/build-context` command and the engine pre-steps in `/session-start` Step 2.4 and `/prime` Step 8c.4.5 (so producers emit the new shape).
2. An update to any Phase 2 consumers (pre-edit check, drift-relative-to-pack) that parse the schema.
3. A migration note in `logs/decisions.md` documenting the reason.

Additive changes (new optional fields, new optional sections) do not require versioning — producers and consumers ignore unknown fields silently.
