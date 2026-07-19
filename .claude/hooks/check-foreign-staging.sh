#!/bin/bash
# PreToolUse(Bash) staging tripwire — Fix 2 of the concurrent-session isolation
# fix-plan (audits/2026-06-09-concurrent-session-isolation-fix-plan.md, build-order
# step 1). Catches the concurrent-session contamination that recurred at S3
# (2026-06-09): a `git commit --amend` in one session swept a FOREIGN session's
# staged file (claim-permission.template.md) into the commit, silently.
#
# WHAT IT GUARDS — when a gated git verb is about to run, it compares the files
#   that verb would stage against THIS session's declared footprint (the mandate's
#   `- Files in scope:` bullet UNION its `- Required outputs:` bullet). Files that are
#   neither in the footprint nor on the exempt-list are "foreign" — most likely another
#   concurrent session's staged work about to be swept into this commit.
#
#   The two bullets are read ASYMMETRICALLY, and that is load-bearing (2026-07-19):
#   files_in_scope is hard-validated by /session-start Step 2.5 and drives the
#   "is the guard armed at all?" decision; required_outputs is an unvalidated free-text
#   field, is shape-filtered per token, and may only WIDEN an already-armed guard. The
#   result is monotonic — the union can turn a block into a pass, never a pass into a
#   block. Both the DO-NOT-UNION note at the no_concrete_footprint gate and the shape
#   filter at the parse site are required to keep that property; do not remove either.
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
#     • A LIVE foreign session is active in this checkout (a per-id marker, ANY DATE, other
#       than this session's own is present AND — process-grounded 2026-07-18 — a foreign
#       Claude CLI process still has its kernel cwd inside this checkout) → BLOCK (exit 2,
#       stop-and-confirm). [Was "today-dated" until 2026-07-14; that filter silently missed
#       an overnight session — the marker is pruned by teardown, not by date. The process
#       condition was added 2026-07-18 because ghost markers from crashed/killed sessions
#       were arming this block on solo sessions. See _live_foreign_session().]
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
import json, sys, os, re, subprocess, datetime, fnmatch

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
#
# Symptom B fix (2026-06-12, improvement-log 2026-06-11 glob/heredoc entry): the
# verb regexes must see only ACTUAL command text, not git-verb mentions inside a
# heredoc body or a quoted string. A `cat >> log <<'EOF' … git commit … EOF`
# append, or a quoted commit message, is not a git invocation and must not gate.
# Two defenses combine: (1) blank heredoc bodies + quoted spans before matching,
# and (2) anchor the verb to a command-segment boundary (start, newline, or after
# ;/&&/||/|/( ) rather than matching anywhere in the string. (1) removes literal
# mentions; (2) keeps newline-separated real invocations gating while still
# rejecting a mid-line mention like `echo git commit`.
def _command_text_only(command):
    """Return `command` with heredoc bodies and quoted spans blanked, so the
    gated-verb regexes match only real invocations. Heredoc bodies
    (`cat <<'EOF' … EOF`) and quoted commit-message text are the recorded
    false-trigger sources (Symptom B). Best-effort line scanner — a pathological
    input (e.g. arithmetic `<< 2`) degrades toward not-seeing text, i.e. a
    fail-open miss, never a false block."""
    out_lines = []
    heredoc_delim = None
    for line in command.split("\n"):
        if heredoc_delim is not None:
            if line.strip() == heredoc_delim:
                heredoc_delim = None
            out_lines.append("")          # drop heredoc body content
            continue
        hm = re.search(r"<<-?\s*[\"']?(\w+)[\"']?", line)
        if hm:
            heredoc_delim = hm.group(1)
            out_lines.append(line[:hm.start()])  # keep the command before `<<`
            continue
        out_lines.append(line)
    text = "\n".join(out_lines)
    # Blank quoted spans (commit messages, echoed text mentioning a git verb).
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    text = re.sub(r"'(?:\\.|[^'\\])*'", "''", text)
    return text

scan = _command_text_only(cmd)

# Command-segment boundary: start-of-string, newline, or after a shell separator.
_VERB_BOUNDARY = r'(?:^|[\n;&|(])\s*'

is_commit = bool(re.search(_VERB_BOUNDARY + r'git\s+commit\b', scan))

def _add_is_wide(command):
    # Gate `git add` only for working-tree-wide forms; explicit pathspec add is safe.
    # The `.` arm must match only a STANDALONE `.` token (whole-cwd add); a leading
    # `./` on an explicit pathspec (`git add ./docs/x.md`) is NOT wide — hence the
    # trailing group is `(\s|$)`, not `(\s|$|/)` (QC finding, 2026-06-09 S5).
    # Boundary-anchored (Symptom B) so a quoted/heredoc `git add` mention cannot gate.
    for m in re.finditer(_VERB_BOUNDARY + r'git\s+add\b([^&|;]*)', command):
        args = m.group(1)
        if re.search(r'(^|\s)(-A|--all|-u|--update|\.)(\s|$)', args):
            return True
    return False

is_add_wide = bool(re.search(_VERB_BOUNDARY + r'git\s+add\b', scan)) and _add_is_wide(scan)

if not is_commit and not is_add_wide:
    sys.exit(0)

# ---- Helpers ----
def sh(args):
    try:
        r = subprocess.run(args, capture_output=True, text=True, timeout=4)
        return r.stdout
    except Exception:
        return ""

# Claude CLI process pattern — overridable for testing (mirrors detect-concurrent-session.sh).
CC_PROCESS_PATTERN = os.environ.get("CC_PROCESS_PATTERN", "native-binary/claude")

def _claude_pids():
    # ps, NOT pgrep: macOS pgrep excludes the calling process's own ancestors by
    # default, so it would never see THIS session's CLI process (verified by
    # execution 2026-07-18 — same fix as detect-concurrent-session.sh).
    # Returns None when ps itself failed (empty output — a real system always
    # lists processes); the caller must treat that as ungrounded, not as absence.
    out = sh(["ps", "-axo", "pid=,command="])
    if not out.strip():
        return None
    pids = []
    for line in out.splitlines():
        line = line.strip()
        if CC_PROCESS_PATTERN in line and "grep" not in line:
            tok = line.split(None, 1)[0]
            if tok.isdigit():
                pids.append(tok)
    return pids

def _self_cli_pid():
    # Walk up the ancestor chain from this hook to find the CLI process hosting
    # THIS session, so it can be excluded from the foreign count.
    p = str(os.getppid())
    for _ in range(10):
        cmd = sh(["ps", "-o", "command=", "-p", p]).strip()
        if CC_PROCESS_PATTERN in cmd:
            return p
        pp = sh(["ps", "-o", "ppid=", "-p", p]).strip()
        if not pp or pp in ("0", "1"):
            return ""
        p = pp
    return ""

def _foreign_cli_here(root_dir):
    """(grounded, count) of FOREIGN Claude CLI processes whose kernel cwd is inside
    root_dir — the set of sessions that share this checkout's git index. grounded is
    False when ps/lsof could not answer; the caller must then fall back to the
    marker-only heuristic rather than treating count=0 as proof of absence."""
    pids = _claude_pids()
    if pids is None:
        return (False, 0)      # ps failed → ungrounded, never "proof of absence"
    self_pid = _self_cli_pid()
    foreign = [p for p in pids if p != self_pid]
    if not foreign:
        return (True, 0)
    out = sh(["lsof", "-a", "-p", ",".join(foreign), "-d", "cwd", "-Fn"])
    cwds = [l[1:] for l in out.splitlines() if l.startswith("n")]
    if not cwds:
        return (False, 0)
    root = os.path.realpath(root_dir)
    n = 0
    for c in cwds:
        rc = os.path.realpath(c)
        if rc == root or rc.startswith(root + os.sep):
            n += 1
    return (True, n)

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

# Marker grammar: `S{N}` (legacy) or `S{N}-{id3}` (current — 3 chars of the session id).
# The suffix exists because two sessions in different checkouts could allocate the SAME S{N}
# (four real collisions in two days). A suffixed name cannot collide, so the S{N} number no
# longer has to be globally unique — the marker as a WHOLE does.
#
# ⚠ The optional group is LOAD-BEARING, not defensive padding. A bare `\bS\d+\b` MATCHES
# `S7-a4f` and returns `S7` — it does not fail, it SILENTLY TRUNCATES. Two different sessions
# (`S7-a4f`, `S7-b2c`) then both resolve to `S7`, and this guard reads the WRONG session's
# footprint out of session-notes.md with no error anywhere. Verified by execution, 2026-07-14.
# Readers accept BOTH grammars (500+ legacy headers still on disk); writers emit only the new one.
mm = re.search(r'\bS\d+(?:-[A-Za-z0-9]{3})?\b', marker_raw)
sess = mm.group(0) if mm else ""
# Marker date (the marker file stores "YYYY-MM-DD SX" — docs/session-marker.md).
# Defect A fix (2026-06-12, improvement-log first-firing entry): the header lookup
# below anchors on BOTH the date and the S-number. Matching the S-number alone let
# an older same-S entry from a prior day (e.g. "## 2026-06-10 — Session S2") match
# first and shadow today's CONCRETE footprint with its stale `(inferred)` one,
# false-firing the no-concrete-footprint branch on a validly-scoped session.
dm = re.search(r'\b\d{4}-\d{2}-\d{2}\b', marker_raw)
sess_date = dm.group(0) if dm else ""

# ---- Live-foreign-session oracle (P3, 2026-06-11) ----
def _live_foreign_session(logs_dir, self_session_id):
    # A per-id marker (logs/.session-marker-<id>) OTHER than this session's own = a session
    # that primed in THIS checkout and has not wrapped (/wrap-session Step 13 removes the
    # marker at teardown) ≈ a live foreign session here. This mirrors the oracle path in
    # detect-concurrent-session.sh. Self is excluded by id, so this session's OWN per-id
    # marker (which DOES exist by PreToolUse time — /prime wrote it) never counts.
    # If this session has no id (old CLI), the oracle is unavailable → return False so P3
    # degrades to the original warn+allow; never escalate to a stop we cannot ground.
    #
    # ⚠ ANY DATE — do NOT re-add a today-only filter. (Fixed 2026-07-14.) This function
    # previously required `content.split(" ")[0] == today`, which silently missed a session
    # that primed YESTERDAY and is still open overnight: the P3 escalation (no-footprint +
    # live concurrent session → BLOCK) quietly downgraded to a warn, and a blind commit could
    # sweep that session's staged files. The marker is pruned by SESSION TEARDOWN, not by
    # date — a marker's date records when the session STARTED, never whether it has ENDED.
    # Filtering it by date is a category error. The identical bug existed in
    # close-worktree-session.md Step 3 and was fixed in the same change; a crashed session's
    # stale marker is the accepted cost, and it is the correct trade (a false stop costs one
    # operator sentence; a false pass costs another session's work).
    # PROCESS-GROUNDING (2026-07-18) — a marker alone proves a session PRIMED here,
    # never that it is still alive: crashed/killed sessions leave markers (SessionEnd
    # cannot fire on SIGKILL), and those ghosts were arming this guard's highest-risk
    # BLOCK on solo sessions (friction-log 2026-07-12: "the guard was blocking on two
    # ghosts"). A session that is genuinely live in this checkout has a Claude CLI
    # process with its kernel cwd inside the repo (verified against the live process
    # table 2026-07-18). So: live == foreign marker present AND >=1 foreign CLI
    # process with cwd inside this checkout. If ps/lsof cannot answer (grounded
    # False), keep the marker-only answer — degrade toward blocking, matching the
    # documented trade (a false stop costs one operator sentence; a false pass costs
    # another session's work). Markers alone are still required: idle VS Code windows
    # keep CLI processes alive for days after their sessions ended, so process
    # presence alone would over-block every footprint-less commit.
    if not self_session_id:
        return False
    self_name = ".session-marker-" + self_session_id
    try:
        names = os.listdir(logs_dir)
    except Exception:
        return False
    marker_found = False
    for name in names:
        if not name.startswith(".session-marker-") or name == self_name:
            continue
        try:
            content = open(os.path.join(logs_dir, name)).read().strip()
        except Exception:
            continue
        if content:
            marker_found = True
            break
    if not marker_found:
        return False
    grounded, n_here = _foreign_cli_here(os.path.dirname(logs_dir))
    if not grounded:
        return True
    return n_here >= 1

# ---- Read the footprint bullets under this session's marker header ----
# TWO bullets are read (2026-07-19): `- Files in scope:` (files this session will touch)
# and `- Required outputs:` (files this session will CREATE). Reading only the first was a
# defect: /session-start Step 2.5(b) HARD-REJECTS a not-yet-existing path from files_in_scope
# and routes it to required_outputs, so a session that followed the schema exactly had its
# own outputs reported as foreign and its commit blocked (observed live 2026-07-19,
# axcion-content-programme). The guard's remediation text then pushed the operator to widen
# files_in_scope with not-yet-created files — precisely what Step 2.5(b) forbids. Two rules
# in the same harness contradicted each other; this reads the second field instead.
footprint_raw = ""
outputs_raw = ""
notes = os.path.join(logs_dir, "session-notes.md")
if sess and sess_date and os.path.isfile(notes):
    try:
        lines = open(notes, encoding="utf-8", errors="replace").read().splitlines()
    except Exception:
        lines = []
    # Anchor on the marker's own date AND S-number (Defect A fix) so only THIS
    # session's header matches — not a prior day's same-S entry. If sess_date is
    # empty (malformed marker), the gate above skips the read entirely and the
    # session falls through to the no-concrete-footprint path (safe degrade).
    #
    # ⚠ The terminator is `(?![-\w])`, NOT `\b`. This is not style — it is the mixed-grammar
    # correctness condition. `\b` fires between `7` and `-`, so a LEGACY marker `S7` would match
    # the header `## <date> — Session S7-a4f` and this guard would read a DIFFERENT session's
    # `- Files in scope:` footprint as its own. `(?![-\w])` refuses to match when a hyphen or word
    # character follows, so `S7` matches only `Session S7` and `S7-a4f` matches only
    # `Session S7-a4f`. Both grammars coexist on disk during the transition; keep this exact.
    header_re = re.compile(
        r'^##\s+' + re.escape(sess_date) + r'\s+—\s+Session\s+' + re.escape(sess) + r'(?![-\w])')
    in_block = False
    for ln in lines:
        if ln.startswith("## "):
            in_block = bool(header_re.match(ln))
            continue
        if not in_block:
            continue
        _s = ln.lstrip()
        # First occurrence of each bullet wins — preserves the original single-bullet
        # `break` semantics per field. The loop now runs to the end of THIS session's
        # block instead of breaking on the first hit; `in_block` is reset by the
        # `ln.startswith("## ")` arm above, so the scan still cannot read another
        # session's bullets.
        if _s.startswith("- Files in scope:") and not footprint_raw:
            footprint_raw = ln.split(":", 1)[1].strip()
        elif _s.startswith("- Required outputs:") and not outputs_raw:
            outputs_raw = ln.split(":", 1)[1].strip()
        if footprint_raw and outputs_raw:
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
# ⚠ THIS GATE IS DRIVEN BY `footprint_raw` (files_in_scope) ALONE — DO NOT union
# `outputs_raw` into it. That asymmetry is deliberate and it is what keeps the
# 2026-07-19 required-outputs change MONOTONIC: required_outputs may only WIDEN an
# already-armed guard, never ARM one that is off today. `required_outputs` is an
# UNVALIDATED free-text field (session-start Step 2.5 validates work_scope,
# exit_condition, files_in_scope and stop_if — not this one), and real entries on disk
# are prose: "settled article-research policy landed in a durable home". Letting such a
# field switch the guard ON would arm it with a near-empty effective footprint, so every
# staged file reads foreign and a SOLO session hard-blocks with no concurrency present —
# a new false-block class, which is the failure shape this file's history is full of.
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
for tok in re.split(r'[,;\s]+', footprint_raw):
    tok = re.sub(r'^\./', '', tok.strip().strip("`").strip()).rstrip("/")
    if repo_name and tok.startswith(repo_name + "/"):
        tok = tok[len(repo_name) + 1:]
    if tok and not tok.startswith("("):
        footprint.append(tok)

# ---- Union in `- Required outputs:` (2026-07-19) ----
# WHY A SHAPE FILTER HERE AND NOT ABOVE. `files_in_scope` is hard-validated by
# /session-start Step 2.5 check 3 (shape test + existence test, both HARD REJECT), so its
# tokens are already paths and are parsed above verbatim. `required_outputs` has NO
# validation of any kind — Step 2.5 checks four fields and this is not one of them. Live
# examples on disk: a clean path list; prose with zero paths ("settled article-research
# policy landed in a durable home"); and prose mixed with paths and a parenthetical. So
# every token is shape-tested before it is allowed into a footprint that a PARSER consumes.
#
# This filter is heuristic and deliberately errs toward DROPPING. A dropped real path costs
# a false block that already happens today (no regression); an admitted junk token cannot
# cost anything, because widening a footprint can only turn a block into a pass. That
# asymmetry is why the filter is safe to keep simple — but see the DO-NOT-UNION warning on
# the no_concrete_footprint gate above, which is what makes the asymmetry hold.
#
# Do NOT "fix" this by adding validation to required_outputs in this change — that is a
# separate, larger change touching every writer of the mandate line (/session-start,
# /prime Step 8c.7). Scope it on its own if wanted.
_PATH_SHAPE = re.compile(r'/|\.(?:md|sh|json|ya?ml|py|ts|js|txt|csv|toml|ini)$', re.I)

for tok in re.split(r'[,;\s]+', outputs_raw):
    tok = re.sub(r'^\./', '', tok.strip().strip("`").strip())
    if not tok or tok.startswith("("):
        continue
    # Leading `/` = not a repo-relative path. Git candidate paths are ALWAYS
    # repo-root-relative, so such a token could never match one; dropping it keeps
    # prose like "a `/risk-check` report under …" out of the block message.
    if tok.startswith("/"):
        continue
    if not _PATH_SHAPE.search(tok) and tok not in ("CLAUDE.md", "SKILL.md"):
        continue
    tok = tok.rstrip("/")
    if repo_name and tok.startswith(repo_name + "/"):
        tok = tok[len(repo_name) + 1:]
    if tok and tok not in footprint:
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
    # Parse the add FORM from `scan` (heredoc/quote-blanked), not raw cmd, so a
    # quoted/heredoc `git add` mention cannot mis-shape the candidate set (Symptom B).
    add_u_only = bool(
        re.search(r'\bgit\s+add\b[^&|;]*\s(-u|--update)\b', scan)
        and not re.search(r'\bgit\s+add\b[^&|;]*\s(-A|--all)\b', scan)
        and not re.search(r'\bgit\s+add\b[^&|;]*\s\.(\s|$)', scan))
    subdir = None
    mcd = re.search(r'\bcd\s+([^\s;&|]+)\s*&&.*\bgit\s+add\b[^&|;]*\s\.(\s|$)', scan)
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
    if re.search(r'\bgit\s+commit\b[^&|;]*\s(-a|--all)\b', scan):  # commit -a sweeps tracked mods
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
        # Run manifests (logs/runs/YYYY-MM-DD-S{N}.json), written by run-manifest.sh
        # and staged by /wrap-session Step 12d. Same marker-scoped process-artifact
        # class as session-plan-*.md directly above: the date+marker IS the filename,
        # so the file is structurally per-session and can never carry foreign work.
        # Before this clause, one command instructed the stage and this guard blocked
        # it — fired on every wrap whose mandate was written at /prime time (i.e. the
        # normal case), and taught sessions to reach for a bypass of the exact tripwire
        # that stops concurrent-session contamination (improvement-log 2026-07-13, id-53).
        # Deliberately NOT added to EXEMPT_DIR_PREFIXES: that is a blanket `startswith`
        # prefix, which would exempt ANY path under logs/runs/. This clause exempts only
        # the manifest filename shape, so a stray logs/runs/* file is still guarded.
        # `== "logs/runs/" + base` (not `startswith`) pins the file to a DIRECT child of
        # logs/runs/ — otherwise a nested logs/runs/<anything>/2026-07-13-S1.json would
        # satisfy both the prefix and the basename regex and slip through exempt.
        #
        # ⚠ The `(?:-[A-Za-z0-9]{3})?` group is what keeps `/wrap-session` WORKING under the
        # suffixed marker grammar. Without it, `\d{4}-\d{2}-\d{2}-S\d+\.json$` cannot match
        # `2026-07-14-S7-a4f.json` — `S\d+` consumes `S7`, then `\.json$` meets `-a4f.json` and
        # fails. The manifest loses its exemption, this guard blocks the wrap commit, and it does
        # so in EVERY checkout. Proven end-to-end in a fixture (2026-07-14 S8): `…-S1.json` → exit
        # 0; `…-S1-a4f.json` → exit 2. The marker rename would have re-created exactly the
        # command-fights-guard defect this clause was written to fix.
        if path == "logs/runs/" + base and re.match(
                r'\d{4}-\d{2}-\d{2}-S\d+(?:-[A-Za-z0-9]{3})?\.json$', base):
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
    # Symptom A fix (2026-06-12, improvement-log 2026-06-11 glob/heredoc entry):
    # footprint tokens legitimately use glob syntax (`wiki/**/*.md`, which
    # /session-start, /prime Step 8c, and hand-written mandates all emit). A literal
    # == / startswith comparison treats `*`/`**` as ordinary characters, so no real
    # path ever matches a glob token → the whole session false-blocks at commit even
    # with a current, correct footprint. For a glob token, match with fnmatch;
    # collapse `**`→`*` first since fnmatch's `*` already crosses `/`. Keep the
    # literal arm for non-glob tokens (exact path or directory prefix).
    for fp in footprint:
        if "*" in fp:
            if fnmatch.fnmatch(path, fp.replace("**", "*")):
                return True
        elif path == fp or path.startswith(fp + "/"):
            return True
    return False

foreign = [c for c in candidates if not is_exempt(c) and not in_footprint(c)]

if not foreign:
    # Exempt-file-sweep warn (2026-07-03, improvement-log 2026-07-03 "/open-items
    # backlog scan → field-match fix" incident 9660bf2): a bare `git commit` with a
    # CONCRETE, correct footprint can still silently fold in exempt files (append-only
    # logs, rotation archives) that a LIVE foreign session has mid-flight-staged. The
    # exempt-list correctly suppresses the hard BLOCK above (co-staging exempt files is
    # normally benign, no lost update) — but when a concurrent session is actually live,
    # "benign" is not guaranteed: the exempt file could be that session's in-progress
    # work, and this commit's message would misattribute it. Warn (never block) only in
    # this narrow case so the operator/agent can choose a pathspec-scoped commit instead.
    exempt_foreign = [c for c in candidates if is_exempt(c) and not in_footprint(c)]
    if exempt_foreign and is_commit and _live_foreign_session(logs_dir, session_id):
        warn_open(
            "This commit would include " + str(len(exempt_foreign)) + " exempt file(s) "
            "outside your declared footprint (" + ", ".join(exempt_foreign) + "), AND a "
            "live concurrent session is active in this checkout. Exempt files (append-only "
            "logs, rotation archives, process markers) are usually safe to co-commit, but "
            "if the concurrent session is mid-write to one of these, a bare `git commit` "
            "will fold its in-flight content into your commit message. Prefer a "
            "pathspec-scoped commit (`git commit -- <your-own-paths>`) so only your own "
            "work lands under this message, or confirm with the operator first.")
    sys.exit(0)

# ---- Confirmed foreign files → BLOCK (exit 2, model-facing stderr) ----
verb = "git add" if is_add_wide else "git commit"
msg = (
    "[staging-tripwire] BLOCKED — this `" + verb + "` would stage "
    + str(len(foreign)) + " file(s) OUTSIDE this session's declared footprint:\n  "
    + "\n  ".join(foreign)
    + "\n\nThis is the concurrent-session contamination pattern: a file that is in "
    "neither `- Files in scope:` nor `- Required outputs:`, and is not a shared log or "
    "process artifact, is about to be swept into your commit — most likely another live "
    "session's staged work.\n"
    "STOP. Do NOT retry the commit as-is. Surface these files to the operator and "
    "confirm they belong to THIS session:\n"
    "  • If they are another session's work — unstage them "
    "(`git restore --staged <path>`) and commit only your footprint.\n"
    "  • If they genuinely belong to this session — your declared footprint is too "
    "narrow. Route each file to the RIGHT field: one this session CREATED belongs in "
    "`- Required outputs:`, one it edited in `- Files in scope:`. Do NOT put a created "
    "file in Files in scope — /session-start Step 2.5(b) rejects it. Tell the operator "
    "before overriding.\n"
    "Declared footprint: " + ", ".join(footprint)
)
print(msg, file=sys.stderr)
sys.exit(2)
PYEOF
