# S1 representative proof substrate

The reusable half of the S1 representative chapter regression: one semantically real input
corpus, one frozen verification response, one explicit rubric and one deterministic scorer.

It exists so the two comparison runs — the same chapter verified at the pre-S1 baseline and at
current `HEAD` — are scored against a stored contract rather than against each other's output or
against anyone's recollection. Building it is deliberately separate from running it: the runs are
attended, carry an operator halt, and involve a fresh independent evaluator. None of that happens
here, and nothing in this directory performs a workflow run, calls an API, or reads client data.

## Running it

```bash
bash score-specimen.sh                    # score ./specimen — the reference valid specimen
bash score-specimen.sh --specimen DIR     # score one run's output directory
bash score-specimen.sh --check-baseline   # validate the recorded pre-S1 revision alone
bash score-specimen.test.sh               # the negative controls — must stay green
```

`score-specimen.sh` exits 0 on `verdict: PASS` and 1 on `verdict: FAIL`, naming each failing
check. `score-specimen.test.sh` mutates a throwaway copy of the reference specimen once per
check and asserts the matching failure; it is the evidence that the scorer can fail at all.

## What is here

| Path | What it is |
|---|---|
| `rubric.md` | Part A — the eight deterministic checks the scorer decides. Part B — what the fresh evaluator judges about analytical meaning at the S1 relay boundary, kept out of the scorer on purpose. |
| `corpus/1.1-chapter-01.md` | The chapter under verification. Ten claim IDs, evidence separated from interpretation, three planted defects for the verification pass to find. |
| `corpus/1.1-Q1-extract.md`, `corpus/1.1-Q2-extract.md` | Pass-2 research extracts: evidence tables carrying the `Q[n]-C[##]` IDs, coverage trackers, gaps. |
| `corpus/1.1-gap-extract-pass-1.md` | The Step 3.S3 gap-fill extract carrying `GF1-C01`, recorded undated on purpose. |
| `corpus/frozen-verification-response.md` | The fixed stand-in for the GPT-5 fact-verification reply. Both runs are handed this exact text; neither calls an API. |
| `specimen/` | The reference **valid** run output — chapter, verification report, capped handoff summary, checkpoint. What a passing run looks like. |
| `expected/baseline-revision.txt` | The pre-S1 boundary revision and how it was derived. |
| `expected/claim-ids.txt` | The ten claim IDs the chapter must still carry. |
| `expected/required-artifacts.txt` | Role → path for the four artifacts a scored run must leave behind. |
| `score-specimen.sh` | The deterministic scorer. |
| `score-specimen.test.sh` | Thirty-six negative controls plus two positive cases — the valid reference specimen, and the decorated summary form the current-HEAD run emitted. |

## The pre-S1 baseline

`f18ed58d6c96b0f97fc677fb7c90073336f310e4` — the parent of `17cc5726`, the first commit that
converted canonical workflow source under S1. The earlier S1 commit `7e2b97a6` is excluded: it
added only the state file and `tests/s1-relay/`, and converted no relay. The full derivation is
recorded in `expected/baseline-revision.txt`, which the scorer validates, so no run has to
re-derive or remember it.

## The planted defects

The corpus chapter contains three deliberate faults, and the frozen response flags exactly those
three. They exist so the verification pass has real structure to relay — a verdict, three
discrepancy blocks, three claim IDs, three issue types — rather than an `APPROVED` with nothing
in it.

| Claim ID | Issue type | The fault |
|---|---|---|
| `Q1-C02` | Overstated | An average-deal-size inference stated inside the evidence section, derived from a value series that excludes the undisclosed transactions. |
| `Q1-C04` | Category-leakage | Market-level adviser concentration written as a claim about how every manager runs its process. The extract records Scope Fit as "Adjacent — market-level, not manager-level". |
| `GF1-C01` | Undated | Gap-fill guidance cited with no publication date; the extract records the date as not captured. |

## Relationship to `tests/s1-relay/`

`tests/s1-relay/` is the deterministic byte-accounting proof: fixed-size filler artifacts whose
only job is to make per-seam payloads measurable. It carries no claim IDs and no verdict or
discrepancy structure, so it cannot answer the representative question. **It is not modified,
extended or read by anything here** — the accepted 40/40 seam position depends on its fixture
staying byte-stable.

This directory answers the other half: whether one chapter's meaning, attribution and structure
survive the same relays. The two are independent and are run independently.

## Synthetic

Every entity, source, figure and finding in `corpus/` is invented for regression testing. The
Halden Secondaries Register, Vestbanken Institutional Research and the Nordic Institutional
Investors Forum do not exist, and nothing in these files is a factual claim about the world. The
analytical *structure* is real — sourcing, claim IDs, evidence/interpretation separation,
hedging, scarcity handling — because that structure is what the regression tests. The facts are
not, because the regression does not need them to be and asserting them would be worse than
useless.
