# Workflow Token-Efficiency Audit — /new-project

**Workflow:** `/new-project` — Project Pipeline Orchestrator
**Scope:** `.claude/commands/new-project.md` + 6 delegated pipeline agents
**Protocol section:** 4
**Date:** 2026-05-18

---

## Workflow Identification

`/new-project` is a multi-stage pipeline orchestrator that consumes approved planning artifacts (context pack, project plan, optional technical spec) from `projects/project-planning/output/{name}/` and drives a 6-stage build through gated subagent delegation. References from CLAUDE.md / commands / docs: high — invoked by every new project bootstrap; referenced in workspace and ai-resources CLAUDE.md.

## File measurements

| File | Lines | Words | Est. tokens (×1.3) |
|---|---|---|---|
| `.claude/commands/new-project.md` | 608 | 6,083 | ~7,908 |
| `.claude/agents/pipeline-stage-3a.md` | 139 | 775 | ~1,008 |
| `.claude/agents/pipeline-stage-3b.md` | 50 | 260 | ~338 |
| `.claude/agents/pipeline-stage-3c.md` | 48 | 261 | ~339 |
| `.claude/agents/pipeline-stage-4.md` | 68 | 417 | ~542 |
| `.claude/agents/pipeline-stage-5.md` | 45 | 255 | ~332 |
| `.claude/agents/session-guide-generator.md` | 57 | 400 | ~520 |
| **Total agent files** | **407** | **2,368** | **~3,078** |
| **Workflow total (cmd + agents)** | **1,015** | **8,451** | **~10,986** |

The command file at 608 lines is well past any 300-line HIGH threshold and is the single largest command file in the repo.

---

## 4.2.1 — What gets loaded at workflow start?

When operator invokes `/new-project`:

1. **CLAUDE.md** (workspace + ai-resources project-level) loads per session — not unique to this workflow but is always-on baseline.
2. **`.claude/commands/new-project.md`** — full 608 lines (~7,908 tokens) loaded into main session context the moment the slash command is invoked. This is the orchestrator body and remains resident across all stage spawns since the orchestrator must persist to gate between stages.
3. **No skills are loaded automatically by the orchestrator itself.** Skill loading happens inside the delegated agents (`architecture-designer`, `implementation-spec-writer`, `project-implementer`, `project-tester`, `session-guide-generator` — declared via `skills:` frontmatter in agent files, loaded in subagent context, not main).

**Total estimated start-of-workflow context (delta beyond baseline CLAUDE.md):** ~7,908 tokens (the command file). Agent files are NOT loaded into main session — they are spawned as subagents and their definitions live in subagent context.

## 4.2.2 — Subagent calls

Six subagent delegations across one full pipeline run (one per stage):

| # | Subagent | Spawned by | Model | Skills loaded inside | Worktree isolated? |
|---|---|---|---|---|---|
| 1 | `pipeline-stage-3a` | Orchestrator step 12 (first-run) | sonnet | (none — mechanical scan) | no |
| 2 | `pipeline-stage-3b` | Continuation after NEXT | opus | architecture-designer | no |
| 3 | `pipeline-stage-3c` | Continuation after NEXT | opus | implementation-spec-writer | no |
| 4 | `pipeline-stage-4` | Continuation after NEXT | sonnet | project-implementer | YES |
| 5 | `pipeline-stage-5` | Continuation after NEXT | sonnet | project-tester | no |
| 6 | `session-guide-generator` | Continuation after NEXT (optional) | sonnet | session-guide-generator | no |

Each subagent spawn happens between operator `NEXT` gates — orchestrator does NOT keep state across spawns in conversation memory; it relies on `pipeline-state.md` on disk.

## 4.2.3 — Output volume returned to main session

Per-stage Return Contracts (read from agent files):

| Subagent | Return cap | Disk artifact | Compliant with subagent contract |
|---|---|---|---|
| 3a | ≤30 lines | `pipeline/repo-snapshot.md` | yes — full snapshot to disk, ≤30 line summary returned |
| 3b | ≤30 lines | `pipeline/architecture.md` | yes |
| 3c | ≤30 lines | `pipeline/implementation-spec.md` | yes |
| 4 | ≤30 lines | `pipeline/implementation-log.md` | yes |
| 5 | ≤30 lines | `pipeline/test-results.md` | yes |
| 6 | ≤30 lines | `pipeline/session-guide.md` | yes |

**Assessment:** All six agents declare and enforce a ≤30-line return contract with disk persistence. **No subagent returns >200 lines to main session — none breach the HIGH threshold defined in Section 4 of the protocol.**

## 4.2.4 — QC / refinement cycles designed for

The orchestrator does NOT chain a `/qc-pass` or `/refinement-pass` invocation between stages. Quality gating is **operator-driven** at each stage:

- Stage 3b: ad-hoc user review at "When the architecture is approved by the user…"
- Stage 3c: "Architecture Gap Handling" allows returning to Stage 3b for revision
- Stage 4: "Error Recovery" allows returning to Stage 3b or 3c on fundamental failure
- Stage 5: "Handling Failures" allows fix-manually / re-run-stage-4-op / accept-as-is

Estimated total sessions per typical run: **6 subagent spawns** baseline. Typical refinement loops add 0–2 reruns (e.g., 3b revision after gap surfaced at 3c). **Refinement multiplier ≤ 1 typical, ≤ 1.5 at worst.** Does not breach the protocol's "consistently >3" MEDIUM threshold.

## 4.2.5 — File reads — main session vs delegable

### Main-session reads (executed by orchestrator body)

| Step | File(s) read in main session | Necessary or delegable? | Size flag |
|---|---|---|---|
| First Run §3 verification | `$SRC/context-pack.md` existence check (`-f`, no content read) | Necessary | — |
| First Run §4 discovery | `ls "$SRC"/project-plan-v*.md` (filename listing, no content read) | Necessary | — |
| First Run §4 QC verdicts | `grep -qE ... $SRC/plan-qc-verdict.md` (single-line match, no full read) | Necessary | — |
| First Run §11a model-ID precedent | **`projects/buy-side-service-plan/CLAUDE.md`** — **full Read** to verify Opus 4.7 identifier string | **DELEGABLE** — see Finding 3 | unknown line count; project-level CLAUDE.md typically 100–300 lines |
| Continuation §1 | `pipeline-state.md` (single small file, <50 lines) | Necessary | — |
| Post-pipeline enrichment §2 | `projects/{name}/.claude/settings.json` (via jq, no full Read into context) | Necessary | — |
| Post-pipeline enrichment §4 | `projects/{name}/CLAUDE.md` (idempotent grep + append; full Read may happen for grep) | Necessary (operates on the file) | unknown |

### Subagent-delegated reads (handled inside spawned context)

| Stage | Files read | In main session? |
|---|---|---|
| 3a | Full repo scan: CLAUDE.md + all SKILL.md + all `.claude/**` + workflows + top-level dirs + file tree | No — delegated to 3a |
| 3b | `project-plan.md`, `repo-snapshot.md`, `technical-spec.md` (opt), `decisions.md` | No — delegated to 3b |
| 3c | `architecture.md`, `repo-snapshot.md`, `technical-spec.md` (opt), `decisions.md`, `project-plan.md` | No — delegated to 3c |
| 4 | `implementation-spec.md`, `decisions.md` | No — delegated to 4 |
| 5 | `implementation-spec.md`, `implementation-log.md` | No — delegated to 5 |
| 6 | `project-plan.md`, `pipeline-state.md`, plan sub-sections | No — delegated to 6 |

**Verdict:** The pipeline's heavy reading IS properly delegated to subagents. The only main-session content-Read of any size is the model-ID precedent check at §11a.

## 4.2.6 — File writes

All large output artifacts written by subagents to disk under `projects/{name}/pipeline/`:
- `repo-snapshot.md` (3a)
- `architecture.md` (3b)
- `implementation-spec.md` (3c)
- `implementation-log.md` (4)
- `test-results.md` (5)
- `session-guide.md` (6)

Plus orchestrator writes (small, structural):
- `pipeline/sources.md`, `pipeline/decisions.md`, `pipeline/pipeline-state.md`
- `projects/{name}/.claude/shared-manifest.json`, `.claude/settings.json`
- `projects/{name}/CLAUDE.md` (4 canonical sections via heredoc append)
- `projects/{name}/logs/decisions.md`

No large outputs are written to context rather than disk. PASS.

---

## Findings

### Finding 1 — HIGH — Command file size (608 lines / ~7,908 tokens)

**Issue.** `.claude/commands/new-project.md` is 608 lines / 6,083 words / ~7,908 estimated tokens. Protocol §3 thresholds (re-used here per §4.2.1 "what gets loaded at workflow start") would mark this HIGH (>300 lines). It is the single largest command file in the repo.

**Evidence.** `wc -l .claude/commands/new-project.md` → 608. `wc -w` → 6,083.

**Loading semantics.** This file loads into main-session context on every `/new-project` invocation and remains in context for the duration of the orchestration session (across all 6 stage spawns, since the orchestrator must persist to gate between stages).

**Composition (descriptive, no recommendations).** Body breakdown by approximate region:
- L1–142: First-Run scaffolding (planning workspace walk, artifact discovery, version pinning, model-ID precedent check, scaffolding sub-step 11a)
- L143–177: Continuation logic + Gate Protocol + Post-Stage-5 + Error Handling (~35 lines)
- **L207–599: Post-Pipeline Enrichment — ~392 lines / ~65% of the file.** Includes:
  - L217–225: shared-manifest template (9 lines)
  - L227–334: settings.json canonical block + jq merge procedure (108 lines; verbatim canonical JSON inline)
  - L336–365: additionalDirectories grant (30 lines, verbatim jq snippet)
  - L367–510: 4 canonical CLAUDE.md blocks (**verbatim section bodies appear twice — once in the new-file heredoc, once in idempotent-append printf strings**). Input File Handling, Commit Rules, Compaction, Session Boundaries. ~143 lines.
  - L512–549: logs/decisions.md scaffold (38 lines, heredoc template)
  - L551–595: initial sync + canonical command verification (45 lines)
- L601–609: Key Rules tail (9 lines)

**Severity:** HIGH (per protocol thresholds applied to command body; >300 lines).

### Finding 2 — MEDIUM — Verbatim duplication of canonical CLAUDE.md sections inside the command body

**Issue.** The Post-Pipeline Enrichment step (§4) inlines the same 4 canonical CLAUDE.md sections (Input File Handling, Commit Rules, Compaction, Session Boundaries) **twice in the file**: once in the new-file heredoc (L434–473) and once each in the idempotent append branches as `printf` argument strings (L483, L490, L497, L504). Effective duplication ≈ 140–150 lines of verbatim policy text inside the command file itself. Additionally, the canonical blocks are first declared in commentary form at L376–426 before being executed at L434–506, so each rule body is in the file at least twice.

**Evidence.** L376–426 declares the four canonical blocks. L434–506 then repeats them inline (heredoc + four printf statements) as the actual implementation.

**Waste mechanism.** Every `/new-project` invocation loads this duplication into main-session context — the rule bodies live separately in workspace `CLAUDE.md` and would normally be referenced by pointer. Rough share: 1,800–2,200 of the command's 6,083 words (~30%) are this enrichment-block duplication.

**Severity:** MEDIUM.

### Finding 3 — MEDIUM — Stage 11a model-ID precedent Read happens inline in main session

**Issue.** Step 11a (L153) instructs the main-session orchestrator to `Read projects/buy-side-service-plan/CLAUDE.md` to verify the canonical Opus 4.7 model identifier string before writing it into the new project's CLAUDE.md. This Read happens in the main session, not in a subagent.

**Evidence.** L153: "read `projects/buy-side-service-plan/CLAUDE.md` for the Opus 4.7 form, and the system-prompt model context for the Sonnet 4.6 1M form."

**Delegability assessment per protocol §4.2.5.** The check is mechanical: grep a single-line identifier string against a known precedent file. The target file is a project-level CLAUDE.md whose size is unknown to this audit but typically falls in the 100–300 line range. Protocol §4 flags "files over 100 lines being read in the main session when they are delegable" — this read qualifies.

**Severity:** MEDIUM (delegable read in main session; target file likely exceeds 100 lines).

### Finding 4 — MEDIUM — No enforced `/compact` breakpoints between stages

**Issue.** Six subagent spawns are gated by operator `NEXT`. The orchestrator body says (L184): "If context has grown from the prior stage, suggest `▸ /compact` before spawning." This is **conditional and advisory** ("if context has grown" / "suggest"), not an enforced breakpoint.

**Natural breakpoints that exist but are unenforced:**
- Between 3a (mechanical scan; 30-line return cap but the orchestrator still accumulated decision-recording chat from earlier setup) and 3b
- Between 3b (architecture design — opus, decision-recording chat) and 3c
- Between 4 (multi-file implementation, log accumulation) and 5
- Between 5 and 6 (or pipeline complete)

**Evidence.** L184 (Gate Protocol §NEXT): conditional suggestion only. No mandatory `/compact` step.

**Severity:** MEDIUM per protocol §4 ("No compaction instructions or breakpoints defined" → MEDIUM).

### Finding 5 — LOW — Inline jq canonical blocks (~50+ lines of verbatim glue)

**Issue.** L304–328 (settings.json merge) and L342–360 (additionalDirectories grant) embed full jq command bodies inline. Each is correct and idempotent, but loaded into the command's context-cost envelope on every invocation.

**Evidence.** L310: `CANONICAL_PERMS='{"defaultMode":"bypassPermissions",...}'` — full canonical JSON inline. L312, L314: hook command literals as escaped JSON strings inline.

**Severity:** LOW (boundary) — correctness-critical glue that is hard to externalize without breaking the "single command file" contract.

### Finding 6 — PASS / informational — Subagent return contracts compliant

**Issue.** All six pipeline agents declare ≤30-line return contracts and write full artifacts to disk. Protocol §4 HIGH threshold ("Subagent returning >200 lines") is not met by design.

**Evidence.** See §4.2.3 table — each agent file's "Return Contract" section caps at ≤30 lines.

**Severity:** PASS.

### Finding 7 — PASS / informational — Refinement multiplier within bounds

**Issue.** Protocol §4 MEDIUM threshold ("Consistent need for >3 refinement cycles") is not met. Typical runs do 6 stage spawns with 0–1 revision cycles in normal operation.

**Severity:** PASS.

---

## Severity rollup

| Severity | Count | Findings |
|---|---|---|
| HIGH | 1 | Finding 1 (command size 608 lines) |
| MEDIUM | 3 | Finding 2 (canonical-block duplication), Finding 3 (inline CLAUDE.md Read at 11a), Finding 4 (no enforced /compact breakpoints) |
| LOW | 1 | Finding 5 (inline jq) — boundary |
| PASS | 2 | Finding 6 (return contracts), Finding 7 (refinement multiplier) |

## Protocol gaps

- Protocol §4 does not define an explicit severity threshold for **command file size itself** within a workflow audit; §3 has command line-count assessment but doesn't tier by line count. I applied §1 / §2 thresholds (>300 lines = HIGH) by analogy since the protocol's general "every line loads every turn" rationale applies. Noted under §4.2.1 above.
- Protocol §4 "missing `/compact` opportunities" criterion does not specify whether an *advisory* suggestion (current L184 behavior) counts as "defined" or "absent." Interpreted as Partial → MEDIUM finding.

## Boundary findings (within ±15% of threshold)

- Finding 5 (inline jq) tagged LOW with boundary marker — sits at the edge of whether "verbatim implementation snippet inside a command file" counts as waste vs. necessary glue.
- Finding 1 (608 lines) is **not** boundary — it is 2× the >300-line HIGH threshold.
- Finding 3 (model-ID Read) has unknown target file size; if `projects/buy-side-service-plan/CLAUDE.md` is under ~115 lines, the finding flips below the 100-line "delegable" threshold and becomes boundary. Main session may verify if needed.
