---
name: country-parity-checker
description: >
  Issues a per-cluster country-parity verdict over a project-defined country
  set, flagging single-country dominance, single-country thinness, and
  region-superset evidence leakage. Use when /run-sufficiency enters its
  Phase C step. Do NOT use to classify sources or judge claim sufficiency.
model: sonnet
effort: medium
---

# Country-Parity Checker

> **Reference dependency.** This skill reads the project's country set from `reference/source-class-hierarchy.md` (project-level), specifically the `## Project Country Set` section. The hierarchy file is a project-side deliverable, not part of this skill's bundle. Until a project provides it, the skill exits at pre-flight with a remediation prompt naming the missing file or section. See the project's pipeline documentation for the unblock plan.

## Purpose

In multi-country research, evidence often leans toward one country at the expense of others, or includes a region-superset (e.g., "Nordics" when the target set is Sweden+Norway+Finland and the evidence covers Sweden+Norway+Finland+Denmark). Both cases produce claims that read as multi-country but are not. This skill catches that drift at the cluster level — before chapter draft — by emitting a per-cluster verdict against the project's declared country set.

Splitting parity-checking from synthesis preserves the four-pass principle: *the agent that judges evidence is not the agent that found it.* The verdict feeds the gate-clearance computation in `/run-sufficiency` Phase F.

## When to Use

- Invoked by `/run-sufficiency` in Phase C, once per section, after Phase A (claim-permission gate) has produced per-cluster permission tables.
- One invocation per section. Positional argument: section identifier (e.g., `1.1`).
- Re-entry: if the `.country-parity-checker.done` sentinel is present in `analysis/{section}/`, `/run-sufficiency` skips this phase. To force re-run, delete the sentinel.

## When Not to Use

- Do NOT use to classify sources (`source-class-mapper`'s job, Pass 1).
- Do NOT use to judge whether a claim is sufficiently supported (`claim-permission-gate`'s job, Pass 3 Phase A).
- Do NOT use to write the chapter (`cluster-synthesis-drafter`'s job, Pass 4).
- Do NOT hard-code a country set inside this skill — the set is project-specific and lives in `reference/source-class-hierarchy.md`.

## Inputs

| Input | Path | Required |
|---|---|---|
| Refined cluster memos | `analysis/cluster-memos/{section}/` — read **only** the refined variant, `{section}-cluster-NN-memo-refined.md` (one per cluster). The unrefined `{section}-cluster-NN-memo.md` sits in the same directory and is **not** an input to this skill. | yes |
| Claim-permission tables | `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` (one per cluster) | yes |
| Project country set | `## Project Country Set` section in `reference/source-class-hierarchy.md` | yes |

### Project country set schema

The `## Project Country Set` section in `reference/source-class-hierarchy.md` must contain:

```markdown
## Project Country Set

- target: COUNTRY_A, COUNTRY_B, COUNTRY_C    # countries in scope for this project
- region: REGION_NAME                        # the region superset name (used in PAN-{REGION}-LEAKAGE verdicts)
- region_superset: COUNTRY_A, COUNTRY_B, COUNTRY_C, COUNTRY_D    # full membership of the region superset
- thinness_threshold: 0.15                   # share-of-evidence floor below which a country is THIN (default 0.15)
- dominance_threshold: 0.60                  # share-of-evidence ceiling above which a country is DOMINANT (default 0.60)
```

Thresholds may be omitted; defaults apply if absent.

## Output

Single file: `analysis/country-parity/{section}/{section}-country-parity.md`.

Directory created on first write.

### Output schema

A frontmatter block followed by one Markdown table:

```markdown
---
section: {section identifier}
country_set: COUNTRY_A, COUNTRY_B, COUNTRY_C
region: REGION_NAME
region_superset: COUNTRY_A, COUNTRY_B, COUNTRY_C, COUNTRY_D
thinness_threshold: 0.15
dominance_threshold: 0.60
generated_at: {YYYY-MM-DD}
---

# Country-Parity Verdicts — Section {section identifier}

| Cluster | Verdict | Evidence shares (per country) | Notes & recommended remediation |
|---|---|---|---|
| {cluster ID} | {PARITY-OK | {COUNTRY}-DOMINANT | {COUNTRY}-THIN | PAN-{REGION}-LEAKAGE} | A: 0.42, B: 0.38, C: 0.20 | {one-line rationale + remediation per failing cluster} |
| ... | ... | ... | ... |
```

- **Cluster** is the cluster ID from the refined cluster memos (verbatim).
- **Verdict** is exactly one of:
  - `PARITY-OK` — all countries in the target set are within thinness/dominance thresholds.
  - `{COUNTRY}-DOMINANT` — one country exceeds the dominance threshold. Use the literal country name (e.g., `SWEDEN-DOMINANT`).
  - `{COUNTRY}-THIN` — exactly one country falls below the thinness threshold. Use the literal country name (e.g., `FINLAND-THIN`).
  - `MULTI-THIN: COUNTRY_A, COUNTRY_C` — two or more countries fall below the thinness threshold. Use one cluster row with the comma-separated list of thin countries after the `MULTI-THIN:` prefix. Do NOT emit a separate row per thin country.
  - `PAN-{REGION}-LEAKAGE` — evidence sources describe the region superset (which includes countries outside the target set). Use the literal region name (e.g., `PAN-NORDIC-LEAKAGE`).
  - `INSUFFICIENT-EVIDENCE` — the cluster has too little source attribution to compute parity (see Failure Behavior). Non-fatal; included so every cluster has a row.
- **Evidence shares** is a per-country share of the cluster's supporting evidence, summing to ≤ 1.0 (region-superset evidence may contribute fractionally; document fractional attribution in Notes).
- **Notes** carries a one-line rationale plus a recommended remediation when the verdict is not `PARITY-OK` (e.g., "Run targeted local-language search for COUNTRY_C" or "Filter Denmark-inclusive aggregate; replace with three-country count").

### Example

A realistic 3-row sample, for format calibration. Country names are illustrative — actual values come from `reference/source-class-hierarchy.md`.

Frontmatter:

```yaml
section: {section}
country_set: COUNTRY_A, COUNTRY_B, COUNTRY_C
region: REGION_X
region_superset: COUNTRY_A, COUNTRY_B, COUNTRY_C, COUNTRY_D
thinness_threshold: 0.15
dominance_threshold: 0.60
generated_at: 2026-MM-DD
```

Body:

> # Country-Parity Verdicts — Section {section}
>
> | Cluster | Verdict | Evidence shares (per country) | Notes & recommended remediation |
> |---|---|---|---|
> | CL-01 | PARITY-OK | A: 0.41, B: 0.32, C: 0.27 | All three target countries within thresholds. |
> | CL-04 | COUNTRY_A-DOMINANT | A: 0.72, B: 0.18, C: 0.10 | A dominates. Recommend targeted local-language search for B and C. |
> | CL-07 | PAN-REGION_X-LEAKAGE | A: 0.20, B: 0.18, C: 0.15, region: 0.47 | 47% of cluster evidence comes from region-superset aggregates that include COUNTRY_D. Recommend filter or replace with country-disaggregated series. |
> | CL-09 | COUNTRY_C-THIN | A: 0.45, B: 0.42, C: 0.13 | C below 0.15 threshold. Recommend targeted local-language search for COUNTRY_C. |
> | CL-12 | MULTI-THIN: COUNTRY_B, COUNTRY_C | A: 0.74, B: 0.14, C: 0.12 | Both B and C below threshold; A approaches dominance. Recommend rebalance via per-country source-class fallback. |

## Behavior

1. **Pre-flight.**
   - Verify `analysis/cluster-memos/{section}/` exists and contains at least one **refined** memo matching `{section}-cluster-NN-memo-refined.md`. If the directory is absent, or contains no file matching that refined pattern: exit with prompt naming the missing path and recommending `/run-cluster` first. A directory holding only unrefined `{section}-cluster-NN-memo.md` files does **not** satisfy this check — `/run-cluster` writes both variants into this one directory, and only the refined variant carries the claim IDs this skill reads.
   - Verify the claim-permission table directory `analysis/claim-permission/{section}/` exists and contains at least one cluster permission table. If absent: exit with prompt noting Phase A must run first (sentinel `.claim-permission-gate.done` should be present).
   - Verify `reference/source-class-hierarchy.md` exists. If absent: exit with the generic remediation prompt under Failure Behavior.
   - Verify the `## Project Country Set` section is present and parseable in the hierarchy. If absent or malformed: exit with prompt naming the expected schema.
2. **Load the country set.** Parse target, region, region_superset, and thresholds from the `## Project Country Set` section.
3. **Per cluster:**
   - Read the refined cluster memo and the matching permission table.
   - Compute per-country evidence shares from the source list and country annotations in each claim's supporting evidence.
   - Identify region-superset attributions (where the source describes the region superset but does not break out the target countries) — these contribute to the `region:` share.
   - Apply the verdict logic:
     - If `region` share ≥ thinness_threshold AND target shares cannot be cleanly disaggregated → `PAN-{REGION}-LEAKAGE`.
     - Else if any target country's share > dominance_threshold → `{COUNTRY}-DOMINANT`.
     - Else if any target country's share < thinness_threshold → `{COUNTRY}-THIN` (one verdict row per thin country, or aggregated as documented).
     - Else → `PARITY-OK`.
   - Record evidence shares, verdict, and a one-line rationale + remediation per non-OK verdict.
4. **Write the output file.** Use the exact schema above.
5. **Emit sentinel.** Write `analysis/{section}/.country-parity-checker.done` on successful completion. Do NOT emit the sentinel if any cluster failed to receive a verdict.

## Failure Behavior

- **`reference/source-class-hierarchy.md` absent.** Exit. Emit:
  > Country-parity-checker requires `reference/source-class-hierarchy.md` (project-level deliverable). File not found. The hierarchy is a project-side responsibility — consult the project's pipeline documentation for the unblock plan. Skill will be functional once the project provides the file and includes the `## Project Country Set` section.
- **`## Project Country Set` section absent or malformed.** Exit. Emit a prompt naming the expected schema (target / region / region_superset / thresholds) and pointing to the hierarchy file.
- **Cluster memos directory absent.** Exit. Emit a prompt noting `/run-cluster` must run first.
- **Phase A permission tables absent.** Exit. Emit a prompt noting `/run-sufficiency` Phase A (claim-permission-gate) must complete first.
- **A cluster has no source attribution sufficient to compute shares.** Do not invent shares. Record verdict as `INSUFFICIENT-EVIDENCE` with a one-line note explaining what's missing. This is non-fatal — continue with remaining clusters. The sentinel still emits because the verdict surface is complete (every cluster has a row).
- **Sentinel pre-exists.** If `.country-parity-checker.done` is already present, exit silently — `/run-sufficiency` re-entry semantics handle this. The skill itself is not responsible for sentinel cleanup.

## Bias Countering

- Do not interpret a cluster as `PARITY-OK` just because the source list is long. Length is not parity — distribution is.
- Do not downgrade a `PAN-{REGION}-LEAKAGE` verdict to `PARITY-OK` because the aggregate "feels close enough" to the target set. Leakage is a categorical signal, not a slider.
- Do not invent country attributions for sources whose geographic scope is unstated. Sources without clear country attribution contribute to neither a target-country share nor the region share — track them as `unattributed: {n}` in Notes, and if `unattributed/total > 0.30` flag the cluster as `INSUFFICIENT-EVIDENCE`.
- The remediation recommendation is a suggestion, not a guarantee. Do not promise "local-language search will close the gap" — say "Recommend targeted local-language search for COUNTRY_X as the next-most-likely closure."

## Runtime Recommendations

- **Model rationale.** Sonnet is sufficient — the verdict logic is rule-evaluation against numeric thresholds, not open-ended synthesis. Escalate to Opus only if cluster memos are long and source attribution requires substantial inference (e.g., implicit country signals in trade-publication titles).
- **Effort rationale.** Medium — one structured output file plus sentinel; per-cluster computation is bounded.
- **Context footprint.** Loads N cluster memos + N permission tables + 1 hierarchy file per section. Footprint scales linearly with cluster count.
- **Invocation cardinality.** One invocation per section. NOT safe to parallelize against the same section (same output file + sentinel). Safe to parallelize across different sections.
- **Model-invocation posture.** Default (enabled). Invoked by `/run-sufficiency` in a pipeline context.
- **Tool footprint.** Read + Write only. No shell, no network.

## Cross-References

- The output is consumed by `/run-sufficiency` Phase F (gate-clearance emission) — non-OK verdicts feed the NOT-SUPPORTED-ratio computation per the gate-clearance schema.
- Sibling Pass 3 skills under `/run-sufficiency`: `claim-permission-gate` (Phase A, runs first), `stop-conditions-check` (Phase D, inline in /run-sufficiency), `source-conflict-resolver` (Phase E, inline), `gate-clearance-emitter` (Phase F, inline). When `counter-search-runner` lands (a deferred remediation in some pipelines), it occupies Phase B between Phase A and Phase C.
- The project-level reference doc that unblocks this skill is `reference/source-class-hierarchy.md` (must include the `## Project Country Set` section).
- **Input-path contract (load-bearing).** The refined-memo input path is owned by two upstream sources and this skill must not restate it independently: `/run-cluster` is the **writer** (it writes both `{section}-cluster-NN-memo.md` and `{section}-cluster-NN-memo-refined.md` into `analysis/cluster-memos/{section}/`), and `reference/file-conventions.md` is the **naming registry** — its canonical row fixes the directory, and its Rule 2 (variant-suffix convention) fixes the `-refined` suffix this skill filters on. If either changes, this skill's Inputs row and pre-flight change in lockstep. Sibling `claim-permission-gate` carries the identical contract and must be updated with it.
