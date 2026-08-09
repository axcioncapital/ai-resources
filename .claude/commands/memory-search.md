---
description: Semantic search over the repo's institutional memory — past findings, decisions, incidents and audits in logs/ and audits/, including archives and audits/working/. Answers "have we seen this problem before?" Results are historical evidence with date and recorded status (default UNKNOWN), never current truth. Read-only; applies no fix, writes no file. Usage — /memory-search <problem description>, or /memory-search reindex to rebuild the index. MVP per plans/semantic-search-mvp/proposal.md.
model: sonnet
---

# /memory-search — Institutional-Memory Search

Read-only lens over `logs/` and `audits/` (including archives and `audits/working/`, which ordinary greps cannot reach). Backed by `logs/scripts/memory-search.py` — a local embedding model, no API key, no network. This command modifies no file, applies no fix, and logs nothing.

`ARGS` = `$ARGUMENTS`.

## Step 1 — Mode

- `ARGS` is exactly `reindex` → **Reindex mode** (Step 4).
- `ARGS` is empty → ask the operator for a problem description in one line; stop.
- Otherwise → **Search mode** with `QUERY` = `ARGS` verbatim.

## Step 2 — Index presence and freshness

`INDEX` = `logs/.memory-index/` under the ai-resources root.

1. If `INDEX/embeddings.npy` is missing → report `No index found — run /memory-search reindex to build it (first build downloads a ~30 MB local model).` Stop. Do **not** auto-build.
2. Read `INDEX/meta.json` (Bash `cat`). If its `built` date is older than 7 days, show one line — `Index built {built date} — older than 7 days; consider /memory-search reindex.` — then proceed.

## Step 3 — Search mode

Run via Bash from the ai-resources root:

```
python3 logs/scripts/memory-search.py search "{QUERY}" --top 6
```

Display the script output **unmodified** — including its leading warning line (`HISTORICAL RECORD — every hit may be stale or superseded…`) and, per hit: score, path, heading, date, recorded status (default `UNKNOWN`), severity when present, snippet.

Do not summarize hits as facts, do not merge them into a narrative, and do not assert that any hit is current. Currency is established only by opening the cited file.

Close with one line of next actions: `Verify a hit by opening its file · more hits: re-run with --top N · refresh: /memory-search reindex`.

## Step 4 — Reindex mode

Run via Bash from the ai-resources root (allow up to ~2 minutes):

```
python3 logs/scripts/memory-search.py index
```

Report the script's summary line (chunks, files, index path) plus the `built` timestamp from `meta.json`. If the run fails, show the error verbatim and stop — do not retry, do not modify the script.

## Boundaries

- Read-only: no fixes, no log entries, no edits to any file. The only writes are the script's own index files under `logs/.memory-index/` (gitignored, derived, regenerable).
- Out of scope (per the proposal): Work Loop, general repo search, resource selection, integrations into other commands. Extensions re-enter through operator decision.
