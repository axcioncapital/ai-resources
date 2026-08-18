# Judgment Authority Contract

> **When to read this file:** before producing, reviewing, approving or consuming a Unit Judgment
> Brief, and before binding any new consumer — including a lightweight-route House View adapter — to
> approved judgment. This is the stable interface. Everything else about judgment is implementation.

The Unit Judgment Brief is the single analytical authority between gap resolution and downstream
writing. This file says what that authority *is*, how it is created, and how a consumer may rely on
it. It is deliberately small: a consumer should be able to bind to judgment without reading any
script in `logs/scripts/`.

**What this contract covers.** The artifact shape, the lifecycle states, the independent-challenge
record, and the promotion transition. **What it does not cover:** which command produces the brief,
which reviewer is dispatched, and which downstream owners consult it. Those are wiring, they differ
per route, and they bind to this contract rather than redefining it.

---

## 1. The artifact

One artifact, three files at most, all derived from one base path. The pairing is part of the
contract and is never a caller's choice:

| File | Status | What it is |
|---|---|---|
| `{base}-proposed.md` | `proposed` | The producer's output. **Not authority.** |
| `{base}-review.md` | — | The current independent-challenge record. Earlier rounds archive to `{base}-review-round-{N}.md`. |
| `{base}-approved.md` | `approved` | Re-issued mechanically after explicit approval. **The only form a consumer may rely on.** |

A rejected outcome is recorded on the proposal itself (`status: rejected`), not as a fourth file. A
rejection creates no approved path, and there is nothing downstream to carry.

`{base}` is resolved by the consuming route, not by this contract. The Research Workflow's deep route
uses `analysis/judgment/{section}/{section}-unit-judgment-brief`; a lightweight route may choose its
own location. What is fixed is the three suffixes and their meaning.

### Required shape

Frontmatter:

```yaml
---
unit: {the unit this judgment covers}
artifact: unit-judgment-brief
status: proposed | approved | rejected
as_of: YYYY-MM-DD
approved_by: {identity}      # required when status is approved
rejected_by: {identity}      # required when status is rejected
---
```

Body — three required headings, and the separation rules that make the brief checkable:

- `## Theses` — three to five, each headed `### Thesis N — {one-line claim}`.
- `## Provisional verdict` — the strongest conclusion the evidence permits, or `unresolved`.
- `## What would change the view` — an observable condition, not "more research".

`unit:` is the routing key. The deep route's `{section}` is one instance of it; the field is named for
what it means rather than for the deep route's directory layout, so a lightweight consumer is not
forced to describe its work as a report section.

---

## 2. The three separations

The brief exists to keep three things apart that models routinely merge. Each separation has a
mechanical rule, and each rule can fail.

**Evidence is cited, never assumed.** Every thesis cites at least one existing claim ID in the
canonical form — `[Q1-C05]`, `[Q2-A03]`, `[GF3-C02]` (`reference/quality-standards.md` § Claim ID
Invariant). A thesis with no claim ID is an interpretation with no evidence basis and is refused.

**Context frames; it never supports.** Axcíon context — current priorities, operating posture,
strategy — may say why a conclusion matters and how it is framed. It may never stand in as evidence
or raise confidence. Context statements carry a `Context:` lead-in, and a `Context:` line may not
cite a claim ID: a context statement that cites evidence is evidence wearing a context label, which
is the precise move this separation exists to catch.

**The verdict rests on evidence.** `## Provisional verdict` cites at least one claim ID. A verdict
supported only by context is context deciding the outcome.

No new identifier scheme is introduced. Separation is enforced by **position** — where a statement
sits and what lead-in it carries — because a new ID family would be one more thing to maintain and
one more thing to get wrong, and position is already load-bearing in this workflow.

---

## 3. The lifecycle

Four states. Two artifacts hold them, and neither duplicates the other:

| State | Where it is recorded | Meaning |
|---|---|---|
| **proposed** | brief `status: proposed` | produced, not yet challenged or decided |
| **reviewed / dispositioned** | challenge record `status:` | challenged, and every required-change finding carries a terminal disposition |
| **approved** | brief `status: approved` + `approved_by:` | explicitly approved; the only downstream authority |
| **rejected** | brief `status: rejected` + `rejected_by:` | explicitly rejected; terminal, never authority |

**The reviewed state lives on the challenge record on purpose.** Putting it on the brief as well
would mean two files asserting the same fact, which is how they come to disagree — and a second
place to approve from is a second approval system, which this contract does not have.

An approval with no approver is not an approval, and a rejection with no rejecter is not a rejection.
Both are refused.

---

## 4. The independent challenge

A brief becomes authority only after a reviewer **that did not write it** has challenged it and every
required-change finding has been disposed of durably.

The challenge record's frontmatter:

```yaml
---
unit: {unit}
artifact: unit-judgment-brief-review
reviews: {path to the exact proposal reviewed}
reviews_sha256: {sha256 of that file, exactly as reviewed}
review_round: {1, 2, 3, ...}
status: findings-only | dispositioned
as_of: YYYY-MM-DD
---
```

Then a ledger of required-change findings, or the explicit empty ledger `findings: none`:

```
finding: F1
tags: permission-breach, decision-conflict: D-12
disposition: PENDING
reason:
```

**An absent ledger is malformed.** A reviewer that raised nothing must say so, because silence and
omission read identically and only one of them is a review.

### The binding is what forces re-review

`reviews_sha256:` binds the record to the bytes actually reviewed. Revise the proposal and the
binding breaks, the challenge goes stale, and promotion refuses until a new round runs against the
revised text. Nothing has to remember to ask.

### Rounds are kept, not overwritten

Before a new round is written, the current record is archived at `{base}-review-round-{N}.md`. This
is not bookkeeping. A later reviewer writing the same path could otherwise replace a round-1
permission breach with `findings: none`, and a gate reading only the current ledger would clear it.
Every finding id any earlier round raised must still appear in the current ledger, where the ordinary
disposition rules apply to it.

### The two terminal dispositions

| Disposition | Meaning | Constraint |
|---|---|---|
| `REVISED-AND-RE-REVIEWED` | raised earlier, the proposal was revised, and this round confirms it resolved | requires `review_round` ≥ 2 — nothing can have been re-reviewed in round 1 |
| `OPERATOR-ACCEPTED` | the operator read it and accepts the brief as it stands, with reasons | **refused** for a `permission-breach` finding |

`PENDING`, or an absent disposition, is the un-disposed state and never clears.

**Two refusals are absolute.** An evidence-permission breach cannot be disposed of by approval — that
is the exact laundering the first judgment trial performed. And a conflict with an unrevoked operator
decision that is **accepted as it stands** must name the decision that settles it, in a `settled-by:`
line; citing the very decision it conflicts with does not settle anything.

That second rule binds `OPERATOR-ACCEPTED` only, and the asymmetry is deliberate: accepting a conflict
asserts that some other decision permits it, so the record must say which. A finding resolved by
revision no longer conflicts — the revision removed it and the following round confirmed that — so
requiring a settling decision there would refuse the ordinary way a conflict gets resolved.

---

## 5. Promotion

Approval is the one transition where a model could quietly change what a human signed off. So it is
mechanical, and one helper performs it:

```bash
bash logs/scripts/promote-judgment-brief.sh {base}-proposed.md \
  --approval "<the operator's verbatim reply>" \
  --approved-by "<the approving operator's identity>"
```

It changes `status:`, adds `approved_by:`, and swaps the banner. **Everything from `## Theses` down is
carried byte for byte, and it refuses to write if that is not true.** What governs downstream is
byte-for-byte what the operator read.

It refuses: a reply carrying no approval, a missing or placeholder approver, an existing approved
brief, a rejected proposal, a proposal failing its own shape check, and a challenge that is missing,
stale, or carries an undisposed finding.

---

## 6. The consumption interface

This is the whole surface a consumer binds to. A consumer needs nothing else from judgment.

**Identify the artifact.** Resolve `{base}` for the unit, then use the three suffixes in § 1.

**Validate before relying on it:**

```bash
bash logs/scripts/check-judgment-contract.sh {base}-approved.md
```

Exit `0` means valid downstream authority. Every other exit means *do not proceed*, and the code says
why: `3` missing, `4` not approved (still proposed, or rejected), `5` no claim IDs, `6` structural
failure, `10` bad usage. Branch on the code, never on the prose.

Add `--allow-proposed` to shape-check a proposal before review. It accepts a structurally sound
proposal and still reports it as **not** authority.

**Check the challenge** (only needed if a consumer gates on review state itself; promotion already
enforces it):

```bash
bash logs/scripts/check-judgment-challenge.sh {base}-proposed.md [--shape-only]
```

Exits: `0` cleared, `3` no challenge, `4` stale, `5` malformed, `6` undisposed finding, `7` laundered
breach, `8` unresolved decision conflict, `9` dropped finding, `12` lost round.

**Consume the content, not just its existence.** A gate that checks an approved brief *exists* and
then drafts from something else has proved nothing. Pass the approved brief's content to whatever
authors downstream, and trace each downstream claim to the thesis it serves.

### What a new consumer must not do

- Do not author the approved file by hand, or by asking a model to "write the approved version".
  Theses drift between what the operator read and what governs the work, and nothing afterwards can
  detect it.
- Do not add a second approval path, a second House View artifact, or a parallel judgment record.
  Bind to this contract or hand back.
- Do not treat a proposed or rejected brief as authority because it is the only one on disk.

---

## 7. Files

| File | Role |
|---|---|
| `reference/unit-judgment-brief.template.md` | the artifact shape, with the authoring guidance |
| `logs/scripts/check-judgment-contract.sh` | shape, status and the three separations |
| `logs/scripts/check-judgment-challenge.sh` | challenge binding, rounds and dispositions |
| `logs/scripts/promote-judgment-brief.sh` | the one mechanical approval transition |
| `logs/scripts/*.test.sh` | the fail-capable regression proofs for each |

Deployed projects receive these by `/sync-workflow` file copy, not by symlink — a canonical edit here
does not take live effect in any consumer until it is propagated deliberately.
