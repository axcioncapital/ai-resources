#!/bin/bash
# PreToolUse(Bash) destructive-op liveness probe — the fix for the 2026-07-14 S2
# near-miss (improvement-log.md 2026-07-14, "Destructive git ops have NO liveness
# check"). S2's mandate, session plan and /risk-check prompt ALL specified
# `git worktree remove` + `git branch -D` on a worktree that held a LIVE Claude
# session with 173+ lines of uncommitted work across 5 files. Every gate passed it.
# What caught it was the operator noticing an open VS Code window.
#
# WHY A HOOK AND NOT A DOC — this is the load-bearing design decision, and it was
#   forced by evidence. A prose warning saying exactly this ("Never remove a worktree
#   a live session still occupies") ALREADY EXISTED in new-worktree-session.md and
#   close-worktree-session.md before S2, and it DID NOT FIRE — because S2 assembled the
#   destructive command directly in a session plan and never opened either file. A gate
#   that must be REMEMBERED is not a gate; memory-dependent gates are this workspace's
#   most-documented failure mode. /risk-check is likewise the wrong home: it runs at PLAN
#   time, reads the repo at rest, and a session can go live between the gate and the act
#   — that relocates the bug one layer up rather than fixing it. Liveness must be probed
#   at EXECUTION time, by the executor, immediately before the command. That is a
#   PreToolUse hook, and nothing else.
#
# WHY IT WORKS WHERE A FILE CENSUS CANNOT — every other gate in this repo (/risk-check,
#   /blindspot-scan, /lean-repo, /qc-pass) reads the artifact AT REST. This hazard is the
#   artifact IN MOTION. A file census cannot see a running process. This hook does not
#   inspect content; it asks "is anyone home?" — three cheap, mechanical questions against
#   the TARGET checkout, not the current one. (S2's fatal reading was `git status` on the
#   target at 08:50, treated as a permanent property. It is a reading of a moving system:
#   the target was clean at 08:50 and held a live session by the time the command ran.)
#
# GATED VERBS (everything else exits 0 immediately, before any file/git read):
#   git worktree remove <path>   — target = <path>              (destroys an entire checkout)
#   git branch -d/-D <branch>    — target = the worktree that has <branch> checked out, if any
#   git reset --hard             — target = the CURRENT checkout (destroys uncommitted work)
#   git clean -f/-fd/-fdx        — target = the CURRENT checkout (destroys untracked files)
#
# THE THREE PROBES (run against the resolved TARGET, never the current checkout unless the
#   target IS the current checkout):
#   (a) `git -C <target> status --short`         → uncommitted work present?
#   (b) `<target>/logs/.session-marker-*`        → a session primed there and has not wrapped?
#       ANY DATE, not just today — an overnight session's marker is dated yesterday and a
#       today-only filter silently passes it. (close-worktree-session.md Step 3 carried
#       exactly that bug; fixed in the same change as this hook.)
#   (c) mtime of the target's dirty files        → written in the last LIVENESS_WINDOW_MIN?
#   Any hit → BLOCK (exit 2). Liveness is the one fact only the operator holds.
#
# SELF-EXCLUSION — for a target that IS the current checkout (reset --hard / clean -f), probe
#   (b) excludes THIS session's own per-id marker: your own marker is always present and would
#   otherwise block every reset you legitimately run on your own tree. What it then detects is a
#   FOREIGN live session sharing this checkout — whose uncommitted work lives in the same working
#   tree and would be destroyed. For a target that is a DIFFERENT checkout, no exclusion applies:
#   any marker there is by definition another session's.
#
# AUTHORITY — ADVISORY TRIPWIRE, not enforcement (principle OP-5), exactly as
#   check-foreign-staging.sh. `exit 2` feeds the evidence back to the AGENT (not an operator
#   permission prompt — this respects the zero-permission-prompt / bypassPermissions floor).
#   The agent can technically re-run the command, so the message instructs STOP-and-surface-to-
#   operator (OP-3 loud-failure path), never silent self-correction.
#
# KNOWN LIMITS — stated plainly, because a guard that overstates its coverage is worse than one
#   that admits a gap. Do not let this section be trimmed into a reassurance.
#
#   1. A CRASHED session leaves a stale marker, so probe (b) can fire on a genuinely idle
#      checkout. Correct trade: a false stop costs one operator sentence; a false pass costs
#      unrecoverable work. Probe (c) helps tell them apart (stale marker + clean tree + no
#      recent writes ≈ a corpse). The operator decides; the hook never decides for them.
#
#   2. ⚠ A SESSION THAT NEVER RAN /prime IS INVISIBLE TO PROBE (b). The per-id marker is written
#      by /prime. A session that skipped it leaves no marker — so probe (b), the strongest of the
#      three, sees nothing. Probes (a) and (c) still catch such a session ONCE IT HAS WRITTEN
#      something, but a session that has thought for twenty minutes and saved nothing is invisible
#      to all three. This is not a hypothetical gap: it is S2's own shape, and what caught S2 was
#      an operator's eyeball, not a file. THIS HOOK NARROWS THE HAZARD; IT DOES NOT CLOSE IT.
#
#   3. `git branch -d/-D` is guarded only when the branch is CHECKED OUT in some worktree (that is
#      how a target checkout is resolved). Deleting a branch that is checked out NOWHERE destroys
#      commits, not a working tree — a different hazard, and one this hook deliberately does not
#      cover. It is nominally covered by workspace Autonomy Rule #1 (destructive git ops are
#      operator-gated) — but note honestly that that is a MEMORY-DEPENDENT RULE, i.e. exactly the
#      class of control this hook exists because it does not work. Unguarded in practice. Say so
#      rather than counting it as coverage.
#
# CONTRACT — non-blocking on every path EXCEPT a confirmed liveness hit (exit 2). If python3
#   or git is unavailable, exits 0 (degrades OPEN — never block a command because the guard
#   itself broke). Reads only; writes nothing. timeout: 5 in settings.json.
#   Two-end contract registered in docs/commit-discipline.md § Destructive-op pre-flight.

set -u

# python3 required for robust JSON/command parsing (matches check-foreign-staging.sh).
# If absent, degrade OPEN — never block because the guard cannot run.
command -v python3 >/dev/null 2>&1 || exit 0

payload=$(cat)

python3 - "$payload" << 'PYEOF'
import json, sys, os, re, subprocess, datetime, shlex

# How recently a file must have been written for probe (c) to call the target "warm".
LIVENESS_WINDOW_MIN = 120

# ---- Parse payload ----
try:
    payload = json.loads(sys.argv[1])
except Exception:
    sys.exit(0)

if payload.get("tool_name", "") != "Bash":
    sys.exit(0)

cmd = (payload.get("tool_input", {}) or {}).get("command", "") or ""


def _command_text_only(command):
    """Blank heredoc bodies and quoted spans so the gated-verb regexes match only REAL
    invocations. Lifted verbatim from check-foreign-staging.sh, where it fixed a recorded
    false-trigger class (Symptom B, 2026-06-12): a `cat <<'EOF' … git clean -f … EOF`
    append, or a quoted commit message naming a verb, is not an invocation and must not
    gate. Degrades toward not-seeing-text (a fail-open miss), never a false block."""
    out_lines = []
    heredoc_delim = None
    for line in command.split("\n"):
        if heredoc_delim is not None:
            if line.strip() == heredoc_delim:
                heredoc_delim = None
            out_lines.append("")
            continue
        hm = re.search(r"<<-?\s*[\"']?(\w+)[\"']?", line)
        if hm:
            heredoc_delim = hm.group(1)
            out_lines.append(line[:hm.start()])
            continue
        out_lines.append(line)
    text = "\n".join(out_lines)
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    text = re.sub(r"'(?:\\.|[^'\\])*'", "''", text)
    return text


scan = _command_text_only(cmd)

# Command-segment boundary: start-of-string, newline, or after a shell separator.
# Anchoring here (rather than matching anywhere) is what stops `echo git clean -f` gating.
_VB = r'(?:^|[\n;&|(])\s*'

# `-C <path>` must tolerate a QUOTED path containing spaces. `\S+` cannot match
# `"/Users/…/Claude Code/Axcion AI Repo/…"`, so with a bare `\S+` the optional group fails,
# the whole pattern fails, and `git -C "<spaced path>" worktree remove <target>` is NEVER
# DETECTED — the hook exits 0 on a destructive command it was written to stop.
#
# ⚠ This is the SAME space-bug the harness caught in the TARGET argument, sitting one
# argument to the left, and it survived the first fix because the harness had no `-C` case.
# Found by the System Owner review, 2026-07-14; reproduced before fixing. EVERY path in this
# workspace contains spaces — treat `\S+` as a defect anywhere it can meet a path.
_GC = r'(?:-C\s+(?:"[^"]*"|\'[^\']*\'|\S+)\s+)?'

# ENV-ASSIGNMENT PREFIX — CLOSES A SILENT BYPASS OF ALL FOUR GATED VERBS.
#
# `_VB` anchors to a command-segment boundary and was immediately followed by `git\s+`. But a
# shell command may legally carry environment assignments BEFORE the binary:
#
#     FOO=bar git worktree remove <path>          <- was NOT detected  -> exit 0, SILENTLY ALLOWED
#     env FOO=bar git worktree remove <path>      <- was NOT detected  -> exit 0, SILENTLY ALLOWED
#     git worktree remove <path>                  <- detected, blocked (correct)
#     cd /tmp && git worktree remove <path>       <- detected, blocked (correct)
#
# Reproduced by execution 2026-07-14 (S8) against a live marker. This was NOT a designed override
# — it was an open hole in the one guard that exists because a session came a single operator
# remark from destroying 173+ lines of uncommitted work in two canonical skills. It defeated ALL
# FOUR verbs (worktree remove / branch -D / reset --hard / clean -f), because every pattern shares
# the `_VB + git` prefix.
#
# ⚠ The hole is also why the override below had to be built SECOND, not first: an
# `AXCION_LIVENESS_OVERRIDE=1 git …` override would have "worked" by exploiting this bug — shipping
# a feature that made the hole look intentional, and leaving `FOO=bar` as a live bypass. Close the
# hole, THEN add the door. Order is load-bearing; do not reorder.
_ENVPFX = r'(?:env\s+)?(?:[A-Za-z_][A-Za-z0-9_]*=(?:"[^"]*"|\'[^\']*\'|[^\s;&|]*)\s+)*'

RE_WORKTREE = _VB + _ENVPFX + r'git\s+' + _GC + r'worktree\s+remove\b([^&|;\n]*)'
RE_BRANCH   = _VB + _ENVPFX + r'git\s+' + _GC + r'branch\s+[^&|;\n]*?-(?:d|D)\b([^&|;\n]*)'
RE_RESET    = _VB + _ENVPFX + r'git\s+' + _GC + r'reset\b[^&|;\n]*?--hard\b'
RE_CLEAN    = _VB + _ENVPFX + r'git\s+' + _GC + r'clean\b[^&|;\n]*?-[a-zA-Z]*f'

# DETECT the verb on `scan` (heredoc/quote-blanked) so a mere mention cannot gate.
is_worktree = bool(re.search(RE_WORKTREE, scan))
is_branch   = bool(re.search(RE_BRANCH, scan))
is_reset    = bool(re.search(RE_RESET, scan))
is_clean    = bool(re.search(RE_CLEAN, scan))

if not (is_worktree or is_branch or is_reset or is_clean):
    sys.exit(0)   # not a destructive verb → nothing to guard. Cheap path; no git/file reads.

# ---- OPERATOR OVERRIDE — an auditable door, replacing a guard-defeating workaround ----
#
# WHY THIS EXISTS. Before this, the ONLY way past a false-positive block was to DELETE THE MARKER
# FILES THE GUARD READS and re-run the command. That is what actually happened on 2026-07-14 (S5),
# and it is recorded in friction-log.md as a guard-defeat path "sitting in the open". A guard whose
# documented bypass is "erase its evidence, then retry" does not stay a guard for long: the habit it
# trains is deleting a signal, and one day that signal will be true.
#
# THE REAL FALSE-POSITIVE THIS SERVES. The marker is a LIVENESS oracle, not a "has-wrapped" oracle.
# SessionEnd (which tears the marker down) fires when the CLI PROCESS ends — not when
# /wrap-session finishes (docs/session-marker.md:227). So a session that has wrapped but whose
# window is still open is STILL LIVE by the oracle's definition, and the guard is RIGHT to block.
# The operator, meaning "that session is finished", needs a way to say so — on the record.
#
# CONTRACT: this allows the command and WRITES AN AUDIT LINE. It never silently permits. If you are
# reaching for `rm` on a marker file, use this instead — that is the entire point.
# ⚠ THE OVERRIDE MUST BE MATCHED ON `scan`, AND MUST BIND TO THE DESTRUCTIVE VERB.
#
# The original form was `re.search(r'\bAXCION_LIVENESS_OVERRIDE=1\b', cmd)` — raw `cmd`, no
# binding. That put the override check on the WRONG SIDE of this file's own load-bearing
# cmd/scan split (documented below at "LOAD-BEARING SPLIT"): verb DETECTION correctly uses
# `scan`, so a quoted mention cannot gate, while the override read raw `cmd`, so a quoted
# mention COULD open the door. Two shapes were accepted that must not be, both reproduced by
# execution 2026-07-19 (S5-dd5) before this fix and re-run as fixtures after it:
#
#   NOTE=AXCION_LIVENESS_OVERRIDE=1 git reset --hard              <- bound to NOTE, not the verb
#   git commit -m "…AXCION_LIVENESS_OVERRIDE=1…" && git reset --hard  <- only inside a quoted string
#
# The fix reuses `_ENVPFX`'s own grammar (:175) rather than inventing one: the override must
# appear as one of the environment assignments prefixing an actual destructive verb. `_VB`
# (:142) anchors each pattern to a real command boundary (`^` or `[\n;&|(]`), which is what
# stops the engine from matching the token where it sits INSIDE another assignment's value —
# that anchor is why `NOTE=AXCION_LIVENESS_OVERRIDE=1 …` cannot match. Matching on `scan`
# (quoted spans blanked) is what kills the second shape.
#
# Do NOT "simplify" this back to a bare search on `cmd`. That is the defect, exactly.
_ASSIGN = r'[A-Za-z_][A-Za-z0-9_]*=(?:"[^"]*"|\'[^\']*\'|[^\s;&|]*)\s+'
_OVRPFX = (r'(?:env\s+)?(?:' + _ASSIGN + r')*AXCION_LIVENESS_OVERRIDE=1\s+'
           r'(?:' + _ASSIGN + r')*')

RE_OVR_WORKTREE = _VB + _OVRPFX + r'git\s+' + _GC + r'worktree\s+remove\b'
RE_OVR_BRANCH   = _VB + _OVRPFX + r'git\s+' + _GC + r'branch\s+[^&|;\n]*?-(?:d|D)\b'
RE_OVR_RESET    = _VB + _OVRPFX + r'git\s+' + _GC + r'reset\b[^&|;\n]*?--hard\b'
RE_OVR_CLEAN    = _VB + _OVRPFX + r'git\s+' + _GC + r'clean\b[^&|;\n]*?-[a-zA-Z]*f'

override = any(re.search(p, scan) for p in
               (RE_OVR_WORKTREE, RE_OVR_BRANCH, RE_OVR_RESET, RE_OVR_CLEAN))
if override:
    try:
        log_dir = os.path.join(
            subprocess.run(["git", "rev-parse", "--show-toplevel"],
                           capture_output=True, text=True, timeout=4).stdout.strip() or ".",
            "logs")
        os.makedirs(log_dir, exist_ok=True)
        # ⚠ THIS RECORD IS WRITTEN AT PreToolUse — BEFORE THE COMMAND RUNS. It therefore
        # CANNOT attest that the command succeeded, or even that it executed: the operator
        # may interrupt, a later hook may block, or the command may fail. The record asserts
        # exactly one thing — that an override was requested and this guard accepted it —
        # and the `event=` / `outcome=` fields say so in the line itself, so a future reader
        # cannot mistake the trail for an execution log. (Fixed 2026-07-19, S5-dd5: the prior
        # line carried no outcome field at all, so every entry read as "this happened.")
        #
        # Adding a real outcome would require a PostToolUse counterpart — a new registration
        # on a globally-registered hook. That is a separately-scoped change and needs its own
        # /risk-check; it was explicitly declined as a rider on this fix. Do not bolt it on here.
        with open(os.path.join(log_dir, "destructive-override.log"), "a") as f:
            f.write("%s  event=override-accepted  phase=pre-execution  outcome=unknown"
                    "  session=%s  cmd=%s\n" % (
                        datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                        os.environ.get("CLAUDE_CODE_SESSION_ID", "<unknown>"),
                        cmd.strip().replace("\n", " ")[:300]))
    except Exception:
        pass  # An override must never fail because its own audit trail could not be written.
    print("[destructive-op liveness] OVERRIDE ACCEPTED — operator asserted the target is idle. "
          "Guard stands down; the command has NOT yet run and its outcome is unrecorded. "
          "Request logged to logs/destructive-override.log.", file=sys.stderr)
    sys.exit(0)

# EXTRACT arguments from the RAW command, never from `scan`.
#
# ⚠ LOAD-BEARING SPLIT — DO NOT "SIMPLIFY" BY REUSING `scan` FOR BOTH.
# `_command_text_only` blanks QUOTED SPANS. check-foreign-staging.sh can reuse `scan`
# throughout because it only ever needs to know THAT a verb ran — it never reads an
# argument. This hook must read the TARGET PATH, and a real worktree path contains spaces
# ("…/Claude Code/Axcion AI Repo/…") so it is ALWAYS quoted. Matching the argument against
# `scan` therefore yields '' → target unresolved → the hook degrades OPEN on precisely the
# command it exists to stop. Caught by the test harness on the first run, 2026-07-14: the
# live-worktree case silently returned exit 0. Detection needs the blanked text; extraction
# needs the raw text. Two passes, deliberately.
m_worktree = re.search(RE_WORKTREE, cmd) if is_worktree else None
m_branch   = re.search(RE_BRANCH, cmd) if is_branch else None
m_reset    = is_reset
m_clean    = is_clean


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
    sys.exit(0)   # not a git repo → nothing to guard, degrade open

session_id = os.environ.get("CLAUDE_CODE_SESSION_ID", "")


def _first_arg(argstr):
    """First non-flag token — the <branch> in `branch -D <branch>`. Quote-aware via shlex.

    ⚠ Use _resolve_dir_arg (below) for PATHS. Naive whitespace splitting is a real,
    caught bug here: every path in this workspace contains spaces ("…/Claude Code/Axcion
    AI Repo/…"), so `.split()` shreds a quoted path into four tokens and the first one is
    not a directory → target unresolved → the hook degrades OPEN on the very command it
    exists to stop. The test harness caught this on `worktree remove` while `branch -D`
    passed, because branch names have no spaces. 2026-07-14."""
    try:
        toks = shlex.split(argstr or "")
    except Exception:
        toks = (argstr or "").split()
    for t in toks:
        t = t.strip()
        if not t or t.startswith("-"):
            continue
        return t
    return ""


def _resolve_dir_arg(argstr, base):
    """Resolve the <path> argument of `worktree remove` to an existing directory.

    Two passes, because a path with spaces can reach us either correctly quoted (shlex
    yields one token) or — if an agent forgot the quotes — as several bare tokens that no
    single token can reconstruct:
      1. shlex-split, take the first non-flag token, test isdir.
      2. Fallback: strip flags from the RAW argstring, strip surrounding quotes, and treat
         the whole remainder as one path. This recovers the unquoted-path-with-spaces case,
         which is malformed shell (git itself would reject it) but must still BLOCK rather
         than silently pass — a guard that opens on a malformed destructive command is worse
         than no guard, because it reads as 'checked and cleared'.
    Returns '' only when nothing resolves to a real directory."""
    cand = _first_arg(argstr)
    if cand:
        p = cand if os.path.isabs(cand) else os.path.abspath(os.path.join(base, cand))
        if os.path.isdir(p):
            return p
    raw = re.sub(r'(^|\s)--?[A-Za-z-]+', ' ', argstr or "")     # drop flags
    raw = raw.strip().strip('"').strip("'").strip()
    if raw:
        p = raw if os.path.isabs(raw) else os.path.abspath(os.path.join(base, raw))
        if os.path.isdir(p):
            return p
    return ""


def _worktree_for_branch(branch):
    """Resolve which checkout (if any) has <branch> checked out. A branch that is not
    checked out anywhere has no working tree to destroy — deleting it risks commits, not
    uncommitted files, and that is not this hook's job (autonomy rule #1 already gates it)."""
    out = sh(["git", "-C", repo_root, "worktree", "list", "--porcelain"])
    cur_path = None
    for line in out.splitlines():
        if line.startswith("worktree "):
            cur_path = line[len("worktree "):].strip()
        elif line.startswith("branch ") and cur_path:
            ref = line[len("branch "):].strip()
            if ref in ("refs/heads/" + branch, branch):
                return cur_path
    return ""


# ---- Resolve the TARGET checkout (the whole point — never probe the current one by default) ----
target = ""
verb = ""
if m_worktree:
    verb = "git worktree remove"
    target = _resolve_dir_arg(m_worktree.group(1), project_dir)
elif m_branch:
    verb = "git branch -d/-D"
    br = _first_arg(m_branch.group(1))
    target = _worktree_for_branch(br) if br else ""
    if not target:
        sys.exit(0)   # branch not checked out anywhere → no working tree at risk
elif m_reset:
    verb = "git reset --hard"
    target = repo_root
elif m_clean:
    verb = "git clean -f"
    target = repo_root

if not target or not os.path.isdir(target):
    # FAIL CLOSED — deliberately, and against this hook's own general degrade-open posture.
    #
    # Reaching here means a destructive verb WAS detected and its target could NOT be resolved.
    # That is not "nothing to guard" — it is "the guard is confused about a command that can
    # destroy a checkout." Degrading open here was the original behaviour and it is exactly how
    # the `-C`-with-spaces hole stayed invisible: an unresolvable target LOOKED like an
    # all-clear. A guard that cannot see its target must not report safe.
    #
    # Note the asymmetry, which is intentional: `git branch -d/-D` for a branch checked out in
    # NO worktree exits 0 above — that is a positive determination (no working tree exists to
    # destroy), not a failure to resolve. Confusion blocks; a clean negative does not.
    print("[destructive-op liveness] BLOCKED — `" + (verb or "destructive git verb")
          + "` was detected, but its TARGET checkout could not be resolved.\n"
            "The guard cannot confirm the target is unoccupied, so it will not report it safe.\n"
            "STOP. Re-run with an explicit, quoted, absolute path to the target checkout, or\n"
            "surface the command to the operator. Do not bypass this by rephrasing the command.",
          file=sys.stderr)
    sys.exit(2)

target_is_self = os.path.realpath(target) == os.path.realpath(repo_root)

# ---- Probe (a): uncommitted work in the TARGET ----
dirty = [l for l in sh(["git", "-C", target, "status", "--short"]).splitlines() if l.strip()]

# For reset --hard / clean -f the target IS your own tree and dirtiness is EXPECTED — it is
# what you are deliberately discarding. Dirtiness alone must not block that. What matters
# there is whether the dirt might be a FOREIGN session's (probe b). For a different checkout,
# any uncommitted work is someone else's by definition and is a hard hit.
dirty_is_hit = bool(dirty) and not target_is_self

# ---- Probe (b): a session primed in the TARGET and has not wrapped (ANY date) ----
markers = []
logs_dir = os.path.join(target, "logs")
self_marker = ".session-marker-" + session_id if session_id else None
try:
    for name in sorted(os.listdir(logs_dir)):
        if not name.startswith(".session-marker-"):
            continue
        # Self-exclusion applies ONLY when the target is this very checkout; otherwise a
        # marker there is by definition another session's.
        if target_is_self and self_marker and name == self_marker:
            continue
        try:
            content = open(os.path.join(logs_dir, name)).read().strip()
        except Exception:
            content = "(unreadable)"
        markers.append((name, content))
except Exception:
    pass   # no logs/ dir → no marker signal; the other probes still run

# ---- Probe (c): was anything in the TARGET written recently? ----
#
# Self-target caveat (caught by the test harness, 2026-07-14): when the target IS this
# checkout, the dirty files and their fresh mtimes are YOUR OWN work — you are deliberately
# discarding it, and that is the entire point of `reset --hard` / `clean -f`. Counting them
# as liveness evidence false-blocks every legitimate reset a session runs on its own tree.
# So probe (c), like probe (a), is a hit only for a FOREIGN checkout. On a self-target the
# ONLY signal that means "someone else is home" is probe (b) with self excluded — a foreign
# session sharing this working tree, whose uncommitted work would be destroyed alongside yours.
warm = []
if not target_is_self:
    try:
        cutoff = datetime.datetime.now().timestamp() - LIVENESS_WINDOW_MIN * 60
        for rel in [l[3:].strip().strip('"') for l in dirty]:
            if " -> " in rel:
                rel = rel.split(" -> ", 1)[1]
            p = os.path.join(target, rel)
            try:
                if os.path.getmtime(p) > cutoff:
                    warm.append(rel)
            except Exception:
                continue
    except Exception:
        pass

if not (dirty_is_hit or markers or warm):
    sys.exit(0)   # target is clean, unoccupied, and cold → proceed

# ---- A liveness hit → BLOCK (exit 2, model-facing stderr) ----
lines = []
lines.append("[destructive-op liveness] BLOCKED — `" + verb + "` targets a checkout that "
             "appears to be OCCUPIED:")
lines.append("  target: " + target)
lines.append("")
if dirty_is_hit:
    lines.append("  (a) UNCOMMITTED WORK — " + str(len(dirty)) + " path(s) in the target:")
    for l in dirty[:10]:
        lines.append("        " + l)
    if len(dirty) > 10:
        lines.append("        … and " + str(len(dirty) - 10) + " more")
if markers:
    lines.append("  (b) LIVE SESSION MARKER — a session primed in that checkout and has not wrapped:")
    for name, content in markers[:5]:
        lines.append("        " + name + "  →  " + content)
if warm:
    lines.append("  (c) RECENT WRITES — file(s) modified in the last "
                 + str(LIVENESS_WINDOW_MIN) + " minutes:")
    for w in warm[:5]:
        lines.append("        " + w)
lines.append("")
lines.append("STOP. Do NOT re-run this command. A clean worktree is not an idle worktree, and")
lines.append("a `git status` you ran minutes ago is a reading of a MOVING system. On 2026-07-14")
lines.append("this exact command was one operator remark away from destroying 173+ lines of a")
lines.append("live session's uncommitted work, with no other copy anywhere.")
lines.append("")
lines.append("Surface the evidence above to the operator and ask directly: is a session running")
lines.append("in that checkout right now? Liveness is the one fact only the operator holds — no")
lines.append("scan in this repo can see a running process.")
lines.append("  • Session is LIVE → do not proceed. Let it wrap and commit first.")
lines.append("  • Operator confirms it is IDLE (a crashed session can leave a stale marker) →")
lines.append("    they say so explicitly, and only then does this become their call, not yours.")
lines.append("")
lines.append("If — and ONLY if — the operator confirms the target is idle, re-run the SAME command")
lines.append("with the override prefix. It proceeds and writes an audit line to")
lines.append("logs/destructive-override.log:")
lines.append("")
lines.append("    AXCION_LIVENESS_OVERRIDE=1 " + cmd.strip().split("\n")[0][:160])
lines.append("")
lines.append("⚠ Do NOT delete the marker files to get past this. That was the old workaround, it")
lines.append("defeats the guard by erasing the evidence it reads, and it leaves no record. The")
lines.append("override above exists precisely so you never have to do that again.")

print("\n".join(lines), file=sys.stderr)
sys.exit(2)
PYEOF
