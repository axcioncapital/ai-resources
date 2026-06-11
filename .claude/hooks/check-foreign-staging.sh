#!/bin/bash
# PreToolUse(Bash) staging tripwire — Fix 2 of the concurrent-session isolation
# fix-plan (audits/2026-06-09-concurrent-session-isolation-fix-plan.md, build-order
# step 1). Catches the concurrent-session contamination that recurred at S3
# (2026-06-09): a `git commit --amend` in one session swept a FOREIGN session's
# staged file (claim-permission.template.md) into the commit, silently.
#
# WHAT IT GUARDS — when a gated git verb is about to run, it compares the files
#   that verb would stage against THIS session's declared footprint (the mandate's
#   `- Files in scope:` bullet). Files that are neither in the footprint nor on the
#   exempt-list are "foreign" — most likely another concurrent session's staged
#   work about to be swept into this commit.
#
# AUTHORITY — this is an ADVISORY STAGING TRIPWIRE, not enforcement (principles
#   OP-5). exit 2 feeds the foreign-file list back to the AGENT (not a permission
#   prompt to the operator — respects the zero-permission-prompt / bypassPermissions
#   floor). The agent can technically re-run the commit, so the stderr message
#   instructs STOP-and-surface-to-operator (OP-3 loud-failure path), not silent
#   self-correction. It pairs with — does not replace — the `git diff --cached`
#   shared-file review in docs/commit-discipline.md, which catches foreign *hunks*
#   inside OWNED files (e.g. CLAUDE.md); this hook only sees whole foreign *files*.
#
# GATED VERBS (everything else exits 0 immediately, before any file/git read):
#   git commit            — stages = `git diff --cached --name-only`
#   git commit --amend    — same
#   git commit -a/--all   — adds tracked unstaged mods → also `git diff --name-only`
#   git add -A/--all/-u/--update/.   — working-tree-wide add
#   git add <pathspec>    — NOT gated (explicit, low-risk).
#
# FAIL-OPEN (Q3) + P3 ESCALATION (2026-06-11) — if this session has no resolvable
#   footprint (no marker, no `- Files in scope:` bullet, or a bullet that reads
#   `(inferred)`/`(none stated)` with no concrete paths), the guard CANNOT judge
#   foreignness. It then splits on concurrency:
#     • A LIVE foreign session is active in this checkout (a today-dated per-id marker
#       other than this session's own is present) → BLOCK (exit 2, stop-and-confirm).
#       This was the worst remaining blind spot (improvement-log 467/501): no footprint
#       AND a concurrent session is exactly when a blind commit sweeps the other session's
#       staged files. P3 escalates it from warn to a hard stop.
#     • No live foreign session → allow the commit and emit a soft non-blocking warn
#       (the original Q3 fail-open). A guard that blocked on its own parse failure with no
#       concurrency present would be worse. RESIDUAL BLIND SPOT: a primed-but-not-planned
#       or `(inferred)`-footprint SOLO session still gets only the warn — but with no
#       concurrent session there is no foreign-contamination risk to block on.
#
# EXEMPT (never "foreign") — append-only shared logs + this session's own process
#   byproducts (markers, plan, scratchpad) + write-once audit artifacts. These are
#   not edit-in-place content, so a cross-session overlap on them is benign (no lost
#   update). The guard targets edit-in-place CONTENT files (commands/docs/skills/
#   templates/CLAUDE.md) — the real lost-update surface.
#
# CONTRACT — non-blocking on every path EXCEPT a confirmed foreign-file stage
#   (exit 2). If python3 or git is unavailable, exits 0 (degrades open, never
#   blocks a commit because the guard itself broke). timeout: 5 in settings.json.
#   Reads only; writes nothing. Two-end contract registered in
#   docs/commit-discipline.md.

set -u

# python3 is required for robust JSON/command parsing (matches check-heavy-tool.sh).
# If absent, degrade OPEN — never block a commit because the guard can't run.
command -v python3 >/dev/null 2>&1 || exit 0

payload=$(cat)

python3 - "$payload" << 'PYEOF'
import json, sys, os, re, subprocess, datetime

# ---- Parse payload ----
try:
    payload = json.loads(sys.argv[1])
except Exception:
    sys.exit(0)

if payload.get("tool_name", "") != "Bash":
    sys.exit(0)

cmd = (payload.get("tool_input", {}) or {}).get("command", "") or ""

# ---- Gated-verb early exit (FIRST real check — before any file/git read) ----
# Keep this cheap: pure regex on the command string. The expensive path (git
# queries, footprint read) runs only for genuine commit/add-wide invocations.
is_commit = bool(re.search(r'\bgit\s+commit\b', cmd))

def _add_is_wide(command):
    # Gate `git add` only for working-tree-wide forms; explicit pathspec add is safe.
    # The `.` arm must match only a STANDALONE `.` token (whole-cwd add); a leading
    # `./` on an explicit pathspec (`git add ./docs/x.md`) is NOT wide — hence the
    # trailing group is `(\s|$)`, not `(\s|$|/)` (QC finding, 2026-06-09 S5).
    for m in re.finditer(r'\bgit\s+add\b([^&|;]*)', command):
        args = m.group(1)
        if re.search(r'(^|\s)(-A|--all|-u|--update|\.)(\s|$)', args):
            return True
    return False

is_add_wide = bool(re.search(r'\bgit\s+add\b', cmd)) and _add_is_wide(cmd)

if not is_commit and not is_add_wide:
    sys.exit(0)

# ---- Helpers ----
def sh(args):
    try:
        r = subprocess.run(args, capture_output=True, text=True, timeout=4)
        return r.stdout
    except Exception:
        return ""

project_dir = os.environ.get("CLAUDE_PROJECT_DIR", "") or os.getcwd()
repo_root = sh(["git", "-C", project_dir, "rev-parse", "--show-toplevel"]).strip()
if not repo_root:
    sys.exit(0)  # not a git repo → nothing to guard, degrade open

logs_dir = os.path.join(repo_root, "logs")
repo_name = os.path.basename(repo_root.rstrip("/"))  # for footprint prefix-stripping

def warn_open(msg):
    out = {"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "additionalContext": "[staging-tripwire] " + msg
    }}
    print(json.dumps(out))
    sys.exit(0)

# ---- Resolve this session's marker (per-id oracle → shared fallback) ----
session_id = os.environ.get("CLAUDE_CODE_SESSION_ID", "")
marker_raw = ""
if session_id:
    p = os.path.join(logs_dir, ".session-marker-" + session_id)
    if os.path.isfile(p):
        try:
            marker_raw = open(p).read().strip()
        except Exception:
            marker_raw = ""
if not marker_raw:
    p = os.path.join(logs_dir, ".session-marker")
    if os.path.isfile(p):
        try:
            marker_raw = open(p).read().strip()
        except Exception:
            marker_raw = ""

mm = re.search(r'\bS\d+\b', marker_raw)
sess = mm.group(0) if mm else ""

# ---- Live-foreign-session oracle (P3, 2026-06-11) ----
def _live_foreign_session(logs_dir, self_session_id):
    # A today-dated per-id marker (logs/.session-marker-<id>) OTHER than this session's
    # own = a session that primed in THIS checkout today and has not wrapped (/wrap-session
    # Step 13 removes the marker at teardown) ≈ a live foreign session here. This mirrors the
    # oracle path in detect-concurrent-session.sh. Self is excluded by id, so this session's
    # OWN per-id marker (which DOES exist by PreToolUse time — /prime wrote it) never counts.
    # If this session has no id (old CLI), the oracle is unavailable → return False so P3
    # degrades to the original warn+allow; never escalate to a stop we cannot ground.
    if not self_session_id:
        return False
    try:
        today = datetime.date.today().isoformat()
    except Exception:
        return False
    self_name = ".session-marker-" + self_session_id
    try:
        names = os.listdir(logs_dir)
    except Exception:
        return False
    for name in names:
        if not name.startswith(".session-marker-") or name == self_name:
            continue
        try:
            content = open(os.path.join(logs_dir, name)).read().strip()
        except Exception:
            continue
        if content and content.split(" ")[0] == today:
            return True
    return False

# ---- Read the `- Files in scope:` bullet under this session's marker header ----
footprint_raw = ""
notes = os.path.join(logs_dir, "session-notes.md")
if sess and os.path.isfile(notes):
    try:
        lines = open(notes, encoding="utf-8", errors="replace").read().splitlines()
    except Exception:
        lines = []
    header_re = re.compile(
        r'^##\s+\d{4}-\d{2}-\d{2}\s+—\s+Session\s+' + re.escape(sess) + r'\b')
    in_block = False
    for ln in lines:
        if ln.startswith("## "):
            in_block = bool(header_re.match(ln))
            continue
        if in_block and ln.lstrip().startswith("- Files in scope:"):
            footprint_raw = ln.split(":", 1)[1].strip()
            break

# ---- Q3 fail-open / P3 escalation: no concrete footprint ----
# Without a concrete footprint the guard cannot judge foreignness. Two sub-cases:
#   (a) a live foreign session is present in THIS checkout → STOP-and-confirm (exit 2).
#       The no-footprint + concurrent-session shape is the highest-risk UNGUARDED path
#       (improvement-log 467/501): the guard can't tell which staged files are yours, AND
#       another live session may have staged its own work. P3 (2026-06-11) escalates this
#       from the old warn+allow to a hard stop so a blind commit can't silently sweep a
#       foreign session's files. This runs AFTER the L72-91 gated-verb early exit, so only
#       genuine commit/add-wide invocations pay for it — ordinary Bash calls already exited.
#   (b) no live foreign session → warn + allow (the original fail-open): with no concurrent
#       session there is no foreign-contamination risk to block on.
low = footprint_raw.lower()
no_concrete_footprint = (
    not footprint_raw
    or "(inferred)" in low
    or "(none stated)" in low
    or "(none)" in low
    or not re.search(r'[\w./-]+\.\w+|[\w-]+/', footprint_raw))

if no_concrete_footprint:
    if _live_foreign_session(logs_dir, session_id):
        verb = "git add" if is_add_wide else "git commit"
        block_msg = (
            "[staging-tripwire] BLOCKED — this `" + verb + "` has NO concrete session "
            "footprint to check against (Files in scope is "
            + (footprint_raw or "absent")
            + "), AND a live concurrent session is active in this checkout (an un-wrapped "
            "per-id marker is present). This is the highest-risk concurrent-session shape: "
            "the guard cannot tell which staged files are yours, and another session may "
            "have staged its own work.\n"
            "STOP. Do NOT commit blind. Run `git diff --cached --name-only` and confirm "
            "with the operator that every staged file belongs to THIS session:\n"
            "  • Foreign files — unstage them (`git restore --staged <path>`) and commit "
            "only your own work.\n"
            "  • All yours — declare a concrete `- Files in scope:` footprint in this "
            "session's mandate so the guard can run normally, then retry the commit.")
        print(block_msg, file=sys.stderr)
        sys.exit(2)
    warn_open(
        "No concrete session footprint declared (Files in scope is "
        + (footprint_raw or "absent")
        + ") — the foreign-file staging guard is OFF for this commit. If another "
        "session is active, run `git diff --cached --name-only` and confirm every "
        "staged file is yours before committing.")

# ---- Parse footprint into a path list (repo-root-relative) ----
# Footprints may be written with a leading repo-name segment (e.g.
# `ai-resources/CLAUDE.md`) while `git` output is repo-root-relative
# (`CLAUDE.md`). Strip a leading repo-name segment so they compare equal
# (QC finding, 2026-06-09 S5).
footprint = []
for tok in re.split(r'[,\s]+', footprint_raw):
    tok = re.sub(r'^\./', '', tok.strip().strip("`").strip()).rstrip("/")
    if repo_name and tok.startswith(repo_name + "/"):
        tok = tok[len(repo_name) + 1:]
    if tok and not tok.startswith("("):
        footprint.append(tok)

# ---- Compute the candidate file set the verb would stage ----
def porcelain_entries():
    # (is_untracked, path) for every working-tree change. Untracked lines = `??`.
    out = sh(["git", "-C", repo_root, "status", "--porcelain", "--untracked-files=all"])
    entries = []
    for line in out.splitlines():
        if len(line) <= 3:
            continue
        xy = line[:2]
        path = line[3:].strip()
        if " -> " in path:           # rename: take the new name
            path = path.split(" -> ", 1)[1]
        path = path.strip().strip('"')
        if path:
            entries.append((xy == "??", path))
    return entries

candidates = []
if is_add_wide:
    # Scope the candidate set to what THIS add form would actually stage, so the
    # guard does not over-block (QC finding, 2026-06-09 S5):
    #   -u/--update            : tracked modifications only — never untracked.
    #   `cd X && git add .`    : only paths under subdir X.
    #   -A/--all / bare `.` @root : the whole working tree (untracked included).
    add_u_only = bool(
        re.search(r'\bgit\s+add\b[^&|;]*\s(-u|--update)\b', cmd)
        and not re.search(r'\bgit\s+add\b[^&|;]*\s(-A|--all)\b', cmd)
        and not re.search(r'\bgit\s+add\b[^&|;]*\s\.(\s|$)', cmd))
    subdir = None
    mcd = re.search(r'\bcd\s+([^\s;&|]+)\s*&&.*\bgit\s+add\b[^&|;]*\s\.(\s|$)', cmd)
    if mcd:
        subdir = re.sub(r'^\./', '', mcd.group(1).strip().strip('"').strip("'")).rstrip("/")
        if repo_name and subdir.startswith(repo_name + "/"):
            subdir = subdir[len(repo_name) + 1:]
    for is_untracked, path in porcelain_entries():
        if add_u_only and is_untracked:
            continue
        if subdir and not (path == subdir or path.startswith(subdir + "/")):
            continue
        candidates.append(path)
else:
    out = sh(["git", "-C", repo_root, "diff", "--cached", "--name-only"])
    candidates = [l.strip() for l in out.splitlines() if l.strip()]
    if re.search(r'\bgit\s+commit\b[^&|;]*\s(-a|--all)\b', cmd):  # commit -a sweeps tracked mods
        out2 = sh(["git", "-C", repo_root, "diff", "--name-only"])
        candidates += [l.strip() for l in out2.splitlines() if l.strip()]

# de-dup, preserve order
seen = set()
candidates = [c for c in candidates if not (c in seen or seen.add(c))]
if not candidates:
    sys.exit(0)  # nothing staged → nothing to guard

# ---- Exempt-list ----
EXEMPT_BASENAMES = {
    "session-notes.md", "decisions.md", "usage-log.md",
    "improvement-log.md", "coaching-data.md",
}
# Write-once / append-only process-artifact directories (repo-relative prefixes).
EXEMPT_DIR_PREFIXES = ("audits/risk-checks/", "audits/working/")

def is_exempt(path):
    base = os.path.basename(path)
    if base in EXEMPT_BASENAMES:
        return True
    for pref in EXEMPT_DIR_PREFIXES:
        if path.startswith(pref):
            return True
    # this session's own process byproducts under logs/
    if path.startswith("logs/"):
        if base.startswith(".session-marker") or base == ".prime-mtime":
            return True
        if re.match(r'session-plan-\d{4}-\d{2}-\d{2}-S\d+.*\.md$', base):
            return True
        if base.endswith("-scratchpad.md"):
            return True
        # Log-rotation byproducts (session-notes-archive-YYYY-MM.md,
        # improvement-log-archive.md, decisions-archive-*.md, …). These are
        # wrap-owned append/rotate artifacts — same benign cross-session class
        # as the append-only logs, and a wrap commit legitimately stages a
        # freshly-rotated archive alongside its source log.
        if "archive" in base:
            return True
    return False

def in_footprint(path):
    for fp in footprint:
        if path == fp or path.startswith(fp + "/"):
            return True
    return False

foreign = [c for c in candidates if not is_exempt(c) and not in_footprint(c)]

if not foreign:
    sys.exit(0)

# ---- Confirmed foreign files → BLOCK (exit 2, model-facing stderr) ----
verb = "git add" if is_add_wide else "git commit"
msg = (
    "[staging-tripwire] BLOCKED — this `" + verb + "` would stage "
    + str(len(foreign)) + " file(s) OUTSIDE this session's declared footprint:\n  "
    + "\n  ".join(foreign)
    + "\n\nThis is the concurrent-session contamination pattern: a file that is "
    "neither in your `- Files in scope:` nor a shared log/process artifact is about "
    "to be swept into your commit — most likely another live session's staged work.\n"
    "STOP. Do NOT retry the commit as-is. Surface these files to the operator and "
    "confirm they belong to THIS session:\n"
    "  • If they are another session's work — unstage them "
    "(`git restore --staged <path>`) and commit only your footprint.\n"
    "  • If they genuinely belong to this session — your declared footprint "
    "is too narrow; tell the operator before overriding.\n"
    "Declared footprint: " + ", ".join(footprint)
)
print(msg, file=sys.stderr)
sys.exit(2)
PYEOF
