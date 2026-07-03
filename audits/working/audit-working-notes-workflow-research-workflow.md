# Section 4 — Workflow Token Efficiency Audit: research-workflow

**Auditor:** token-audit Section 4 executor (fresh context). **Executed:** 2026-07-03.
**Supersedes** a stale prior copy at this path dated 2026-05-18 (its line counts — CLAUDE.md 128, run-execution 187, produce-prose-draft 212, "29 commands", "4 reference files" — no longer match the current tree; the workflow has since grown to 155 / 204 / 244 lines, 31 commands, 16 reference files, and gained `run-sufficiency`).
**AUDIT_ROOT:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow scope:** `workflows/research-workflow/` (CLAUDE.md, `.claude/commands/`, `.claude/agents/`, `reference/` library, bundled skills).
**Protocol:** token-audit-protocol.md v1.3, Section 4 (Steps 4.1, 4.2) + header token-estimation caveat.
**Telemetry:** NONE. `usage/` holds only `.gitkeep`; no `session-notes`/`usage-log` files exist in AUDIT_ROOT. **All "typical run", session-count, refinement-multiplier, and return-size figures are STRUCTURAL INFERENCES from command instructions + file line counts, not observed data.**
**Token proxy:** word × 1.3 (±30% drift). Findings within ±15% of a line-count threshold tagged `(boundary)`.

---

## Step 4.1 — Workflow identification

`find . -name "*workflow*"` + tree walk: exactly ONE active workflow under `workflows/` — **research-workflow**. This single audit is the complete active-workflow set (per launching agent). No ranking needed (< 4 candidates).

Surface (measured `wc -l -w`):
- `CLAUDE.md` — 155L / 1611w (~2094 tok). TEMPLATE (`{{placeholders}}`).
- `.claude/commands/` — **31 files**, 2686L / 27,108w.
- `.claude/agents/` — 4: execution-agent (29L), improvement-analyst (88L), qc-gate (52L), verification-agent (40L).
- `reference/` — 16 non-gitkeep files, 1978L / 21,992w. Largest: stage-instructions.md (211L/4751w ~6176 tok), quality-standards.md (260L/3515w ~4570 tok), stage-5-common-phases.md (173L), file-conventions.md (145L). Bundled skills: knowledge-file-producer (135L), report-compliance-qc (113L). SOPs: research-executor-gpt (153L), evidence-pack-compressor (146L), fact-verification-prompt (30L).
- `docs/` — project-config-schema (149L), required-reference-files (97L). `SETUP.md` 194L.
- `.claude/settings.json` Read-deny rules present: `archive/**`, `**/*.archive.*`, `logs/*-archive-*.md`, `**/deprecated/**`, `**/old/**` (context-load protection; not a Section-4 severity item).

Heaviest commands (`wc -l`): produce-prose-draft 244, session-plan 226, run-execution 204, run-analysis 199, produce-formatting 154, audit-structure 148, run-sufficiency 129, run-report 117, consult 108, run-preparation 107, produce-architecture 101.

Pipeline (CLAUDE.md + stage-instructions.md): Five stages — Preparation → Execution (four-pass P1+P2) → Analysis & Gap Resolution (P3+P4) → Report Production → Final Production. Stage-3 split across `run-cluster` + `run-sufficiency` + `run-analysis` + `run-synthesis`. Stage-5 via `produce-*`.

---

## Step 4.2 — Token-flow map

### 1. Context loading chain (structural inference)

Entry: operator opens project → `/prime` (sonnet) → a stage command.

1. **Workflow `CLAUDE.md` auto-loads** — ~2094 tok. Deliberately REPEATS canonical workspace rules for standalone opens: Input File Handling (L115–126), File Verification & Git Commits (L128–133), Commit Rules (L134–140) — ~40 duplicated lines. Context cost, but a Section-1 concern; noted, no Section-4 severity.
2. **`/prime`** — 234w ≈ ~304 tok + reads last session-notes entry + latest checkpoint (small). Explicitly executes NO pipeline command (good — no cascade).
3. **Stage command**, e.g. `/run-report` — 1824w ≈ ~2371 tok shell + **Step 4.0 bulk operand reads** (all chapter drafts + all extracts + all cluster memos + all directives + scarcity + editorial recs — variable, section-dependent, the DOMINANT/unbounded driver).
4. **On-demand reference reads** at stage entry: stage-instructions.md (~6176 tok), quality-standards.md (~4570 tok). CLAUDE.md L58 instructs "Only load these when actively working on the relevant stage" — good hygiene, keeps refs out of baseline.

**Total est. start-of-workflow context** (CLAUDE.md + /prime + one stage-command shell, BEFORE bulk operand reads): ~2094 + ~304 + ~2371 ≈ **~4,800 tok** scaffolding; **+ ~6,176 tok** if stage-instructions loaded → **~11,000 tok**; **+ Step 4.0 bulk operand reads** (section-dependent). All structural inference.

### 2. Subagent call count (design)

Every stage command is subagent-driven. Delegate/subagent mention counts: run-execution 29, produce-prose-draft 24, run-report 20, produce-formatting 18, run-analysis 17, run-preparation 15, run-cluster 9, produce-architecture 8. Agents wired: **qc-gate** (6 commands), **qc-reviewer** (3), **execution-agent** (1: verify-chapter St4), **verification-agent** (1: workflow-status St7), **improvement-analyst** (1: improve), **refinement-reviewer** (1: refinement-pass), + many `general-purpose`. run-report carries an explicit per-dispatch `model` override (opus/sonnet 200K) to avoid the 1M-context usage-credit gate. Structural inference: a typical multi-cluster/multi-chapter section run exceeds ~40 subagent launches across the pipeline.

### 3. Output volume — see subagent-pattern table.
### 4. Refinement cycles — see M3.

### 5. File-read map (necessary vs delegable)

| File | Size | Read in main/subagent | Necessary / Delegable | Command/step |
|------|------|-----------------------|-----------------------|--------------|
| `reference/quality-standards.md` | 260L | **main** → content-passed to each parallel cluster subagent (×N) | **Delegable** (path-passable per workflow carve-out) → H4 | run-cluster St2.2 |
| `reference/source-class-hierarchy.md` | 106L `(boundary)` | **main** → content-passed | **Delegable** → H4 | run-cluster St2.2; run-execution St2.1 |
| `reference/known-limits.md` | 105L `(boundary)` | **main** → content-passed | **Delegable** → H4 | run-cluster St2.2; run-execution St2.3 |
| `reference/quality-standards.md` | 260L | **main** → content-passed to prompt/extract subagents | **Delegable** → H4 | run-execution St2.1, St2.3 |
| `quality-standards.md`, `style-guide.md` | 260L, 35L | **subagent by PATH** (FX-C1 carve-out) | Correct path-pass (PASS) | run-report 4.2a/b/c |
| `context/prose-quality-standards.md`, `style-reference.md` | ~1200L (project) | **subagent by PATH** | Correct path-pass (PASS) | produce-prose-draft Ph2/3 |
| all chapter drafts + all extracts + all memos + all directives + scarcity + editorial recs | aggregate large | **main** (St4.0), content-passed | Isolation-mandated operand content-pass; subagent-capable → H3 | run-report St4.0 |
| architecture + scarcity + all directives + editorial recs + all chapter drafts | aggregate large (overlaps St4.0) | **main** (St4.1b re-read) | Redundant re-read overlap → H3 | run-report St4.1b |
| all refined cluster memos | aggregate large | **main** (St1), held across St2/4/5/5b/5c | Operand content-pass → H3 | run-analysis St1 |
| all refined memos + all directives | aggregate large | **main** (St1) | Operand content-pass → H3 | run-synthesis St1 |
| all raw research reports | large (multi-thousand-word GPT/Perplexity) | **main** (St2.3), content-passed to extract subagents | Operand content-pass; sheds via /compact St2.3.8 → H3 | run-execution St2.3 |
| all section drafts | large | **main** (Ph2 AND Ph3 — double-read) | Operand content-pass; double intra-command read → H3 | produce-architecture Ph2, Ph3 |
| each `[skill]/SKILL.md` | 100–260L | **main** every delegated step, then content-passed | Isolation-mandated (qc-gate never reads skill itself) → M4 | all run-* / produce-* |
| operator-pasted raw research output | large | **main** (chat paste) | Necessary (external evidence intake, manual) | run-execution St2.2b |
| last session-notes entry + latest checkpoint | small | main | Necessary | prime |

### 6. File-write map (Q6)

Outputs go to DISK, not context: checkpoints (target < 500 tok, CLAUDE→stage-instructions Strategy 1), memos, drafts, verdicts, permission tables, gate-clearance, sentinels. **No large-output-to-context anti-pattern.** Subagent-to-disk is the default (Strategy 3). Strong write discipline (PASS).

---

## Subagent-pattern table

| Subagent purpose | Command/step | Returns to main? | Return size est. | Disk-write? |
|-----------------|--------------|------------------|------------------|-------------|
| evidence-to-report-writer (chapter prose) | run-report 4.2a | **FULL chapter draft content** | **>200L (struct. inf.; `(boundary)` if chapters ~200L)** → H1 | No — main writes at 4.2d |
| execution-agent (GPT-5/Perplexity API) | verify-chapter St4 | **FULL response verbatim** (agent L19,24) | **>200L (fact-verif over full chapter)** → H2 | Yes (L28) — return DUPLICATES disk |
| chapter-prose-reviewer | run-report 4.2b | verdict + findings + changes | ~50–150L (sub-200) → M5 | No — main writes review at 4.2d |
| report-compliance-qc (qc-gate) | run-report 4.2c | verdict + per-item findings | ~50–150L (sub-200) → M5 | No — main writes at 4.2d |
| qc-gate (all delegate-qc steps) | run-preparation 1b/3b/5, run-execution 2.1b/2.4, run-analysis 5c, run-report 4.1b, run-sufficiency… | verdict + findings (qc-gate is **Read-only**, cannot Write) | bounded, sub-200; ALWAYS transit main → M5 | No — main writes verdict |
| qc-reviewer / refinement-reviewer | qc-pass, refinement-pass | full review "exactly as returned" | bounded, sub-200 → L2 | No (operator-presented) |
| verification-agent | workflow-status St7 | full independent analysis + comparison | bounded (health check) → L3 | No disk-write instruction |
| cluster-synthesis-drafter | run-synthesis St2 | **path + structure summary + coverage** | small (PASS — contrast H1, same artifact class) | Yes — writes draft |
| cluster-analysis-pass + memo-refiner | run-cluster St2 | paths + themes + check outcomes + gaps | small (PASS) | Yes — writes memos |
| research-structure-creator | run-report 4.1 / produce-architecture Ph2 | section count + mapping + flags + allocations | small (PASS) | Yes |
| chapter-revision-applier / citation-converter | run-report 4.2f/4.2j | revised path + markers; citation count + CTL | small (PASS) | Yes |
| gap-assessment/section-directive/memo-review/editorial-recs/editorial-qc | run-analysis 2/4/5/5b/5c | path + structured summary | small (PASS) | Yes |
| execution-manifest/prompt-creator/extract-creator/extract-verifier | run-execution 2.0/2.1/2.3/2.4 | routing table / session plan / inventory / verdicts | small (PASS) | Yes |
| task/research-plan/answer-spec creators | run-preparation 1/3/4 | path + scope/RQ/spec inventory | small (PASS) | Yes |
| produce-prose-draft Phase 3 review | produce-prose-draft Ph3 | **"no more than 20 lines", fixed fields** | capped (EXEMPLAR) | Yes — working file |
| produce-formatting Ph2/3 | produce-formatting | Output-to-disk full report; capped summary | capped (EXEMPLAR) | Yes |
| decontamination / jargon-gloss | stage-5-common-phases | change counts + flags | small (PASS) | Yes |
| claim-permission-gate / country-parity-checker | run-sufficiency A/C | writes tables + sentinel; verdict/ratios to chat | small (PASS) | Yes |

---

## /compact breakpoint coverage (Q3)

| Command | `/compact` count | Note |
|---------|------------------|------|
| run-analysis | 7 | per-step — good |
| run-execution | 6 | per-step + 2.S — good |
| run-preparation | 4 | per-step — good |
| produce-prose-draft | 4 | per-phase — good |
| run-report | 3 | 4.1, 4.1b, per-chapter 4.2k — adequate |
| produce-architecture | 2 | per-phase — good |
| run-synthesis | 2 | adequate |
| produce-formatting | 2 | good |
| verify-chapter | 2 | good (St6 fires AFTER execution-agent return — see H2) |
| review-chapter, session-plan | 1 each | — |
| **run-cluster** | **0** | **M1** — no breakpoint after reading 3 reference docs + N-way fan-out |
| **run-sufficiency** | **0** | **M2** — no breakpoint across 5-phase (A/C/D/E/F) orchestration |

CLAUDE.md L142–149 Compaction section advocates scratchpad + `/clear` restart over lossy auto-summarization at the workflow level; per-command `▸ /compact` enforcement is strong in most commands and absent in run-cluster and run-sufficiency.

---

## Findings

| # | Finding | Severity | Waste mechanism |
|---|---------|----------|-----------------|
| H1 | `run-report` St4.2a: `evidence-to-report-writer` instructed `Return: chapter draft content, ...` — the FULL chapter draft transits main; main writes it to disk at 4.2d. Sibling `run-synthesis` St2 (same artifact class) has the subagent write to disk and return only `path + structure summary` — 4.2a does not adopt that pattern. | **HIGH** | Full-output subagent return (>200L struct. inf.) into main; `(boundary)` if a project's chapters run ~200L. |
| H2 | `execution-agent.md` L19+L24: `Return the full response content` + "Interpret or summarize the response — return it verbatim" [summarizing prohibited]. Wired via `/verify-chapter` St4 (fact-verification report over a full chapter). Agent ALSO writes response to disk (L28); `/compact` at verify-chapter St6 fires only AFTER the full return has landed in main. | **HIGH** | Full verbatim API response (>200L struct. inf.) returned to main; duplicates disk write. |
| H3 | Large delegable OPERAND reads relayed through main (isolation-rule content-pass). Instances: `run-report` St4.0 (six large categories: all chapter drafts + all extracts + all memos + all directives + scarcity + editorial recs) and St4.1b (explicit re-read overlapping St4.0); `run-analysis` St1 (all refined memos, held across St2/4/5/5b/5c); `run-synthesis` St1 (all memos + all directives); `run-execution` St2.3 (all raw research reports); `produce-architecture` Ph2 AND Ph3 (all section drafts — double intra-command read). Each is a large (>100L aggregate) main read; the isolation rule mandates content-passing operands (path-passing carve-out covers reference docs only), but subagents have Read access and could path-read. Per-step `/compact` mitigates partially. | **HIGH** | Main-session content-relay of operand bundles + re-reads; large delegable reads per protocol Q5. |
| H4 | Large delegable REFERENCE reads content-passed where the workflow's OWN Context Isolation carve-out (stage-instructions.md L194) sanctions path-passing. `run-cluster` St2.2 reads `quality-standards.md` (260L), `source-class-hierarchy.md` (106L `(boundary)`), `known-limits.md` (105L `(boundary)`) into main and content-passes ALL THREE to EACH parallel cluster subagent (duplicated ×N clusters). `run-execution` St2.1 (source-class-hierarchy 106L + quality-standards 260L) and St2.3 (quality-standards 260L + known-limits 105L) do the same. `run-report`/`produce-*` already path-pass these exact docs. | **HIGH** | Large delegable reference reads in main + N-way content duplication where path-passing is available and used elsewhere. |
| M1 | `run-cluster.md` — ZERO `▸ /compact` directives, despite reading 3 reference docs + a cluster map + collecting N subagent summaries in main. No compaction breakpoint defined. | **MEDIUM** | No compaction breakpoint; reference-doc content persists unshed. |
| M2 | `run-sufficiency.md` — ZERO `▸ /compact` directives across its 5-phase (A/C/D/E/F) orchestration; inline phases D/E/F read Phase A permission tables in main with no shed between phases. | **MEDIUM** | No compaction breakpoints in a multi-phase orchestration command. |
| M3 | **Refinement multiplier >3 by design** (structural inference): a full section run designs for >3 QC/refinement cycles — Stage-1 research-plan QC + answer-spec-qc (re-run on Moderate); Stage-2 research-prompt-qc (1 retry) + up-to-2 re-extraction passes + optional 2 supplementary passes; Stage-3 6-check memo refinement + editorial-recs-qc + Path-A/Path-B gap loops; Stage-4 prose-reviewer + compliance-qc + revision-applier per chapter; Stage-5 integration-qc + prose Phase-3 review (+fix agent) + formatting-qc. Also designs ~7–8 stage-boundary SESSIONS per section (explicit "start a new session" gates: run-analysis→run-synthesis→run-report). Standalone `/qc-pass`, `/refinement-pass`, `/verify-chapter`, `/review-chapter` add further passes. | **MEDIUM** | Protocol rule: >3 refinement cycles → MEDIUM. BY-DESIGN (four-pass evidence-sufficiency + independent-QC discipline), not observed re-work churn; token cost real. |
| M4 | Skill-content-into-main is pervasive: EVERY delegated step reads `[skill]/SKILL.md` into main, then content-passes it (qc-gate agent "never reads skill files itself" — L43; verification is content-passed per isolation rule L194). Skill files run 100–260L. Per-step `/compact` mitigates. `produce-prose-draft`/`run-report` path-pass reference docs, but skill content is always content-passed. (Skill sizes partly outside workflow-file scope.) | **MEDIUM** | Isolation-mandated skill content-passing loads each skill into main before delegation. |
| M5 | `qc-gate` is a **Read-only** agent (no Write tool) — so EVERY `delegate-qc` verdict (run-preparation 1b/3b/5, run-execution 2.1b/2.4, run-analysis 5c, run-report 4.1b/4.2c, run-sufficiency phases, etc.) returns its findings into main, which then writes the verdict to a checkpoint. Individually bounded (sub-200L findings lists), but systematically transit main across ~15+ QC steps per section. Includes run-report 4.2b (chapter-prose-reviewer) full findings return. | **MEDIUM** | Read-only QC agent forces all verdicts through main context; aggregate over many steps. |
| L2 | `refinement-pass.md` / `qc-pass.md`: "Show the subagent's review to the operator exactly as returned." Full reviewer output enters main for operator presentation; bounded review size, sub-200 typical. | **LOW** | By-design full-return-to-operator; bounded. |
| L3 | `verification-agent` (wired via `/workflow-status` St7): returns full independent analysis + comparison to main with no disk-write instruction. Bounded (health-check context, low frequency). | **LOW** | Full analysis return, no disk-write; bounded. |

**Totals: 11 findings — HIGH 4, MEDIUM 5, LOW 2.**

### PASS observations (facts; no Section-4 severity)
- File-write discipline (Q6): outputs to disk; checkpoints capped < 500 tok; no large-output-to-context anti-pattern.
- Subagent-to-disk + capped-summary is the DEFAULT across most commands. Exemplars: produce-prose-draft Phase 3 ("no more than 20 lines", fixed fields), produce-formatting Ph2/3 (Output-to-disk), run-analysis (all steps: path + structured summary), run-synthesis St2 (path + summary, NOT full draft — the correct contrast to H1), run-preparation (all steps), produce-architecture, stage-5-common-phases.
- CLAUDE.md L58 enforces on-demand reference loading (keeps stage-instructions/quality-standards out of baseline).
- run-report per-dispatch model override prevents 1M-context usage-credit stalls.
- FX-C1 carve-out (run-report, produce-prose-draft) path-passes large reference docs correctly — the pattern H4 fails to apply in run-cluster/run-execution.

---

## Protocol gaps / ambiguities (best-interpretation notes for Section 10)

1. **"delegable → HIGH" applied literally.** The protocol (Q5 + severity) rates large main-session reads that "could be delegated" as HIGH. I applied this to operand bulk-reads (H3) and reference-doc content-passing (H4) because subagents have Read access and CAN path-read — the workflow's Context Isolation Rule is the *reason* they aren't delegated, i.e. the waste MECHANISM, not a severity reducer. Whether the isolation rule's independence benefit justifies the token cost is a Section-9 synthesis judgment, not a Section-4 fact. A reviewer who treats the isolation rule as making these reads "not delegable" would downgrade H3/H4 to MEDIUM — flagged for Section 10 confidence.
2. **No telemetry.** `usage/` empty; no session-notes/usage-log in AUDIT_ROOT. Every "typical run", session-count, refinement-multiplier, subagent-count, and return-size figure is a STRUCTURAL INFERENCE from instructions + line counts.
3. **CLAUDE.md is a template** (`{{placeholders}}`). Loading-chain token estimates use template word counts; a filled project CLAUDE.md (Project Config populated) would be larger.
4. **Return-size estimates** (H1 chapter drafts, H2 API responses) use word×1.3 against typical artifact sizes with no measured proxy — ±30% drift + artifact-size variance. Small-chapter projects could put H1/H2 return sizes near the 200-line boundary; return cells `(boundary)`-noted, findings held at HIGH.
5. **106L / 105L reference docs** (source-class-hierarchy, known-limits) fall in 85–115 (±15% of the 100-line flag threshold) → `(boundary)` in H3/H4. quality-standards.md (260L) is clear of the boundary.
6. **Prior audit reconciliation.** The stale 2026-05-18 copy at this path reported 18 findings (6 HIGH / 9 MEDIUM / 3 LOW) using superseded line counts. This fresh audit re-measured everything, consolidated same-mechanism instances (operand bulk-reads → one H3; reference content-pass → one H4), and added findings the prior missed: execution-agent verbatim full-return (H2), run-sufficiency zero-compact (M2), qc-gate Read-only forced-return pattern (M5), verification-agent (L3), and the run-synthesis St2 contrast to H1.
