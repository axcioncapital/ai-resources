# L3 representative operating proof

**Date:** 2026-08-18  
**Corrected implementation:** `a306db36`, `041f224b`  
**Purpose:** durable evidence for the Lightweight Research Workflow's representative Light,
Standard and Deep behaviour. This record replaces reliance on session-scoped attachment paths.

## Light

Operator question: “Which L3 capabilities are complete, and what remains before L3 can close?”

Observed resolution: `Route: Light`, floor set by the base rule; no preference was overridden.
The response separated evidence, inference and gaps, identified the accepted deterministic core,
and correctly treated the unpublished House View adapter as a fenced seam rather than work L3
could invent.

## Standard — final corrected invocation

Operator question: “Assess whether the corrected L3 entry now prevents an under-controlled route
when required classifier signals are missing or invalid. Use only this repository's implementation
and tests, and keep the result internal.”

Observed resolution: `Route: Standard`, floor set by `output=analysis`. The response reported
`research-route-memo-check.sh` verdict `PASS` and produced a claim-bound memo under the corrected
format.

Material findings:

- Missing, invalid, duplicate, unknown and malformed signal inputs exit `2` without emitting a
  route.
- Any assessed `unclear` safety signal raises the floor to Standard and overrides a Light
  preference.
- Step 3 requires executable classification and instructs the actor to stop when the classifier is
  unavailable; hand calculation and fallback to Light are forbidden.
- The remaining boundary is explicit: the classifier validates the supplied vector, while deciding
  the five signal values remains a model judgment. A well-formed but mistaken assessment cannot be
  detected by this classifier.

Repository proof run against the corrected implementation:

- `research-route-l3-unit-1.test.sh`: `14 passed, 0 failed`.
- `research-route-l3-unit-2.test.sh`: `33 passed, 0 failed`.
- Bash syntax checks and `git diff --check`: pass.

## Deep

Operator request: a report on 2026–2030 European workforce-management software and implications for
Axcíon's product and positioning, with `projects/axcion-sector-intelligence` as a verify-first target
and no pipeline execution.

Observed resolution: `Route: Deep`, floor set by `output=report` and independently by `scope=broad`.
The response verified the deployed Research Workflow target, disclosed its later-stage setup gaps,
returned the `/run-preparation` handoff and ran no pipeline stage.

## Assessment

The corrected implementation meets the L3 representative-proof requirement at pilot quality:
operator-run Light and Standard behaviour, plus a verified Deep handoff. The independent review's
four material control failures are corrected. No House View adapter, alternate judgment mechanism,
retrieval runtime, propagation machinery, consumer deployment, merge or push was introduced.

Accepted limitations remain: instruction adherence and signal assessment are judgment-dependent;
the checks validate declared routing and memo structure rather than analytical quality; and a copied
command without its canonical helpers must stop rather than complete Standard work.
