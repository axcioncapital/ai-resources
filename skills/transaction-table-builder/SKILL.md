---
name: transaction-table-builder
description: >
  Build a structured transaction-evidence table for a research section. Reads
  Stage 2 raw reports and research extracts; produces one row per named
  transaction with 13 mandatory fields (target, buyer, seller, country, sector,
  date, buyer type, deal type, EV, size-lens status, two sources, supported
  claim ID). Output enables downstream skills to verify named-deal claims
  against a structured artifact instead of free-text mentions, closing the
  drift where above-lens deals support lower-mid-market conclusions. Sub-agent
  invocation, one per section, between Stage 2.3 (extracts) and Stage 3.1
  (cluster analysis). Trigger when an operator/command invokes
  `transaction-table-builder` with a section identifier, or on requests like
  "build the transaction table for {section}." Do NOT use for cluster memo
  refinement (cluster-memo-refiner), chapter-write-time citation verification
  (evidence-to-report-writer), source classification (source-class-mapper), or
  any web search — this skill consumes already-collected evidence only.
model: sonnet
effort: medium
---

# Transaction Table Builder

## Purpose

When named transactions enter cluster memos as free-text mentions, above-lens deals (EV above the project's size band) can quietly support claims about lower-mid-market dynamics. This skill turns named-transaction evidence into a structured artifact every downstream consumer can verify against: 13 mandatory fields per row, an explicit size-lens classification per deal, and a supported-claim ID linking each row to the cluster-memo claim it substantiates.

The skill is project-agnostic — the size-lens band, country set, sector taxonomy, and source-class hierarchy are read from project reference docs. The 13 fields, 5 size-lens classes, and same-pattern thresholds below are the canonical contract every project using this skill inherits.

## When to Use

- Invoked per section, after Stage 2.3 (extracts produced) and before Stage 3.1 (cluster analysis begins). Positional argument: section identifier (e.g., `1.1`).
- Re-entry: idempotent on the same section. If the output file already exists, the skill merges new rows from new extract files and preserves existing rows verbatim unless the operator forces a rebuild by deleting the output file.
- Single output per section (one table file). No multi-section batching.

## When Not to Use

- Do NOT use to refine cluster memos or enforce the same-pattern threshold (`cluster-memo-refiner`'s job at consumption time — documented in § Same-Pattern Clustering Rule below for transparency only).
- Do NOT use to verify named-deal citations in chapter prose (`evidence-to-report-writer`'s job at chapter-write time).
- Do NOT use to classify sources (`source-class-mapper`'s job).
- Do NOT use to mint new claim IDs — IDs are consumed from `cluster-memo-refiner`, never created here.
- Do NOT use to search the web — works only from already-collected extracts + reports.

## Inputs

| Input | Path | Required |
|---|---|---|
| Research extracts | `execution/extracts/{section}/` (directory; one extract per Stage 2 session) | yes |
| Raw research reports | `execution/reports/{section}/` (directory; raw Research GPT / Perplexity outputs) | yes |
| Source-class hierarchy | `reference/source-class-hierarchy.md` (project-level) | yes |
| Project size-lens band | declared in the project's `CLAUDE.md` or in `reference/source-class-hierarchy.md` (project-specific surface) | yes |
| Project country set | `## Project Country Set` section in `reference/source-class-hierarchy.md` | yes |
| Sector taxonomy | project's `reference/` (look for a sector-taxonomy file; if absent, fall back to free-text sector labels and flag in § Failure Behavior) | optional |

**If any required input is absent:** halt and emit a one-line message naming the missing file or section. Do not proceed with partial inputs — a transaction table built without the size-lens band cannot classify rows correctly.

## Output

Single file: `execution/transaction-table/{section}/{section}-transaction-table.md`.

Directory created on first write.

### Output Schema

```markdown
# Transaction Table — {section}

> **Source:** Built by `transaction-table-builder` from `execution/extracts/{section}/` + `execution/reports/{section}/` on {YYYY-MM-DD}. One row per named transaction. Size-lens classifications use the project band declared in `reference/source-class-hierarchy.md` (or project `CLAUDE.md`).

| Target | Buyer | Seller | Country | Sector | Date | Buyer type | Deal type | EV (EUR) | EV disclosure | Size-lens | Source 1 | Source 2 | Claim supported |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ... |
```

Each column maps to one of the 13 mandatory fields. The `EV (EUR)` and `EV disclosure` columns together carry the deal-value field (column 9 in the v4 spec) — `EV (EUR)` is the value if disclosed or inferred (else `—`); `EV disclosure` is `disclosed`, `inferred`, or `undisclosed`. This split makes the inferred/disclosed flag machine-readable.

### Worked Example (3 rows)

```markdown
# Transaction Table — 1.1

> **Source:** Built by `transaction-table-builder` from `execution/extracts/1.1/` + `execution/reports/1.1/` on 2026-05-26. One row per named transaction. Size-lens classifications use the project band declared in `reference/source-class-hierarchy.md` (€2–25M EV for this project).

| Target | Buyer | Seller | Country | Sector | Date | Buyer type | Deal type | EV (EUR) | EV disclosure | Size-lens | Source 1 | Source 2 | Claim supported |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Nordic Components AB | Adelis Platform Co | Family (Karlsson) | Sweden | Industrial services | 2025-09-12 | sponsor-backed platform | add-on | 8500000 | disclosed | CONFIRMED_IN_LENS | Adelis press release (2025-09-12) | Affärsvärlden article (2025-09-15) | 1.1-cluster-04-claim-12 |
| Visby Software Oy | CapMan Growth Equity Fund III | Founders | Finland | Software | 2025-11-03 | PE | platform | — | undisclosed | LIKELY_IN_LENS | CapMan press release (2025-11-03) | Talouselämä article (2025-11-04) | 1.1-cluster-07-claim-03, 1.1-cluster-07-claim-05 |
| TechFinland Oy | Investor AB (strategic) | Vaaka Partners Fund III | Finland ← Sweden | Financial software | 2025-08-21 | strategic | secondary | 180000000 | disclosed | ABOVE_LENS | Investor AB press release (2025-08-21) | — | UNVERIFIED |

Notes: Row 3 is single-source at table-build time (only DNB PR confirmed). Row 3 claim ID UNVERIFIED — no cluster-memo claim has yet been emitted in the new scheme to attach to.
```

Three contracts the example demonstrates verbatim:

- Size-lens canonical strings (`CONFIRMED_IN_LENS`, `LIKELY_IN_LENS`, `ABOVE_LENS`) — exact-match required.
- Cross-border country notation — row 3 shows the `target ← buyer` form (here both Norwegian; a Norwegian target sold by a Norwegian-domiciled fund to a Norwegian strategic).
- Claim-ID format with multi-claim case — row 2 shows comma-separated multi-claim attribution; row 3 shows the `UNVERIFIED` placeholder when the cluster-memo claim is not yet in the new scheme.
- `EV (EUR)` empty cell with `EV disclosure = undisclosed` — row 2 shows the `—` placeholder.

(Example values are illustrative; real rows must come from extracts/reports, never invented.)

## The 13 Mandatory Fields

| # | Field | Required | Notes |
|---|---|---|---|
| 1 | Target | Yes | Company name. Use the legal/operating name as it appears in the primary source; do not normalize across sources. |
| 2 | Buyer | Yes | Acquirer / new owner. |
| 3 | Seller | Yes | Prior owner / family / corporate parent. If the target was bought from public markets (take-private) or had no single prior owner (IPO), state the equivalent (`public shareholders`, `n/a — IPO`). |
| 4 | Country | Yes | The target's home country. Project country set lives in `## Project Country Set` in `reference/source-class-hierarchy.md`. Cross-border deals: label `{target-country} ← {buyer-country}` (e.g., `Sweden ← Norway`). |
| 5 | Sector | Yes | Per the project's sector taxonomy. If the taxonomy file is absent, free-text label + flag in the row's `Notes` (skill emits a sector-taxonomy gap warning in this case). |
| 6 | Date | Yes | `YYYY-MM-DD`. Use announcement date if completion not disclosed; flag in `EV disclosure` column. |
| 7 | Buyer type | Yes | One of: `PE`, `strategic`, `sponsor-backed platform`. |
| 8 | Deal type | Yes | One of: `platform`, `add-on`, `secondary`, `carve-out`, `take-private`, `IPO`. |
| 9 | Deal value / EV | Required if available | EUR; the table splits this into `EV (EUR)` (the value) and `EV disclosure` (`disclosed` / `inferred` / `undisclosed`). |
| 10 | Size-lens status | Yes | One of the 5 classes below. |
| 11 | Source 1 | Yes | Primary source preferred (best class for `Named transactions` per the project hierarchy). |
| 12 | Source 2 | Yes | Independent confirmation preferred. If only one source exists, write `—` and flag `single-source` in `Notes`. |
| 13 | Claim supported | Yes | Cluster-memo claim ID this transaction substantiates. See § Claim-ID Contract below. |

## Size-Lens Classification (5 classes)

| Classification | Meaning |
|---|---|
| `CONFIRMED_IN_LENS` | EV disclosed and within the project size-lens band, or clearly inferable from disclosed financials (revenue, EBITDA, employee count where filed). |
| `LIKELY_IN_LENS` | Small company, local operator, lower-mid-market adviser language ("lower-mid-market platform," "add-on bolt-on"). |
| `POSSIBLY_IN_LENS` | Undisclosed, but no evidence of large-cap (no flagship-tier adviser, no major financial press coverage). |
| `ABOVE_LENS` | Disclosed value above the project size-lens upper bound, or obvious large-cap (flagship sponsor primary investment, top-tier adviser slate). |
| `UNKNOWN` | Cannot classify; default if no signal in either direction. |

The class labels are project-agnostic; the band (e.g., €2–25M EV) is project-specific and read at runtime. Apply the class names verbatim — they are the canonical strings downstream consumers (`cluster-memo-refiner`, `evidence-to-report-writer`) match against.

## Deal-Value Recovery Routine

For deals where EV is undisclosed, attempt to infer size-lens fit from indirect signals before defaulting to `UNKNOWN`. Climb this checklist in order; stop at the first signal that produces a confident classification:

1. **Annual reports** — publicly filed for AB / AS / Oy company forms. Revenue + EBITDA disclose enough to bracket EV in most cases.
2. **Company registry filings** — Bolagsverket (SE), Brønnøysund (NO), PRH (FI) for the Nordic context, or equivalent registries per the project's country set. Ownership changes, board changes, merger filings.
3. **LinkedIn headcount** — rough revenue proxy at ~200K–400K EUR per FTE for B2B services. Adjust band per sector if a project sector-taxonomy file states sector-specific revenue-per-FTE benchmarks.
4. **Adviser descriptions** — "lower-mid-market," "small-cap platform," "boutique advisory."
5. **Platform vs. add-on language** — "bolt-on for [platform name]" strongly suggests a small target (add-ons typically sit below platform EV).
6. **Previous acquisition price** — for add-ons to a known platform, the platform's prior EV bounds the add-on.
7. **Tender documents** — where available.
8. **Financial statements** — revenue, employees, EBITDA where filed.

If none of these produce a confident classification, default to `UNKNOWN` and emit a one-line note in the row's `Notes` (or `Source 2` if Notes is absent) naming which signals were checked. Do NOT guess — `UNKNOWN` is the correct answer when signals are genuinely absent.

## Same-Pattern Clustering Rule

*Documented here for transparency. This rule is enforced by `cluster-memo-refiner` at consumption time, not by this skill.*

| Cluster size | Permitted conclusion |
|---|---|
| Fewer than 3 same-pattern transactions | **Illustrative only** — cannot support a market-pattern claim |
| 3–5 same-pattern transactions | **Directional** — can support a directional pattern claim with caveat |
| 5+ same-pattern transactions across at least 2 countries | **Pattern candidate** — can support a pattern claim |

Knowing this threshold helps when populating the `Claim supported` field: if a row is part of a 2-transaction cluster, the `Claim supported` ID will reference a claim flagged `illustrative` by `cluster-memo-refiner`, not a load-bearing pattern claim. The row still gets recorded; the consumer enforces the threshold.

## Claim-ID Contract

The `Claim supported` field (column 13) references a cluster-memo claim ID using this canonical format:

```
{section}-cluster-NN-claim-NN
```

- `{section}` — project section identifier (e.g., `1.1`).
- `cluster-NN` — zero-padded 2-digit cluster number within the section.
- `claim-NN` — zero-padded 2-digit claim number scoped within the cluster.

Example: `1.1-cluster-04-claim-12` means section 1.1, cluster 4, claim 12.

**Producer of IDs:** `cluster-memo-refiner` (see that skill's § Claim-ID Format section). This skill is a **consumer only** — it does not mint new IDs.

**Until the producer emits IDs in this scheme:** populate `Claim supported` with `UNVERIFIED` for any row whose supporting claim does not yet exist in cluster-memo form. The placeholder is intentional — it tells the downstream consumer (Bundle 2b's claim-permission gate, deferred) the row is unattached.

## Process

1. Read `reference/source-class-hierarchy.md` — capture the project size-lens band, country set, and named-source appendix.
2. Read the project's sector taxonomy file if present; otherwise note the absence and emit a one-line gap warning.
3. Walk `execution/extracts/{section}/` and `execution/reports/{section}/`. For each named transaction encountered:
   - Extract the 13 fields directly where stated; apply the deal-value recovery routine where EV is undisclosed.
   - Classify size-lens using the 5-class taxonomy.
   - Identify the cluster-memo claim ID(s) the transaction substantiates. Multiple claim IDs per row are permitted (comma-separated). `UNVERIFIED` if the cluster-memo doesn't yet exist in the new ID scheme.
   - Capture two sources (primary + independent confirmation). Single-source rows are recorded with `—` in Source 2 and `single-source` in the Notes column.
4. De-duplicate: if the same Target + Buyer + Date appears in multiple extracts, merge into one row (union of sources, narrowest size-lens class consistent with the evidence).
5. Sort rows by Date ascending. Ties broken by Country, then Target.
6. Write the output file. Include the header note (date built, source paths, size-lens band).

## Failure Behavior

- **Missing source-class hierarchy file** — halt; emit the one-line message naming the missing file. The skill cannot classify sources without it.
- **Missing project country set section** — halt; emit the one-line message naming the missing section. Country-field assignment is unreliable without the project's declared set.
- **Missing project sector taxonomy** — proceed with free-text sector labels; emit one warning naming the absent taxonomy; downstream consumers should treat sector labels as `[unclassified]`.
- **Missing extracts or reports directory** — halt; emit a one-line message naming the missing directory.
- **Empty extracts + reports** — proceed (write an empty table with header only); the empty table is itself a signal to the operator that named-transaction evidence is thin.
- **Conflicting field values across sources** — record the higher-confidence value (primary class source wins per the project hierarchy); flag the conflict in `Notes`. Do not invent a synthesis.
- **Cluster-memo file absent or claim-ID scheme not yet emitted** — populate `Claim supported` with `UNVERIFIED` (see § Claim-ID Contract).

If provided information is insufficient to populate a row confidently, leave the row out and flag the gap rather than fabricating fields. It is acceptable to report a smaller table with all rows fully populated rather than a larger table with synthetic content. Accuracy over comprehensiveness.

## Inert-Fields Ledger Note

Two fields in the output land partially inert in Bundle 2a (defined here but not yet end-to-end enforced):

| Field | Activated by Bundle | Status until activation |
|---|---|---|
| `Claim supported` | Bundle 2b's S-06 (claim-permission gate, deferred) | Populated using the format above, but the cross-table consistency check that fails when a chapter claim cites a row without `Claim supported` filled is not yet built. Manual operator review fills the gap. |
| `Size-lens` (downstream cite check) | S-05 step 6 (`evidence-to-report-writer` size-lens verification at chapter-write time, this session — Mitigation A | Once S-05 step 6 lands, the chapter writer will block citations whose size-lens does not match the table. Until then, no automated check. |

Once Bundle 2b lands, remove this ledger or rewrite as a historical breadcrumb.

## Self-Check

Before writing the output file, verify:

- Every row carries all 13 fields (no field labeled `n/a` except where the schema explicitly allows it for `Seller` on IPOs).
- Every `Size-lens` value is one of the 5 canonical classes (exact string match).
- Every `Country` value matches the project country set (no `Nordic` when the set is `Sweden`/`Norway`/`Finland`; cross-border rows use the `target ← buyer` notation).
- Every `Claim supported` value is either one or more well-formed claim IDs (`{section}-cluster-NN-claim-NN`, comma-separated if multiple) or the literal string `UNVERIFIED`.
- No row has `EV (EUR)` populated when `EV disclosure` is `undisclosed`.
- No row repeats Target+Buyer+Date (de-duplicated).
- Rows sorted by Date ascending.
- Header note present with build date, source paths, project size-lens band.
- Output path is `execution/transaction-table/{section}/{section}-transaction-table.md` exactly.

If any check fails: do not write the file. Emit a one-line message naming the failing check and the affected row(s), then halt for operator review.

## Output Protocol

Default mode: **Direct write**. This skill produces a structured artifact with a well-defined schema — no plan-then-execute pattern is needed.

If the input volume is large (>30 named transactions in the extracts), present a one-paragraph plan first (total row count, size-lens distribution, claim-ID coverage rate, expected gaps) and wait for operator `proceed` before writing. This prevents wasted work on a misshapen input set.

## Runtime Recommendations

- **Model:** `sonnet`. The work is structured-artifact production with light classification judgment (per-row size-lens taxonomy, conflicting-source tiebreaker). Not analytical synthesis. Sonnet handles the 13-field extraction + 5-class taxonomy + canonical-string matching reliably; Opus is overkill at this tier.
- **Effort:** `medium`. Per-row work requires the Deal-Value Recovery Routine ladder when EV is undisclosed (8 candidate signal checks) and conflicting-source reconciliation per the project hierarchy. Not mechanical; not deep reasoning.
- **Throughput posture (≤30 transactions per section):** direct write — no plan-first ceremony.
- **Throughput posture (>30 transactions per section):** plan-first per § Output Protocol — present row count, size-lens distribution, claim-ID coverage rate, and expected gaps; wait for operator `proceed`. This is a budget-protection gate against misshapen input sets.
- **Escalate to Opus if:** the conflicting-source rate exceeds ~20% of rows (Sonnet's primary-class tiebreaker may miss nuance at that density), or the project sector taxonomy is absent and sector labels require synthesis from heterogeneous extracts. In both cases, escalation is judgment — operator decides via `/model opus`, not auto-switched here.
- **Re-entry cost:** re-running the skill on an existing output is idempotent (merge new rows, preserve existing). Re-runs are cheap; full rebuilds require deleting the output file first.

## Related Skills and References

- `cluster-memo-refiner` — producer of claim IDs consumed by this skill (Claim supported field).
- `evidence-to-report-writer` — chapter-write-time consumer; verifies cited transactions against this table.
- `source-class-mapper` — runs upstream (Pass 1); classifies sources, not transactions.
- `country-parity-checker` — cluster-level consumer; reads `## Project Country Set` from the same hierarchy file this skill reads.
- `reference/source-class-hierarchy.md` (project) — best-class-per-evidence-type table, ladders, named-source appendix, country set.
