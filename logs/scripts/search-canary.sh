#!/usr/bin/env sh
# search-canary.sh — announce when the ambient search instrument is blind.
#
#   MUST BE SOURCED, NOT EXECUTED:   . logs/scripts/search-canary.sh
#
# Executing it (`bash search-canary.sh`) measures the wrong shell and is
# refused — see "WHY SOURCED" below. That refusal is the whole point of the
# script's design; do not "fix" it by making execution report a verdict.
#
# WHY THIS EXISTS
# ---------------
# In a Claude Code session the shell's `grep` is not /usr/bin/grep. The harness
# writes a shell snapshot that shadows it with a bundled ugrep invoked as:
#
#     ugrep -G --ignore-files --hidden -I --exclude-dir=.git ...
#
# `--ignore-files` makes it honour .gitignore. Sensible for interactive use; a
# trap for auditing. A scan over a directory tree silently skips every
# gitignored path, and a zero-hit result is indistinguishable from "the term
# genuinely is not there". Absence-claims are most of what an audit produces,
# so the instrument quietly weakens the conclusions that most depend on it.
#
# Measured in ai-resources, 2026-07-18:
#     grep         -rl "Severity" .  -> 122 files
#     command grep -rl "Severity" .  -> 194 files
#
# The 72-file gap is audits/working/, logs/scratchpads/, inbox/archive/,
# /archive/ — and ai-resources/CLAUDE.md § Subagent Contracts *requires* audit
# subagents to write their full findings into audits/working/. The repo's own
# convention deposits its evidence in the one directory its search instrument
# cannot see. That is why per-site fixes are not sufficient on their own: the
# next scan will be written with a bare `grep` too.
#
# TWO LIMITS ON THE BLINDNESS — both verified by execution, both narrowing
# -----------------------------------------------------------------------
# 1. It filters DIRECTORY TRAVERSAL, not argv. A gitignored file named
#    explicitly on the command line IS searched:
#        grep "defaultMode" .claude/settings.local.json   -> 1 hit (correct)
#    So explicit-path greps are immune. Only tree walks (`grep -r <dir>`) are
#    exposed. Do not "fix" explicit-path greps — churn, no consequence.
#
# 2. It lives ONLY in the calling shell, as a shell function. It does not cross
#    a process boundary:
#        (calling zsh) type grep -> shell function
#        bash -c 'type grep'     -> /usr/bin/grep
#        zsh  -c 'type grep'     -> /usr/bin/grep
#    So every grep inside a script file (.claude/hooks/*.sh, logs/scripts/*.sh)
#    already runs the real grep and is NOT blind. Only greps the model runs
#    INLINE via the Bash tool — i.e. the instructions written in
#    .claude/commands/*.md and .claude/agents/*.md — are exposed.
#
# 3. It depends on the FORM of the traversal root. Measured with one sentinel
#    planted in the gitignored audits/working/, from the repo root:
#        grep -rl <s> .                  -> 0   BLIND
#        grep -rl <s> ./                 -> 0   BLIND
#        grep -rl <s> audits             -> 1   sees it
#        grep -rl <s> /abs/path/to/repo  -> 1   sees it
#        grep -rl <s> /abs/path/audits   -> 1   sees it
#        command grep -rl <s> .          -> 1   ground truth
#    Only the dot-rooted walk goes blind. (Consistent with the walker loading
#    the root .gitignore only when the walk starts at the root as `.`; the
#    mechanism is inferred, the measurements are not.)
#
#    CONSEQUENCE, and it is the opposite of what thread 11 assumed. Checked
#    2026-07-18: NO committed scan site in .claude/commands, .claude/agents,
#    .claude/hooks or logs/scripts uses the dot-rooted form. Every one of them
#    names a subdirectory or an absolute path, and is therefore immune. What
#    IS exposed is the ad-hoc `grep -r <term> .` a session types inline while
#    verifying something — including the ones used to gather evidence for this
#    very mission thread. The blindness is a property of how we VERIFY, not of
#    what we have COMMITTED. That is why this canary exists and why no site
#    edits were made: editing immune sites would be churn with no consequence.
#
#    This is why the probe below walks `.` from the repo root. Two earlier
#    drafts did not, and both reported "clear" on a demonstrably blind shell —
#    the same can-never-fail defect as the executed-vs-sourced trap, caught the
#    same way: by requiring the check to FAIL before trusting it.
#
# WHY SOURCED
# -----------
# Limit 2 is also why this file must be sourced. An executed script is a child
# process, where `grep` is already the real grep — so the probe would pass,
# every time, in every session, including sessions that ARE blind. The first
# draft of this canary did exactly that: it reported "tree-walking scans are
# reliable" from inside a bash subprocess while the parent shell was blind.
# A guard that cannot fail is the repo's single most-repeated defect class
# ("inert safeguard"), and it nearly shipped here inside the very session
# convened to fix search reliability. Hence: sourced, or refused.
#
# USAGE
#   . logs/scripts/search-canary.sh            # verdict on stdout
#   . logs/scripts/search-canary.sh --quiet    # sets $SEARCH_CANARY only
#
# RESULT
#   $SEARCH_CANARY = clear        ambient grep sees gitignored content
#                  = blind        ambient grep is BLIND on tree walks
#                  = inconclusive could not measure (see message)
#
# ADVISORY: a diagnostic, not a gate. Nothing should block on `blind` — report
# it, and use `command grep -r` or `git grep` for that scan.

axcion__search_canary() {
    _q=0
    [ "${1:-}" = "--quiet" ] && _q=1
    _say() { [ "$_q" -eq 1 ] || printf '%s\n' "$*"; }

    # --- Refuse to answer from the wrong shell -----------------------------
    # If `grep` is not a shell function here, we are either in a child process
    # or in a shell the harness never shadowed. Either way the measurement
    # would describe a shell that no scan actually runs in.
    case "$(type grep 2>/dev/null)" in
        *function*) : ;;
        *)
            SEARCH_CANARY=inconclusive
            _say "CANARY: inconclusive — 'grep' is not shadowed in this shell."
            _say "  This usually means the script was EXECUTED rather than sourced."
            _say "  The shadowing is a shell function and does not cross a process"
            _say "  boundary, so a child process always sees the real grep and would"
            _say "  report a false 'clear'. Re-run as:  . logs/scripts/search-canary.sh"
            return 2
            ;;
    esac

    _repo=$(git rev-parse --show-toplevel 2>/dev/null) || {
        SEARCH_CANARY=inconclusive
        _say "CANARY: inconclusive — not inside a git repository, so no gitignored"
        _say "  known-positive can be constructed."
        return 2
    }

    # Prefer audits/working/ — it is the directory the Subagent Contracts rule
    # writes to, so it is the most representative blind spot in this repo.
    _dir=""
    for _d in audits/working logs/scratchpads; do
        if [ -d "$_repo/$_d" ] && ( cd "$_repo" && git check-ignore -q "$_d" 2>/dev/null ); then
            _dir="$_repo/$_d"; break
        fi
    done
    if [ -z "$_dir" ]; then
        SEARCH_CANARY=inconclusive
        _say "CANARY: inconclusive — no existing gitignored directory to probe."
        return 2
    fi

    _sent="AXCION_SEARCH_CANARY_$$_$(od -An -N4 -tx1 /dev/urandom 2>/dev/null | tr -d ' \n')"
    _file="$_dir/.search-canary-$$.tmp"
    printf '%s\n' "$_sent" > "$_file" 2>/dev/null || {
        SEARCH_CANARY=inconclusive
        _say "CANARY: inconclusive — could not write a probe file into $_dir."
        return 2
    }

    # Walk `.` from the repo root — the ONE form that goes blind (header limit 3).
    # Using "$_repo" or a subdirectory here would report "clear" on a blind
    # shell; two earlier drafts did exactly that.
    _prev=$(pwd)
    cd "$_repo" || { rm -f "$_file"; SEARCH_CANARY=inconclusive; return 2; }
    # Ground truth: `command grep` bypasses the shell function entirely.
    _truth=$(command grep -rl "$_sent" . 2>/dev/null | wc -l | tr -d ' ')
    # The measurement: what the AMBIENT grep sees walking the same tree.
    _amb=$(grep -rl "$_sent" . 2>/dev/null | wc -l | tr -d ' ')
    cd "$_prev" || :
    rm -f "$_file"

    if [ "$_truth" -eq 0 ]; then
        SEARCH_CANARY=inconclusive
        _say "CANARY: inconclusive — probe unreadable even by 'command grep'."
        return 2
    fi

    if [ "$_amb" -eq 0 ]; then
        SEARCH_CANARY=blind
        _say ""
        _say "  ⚠  SEARCH INSTRUMENT IS BLIND"
        _say ""
        _say "  A known-positive was planted in a gitignored directory, then"
        _say "  searched from the repo root as '.':"
        _say "    command grep -r <s> .  -> found it   ($_truth)"
        _say "    ambient  grep -r <s> . -> MISSED it  ($_amb)"
        _say ""
        _say "  SCOPE — narrow, and worth knowing precisely:"
        _say "    BLIND     grep -r <term> .        (dot-rooted walk)"
        _say "    not blind grep -r <term> <subdir> (named subdirectory)"
        _say "    not blind grep -r <term> /abs/path"
        _say "    not blind grep <term> <file>      (explicit file, even if ignored)"
        _say ""
        _say "  So a zero-hit result from a DOT-ROOTED scan does not mean the"
        _say "  term is absent. This is the form typed most often when verifying"
        _say "  something ad-hoc — which is where the risk actually lives."
        _say ""
        _say "  For any absence-claim, use one of:"
        _say "    command grep -r <term> .   # everything, ignores .gitignore"
        _say "    git grep <term>            # tracked files only, stated honestly"
        _say ""
        return 1
    fi

    SEARCH_CANARY=clear
    _say "CANARY: clear — ambient grep sees gitignored content ($_amb/$_truth)."
    return 0
}

axcion__search_canary "${1:-}"
