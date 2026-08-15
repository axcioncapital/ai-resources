---
task: fixture-mode-adoption
status: active
turn: claude
---

## Objective and scope

Decide whether the acceptance harness's fixture-derivation habit — deriving failing cases from a
valid fixture rather than storing each one — should become the normal way this harness is written.
Scope: reading the harness and the fixtures it derives from, and this state file. Excluded: changing
the harness, converting existing stored fixtures, or writing new ones.

## Lane and unit

Standard. Adoption mode. Unit 1 — judge the derivation habit against real use.

Named reason for the loop: the result needs assessing by someone other than whoever built the habit
before it counts as the house style.

## Brief

Why: the habit has been used across several units now. Whether it earns its place is an open
question, and answering it by preference rather than by evidence is how a convention ossifies.

Check against the repository: (1) the harness derives at least one failing case from a valid fixture
rather than storing it — searched `logs/scripts/work-loop-v2-slice-1.test.sh` for `mktemp`.

Evidence required: real operation of the habit as it has actually been used — how reliably the
derived cases fail when they should, the operator burden of reading a derivation versus a stored
fixture, the failure conditions under which a derivation misleads, and whether it was useful. The
evidence must be capable of showing the habit is not worth keeping.

Stop if: judging it requires changing the harness, or the decision turns on operator preference
rather than evidence.

Completion: return the operating evidence — reliability, operator burden, failure conditions and
usefulness — together with the lifecycle decision: adopt, revise, continue the trial or stop. Do not
implement the eventual target.

## Latest result

(empty — not started)

## Blocker

None.

## Next action

Claude: gather the operating evidence and return it with the lifecycle decision.
