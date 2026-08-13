#!/usr/bin/env python3
"""memory-search — institutional-memory search over logs/ and audits/.

Two modes:
  python3 memory-search.py index                  # (re)build the index
  python3 memory-search.py search "query" [--top N]

Semantic search over past findings, decisions, incidents and audit reports.
Results are HISTORICAL EVIDENCE, not current truth: every hit carries its
date and any recorded status, defaulting to UNKNOWN. The consuming agent
must verify currency by inspection before relying on a hit.

Index lives in logs/.memory-index/ (gitignored, derived, regenerable).
Embeddings: model2vec static model (local, no API key).
"""

import argparse
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

import numpy as np

REPO_ROOT = Path(__file__).resolve().parents[2]  # ai-resources/
INDEX_DIR = REPO_ROOT / "logs" / ".memory-index"
MODEL_NAME = "minishlab/potion-base-8M"

# Corpora: institutional memory. Script-level reads bypass harness deny
# rules on purpose — search must see archives and audits/working/.
CORPUS_GLOBS = [
    "logs/*.md",
    "logs/work-loop/*.md",
    "logs/missions/*.md",
    "audits/**/*.md",
]
EXCLUDE_PARTS = {".memory-index", "scripts"}

MAX_FILE_BYTES = 2_000_000
TARGET_CHUNK = 1500      # chars; soft target
MAX_CHUNK = 3000         # chars; hard split above this

HEADING_RE = re.compile(r"^(#{2,3}) ")
DATE_RE = re.compile(r"(\d{4}-\d{2}-\d{2})")
STATUS_RE = re.compile(r"\*\*Status:\*\*\s*([^\n|]+)")
SEVERITY_RE = re.compile(r"\*\*Severity:\*\*\s*\**([a-zA-Z-]+)")
RESOLVED_RE = re.compile(r"\*\*Resolved:?\*\*|\[FADING-GATE\] verified")


def corpus_files():
    seen = set()
    for pattern in CORPUS_GLOBS:
        for p in sorted(REPO_ROOT.glob(pattern)):
            if not p.is_file() or p in seen:
                continue
            if any(part in EXCLUDE_PARTS for part in p.parts):
                continue
            if p.stat().st_size > MAX_FILE_BYTES:
                continue
            seen.add(p)
            yield p


def split_chunks(text):
    """Split on ##/### headings; merge tiny blocks, hard-split huge ones."""
    lines = text.splitlines()
    blocks, cur = [], []
    for line in lines:
        if HEADING_RE.match(line) and cur:
            blocks.append("\n".join(cur))
            cur = [line]
        else:
            cur.append(line)
    if cur:
        blocks.append("\n".join(cur))

    merged = []
    for b in blocks:
        if merged and len(merged[-1]) + len(b) < TARGET_CHUNK:
            merged[-1] = merged[-1] + "\n" + b
        else:
            merged.append(b)

    final = []
    for b in merged:
        while len(b) > MAX_CHUNK:
            cut = b.rfind("\n\n", 0, MAX_CHUNK)
            if cut < TARGET_CHUNK // 2:
                cut = MAX_CHUNK
            final.append(b[:cut])
            b = b[cut:]
        if b.strip():
            final.append(b)
    return final


def chunk_meta(chunk, relpath):
    heading = ""
    for line in chunk.splitlines():
        if HEADING_RE.match(line):
            heading = line.lstrip("# ").strip()
            break
    date = ""
    m = DATE_RE.search(heading) or DATE_RE.search(relpath)
    if m:
        date = m.group(1)
    status = "UNKNOWN"
    m = STATUS_RE.search(chunk)
    if m:
        status = m.group(1).strip().rstrip("*")
    elif RESOLVED_RE.search(chunk):
        status = "resolved-marker present"
    severity = ""
    m = SEVERITY_RE.search(chunk)
    if m:
        severity = m.group(1).strip()
    return {"path": relpath, "heading": heading, "date": date,
            "status": status, "severity": severity}


def load_model():
    from model2vec import StaticModel
    return StaticModel.from_pretrained(MODEL_NAME)


def build_index():
    model = load_model()
    records, texts = [], []
    nfiles = 0
    for p in corpus_files():
        try:
            text = p.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        nfiles += 1
        rel = str(p.relative_to(REPO_ROOT))
        for chunk in split_chunks(text):
            meta = chunk_meta(chunk, rel)
            meta["snippet"] = " ".join(chunk.split())[:400]
            records.append(meta)
            texts.append(chunk[:MAX_CHUNK])
    if not texts:
        sys.exit("memory-search: no corpus files found — check CORPUS_GLOBS")
    emb = model.encode(texts, show_progress_bar=False)
    emb = np.asarray(emb, dtype=np.float32)
    norms = np.linalg.norm(emb, axis=1, keepdims=True)
    norms[norms == 0] = 1.0
    emb = emb / norms

    INDEX_DIR.mkdir(parents=True, exist_ok=True)
    np.save(INDEX_DIR / "embeddings.npy", emb)
    with open(INDEX_DIR / "chunks.jsonl", "w", encoding="utf-8") as f:
        for r in records:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")
    meta = {
        "built": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "files": nfiles,
        "chunks": len(records),
        "model": MODEL_NAME,
    }
    with open(INDEX_DIR / "meta.json", "w", encoding="utf-8") as f:
        json.dump(meta, f, indent=2)
    print(f"memory-search: indexed {len(records)} chunks "
          f"from {nfiles} files -> {INDEX_DIR.relative_to(REPO_ROOT)}")


def search(query, top):
    emb_path = INDEX_DIR / "embeddings.npy"
    if not emb_path.exists():
        sys.exit("memory-search: no index found — run "
                 "`python3 logs/scripts/memory-search.py index` first")
    emb = np.load(emb_path)
    with open(INDEX_DIR / "chunks.jsonl", encoding="utf-8") as f:
        records = [json.loads(line) for line in f]

    model = load_model()
    q = np.asarray(model.encode([query]), dtype=np.float32)[0]
    qn = np.linalg.norm(q)
    if qn:
        q = q / qn
    scores = emb @ q
    order = np.argsort(-scores)[:top]

    print("HISTORICAL RECORD — every hit may be stale or superseded. "
          "Verify currency by inspection before relying on it.\n")
    for rank, i in enumerate(order, 1):
        r = records[i]
        line2 = f"   date: {r['date'] or 'none'} | status: {r['status']}"
        if r["severity"]:
            line2 += f" | severity: {r['severity']}"
        print(f"{rank}. [{scores[i]:.3f}] {r['path']}"
              + (f" :: {r['heading']}" if r["heading"] else ""))
        print(line2)
        print(f"   {r['snippet'][:300]}\n")


def main():
    ap = argparse.ArgumentParser(prog="memory-search")
    sub = ap.add_subparsers(dest="cmd", required=True)
    sub.add_parser("index")
    sp = sub.add_parser("search")
    sp.add_argument("query")
    sp.add_argument("--top", type=int, default=6)
    args = ap.parse_args()
    if args.cmd == "index":
        build_index()
    else:
        search(args.query, args.top)


if __name__ == "__main__":
    main()
