---
name: claim-permission-gate
description: >
  Assigns each claim a permission class (SUPPORTED / PROXY-SUPPORTED /
  ILLUSTRATIVE-ONLY / NOT-SUPPORTED) based on evidence and source-diversity,
  then caps it by the claim's risk tier (a ceiling, not a re-grade; presence-
  gated to Tier B when no tiering is present). Use when /run-sufficiency enters
  its Phase A step. Do NOT use to find evidence or write chapter prose.
model: opus
effort: high
---

# Claim-Permission Gate

> **Regime disclosure.** This skill assigns permission classes based on the evidence and source-diversity available at the time it runs. It does NOT perform disconfirming-evidence search — that is the job of `counter-search-runner`, a sibling Pass 3 phase. When the counter-search sentinel `analysis/{section}/.counter-search-runner.done` is absent, this skill emits an inline disclaimer in each per-cluster permission table noting that SUPPORTED claims were not disconfirmation-tested in this run. Downstream readers of the table see the regime explicitly.

> **Reference dependency.** This skill reads:
> - The Claim-Permission Class section in `reference/quality-standards.md` (project-level), which defines the four classes and their evidence thresholds.
> - The Source-Diversity Matrix section in `reference/quality-standards.md` (project-level), which defines the diversity rule.
>
> Both are project-side deliverables. Until a project provides them, the skill exits at pre-flight with a remediation prompt naming the missing section. See the project's pipeline documentation for the unblock plan.

## Purpose

The four-pass research workflow separates *finding* evidence (Pass 1 + 2) from *judging* whether the evidence is sufficient to support a downstream claim (Pass 3). This skill is the judgment step: per claim, per cluster, decide whether the claim is permitted, permitted-as-proxy, permitted-only-as-illustration, or not permitted at all.

The output (per-cluster permission tables) constrains Pass 4 synthesis: the `cluster-synthesis-drafter` may not state a NOT-SUPPORTED claim, and must label ILLUSTRATIVE-ONLY and PROXY-SUPPORTED claims accordingly in prose.

The principle: *the agent that found the evidence is not the agent that judges its sufficiency.* This skill embodies the judge role.

## When to Use

- Invoked by `/run-sufficiency` in Phase A, once per section, after `/run-cluster` has produced refined cluster memos with claim IDs.
- One invocation per section. Positional argument: section identifier (e.g., `1.1`).
- Re-entry: if the `.claim-permission-gate.done` sentinel is present in `analysis/{section}/`, `/run-sufficiency` skips this phase. To force re-run, delete the sentinel.

## When Not to Use

- Do NOT use to find or extract evidence (Pass 1 + 2 jobs, handled by `research-prompt-creator` / `research-extract-creator` / `transaction-table-builder`).
- Do NOT use to write chapter prose (`cluster-synthesis-drafter`'s job, Pass 4 — this skill's output constrains that step but does not perform it).
- Do NOT use to issue a country-parity verdict (`country-parity-checker`'s job, Phase C — runs after this skill in the same pipeline).
- Do NOT use to run disconfirming-evidence search (`counter-search-runner`'s job — a separate phase that, when present, follows this one).
- Do NOT hard-code the four permission classes' thresholds inside this skill — they live in the project's `reference/quality-standards.md` Claim-Permission Class section.

## Inputs

| Input | Path | Required |
|---|---|---|
| Refined cluster memos (with claim IDs) | `analysis/{section}/cluster-memos-refined/` (directory; one memo per cluster) | yes |
| Claim-Permission Class section | `reference/quality-standards.md` → `## Claim-Permission Classes` section | yes |
| Source-Diversity Matrix section | `reference/quality-standards.md` → `## Source-Diversity Matrix` section | yes |
| Per-claim-type thresholds (soft fallback) | `reference/claim-permission.md` → per-claim-type threshold table, Source-Diversity Matrix rows, defect fold-ins | no (absent/unfilled → disclosed GENERIC-BAR regime) |
| Counter-search sentinel (advisory only) | `analysis/{section}/.counter-search-runner.done` | no |
| Research plan (for the risk-tier ceiling) | from `research-plan-creator`; carries a per-question `risk-tier:` field (`A`/`B`/`C`/`D`) | no |
| Risk-Tier Model section | `reference/quality-standards.md` → `## Risk-Tier Model` section (defines the per-tier ceiling) | no (presence-gated; absent → every claim Tier B) |

The two reference sections may be in the same file or in adjacent files; the schema below states the section names this skill looks for. The research plan is **advisory and presence-gated**: if it is absent, carries no `risk-tier:` fields, or the project's `quality-standards.md` has no `## Risk-Tier Model` section, every claim binds at **Tier B** (ceiling SUPPORTED — no constraint), i.e. current uniform behaviour. Tiering is opt-in enrichment, never a breaking change. The plan's absence must NOT trigger a pre-flight exit (see Behavior step 1).

### Claim-Permission Class section schema

The `## Claim-Permission Classes` section in `reference/quality-standards.md` must define four classes with their evidence-quantity-and-quality thresholds:

```markdown
## Claim-Permission Classes

- **SUPPORTED** — {definition + evidence threshold}
- **PROXY-SUPPORTED** — {definition + evidence threshold}
- **ILLUSTRATIVE-ONLY** — {definition + evidence threshold}
- **NOT-SUPPORTED** — {definition + evidence threshold}
```

### Source-Diversity Matrix section schema

The `## Source-Diversity Matrix` section in `reference/quality-standards.md` defines the diversity rule (e.g., "≥N independent sources from ≥M distinct source classes" — exact rule is project-defined).

## Output

One file per cluster: `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` (where `NN` is the zero-padded cluster number).

Directory created on first write.

### Output schema

```markdown
---
section: {section identifier}
cluster: {cluster ID}
generated_at: {YYYY-MM-DD}
disconfirmation_tested: {true | false}
regime_note: {one-line statement of the disconfirmation regime — see Regime disclosure below}
---

# Claim-Permission Table — Section {section identifier}, Cluster {cluster ID}

> **Regime disclosure (inline).** {Disclosure text per Regime disclosure rule below.}

| Claim ID | Claim text | Supporting evidence (summary) | Source-diversity | Assigned class | Rationale |
|---|---|---|---|---|---|
| {claim ID} | {full claim text — verbatim from cluster memo} | {one-line summary of supporting evidence} | {pass / fail per diversity rule, with N sources / M classes} | {one of: SUPPORTED, PROXY-SUPPORTED, ILLUSTRATIVE-ONLY, NOT-SUPPORTED} | {one-line rationale} |
| ... | ... | ... | ... | ... | ... |
```

- **Claim ID** comes verbatim from the cluster memo (do not renumber).
- **Claim text** is the full claim (not truncated — operators must be able to audit assigned class against full text).
- **Supporting evidence** is a one-line summary listing source titles or IDs (with `→` separators for multiple).
- **Source-diversity** records the count of independent sources and distinct source classes, with `pass` or `fail` per the project's diversity rule.
- **Assigned class** is exactly one of the four permitted strings.
- **Rationale** explains the assignment in one line. For NOT-SUPPORTED, the rationale must say what is missing (e.g., "single-source; no independent corroboration"). The Rationale also records the **risk-tier binding** and any ceiling cap/flag from Behavior step 3 (free-text, additive — no new column, so the schema and any positional parser are unaffected), e.g. `Binding tier: D — hard-capped to ILLUSTRATIVE-ONLY`, `Binding tier: C — [C-CEILING-EXCEEDED — operator review]`, or `Binding tier: B (presence-gate default)`.

### Regime disclosure rule

The frontmatter `disconfirmation_tested:` field and the inline `> **Regime disclosure (inline).**` callout both reflect the actual state at run-time:

- If `analysis/{section}/.counter-search-runner.done` is present at run-time: `disconfirmation_tested: true`; regime note: `"Disconfirming-evidence search was run for this section (counter-search-runner.done present)."`
- If absent: `disconfirmation_tested: false`; regime note: `"SUPPORTED claims in this table were NOT disconfirmation-tested in this run. counter-search-runner did not execute (sentinel absent). A SUPPORTED verdict here means the positive-evidence and source-diversity thresholds were met; it does not assert that contradicting evidence was searched for and not found. Downstream synthesis should treat SUPPORTED-without-disconfirmation as one strength tier below SUPPORTED-with-disconfirmation."`

This carries the regime through to anyone reading the table, not just to the operator at run-time.

### Example

A realistic 4-row sample (cluster CL-04), for format calibration. Claim text, source titles, and rationale are illustrative. Row CL-04-4 shows the risk-tier ceiling capping an otherwise-SUPPORTED claim because a Tier-D question is load-bearing on it.

Frontmatter:

```yaml
section: {section}
cluster: CL-04
generated_at: 2026-MM-DD
disconfirmation_tested: false
regime_note: "SUPPORTED claims in this table were NOT disconfirmation-tested in this run. counter-search-runner did not execute (sentinel absent). A SUPPORTED verdict here means the positive-evidence and source-diversity thresholds were met; it does not assert that contradicting evidence was searched for and not found. Downstream synthesis should treat SUPPORTED-without-disconfirmation as one strength tier below SUPPORTED-with-disconfirmation."
```

(The `regime_note` above is the full `disconfirmation_tested: false` string verbatim from the Regime disclosure rule — inlined, not elided, so the example is copy-safe.)

Body:

> # Claim-Permission Table — Section {section}, Cluster CL-04
>
> > **Regime disclosure (inline).** SUPPORTED claims in this table were NOT disconfirmation-tested in this run. counter-search-runner did not execute (sentinel absent). A SUPPORTED verdict here means the positive-evidence and source-diversity thresholds were met; it does not assert that contradicting evidence was searched for and not found. Downstream synthesis should treat SUPPORTED-without-disconfirmation as one strength tier below SUPPORTED-with-disconfirmation.
>
> | Claim ID | Claim text | Supporting evidence (summary) | Source-diversity | Assigned class | Rationale |
> |---|---|---|---|---|---|
> | CL-04-1 | {full claim text — verbatim from cluster memo} | Source A → Source B → Source C | pass (3 sources / 3 classes) | SUPPORTED | Meets diversity threshold; recent CURRENT-tier evidence. Binding tier: B (presence-gate default). |
> | CL-04-2 | {full claim text — verbatim} | Source D | fail (1 source / 1 class) | NOT-SUPPORTED | Single-source; no independent corroboration. |
> | CL-04-3 | {full claim text — verbatim} | Source E | fail (1 source / 1 class) | ILLUSTRATIVE-ONLY | Single named example; explicitly framed as illustration, not generalization. |
> | CL-04-4 | {full claim text — verbatim} | Source F → Source G → Source H | pass (3 sources / 3 classes) | ILLUSTRATIVE-ONLY | Evidence met SUPPORTED, but Binding tier: D — hard-capped to ILLUSTRATIVE-ONLY (a Tier-D question is load-bearing on this claim). |

## Behavior

1. **Pre-flight.**
   - Verify `analysis/{section}/cluster-memos-refined/` exists and contains at least one memo. If absent: exit with prompt recommending `/run-cluster` first.
   - Verify `reference/quality-standards.md` exists. If absent: exit with the generic remediation prompt under Failure Behavior.
   - Verify both required sections (`## Claim-Permission Classes`, `## Source-Diversity Matrix`) are present and parseable in `quality-standards.md`. If either is absent or malformed: exit with prompt naming the missing section.
   - **`reference/claim-permission.md` completeness check (soft class — values-present, not heading-present).** Check whether `reference/claim-permission.md` exists AND its operative values are filled: the per-claim-type threshold table, the Source-Diversity Matrix rows, and any defect fold-ins must carry real values, not template placeholders. Distinguish *shape-present* (headings exist) from *values-present* (rows filled) — shape-only counts as unfilled. If absent or unfilled, do NOT fail pre-flight and do NOT silently default: proceed in an explicitly-disclosed **GENERIC-BAR regime** — one generic bar for all claim types, taken from `quality-standards.md`'s generic class thresholds — and emit a hard log line at entry: `claim-permission.md absent or unfilled — GENERIC-BAR regime active; no per-claim-type calibration in this run.` The operator must see that per-type calibration is off; silent fallback is the failure mode this check exists to remove.
   - Check `analysis/{section}/.counter-search-runner.done` presence to determine the regime (do not fail if absent — regime disclosure handles it).
   - Check for the research plan and the `## Risk-Tier Model` section in `quality-standards.md` to determine whether the risk-tier ceiling is active. **Do NOT fail pre-flight if either is absent** — an absent plan or absent `## Risk-Tier Model` section routes every claim to Tier B (no ceiling constraint) per step 3's presence-gate. The ceiling is opt-in; only `## Claim-Permission Classes` and `## Source-Diversity Matrix` are hard pre-flight requirements.
2. **Load the rules.** Parse the four permission classes and the diversity matrix from `quality-standards.md`. These are the only valid class names; the diversity rule is the only diversity check applied.
3. **Per cluster:**
   - Read the refined cluster memo. Identify each claim by ID and full text.
   - For each claim: summarize supporting evidence; apply the source-diversity rule; assign one of the four permission classes; write a one-line rationale.
   - **Apply the risk-tier permission ceiling (a cap, not a re-grade).** After the class above is assigned, cap it by the claim's risk tier per `reference/quality-standards.md § Risk-Tier Model`. The tier never *raises* a class — a Tier-A claim with thin evidence still lands NOT-SUPPORTED; the ceiling only bounds the top.
     - **Resolve the claim's contributing questions** from the cluster memo's provenance (the research questions feeding the finding behind this claim). Read each contributing question's `risk-tier:` value from the research plan.
     - **Binding tier = the MOST-RESTRICTIVE tier among the contributing questions** (restrictiveness order D > C > B > A). A claim load-bearing on a Tier-D question — illustrative *by construction* — must not be lifted by a co-occurring higher-tier question; that would launder illustrative evidence into a pattern claim.
     - **Apply the ceiling:** **D → hard cap** the claim to `ILLUSTRATIVE-ONLY` (no override), regardless of the assigned class. **C → advisory:** if the assigned class is stronger than `PROXY-SUPPORTED` (i.e. `SUPPORTED`), keep the assigned class but flag it in the Rationale as `[C-CEILING-EXCEEDED — operator review]` (do not silently downgrade; the operator may override). **A / B → ceiling `SUPPORTED`** (no constraint).
     - **Presence-gate (load-bearing backward-compat).** Resolve tiers *per question*, then bind. A single contributing question with an absent `risk-tier:` field defaults *that question* to Tier B — it still participates in the most-restrictive selection, so a claim resting on a Tier-D question and an un-tiered question still binds at **D**. Bind the *whole claim* at Tier B (ceiling SUPPORTED → no constraint) only when no tier is resolvable at all: no research plan, OR a `quality-standards.md` with no `## Risk-Tier Model` section, OR none of the claim's contributing questions can be resolved to plan question IDs. An un-tiered project therefore binds every claim at Tier B and runs exactly as before.
     - **Record** the binding tier and any cap/flag in the Rationale column — e.g. `Binding tier: D — hard-capped to ILLUSTRATIVE-ONLY`, `Binding tier: C — [C-CEILING-EXCEEDED — operator review]`, or `Binding tier: B (presence-gate default)`. The four permission-class names, thresholds, verb lists, and gate semantics (§ Claim-Permission Classes) are unchanged — the ceiling is the single point of contact, a cap.
   - Write the per-cluster permission table file with the schema above. Both frontmatter `disconfirmation_tested:` and the inline regime disclosure must reflect the actual run-time state from step 1's sentinel check.
   - **Progress tracking (per cluster).** After each cluster's table is written, emit a one-line progress marker to chat (e.g., `cluster-04: 12 claims classified, table written`). With N clusters processed in sequence, this makes a partial failure visible *before* the step-4 sentinel decision — the operator can see which clusters completed if the run halts mid-section.
4. **Emit sentinel.** Write `analysis/{section}/.claim-permission-gate.done` on successful completion. Do NOT emit the sentinel if any cluster failed to produce a permission table.
5. **Report the tier and calibration regimes.** In a brief end-of-run summary to chat, state (a) whether the risk-tier ceiling was **active** (research plan + `## Risk-Tier Model` both present — caps applied per claim) or **inactive** (one or both absent — every claim bound at Tier B, no constraint), and (b) whether per-claim-type calibration was **active** (`reference/claim-permission.md` present and filled) or the run used the **GENERIC-BAR regime** (absent/unfilled — one generic bar for all claim types). This mirrors the regime-disclosure principle: make the regime visible, do not let it be silent.

## Failure Behavior

- **`reference/quality-standards.md` absent.** Exit. Emit:
  > Claim-permission-gate requires `reference/quality-standards.md` (project-level deliverable) with `## Claim-Permission Classes` and `## Source-Diversity Matrix` sections. File not found. Consult the project's pipeline documentation for the unblock plan.
- **Required section(s) absent or malformed.** Exit. Emit a prompt naming the specific missing section and pointing to the file.
- **Cluster memos directory absent.** Exit. Emit a prompt noting `/run-cluster` must run first.
- **A claim has no supporting evidence at all.** Assign NOT-SUPPORTED with rationale "No evidence in cluster memo." Continue with remaining claims.
- **A claim's supporting evidence cannot be parsed.** Do not invent. Assign NOT-SUPPORTED with rationale naming the parse failure. Continue.
- **A cluster has zero claims.** Skip the cluster — do not write an empty table. Note the skipped cluster in a brief end-of-run summary to chat.
- **Research plan / `## Risk-Tier Model` section absent, or a claim's contributing questions cannot be resolved.** Do NOT exit. Bind the affected claim(s) at Tier B (ceiling SUPPORTED → no constraint) and continue. The risk-tier ceiling is opt-in; its inputs being absent is the normal un-tiered case, not an error.
- **Sentinel pre-exists.** Exit silently — `/run-sufficiency` re-entry semantics handle this.

## Bias Countering

This skill is the choke point that converts "we have evidence" into "we may state a claim." The dominant failure mode is over-permission — issuing SUPPORTED when the evidence is thinner than it appears. Counter:

- A long evidence list is not the same as diverse evidence. Apply the diversity rule literally, not by gestalt.
- It is acceptable — and expected — to assign NOT-SUPPORTED to claims that "feel right" but lack independent corroboration. Forcing a permission upward is the failure mode this gate exists to prevent.
- Symmetrically: do not assign NOT-SUPPORTED when the diversity rule is in fact met. Under-permission silently starves Pass 4 of legitimate claims and is harder to detect downstream than over-permission. Apply the rule literally in both directions, not just the strict one.
- PROXY-SUPPORTED is not a softer SUPPORTED. It carries the implication that the prose must signal proxy reasoning (e.g., "GP positioning materials suggest..." rather than "Lower-mid-market PE creates value via..."). Reserve PROXY-SUPPORTED for claims that genuinely need that signaling.
- ILLUSTRATIVE-ONLY is not a softer PROXY-SUPPORTED. It carries the implication that the claim is an example, not a generalization. Reserve for true exemplars.
- Do NOT compensate for absent counter-search by tightening SUPPORTED thresholds. The regime disclosure does the right thing — make the regime visible, then judge against the rule as written. Tightening rules silently is the inverse failure mode.
- The risk-tier ceiling **caps, it never raises.** Do not let a high tier (A) lift a thin-evidence claim above what the diversity rule earns — the tier sets the *ceiling*, the evidence still sets the *floor*. Assign the class on evidence first, then apply the cap.
- For a Tier-C claim graded above the ceiling, **surface the advisory flag — do not silently downgrade.** A silent C-downgrade is the same hidden-judgment failure mode as silently tightening thresholds: record `[C-CEILING-EXCEEDED — operator review]` in the Rationale and let the operator decide. The D hard cap is the only tier that downgrades without an override, and it is recorded in the Rationale every time.
- For the per-claim rationale, prefer specific language ("single-source; no independent corroboration") over generic ("insufficient"). Operators audit the gate by reading rationales.

## Runtime Recommendations

- **Model rationale.** Opus is required because the assignment is judgment under ambiguity: distinguishing PROXY-SUPPORTED from ILLUSTRATIVE-ONLY, or SUPPORTED from PROXY-SUPPORTED, on per-claim evidence requires the most capable model. Do not downgrade to Sonnet — under-judgment here propagates into chapter prose.
- **Effort rationale.** High — per-claim deliberation against thresholds.
- **Context footprint.** Loads N cluster memos + 1 reference file per section. Cluster memos may be substantial (claim text + evidence summaries). Expect highest per-section footprint of any Pass 3 sub-agent.
- **Invocation cardinality.** One invocation per section. NOT safe to parallelize against the same section (sentinel + N output files). Safe to parallelize across different sections.
- **Model-invocation posture.** Default (enabled, `disable-model-invocation` not set). Invoked by `/run-sufficiency` in a pipeline context.
- **`paths` frontmatter — not set, deliberately.** This skill is invoked positionally by `/run-sufficiency` (Phase A) with the section identifier as its argument, not path-triggered; there is no file-glob that should auto-activate it.
- **Tool footprint.** Read + Write only (`allowed-tools` not fenced — a narrow fence is unnecessary given the Read+Write-only footprint and the no-evidence-finding constraint enforced in When-Not-to-Use). No shell, no network.

## Cross-References

- The output is consumed by `/run-sufficiency` Phase F (gate-clearance emission — NOT-SUPPORTED counts feed the ratio computation) and by Pass 4 (`cluster-synthesis-drafter` reads the per-cluster tables to constrain chapter-draft claims).
- Sibling Pass 3 skills under `/run-sufficiency`: `country-parity-checker` (Phase C, runs after this skill), `stop-conditions-check` (Phase D, inline), `source-conflict-resolver` (Phase E, inline), `gate-clearance-emitter` (Phase F, inline). When `counter-search-runner` is present, it runs as Phase B between this skill (Phase A) and country-parity-checker (Phase C).
- The project-level reference doc that unblocks this skill is `reference/quality-standards.md` (must include `## Claim-Permission Classes` and `## Source-Diversity Matrix` sections; it may **optionally** include a `## Risk-Tier Model` section, which activates the per-claim risk-tier ceiling — absent it, every claim binds at Tier B).
- Upstream: `research-plan-creator` produces the per-question `risk-tier:` field this skill reads for the ceiling. Sibling `cluster-memo-refiner` Check 9 applies the same deterministic most-restrictive ceiling in its (first-pass) refinement table; this skill's authoritative Pass-3 table supersedes it at the shared path. Both use the same chassis rule (`§ Risk-Tier Model`), so they agree by construction.
- The disconfirmation-regime contract is the load-bearing coupling between this skill and `counter-search-runner`: when counter-search runs, downgrade recommendations apply back to this skill's output tables before Phase C; when it does not run, the regime disclosure documents the gap.
