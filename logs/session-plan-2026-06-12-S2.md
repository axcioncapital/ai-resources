# Session Plan — 2026-06-12

## Intent
Fix the two PENDING naive-matching false-fires in `check-foreign-staging.sh` — Symptom A (glob footprints matched literally → legit commits false-blocked) via a glob-aware `in_footprint()`, and Symptom B (the gated-verb regex scans the whole command string → heredoc/quoted "git commit" false-triggers) via invocation-anchored verb detection.

## Model
opus — match. The fix *approach* is pre-specified in the improvement-log entry (so this leans "doing"), but the target is the load-bearing commit-staging guard and both defects originate from subtle matching errors; crafting the glob-match and the command-boundary regex correctly is correctness-sensitive enough to keep the higher tier. No `/model` switch.

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` — the target hook (Fix A: `in_footprint()` + token parse; Fix B: gated-verb detection)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — the spec (2026-06-11 entry, line 538: Symptoms A/B, Fix A/B prescriptions) + status flip target
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md` — two-end staging contract (cross-ref; verify no edit needed)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — structural change-class definitions (hook edit → `/risk-check`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — marker/footprint contract the hook reads against

## Findings / Items to Address
1. **Symptom A — glob footprint false-block** (improvement-log.md:544). `in_footprint()` (≈L338–342) matches by literal `path == fp` / `path.startswith(fp + "/")`, so a footprint token with `*`/`**` (e.g. `wiki/**/*.md`, which `/session-start` and `/prime` Step 8c legitimately emit) never matches a real article path → every file in a glob-scoped session is judged foreign and a legit commit is blocked. **Fix A** (improvement-log.md:547): in `in_footprint()`, when a token contains `*`, match with `fnmatch.fnmatch(path, token)` (add `import fnmatch`; collapse `**`→`*` first since fnmatch `*` already crosses `/`); keep the literal `==`/`startswith` arm for non-glob tokens. Inspect the token-parse site (≈L245–251) to confirm glob tokens survive parsing intact.
2. **Symptom B — heredoc/quoted-body false-trigger** (improvement-log.md:545). The gated-verb test `re.search(r'\bgit\s+commit\b', cmd)` (≈L82) scans the entire command string, so `git commit`/`git add` appearing inside a `<<'EOF' … EOF` heredoc body or a quoted string (e.g. a `cat >> log` append describing a commit) is intercepted though no git command runs. **Fix B** (improvement-log.md:548): match a git verb only at a command boundary — start of string or after `;`/`&&`/`||`/`|`/`(`/newline. Interim anchor: `(^|[;&|(]\s*)git\s+(commit|add)\b`; stronger: strip single/double-quoted spans and heredoc bodies before the regex. Choose at implementation per what the surrounding code (≈L82–98) supports cleanly.
3. **Status flip** (improvement-log.md:538, 554). Flip the 2026-06-11 glob/heredoc entry PENDING → RESOLVED once both fixes land + QC GO; line 554 already notes this entry "stays PENDING" so that note also updates.

## Execution Sequence
1. **Inspect.** Read `check-foreign-staging.sh` end-to-end — confirm the language (the spec says `fnmatch`/`import`, implying Python, but the file is `.sh`; resolve the actual interpreter/structure before editing). Locate the real line numbers for `in_footprint()`, the token parse, and the gated-verb test (the L-numbers in the log are approximate). *Verify: actual matcher + verb-detection sites identified; language confirmed.*
2. **Plan-time `/risk-check`.** Hook edit = structural change class → run before any edit. *Verify: verdict GO (or PROCEED-WITH-CAUTION + mitigations). On NO-GO, stop per Stop points.*
3. **Fix A — glob-aware match.** Apply the glob arm in `in_footprint()` (or its shell equivalent), preserving the literal arm for non-glob tokens. *Verify: a `wiki/**/*.md` token matches a real `wiki/foo/bar.md` path; a non-glob token still matches exactly.*
4. **Fix B — anchored verb detection.** Tighten the gated-verb test to command-boundary matching. *Verify: a heredoc body / quoted string containing "git commit" no longer triggers; a real `git commit` at a segment boundary still triggers.*
5. **Self-test the hook.** Exercise both fixes against representative inputs (glob footprint + real path; heredoc with "git commit"; genuine git invocation). *Verify: false-fires gone, true-fires intact.*
6. **End-time `/risk-check` + independent `/qc-pass`.** Both before commit. *Verify: both GO. If the QC subagent is unreachable (1M-credit gate on >200k-token conversation), STOP and defer the commit via `/handoff` (QC-PENDING) — do not self-QC-and-commit.*
7. **Flip status + commit.** Flip the improvement-log entry PENDING → RESOLVED, stage the hook + log, commit directly (no pre-commit checks). *Verify: both files in the commit; entry reads RESOLVED.*

## Scope Alternatives
- **Min:** Fix A only (the glob false-block is the one with a recorded operator-facing incident — a blocked 12-file commit). Defer B.
- **Recommended:** Both A and B in one change set — they share the file, the `/risk-check`, and the QC pass; the mandate scopes both.
- **Max:** A + B + a small inline self-test harness committed alongside (regression fixture for the matcher). Deferred unless QC surfaces a need — the spec does not ask for it.

## Autonomy Posture
Gated — one structural class (PreToolUse hook edit), but scope is bounded to one file + a log flip. The gates are the *automated* `/risk-check` (plan-time + end-time) and independent `/qc-pass`, not operator-decision pauses; execution otherwise runs under full autonomy per workspace rules.

**Stop points:**
- `/risk-check` returns NO-GO → stop, surface, do not edit/commit.
- QC subagent unreachable (1M-credit gate on >200k-token conversation) → defer commit via `/handoff` (QC-PENDING); do not self-QC-and-commit.

## Risk
Run `/risk-check` after this plan is approved (plan-time gate) and again before commit (end-time gate). The edit touches a PreToolUse hook with shared-state (commit-staging) effects — a structural change class per `docs/audit-discipline.md`. A regex/glob error here re-breaks the guard, so the end-time gate is not optional.
