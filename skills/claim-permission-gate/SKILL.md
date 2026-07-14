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
- Do NOT hard-code the four permission classes' **thresholds** inside this skill — they live in the project's `reference/quality-standards.md` § Claim-Permission Classes (the generic bar) and `reference/claim-permission.md` (per-claim-type calibration). The **class names**, by contrast, ARE canonical and fixed for every project — see the authority split in Behavior step 2. Naming them as literals in the Output schema is correct; restating their thresholds is not.

## Inputs

| Input | Path | Required |
|---|---|---|
| Refined cluster memos (with claim IDs) | `analysis/cluster-memos/{section}/` — read **only** the refined variant, `{section}-cluster-NN-memo-refined.md` (one per cluster). The unrefined `{section}-cluster-NN-memo.md` sits in the same directory and is **not** an input to this skill. | yes |
| Claim-Permission Class section | `reference/quality-standards.md` → `## Claim-Permission Classes` section | yes |
| Source-Diversity Matrix section | `reference/quality-standards.md` → `### Source-Diversity Matrix` — a **`###` nested inside** `## Claim-Permission Classes`, not a top-level `##` | yes |
| Per-claim-type thresholds (soft fallback) | `reference/claim-permission.md` → per-claim-type threshold table, Source-Diversity Matrix rows, defect fold-ins | no (absent/unfilled → disclosed GENERIC-BAR regime) |
| Counter-search sentinel (advisory only) | `analysis/{section}/.counter-search-runner.done` | no |
| Research plan (for the risk-tier ceiling) | from `research-plan-creator`; carries a per-question `risk-tier:` field (`A`/`B`/`C`/`D`) | no |
| Risk-Tier Model section | `reference/quality-standards.md` → `## Risk-Tier Model` section (defines the per-tier ceiling) | no (presence-gated; absent → every claim Tier B) |

The two reference sections may be in the same file or in adjacent files; the schema below states the section names this skill looks for. The research plan is **advisory and presence-gated**: if it is absent, carries no `risk-tier:` fields, or the project's `quality-standards.md` has no `## Risk-Tier Model` section, every claim binds at **Tier B** (ceiling SUPPORTED — no constraint), i.e. current uniform behaviour. Tiering is opt-in enrichment, never a breaking change. The plan's absence must NOT trigger a pre-flight exit (see Behavior step 1).

### Claim-Permission Class section schema

The `## Claim-Permission Classes` section in `reference/quality-standards.md` carries a **`### Four Permission Classes` table** with one row per class and the columns `Class | Conditions | Permitted prose verbs | Permitted prose framing`, followed by `### Adjudication order`, `### Permission ceilings`, and `### Evidenced Negatives vs Absence of Evidence`.

The four class names are **canonical and fixed** — `SUPPORTED`, `PROXY-SUPPORTED`, `ILLUSTRATIVE-ONLY`, `NOT-SUPPORTED`. A project may tighten the evidence bar per claim type in its `claim-permission.md`; it may not rename, add, or redefine a class (see Behavior step 2). If the parsed section presents names other than these four, treat the project chassis as corrupt or hand-edited and exit at pre-flight rather than adopting the divergent names.

> **Corrected 2026-07-14.** This schema previously described the section as a *bullet list* of four classes. The chassis has always used a **table**, so the shape stated here never matched the file the pre-flight parses. Fixed to the real shape; if the chassis table changes, this schema changes with it (see the Permission-class contract in Cross-References).

### Source-Diversity Matrix section schema

The `### Source-Diversity Matrix` subsection (nested inside `## Claim-Permission Classes`) in `reference/quality-standards.md` defines the diversity rule. It is a count of **independent evidentiary roles**, not of documents: same-origin channels collapse to ONE role (the triangulation-packets rule), and the collapse applies *across* source classes that share an underlying origin, not merely within one. The generic bar and the collapse rule are **chassis-owned**; what a project may vary is the per-claim-type threshold *on top of* them (in `claim-permission.md`) — not the rule itself.

> **Corrected 2026-07-14.** This schema previously said the "exact rule is project-defined." That contradicted the chassis's Canonical-ordering rule, which owns the diversity rule. Projects calibrate the bar; they do not author the rule.

## Output

One file per cluster: `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md` (where `NN` is the zero-padded cluster number).

Directory created on first write.

### Output schema

```markdown
---
section: {section identifier}
cluster: {cluster ID}
chassis_version: {YYYY-MM-DD — copied verbatim from the chassis-version marker read at pre-flight}
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

- **`chassis_version`** is the version marker you read at the pre-flight chassis-version gate, copied **verbatim**. It is not optional and it is not the date you ran — it is the identity of the *rules* that produced these verdicts. **This field is the outputs-side half of the chassis-version gate, and it exists for the same reason** (added 2026-07-14): the gate stops a *new* run against *old* rules, but says nothing about a table already on disk. A permission table is a set of confident class verdicts; without this field nothing downstream can tell whether they were graded by a rule set since found to have a gap and an overlap. **Demonstrated, not hypothetical:** re-adjudicating a real pre-2026-07-14 table (`research-pe-regime-shift-advisory-gap` 1.1-cluster-03) under the current rules moved **2 of 6 claims** from `PROXY-SUPPORTED` to `ILLUSTRATIVE-ONLY` — and a blind `section-directive-drafter` run on the stale table confirmed it would **permit both to be written as hedged market-pattern claims**, which the current rules forbid outright. A stale table launders an over-claim into the report, silently. Never omit this field; never back-fill it with a guess.
- **Claim ID** comes verbatim from the cluster memo (do not renumber).
- **Claim text** is the full claim (not truncated — operators must be able to audit assigned class against full text).
- **Supporting evidence** is a one-line summary listing source titles or IDs (with `→` separators for multiple).
- **Source-diversity** records the count of **independent evidentiary roles** (after same-origin collapse) and the distinct source classes behind them, with `pass` or `fail` per the project's diversity rule. **`pass`/`fail` is deliberately binary** and is not a project-variable vocabulary: the chassis's diversity rule produces a binary outcome (the claim either meets the independent-role bar or downgrades), so a third value would have no defined consequence. Record the *counts* to show the working; the *verdict* is binary. (Checked 2026-07-14 against the chassis and both deployed projects — no project matrix defines a third value, and none can without a chassis change.)
- **Assigned class** is exactly one of the four permitted strings. **These four literals are canonical** — fixed by the chassis for every project (see Behavior step 2). Naming them here is correct and is not a hard-coding defect; what must never be hard-coded here are the *thresholds*.
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
   - Verify `analysis/cluster-memos/{section}/` exists and contains at least one **refined** memo matching `{section}-cluster-NN-memo-refined.md`. If the directory is absent, or contains no file matching that refined pattern: exit with prompt recommending `/run-cluster` first. A directory holding only unrefined `{section}-cluster-NN-memo.md` files does **not** satisfy this check — `/run-cluster` writes both variants into this one directory, and only the refined variant carries the claim IDs this skill adjudicates.
   - Verify `reference/quality-standards.md` exists. If absent: exit with the generic remediation prompt under Failure Behavior.
   - **⚠ CHASSIS-VERSION GATE — check this FIRST, before any adjudication, and HARD-EXIT on failure.** Read the chassis-version marker in `reference/quality-standards.md § Claim-Permission Classes` (the line `**Chassis version: \`YYYY-MM-DD\`.**`, or the HTML comment `<!-- chassis-version: YYYY-MM-DD -->`). **This skill requires chassis version `2026-07-14` or later.** If the marker is **absent**, or its date is **earlier than `2026-07-14`**, **STOP — do not adjudicate a single claim** — and emit the stale-chassis prompt under Failure Behavior.

     **Why this gate is load-bearing and must never be softened into a warning.** This skill is **symlinked** into consuming projects, but each project holds its **own real copy** of the chassis. A canonical edit to this skill therefore lands in every project *the moment it merges*, while the chassis it depends on does **not** — the two diverge silently. Every other pre-flight check below is a *heading-presence* check, and an old chassis has all the same headings, so **nothing else here can detect the divergence.** Without this gate, this skill would run its 2026-07-14 adjudication order (roles → fit → ceilings) against a pre-2026-07-14 chassis whose class Conditions still carry the mixed-axis gap and overlap — and it would produce confident, wrong permission tables with no error. **Silent misadjudication is the worst failure this gate can have; a hard exit is the correct trade.**
   - Verify both required sections are present and parseable in `quality-standards.md`: the top-level `## Claim-Permission Classes` and, **nested beneath it**, the `### Four Permission Classes` table and the `### Source-Diversity Matrix` subsection. If either is absent or malformed: exit with prompt naming the missing section. **Heading levels matter here and are easy to get wrong** — `Source-Diversity Matrix` is a `###` *inside* `## Claim-Permission Classes`, not a top-level `##`. (This skill described it as `## Source-Diversity Matrix` until 2026-07-14; the chassis has always nested it. A substring match papered over the mismatch, which is why no project ever tripped on it.)
   - **`reference/claim-permission.md` completeness check (soft class — values-present, not heading-present).** Check whether `reference/claim-permission.md` exists AND its operative values are filled: the per-claim-type threshold table, the Source-Diversity Matrix rows, and any defect fold-ins must carry real values, not template placeholders. Distinguish *shape-present* (headings exist) from *values-present* (rows filled) — shape-only counts as unfilled. If absent or unfilled, do NOT fail pre-flight and do NOT silently default: proceed in an explicitly-disclosed **GENERIC-BAR regime** — one generic bar for all claim types, taken from `quality-standards.md`'s generic class thresholds — and emit a hard log line at entry: `claim-permission.md absent or unfilled — GENERIC-BAR regime active; no per-claim-type calibration in this run.` The operator must see that per-type calibration is off; silent fallback is the failure mode this check exists to remove.
   - Check `analysis/{section}/.counter-search-runner.done` presence to determine the regime (do not fail if absent — regime disclosure handles it).
   - Check for the research plan and the `## Risk-Tier Model` section in `quality-standards.md` to determine whether the risk-tier ceiling is active. **Do NOT fail pre-flight if either is absent** — an absent plan or absent `## Risk-Tier Model` section routes every claim to Tier B (no ceiling constraint) per step 3's presence-gate. The ceiling is opt-in; only `## Claim-Permission Classes` and its nested `### Source-Diversity Matrix` are hard pre-flight requirements.
2. **Load the rules — and know which parts are canonical.** Parse the class conditions and the diversity matrix from `quality-standards.md § Claim-Permission Classes`, and the per-claim-type calibration from `claim-permission.md` when present.

   **The authority split (settled 2026-07-14 — this was previously ambiguous and the ambiguity was load-bearing).** The chassis's Canonical-ordering rule fixes three things **globally, for every project deployed from this template**: the four class **names**, the **verb lists**, and the **class conditions** (the generic evidence bar). A project may *tighten* the bar per claim type in its `claim-permission.md`; it may **not** rename a class, add a class, or redefine what a class means. Therefore:
   - The four class names — `SUPPORTED` / `PROXY-SUPPORTED` / `ILLUSTRATIVE-ONLY` / `NOT-SUPPORTED` — are **literals**, and this skill's Output schema names them as literals **correctly**. Do not treat them as project-variable.
   - What you parse from the project's files are the **thresholds and the diversity rule**, not the vocabulary. If a project's `quality-standards.md` presents class names that differ from the four canonical literals, that project's chassis is **corrupt or hand-edited** — exit at pre-flight with a remediation prompt rather than adopting the divergent names.

3. **Per cluster:**
   - Read the refined cluster memo. Identify each claim by ID and full text.
   - For each claim: summarize supporting evidence; **count the independent evidentiary roles** (collapsing same-origin channels per the triangulation-packets rule — this is a count of *roles*, not of documents); apply the **fit** test (direct/in-scope vs proxy-requiring-downgrade); assign exactly one of the four permission classes; write a one-line rationale.
   - **Adjudication order — the partition is total; do not invent a precedence rule.** The four class conditions are mutually exclusive and jointly exhaustive on the evidence axis (0 roles → `NOT-SUPPORTED`; exactly 1 → `ILLUSTRATIVE-ONLY`; ≥2 proxy → `PROXY-SUPPORTED`; ≥2 direct/in-scope → `SUPPORTED`). Every claim lands in exactly one class. Two consequences, both of which the pre-2026-07-14 rules got wrong:
     - A single direct in-scope source that is **not** a named example (e.g. one regulator statistic) is `ILLUSTRATIVE-ONLY` — it is **not** a fall-through, and it is **not** `NOT-SUPPORTED`. It may be stated, attributed, as a single-sourced datum.
     - A pattern claim resting on 2 direct roles is `SUPPORTED`. Its generalization is then bounded by the **generalization ceiling** (step 3b) — the evidence is **not** re-graded down to `ILLUSTRATIVE-ONLY`.
   - **Evidenced negatives grade on the ordinary ladder.** A claim whose *content* is negative ("no continuation vehicles were used in this segment") is graded exactly like a positive claim: sources that positively evidence the absence — a regulator confirming zero registrations, a dataset with a true zero — **count as evidentiary roles**, and such a claim **can reach `SUPPORTED`**. Never downgrade a conclusion for being negative; an evidenced negative is a result, not a shortfall. Conversely, a claim that merely **failed to find** support is `NOT-SUPPORTED` — a statement about the evidence, not a finding that the claim is false — and its **negation is equally unstateable**. Never invert a `NOT-SUPPORTED` claim into a positive assertion of the opposite. Where a `NOT-SUPPORTED` arises from an incomplete search rather than an exhausted one, say so in the Rationale (`incomplete research, no stop condition met`) so it cannot be misread as a searched-and-found-nothing verdict. Full rule: chassis § Evidenced Negatives vs Absence of Evidence.
   - **3b. Apply the ceilings (caps, never raises).** After the evidence-graded class is assigned, cap it by the claim's ceilings. They compose monotonically downward, so the most-restrictive binds and application order does not change the result. **Record every applied cap in the Rationale** — an unrecorded cap is indistinguishable from an evidence verdict, which destroys the operator's ability to audit the gate.

     **Presence-gating — and the distinction that makes it coherent.** Two kinds of missing input, treated differently. Do not collapse them:
     - **Legitimately absent → ceiling INAPPLICABLE, does not fire.** An input a correct project may simply lack: no Country Coverage Table in a single-country project; no research plan in an un-tiered project; no instance count on a claim that **does not generalize**. Absence says nothing about the claim, so firing would penalise a technicality.
     - **Required but missing → input MALFORMED, ceiling FIRES with a flag.** An input the claim's own shape demands: a claim that **does** generalize but records neither ≥3 instances **nor** a population-level source. It has recorded **no warrant to generalize**, and a generalization with no warrant must not pass as `SUPPORTED`.

     "Absent input → never fire" applies **only** to the first case. It is not a licence to skip a ceiling whenever the memo is thin.

     - **Generalization ceiling — two tests, both required.** **(1) Does the claim generalize?** Read the **claim text**: does it extrapolate a pattern across a class of actors, deals, or periods ("sponsors systematically…", "no sponsor did X")? If **no** — a single attested datum, a named case — the ceiling is **inapplicable**; record `instances: n/a` and move on. **(2) If it generalizes, is there a warrant?** A generalization is warranted by **exactly one of two things**: **≥3 same-pattern instances**, **OR ≥1 population-level evidentiary role**. If **either** is recorded, the ceiling does not fire. If **neither** is, it **fires** and the row is flagged.
     - **This skill can only CAP — it cannot narrow.** The chassis offers a narrow-or-cap branch, but narrowing means rewriting the claim, and this skill's Output schema mandates claim text **verbatim from the cluster memo** while When-Not-to-Use forbids writing prose. Narrowing is `cluster-memo-refiner` Check 9's job, upstream. Here a fired ceiling **caps at `ILLUSTRATIVE-ONLY`**. Do not rewrite or truncate the claim to make it fit.
     - **On firing, record `GENERALIZATION-CAPPED`** alongside the class the evidence *would* have earned — e.g. `evidence: SUPPORTED (2 roles); generalization ceiling → capped ILLUSTRATIVE-ONLY [GENERALIZATION-CAPPED]`. Load-bearing: the capped row is **self-contradictory on its face** (a generalizing claim in a class that forbids stating generalizations), and this marker is what tells Pass 4 how to dispose of it — narrow it in prose to what the instances attest, or omit it; never restate the generalization under a hedge. It also signals Check 9 failed to narrow upstream. Full rule: chassis § Disposition rule.
     - **Population-level = coverage, not size.** A population-level role is a source whose *stated scope is the whole population the claim quantifies over* — a complete statutory register, a mandatory-filing database, an exhaustive transaction record. **A large sample is NOT a population:** a 140-respondent survey cannot supply the warrant on its own, however well-constructed; it may corroborate *alongside* a population-level source. **You do not adjudicate population-level status — you read it** from the memo (`instances: n/a (population-level — {named source})`), where `cluster-memo-refiner` records it. This is what protects an **evidenced negative**, which has zero positive instances by construction: a well-evidenced "no CVs were used in this segment", resting on a complete register recording a true zero, would otherwise read as `0 < 3` and be capped — re-importing through the ceiling layer the exact penalty-on-negatives that step 3 forbids on the class layer.
     - **A bare `n/a` on a generalizing claim is a memo defect, not an exemption.** The memo has not said why the claim may generalize, and silence is not permission. Cap at `ILLUSTRATIVE-ONLY` **and** flag `[POPULATION-LEVEL-UNVERIFIED — operator review]` — flag rather than silently downgrade, exactly as the Tier-C ceiling does. Do not resolve it yourself: choosing "don't fire" launders a sample into a population claim; choosing "fire" silently destroys a well-evidenced negative. **Expect these flags when re-running against a project whose memos predate 2026-07-14** — they did not carry this field. That is memo-completion work, not an evidence failure.
     - **Country-coverage ceiling.** ≥2 countries `not evidenced` in the claim's Country Coverage Table → cap at `ILLUSTRATIVE-ONLY`. **Does not fire** when the project is single-country, the claim is not country-relevant, or the memo carries no Country Coverage Table. A missing table is *inapplicable*, never "≥2 countries not evidenced."
     - **Risk-tier ceiling.** Per the presence-gated rules in step 3's tier block below.
     - **Process ceiling (the fourth ceiling) — DO NOT APPLY; you cannot.** The chassis's § Research Stop Conditions reciprocal rule caps at `NOT-SUPPORTED` any claim from a subtask that met no stop condition. It is a ceiling, not a class condition. **This skill does not implement it, deliberately: the refined cluster memo — your only input — carries no stop-condition or subtask-completeness field**, so the trigger is not evaluable here at all. Do not infer subtask abandonment from thin evidence; a diligent subtask that found one source closes legitimately under Cond. 5 and its claim is `ILLUSTRATIVE-ONLY`, not a process failure. Wiring this ceiling requires a memo-schema change upstream. Disclosed in the chassis; routed on mission `research-workflow-deploy-fitness`.
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
  > Claim-permission-gate requires `reference/quality-standards.md` (project-level deliverable) with a `## Claim-Permission Classes` section carrying the nested `### Four Permission Classes` table and `### Source-Diversity Matrix` subsection. File not found. Consult the project's pipeline documentation for the unblock plan.
- **⚠ Chassis version absent or older than `2026-07-14`.** **HARD EXIT — adjudicate nothing.** Emit:
  > **Claim-permission-gate halted: your project's `reference/quality-standards.md` predates the 2026-07-14 permission re-cut.**
  >
  > This skill (canonical, symlinked) requires chassis version `2026-07-14` or later; your project's chassis is a **local copy** and was not updated when the skill was. Running the new adjudication order against the old class conditions would produce **confident, wrong permission tables with no error**, so the gate stops instead.
  >
  > **To unblock:** back-port from the canonical template (`workflows/research-workflow/reference/quality-standards.md`) into your project's `reference/quality-standards.md`: § Claim-Permission Classes and all of its subsections (Four Permission Classes, Adjudication order, Permission ceilings, Evidenced Negatives vs Absence of Evidence, Lockstep contract, Minimum Evidence Thresholds, Source-Diversity Matrix), § Country Coverage Table's gate rule, and § Research Stop Conditions (which gains Cond. 5). Keep any project-specific values you have filled in.
  >
  > **Then re-check what you already have.** Permission tables adjudicated under the old chassis were graded by a rule set with a **known gap** (a single direct in-scope source that is not a named example matched *no* class) and a **known overlap** (a 2-role pattern claim matched `SUPPORTED` and `ILLUSTRATIVE-ONLY` at once). Those verdicts are not automatically wrong, but they were not automatically right either — re-run the gate on affected sections rather than assuming.
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
- **Do not penalize a claim for concluding "no".** An evidenced negative is a finding, and the pull to treat it as a shortfall — to reach for NOT-SUPPORTED because the conclusion is negative — is a real and specific bias. Grade the evidence, not the direction of the conclusion. A well-evidenced "this does not occur" is `SUPPORTED`.
- **And do not manufacture a negative out of an empty search.** The inverse error is worse: reading `NOT-SUPPORTED` (we found nothing) as licence to assert the opposite. It does not license that. A `NOT-SUPPORTED` claim and its negation are **both** unstateable. When the Rationale says the search was *incomplete* rather than *exhausted*, that is doubly true.
- **Do not let a ceiling masquerade as an evidence verdict.** A claim capped at `ILLUSTRATIVE-ONLY` by the generalization, country-coverage, or risk-tier ceiling has *not* been judged evidence-poor — its evidence may be strong and its class capped for a reason about the *claim*. Always record which ceiling applied. A silent cap tells the operator the evidence failed, when it did not.
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
- The project-level reference doc that unblocks this skill is `reference/quality-standards.md` (must include a `## Claim-Permission Classes` section carrying the nested `### Four Permission Classes` table and `### Source-Diversity Matrix` subsection; it may **optionally** include a `## Risk-Tier Model` section, which activates the per-claim risk-tier ceiling — absent it, every claim binds at Tier B).
- **Permission-class contract (load-bearing).** The class **names**, the class **conditions**, the **adjudication order**, and the **ceilings** are owned by `reference/quality-standards.md § Claim-Permission Classes` — the authority. Two other files carry working copies of the same rules: **this skill** (Behavior steps 2–3b, the Output schema) and **`cluster-memo-refiner` § Check 9** (its first-pass grading). **All three change together, or they diverge.** An edit to any of the four owned things requires a paired edit to the other two files and a `/risk-check` re-fire per the chassis's Canonical-ordering rule. This contract exists because the copies *did* silently diverge: before 2026-07-14 the chassis and Check 9 both carried a mixed-axis class table with a gap (single-source non-example evidence matched no class) and an overlap (a 2-source pattern claim matched two), and nothing bound them. The acceptance test for any future edit is the worked-cases table in the chassis § Adjudication order — run all four cases through the changed rules and show each lands in exactly one class.
- **Input-path contract (load-bearing).** The refined-memo input path is owned by two upstream sources and this skill must not restate it independently: `/run-cluster` is the **writer** (it writes both `{section}-cluster-NN-memo.md` and `{section}-cluster-NN-memo-refined.md` into `analysis/cluster-memos/{section}/`), and `reference/file-conventions.md` is the **naming registry** — its canonical row fixes the directory, and its Rule 2 (variant-suffix convention) fixes the `-refined` suffix this skill filters on. If either changes, this skill's Inputs row and pre-flight change in lockstep. Sibling `country-parity-checker` carries the identical contract and must be updated with it.
- Upstream: `research-plan-creator` produces the per-question `risk-tier:` field this skill reads for the ceiling. Sibling `cluster-memo-refiner` Check 9 applies the same deterministic most-restrictive ceiling in its (first-pass) refinement table; this skill's authoritative Pass-3 table supersedes it at the shared path. Both use the same chassis rule (`§ Risk-Tier Model`), so they agree by construction.
- The disconfirmation-regime contract is the load-bearing coupling between this skill and `counter-search-runner`: when counter-search runs, downgrade recommendations apply back to this skill's output tables before Phase C; when it does not run, the regime disclosure documents the gap.
