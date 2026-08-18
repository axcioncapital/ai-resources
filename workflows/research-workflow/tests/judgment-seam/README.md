# Judgment seam — the command-path proof

> **When to read this:** before editing `/run-analysis` Step 3.5, and when checking whether the deep
> route still produces, challenges and decides a Unit Judgment Brief before any report-bound writing.

`docs/judgment-authority-contract.md` says what the artifact is and how it is promoted. It
deliberately does not say **which command produces it, which reviewer challenges it, or where the
route halts for the founder** — that is wiring, and this directory is the proof that the wiring
exists.

## Running it

```bash
cd workflows/research-workflow
bash tests/judgment-seam/check-judgment-seam.sh          # the seam check — must be green
bash tests/judgment-seam/check-judgment-seam.test.sh     # its own fail-capable proof
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

## Scope

This proves the seam that **creates** approved judgment. It does not check analytical quality, the
content of any produced brief, or the downstream owners past the seam — section directives, synthesis,
report architecture, chapter prose and their QC. Those bind to the approved brief in a later unit.

## Blast radius

Six project checkouts carry a copy of `run-analysis.md` and five carry `reference/stage-instructions.md`
and `reference/file-conventions.md`. They are **regular file copies, not symlinks**, so the canonical
edits proved here take no live effect in any of them until `/sync-workflow` propagates them
deliberately.
