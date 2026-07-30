REVIEW
UNIT: 2026-07-29-prime-minimum-responsibility-prove
STREAM: 2026-07-29-prime-minimum-responsibility
PHASE: prove
REPO: ai-resources
BASE: cb11500
NEXT: Claude — transcribe verbatim, adjudicate the material findings, then hold at G2

PREMISE DIMENSION

The central release failure is confirmed. I inspected `prime.md@8b49da2`, the qualified script, the capability record, the Shape criteria, the Prove evidence and the current project-consumer layout.

The package is not fit to release.

[MATERIAL F1] F-DUP is unassessed, not passed.

Objects inspected:
- `shape.plan.md` §6, F-DUP
- `prove.evidence.md:40-46`, `:123`, `:173-175`
- `prime.md@50cead2` and `prime.md@8b49da2`

Shape required the same grep to detect exactly eight known duplication declarations in the pre-change file. The evidence could not reconstruct that grep, substituted a different pattern and obtained 13 control hits.

That proves the substitute can find some duplication-shaped wording; it does not prove it includes all eight declarations the criterion meant to guard. The evidence admits a duplication phrased outside its nine alternatives would be missed.

Therefore the positive-control premise was not confirmed as specified, and F-DUP cannot carry `pass`. Record it `unassessed` and replace it with a reproducible explicit declaration list before any later release proof.

NEGATIVE RESULTS AND CLAIM-TO-EVIDENCE FIT

[MATERIAL F2] The shared marker call is a release-blocking runtime defect.

Objects inspected:
- `prime.md@8b49da2:276-295`
- `logs/scripts/prime-marker.sh@8b49da2`
- `prime-runtime-delegation.md` § Public interface
- the 28 project entries containing `.claude/commands/prime.md`
- `prove.evidence.md:67-105`

`/prime` runs from the consuming repository root but calls:

`bash logs/scripts/prime-marker.sh`

The script exists only under `ai-resources/logs/scripts/`. I independently counted 27 project commands that contain this call; none of those 27 project roots contains the script. The ai-resources control does.

All three ordinary dispatch branches reach shared Step 8h and then Step 8k. The resulting launch failure therefore prevents numbered, free-text and auto dispatch in the affected consumers. This is observed hidden coupling between prompt distribution and script distribution, not a hypothetical risk.

Release must be declined until the locator/distribution seam is corrected and the complete behavioural battery passes from an actual project-consumer root.

[MATERIAL F3] Shape’s published step-interface constraint was breached.

Objects inspected:
- `shape.plan.md:38-57`, C2
- `prime.md@50cead2` and `prime.md@8b49da2`
- `docs/session-marker.md@8b49da2:339`
- `prove.evidence.md:132-146`

Shape explicitly prohibited renumbering and required citations to delegated content to be repointed in the same commit. The completed package removed Step 8c.2 while leaving `docs/session-marker.md` citing it. It also minted new 8c identifiers despite the no-renumber constraint.

F-CITE is correctly falsified. The stale citation must be repaired, and the retained published identifiers must be reconciled against C2 before release.

[MATERIAL F4] The frozen size acceptance criterion failed.

Objects inspected:
- `shape.plan.md` §6, F-LINES
- `prime.md@8b49da2`
- `prove.evidence.md:122`, `:150-159`

The implemented command is 413 lines. The frozen acceptance threshold is 300, so the package misses by 113 lines. The intermediate ≤430 waypoint was met, but it does not replace the frozen criterion.

F-LINES is correctly falsified. Whether the smaller-but-over-target result is retained for further revision is a lifecycle decision; it cannot be described as satisfying this stream’s release contract.

[MINOR F5] The blast-radius headline overcounts one project.

Objects inspected:
- the evidence’s 28-project census and limitation
- all 28 project `.claude/commands/prime.md` entries

Within that census, 27 commands contain Step 8k’s failing call. `axcion-sector-intelligence` is the intentional short variant and does not call `prime-marker.sh`.

The evidence therefore establishes 27 affected project entries in this census, not all 28. This does not weaken the release blocker, but the durable headline “28 of 29 consumers” and the claim that variants can only understate the blast radius should be corrected.

SCOPE AND LIMITATIONS

The Prove unit respected its no-repair scope. The twelve unexecuted behavioural criteria are honestly marked `unassessed`, and the surviving scratch fixture is explicitly disclosed with its location and reason.

Stopping the battery after the shared launch failure was reasonable for this release decision. A later correction cannot inherit those twelve results: it must re-run them from a project consumer, against the then-current package.

RISK-AWARE ASSESSMENT

- Usage cost: reducing `/prime` from 830 to 413 lines is a real prompt-cost improvement, but it does not compensate for broken dispatch or the unmet target.
- Permissions surface: no external service or new broad permission surface was introduced.
- Blast radius: broad and immediate because the canonical prompt is shared while its new executable dependency is not.
- Reversibility: the Git-tracked slices are recoverable; Slice 2 can be reverted if correction is not adopted.
- Hidden coupling: confirmed between consumer cwd, canonical prompt location and script location.
- Principle alignment: executable ownership is sound in principle; the current wiring violates behaviour preservation, citation stability and the frozen size assertion.
- Problem reality: both the original stale-test problem and the new consumer-path failure were observed. The latter was isolated without mutating a real project.

G2 VERDICT

Decline release.

Land should keep the capability in an active revision state, not adopt it. Open the correction work for the script-location seam, repair the dangling interface citation, make F-DUP reproducible, and re-prove every dispatch criterion from a real project consumer before reconsidering release.

Next: paste the block above back into Claude’s `/work-loop` so it can adjudicate the findings.
