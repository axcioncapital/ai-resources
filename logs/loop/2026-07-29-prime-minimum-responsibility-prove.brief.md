BRIEF
UNIT: 2026-07-29-prime-minimum-responsibility-prove
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: prove
REPO: ai-resources
BASE: 8b49da2
NEXT: Claude — run the behavioural battery in a scratch checkout, then Codex for the G2 review

**Capability:** prime-runtime-delegation

**Operator-directed, 2026-07-29** (S3-060 authorization, directive 8: *"Once build-4 closes, open Prove
and send the evidence to Codex for G2 review."*). Opened at the close of build-4, which was the stream's
last Build slice.

Need: every Build slice has landed — S1, S3, S2 and merged S4+S5 — taking `prime.md` from **635 to 413**
lines with dispatch unchanged at 147. Nothing in the stream has been independently reviewed since the
Shape unit's pre-implementation review, and **no `/prime` has ever executed the compressed orientation
text.** Prove closes both gaps: measure the result against every criterion the Shape plan declared, then
obtain the post-implementation Codex review and stop at G2.

Scope: the whole stream's result, judged against `…shape.plan.md` § 6 — eighteen criteria, F-LINES
through F-QUAL. Judge what Shape said would falsify success, not whether the work looks reasonable.

**Four criteria are already evidenced by the Build units and are carried, not re-run:**
- **F-LINES — FALSIFIED and recorded.** 413 > 300. Per D2 the frozen assertion is not renegotiated; the
  shortfall (113) is reported unmet. The ≤430 waypoint is met by 17. This is a *recorded falsification*,
  not a pending measurement — do not re-open it as though the number might change.
- **F-ALLOC** — `prime-allocator.test.sh` 19/0 against the running implementation (build-2, re-run
  build-4), with a falsification control proving the suite can fail.
- **F-SEED** — the fail-safe seed ordering is intact in `prime-marker.sh:67–81` and is the mutation the
  build-2 control used to force a red run.
- **F-QUAL** — `prime-marker.sh` traces to the `/develop-ai-resource` disposition recorded as D3.

**The remaining fourteen need real dispatch runs, and they must not run in a working checkout.**
F-MENU, F-NUM/F-FREE/F-AUTO, F-1GATE, F-8AGATE, F-8BNOGATE, F-ARTIFACTS, F-DIRECT/F-ENG, F-MISSION and
F-FAIL all write markers, session headers, mandates, plan files and run manifests. Executing them here
would mutate the very artifacts F-ARTIFACTS asserts on and would allocate real S{N} markers into the
live sequence. **Use a scratch checkout**, and say in the evidence which checkout each run used.

Premises to verify:
- `…shape.plan.md` § 6 is still the operative criteria table — plan-v4 and plan-v5 amended § 4/§ 5
  arithmetic and the option set, **not** § 6. Confirm by reading before measuring against it.
- F-DUP's positive control fires: the 8 duplication declarations must be found by the same grep on the
  **pre-change** file. An empty result is not evidence until the control has shown the grep can hit.
- F-CITE's § 0 C2 grep across all 14 files still resolves — Slice 4 removed no step, but it did move
  rationale into five documents, so cross-file citations changed.
- F-NOIMPORT: neither `CLAUDE.md` grew and nothing landed in `harness-rules.md`. Slice 4 relocated prose
  into `docs/` and one command; confirm none of those are always-loaded.

Falsified if: any behavioural criterion fails — a dispatch path that does not dispatch, a gate that
stops zero or twice, a guard that fails open, a missing or misnamed artifact. **Report the failure; do
not repair `/prime` inside this unit.** A slice that cannot be verified is a finding here, not a fourth
gate.

Gates: `/risk-check`, `/qc-pass` and subagent dispatch remain **operator-declined** unless the operator
lifts that for this unit — recorded as declined, never as passed or waived. G2 is a real operator stop:
the held package is the evidence, the Codex review, the adjudication, and any residual limitation.
