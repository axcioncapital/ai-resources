#!/bin/bash
# Regression suite for .claude/hooks/pre-commit.
#
# Guards two defects, both of which shipped past a static review once:
#
#   1. PATH RESOLUTION. The hook is installed at .git/hooks/pre-commit, where its
#      companion check-skill-size.sh is NOT a sibling. A $(dirname "$0") lookup
#      resolves to .git/hooks/ and the check silently no-ops while the hook still
#      prints "All skill checks passed." A "does the commit succeed?" test passes
#      either way — useless. ARM A/B below actually detect it.
#
#   2. FAIL-SAFE UNDER `set -e`. The hook runs with `set -e`. A bare assignment
#      takes the exit status of its command substitution, so a failing
#      `git rev-parse` aborts the hook and BLOCKS THE COMMIT — before any -n guard
#      can run. The `|| true` on that assignment is load-bearing. ARM C guards it.
#
# The suite never touches the real repo index: it builds a throwaway git repo in
# $TMPDIR and removes it on exit.
#
# Run: bash logs/scripts/pre-commit-hook.test.sh

SCRATCH="$(mktemp -d "${TMPDIR:-/tmp}/pre-commit-hook-test.XXXXXX")"
trap 'rm -rf "$SCRATCH"' EXIT

# Resolve ai-resources from this script's own location (logs/scripts/ -> root)
# rather than a hardcoded absolute path, so the suite is machine-portable.
AIR="$(cd "$(dirname "$0")/../.." && pwd)"
HOOK="$AIR/.claude/hooks/pre-commit"

fail() { echo ">>> FAIL: $1"; exit 1; }

mkdir -p "$SCRATCH/.claude/hooks"
cd "$SCRATCH" || exit 1
git init -q .
git config user.email t@t.t
git config user.name t

# Real helper, real layout: helper in .claude/hooks/, hook installed to .git/hooks/
cp "$AIR/.claude/hooks/check-skill-size.sh" .claude/hooks/
chmod +x .claude/hooks/check-skill-size.sh

# A VALID SKILL.md (clears the hook's blocking checks 1-6) that is ALSO over the
# 300-line threshold — so execution reaches the informational size check.
mkdir -p skills/bigskill
python3 - <<'PY'
fm = "---\nname: bigskill\ndescription: A deliberately oversized skill fixture.\n---\n\n# Big\n"
open('skills/bigskill/SKILL.md', 'w').write(fm + 'line\n' * 350)
PY
git add skills/bigskill/SKILL.md
LINES=$(wc -l < skills/bigskill/SKILL.md | tr -d ' ')
echo "fixture: skills/bigskill/SKILL.md — ${LINES} lines (threshold 300), valid frontmatter"

# The hook echoes `wc -l` verbatim, which BSD pads with spaces ("is      356 lines").
# Tolerate arbitrary whitespace or the assertion silently fails on a WORKING fix —
# exactly the false-negative this suite exists to prevent.
MARKER="INFO:.*SKILL\.md is[[:space:]]+${LINES} lines"

# ---------------------------------------------------------------------------
echo ""
echo "########## ARM A — CONTROL: buggy \$(dirname \$0) lookup must NOT warn ##########"
# Reconstruct the old buggy resolution. Match the rev-parse assignment by pattern
# (not by exact literal) so a benign reword of that line does not silently break
# the reconstruction. If reconstruction fails, ARM A warns and we abort loudly.
sed -E \
  -e 's|^repo_root=.*$|repo_root="$(dirname "$0")"|' \
  -e 's|^size_check=.*$|size_check="${repo_root}/check-skill-size.sh"|' \
  "$HOOK" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
grep -q 'dirname "\$0"' .git/hooks/pre-commit \
  || fail "ARM A could not reconstruct the buggy hook — sed patterns no longer match $HOOK. Suite is blind; fix it."

OUT_A="$(bash .git/hooks/pre-commit 2>&1)"; RC_A=$?
if echo "$OUT_A" | grep -qE "$MARKER"; then
  fail "ARM A warned — the suite CANNOT detect the path bug (not sensitive). Do not trust ARM B."
fi
[ "$RC_A" -eq 0 ] || fail "ARM A exited $RC_A — the buggy hook should still exit 0 (it no-ops silently)."
echo ">>> ARM A pass: no warn, exit 0 — bug reproduced, suite is sensitive."

# ---------------------------------------------------------------------------
echo ""
echo "########## ARM B — SUBJECT: real hook must warn AND exit 0 ##########"
cp "$HOOK" .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
OUT_B="$(bash .git/hooks/pre-commit 2>&1)"; RC_B=$?
echo "$OUT_B"
echo "---"
echo "$OUT_B" | grep -qE "$MARKER" \
  || fail "ARM B: check-skill-size.sh was NOT reached from .git/hooks/ — the path fix is broken."
# Exit code is the hook's single most important property: a size WARN must never
# block a commit. Asserting only on the warning string would green-light a hook
# that warns and THEN exits non-zero.
[ "$RC_B" -eq 0 ] \
  || fail "ARM B: hook printed the warning but exited $RC_B — an informational check MUST NOT block the commit."
echo ">>> ARM B pass: warn printed, exit 0 — helper genuinely ran from .git/hooks/."

# ---------------------------------------------------------------------------
echo ""
echo "########## ARM C — FAIL-SAFE: repo-root lookup must not abort under set -e ##########"
# The hazard, isolated: under `set -e`, a bare assignment from a failing command
# substitution aborts the script. Prove the hazard is real, prove `|| true` cures
# it, then assert the real hook uses the cured form.
cat > bare.sh <<'EOS'
set -e
v="$(false)"
echo "reached"
EOS
cat > guarded.sh <<'EOS'
set -e
v="$(false || true)"
echo "reached"
EOS
bash bare.sh >/dev/null 2>&1 && fail "ARM C: expected a bare assignment to abort under set -e; it did not. Re-derive this guard."
bash guarded.sh >/dev/null 2>&1 || fail "ARM C: '|| true' did not cure the abort. Re-derive this guard."
echo ">>> ARM C: hazard confirmed real, '|| true' confirmed as the cure."

grep -qE '^repo_root=.*\|\|[[:space:]]*true' "$HOOK" \
  || fail "ARM C: $HOOK resolves repo_root WITHOUT '|| true'. Under set -e a failing git rev-parse (bare repo, GIT_DIR without worktree) will abort the hook and BLOCK EVERY COMMIT."
echo ">>> ARM C pass: hook's repo_root assignment is guarded."

# ---------------------------------------------------------------------------
echo ""
echo "########## ARM D — CONFLICT MARKERS: block real markers, allow look-alikes ##########"
MK="$SCRATCH/markers"
mkdir -p "$MK"
( cd "$MK" && git init -q . && git config user.email t@t.t && git config user.name t )
cp "$HOOK" "$MK/.git/hooks/pre-commit"; chmod +x "$MK/.git/hooks/pre-commit"
cd "$MK" || exit 1
# D1: a real conflict marker at line-start -> hook exit 1.
printf 'ok line\n<<<<<<< HEAD\nmine\n=======\ntheirs\n>>>>>>> branch\n' > file.txt
git add file.txt
bash .git/hooks/pre-commit >/dev/null 2>&1 && fail "ARM D1: real conflict markers were NOT blocked."
echo ">>> ARM D1 pass: real conflict marker -> exit 1."
git rm -q --cached file.txt >/dev/null 2>&1; rm -f file.txt
# D2: a clean staged file -> hook exit 0.
printf 'clean content\nno markers here\n' > clean.txt
git add clean.txt
bash .git/hooks/pre-commit >/dev/null 2>&1 || fail "ARM D2: a clean staged file was WRONGLY blocked."
echo ">>> ARM D2 pass: clean file -> exit 0."
git rm -q --cached clean.txt >/dev/null 2>&1; rm -f clean.txt
# D3: setext heading ('=======' at line start) + a mid-line backticked marker -> exit 0.
# The settled policy excludes '=======' and anchors on line-start, so neither is a false positive.
printf 'Title\n=======\n\nSee the `<<<<<<<` marker syntax mid-line.\n' > doc.md
git add doc.md
bash .git/hooks/pre-commit >/dev/null 2>&1 || fail "ARM D3: setext heading / mid-line marker mention was WRONGLY blocked."
echo ">>> ARM D3 pass: '=======' setext + mid-line mention -> exit 0."
cd "$SCRATCH" || exit 1

# ---------------------------------------------------------------------------
echo ""
echo "########## ARM E — APPEND-ORDER INTEGRATION: hook wires check-append-order.sh ##########"
AO="$SCRATCH/appendorder"
mkdir -p "$AO/logs/scripts"
( cd "$AO" && git init -q . && git config user.email t@t.t && git config user.name t )
cp "$HOOK" "$AO/.git/hooks/pre-commit"; chmod +x "$AO/.git/hooks/pre-commit"
cp "$AIR/logs/scripts/check-append-order.sh" "$AO/logs/scripts/"; chmod +x "$AO/logs/scripts/check-append-order.sh"
cd "$AO" || exit 1
cat > logs/decisions.md <<'EOF'
# Decisions

## 2026-07-10 — Old
body

## 2026-07-20 — Newer
body
EOF
git add logs/decisions.md; git commit -q -m base --no-verify
# E1: prepend a newest entry -> hook blocks (via check-append-order.sh).
python3 - <<'PY'
p='logs/decisions.md'; s=open(p).read()
open(p,'w').write(s.replace("# Decisions\n\n","# Decisions\n\n## 2026-07-25 — Prepended\nbody\n\n",1))
PY
git add logs/decisions.md
bash .git/hooks/pre-commit >/dev/null 2>&1 && fail "ARM E1: hook did not block a prepended decisions.md entry."
echo ">>> ARM E1 pass: hook blocks a prepend through check-append-order.sh."
git checkout -q HEAD -- logs/decisions.md
# E2: clean append -> hook allows.
printf '\n## 2026-07-25 — Appended\nbody\n' >> logs/decisions.md
git add logs/decisions.md
bash .git/hooks/pre-commit >/dev/null 2>&1 || fail "ARM E2: hook WRONGLY blocked a clean append."
echo ">>> ARM E2 pass: hook allows a clean append."
git checkout -q HEAD -- logs/decisions.md
cd "$SCRATCH" || exit 1

# ---------------------------------------------------------------------------
echo ""
echo "########## ARM F — END-TO-END: a real 'git commit' of a prepend is refused ##########"
cd "$AO" || exit 1
git config core.hooksPath "$AO/.git/hooks"
python3 - <<'PY'
p='logs/decisions.md'; s=open(p).read()
open(p,'w').write(s.replace("# Decisions\n\n","# Decisions\n\n## 2026-07-25 — Prepended E2E\nbody\n\n",1))
PY
git add logs/decisions.md
git commit -q -m "should be blocked" 2>/dev/null && fail "ARM F: a real 'git commit' of a prepend SUCCEEDED (must be blocked)."
echo ">>> ARM F pass: end-to-end, 'git commit' is refused by the installed hook."
git checkout -q HEAD -- logs/decisions.md
cd "$SCRATCH" || exit 1

echo ""
echo "ALL ARMS PASS (A: path-bug detectable · B: size fix works · C: fail-safe intact · D: markers · E: append-order wired · F: end-to-end commit blocked)"
exit 0
