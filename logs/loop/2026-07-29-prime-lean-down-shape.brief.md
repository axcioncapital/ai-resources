UNIT: 2026-07-29-prime-lean-down-shape    STREAM: 2026-07-29-prime-lean-down    PHASE: shape
REPO: ai-resources                         BASE: fd3ae2608fb05f5d63a95cc6df96247559db0132    NEXT: Claude

BRIEF
Need: define the smallest safe package that removes the allocator implementation and
duplicated rationale from /prime without overstating this unit as a whole-command lean-down.

Premises to verify:
- Frame evidence at fd3ae26 is complete and its four findings remain current. [open; re-check paths]
- prime-allocator.test.sh still scrapes prime.md and passes 19/0 before planning. [run]
- 27 consumers are symlinks; axcion-design-studio remains a byte-identical real fork. [inventory]
- The allocator block still contains 49 executable and 88 comment-only lines. [re-derive]
- Auto mode remains unchanged and deferred under F4. [scope check]

Scope: produce the immutable Shape PLAN only; make no change to the object under work.
The plan must name the intended executable owner, complete call path and exact affected files;
keep the running implementation and its test coupled throughout every Build slice;
explicitly disposition the frozen axcion-design-studio fork without writing to that sibling;
place each line-local anti-regression warning beside the code whose failure it prevents;
define vertical Build slices, per-slice evidence, rollback, and Prove falsification checks.
No marker format, allocation semantics, task source, menu, mission or auto-mode change enters scope.

Falsified if the plan permits two canonical allocator owners, leaves the test scraping removed
text, silently treats the frozen fork as updated, drops line-local invariants, changes observable
session artifacts, or cannot be reversed without altering marker state.
