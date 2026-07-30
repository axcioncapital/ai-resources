REVIEW
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
BASE: 49c8582
NEXT: Claude — adjudicate these findings; hold G1 only after the package is corrected

**Capability:** prime-runtime-delegation

Round 2. Codex, 2026-07-30. Object: `…shape.plan-v2.md`. Transcribed verbatim by Claude; immutable.

Round-2 justification (`docs/work-loop.md` § The challenged route): plan-v2 rewrote S3's owner design,
withdrew F-RULES for F-BEHAVE, and re-scoped S6 from optional to mandatory. Each changed something
review-1's verdict rested on, so this is a closure review of corrections, not a second opinion on the
same object. plan-v2 § 8's statement that no further round was planned is superseded by the round
having been run.

---

REVIEW

Verdict: REVISE BEFORE G1. Plan-v2 materially improves v1, and its literal `/prime` arithmetic is
correct, but four remaining defects mean the planned routes would not all work.

## Premise dimension

Independently observed at 49c8582:
- `prime.md` remains 411 lines and byte-identical to 8c573af.
- plan-v2 exists separately from immutable v1 and review-1.
- The hook-result correction and its positive control are valid.
- Observed-versus-inferred locator evidence is now stated correctly.
- No premise was rejected.

## Material findings

M1 — S6's receiving owners do not yet own the transferred behavior.

Objects inspected: plan-v2 §1 S6:154-170 and §6.4:457-507;
`session-start.md:443-469`; `session-plan.md:231-251`.

The transfer table says only one new line is needed, but the receiving commands explicitly return
control to `/prime` for behavior S6 deletes:

- `session-start.md:452` returns direct numbered/free-text routes to `/prime` for the pause or execution.
- `session-start.md:465` forwards auto mode expecting `/session-plan` to return to `/prime`.
- `session-plan.md:235-239` returns auto mode to `/prime` without beginning execution.
- `session-plan.md:241-245` says the numbered gate belongs to `/prime`.
- `session-start.md:349` still declares `/prime` the owner of `STRUCTURAL_RISK`.

With plan-v2's new Step 9, direct numbered/free-text and auto mode can therefore stop at the hand-back
with no owner continuing the required behavior. This is the hidden coupling S6 was meant to remove.

The citation table also marks `8c.9` retained, but drafted auto dispatch is `8c.4`; its live downstream
citations would become wrong.

Required correction: complete the downstream ownership transfer, remove every "return to `/prime`"
dependency, resolve the retired `STRUCTURAL_RISK` input, and reconcile the `8c.9` references. Budget B
must be recounted after the real owner edits; it cannot remain +12 on current evidence.

M2 — The stamped promotion sweep is sequentially idempotent, not concurrency-safe.

Objects inspected: plan-v2 S3:97-130, F-LOOP:334-341 and §6.5:510-524;
`session-feedback-collector.md:98`; `session-start.md:58-64`.

`improvement-log.md` and `friction-log.md` have append-only writers, while the repository already
classifies `improvement-log.md` as a non-append shared lost-update surface when old entries are edited.
The proposed sweep adds in-place `<!-- promoted -->` stamps.

Two concurrent wraps can both:

1. read the same unstamped finding;
2. append it to `next-up.md`;
3. stamp the source.

That produces a duplicate despite both runs succeeding. F-LOOP runs the owner twice sequentially and
cannot detect this race. A source-log rewrite can also collide with a concurrent append or archive, and
a stored line number is unstable after either operation.

The never-wrapped claim is also conditional: it is recovered only if some later wrap occurs in that
repository. That is eventual best effort, not unconditional coverage.

Required correction: use a concurrency-safe identity/claim. The smallest likely shape is a stable
promotion ID recorded in the destination plus a repo-local lock, avoiding source-log rewrites. Test two
simultaneous sweeps, not only two sequential runs. If recovery remains dependent on a later wrap, state
that limitation precisely rather than calling every never-wrapped case covered.

M3 — Budget A counts the drafted text correctly, but the drafted text is not a complete valid `/prime`.

Objects inspected: plan-v2 §3:202-229, B12:305, §6.2:399-431 and §6.4:466-474.

The arithmetic of the literal blocks is correct: 186 lines. Two functional defects remain:

- `TELEMETRY_GAP` and B12 explicitly preserve the telemetry read/nudge that the operator directed
  removed. Review-1 M4 is therefore not fixed.
- `8g` consumes `CWD_REPO`, but no drafted replacement defines it or returns it from the collector.
  The wrong-repository guard cannot execute as written.

Required correction: remove telemetry prefetch/nudge completely and establish `CWD_REPO` through a
counted interface. Recount A afterward. The margin remains ample; this does not threaten ≤300.

M4 — The reduced failure test is defensible in principle, but its recovery table is inaccurate.

Objects inspected: plan-v2 S1:72-83 and F-RECOVER/F-TESTS:318-332;
`prime-marker.sh:140-156`.

"Marker write fails → nothing written" is false for the current allocator. It creates the shared claim
directory and writes its owner breadcrumb before writing `logs/.session-marker`; the shared and per-id
marker files are also separate writes. A failure can therefore leave a claim, one marker file, or both.

The table is being used as evidence for not testing those states, but a table is not runtime evidence.
F-ENTRY proves the happy path, not recovery from the two unexecuted failures.

Required correction: describe the actual partial states. One injected failure can remain proportionate
if it is placed after the complete marker claim/write and proves the dangerous retry path, while the
other recovery claims are explicitly marked unassessed. If the plan continues to claim all three
recoveries as proven behavior, all three require execution.

## Answers to R1–R4

R1 — No. The backward-looking idea is sound, but source stamping has a concurrent check-then-act race
and creates an in-place shared-log write. Sequential idempotence does not close either failure mode.

R2 — `186` is the correct count of the literal `/prime` draft. It is not yet an honest completed-package
ceiling because `CWD_REPO` is missing and prohibited telemetry remains. Budget B is also undercounted
because S6 requires substantive receiving-owner changes. The ≤300 target is still comfortably reachable.

R3 — No. F-BEHAVE lacks the full downstream outcomes for:
- numbered × engineered/direct;
- free-text × engineered/direct;
- auto × engineered/direct;
- the explicit `auto N` input shape.

B14 observes "nothing follows" but cannot establish that ownership transferred successfully. Current
owners actually return several routes to `/prime`, so those route outcomes would fail.

R4 — The bounded F-BEHAVE register is the right reduction; do not restore an impossible every-rule
inventory. One injected failure can also be proportionate, but only with an accurate state model and
claims limited to what was actually run. As written, the table substitutes assertion for the omitted
tests and therefore partially recreates the unassessed-criteria problem.

## Risk-aware summary

1. Usage cost: A is strongly reduced; B must be recounted after the real S6 transfer.
2. Permissions: absolute script invocation remains plausible and testable from a consumer.
3. Blast radius: downstream `session-start`/`session-plan` coupling remains materially understated.
4. Reversibility: source-log stamps add conflict-prone mutations to shared historical records.
5. Hidden coupling: explicit downstream returns to `/prime` are the largest remaining blocker.
6. Principle alignment: telemetry retention contradicts the settled removal list.
7. Problem reality: locator evidence is now correctly separated into one observation plus inferred extent.

Minor: Budget C says "three scripts," while the plan lists four script owners—one extended and three new.
State that distinction explicitly.
