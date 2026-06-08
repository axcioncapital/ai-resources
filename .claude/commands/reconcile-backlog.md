---
model: opus
---

Scan the status-bearing log files and separate items that are **genuinely still open** from items that are **actually already done** — judging from **on-disk evidence first**, git second.

## Usage

- `/reconcile-backlog` — Default mode: read-only. Print the open-vs-done report; touch no files.
- `/reconcile-backlog apply` — After printing the report, write back **only** the `CONFIRMED-DONE` closures to their source logs.

## Purpose

`/open-items` and the canonical primitive `docs/backlog-reconciliation.md` reconcile backlog items against **git commit history** — and are **advisory-only** (they never edit logs). That misses a real case: an item's proof-of-done is **written to disk but not yet committed** (e.g., a wrap note in `session-notes.md` past the committed tail). Git can't see it, so a finished item keeps showing as open.

This command is the **inverse**: it reads the **full current on-disk content** of the status-bearing logs (past the committed tail), hunts for resolution evidence **wherever it lives on disk**, and uses git only as a *secondary* signal. Run it after `/prime` when you suspect "open" items are actually finished.

Scoped to the current working directory's repo (plus the merged multi-repo git scan in Step 2c).

## Hard exclusions (applied to every source)

Never surface, in any mode:
- Files matching `*archive*.md` (case-insensitive)
- Anything inside `inbox/archive/`
- Items containing `[LOW]`, `someday`, `nice-to-have`, or `deferred indefinitely` (case-insensitive)

## Instructions

### Step 1 — Scan sources on-disk (full file, NOT the git tail)

Resolve `cwd`. For each source below, skip silently if it doesn't exist. If none of `logs/` exists, print `No status-bearing logs found in this folder.` and stop.

Read each source **in full** with `Read` — the whole current file, including any uncommitted tail. This is the point of the command: the resolution evidence may sit in content git has never seen. Do **not** substitute `git show HEAD:<file>` or a committed snapshot for the live file.

Extract candidate **open items** using the same definitions `/open-items` uses (keep DRY — these mirror [open-items.md](open-items.md) Step 1):

| Source | What counts as an open item |
|---|---|
| `logs/improvement-log.md` | Entries with `Status: applied` but no non-empty `Verified:` line; and entries whose `Status:` is `logged`/`proposed`/`pending`/`logged (pending)` |
| `logs/friction-log.md` | Top-level `-` bullets under `### Friction Events` with no non-empty `Resolved:` field and no `[FADING-GATE] verified` annotation |
| `logs/decisions.md` | Entries containing `Defer`/`Deferred` (case-insensitive) **and** a `Trigger for action:` field |
| `logs/session-plan-*.md` (glob) | `- [ ]` unchecked checkbox lines across all session plans (include the source filename in attribution) |
| `logs/session-notes.md` | **Open Questions** sections whose content is not `None`/`None.`/`None blocking`/`None blocking.` (case-insensitive, trimmed) |

Excluded by design (avoid false positives): `incident-log.md`, `value-log.md`, and other wide-net logs.

### Step 2 — Gather resolution evidence per open item (on-disk first)

For each candidate, look for proof-of-done in this **precedence order** and record the strongest signal found:

**2a — Direct on-disk resolution (strongest).** A later record on disk that resolves the item:
- An `improvement-log.md` entry with a non-empty `Verified:` line naming the same target.
- A `decisions.md` entry recording the decision/resolution, or a friction entry with a filled `Resolved:` field.
- A `session-notes.md` wrap note (in **any** entry, including the uncommitted tail) that names the item done — this is the canonical missed case.
- A now-checked box (`- [x]`) for a session-plan item, or the brief moved to `inbox/archive/`.

**2b — Artifact existence.** The file or edit the item promised actually exists on disk (`Read`/`Glob` to confirm the named command/doc/section/output is present). Existence alone is supporting, not conclusive — pair it with 2a or 2c.

**2c — Git (secondary signal only).** For **anchored** sources (`improvement-log.md` `### YYYY-MM-DD`, `friction-log.md` `## Session — YYYY-MM-DD`), reuse the merged multi-repo `git log --since=<anchor>` scan defined in `docs/backlog-reconciliation.md` (run it once per earliest anchor, reuse the result set). Apply that doc's **conservative keyword-match tolerance** (commit hash / `id-NN` first; distinctive keywords otherwise; drop generic tokens). Anchorless sources (`session-plan-*.md`, `session-notes.md`) are **not** git-queried.

Fall-through: if git fails or returns nothing, continue with on-disk signals only.

### Step 3 — Classify (conservative — biased to still-open)

- **`CONFIRMED-DONE`** — direct on-disk resolution evidence (2a), or artifact existence + git both pointing the same way (2b + 2c).
- **`LIKELY-DONE`** — git-only match (2c) or a weak/keyword-only signal. This is the existing primitive's bar.
- **`STILL-OPEN`** — no evidence. **When in doubt → still-open.** A miss here only re-surfaces the item; a wrong "done" hides real work, which is worse.

### Step 4 — Print the report (always; read-only)

Use clickable markdown links `[label](path)` for every file reference. Print all three headings; under an empty one print `None.`

```
## CONFIRMED-DONE (on-disk evidence — safe to close)
- <item> — evidence: <what + where> — [<source>](<source>)

## LIKELY-DONE — verify (git signal only)
- <item> — commit <hash> — [<source>](<source>)

## STILL-OPEN
- <item> — [<source>](<source>)
```

End with one summary line:
`<C> confirmed-done · <L> likely-done (verify) · <S> still-open.`

### Step 5 — `apply` mode (only if `$ARGUMENTS` contains `apply`, case-insensitive)

After printing the report, write back **only** the `CONFIRMED-DONE` items to their source logs, in one batch, following `docs/file-write-discipline.md`:
- improvement-log entry → add a `Verified: <today> — closed by /reconcile-backlog (<evidence>)` line.
- friction entry → set `Resolved:` to the evidence pointer.
- session-plan checkbox → flip `- [ ]` to `- [x]`.
- decisions entry → note the resolution inline.

**Never** touch `LIKELY-DONE` or `STILL-OPEN` items — they remain for operator/spot-check. After writing, print exactly what was changed (file + line summary). Verify writes by reading the filesystem, not git.

$ARGUMENTS
