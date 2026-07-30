#!/usr/bin/env bash
# promote-findings.sh — THE executing owner of finding promotion.
#
# Sweeps this repository's backlog logs for open high-severity findings and appends each one not
# already queued to logs/next-up.md, where /prime Step 2 picks it up as a task-menu candidate.
#
# Built 2026-07-30 (stream 2026-07-30-prime-session-entry-ownership, slice S3) to replace /prime
# Step 3, which re-grepped both logs at EVERY orientation — a ~50-60k-token full read before it was
# bounded on 2026-07-13, and still the single most expensive recurring scan in the harness. Promotion
# is a write, orientation is a read; separating them is the point of the slice.
#
# CONTRACT
#   Usage:  promote-findings.sh          (no arguments)
#   cwd:    the repository root whose logs/ holds the backlog. The CALLER locates this script by
#           ABSOLUTE path and leaves cwd alone, so one copy in ai-resources serves every consumer.
#   stdout: one summary line, or nothing when the lock is held.
#   writes: logs/next-up.md ONLY. Creates it when absent (/prime never does).
#   exit:   0 always, including when the lock is held — a wrap must not fail because a concurrent
#           sweep got there first.
#
# IT NEVER WRITES THE SOURCE LOGS, AND THAT IS A RULE, NOT A PREFERENCE.
#   An earlier design stamped `<!-- promoted -->` into the source entry to mark it done. That is
#   forbidden by docs/commit-discipline.md § Maintenance-owned in-place mutations, which confines
#   in-place mutation of friction-log.md and improvement-log.md to dedicated single-purpose sessions
#   and states that an ordinary work session "appends only; it never reaches into an existing entry" —
#   naming a command that "helpfully" flips a status as a side-effect of ordinary work as exactly the
#   drift it guards against. /wrap-session is an ordinary work session. So promotion identity lives in
#   the DESTINATION instead: a content-derived id recorded on the next-up.md line.
#
# THE PROMOTION ID
#   sha1(source-relative-path + "\n" + entry header text), first 12 hex chars, written as
#   `<!-- promote:{id} -->` at the end of the line. Content-derived, so it survives log archiving and
#   line-number drift — a stored line number would not. An entry whose header text is edited gets a
#   new id and is promoted again; that is the accepted cost of not writing the source.
#
# CONCURRENCY
#   A repo-local `mkdir logs/.promote.lock` mutex — the same atomic-mkdir primitive proven in
#   prime-session-entry.sh. mkdir is atomic on POSIX: exactly one caller creates the directory and
#   every other gets EEXIST. Lock held -> exit 0 silently, because the holder is sweeping the same
#   entries and will queue them. Each run also de-duplicates next-up.md by promotion id, so a
#   duplicate that arrives through a git union of two checkouts is removed by the next sweep in
#   either tree.
#
# WHY friction-log.md CONTRIBUTES NOTHING TODAY, AND WHY THAT IS DELIBERATE
#   improvement-log.md is schema'd: every entry carries a mandatory `**Severity:**` field with a
#   machine-readable value, which is why that log can be swept mechanically at all. friction-log.md
#   has no severity field — its schema (§ Schema, canonical) requires Failure mode / Root cause /
#   Prevention / Owner artifact and nothing that ranks the entry. /prime Step 3 fell back to a
#   keyword grep for HIGH|urgent|do-now there, and its own text called those hits "candidates to
#   judge, not findings", because a session could discard the incidental matches in context.
#   A SCRIPT CANNOT JUDGE. Measured 2026-07-30 against this repo: that grep returned 3 hits and all 3
#   were prose — the word "HIGH" inside an allocator comment, "the open HIGH item of 2026-07-14"
#   inside a narrative, and a "4 HIGH research-workflow relays" aside. Promoting them would have put
#   three non-findings on the task menu.
#   So the sweep below reads friction-log.md through the SAME severity-field test as improvement-log,
#   which today matches zero entries. The code path is live, not stubbed: the day friction entries
#   start carrying `**Severity:**`, they promote with no change here. What is NOT done is guessing
#   from keywords. Restoring a keyword fallback needs a judging consumer, not a looser regex.

set -u

[ -d logs ] || {
  printf 'promote-findings.sh: no ./logs directory — run with cwd = the repository root (cwd is %s).\n' "$(pwd)" >&2
  exit 1
}

# ---- the mutex ------------------------------------------------------------------------------
# Held -> another sweep is covering the same entries. Exit 0 and say nothing: a wrap must not fail,
# and a "could not promote" line here would be noise, not information.
LOCK="logs/.promote.lock"
mkdir "$LOCK" 2>/dev/null || exit 0
# Released on every exit path, including a crash mid-write. A stale lock directory would block every
# future sweep silently, which is the one failure mode worse than a duplicate.
trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM

python3 - <<'PY'
import hashlib, os, re, sys

SOURCES = ["logs/friction-log.md", "logs/improvement-log.md"]
DEST    = "logs/next-up.md"

ENTRY  = re.compile(r'^#{2,3} \d{4}-\d{2}-\d{2}')
# medium-high is listed BEFORE high so the alternation cannot match the "high" inside it and lose the
# tier. The ^ anchor is what keeps a plain `medium` out: it never reaches the `high` branch.
SEV    = re.compile(r'^-?\s*\*\*Severity:\*\*\s*\**\s*(critical|urgent|medium-high|high)\b', re.I)
SEVANY = re.compile(r'^-?\s*\*\*Severity:\*\*', re.I)
STATUS = re.compile(r'^-?\s*\*\*Status:\*\*', re.I)
# Same exclusion set /prime Step 3 applied to the returned lines. `closed` and `void` are NOT here:
# the improvement-log schema keeps them in the active log by design, and their entries carry
# `Severity: none`, so the severity test already drops them.
DONE   = re.compile(r'resolved|applied|verified|declined', re.I)
IDTAG  = re.compile(r'<!--\s*promote:([0-9a-f]{12})\s*-->')

def promotion_id(path, header):
    return hashlib.sha1((path + "\n" + header.strip()).encode("utf-8")).hexdigest()[:12]

def title_of(header):
    # "### 2026-07-29 — Some title" -> "Some title". Fall back to the whole header if the em-dash
    # split is absent, rather than emitting an empty menu item.
    t = re.sub(r'^#{2,3}\s*\d{4}-\d{2}-\d{2}\s*[—-]?\s*', '', header).strip()
    return t or header.strip().lstrip('#').strip()

def qualifying(path):
    if not os.path.exists(path):
        return [], 0
    lines = open(path, encoding="utf-8").read().split("\n")
    heads = [i for i, l in enumerate(lines) if ENTRY.match(l)]
    out, seen_sev = [], 0
    for k, s in enumerate(heads):
        e = heads[k + 1] if k + 1 < len(heads) else len(lines)
        block = lines[s:e]
        if any(SEVANY.match(x) for x in block):
            seen_sev += 1
        if not any(SEV.match(x) for x in block):
            continue
        status = " ".join(x for x in block if STATUS.match(x))
        if DONE.search(status):
            continue
        out.append((promotion_id(path, lines[s]), title_of(lines[s]), path))
    return out, seen_sev

candidates, per_source = [], []
for src in SOURCES:
    got, seen = qualifying(src)
    candidates.extend(got)
    per_source.append((src, len(got), seen))

# ---- read the destination -------------------------------------------------------------------
# "Already queued" means the id appears ANYWHERE in next-up.md — checked or unchecked. A finding the
# operator has already ticked off must never come back.
existing = open(DEST, encoding="utf-8").read().split("\n") if os.path.exists(DEST) else []
present  = {m.group(1) for l in existing for m in [IDTAG.search(l)] if m}

# ---- de-duplicate what is already there ------------------------------------------------------
# Self-healing pass: a git union of two checkouts can land the same promoted line twice. Keep the
# first occurrence of each id and drop later ones; every line without an id is preserved verbatim.
kept, dropped, seen_ids = [], 0, set()
for l in existing:
    m = IDTAG.search(l)
    if m:
        if m.group(1) in seen_ids:
            dropped += 1
            continue
        seen_ids.add(m.group(1))
    kept.append(l)

new = [c for c in candidates if c[0] not in present]

if not new and not dropped:
    print(f"promote-findings: nothing to promote ({len(present)} already queued)")
    sys.exit(0)

if not kept:
    kept = ["# Next Up", "",
            "Task-queue items. `/prime` Step 2 reads the unchecked ones as menu candidates.",
            "Promoted findings carry their source and a content-derived id; tick an item to retire it.",
            ""]
while kept and kept[-1] == "":
    kept.pop()

if new:
    kept.append("")
    for pid, title, src in new:
        kept.append(f"- [ ] {title} — `{src}` <!-- promote:{pid} -->")
kept.append("")

tmp = DEST + ".tmp"
with open(tmp, "w", encoding="utf-8") as f:
    f.write("\n".join(kept))
os.replace(tmp, DEST)   # atomic within the lock: a reader never sees a half-written queue

detail = " · ".join(f"{s.split('/')[-1]}: {n} qualifying, {sv} severity-tagged" for s, n, sv in per_source)
print(f"promote-findings: +{len(new)} promoted, {dropped} duplicate(s) removed, "
      f"{len(present)} already queued  ({detail})")
PY
