# Independent-review handoff

Prepare this handoff only after production QA passes on an exact candidate. Writing Studio prepares the packet; the destination workflow or operator invokes a separate fresh-context reviewer.

## Packet contents

Include only what the reviewer needs to judge the candidate:

- exact candidate wording, path, and version identity;
- authority and evidence mapped to material claims;
- intended audience and claimed reader prerequisites;
- the asset's distinct contribution;
- material limitations and unresolved issues relevant to judgment;
- the production contract; and
- destination review constraints.

Keep the packet bounded. Link or excerpt only the evidence needed to assess the candidate's material claims; do not make the reviewer reconstruct the entire production process.

## Contamination exclusions

Unless the destination review method explicitly requires them, exclude:

- discarded openings and unused fragments;
- the internal grounding ledger;
- drafting rationale and branch deliberation;
- production self-assessment or QA commentary;
- earlier reviewer conclusions; and
- operator preferences that are not governing constraints.

These exclusions preserve a cold review. Do not conceal a material limitation or authority condition under the label of contamination.

## Version binding

Bind the packet and every returned finding to the exact candidate identity. If wording changes materially after the packet is prepared, invalidate the packet, create a new candidate identity, repeat production QA, and prepare a replacement packet.

The reviewer returns findings and any destination-defined gate result against that identity. Writing Studio may apply authorised findings in Improve mode, but may not issue, revise, or overrule the independent verdict.

## Downstream authority

Keep these as separate events:

1. `READY_FOR_REVIEW` — Writing Studio has produced and self-checked a candidate.
2. Independent review — a fresh context judges the exact candidate.
3. Destination acceptance — the named acceptance owner decides whether the candidate meets the destination need.
4. Founder approval when required — Patrik's decision binds to exact final wording.
5. Publication — the destination's publication owner acts after required approvals.

No earlier event grants a later authority. A material change after review or approval repeats every affected gate.

## Handoff output

Return:

```text
READY_FOR_REVIEW
candidate: <exact identity and path>
packet: <manifest or authorised paths>
production_qa: <bound PASS record>
review_owner: <destination workflow or named owner>
```

Do not mark the asset approved, accepted, publishable, or published.
