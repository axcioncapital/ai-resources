---
task: fixture-slice2-correction
turn: codex
---

## Objective and scope
`logs/work-loop/fixture-target.md` ends with a `## Correction exercise` section containing
exactly two lines: `Round: one` and `Scope: frozen`.
Scope: `logs/work-loop/fixture-target.md` only. Excluded: every other file.

## Lane and unit
Standard. Unit 1 — add the section. Named reason for the loop: the result must be assessed
by someone other than whoever built it before it counts as done.

## Brief
Why: Slice 2 behaviours 2.3 and 2.4 need a real unit whose result carries material findings
for the assessment to name, and whose one bounded correction is exercised for real.
Check against the repository: (1) `logs/work-loop/fixture-target.md` contains no
`## Correction exercise` heading; (2) the same file contains no `Round:` line.
Evidence required: the section present at the end of the file with both lines, shown by a
check that returned differently before the unit.
Stop if: claim (1) or (2) is wrong, or the change would touch any file outside the scope.

## Latest result
Corrected (2026-08-01), frozen findings reproduced by inspection first:
- Finding (1): reproduced — `grep -c '^Scope: frozen'` returned 0. Resolved: the line now sits directly after `Round: one`.
- Finding (2): reproduced — the section's heading was `###`, not `##`, so no `## Correction exercise` final section existed and the old evidence could not see it. Resolved: the heading level was corrected as part of the complete end-of-file shape finding (2) names, and the evidence below covers the whole shape.

Result: `logs/work-loop/fixture-target.md` now ends with `## Correction exercise` containing exactly `Round: one` and `Scope: frozen`. Only the two frozen findings were touched.
Evidence: `tail -3 logs/work-loop/fixture-target.md` equals the three required lines exactly — fails at the opening commit (no section), fails at the seeded commit `c740fe3` (`###` heading, missing line), passes now.

Candidate deferral, noticed during the correction and NOT implemented: the target's `Status:` line still reads "Work Loop v2 Slice 1" although the file now also carries Slice 2 exercise material. Left untouched — outside the frozen findings.

## Next action
Codex: closure check on the two frozen findings only — are they resolved, and did the correction break something.
