#!/usr/bin/env python3
"""decision_ref_slug — THE single definition of the `decisions_refs` anchor slug.

WHY THIS FILE EXISTS
--------------------
The slug briefly lived in three places: prose in docs/spine-schemas.md, a model
hand-deriving it at wrap time, and a Python function in check-decision-refs.sh.
Three implementations of one algorithm — two had already drifted, and the third
was a language model counting to 60 characters. The evidence was on disk: of the
three refs hand-authored before this module existed, THREE were orphans that
resolved to no real header.

So: generation and validation now call this function, and nothing hand-derives a
slug. docs/spine-schemas.md § 1 documents this code; it is not a second authority.
If you change the algorithm here, that doc is the only prose to update — and every
already-written ref in logs/runs/*.json silently stops resolving, so don't, unless
you also plan to migrate them.

CONTRACT
--------
slug(header) -> str
  1. Strip leading '#' markers and surrounding whitespace.
  2. Lowercase; every run of non-alphanumerics becomes a single '-'; strip edge '-'.
  3. Truncate to 60 chars; then, unless the result ends exactly at a word boundary,
     cut back to the last '-' so the slug never ends mid-word.

There is deliberately NO de-duplication suffix (`-2`, `-3`). An earlier draft had one;
it was wrong twice over: it de-duped *within a manifest* when the real ambiguity is two
identically-titled *headers* in decisions.md, and a `-2` ref resolves to nothing at all
(no such anchor exists), so it manufactured the orphan it was meant to prevent. Two
decisions in one session must simply be given distinct headers — the session writing the
ref is the same one writing the header, so this costs nothing.

USAGE
-----
  python3 decision_ref_slug.py "## 2026-07-12 (S5) — Some decision"   # -> prints the slug
  python3 decision_ref_slug.py --self-test                            # -> exits 1 on drift
  from decision_ref_slug import slug, ref                             # -> as a module
"""

import re
import sys

MAX_LEN = 60


def slug(header: str) -> str:
    """Derive the anchor slug from a decisions.md header line. THE definition."""
    text = re.sub(r'^#+\s*', '', header.strip())
    s = re.sub(r'[^a-zA-Z0-9]+', '-', text.lower()).strip('-')
    if len(s) > MAX_LEN:
        cut_at_boundary = s[MAX_LEN] == '-'      # char 61 is a separator => 60 ends a word
        s = s[:MAX_LEN]
        if not cut_at_boundary and '-' in s:
            s = s.rsplit('-', 1)[0]              # would have ended mid-word => drop the fragment
        s = s.strip('-')
    return s


def ref(header: str, log_path: str = "logs/decisions.md") -> str:
    """Full `decisions_refs` entry for a decision header."""
    return f"{log_path}#{slug(header)}"


_CASES = [
    # (header, expected slug) — the two real S5 headers, both >60 chars (the trim-back path)
    ("## 2026-07-12 (S5) — decisions_refs ref format: slug the decision header, not date+marker",
     "2026-07-12-s5-decisions-refs-ref-format-slug-the-decision"),
    ("## 2026-07-12 (S5) — R3 Pass 2 has a SECOND prerequisite, and it is still open",
     "2026-07-12-s5-r3-pass-2-has-a-second-prerequisite-and-it-is"),
    # Header-level indifference: ## and ### must slug identically (decisions.md mixes both)
    ("### 2026-07-03 — a short one", "2026-07-03-a-short-one"),
    ("## 2026-07-03 — a short one", "2026-07-03-a-short-one"),
    # Short header: untouched by truncation
    ("## 2026-07-12 (S4) — R3 Pass 2: HOLD", "2026-07-12-s4-r3-pass-2-hold"),
    # Underscores/punctuation collapse; no trailing separator
    ("## 2026-01-01 — a__b: c!!!", "2026-01-01-a-b-c"),
    # The collision the format exists to prevent: two same-day, same-marker headers
    # must produce DIFFERENT slugs (this is what `#{date}-{marker}` could not do).
]


def _self_test() -> int:
    failures = 0
    for header, expected in _CASES:
        got = slug(header)
        if got != expected:
            failures += 1
            print(f"FAIL\n  header:   {header}\n  expected: {expected}\n  got:      {got}")
    # Boundary behaviour: a slug is never longer than MAX_LEN and never ends on '-'.
    for header, _ in _CASES:
        s = slug(header)
        if len(s) > MAX_LEN or s.endswith('-') or s.startswith('-'):
            failures += 1
            print(f"FAIL (shape): {s!r} from {header!r}")
    # The collision proof, asserted rather than assumed.
    a = slug("## 2026-07-12 (S4) — R3 Pass 2: HOLD. The gate does not hold")
    b = slug("## 2026-07-12 (S4) — Model Tier carve-out: ratify spawn-site tier pins")
    if a == b:
        failures += 1
        print("FAIL: two distinct same-day/same-marker headers collided — the whole point of this format.")
    # Negative control: a test that cannot fail is not a test.
    if slug("## 2026-01-01 — x") == "deliberately-wrong":
        failures += 1
        print("FAIL: negative control matched — the harness is broken.")
    print(f"self-test: {len(_CASES) * 2 + 2} assertions, {failures} failure(s)")
    return 1 if failures else 0


if __name__ == "__main__":
    args = sys.argv[1:]
    if not args or args[0] in ("-h", "--help"):
        print(__doc__)
        sys.exit(0)
    if args[0] == "--self-test":
        sys.exit(_self_test())
    print(slug(args[0]))
