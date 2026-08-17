---
task: generated-symlink-remediation
status: closed
turn: operator
---

## Outcome

The canonical generator now treats manifest-managed shared-resource symlinks as checkout-local generated products through one authoritative traversal. It maintains an exact checkout-local exclude block, prevents those paths from crossing the commit boundary, installs and refreshes that guard safely, and validates generated-link health across ordinary and nested checkout depths.

The frozen Unit 6 finding is resolved: an undeclared regular file, directory, or other non-symlink at a traversed generated name is reported under `GENERATED-HEALTH:` with the repository-relative path and the manifest-local correction, while remaining untouched, unignored, and fail-open. Genuinely manifest-local resources stay outside the traversal and silent. The correction did not break the accepted behavior, per the focused 74/74 health assertions and the required regression set recorded at closure.

## Decisions that matter

- `.claude/hooks/auto-sync-shared.sh` is the single owner of generated-path calculation and of the marked local-exclude block; `.claude/hooks/pre-commit` Guard 3 consumes that block rather than recalculating membership. Health validation shares that contract instead of becoming a second owner.
- The separate `AI-RESOURCES DRIFT:` message keeps its own ownership of content divergence; the health verdict owns only occupancy of a generated name. Neither was broadened to absorb the other.
- Deferred, with reasons: `projects/strategy-os` registration repair, workspace-root stale-hook adoption, project-owned hook composition, legacy cleanup and branch rollout, and the two stale documentation claims — all outside this canonical-mechanism task and belonging to later owner-specific work. JSON escaping in aggregated `additionalContext` and script executable-mode normalization — separate hardening/cleanup concerns not required by this task's exit condition. Rerunning the five earlier installer mutation legs after the frozen correction — the correction changed only health validation and its focused test, and the already-required installer regression suite passed.
- Branch merge, rebase, push, and divergence reconciliation remain excluded and operator-gated at wrap.

## Evidence

Accepted implementation chain: `2aedc455`, `638ab8cc`, `22c0079d`, `cd959ac2`, `e0cf0ef0`, `c58fdf11`, Unit 6 implementation `be42752e`, Unit 6 correction `36e8e73f`.

Final focused and regression evidence at closure: `logs/scripts/auto-sync-shared-health.test.sh` at 74 assertions, `pass=74 fail=0 skip=0`, every fixture disposable under `mktemp`; `auto-sync-shared-excludes.test.sh` 16/16; `pre-commit-generated-guard.test.sh` 8/8; `auto-sync-shared-guard-install.test.sh` 59/59 skip=0; `pre-commit-hook.test.sh` all arms pass; `bash -n` clean on both changed shell files.

Closing evidence pointer: this closing record's commit on `main` in `ai-resources`.

## Accepted limitations

None within the stated objective and scope. The deferrals above are excluded follow-on work, not limitations on the accepted canonical mechanism.
