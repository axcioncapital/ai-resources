# Judgment seam — the command-path proofs

> **When to read this:** before editing `/run-analysis` Step 3.5 or any downstream owner's dispatch in
> `/run-analysis` Step 4, `/run-synthesis` or `/run-report`, and when checking whether the deep route
> still produces, challenges, decides and then actually *obeys* a Unit Judgment Brief.

Two checks live here, and they prove different things:

| Check | Question it answers |
|---|---|
| `check-judgment-seam.sh` | is approved judgment **created** properly — produced from separated inputs, independently challenged, decided by the founder? |
| `check-judgment-consumption.sh` | does approved judgment then **govern** — do synthesis, report architecture, report prose, section directives and compliance QC validate it, receive it by path, and shape their output from it? |

Passing the first and failing the second is the state the workflow was in after Unit 2: a correctly
produced authority that nothing downstream was required to obey.

`docs/judgment-authority-contract.md` says what the artifact is and how it is promoted. It
deliberately does not say **which command produces it, which reviewer challenges it, or where the
route halts for the founder** — that is wiring, and this directory is the proof that the wiring
exists.

## Running them

```bash
cd workflows/research-workflow
bash tests/judgment-seam/check-judgment-seam.sh                 # creation — must be green
bash tests/judgment-seam/check-judgment-seam.test.sh            # its fail-capable proof
bash tests/judgment-seam/check-judgment-consumption.sh          # governance — must be green
bash tests/judgment-seam/check-judgment-consumption.test.sh     # its fail-capable proof
```

`check-judgment-seam.sh` exits `0` when every assertion holds, `1` when one or more fail, `2` on a
usage or input error. It takes an optional path so an older or mutated command body can be checked;
`--format tsv` emits one row per assertion.

## What it asserts, and why each one exists

| Id | Assertion | The failure it catches |
|---|---|---|
| `J0` | the `### Step 3.5:` seam exists before Step 4 | the route the workflow actually had: resolved gaps flow straight into section directives, no judgment is ever produced, and nothing downstream can tell |
| `J1` | the producer's two bundles are **disjoint** path lists | evidence and Axcíon context merged into one input, which is what makes context able to stand in as evidence |
| `J2` | the proposal is shape-checked with `--allow-proposed` before review | a reviewer dispatched against a malformed brief |
| `J3` | the reviewer gets the proposal **by path**, and 3.5a's return is withheld | a reviewer briefed on the producer's account is reviewing that account, not the brief |
| `J4` | the digest is computed from the proposal file, never reported by a model | a binding that says what a sub-agent claimed rather than what the file is |
| `J5` | four closed decision branches, halt stated unconditional | a fifth "proceed" path around the founder |
| `J6` | the else-branch promotes nothing | silence, a question or a partial reply read as approval |
| `J7` | revise routes back through 3.5a **and** 3.5b as a new round | a revised brief carrying a clearance earned by the text it replaced |
| `J8` | approve invokes the promoter with `--approval` **and** `--approved-by` | an approved file authored by hand, whose theses can drift from what the founder read |
| `J9` | reject sets `status: rejected` + `rejected_by:` and creates no approved path | a rejection that leaves something downstream can rely on |
| `J10` | the gate validates `-approved.md` and never accepts a proposal | downstream work running on a brief nobody approved |
| `J11` | rounds after the first pass the prior ledger and demand a per-id verdict | a re-review that proves the revised brief was read, while the ledger claims it proved each earlier finding resolved — two different claims |
| `J12` | `REVISED-AND-RE-REVIEWED` requires this round's explicit confirmation | the main session marking a finding resolved on its own reading, asserting an independent re-review nobody performed |

## What makes it trustworthy rather than a keyword scan

Every assertion is derived from the **structure** of the live command body — which sub-step a
directive sits in, which decision branch it sits in, whether two labelled lists share a path — never
from a word being present somewhere in the file. Three controls hold that honest:

- **`Tpre`** runs the check against the pre-seam command body taken from Git and requires all thirteen
  assertions to fail. An always-green check is indistinguishable from a working one without it. The
  baseline is **pinned** to `4a2a0b96` — Unit 1's accepted commit, the last state of this command
  before Step 3.5 existed — and not to `HEAD`, which stopped being the pre-seam body the moment the
  seam was committed. The case self-checks the pin: a baseline that already contains Step 3.5 fails
  loudly rather than reporting a red it never earned.
- **`T0b`** appends paragraphs to that same pre-seam body asserting the seam is wired. No verdict may
  move. Prose cannot buy a pass.
- **`M1`–`M12`** each apply **one** mechanical edit to a copy of the **real** command body and require
  exactly the targeted assertion to flip, with nothing else moving. A check that degraded wholesale on
  any edit would fail these rather than pass them.

## The N-series proves the halt, not the wording

`N1`–`N6` read no command body at all. They build the artifact states the route must refuse — no
approved brief, a sound proposal that has not been approved, a rejected brief, an approved brief with
its evidence stripped, a challenge bound to bytes that have since changed, an undisposed
`permission-breach` finding — and run the **real** helpers the command body invokes against them,
asserting the exact exit code each time. Two of them (`N2b`, `N5a`) are controls that must pass: a
gate that refused everything would otherwise satisfy the refusals for free.

## The consumption check — one invariant, five owners

`check-judgment-consumption.sh` reads three command bodies and asks the same four things of each
owner, in that owner's **own dispatch region** — a directive elsewhere in the file does not count:

| Id | Owner | Entry point | Directly invokable? |
|---|---|---|---|
| `C1` | section directives | `/run-analysis` Step 4 | no — protected by Step 3.5e in the same command |
| `C2a`/`C2b` | cluster synthesis | `/run-synthesis` Steps 0b, 2 | **yes**, fresh session |
| `C3a`/`C3b` | report architecture | `/run-report` Steps 4.0b, 4.1 | **yes**, fresh session |
| `C4` | chapter prose | `/run-report` Step 4.2a | yes, within `/run-report` |
| `C5` | compliance QC | `/run-report` Step 4.2c | yes, within `/run-report` |
| `C6` | all three commands | the authority-conflict rule | — |
| `S1a`/`S1b` | report-mode prose refinement | `/produce-prose-draft` Phase 0b, Phase 2 | **yes**, standalone |
| `S2a`/`S2b` | report-mode formatting + H3 | `/produce-formatting` Phase 0b, Phase 2 | **yes**, standalone |
| `S3` | final editorial-integration QC | `/produce-formatting` Phase 3 | yes, within `/produce-formatting` |
| `S4` | both Stage 5 gates | the section-mode exemption | — |

**Stage 4 is not the last thing that touches the report.** `/produce-prose-draft` develops the hardest
claims — precisely the ones an approved House View constrains — and `/produce-formatting` restructures
presentation and runs the QC that signs the report off. Both are invoked directly, after every Stage-4
control. An approved brief governing everything up to Stage 4 and nothing after it is governed where it
is cheapest to check and unguarded where the last word is written.

`S3` adds the two conditions the final QC needs: it judges House View fidelity, thesis trace continuity
and drift against the approved brief and the formatted prose **only** — the Phase 2 change log and the
Stage 1 fixes-applied log may explain a finding but never satisfy the check, because a producer that
dropped a trace will not report having dropped it.

`S4` runs in the opposite direction from every other assertion. Section-mode projects do not run the
judgment path and have no brief to consume, so both Stage 5 gates are scoped report-mode-only and must
say section mode gains no prerequisite. `SM` proves that control is live: a governance check that
quietly imposed a judgment prerequisite on section-mode would break working projects to satisfy an
assertion.

### Excluded, with the reason

`/produce-jargon-gloss` is **not** wired, and the reason is its own contract rather than convenience.
The `jargon-gloss` skill is additive at the term level: its hard constraint forbids changing argument
structure, analytical conclusions or voice; Check 2 (analytical-claim protection) refuses to apply a
gloss that would alter an analytical claim and flags it instead; and its output checklist requires that
no analytical claim, sourced statement or quoted material has been modified. It cannot materially alter
report-mode analytical content, so gating it would add ceremony without closing anything.

**VALIDATE** the entry runs the contract helper and halts on nonzero; **PASS** the brief reaches the
sub-agent by path; **USE** the sub-agent must shape its output from the theses, verdict, countercases
and change conditions; **TRACE** the output names the `Thesis N` each consequential claim or structural
choice implements. `C5` adds two: the QC receives the brief **without** step (a)'s account of what the
drafter did, and it checks drift beyond the approved view as well as evidence-permission overreach.

`C6` is the limit on all of it. Approved judgment governs downstream work; it does not outrank the
permission tables, scarcity instructions, gate-clearance caveats or operator decisions. A genuine
conflict halts and surfaces both — silently preferring either one is a decision no owner here may make.

### Why its proof is built the way it is

The claim splits into two halves that are each satisfiable alone, so each is proved separately: `C2a`
and `C3a` prove the entry **calls** the helper and halts on nonzero; the `A`-series proves the helper
**returns** nonzero on missing, proposed, rejected and structurally invalid authority, with `A5` as the
control that accepts a valid one. Proving only the first gives a command dutifully calling something
that always says yes; proving only the second gives a correct helper nothing calls.

`U1`–`U5` are the series that matters most. Each reduces one owner's use instruction to *"verify the
approved brief exists at that path"* — the path handoff survives, so the owner still receives the
brief and simply stops being told to do anything with it — and requires that owner's assertion to fail.
An existence-only gate cannot pass this suite for free. `P1`–`P5` remove each path handoff, `G1`/`G2`
each entry gate, `Q` the compliance QC's independence, and `X` the conflict rule; every one flips
exactly its own assertion on a copy of the real command bodies.

## Scope

Together these prove approved judgment is created properly and is required to govern. Neither checks
**analytical quality**: whether the theses are any good, and whether a chapter's prose genuinely
carries the thesis it cites, are judgments for a fresh-context reviewer and the representative
semantic proof, not for a command-path check.

## Blast radius

Six project checkouts carry a copy of `run-analysis.md` and five carry `reference/stage-instructions.md`
and `reference/file-conventions.md`. They are **regular file copies, not symlinks**, so the canonical
edits proved here take no live effect in any of them until `/sync-workflow` propagates them
deliberately.
