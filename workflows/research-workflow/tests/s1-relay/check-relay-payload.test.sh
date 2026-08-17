#!/usr/bin/env bash
# Regression suite for check-relay-payload.sh.
#
# The suite exists to answer one question the S1 brief puts sharply: does the check fail because the
# workflow's relay behaviour is what it is, or because something told it to fail? T1/T2 prove the
# machinery scores a compliant surface green and a noncompliant one red. T3 is the falsifiability
# control — prose asserting noncompliance must move nothing. T9 proves the same on the REAL command
# bodies: a single mechanical edit to one live directive flips that seam from violation to compliant.
#
# Usage: bash check-relay-payload.test.sh
# Exit: 0 all pass, 1 any failure.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CHECK="$HERE/check-relay-payload.sh"
WORKFLOW="$(cd "$HERE/../.." && pwd -P)"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/s1-relay-test.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

pass=0; fail=0
ok()   { pass=$((pass + 1)); printf 'PASS  %s\n' "$1"; }
bad()  { fail=$((fail + 1)); printf 'FAIL  %s\n       %s\n' "$1" "${2:-}"; }

# ---------------------------------------------------------------------------
# A synthetic two-seam workflow, in a compliant and a noncompliant variant.
# ---------------------------------------------------------------------------
mk_synthetic() {
  local root="$1" variant="$2"
  mkdir -p "$root/.claude/commands" "$root/fx"
  # a fixture payload of exactly 300 lines
  awk 'BEGIN { for (i = 1; i <= 300; i++) printf "line %04d padding padding padding\n", i }' > "$root/fx/big-draft.md"
  awk 'BEGIN { for (i = 1; i <= 120; i++) printf "line %04d padding padding padding\n", i }' > "$root/fx/refdoc.md"

  if [ "$variant" = compliant ]; then
    cat > "$root/.claude/commands/demo.md" <<'EOF'
### Step 1: Load
1. List the draft files in `/analysis/drafts/` — file paths only, not content.

### Step 2: Delegate
2. Launch a general-purpose sub-agent. Pass it: the skill content and the big draft path `/analysis/drafts/big-draft.md`. Task: draft it. Return: output file path, summary.
   Also pass the **reference doc PATH (subagent reads directly)**: `reference/refdoc.md`.
EOF
  else
    cat > "$root/.claude/commands/demo.md" <<'EOF'
### Step 1: Load
1. Read all draft files from `/analysis/drafts/`.

### Step 2: Delegate
2. Launch a general-purpose sub-agent. Pass it: the skill content and the big draft content. Task: draft it. Return: big draft content, summary.
   Also pass the reference doc as content: `reference/refdoc.md`.
EOF
  fi

  {
    printf '# synthetic manifest\n'
    printf 'seam_id\tclass\tsurface\tstep\tanchor\tpayload_token\tlist_intro\tpayload_glob\treps\tproducer\tconsumer\ton_disk\tisolation\tblast_radius\ttarget\n'
    printf 'S-01\tW4-H3\t.claude/commands/demo.md\t1.1\t^1\\. (Read all|List the) draft\tdraft file\t-\tbig-draft.md\t1\tdisk\tmain\tyes\toperand-path-ok\tsynthetic\tpath\n'
    printf 'S-02\tW4-H1\t.claude/commands/demo.md\t2.2\tLaunch a general-purpose sub-agent\tbig draft\t-\tbig-draft.md\t1\tsubagent\tmain\tno\toperand-path-ok\tsynthetic\tpath+capped-summary\n'
    printf 'S-03\tW4-H4\t.claude/commands/demo.md\t2.2b\tAlso pass the\treference doc\t-\trefdoc.md\t1\tmain\tsubagent\tyes\treference-path-ok\tsynthetic\tpath\n'
  } > "$root/manifest.tsv"
}

run_synthetic() {  # $1=root ; echoes output, sets RC
  OUT="$("$SHELL_BIN" "$CHECK" --workflow "$1" --manifest "$1/manifest.tsv" --fixture "$1/fx" 2>&1)"
  RC=$?
}
SHELL_BIN=bash

# T1 — a compliant synthetic surface passes.
mk_synthetic "$TMP/good" compliant
run_synthetic "$TMP/good"
if [ "$RC" -eq 0 ] && printf '%s' "$OUT" | grep -q 'verdict: TARGET MET'; then
  ok 'T1 compliant synthetic workflow passes (exit 0, TARGET MET)'
else
  bad 'T1 compliant synthetic workflow should pass' "exit=$RC; $(printf '%s' "$OUT" | tail -18 | tr '\n' '|')"
fi

# T2 — a noncompliant synthetic surface fails, and the reason is a MEASURED content relay.
mk_synthetic "$TMP/bad" noncompliant
run_synthetic "$TMP/bad"
if [ "$RC" -eq 1 ] &&
   printf '%s' "$OUT" | grep -q 'verdict: TARGET NOT MET' &&
   printf '%s' "$OUT" | grep -q 'VIOLATION S-02.*relays .* as CONTENT' &&
   printf '%s' "$OUT" | grep -qE 'Measured [0-9]+ bytes'; then
  ok 'T2 noncompliant synthetic workflow fails on a measured content relay (exit 1)'
else
  bad 'T2 noncompliant synthetic workflow should fail with measured bytes' "exit=$RC"
fi

# T3 — FALSIFIABILITY CONTROL. Adding prose that merely ASSERTS noncompliance, without touching any
# relay directive, must leave the verdict and the violation count untouched. This is the check that a
# marker cannot drive the result.
cp -R "$TMP/good" "$TMP/good-asserted"
cat >> "$TMP/good-asserted/.claude/commands/demo.md" <<'EOF'

> NOTE: this workflow is NONCOMPLIANT with W4-H1..H4. It relays full content through the main
> session and violates the path-passing target. Expected: FAIL.
EOF
run_synthetic "$TMP/good-asserted"
if [ "$RC" -eq 0 ] && printf '%s' "$OUT" | grep -q 'verdict: TARGET MET'; then
  ok 'T3 falsifiability control: prose asserting noncompliance does not change the verdict'
else
  bad 'T3 prose assertion must not change the verdict' "exit=$RC"
fi

# T3b — the converse: editing the DIRECTIVE does change it.
cp -R "$TMP/good" "$TMP/good-broken"
sed -i.bak 's/the big draft path `\/analysis\/drafts\/big-draft.md`/the big draft content/' \
  "$TMP/good-broken/.claude/commands/demo.md"
rm -f "$TMP/good-broken/.claude/commands/demo.md.bak"
run_synthetic "$TMP/good-broken"
if [ "$RC" -eq 1 ] && printf '%s' "$OUT" | grep -q 'VIOLATION S-02'; then
  ok 'T3b editing one relay directive flips that seam to a violation'
else
  bad 'T3b directive edit should produce a violation' "exit=$RC"
fi

# T4 — a stale anchor is reported UNRESOLVED, never silently passed.
cp -R "$TMP/good" "$TMP/stale"
sed -i.bak 's/^2\. Launch a general-purpose sub-agent/2. Dispatch a worker/' \
  "$TMP/stale/.claude/commands/demo.md"
rm -f "$TMP/stale/.claude/commands/demo.md.bak"
run_synthetic "$TMP/stale"
if [ "$RC" -eq 1 ] &&
   printf '%s' "$OUT" | grep -q 'UNRESOLVED S-02 — anchor matches no line' &&
   printf '%s' "$OUT" | grep -qE 'unresolved \(uncovered\)  : [1-9]'; then
  ok 'T4 a stale anchor is reported UNRESOLVED and fails the run'
else
  bad 'T4 stale anchor should be UNRESOLVED' "exit=$RC"
fi

# T5 — the 20-line / 4 KB summary cap is enforced on a capped-summary target.
run_synthetic "$TMP/bad"
if printf '%s' "$OUT" | grep -q 'CAP S-02 — the relayed payload exceeds the summary cap' &&
   printf '%s' "$OUT" | grep -qE 'cap violations          : [1-9]'; then
  ok 'T5 capped-summary ceiling is enforced and counted'
else
  bad 'T5 cap violation should be reported for the oversized return'
fi
# and a generous cap removes exactly that finding, nothing else
OUT="$(bash "$CHECK" --workflow "$TMP/bad" --manifest "$TMP/bad/manifest.tsv" --fixture "$TMP/bad/fx" \
        --cap-lines 100000 --cap-bytes 100000000 2>&1)"
if printf '%s' "$OUT" | grep -qE 'cap violations          : 0'; then
  ok 'T5b raising the cap removes the cap finding (the cap is measured, not asserted)'
else
  bad 'T5b a generous cap should clear the cap finding'
fi

# T5c — AMBIGUITY CONTROL. Unit 12 settled the last `ambiguous` manifest row, so the real workflow no
# longer exercises that branch at all. Without a synthetic row the control would sit unproven and
# could rot silently — and an ambiguity finding that can no longer fire is exactly the failure the
# `ambiguous` classification exists to prevent. This asserts on the synthetic surface instead, in
# both directions: an ambiguous isolation reports and counts, and settling it clears the finding and
# nothing else.
cp -R "$TMP/bad" "$TMP/amb"
# awk, not sed: BSD sed does not expand \t in the pattern, and these are tab-separated fields.
awk -F'\t' -v OFS='\t' '$1 == "S-02" { $13 = "ambiguous" } { print }' \
  "$TMP/bad/manifest.tsv" > "$TMP/amb/manifest.tsv"
amb_count() { printf '%s' "$1" | sed -n 's/^  ambiguous (unsettled) *: //p'; }
viol_count() { printf '%s' "$1" | sed -n 's/^  measured violations *: //p'; }
run_synthetic "$TMP/amb"; amb_out="$OUT"
run_synthetic "$TMP/bad"; set_out="$OUT"
if printf '%s' "$amb_out" | grep -q 'AMBIGUOUS S-02 — the isolation contract does not settle' &&
   [ "$(amb_count "$amb_out")" -ge 1 ] 2>/dev/null; then
  ok "T5c an ambiguous isolation contract is reported and counted ($(amb_count "$amb_out"))"
else
  bad 'T5c an ambiguous isolation should be reported and counted' \
      "ambiguous=$(amb_count "$amb_out")"
fi
if [ "$(amb_count "$set_out")" = '0' ] &&
   ! printf '%s' "$set_out" | grep -q 'AMBIGUOUS S-02' &&
   [ -n "$(viol_count "$set_out")" ] &&
   [ "$(viol_count "$set_out")" = "$(viol_count "$amb_out")" ]; then
  ok 'T5d settling that isolation clears the ambiguity finding and moves nothing else'
else
  bad 'T5d settling an isolation should clear only the ambiguity finding' \
      "ambiguous=$(amb_count "$set_out") viol=$(viol_count "$set_out") vs $(viol_count "$amb_out")"
fi

# T6 — the REAL workflow is the expected red baseline: resolvable everywhere, violations measured.
OUT="$(bash "$CHECK" --workflow "$WORKFLOW" 2>&1)"; RC=$?
real_viol="$(printf '%s' "$OUT" | sed -n 's/^  measured violations     : //p')"
real_unres="$(printf '%s' "$OUT" | sed -n 's/^  unresolved (uncovered)  : //p')"
if [ "$RC" -eq 1 ] && [ "${real_viol:-0}" -gt 0 ]; then
  ok "T6 unmodified production workflow exits nonzero with $real_viol measured violations"
else
  bad 'T6 the real workflow should exit nonzero with measured violations' "exit=$RC viol=${real_viol:-?}"
fi
if [ "${real_unres:-1}" -eq 0 ]; then
  ok 'T6b every manifest row resolves against the real workflow (0 uncovered)'
else
  bad 'T6b no manifest row may be unresolved against the real workflow' "unresolved=${real_unres:-?}"
fi

# T7 — the fixture is byte-stable, so reduction percentages stay comparable between runs.
a="$(find "$HERE/fixture" -type f -exec cat {} + | wc -c | tr -d ' ')"
bash "$HERE/make-fixture.sh" --out "$TMP/fx-regen" >/dev/null 2>&1
b="$(find "$TMP/fx-regen" -type f -exec cat {} + | wc -c | tr -d ' ')"
if [ "$a" = "$b" ] && [ "${a:-0}" -gt 0 ]; then
  ok "T7 fixture regenerates byte-identical ($a bytes)"
else
  bad 'T7 fixture must regenerate byte-identical' "committed=$a regenerated=$b"
fi

# T8 — manifest coverage: all four audit classes, and every audit-named surface carries a row.
man="$HERE/seam-manifest.tsv"
miss=''
for c in W4-H1 W4-H2 W4-H3 W4-H4; do
  awk -F'\t' -v c="$c" '$1 !~ /^#/ && $1 != "seam_id" && $2 == c { n++ } END { exit !(n > 0) }' "$man" ||
    miss="$miss $c"
done
[ -z "$miss" ] && ok 'T8 all four W4 finding classes are represented' \
                || bad 'T8 a W4 class has no manifest row' "missing:$miss"

miss=''
for s in run-report run-analysis run-synthesis run-execution run-cluster produce-architecture \
         verify-chapter execution-agent; do
  grep -q "/$s\.md" "$man" || miss="$miss $s"
done
[ -z "$miss" ] && ok 'T8b every audit-named surface maps to at least one manifest row' \
                || bad 'T8b an audit-named surface has no manifest row' "missing:$miss"

# T9 — LIVE-SURFACE liveness. One mechanical edit per class, on a COPY of the real workflow, must
# move that seam's state. Without this, a check that can never move on the real bodies would look
# identical to one that measures them.
#
# The direction depends on where the refactor has reached, and BOTH directions prove the same
# property — the verdict is derived from the live directive text:
#   - a seam still relaying content is edited toward a path and must go VIOLATION -> COMPLIANT;
#   - a seam already converted is edited back toward content and must go COMPLIANT -> VIOLATION.
# A converted seam cannot prove liveness in the first direction (it has no violation left to clear),
# so pinning it there would turn a real conversion into a test failure and invite weakening the
# check to make it pass. H4-01 and H4-02 moved to the second direction when Unit 2 converted the
# W4-H4 reference-document relays; their old sed expressions targeted the pre-conversion wording
# (`^2. Read the project reference docs ...` and `Pass each sub-agent as content:`) and no longer
# describe the live surface. H3-17 moved the same way when Unit 5 converted `run-execution` 2.3.1:
# its old expression targeted `^1. Read all raw reports from ...`, which the conversion removed. The
# replacements still flip on relay SHAPE, never on approved wording. H1-01 moved the same way when
# Unit 10 converted `run-report` 4.2a: its old expression targeted `Return: chapter draft content,
# scarcity`, which the conversion removed.
cp -R "$WORKFLOW/.claude" "$TMP/live-claude"
mkdir -p "$TMP/live"; mv "$TMP/live-claude" "$TMP/live/.claude"

flip_dir() {  # $1=seam_id $2=file $3=sed expr $4=label $5=expected-before $6=expected-after
  local root="$TMP/flip-$1"
  rm -rf "$root"; mkdir -p "$root"; cp -R "$TMP/live/.claude" "$root/.claude"
  sed -i.bak "$3" "$root/$2"; rm -f "$root/$2.bak"
  local before after
  before="$(bash "$CHECK" --workflow "$TMP/live" --format tsv 2>&1 | awk -F'\t' -v s="$1" '$1 == s { print $6 }')"
  after="$(bash "$CHECK" --workflow "$root" --format tsv 2>&1 | awk -F'\t' -v s="$1" '$1 == s { print $6 }')"
  if [ "$before" = "$5" ] && [ "$after" = "$6" ]; then
    ok "T9 $1 flips $5 -> $6 when $4"
  else
    bad "T9 $1 should flip $5 -> $6 on a real directive edit ($4)" "before=$before after=$after"
  fi
}

# a seam still relaying content: edited toward a path, it must clear
flip()      { flip_dir "$1" "$2" "$3" "$4" VIOLATION COMPLIANT; }
# a seam already converted: edited back toward content, it must break
flip_back() { flip_dir "$1" "$2" "$3" "$4" COMPLIANT VIOLATION; }

flip_back H1-01 .claude/commands/run-report.md \
  's|Return: chapter draft path (the exact output path above) plus a factual handoff|Return: chapter draft content|' \
  'run-report 4.2a returns the full draft again instead of its path'

flip_back H1-02 .claude/commands/run-report.md \
  's|the chapter draft from step (a) by PATH `/report/chapters/{section}/{section}-chapter-NN-draft.md`|the chapter draft from step (a) as content|' \
  'run-report 4.2b takes the full draft back into the relay'

flip_back H1-03 .claude/commands/run-report.md \
  's|the chapter draft by PATH `/report/chapters/{section}/{section}-chapter-NN-draft.md`|the chapter draft as content|' \
  'run-report 4.2c takes the full draft back into the relay'

# T9c — the two 4.2 draft relays must be INDEPENDENTLY live. Unit 12 converted them together, and a
# single edit that moved both would look identical to two working conversions. Each flip above is
# built on its own copy, so this control asserts the other seam — and the two settled content
# exemptions, plus H2-03 and H2-05 — did not move with it.
for pair in 'H1-02 H1-03' 'H1-03 H1-02'; do
  set -- $pair
  moved=''
  for other in "$2" H3-04 H3-09 H2-04 H2-03 H2-05; do
    b="$(bash "$CHECK" --workflow "$TMP/live" --format tsv 2>&1 | awk -F'\t' -v s="$other" '$1 == s { print $6 }')"
    a="$(bash "$CHECK" --workflow "$TMP/flip-$1" --format tsv 2>&1 | awk -F'\t' -v s="$other" '$1 == s { print $6 }')"
    [ -n "$b" ] && [ "$b" = "$a" ] || moved="$moved $other($b->$a)"
  done
  [ -z "$moved" ] && ok "T9c reverting $1 alone moves no other seam" \
                  || bad "T9c reverting $1 moved an unrelated seam" "$moved"
done

flip_back H2-05 .claude/commands/verify-chapter.md \
  's|the chapter prose by PATH|the chapter prose as content|' \
  'verify-chapter 3.7a hands the fixer the whole chapter body again'

# T9d — the same independence control as T9c, for the one seam this file's OTHER two rows sit beside.
# verify-chapter carries H2-03 (still a measured violation) and H2-04 (a settled content exemption)
# in the same file as H2-05, so an edit that degraded the file wholesale would pass T9 by accident.
moved=''
for other in H2-03 H2-04 H3-04 H3-09 H1-02 H1-03; do
  b="$(bash "$CHECK" --workflow "$TMP/live" --format tsv 2>&1 | awk -F'\t' -v s="$other" '$1 == s { print $6 }')"
  a="$(bash "$CHECK" --workflow "$TMP/flip-H2-05" --format tsv 2>&1 | awk -F'\t' -v s="$other" '$1 == s { print $6 }')"
  [ -n "$b" ] && [ "$b" = "$a" ] || moved="$moved $other($b->$a)"
done
[ -z "$moved" ] && ok 'T9d reverting H2-05 alone moves no other seam, including its two file-mates' \
                || bad 'T9d reverting H2-05 moved an unrelated seam' "$moved"

flip_back H4-01 .claude/commands/run-cluster.md \
  's|^2\. Identify the project reference docs the two skills consume by PATH|2. Read the project reference docs the two skills consume as content|' \
  'run-cluster 2.2 reads the reference docs back into the main session'

flip_back H4-02 .claude/commands/run-cluster.md \
  's|, by PATH (the sub-agent reads each directly):|, as content:|' \
  "run-cluster's relay list hands the reference docs over as content"

flip_back H3-17 .claude/commands/run-execution.md \
  's|^1\. Resolve all raw reports from `/execution/raw-reports/` to project-root-relative paths only.*|1. Read all raw reports from `/execution/raw-reports/`.|' \
  'run-execution 2.3.1 reads the raw reports back into the main session'

# T9b — isolation control: flipping run-cluster's relay list must not move a seam in another file.
# Without this, a check that simply degraded everywhere on any edit would pass T9 by accident.
ctl_root="$TMP/flip-H4-02"
before_ctl="$(bash "$CHECK" --workflow "$TMP/live" --format tsv 2>&1 | awk -F'\t' '$1 == "H3-01" { print $6 }')"
after_ctl="$(bash "$CHECK" --workflow "$ctl_root" --format tsv 2>&1 | awk -F'\t' '$1 == "H3-01" { print $6 }')"
if [ -n "$before_ctl" ] && [ "$before_ctl" = "$after_ctl" ]; then
  ok "T9b isolation control: an unrelated seam is unmoved by the run-cluster edit ($before_ctl)"
else
  bad 'T9b an unrelated seam must not move' "before=$before_ctl after=$after_ctl"
fi

printf '\n%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ] || exit 1
