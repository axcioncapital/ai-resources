# S1 relay baseline — instrumentation for the W4-H1–H4 path-passing refactor

> **When to read this:** before editing any main-session relay in this workflow, and when checking
> whether the S1 payload-reduction target has been met.

This directory is the **proof seam** for Slice S1 of
`plans/canonical-research-workflow-near-term-strategic-improvements-implementation-plan.md` § 5.
It measures how much delegable content the workflow's relay seams push through the main session,
against a fixed fixture, and fails while the approved target is unmet. It changes no production
behaviour: nothing here is read at runtime by any command, agent, or skill.

## Running it

```bash
cd workflows/research-workflow/tests/s1-relay
bash check-relay-payload.sh          # the target check — currently RED by design
bash check-relay-payload.test.sh     # the harness's own regression suite — must be green
bash make-fixture.sh                 # regenerate the fixture (must stay byte-identical)
```

`check-relay-payload.sh` exits `0` when the target is met, `1` when it is not, `2` on a usage or
input error. `--format tsv` emits one machine-readable row per seam for downstream tooling.

## What makes the red baseline trustworthy

The manifest records *where* each relay is and *what it should become*. It never records whether the
seam currently complies. The check opens the live command or agent body, finds the one relay directive
line, and derives the current shape — content or path — from that text. So:

- The check cannot fail because a marker, an expected string, or the S1 brief says the workflow is
  noncompliant. `check-relay-payload.test.sh` T3 proves it: appending prose that asserts
  noncompliance to a compliant surface leaves the verdict at TARGET MET.
- The check can go green. T9 takes the **real** command bodies, applies one mechanical edit to a
  single live directive, and asserts that seam changes state — VIOLATION → COMPLIANT for a seam still
  relaying content, COMPLIANT → VIOLATION for one already converted. Both directions prove the same
  thing: the verdict follows the live directive text. T9b confirms an unrelated seam in another file
  does not move.
- Reduction is measured against a **fixed baseline** (every in-scope seam's full fixture payload,
  computed from manifest + fixture alone), not against a live projection. A projection-based figure
  reads ~98% while nothing has been fixed, then collapses once the refactor lands — failing exactly
  backwards.

## Reconciliation: every audit-named surface maps to at least one seam row

`audits/token-audit-2026-07-03-ai-resources.md` § 4 named the four HIGH classes. Each named surface
below carries one or more manifest rows; `check-relay-payload.test.sh` T8/T8b assert the mapping
holds. Two audit references did not survive re-enumeration and are corrected in the manifest:

| Audit statement | What the live bodies actually show |
|---|---|
| `execution-agent` is wired via `/verify-chapter` **St4** | The delegation is at **Step 2, item 4**. Step 4 only logs to `/logs/qc-log.md`. |
| `evidence-to-report-writer` (listed beside the workflow's agents) | It is a **skill** at `ai-resources/skills/evidence-to-report-writer/SKILL.md`, loaded into a general-purpose subagent by `run-report` 4.2a. The workflow's four agents are `execution-agent`, `improvement-analyst`, `qc-gate`, `verification-agent`. |

| Class | Audit-named surface | Seam rows |
|---|---|---|
| W4-H1 | `run-report` St4.2a (full draft return) | `H1-01`, plus the downstream re-relays `H1-02` (4.2b) and `H1-03` (4.2c) |
| W4-H2 | `execution-agent`, `verify-chapter` | `H2-01` (agent return contract), `H2-03`/`H2-04` (Step 1 inputs), `H2-05` (Step 3 correction relay) |
| W4-H3 | `run-report` St4.0 (six categories) + St4.1b re-read + the St4.2 per-chapter operands | `H3-01`–`H3-04` (St4.0), `H3-05` (St4.1), `H3-06`/`H3-07` (St4.1b), `H3-08`/`H3-09` (St4.2a operands), `H3-24` (St4.2c architecture operand — not audit-named; the relay repeats the same approved architecture to `report-compliance-qc` four times per section and carried no row until Unit 7 added one) |
| W4-H3 | `run-analysis` St1 (all memos) | `H3-10`, plus the five content relays it feeds: `H3-11`, `H3-12`, `H3-13`, `H3-14` |
| W4-H3 | `run-synthesis` St1 | `H3-15`, `H3-16` |
| W4-H3 | `run-execution` St2.3 (all raw reports) | `H3-17`, `H3-18`, `H3-19` |
| W4-H3 | `produce-architecture` Ph2+Ph3 (drafts double-read) | `H3-20`/`H3-21` (Ph2), `H3-22`/`H3-23` (Ph3) |
| W4-H4 | `run-cluster` St2.2 | `H4-01`, `H4-02` |
| W4-H4 | `run-execution` St2.1 + St2.3 | `H4-03`/`H4-04` (St2.1), `H4-05`/`H4-06` (St2.3) |
| W4-H4 | (not audit-named — found by sweep) `run-report` 4.2a/b/c reference docs | `H4-07`, `H4-08`, `H4-09` — **already compliant at the Unit 1 baseline**; `H4-01`–`H4-06` joined them in Unit 2 |

**One deliberate omission.** The audit's W4-H2 also covers `execution-agent`'s
`Interpret or summarize the response — return it verbatim` prohibition. That line is an **edit target**,
not a payload relay: the fix deletes or rewrites it, which would leave any seam row anchored there
permanently UNRESOLVED. It is recorded in the edit map below instead.

## Isolation: what may be path-passed, and what may not

`docs/required-reference-files.md` § Path-passing convention is the governing boundary. It settles two
cases and leaves a third open, and the manifest's `isolation` column keeps them apart:

- **`reference-path-ok`** — the four reference docs. The convention *already* mandates path-passing for
  them ("The Stage 2–4 commands pass these reference files to subagents **by path, not by content**").
  `run-report` 4.2a/b/c complied from the start. `run-cluster` St2.2/2.3 and `run-execution`
  St2.1/St2.3 did not — they read the docs into main and passed them as content, `run-cluster` once
  per cluster; **Unit 2 converted all six**. These were the
  clean conversions: the documented convention is on their side and the consuming agents all hold
  `Read` (`qc-gate`: `Read`; `verification-agent`: `Read, Glob, Grep`; `execution-agent`: `Read, Bash`;
  general-purpose: all tools), so every consumer can resolve a path.
- **`intentional-content`** — cluster memos and section directives. The convention names these as
  per-chapter inputs "passed by content per the context-isolation rule". Their target is
  `content-required`; the check measures them and holds them **outside** the reduction accounting
  rather than scoring them as violations.
- **`ambiguous` — surfaced, not guessed.** Five payloads are neither a reference doc nor a named
  per-chapter input, so the contract does not settle them. The check reports each one and fails the
  run rather than assuming:
  - `H3-04` / `H2-04` **research extracts.** The convention lists extracts among the content-passed
    per-chapter inputs, and `run-report` St4.0 restates that ("Sub-agents receive content, not file
    paths"). But `run-cluster` St2.3 already passes extract **paths** — "the sub-agent reads its own
    extracts" — so the workflow contradicts itself about this exact artifact class. Which reading
    governs is an isolation-contract question, not an implementation choice.
  - `H1-02` / `H1-03` **the chapter draft relayed onward to the reviewer and the compliance QC.**
    These consume a draft that has not been written to disk yet at that point in 4.2 (the write is
    step d), so path-passing them requires reordering the write ahead of the review — a sequencing
    change, not a relay swap.
  - `H2-05` **chapter prose to `evidence-prose-fixer`.** Same shape as above.

## Blast radius

Five projects carry a copy of every seam-bearing surface: `axcion-content-programme`,
`axcion-sector-intelligence`, `buy-side-service-plan`, `positioning-research`,
`research-pe-regime-shift-advisory-gap`.

They are **regular file copies, not symlinks**, so a canonical edit does *not* take live effect in
them — propagation needs `/sync-workflow`, which is S0's territory and outside this task. **None of
the five received Unit 2's canonical change, so all five copies now diverge from canonical**: the two
command bodies Unit 2 edited, `run-cluster.md` and `run-execution.md`, differ from canonical in every
one of the five. Unit 2's edits therefore landed canonically only, and the accumulated divergence must
be reckoned with before any propagation is claimed.

## The bounded edit map for the next unit

Ordered by ratio of measured bytes removed to isolation risk. Run `check-relay-payload.sh` for the
current per-seam figures rather than quoting numbers from here.

1. ~~**Reference docs — no contract question at all**~~ **— LANDED in Unit 2** (`H4-01`, `H4-02`,
   `H4-03`, `H4-04`, `H4-05`, `H4-06`). The docs are no longer read into main; each seam passes
   `reference/{name}.md` as a path, matching what `run-report` 4.2a/b/c already did. `H4-02` was the
   single largest measured seam because the relay repeats per cluster. `run-cluster`'s stage-entry
   completeness gate is unchanged and still verifies the files are present **and filled** before
   launching — path-passing makes that gate more load-bearing, not less. `run-execution` has no
   command-level completeness gate; its Steps 2.1.4 / 2.3.4 now verify presence in place of the
   content read, so the same fail-fast point survives.
2. **Bulk operand reads and their onward relays.** All are `operand-path-ok`: the payload is already on
   disk and the consumer can read it. `produce-architecture` Ph2/Ph3 read the same drafts twice, so
   one conversion clears both.
   - ~~Pending~~ **— LANDED in Units 3–7:** `H3-20`–`H3-23` (Unit 3, `produce-architecture` Ph2/Ph3
     section drafts); `H3-01`, `H3-05`, `H3-06`, `H3-07` (Unit 4, the `run-report` chapter-draft set);
     `H3-17`, `H3-18` (Unit 5, `run-execution` St2.3 raw reports); `H3-08` (Unit 6, the St4.2a
     architecture operand); `H3-24` (Unit 7, the St4.2c architecture operand — the row itself did not
     exist before that unit, so this seam was outside the measured denominator until Unit 7 added it).
   - **Still pending: `H3-19`** — the `run-execution` St2.1 Answer Specs operand, the last measured
     W4-H3 content relay in this group.
3. **W4-H1 and W4-H2 returns** (`H1-01`, `H2-01`). Bring 4.2a to the `run-synthesis` St2 pattern —
   the sibling writes the same artifact class to disk and returns "output file path, chapter structure
   summary, evidence coverage notes". For `execution-agent`, the response is *already* written to disk
   ("Write the response to the file path specified by the caller"), so the verbatim return is pure
   duplication; the `Interpret or summarize … verbatim` prohibition must be rewritten in the same
   commit to permit a path plus a capped summary while still forbidding interpretation of the response
   itself.
4. **Hand the ambiguous five back before touching them.** `H3-04`, `H2-04`, `H1-02`, `H1-03`, `H2-05`
   need the isolation contract settled — including the extract-class contradiction between
   `docs/required-reference-files.md`, `run-report` St4.0 and `run-cluster` St2.3 — and `H1-02`/`H1-03`
   additionally need the 4.2 write reordered ahead of the review.

Summaries added anywhere in step 3 are capped at **20 lines and 4 KB**; the check enforces both.

## Files

| File | Role |
|---|---|
| `seam-manifest.tsv` | the exact live seam surface — one row per (seam, payload), with the anchor the check reads and the target it should reach |
| `fixture/` | fixed, byte-stable stand-in for one section's artifacts (4 chapters / 4 clusters / 8 questions / 3 sessions / 3 Part-2 drafts) |
| `make-fixture.sh` | regenerates `fixture/`; regeneration must be byte-identical (T7) |
| `check-relay-payload.sh` | the target check — per-seam and aggregate measurement, verdict, nonzero exit while unmet |
| `check-relay-payload.test.sh` | the harness's own regression proof, including the falsifiability controls |
