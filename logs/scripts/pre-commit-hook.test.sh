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

echo ""
echo "ALL ARMS PASS (A: bug detectable · B: fix works · C: fail-safe intact)"
exit 0
