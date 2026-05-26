---
friction-log: true
model: opus
---
Pass 3 sufficiency check — claim-permission gate, country-parity check, stop-conditions, source-conflict resolution, gate-clearance emission. Runs after `/run-cluster` and before `/run-analysis` or `/run-synthesis`. The gate-clearance file produced here is the hard pre-flight input that Pass 4 reads at Step 0; without it, `/run-analysis` and `/run-synthesis` refuse to run.

**Positional argument:** Section identifier (e.g., `1.1`). Must match an existing `/analysis/{section}/cluster-memos-refined/` directory.

**Architecture.** This command orchestrates five phases (A, C, D, E, F). The labeling skips B intentionally — the position is reserved for a disconfirming-evidence search step (`counter-search-runner`) that is deferred in this slimmed pipeline. The skipped position preserves the canonical phase labels so a later bundle can land Phase B without renumbering.

Skill loading: For each phase below that delegates to a sub-agent skill, read the skill file from `/ai-resources/skills/[skill-name]/SKILL.md` and follow its instructions. Pass the section identifier and required paths.

---

### Step 0 — Pre-flight

Verify all of the following before launching any phase. If any check fails, exit with the specific remediation prompt listed below and do NOT launch any phase. The command never silently degrades.

**Required project artifacts (read-only inputs):**

1. **Refined cluster memos** at `/analysis/{section}/cluster-memos-refined/` — must contain at least one memo. If absent:
   > `/run-sufficiency` requires refined cluster memos at `/analysis/{section}/cluster-memos-refined/`. Run `/run-cluster {section}` first, then re-invoke `/run-sufficiency {section}`.

2. **Source-class hierarchy** at `reference/source-class-hierarchy.md` — must exist and contain a parseable `## Project Country Set` section. If absent or malformed:
   > `/run-sufficiency` requires `reference/source-class-hierarchy.md` (project-level deliverable) including a `## Project Country Set` section with target / region / region_superset / thresholds. The hierarchy is a project-side responsibility — consult the project's pipeline documentation for the unblock plan, including the expected land date for this reference doc. Without it, sub-agent skills (source-class-mapper, country-parity-checker) cannot run.

3. **Quality-standards rule sections** at `reference/quality-standards.md` — must contain both `## Claim-Permission Classes` and `## Source-Diversity Matrix` sections (project-defined). If either is absent or malformed:
   > `/run-sufficiency` requires `reference/quality-standards.md` to include `## Claim-Permission Classes` and `## Source-Diversity Matrix` sections (project-level definitions). Consult the project's pipeline documentation for the unblock plan and expected land date.

4. **Known-limits reference (if defined by the project)** at `reference/known-limits.md` — read-only input to Phase D stop-conditions check. If absent, Phase D proceeds without it and notes the gap inline. *Not* a fatal pre-condition.

5. **NOT-SUPPORTED ratio thresholds.** Read from `reference/quality-standards.md` — typically a per-cluster ceiling and a per-section ceiling. If thresholds are absent, Phase F exits with a remediation prompt naming the missing threshold values.

**Operator-visible unblock guidance.** When the command exits at Step 0 due to a project-level reference doc being absent, the exit message must invite the operator to consult the project's pipeline documentation for the expected land date of the missing artifact. The expected-land-date discipline (per Mitigation 3+ of the source-pipeline workflow fix) lives in project-side docs because canonical commands do not own per-project schedules. If the project provides no expected date, treat that as a signal that the deferral is drifting toward permanent debt and surface the concern to the operator.

**Optional advisory check.** Look for `analysis/{section}/.counter-search-runner.done`. If present: Phase A's claim-permission tables will record `disconfirmation_tested: true`. If absent: Phase A records `disconfirmation_tested: false` and emits the regime disclosure inline per the `claim-permission-gate` skill's contract. Step 0 does NOT treat the absence of this sentinel as a failure — it is the slimmed-pipeline default.

If all Step 0 checks pass: proceed to Phase A.

---

### Phase A — Claim-Permission Gate

Delegate to the `claim-permission-gate` sub-agent (Opus). Pass the section identifier, the cluster memos directory, and the quality-standards rule section paths.

- **Outputs:** Per-cluster permission tables at `/analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` (one per cluster, NN zero-padded).
- **Inline regime disclosure:** Each per-cluster table carries the disconfirmation regime in both frontmatter (`disconfirmation_tested:`) and as an inline blockquote at the top, per the skill's Regime disclosure rule.
- **On success:** Write sentinel `/analysis/{section}/.claim-permission-gate.done`.
- **Re-entry:** Skip Phase A if `.claim-permission-gate.done` is present at Step 0.

---

### Phase C — Country-Parity Check

Delegate to the `country-parity-checker` sub-agent (Sonnet). Pass the section identifier, the cluster memos directory, the Phase A permission table directory, and the source-class hierarchy path.

- **Outputs:** Per-section country-parity verdicts at `/analysis/country-parity/{section}/{section}-country-parity.md`.
- **On success:** Write sentinel `/analysis/{section}/.country-parity-checker.done`.
- **Re-entry:** Skip Phase C if `.country-parity-checker.done` is present at Step 0.

*(Phase B reserved for `counter-search-runner` — not implemented in this slimmed pipeline. See Architecture note above.)*

---

### Phase D — Stop-Conditions Check

Inline Opus step. Applies the project-defined stop conditions to each cluster's evidence + permission verdicts. Verifies the scarcity register has been consulted (input from Stage 2). When `reference/known-limits.md` is present, tags claims against the project's catalogued known-limit gaps; when absent, proceeds and notes the omission inline.

- **Output:** `/analysis/stop-conditions/{section}/{section}-stop-conditions.md` — per-cluster stop-condition verdict + rationale.
- **On success:** Write sentinel `/analysis/{section}/.stop-conditions.done`.
- **Re-entry:** Skip Phase D if `.stop-conditions.done` is present at Step 0.

---

### Phase E — Source-Conflict Resolution

Inline Opus step. Applies the project's source-conflict procedure to any conflict triples flagged by Phases A or C (same factual claim with two sources giving incompatible values). Records resolution decisions per triple.

- **Output:** `/analysis/source-conflicts/{section}/{section}-source-conflict-log.md`.
- **On success:** Write sentinel `/analysis/{section}/.source-conflicts.done`.
- **Re-entry:** Skip Phase E if `.source-conflicts.done` is present at Step 0.

---

### Phase F — Gate-Clearance Emission

Inline Opus step. Computes NOT-SUPPORTED ratios per cluster and per section from the Phase A permission tables, applies the project's thresholds (read from `reference/quality-standards.md`), and writes the gate-clearance verdict file. This file is the load-bearing artifact that Pass 4 commands read at their Step 0.

- **Output:** `/analysis/gate-clearance/{section}/{section}-gate-clearance.md` with frontmatter:
  ```yaml
  ---
  section: {section}
  generated_at: {YYYY-MM-DD}
  disconfirmation_tested: {true | false}
  per_cluster_ratios: {cluster: ratio, ...}
  section_ratio: {ratio}
  per_cluster_threshold: {threshold value}
  section_threshold: {threshold value}
  verdict: {CLEARED | CLEARED-WITH-CAVEATS | BLOCKED}
  caveats: [list of caveats if CLEARED-WITH-CAVEATS]
  ---
  ```
- **Verdict logic:**
  - `BLOCKED` — any cluster's NOT-SUPPORTED ratio exceeds the per-cluster threshold, OR the section's ratio exceeds the section threshold.
  - `CLEARED-WITH-CAVEATS` — all ratios within thresholds AND any of: (a) `disconfirmation_tested: false`, (b) any cluster's verdict from Phase C is non-OK, (c) any conflict triple in Phase E was resolved with operator-deferred status.
  - `CLEARED` — all ratios within thresholds AND none of the caveat conditions above.
- **On success:** Write sentinel `/analysis/{section}/.gate-clearance.done`.
- **Re-entry:** Skip Phase F if `.gate-clearance.done` is present at Step 0.

---

### Stop condition (command-level)

Gate-clearance file written with all per-cluster and section-level verdicts populated; all five sentinels present in `/analysis/{section}/`. Report the verdict + per-cluster ratios to chat and exit.

### Failure modes

- Missing refined cluster memos at Step 0 → exit with the Step 0 remediation prompt.
- Sub-agent failure mid-phase → command exits with partial state preserved; completed sentinels stay; re-invocation skips already-completed phases.
- Threshold edits in `reference/quality-standards.md` between invocations → command re-emits gate-clearance on next invocation; downstream Pass 4 re-reads on its pre-flight (no migration step needed — gate-clearance is a derived artifact).
- A `claim-permission-gate` verdict the operator disputes → operator edits the affected `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` directly; deletes the `.claim-permission-gate.done` sentinel to force re-emission on next invocation; the rationale for the dispute is logged to `/logs/decisions.md`.

### Re-entry semantics (summary)

Each phase is skip-on-sentinel-present. To force re-run of a specific phase, delete its sentinel. To force a full clean run, delete all `.{phase}.done` files in `/analysis/{section}/`. The command does NOT auto-clean stale sentinels — that responsibility is the operator's, to avoid silent stale-state risks.

### Operator-override on `BLOCKED` verdict

If Phase F emits `BLOCKED`, the operator may manually override by editing `/analysis/gate-clearance/{section}/{section}-gate-clearance.md` and setting `verdict: OPERATOR-OVERRIDE` with a signed rationale in a new `override_rationale:` field. Pass 4 commands accept `OPERATOR-OVERRIDE` as equivalent to `CLEARED-WITH-CAVEATS`, attach the override rationale to the synthesis brief, and auto-log the override to `/logs/decisions.md` on next invocation. Override is per-section; it does not propagate to other sections.
