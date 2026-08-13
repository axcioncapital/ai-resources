#!/usr/bin/env python3
"""Institutional-memory search over ai-resources logs/, audits/, reports/.

Stateless: reads the corpus live on every invocation — no index file, so
results can never be stale. Lexical BM25 candidate scoring only; semantic
query expansion and relevance judgment belong to the calling session
(/recall command), not to this script.

Usage:
  recall-search.py --terms "term1 term2 phrase-word ..." [--top 25]
  recall-search.py --show "relative/path.md:LINE"

Output (--terms): one JSON object per line, best score first:
  {"score", "path", "line", "heading", "date", "status", "snippet"}
"status" is reported exactly as recorded in the chunk; absence means the
record carries no status — the consumer must treat it as UNKNOWN, never
as current.
"""

import argparse
import json
import math
import re
import sys
from collections import Counter
from pathlib import Path

CORPUS_DIRS = ["logs", "audits", "reports"]
MAX_CHUNK_CHARS = 8000
SNIPPET_CHARS = 500

HEADING_RE = re.compile(r"^#{1,4}\s")
DATE_RE = re.compile(r"(20\d{2}-\d{2}-\d{2})")
STATUS_FIELD_RE = re.compile(r"\*\*Status:\*\*\s*([^\n|]+)")
SEVERITY_FIELD_RE = re.compile(r"\*\*Severity:\*\*\s*\**([a-zA-Z-]+)")
MARKER_RES = {
    "resolved": re.compile(r"\*\*Resolved", re.IGNORECASE),
    "superseded": re.compile(r"superseded", re.IGNORECASE),
    "retired": re.compile(r"\bretired\b", re.IGNORECASE),
    "fading-gate-verified": re.compile(r"\[FADING-GATE\] verified"),
}
TOKEN_RE = re.compile(r"[a-z0-9][a-z0-9_-]+")


def find_ai_resources_root() -> Path:
    """Walk upward from this script's location to the ai-resources dir."""
    here = Path(__file__).resolve()
    for parent in here.parents:
        if parent.name == "ai-resources":
            return parent
    sys.exit("recall-search.py must live inside ai-resources/")


def iter_chunks(root: Path):
    """Yield (relpath, start_line, heading, inherited_date, text) per chunk.

    inherited_date is the most recent YYYY-MM-DD seen in any heading above
    the chunk in the same file, so a dated session block passes its date
    down to its sub-sections.
    """
    for dirname in CORPUS_DIRS:
        base = root / dirname
        if not base.is_dir():
            continue
        for path in sorted(base.rglob("*.md")):
            try:
                lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
            except OSError:
                continue
            rel = str(path.relative_to(root))
            start, heading, inherited = 1, "", ""
            buf = []
            for i, line in enumerate(lines, 1):
                if HEADING_RE.match(line):
                    m = DATE_RE.search(line)
                    if m:
                        inherited = m.group(1)
                if HEADING_RE.match(line) and buf:
                    yield rel, start, heading, inherited, "\n".join(buf)
                    buf, start, heading = [line], i, line.lstrip("# ").strip()
                else:
                    if HEADING_RE.match(line) and not heading:
                        heading = line.lstrip("# ").strip()
                    buf.append(line)
                if sum(len(b) for b in buf) > MAX_CHUNK_CHARS:
                    yield rel, start, heading, inherited, "\n".join(buf)
                    buf, start = [], i + 1
            if buf:
                yield rel, start, heading, inherited, "\n".join(buf)


def extract_date(heading: str, text: str, relpath: str) -> str:
    for source in (heading, relpath, text[:300]):
        m = DATE_RE.search(source)
        if m:
            return m.group(1)
    return ""


def extract_status(text: str) -> str:
    parts = []
    m = STATUS_FIELD_RE.search(text)
    if m:
        parts.append("Status: " + m.group(1).strip())
    m = SEVERITY_FIELD_RE.search(text)
    if m:
        parts.append("Severity: " + m.group(1).strip())
    for name, rx in MARKER_RES.items():
        if rx.search(text):
            parts.append(name)
    return "; ".join(parts)


def tokenize(text: str):
    return TOKEN_RE.findall(text.lower())


def search(root: Path, terms: list[str], top: int):
    chunks = []
    doc_freq: Counter = Counter()
    for rel, line, heading, inh_date, text in iter_chunks(root):
        toks = Counter(tokenize(heading + " " + text))
        chunks.append((rel, line, heading, inh_date, text, toks, sum(toks.values())))
        for t in set(toks) & set(terms):
            doc_freq[t] += 1
    n = len(chunks)
    if n == 0:
        return []
    avg_len = sum(c[6] for c in chunks) / n
    scored = []
    for rel, line, heading, inh_date, text, toks, length in chunks:
        score = 0.0
        for t in terms:
            tf = toks.get(t, 0)
            if not tf:
                continue
            idf = math.log(1 + (n - doc_freq[t] + 0.5) / (doc_freq[t] + 0.5))
            score += idf * tf / (tf + 1.2 * (0.25 + 0.75 * length / avg_len))
        if score > 0:
            scored.append((score, rel, line, heading, inh_date, text))
    scored.sort(key=lambda s: -s[0])
    return scored[:top]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--terms", help="space-separated search terms (pre-expanded)")
    ap.add_argument("--top", type=int, default=25)
    ap.add_argument("--show", help="path.md:LINE — print the full chunk at that location")
    args = ap.parse_args()
    root = find_ai_resources_root()

    if args.show:
        rel, _, line_s = args.show.rpartition(":")
        want = int(line_s)
        best = None
        for crel, cline, heading, _inh, text in iter_chunks(root):
            if crel == rel and cline <= want:
                best = (cline, text)
        if best:
            print(best[1])
        else:
            sys.exit(f"no chunk found for {args.show}")
        return

    if not args.terms:
        ap.error("--terms or --show is required")
    terms = list(dict.fromkeys(tokenize(args.terms)))
    for score, rel, line, heading, inh_date, text in search(root, terms, args.top):
        snippet = re.sub(r"\s+", " ", text)[:SNIPPET_CHARS].strip()
        print(json.dumps({
            "score": round(score, 2),
            "path": rel,
            "line": line,
            "heading": heading,
            "date": extract_date(heading, text, rel) or inh_date,
            "status": extract_status(text),
            "snippet": snippet,
        }, ensure_ascii=False))


if __name__ == "__main__":
    main()
