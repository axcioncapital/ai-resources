#!/usr/bin/env bash
# check-judgment-seam.sh — the command-path gate on the Unit Judgment Brief seam.
#
# WHAT THIS IS FOR. `docs/judgment-authority-contract.md` says what the artifact
# is and how it is promoted. It deliberately does NOT say which command produces
# it, which reviewer challenges it, or where the route halts for the founder —
# that is wiring, and wiring is what this file checks.
#
# The failure it exists to catch is the one the deep route actually had: the
# command body passes from resolved gaps straight into report-bound analytical
# writing, so no judgment is ever produced, nothing is independently challenged,
# and the founder is never asked. Nothing downstream can detect that, because
# every downstream artifact looks complete either way.
#
# HOW IT AVOIDS BEING A KEYWORD CHECK. Every assertion is derived from the
# STRUCTURE of the live command body — which sub-step a directive sits in, which
# decision branch it sits in, and whether two labelled input lists are disjoint —
# never from the presence of a word the brief already supplied. Two consequences,
# both deliberate:
#
#   - Adding prose that ASSERTS the seam is wired moves nothing. `T0b` proves it.
#   - Moving one real directive between branches flips exactly one assertion.
#     `check-judgment-seam.test.sh` proves that for every assertion, by mutating
#     a copy of the REAL command body rather than a synthetic stand-in.
#
# WHAT IT DOES NOT CHECK. Analytical quality, the content of any produced brief,
# and every downstream owner past the seam (section directives, synthesis, report
# architecture, prose, content QC). Those bind to the approved brief in a later
# unit; this file proves the seam that creates the approved brief exists.
#
# Usage:
#   check-judgment-seam.sh [<path-to-run-analysis.md>] [--format tsv]
#
# Exit: 0 every assertion holds, 1 one or more failed, 2 usage or input error.

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/../../.claude/commands/run-analysis.md"
FORMAT=text

while [ "$#" -gt 0 ]; do
  case "$1" in
    --format) [ "$#" -ge 2 ] || { echo "--format needs a value" >&2; exit 2; }
              FORMAT="$2"; shift 2 ;;
    -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
    -*) echo "unknown option: $1" >&2; exit 2 ;;
    *) SRC="$1"; shift ;;
  esac
done

[ -f "$SRC" ] && [ -r "$SRC" ] || { echo "not a readable file: $SRC" >&2; exit 2; }

# ---------------------------------------------------------------------------
# Block extraction. The seam is a `### Step 3.5:` section; its sub-steps are
# `#### Step 3.5{a..e}:`; the founder decision's branches are top-level bullets
# inside 3.5d. Everything below reads one of those regions, never the whole file,
# so a directive in the wrong region fails the assertion that names the region.
# ---------------------------------------------------------------------------

seam_block() {
  awk '
    /^### Step 3\.5:/ { inb = 1; print; next }
    inb && /^### / { inb = 0 }
    inb { print }
  ' "$SRC"
}

sub_block() {  # $1 = sub-step letter; reads SEAM on stdin
  awk -v pat="^#### Step 3\\.5$1:" '
    $0 ~ pat { inb = 1; print; next }
    inb && /^#### / { inb = 0 }
    inb && /^### / { inb = 0 }
    inb { print }
  '
}

# awk uses POSIX ERE, where `\*` is not a portable escape — bracket the literal
# asterisks instead. Getting this wrong is silent: the pattern never matches, the
# branch reads empty, and every per-branch assertion fails for the wrong reason.
branch_block() {  # $1 = branch name; reads 3.5d block on stdin
  awk -v pat="^- [*][*]$1[*][*]" '
    $0 ~ pat { inb = 1; print; next }
    inb && /^- [*][*]/ { inb = 0 }
    inb && /^#### / { inb = 0 }
    inb { print }
  '
}

# Backticked project-absolute path tokens inside a bullet list.
path_tokens() { grep -o '`/[^`]*`' | tr -d '`' | sort -u; }

# The bullet list introduced by a bold label, up to the next blank-line-separated
# non-bullet. Used to prove the two producer bundles are disjoint.
labelled_list() {  # $1 = the bold label, regex-safe
  awk -v pat="$1" '
    $0 ~ pat { inb = 1; next }
    inb && /^[[:space:]]*-/ { print; next }
    inb && /^[[:space:]]*$/ { next }
    inb { inb = 0 }
  '
}

SEAM="$(seam_block)"
A="$(printf '%s\n' "$SEAM" | sub_block a)"
B="$(printf '%s\n' "$SEAM" | sub_block b)"
C="$(printf '%s\n' "$SEAM" | sub_block c)"
D="$(printf '%s\n' "$SEAM" | sub_block d)"
E="$(printf '%s\n' "$SEAM" | sub_block e)"

BR_APPROVE="$(printf '%s\n' "$D" | branch_block approve)"
BR_REVISE="$(printf '%s\n' "$D" | branch_block revise)"
BR_REJECT="$(printf '%s\n' "$D" | branch_block reject)"
BR_ELSE="$(printf '%s\n' "$D" | branch_block 'anything else')"

results=""
failures=0

record() {  # $1 = id, $2 = PASS|FAIL, $3 = detail
  results="${results}$1	$2	$3
"
  [ "$2" = FAIL ] && failures=$((failures + 1))
  return 0
}

has() { printf '%s\n' "$1" | grep -qE -- "$2"; }

# ---------------------------------------------------------------------------
# J0 — the seam exists at all. Every other assertion is meaningless without it,
# and this is the state the route was in before the seam was wired: gaps resolve
# and the next thing that happens is Step 4.
# ---------------------------------------------------------------------------
if [ -z "$SEAM" ]; then
  record J0-seam-present FAIL "no '### Step 3.5:' section — the route passes from resolved gaps into Step 4 with no judgment produced"
  for id in J1-separated-inputs J2-proposal-validated J3-reviewer-independent \
            J4-byte-binding J5-decision-branches J6-silence-cannot-promote \
            J7-revision-restales J8-approval-mechanical J9-rejection-no-approved \
            J10-authority-gate; do
    record "$id" FAIL "unreachable — the seam section is absent"
  done
else
  record J0-seam-present PASS "seam section found"

  # -------------------------------------------------------------------------
  # J1 — the producer receives two SEPARATE bundles. Proved by disjointness of
  # the two labelled path lists, not by both labels existing: a body that keeps
  # the headings and merges the paths under both fails here.
  # -------------------------------------------------------------------------
  ev="$(printf '%s\n' "$A" | labelled_list '[*][*]Evidence bundle:[*][*]' | path_tokens)"
  cx="$(printf '%s\n' "$A" | labelled_list '[*][*]Axcíon context bundle:[*][*]' | path_tokens)"
  if [ -z "$ev" ] || [ -z "$cx" ]; then
    record J1-separated-inputs FAIL "3.5a must carry two labelled path lists (Evidence bundle / Axcíon context bundle); found evidence=$(printf '%s' "$ev" | grep -c . ) context=$(printf '%s' "$cx" | grep -c . )"
  else
    overlap="$(comm -12 <(printf '%s\n' "$ev") <(printf '%s\n' "$cx") | grep -c .)"
    if [ "$overlap" -ne 0 ]; then
      record J1-separated-inputs FAIL "the two producer bundles share $overlap path(s) — they are not separated inputs"
    else
      record J1-separated-inputs PASS "$(printf '%s\n' "$ev" | grep -c .) evidence paths, $(printf '%s\n' "$cx" | grep -c .) context paths, disjoint"
    fi
  fi

  # -------------------------------------------------------------------------
  # J2 — the proposal is shape-checked before any reviewer is dispatched.
  # -------------------------------------------------------------------------
  if has "$A" 'check-judgment-contract\.sh.*-proposed\.md.*--allow-proposed'; then
    record J2-proposal-validated PASS "3.5a shape-checks the proposal with --allow-proposed"
  else
    record J2-proposal-validated FAIL "3.5a must run check-judgment-contract.sh <proposal> --allow-proposed on one directive line"
  fi

  # -------------------------------------------------------------------------
  # J3 — the reviewer did not write the brief, and does not inherit what the
  # producer said about it. Two conditions: the proposal reaches the reviewer as
  # a PATH it reads itself, and the producer's return is explicitly withheld.
  # -------------------------------------------------------------------------
  j3=""
  has "$B" 'by path|PATH' || j3="${j3}the reviewer must receive the proposal by path; "
  has "$B" '\-proposed\.md' || j3="${j3}the reviewer dispatch must name the proposal file; "
  has "$B" '\*\*Withheld from the reviewer:\*\*' || j3="${j3}3.5b must carry a **Withheld from the reviewer:** directive; "
  has "$B" 'Withheld from the reviewer:.*3\.5a' || j3="${j3}the withholding directive must name what 3.5a returned; "
  if [ -z "$j3" ]; then
    record J3-reviewer-independent PASS "proposal passed by path; 3.5a's return withheld"
  else
    record J3-reviewer-independent FAIL "${j3%; }"
  fi

  # -------------------------------------------------------------------------
  # J4 — the challenge binds to the bytes actually reviewed, and the digest is
  # computed from the file rather than taken from a model's word for it.
  # -------------------------------------------------------------------------
  j4=""
  has "$C" '(shasum -a 256|sha256sum).*-proposed\.md' || j4="${j4}3.5c must compute the digest from the proposal file itself; "
  has "$C" 'reviews_sha256' || j4="${j4}3.5c must write reviews_sha256 into the record; "
  has "$C" '[Nn]ever (copy|take) a digest' || j4="${j4}3.5c must forbid copying a digest from a sub-agent return; "
  if [ -z "$j4" ]; then
    record J4-byte-binding PASS "digest computed from the proposal file and written as reviews_sha256"
  else
    record J4-byte-binding FAIL "${j4%; }"
  fi

  # -------------------------------------------------------------------------
  # J5 — the founder pause is unconditional and its branch set is closed. Exactly
  # four branches: the three decisions, plus the else-branch that catches
  # everything a reply can be that is not one of them.
  # -------------------------------------------------------------------------
  nbranch="$(printf '%s\n' "$D" | grep -cE '^- \*\*(approve|revise|reject|anything else)\*\*')"
  nany="$(printf '%s\n' "$D" | grep -cE '^- \*\*[^*]+\*\*')"
  j5=""
  [ "$nbranch" -eq 4 ] || j5="${j5}expected the four branches approve/revise/reject/anything else, found $nbranch; "
  [ "$nany" -eq "$nbranch" ] || j5="${j5}$((nany - nbranch)) branch(es) outside the closed set; "
  has "$D" 'unconditional' || j5="${j5}the halt must be stated unconditional; "
  has "$D" 'no auto-approve' || j5="${j5}the halt must refuse auto-approval; "
  if [ -z "$j5" ]; then
    record J5-decision-branches PASS "four closed branches, halt stated unconditional"
  else
    record J5-decision-branches FAIL "${j5%; }"
  fi

  # -------------------------------------------------------------------------
  # J6 — silence, a question or a partial reply cannot promote. Proved by the
  # else-branch carrying no promoter call, not by a sentence saying it does not.
  # -------------------------------------------------------------------------
  j6=""
  [ -n "$BR_ELSE" ] || j6="${j6}no 'anything else' branch; "
  has "$BR_ELSE" 'promote-judgment-brief\.sh' && j6="${j6}the else-branch invokes the promoter; "
  has "$BR_ELSE" 'not a decision' || j6="${j6}the else-branch must state that the reply is not a decision; "
  if [ -z "$j6" ]; then
    record J6-silence-cannot-promote PASS "else-branch present and promotes nothing"
  else
    record J6-silence-cannot-promote FAIL "${j6%; }"
  fi

  # -------------------------------------------------------------------------
  # J7 — a revision sends the unit back through production AND re-review. The
  # digest binding makes the old clearance stale mechanically; the branch has to
  # actually route back, or the route stalls on a record nothing will refresh.
  # -------------------------------------------------------------------------
  j7=""
  has "$BR_REVISE" '3\.5a' || j7="${j7}the revise branch must return to 3.5a; "
  has "$BR_REVISE" '3\.5b' || j7="${j7}the revise branch must re-run the challenge at 3.5b; "
  has "$BR_REVISE" 'round' || j7="${j7}the revise branch must require a new review round; "
  has "$BR_REVISE" 'promote-judgment-brief\.sh' && j7="${j7}the revise branch invokes the promoter; "
  if [ -z "$j7" ]; then
    record J7-revision-restales PASS "revise routes 3.5a -> 3.5b as a new round, promotes nothing"
  else
    record J7-revision-restales FAIL "${j7%; }"
  fi

  # -------------------------------------------------------------------------
  # J8 — approval is the mechanical transition with a real approver, and the
  # approved file is never authored by hand.
  # -------------------------------------------------------------------------
  j8=""
  has "$BR_APPROVE" 'promote-judgment-brief\.sh' || j8="${j8}the approve branch must invoke the promoter; "
  has "$BR_APPROVE" '\-\-approval' || j8="${j8}the promoter call must carry --approval; "
  has "$BR_APPROVE" '\-\-approved-by' || j8="${j8}the promoter call must carry --approved-by; "
  has "$BR_APPROVE" 'by hand' || j8="${j8}the approve branch must forbid authoring the approved file by hand; "
  if [ -z "$j8" ]; then
    record J8-approval-mechanical PASS "promoter invoked with both --approval and --approved-by"
  else
    record J8-approval-mechanical FAIL "${j8%; }"
  fi

  # -------------------------------------------------------------------------
  # J9 — a rejection is durable and creates nothing downstream can rely on.
  # -------------------------------------------------------------------------
  j9=""
  has "$BR_REJECT" 'status: rejected' || j9="${j9}the reject branch must set status: rejected; "
  has "$BR_REJECT" 'rejected_by' || j9="${j9}the reject branch must set rejected_by; "
  has "$BR_REJECT" 'promote-judgment-brief\.sh' && j9="${j9}the reject branch invokes the promoter; "
  has "$BR_REJECT" '\-approved\.md' && j9="${j9}the reject branch names an approved artifact; "
  if [ -z "$j9" ]; then
    record J9-rejection-no-approved PASS "reject is durable and creates no approved path"
  else
    record J9-rejection-no-approved FAIL "${j9%; }"
  fi

  # -------------------------------------------------------------------------
  # J10 — nothing downstream of the seam runs on anything but a validated
  # approved brief, and the gate sits before Step 4 in file order.
  # -------------------------------------------------------------------------
  j10=""
  has "$E" 'check-judgment-contract\.sh.*-approved\.md' || j10="${j10}3.5e must validate the approved brief; "
  has "$E" 'check-judgment-contract\.sh.*-approved\.md.*--allow-proposed' && j10="${j10}the gate must not accept a proposal; "
  has "$E" 'Exit 0' || j10="${j10}the gate must branch on exit 0; "
  seam_ln="$(grep -nE '^### Step 3\.5:' "$SRC" | head -1 | cut -d: -f1)"
  step4_ln="$(grep -nE '^### Step 4:' "$SRC" | head -1 | cut -d: -f1)"
  if [ -z "$seam_ln" ] || [ -z "$step4_ln" ] || [ "$seam_ln" -ge "$step4_ln" ]; then
    j10="${j10}the seam must sit before Step 4 in the command body; "
  fi
  if [ -z "$j10" ]; then
    record J10-authority-gate PASS "approved-only gate at 3.5e, before Step 4 (line $seam_ln < $step4_ln)"
  else
    record J10-authority-gate FAIL "${j10%; }"
  fi
fi

if [ "$FORMAT" = tsv ]; then
  printf '%s' "$results"
else
  printf 'judgment seam — %s\n\n' "$SRC"
  printf '%s' "$results" | while IFS=$'\t' read -r id verdict detail; do
    printf '  %-26s %-4s %s\n' "$id" "$verdict" "$detail"
  done
  printf '\n'
  if [ "$failures" -eq 0 ]; then
    printf 'SEAM WIRED — all assertions hold.\n'
  else
    printf 'SEAM NOT WIRED — %d assertion(s) failed.\n' "$failures"
  fi
fi

[ "$failures" -eq 0 ] || exit 1
exit 0
