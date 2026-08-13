# Proposal — Semantic Search MVP (`/memory-search`)

**Status:** Proposal — awaiting operator approval. Nothing in this document is built yet (a prototype script exists; see § Current state on disk).
**Date:** 2026-08-09
**Author:** Claude (session investigation + operator direction)
**Decision owner:** Patrik

---

## 1. Background and problem

The ai-resources repo accumulates institutional memory: ~9.7 MB in `logs/` (521 files) and ~16 MB in `audits/` (1,035 files) — findings, decisions, incidents, friction entries, and audit reports. A repo-wide investigation (2026-08-09, four parallel read-only sweeps) established that this material is effectively **write-only**:

- Every audit consumer reads only the newest report (`sort | tail -1`). No command searches audit *content* at all.
- `audits/working/` (420 files) is gitignored, so both `git grep` and the harness grep are blind to it — even though repo convention requires audit subagents to write their evidence there.
- `audits/risk-checks/` (400 files) has had no reader since `/risk-check` was retired 2026-07-30.
- The 818-entry log archives (506 archived sessions, 312 archived decisions) are deny-read in settings.
- The only automated finding-to-attention channel is a `**Severity:**` regex; `friction-log.md` (87 entries) has no severity field and reaches no queue.
- Keyword retrieval has documented failures in both directions: a 23% false-positive extraction rule, and misses that let already-dead backlog items reach the apply stage ("6 of 7 dissolved", `docs/backlog-reconciliation.md`).

Measured consequence: problems are re-investigated from zero. One defect class is self-described in `logs/improvement-log.md` as "the repo's most-repeated defect class (inert safeguard, 6+ logged instances)." One 2026-07 entry records the same failure pattern recurring three times in a single session even though the prior entry was on screen at orientation — recency-based surfacing is not relevance-based retrieval.

**The problem statement:** when a problem, question, or proposal comes up, no tool can answer *"have we seen this before?"* across the repo's accumulated record.

## 2. What the MVP is

One standalone slash command, `/memory-search`, backed by one local Python script and one derived index. It answers one question — "have we seen this problem before?" — on demand, invoked by the operator or by Claude mid-session.

Explicitly NOT in this MVP:

- No integration into any existing command (`/resolve-repo-problem` integration was considered and set aside by operator decision 2026-08-09; it remains a five-line edit if usage later justifies it).
- No Work Loop involvement. Work Loop's documented failures are state-drift, not findability; its context-engineering rules deliberately forbid broad historical scanning. Any future Work Loop use requires an explicit amendment to that rule set, owned by the Work Loop change process.
- No general repo search, no skill/resource selection, no doc routing, no UI, no auto-refresh hooks.
- No settings or permission changes. The deny-read on archives applies to Claude's Read tool; the indexer is a script and reads files directly. The archive deny-rule contradiction stays a separate, operator-owned decision.

## 3. Design principles

1. **Historical evidence, never current truth.** Every result carries its date and any recorded status, defaulting to `UNKNOWN`. Every result list opens with a fixed warning: *"Historical record — every hit may be stale or superseded. Verify currency by inspection before relying on it."* The search layer never asserts that a hit is current; currency is established by opening the cited file (the same premise-check discipline Work Loop uses). This is the guard against the repo's best-documented failure fear: stale material masquerading as governing context.
2. **Local, free, offline.** Embeddings come from a small local static model (`model2vec`, `minishlab/potion-base-8M`, ~30 MB, no torch, no API key). Rejected alternative: API embeddings (better quality, but blocks on key provisioning and adds a per-use cost). The backend is one function; swapping to an API model later is contained.
3. **Derived data stays out of git.** The index is regenerable at any time and lives in a gitignored directory.
4. **Smallest thing that can prove value.** Three artifacts total. Anything more (auto-refresh, second corpus, integrations) waits for usage evidence.

## 4. Components

### 4.1 Indexer + search script — `logs/scripts/memory-search.py`

Single Python file, two modes. A prototype already exists and has been exercised (see § 7).

- **`index` mode** — walks the corpus, chunks files, extracts metadata, embeds, writes the index.
  - Corpus globs (relative to ai-resources root): `logs/*.md`, `logs/work-loop/*.md`, `logs/missions/*.md`, `audits/**/*.md`. Includes archives and `audits/working/`. Excludes `logs/.memory-index/` and script directories. Files > 2 MB skipped.
  - Chunking: split on `##`/`###` headings (the repo's entry convention); merge blocks under ~1,500 chars; hard-split above ~3,000 chars at paragraph boundaries.
  - Per-chunk metadata: relative path, heading, date (from heading or filename, `YYYY-MM-DD`), recorded status (`**Status:**` value, or "resolved-marker present" when a `**Resolved:**` / `[FADING-GATE] verified` stamp is found, else `UNKNOWN`), severity (`**Severity:**` value if present), 400-char snippet.
  - Output: `embeddings.npy` (L2-normalized float32) + `chunks.jsonl` + `meta.json` (build timestamp, file/chunk counts — *meta.json is a small addition still to build; the rest exists*).
  - Measured on the prototype: 14,329 chunks from 1,248 files; index build runs in seconds after the one-time model download.
- **`search` mode** — embeds the query, cosine-ranks all chunks, prints top N (default 6) with rank, score, path, heading, date, status, severity, snippet — headed by the fixed historical-record warning.

Dependencies: `python3` (3.14 present), `numpy`, `model2vec` (both already installed user-level).

### 4.2 Index directory — `logs/.memory-index/` (gitignored)

One `.gitignore` line: `logs/.memory-index/`. Derived, regenerable, never committed.

### 4.3 The command — `.claude/commands/memory-search.md`

- **Name:** `/memory-search` (recommended over `/memory`: unambiguous, matches the script name, one term per thing). Frontmatter `model: sonnet` — the command is a mechanical wrapper (run script, display results); any follow-up judgment happens in the session at session tier. Explicit tier per workspace Model Tier rules.
- **Usage:**
  - `/memory-search <problem description>` — run the search, display results verbatim.
  - `/memory-search reindex` — rebuild the index.
- **Command behavior:**
  1. If the index is missing → say so and offer `reindex` (do not auto-build; first build downloads a model).
  2. If `meta.json` shows the index is older than 7 days → show a one-line staleness note with the build date, then proceed.
  3. Run the script via Bash, top 6 hits, and display the output unmodified — including the historical-record warning line.
  4. Close with one line of next actions: open a cited file to verify currency, ask for more hits (`--top`), or `reindex`.
- The command applies no fix, writes no log entry, and modifies no file. It is a read-only lens.

## 5. Risks and mitigations

| Risk | Mitigation |
|---|---|
| A stale hit is mistaken for current truth | `UNKNOWN`-default status label, date on every hit, fixed warning header, verify-by-inspection instruction. The command never summarizes hits as facts. |
| Local model quality below API-grade embeddings | Accepted for MVP. Prototype queries already retrieve correct prior-art documents. Backend is swappable in one function if quality disappoints. |
| Index drift (new entries not indexed) | `meta.json` build date + 7-day staleness note; manual `reindex` is seconds. Auto-refresh (wrap-session hook) is a deliberate v2 candidate, not MVP. |
| Orphan risk — a standalone command nobody invokes (the `skills/CATALOG.md` failure mode) | Review usage after 2–3 weeks of real sessions. If used: consider the `/resolve-repo-problem` integration (five-line edit). If unused: retire via `/develop-ai-resource` retirement path. Named check, not a silent hope. |
| Scope creep toward general retrieval infrastructure | § 2's NOT-list is part of the approved scope; extensions re-enter through operator decision. |

## 6. Effort, verification, review

- **Remaining build effort:** ~2–3 hours from the current prototype (meta.json, staleness note, the command file, `.gitignore` line, cleanup below).
- **Verification (build session, deterministic):** `reindex` completes; a search returns ≤ N hits each carrying path/date/status/snippet under the warning header; hits from `audits/working/` and an archive file demonstrably appear; missing-index and empty-query paths fail gracefully.
- **Independent review:** one Codex review of the built artifacts (new command + script = consequential, not high-consequence; one review, not risk-aware tier), per `docs/qc-independence.md`.

## 7. Current state on disk (pre-approval prototype)

Created during this session **before** the operator paused implementation; none of it is committed:

1. `logs/scripts/memory-search.py` — working prototype of § 4.1 (missing only `meta.json`).
2. `logs/.memory-index/` — built index (14,329 chunks / 1,248 files); not yet gitignored.
3. Python packages `model2vec` + `numpy` installed user-level.
4. **One edit already applied to `.claude/commands/resolve-repo-problem.md`** (a memory-search step in the MANUAL-mode investigator brief). Under the standalone-command decision this edit is out of scope and should be **reverted** in the build session.
5. Two sanity queries were run against the prototype; both returned the correct prior documents, including hits from the previously unsearchable `audits/working/` and `audits/risk-checks/` corpora.

## 8. Open decisions for the operator

1. **Approve the scope** in §§ 2–4 (or amend).
2. **Command name:** `/memory-search` (recommended) or `/memory`.
3. **Prototype disposition:** keep as the build starting point (recommended — it is § 4.1 minus meta.json) or delete and rebuild clean.
4. **Confirm the revert** of the out-of-scope edit in `.claude/commands/resolve-repo-problem.md` (recommended: revert).

On approval, the build session executes § 4 + § 6 and nothing else.
