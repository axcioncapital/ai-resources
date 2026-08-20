---
task: canonical-rw-l4-integrated-pilot
status: closed
turn: operator
---

## Outcome

**Stopped without L4 acceptance.** The manual cross-repository integration and the founder reject
path were exercised end to end; the approved plan's terminal condition was not met.

What was proved: the safety model holds. A `proposed` brief never became authority, four independent
challenge rounds ran with their ledger chain intact, permission-breach findings could not be waived
into approval, promotion stayed fail-closed throughout, and the founder gate — when actually
exercised — refused. Patrik rejected the precision-components proposal at the Step 3b.2 gate; the
rejection is durably recorded and the contract validator now returns `NOT-APPROVED` against that
artifact.

What was not proved, and is unmet rather than accepted: there is no approved House View, no
downstream analysis or prose, no independent content QC, no final canonical/project regression or
representative Light/Standard/Deep route evidence, and no completed burden comparison against L1.
Those are L4 acceptance proofs that did not happen. They are not limitations of a delivered result.

The operating lesson the pilot returned, and the reason it stopped where it did: the review path
imposed three founder revision gates and 22,214 words of review records before the rejection. Each
round resolved the findings it was given and surfaced another. The founder's stated rationale —
`I dont have time for ceremony` — is a verdict on that burden, not on the safety mechanics.

## Decisions that matter

- **Patrik rejected the proposal (2026-08-20)**, verbatim rationale `I dont have time for ceremony`.
  Recorded once as **Decision 36** in the consumer's `logs/decisions.md`. Terminal: no approved form
  was created, `promote-judgment-brief.sh` was never run, and `/run-analysis` stopped before Step
  3b.4 / 3c / 4.
- **Codex chose closure over another case or review cycle.** The current proposal is terminal, a
  different route to the downstream proofs would require new operator intent, and the operator had
  explicitly said they have no time for further ceremony. This closure does not claim L4 success and
  authorizes no successor case, rollout, merge, push or deployment.
- **Round 4's F10 was left `PENDING` and undisposed.** A rejection does not require dispositions;
  disposing it would have implied a route the rejection closed.
- **`precision-components` retains no judgment authority.** Both routes stay fail-closed for it under
  Decision 35, and the rejected proposal cannot be revived as authority or reused as a successor case.

Deferrals retained, with reasons:

- **The last-thesis validator defect is unfixed** — it sat outside L4's active content path and
  manual per-identifier checking compensated at every round that depended on it.
- **The missing Decision 41 reference, the Decision 19 ↔ CC-1 wording tension, and the dangling
  Decision 34 cross-reference all remain open** — none affected the rejection, and none justified
  further work after the stop. Round 4 confirmed Decision 34 is a dangling cross-reference like
  Decision 38, not a lost entry, which narrows that item without closing it.
- **The proposal-length deferral is discharged** by the rejection: a rejected brief is not compressed.

## Evidence

- **Consumer** (`projects/axcion-sector-intelligence-l1-trial`, branch
  `trial/l1-repeat-precision-components`): rejection at
  `0c61d2a1e60332076b9b335bff2f807aeb7d4713`, on the Unit 20–25 chain ending
  `36b1e696184e618eec03368e115eaccf871c1d77` (round 4), `769f68a3e3c0996cbd01a5d54d6bf604e0422953`
  (round 3) and `8bd47071` (round 2).
- **Integration**: Unit 26 handback `225bf946471ab4caf94d8d43ceadf09698fbae1c`, plus the commit
  carrying this closing record.
- **Fail-closed state, verified**: `check-judgment-contract.sh … --allow-proposed` returns **exit 4
  `NOT-APPROVED`** — "this brief was rejected by Patrik and is not downstream authority" — where the
  same file returned exit 0 `VALID` before the rejection edit. The rejected proposal's body is
  preserved byte-for-byte at `6142d817bf4890856287400ca43975ea14ecc2ed923b0b24fbbb9e1b9a29d192`
  (10,034 bytes) as the durable record of what was refused.
- **Challenge chain intact**: round 1 `5460ec7f…2e31`, round 2 `ee2e7550…135fe`, round 3
  `6bd74b40…4813`, current round-4 review `4a55cc55…9593` — all unchanged, no round lost, every
  finding F1–F10 carried under its original id and tags.
- **No authority and no downstream output exists**: no approved artifact at the active base;
  `analysis/section-directives`, `report/` and `analysis/chapters` untouched. The preserved legacy
  `-approved.md` under `superseded/2026-08-18/` stopped governing at `a880495` under Decision 35 and
  was not touched by this task.
- **Nothing was pushed, merged or deployed.** All commits are local, on their own branches.

## Accepted limitations

None. L4 is explicitly **not** accepted. Its unmet terminal proofs — approved House View, downstream
analysis and prose, independent content QC, final regressions, representative-route evidence and the
L1 burden comparison — are outcomes that did not happen, and must not be read as accepted limitations
of a delivered result or as implied future work.
