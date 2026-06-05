# Backlog Reconciliation — reconcile-at-read against live state

> **When to read this file:** Before an issue-surfacing command presents backlog/diagnostic candidates to the operator (or to a vetting subagent) as *actionable*. The canonical consumers are `/prime`, `/fix-project-issues`, `/fix-repo-issues`, and `/open-items` (see **Consumers** below). This doc is the single definition of the reconcile-at-read primitive those commands invoke.

## Why this exists

Backlog logs and dated audit reports drift out of sync with the live repo. An item gets fixed (committed) but its log entry is never status-flipped; a dated report freezes a finding that a later commit resolves. A scan that reads those stale sources then surfaces already-done work as actionable — and the operator (or a vetting subagent) burns a session reconciling each candidate by hand to discover most are dead.

Observed instance (2026-06-05): `/fix-project-issues` on `ai-resources` scanned 39 candidates → System Owner vetted 7 → **6 of 7 dissolved** on manual reconciliation (already-applied / conflict / out-of-scope). Only 1 was real. The cost was a full vetting + reconciliation pass on dead items.

This primitive moves that reconciliation into the read path so it happens automatically, every scan.

## Source-of-truth rule

**When a backlog/log/report candidate conflicts with live repo state (git log, filesystem), live state wins.** Logs are advisory, not authoritative. Any issue-surfacing scan MUST reconcile its candidate list against live state before surfacing candidates as actionable. A log entry that says "open" is a claim, not a fact — the git history is the fact.

## Anchored-only precondition (hard)

The primitive applies **only** to candidates that carry a **commit-resolvable date anchor**:

- Dated log entries — improvement-log `### YYYY-MM-DD —` headers; friction-log `## Session — YYYY-MM-DD` headers.
- Dated report findings — the report's `report_date` (from filename) or the scanner's computed `age_days` → date.

Candidates with **no commit-resolvable anchor are passed through untouched — never git-queried**:

- `inbox/*.md` briefs
- `next-up.md` checkboxes
- `session-plan-*.md` checkboxes

A git query against an anchorless source either no-ops silently or, worse, matches stray keywords against the full history and wrongly hides a live item. Do not wire one. Anchorless sources keep whatever existing freshness / `Resolved:`-field handling their consumer already applies.

## The git cross-check mechanism

For each **anchored** candidate, derive its anchor date, then check whether any commit since that date resolved it.

**1. Establish repo variables** (the consumer already has these or derives them):

```
AI_RESOURCES="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"
CWD_REPO=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)
WORKSPACE_ROOT="$(dirname "$AI_RESOURCES")"
```

**2. Run the merged multi-repo `git log --since` scan.** A candidate in one scope is frequently resolved by a commit in another repo (canonical command/doc/log edits land in `ai-resources`; a project item may be closed by a commit in a sibling project). Checking only one repo's log re-introduces the dual-repo blindspot. Merge the result sets across **cwd + `ai-resources` + every sibling `projects/*/` repo** before the keyword-match pass:

```bash
ANCHOR="<candidate-anchor-date>"   # YYYY-MM-DD

# cwd repo
git -C "$CWD_REPO" log --since="${ANCHOR}T00:00:00" --pretty="%h %s" --all 2>/dev/null

# ai-resources, if different from cwd
[ "$CWD_REPO" != "$AI_RESOURCES" ] && \
  git -C "$AI_RESOURCES" log --since="${ANCHOR}T00:00:00" --pretty="%h %s" --all 2>/dev/null

# sibling project repos
for d in "$WORKSPACE_ROOT"/projects/*/; do
  repo="$(git -C "$d" rev-parse --show-toplevel 2>/dev/null)" || continue   # skip non-repos
  [ "$repo" = "$CWD_REPO" ] && continue                                     # already scanned
  [ "$repo" = "$AI_RESOURCES" ] && continue                                 # already scanned
  git -C "$repo" log --since="${ANCHOR}T00:00:00" --pretty="%h %s" --all 2>/dev/null
done
```

The scan is bounded by *output* (`--since` returns nothing for repos with no commits since the anchor), not by invocation count. A repo `--show-toplevel`-equal to one already scanned is skipped (no double-count). Any directory that is not a git repo, or whose `git` call errors, is skipped silently. This is the same merged scan `/prime` Step 1a runs; that is the reference implementation.

**Efficiency note.** Anchor dates cluster — many candidates share a date or fall after the same recent date. Run the merged scan once per **distinct (or earliest) anchor date** and reuse the result set across candidates that share it, rather than re-running git per candidate. The whole scan can usually collapse to one `--since=<earliest-anchor>` pass whose output is then matched against every candidate.

**3. Keyword-match each candidate against the merged commit subjects** (see tolerance posture below) and classify.

## Keyword-match tolerance posture

Classification is deliberately **conservative — biased toward false-negative over false-positive.** A candidate is demoted to *likely-done* only on a confident match:

- **Match on the highest-precision signal first.** If the candidate carries a **commit hash** or an **`id-NN`** in its own body (improvement-log entries often do), match on that exact token. This sidesteps wording drift entirely and is the strongest signal.
- **Otherwise match the candidate's *distinctive* subject keywords** — the specific noun phrase, file name, or target — against commit subjects. Commit subjects here follow `type: name — purpose` (e.g., `update: ai-resources CLAUDE.md — de-dup push rule`), so draw keywords from the candidate's specific target, **not** its category. **Drop generic tokens** before matching: `update`, `fix`, `new`, `session`, `log`, the bare scope name, and similar high-frequency words that match almost any commit.
- **Accuracy floor — when in doubt, classify still-open.** A wording-drift miss leaves the item still-open: it reaches the operator, costing only the noise this primitive is trying to reduce — no item is lost. A loose match wrongly hides a real item, which is worse. Prefer the miss.

## Classification + advisory contract

- **Match found → likely-done.** Demote the candidate into a separate, clearly-labelled **"likely-already-done — verify (commit `<hash>`)"** section. Tag it with the resolving commit hash. It is **never deleted, never auto-actioned, never vetted as work** — it is set aside for an optional operator/subagent spot-check.
- **No match → still-open.** Surface as actionable, unchanged.
- **Advisory-only — never edit logs.** This primitive reads git and filesystem; it does **not** write to any log, report, or source file. It changes only what a scan *surfaces*, never the underlying record. The source log stays untouched, so the operator can always verify a likely-done call directly. (This matches `/prime`, which never edits `session-notes.md`.)
- **Demote, don't drop.** Because likely-done items are demoted + tagged rather than removed, a wrong match costs a glance, not a lost item. This is what makes the conservative posture safe.

## Fall-through on git failure

If a `git` call fails, or the merged scan returns nothing, **treat the affected candidates as still-open and continue.** Reconciliation is best-effort: it can demote noise, but it must never block a scan or silently drop a candidate when git is unavailable. Same posture as `/prime` Step 1a.

## Consumers

Four call sites invoke this primitive. Changes to the mechanism here propagate to all four:

| Consumer | Where reconciliation runs | Likely-done destination |
|---|---|---|
| `/prime` Step 1a | Next-Steps cross-check at session orient | Demoted out of the numbered task menu |
| `/fix-project-issues` | After `diagnostics-scanner` returns, before System-Owner vetting | "likely-already-done — verify" appendix; **not** passed to the SO as actionable |
| `/fix-repo-issues` | Step 3 aggregation, before triage grouping | Folded into the **Skip** group, annotated with commit hash |
| `/open-items` | Step 1/2 scan, anchored sources only | Separate "likely-already-done — verify" section below the live backlog |

`/prime` Step 1a is the reference implementation of the merged git scan; this doc generalizes its logic for the other three consumers.
