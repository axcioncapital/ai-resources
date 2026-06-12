# Session Plan — 2026-06-12 S6

## Intent
Run 2 picked menu items in order: fix the split-log.sh code-fence bug in both script copies and verify against the real failing file; confirm the non-/prime per-id-marker gap is already logged (it is — zero work remains on item 2).

## Model
Recommended: sonnet (mechanical script fix + log edit). Session is running on a different model; advisory only, no blocker.

## Source Material
- `logs/improvement-log.md` — entry "2026-06-12 — split-log.sh: skip ## headers inside fenced code blocks" (status: open, severity low, target: `logs/scripts/split-log.sh`).
- `logs/improvement-log.md` — entry "2026-06-12 — Non-/prime session start writes no per-id marker" (status: logged pending) — item 2's deliverable, already present.
- `logs/session-notes.md` S4 cont. Next Steps — origin of both picked items.
- `logs/scripts/split-log.sh` (canonical copy, 83 lines, bash-3.2 portable).
- `workflows/research-workflow/logs/scripts/split-log.sh` (template copy — still uses `mapfile`, bash-3.2 incompatible; separate MED defect logged in positioning-research).
- `projects/axcion-brand-book/logs/decisions.md` — the real failing file (template placeholder `## YYYY-MM-DD — {one-line decision title}` on line 8 inside a fenced code block, lines 7–19; 29 real entries + 1 fake).

## Findings / Items to Address

### Item 1 — split-log.sh code-fence bug
- Root cause: line 22 `grep -n '^## '` matches `## ` lines inside fenced code blocks. The fake header becomes `HEADERS[0]`; date derivation fails ("could not derive YYYY-MM from header"), exit 1, archival blocked.
- Fix: replace the bare grep with a fence-aware awk scan that toggles a fence flag on lines starting with ``` or ~~~ and emits line numbers only for true `^## ` headers outside fences.
- Secondary surfaces (same class): the idempotency check at lines 56–57 greps `^## ` over the archive file and archive block. The block-side `head -1` is safe (block starts at a true header), but the archive-file `tail -1` could match a fenced line inside the last archived entry → false mismatch → duplicate append on re-run. Make these fence-aware with the same helper for consistency.
- Template copy: gets the identical fence-aware fix PLUS the bash-3.2 portable while-read loop the canonical copy already has (replacing `mapfile`), so the two copies converge and future deployed projects inherit neither defect.

### Item 2 — per-id-marker gap logging
- Already satisfied: wrap-collector logged it at S4 wrap (improvement-log entry "Non-/prime session start writes no per-id marker…", category guardrail-candidate, status logged/pending, review-cycle monthly).
- Action: none. Report verified-closed; the stale Next-Steps bullet needs no edit (session-notes is append-only).

## Execution Sequence

### Stage 1 — Item 1: fix both script copies
1. Edit `logs/scripts/split-log.sh`: fence-aware header scan (awk), reuse for the two idempotency greps.
2. Rewrite `workflows/research-workflow/logs/scripts/split-log.sh` to match the fixed canonical copy (fence-aware + portable loop).

### Stage 2 — Item 1: verification (isolated, no live mutation)
3. Synthetic unit test: temp file with fenced fake headers + real headers; assert only real header line numbers returned.
4. Real-file test: copy `axcion-brand-book/logs/decisions.md` to a temp dir, run the fixed script (keep=10, order matching the log's shape), assert exit 0, correct archive boundary (oldest real entry, not the fenced placeholder), correct entry counts (29 real entries: archived + kept = 29), no content loss (line-count reconciliation).
5. Regression test: run the fixed script against a copy of a file it previously handled correctly (e.g., the marketing-positioning session-notes shape) — same split result as the old logic on a fence-free file.

### Stage 3 — close-out
6. Flip the improvement-log entry to resolved (status line + one-line resolution note). Shared non-append log: re-check `git status` on it first (3 concurrent sessions live); explicit-path staging.
7. Commit (explicit paths: both scripts + improvement-log.md + session-notes.md + this plan).
8. /qc-pass on the script change before declaring complete.

## Scope Alternatives
- Leaner: fix only the canonical copy (the logged entry's literal target) — rejected: template copy ships the bug to every future deployed project; one extra file now closes two defects.
- Heavier: re-run full 16-scope `/log-sweep --dry-run` as verification — rejected: same proof obtained by the targeted isolated test at a fraction of cost. Out of scope per mandate.

## Autonomy Posture
Full autonomy. No structural change class (defect fix narrowing existing script behavior; pre-assessed low risk in the logged entry). STRUCTURAL_RISK=false → no /risk-check. Stop-if: wrong entry boundaries in the test split (data-loss shape) → stop and surface.

## Risk
- Data-loss shape if the fence toggle misparses (e.g., 4-backtick fences, unbalanced fences): mitigated by isolated-copy testing only; live files untouched until verified; line-count reconciliation asserts no content loss.
- Concurrent sessions (3 live): improvement-log.md edit is a lost-update surface — re-check dirty state immediately before editing; explicit-path staging on commit.
- Unbalanced-fence edge: a file with an unclosed fence would suppress all later headers. Acceptable: such a file is already malformed; the script's existing failure mode (exit on no headers / threshold not met) is non-destructive.
