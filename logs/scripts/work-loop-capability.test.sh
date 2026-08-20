#!/bin/bash
# Focused harness for Tracer bullet 5 — deployment is complete or visibly
# unavailable.
#
# TWO THINGS ARE PROVED HERE, and they are deliberately different in kind:
#
#   Part A  the SHARED RULE — work-loop-capability.sh itself, against one
#           complete deployment fixture and the six fixtures derived from it by
#           removing exactly one component each, plus drift, applicability and
#           read-only cases.
#   Part B  the WIRING — that the Work Loop entry command, the two deployment
#           commands, the generic SessionStart sweep and the research workflow
#           template actually carry that rule.
#
# WHY THE FIXTURES ARE DERIVED, NOT WRITTEN. Each one is the complete checkout
# minus a single component. That is what makes the failure attributable:
# if a fixture missing only the Reorient skill reports the compact hook instead,
# the diagnostic is wrong in the one way that matters, because the operator would
# fix the wrong thing. Writing independent fixtures per case would let a shared
# typo hide exactly that.
#
# WHAT PART B CAN AND CANNOT SHOW. It is a mechanical check over instruction
# text and one shell script: it proves the call is present and, for the entry
# command, positioned above the first step that reads task state — not that a
# model obeyed it. Interactive enforcement is instruction-borne, the same
# accepted limitation the ownership helper and the session preflight carry.
# Stated, not covered by a claim to the contrary.
#
# Case 0 is the falsifiability proof: it points Part A at a stub checker that
# always answers READY and asserts the suite notices. A harness that stays green
# with the thing under test replaced by a rubber stamp is not evidence.
#
# Usage:  bash work-loop-capability.test.sh

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# logs/scripts -> logs -> checkout root. Two levels, not one.
REPO_ROOT="${REPO_ROOT:-$(cd "$HERE/../.." && pwd)}"
CAP_BIN="${CAP_BIN:-$HERE/work-loop-capability.sh}"
OWNER_BIN="$HERE/work-loop-owner.sh"
STATE_BIN="$HERE/work-loop-state.sh"
HOOK_SRC="$REPO_ROOT/.codex/hooks/work-loop-reorient.sh"
TEMPLATE_DIR="$REPO_ROOT/workflows/research-workflow"

PASS=0; FAIL=0
SANDBOX_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/wl2-capability-test.XXXXXX")"
trap 'rm -rf "$SANDBOX_ROOT"' EXIT

ok()  { PASS=$((PASS+1)); printf '  PASS  %s\n' "$1"; }
bad() { FAIL=$((FAIL+1)); printf '  FAIL  %s\n' "$1"; [ -n "${2:-}" ] && printf '        %s\n' "$2"; }

expect_rc() { # want got label output
  [ "$1" = "$2" ] && ok "$3" || bad "$3" "expected exit $1, got $2 — $4"
}

expect_grep() { # pattern output label
  printf '%s' "$2" | grep -qE "$1" && ok "$3" || bad "$3" "no match for /$1/ in: $2"
}

expect_no_grep() { # pattern output label
  printf '%s' "$2" | grep -qE "$1" && bad "$3" "unwanted match for /$1/ in: $2" || ok "$3"
}

# ------------------------------------------------------------------ fixtures

# The Work Loop skill body plus the direct references it links. Written here
# rather than copied from the real skill on purpose: the component under test is
# the RULE "every reference the body links is present", and a fixture that
# borrowed the real body would drift with it and would stop being a fixture the
# day the reference set changed. Two references, so a case that removes one can
# show the other is untouched.
install_work_loop_skill() { # dir
  mkdir -p "$1/.agents/skills/work-loop-v2/references"
  cat >"$1/.agents/skills/work-loop-v2/SKILL.md" <<'EOF'
---
name: "work-loop-v2"
---

# work-loop-v2 — fixture body

| Reference | Read it when |
|---|---|
| [Core resolution](references/core-resolution.md) | when the Work Loop owns the move |
| [Unit framing](references/unit-framing.md) | when preparing a unit |
EOF
  printf '# Core resolution\n'  >"$1/.agents/skills/work-loop-v2/references/core-resolution.md"
  printf '# Unit framing\n'     >"$1/.agents/skills/work-loop-v2/references/unit-framing.md"
}

# A checkout carrying all six components and the command that makes them
# applicable. Everything else is derived from this by removing one thing.
complete_checkout() { # -> path
  local d; d="$(mktemp -d "$SANDBOX_ROOT/co.XXXXXX")"
  mkdir -p "$d/.claude/commands" "$d/logs/scripts" "$d/logs/work-loop" \
           "$d/.agents/skills/reorient" "$d/.codex/hooks" \
           "$d/.agents/skills/work-loop-v2/references"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name harness

  printf 'Run Claude half of one Work Loop v2 unit.\n' >"$d/.claude/commands/work-loop-v2.md"
  cp "$STATE_BIN" "$d/logs/scripts/work-loop-state.sh"
  cp "$OWNER_BIN" "$d/logs/scripts/work-loop-owner.sh"
  printf -- '---\nname: reorient\n---\n\n# Reorient\n' >"$d/.agents/skills/reorient/SKILL.md"
  install_work_loop_skill "$d"
  cp "$HOOK_SRC" "$d/.codex/hooks/work-loop-reorient.sh"
  cat >"$d/.codex/hooks.json" <<'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          {
            "type": "command",
            "command": "bash '.codex/hooks/work-loop-reorient.sh'",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
EOF
  printf '.DS_Store\nlogs/work-loop/.owner\n' >"$d/.gitignore"
  git -C "$d" add -A >/dev/null 2>&1
  git -C "$d" commit -qm "complete fixture" >/dev/null 2>&1
  printf '%s' "$d"
}

run_check() { # checkout [canonical]
  if [ -n "${2:-}" ]; then
    bash "$CAP_BIN" check --checkout "$1" --canonical "$2" 2>&1
  else
    bash "$CAP_BIN" check --checkout "$1" 2>&1
  fi
}

# ============================================================================
printf '\n--- Part A: the rule -------------------------------------------------\n'
# ============================================================================

# --- A1 the complete fixture passes -----------------------------------------
CO="$(complete_checkout)"
OUT="$(run_check "$CO")"; RC=$?
expect_rc 0 "$RC" "A1    the complete deployment fixture is READY" "$OUT"
expect_grep '^verdict: READY' "$OUT" "A1    the verdict line says READY"
expect_no_grep '^(missing|drifted):' "$OUT" "A1    nothing is reported missing or drifted"

# --- A2..A6 each fixture missing exactly one component ----------------------
# Every case removes one thing from a freshly built complete checkout, so the
# only difference from A1 is the component under test.

remove_and_check() { # label component-name removal-command...
  local label="$1" component="$2"; shift 2
  # Not run in a command substitution: ok/bad must reach the real PASS/FAIL
  # counters, and a subshell would silently discard every count this loop makes.
  local d; d="$(complete_checkout)"
  ( cd "$d" && eval "$@" )
  local out rc count
  out="$(run_check "$d")"; rc=$?
  expect_rc 3 "$rc" "$label INCOMPLETE when $component is missing" "$out"
  expect_grep "^missing: $component" "$out" "$label the diagnostic names $component"
  # Attribution: removing one component must not implicate the other four.
  count=$(printf '%s' "$out" | grep -cE '^(missing|drifted):')
  [ "$count" = 1 ] && ok "$label exactly one component is reported" \
    || bad "$label exactly one component is reported" "got $count lines: $out"
}

remove_and_check 'A2   ' 'state-validator' 'rm logs/scripts/work-loop-state.sh'
remove_and_check 'A3   ' 'owner-helper' 'rm logs/scripts/work-loop-owner.sh'
remove_and_check 'A4   ' 'reorient-skill' 'rm -rf .agents/skills/reorient'
# The reference case is the one the 2026-08-18 correction added. Before it, this
# exact fixture — a checkout whose Work Loop skill directs a move to a file that
# is not there — reported READY and exit 0, so a unit could open in a checkout
# that could not finish it. Removing the file the resolver lives behind is not a
# hypothetical: it is the reproduction the independent review returned.
remove_and_check 'A4b  ' 'work-loop-references' \
  'rm .agents/skills/work-loop-v2/references/core-resolution.md'
# The skill body itself. Without this case the derivation could fail open: no
# body, no links, an empty set, and nothing reported for the checkout least able
# to run a unit.
remove_and_check 'A4c  ' 'work-loop-references' \
  'rm .agents/skills/work-loop-v2/SKILL.md'
remove_and_check 'A5   ' 'compact-recovery-hook' 'rm .codex/hooks/work-loop-reorient.sh'
remove_and_check 'A6   ' 'owner-ignore-rule' "printf '.DS_Store\n' >.gitignore"

# A body that links nothing is the third way the derived set can be empty, and it
# is not the same fault as a missing body: the file is there and says nothing.
CO="$(complete_checkout)"
( cd "$CO" && printf -- '---\nname: "work-loop-v2"\n---\n\n# no references linked\n' \
    >.agents/skills/work-loop-v2/SKILL.md )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 3 "$RC" "A4d   a Work Loop skill body linking no reference is INCOMPLETE" "$OUT"
expect_grep '^missing: work-loop-references' "$OUT" "A4d   the diagnostic names work-loop-references"

# Attribution downward: removing ONE reference must not implicate the other.
CO="$(complete_checkout)"
( cd "$CO" && rm .agents/skills/work-loop-v2/references/unit-framing.md )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 3 "$RC" "A4e   removing one reference is INCOMPLETE" "$OUT"
expect_grep 'unit-framing\.md is absent' "$OUT" "A4e   the diagnostic names the reference that is gone"
expect_no_grep 'core-resolution\.md is absent' "$OUT" "A4e   and does not implicate the one still present"

# --- A7 the hook file without its registration is still missing --------------
# The component is the hook PLUS the wiring that makes it fire. A checkout
# holding an unregistered script is exactly as unrecovered as one holding none,
# and this is the case a presence-only check would wave through.
CO="$(complete_checkout)"
( cd "$CO" && printf '{"hooks":{"SessionStart":[]}}\n' >.codex/hooks.json )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 3 "$RC" "A7    an unregistered compact hook is INCOMPLETE" "$OUT"
expect_grep 'never fires' "$OUT" "A7    the diagnostic says the hook never fires"

# A registration under the wrong matcher does not count either.
CO="$(complete_checkout)"
( cd "$CO" && printf '{"hooks":{"SessionStart":[{"hooks":[{"type":"command","command":"bash .codex/hooks/work-loop-reorient.sh"}]}]}}\n' >.codex/hooks.json )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 3 "$RC" "A7    registration without the compact matcher is INCOMPLETE" "$OUT"

# --- A8 applicability: no command, no capability ----------------------------
CO="$(complete_checkout)"
( cd "$CO" && rm .claude/commands/work-loop-v2.md )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 2 "$RC" "A8    a checkout without the command reports NOT_APPLICABLE" "$OUT"
expect_grep '^verdict: NOT_APPLICABLE' "$OUT" "A8    the verdict line says NOT_APPLICABLE"
expect_no_grep '^missing:' "$OUT" "A8    nothing is reported missing — not applicable is not broken"

# A checkout stripped of everything BUT the command is the opposite case: the
# capability is applicable and entirely absent. Without the applicability rule
# these two would be indistinguishable.
CO="$(complete_checkout)"
( cd "$CO" && rm -f logs/scripts/work-loop-state.sh logs/scripts/work-loop-owner.sh \
    .codex/hooks/work-loop-reorient.sh && rm -rf .agents/skills && printf '\n' >.gitignore )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 3 "$RC" "A8    command-only checkout is INCOMPLETE, not NOT_APPLICABLE" "$OUT"
[ "$(printf '%s' "$OUT" | grep -cE '^missing:')" = 6 ] \
  && ok "A8    all six components are named" \
  || bad "A8    all six components are named" "$OUT"

# The command installed as a SYMLINK exposes Work Loop exactly as a copy does.
CO="$(complete_checkout)"
( cd "$CO" && rm .claude/commands/work-loop-v2.md \
    && printf 'canonical\n' >canonical-work-loop-v2.md \
    && ln -s ../../canonical-work-loop-v2.md .claude/commands/work-loop-v2.md \
    && rm logs/scripts/work-loop-state.sh )
OUT="$(run_check "$CO")"; RC=$?
expect_rc 3 "$RC" "A8    a symlinked command still counts as exposure" "$OUT"

# --- A9 byte identity of the copied components ------------------------------
CANON="$(complete_checkout)"
CO="$(complete_checkout)"
OUT="$(run_check "$CO" "$CANON")"; RC=$?
expect_rc 0 "$RC" "A9    identical copies are READY against a canonical source" "$OUT"
expect_grep 'byte-identical' "$OUT" "A9    the reason records the byte comparison"

( cd "$CO" && printf '\n# local edit\n' >>logs/scripts/work-loop-owner.sh )
OUT="$(run_check "$CO" "$CANON")"; RC=$?
expect_rc 3 "$RC" "A9    a drifted owner-helper copy is INCOMPLETE" "$OUT"
expect_grep '^drifted: owner-helper' "$OUT" "A9    the diagnostic names the drifted component"
# Drift is invisible without a canonical source, and the check says so by not
# inventing one: presence-only is a weaker answer, not a wrong one.
OUT="$(run_check "$CO")"; RC=$?
expect_rc 0 "$RC" "A9    without --canonical the same checkout is READY on presence" "$OUT"

# A reference is present and wrong. Instructions drift more quietly than scripts
# do — a stale reference reads as authoritative and fails nothing — so the
# reference set is compared like the other copied components, not just counted.
CANON="$(complete_checkout)"
CO="$(complete_checkout)"
( cd "$CO" && printf '\n<!-- local edit -->\n' \
    >>.agents/skills/work-loop-v2/references/core-resolution.md )
OUT="$(run_check "$CO" "$CANON")"; RC=$?
expect_rc 3 "$RC" "A9    a drifted reference copy is INCOMPLETE" "$OUT"
expect_grep '^drifted: work-loop-references' "$OUT" "A9    the diagnostic names the drifted reference set"

# --- A10 read-only ----------------------------------------------------------
# A checker that installed or repaired anything would make "is this ready?"
# unanswerable. Proof: a git-clean fixture stays clean, and no untracked file
# appears, across a run that reports five missing components.
CO="$(complete_checkout)"
( cd "$CO" && rm -f logs/scripts/work-loop-state.sh logs/scripts/work-loop-owner.sh \
    .codex/hooks/work-loop-reorient.sh && rm -rf .agents/skills/reorient && printf '\n' >.gitignore \
    && git add -A >/dev/null 2>&1 && git commit -qm "stripped" >/dev/null 2>&1 )
BEFORE="$(cd "$CO" && git status --porcelain; find "$CO" -type f | sort)"
run_check "$CO" >/dev/null 2>&1
AFTER="$(cd "$CO" && git status --porcelain; find "$CO" -type f | sort)"
[ "$BEFORE" = "$AFTER" ] && ok "A10   the check created, edited and deleted nothing" \
  || bad "A10   the check created, edited and deleted nothing" "tree changed"

# --- A11 usage errors -------------------------------------------------------
OUT="$(bash "$CAP_BIN" check --checkout "$SANDBOX_ROOT/does-not-exist" 2>&1)"; RC=$?
expect_rc 10 "$RC" "A11   a non-directory --checkout is BAD_USAGE" "$OUT"
OUT="$(bash "$CAP_BIN" --checkout "$CO" 2>&1)"; RC=$?
expect_rc 10 "$RC" "A11   a missing action is BAD_USAGE" "$OUT"
OUT="$(bash "$CAP_BIN" check --checkout "$CO" --nonsense x 2>&1)"; RC=$?
expect_rc 10 "$RC" "A11   an unknown argument is BAD_USAGE" "$OUT"

# --- Case 0 falsifiability --------------------------------------------------
# Replace the checker with a rubber stamp. Part A must go red.
STUB="$SANDBOX_ROOT/stub-capability.sh"
printf '#!/bin/bash\nprintf "verdict: READY\\n"\nexit 0\n' >"$STUB"
CO="$(complete_checkout)"
( cd "$CO" && rm logs/scripts/work-loop-state.sh )
STUB_OUT="$(bash "$STUB" check --checkout "$CO" 2>&1)"; STUB_RC=$?
if [ "$STUB_RC" = 0 ] && ! printf '%s' "$STUB_OUT" | grep -q '^missing: state-validator'; then
  ok "0     falsifiability: a rubber-stamp checker fails A2's assertions"
else
  bad "0     falsifiability: a rubber-stamp checker fails A2's assertions" \
      "the stub answered rc=$STUB_RC / $STUB_OUT — A2 would not have discriminated"
fi

# ============================================================================
printf '\n--- Part B: the wiring -----------------------------------------------\n'
# ============================================================================

CMD_F="$REPO_ROOT/.claude/commands/work-loop-v2.md"
SYNC_F="$REPO_ROOT/.claude/commands/sync-workflow.md"
DEPLOY_F="$REPO_ROOT/.claude/commands/deploy-workflow.md"
SWEEP_F="$REPO_ROOT/.claude/hooks/auto-sync-shared.sh"

# --- B1 the entry command runs the check, and runs it FIRST -----------------
grep -q 'work-loop-capability.sh' "$CMD_F" \
  && ok "B1    /work-loop-v2 calls work-loop-capability.sh" \
  || bad "B1    /work-loop-v2 calls work-loop-capability.sh"

# Position is the whole point: a readiness check that ran after the state read
# would let a partial checkout begin the unit it is unable to finish.
CAP_LINE=$(grep -n 'work-loop-capability.sh' "$CMD_F" | head -1 | cut -d: -f1)
STATE_LINE=$(grep -n 'work-loop-state.sh validate' "$CMD_F" | head -1 | cut -d: -f1)
OWNER_LINE=$(grep -n 'work-loop-owner.sh check' "$CMD_F" | head -1 | cut -d: -f1)
if [ -n "$CAP_LINE" ] && [ -n "$STATE_LINE" ] && [ "$CAP_LINE" -lt "$STATE_LINE" ]; then
  ok "B1    the readiness check is positioned above the state validation"
else
  bad "B1    the readiness check is positioned above the state validation" \
      "capability at ${CAP_LINE:-none}, validator at ${STATE_LINE:-none}"
fi
if [ -n "$CAP_LINE" ] && [ -n "$OWNER_LINE" ] && [ "$CAP_LINE" -lt "$OWNER_LINE" ]; then
  ok "B1    the readiness check is positioned above the ownership check"
else
  bad "B1    the readiness check is positioned above the ownership check" \
      "capability at ${CAP_LINE:-none}, owner at ${OWNER_LINE:-none}"
fi
grep -qi 'NOT_APPLICABLE' "$CMD_F" \
  && ok "B1    the command distinguishes NOT_APPLICABLE from INCOMPLETE" \
  || bad "B1    the command distinguishes NOT_APPLICABLE from INCOMPLETE"

# --- B1b Step 0 asks for drift, not just presence ---------------------------
# A9 proves the script answers READY on a drifted checkout when --canonical is
# withheld. That is correct script behaviour and a silent hole in the entry
# command, which withheld it: the deployed helper copies are the components most
# able to be present and wrong, and Step 0 is the only gate that sees them before
# a unit opens. The two deployment commands already pass --canonical; the entry
# command did not until 2026-08-16.
grep -q -- '--canonical' "$CMD_F" \
  && ok "B1b   Step 0 passes --canonical, so drift is compared and not assumed" \
  || bad "B1b   Step 0 passes --canonical, so drift is compared and not assumed" \
         "presence-only at Step 0 reports READY on a stale helper copy (see A9)"

# Resolved, never hardcoded. An absolute path baked into the command breaks the
# moment the workspace is moved, cloned or checked out elsewhere — and it would
# break silently, degrading to the presence-only hole this assertion closes.
if grep -q 'ai-resources/.claude/commands' "$CMD_F" && grep -q 'dirname' "$CMD_F"; then
  ok "B1b   Step 0 resolves the canonical source by walking ancestors"
else
  bad "B1b   Step 0 resolves the canonical source by walking ancestors" \
      "expected the same ancestor walk the SessionStart sweep uses"
fi
grep -qE '^\s*CANONICAL="?/Users|^\s*CANONICAL="?/home' "$CMD_F" \
  && bad "B1b   Step 0 does not hardcode an absolute canonical path" \
         "a machine-specific path was found in the Step 0 block" \
  || ok "B1b   Step 0 does not hardcode an absolute canonical path"

# An unresolved canonical must stay visible rather than silently becoming a
# presence-only pass reported as an unqualified READY.
grep -q 'UNRESOLVED' "$CMD_F" \
  && ok "B1b   Step 0 names the unresolved-canonical case instead of hiding it" \
  || bad "B1b   Step 0 names the unresolved-canonical case instead of hiding it"

# --- B2 /sync-workflow checks the capability, not two of its five parts -----
grep -q 'work-loop-capability.sh' "$SYNC_F" \
  && ok "B2    /sync-workflow calls work-loop-capability.sh" \
  || bad "B2    /sync-workflow calls work-loop-capability.sh"
for component in state-validator owner-helper reorient-skill compact-recovery-hook owner-ignore-rule; do
  grep -q "$component" "$SYNC_F" \
    && ok "B2    /sync-workflow's remediation covers $component" \
    || bad "B2    /sync-workflow's remediation covers $component"
done
# Preservation: the ignore rule is still checked as a rule, and project files are
# appended to rather than replaced. Losing this would trade one failure for another.
grep -qi 'check the \*\*rule\*\*, not the file' "$SYNC_F" \
  && ok "B2    /sync-workflow still checks the ignore rule, not the whole file" \
  || bad "B2    /sync-workflow still checks the ignore rule, not the whole file"

# --- B3 /deploy-workflow deploys and validates the capability ---------------
grep -q 'work-loop-capability.sh' "$DEPLOY_F" \
  && ok "B3    /deploy-workflow calls work-loop-capability.sh" \
  || bad "B3    /deploy-workflow calls work-loop-capability.sh"

# --- B4 the generic sweep cannot present a partial capability as ready ------
grep -q 'work-loop-capability.sh' "$SWEEP_F" \
  && ok "B4    auto-sync-shared.sh consults the capability check" \
  || bad "B4    auto-sync-shared.sh consults the capability check"
grep -q 'WORK LOOP INCOMPLETE' "$SWEEP_F" \
  && ok "B4    the sweep emits a distinct incomplete-capability warning" \
  || bad "B4    the sweep emits a distinct incomplete-capability warning"

# The sweep must stay fail-open: a SessionStart hook that blocked a session over
# a deployment gap would be worse than the gap.
grep -q 'exit 0' "$SWEEP_F" \
  && ok "B4    the sweep still exits 0" \
  || bad "B4    the sweep still exits 0"

# --- B5 the research template carries byte-identical copies -----------------
if [ -d "$TEMPLATE_DIR" ]; then
  for pair in "logs/scripts/work-loop-state.sh" "logs/scripts/work-loop-owner.sh" \
              ".codex/hooks/work-loop-reorient.sh"; do
    if [ ! -f "$TEMPLATE_DIR/$pair" ]; then
      bad "B5    the template carries $pair" "absent"
    elif cmp -s "$REPO_ROOT/$pair" "$TEMPLATE_DIR/$pair"; then
      ok "B5    the template's $pair is byte-identical to canonical"
    else
      bad "B5    the template's $pair is byte-identical to canonical" "differs"
    fi
  done
  grep -q 'logs/work-loop/.owner' "$TEMPLATE_DIR/.gitignore" \
    && ok "B5    the template's .gitignore carries the .owner rule" \
    || bad "B5    the template's .gitignore carries the .owner rule"
  if command -v jq >/dev/null 2>&1; then
    jq -e '[.skills.shared[]?] | index("reorient")' "$TEMPLATE_DIR/.claude/shared-manifest.json" >/dev/null 2>&1 \
      && ok "B5    the template's manifest opts into the reorient skill" \
      || bad "B5    the template's manifest opts into the reorient skill"
  fi
  # The template holds the hook FILE; its registration is a deploy-time step,
  # because the command path is only known once the project directory exists.
  # That is why a freshly deployed project is INCOMPLETE until registered — the
  # intended visible-unavailability, not a gap in this harness.
  grep -q 'work-loop-reorient' "$DEPLOY_F" \
    && ok "B5    /deploy-workflow reports the compact-hook registration step" \
    || bad "B5    /deploy-workflow reports the compact-hook registration step"
else
  bad "B5    the research workflow template is present" "$TEMPLATE_DIR not found"
fi

# --- B6 this checkout is itself complete ------------------------------------
# The canonical repository exposes /work-loop-v2, so it must satisfy its own
# contract. A rule its own home fails is not a rule.
OUT="$(run_check "$REPO_ROOT")"; RC=$?
expect_rc 0 "$RC" "B6    the canonical checkout is itself READY" "$OUT"

# --- B7 both commands state the merge-only remedy ---------------------------
# Step 7 of /sync-workflow applies approved changes by overwriting. Three of the
# five remedies must never go through it, and both commands have to say so where
# the remedy is written — a rule stated only in one is a rule one path can miss.
grep -q 'merge-only' "$SYNC_F" \
  && ok "B7    /sync-workflow carves the merge-only files out of Step 7" \
  || bad "B7    /sync-workflow carves the merge-only files out of Step 7"
for f in '.gitignore' 'shared-manifest.json' '.codex/hooks.json'; do
  awk '/^### The three merge-only files/{f=1} f' "$SYNC_F" | grep -q "$f" \
    && ok "B7    the carve-out names $f" \
    || bad "B7    the carve-out names $f"
done
grep -qi 'does not prove\|is therefore not evidence' "$SYNC_F" \
  && ok "B7    /sync-workflow says READY alone is not evidence of preservation" \
  || bad "B7    /sync-workflow says READY alone is not evidence of preservation"
grep -q 'does not prove the two additions above were applied correctly' "$DEPLOY_F" \
  && ok "B7    /deploy-workflow says the same about its two additions" \
  || bad "B7    /deploy-workflow says the same about its two additions"
grep -q 'Do not write the manifest from the template' "$DEPLOY_F" \
  && ok "B7    /deploy-workflow forbids replacing the project manifest" \
  || bad "B7    /deploy-workflow forbids replacing the project manifest"

# ============================================================================
printf '\n--- Part C: the remedies preserve project content ---------------------\n'
# ============================================================================
#
# Two of the five components are added to files the PROJECT owns, and one to its
# .gitignore. Applying those three the way /sync-workflow Step 7 applies
# everything else — copy the canonical file over — reaches the same READY
# verdict while deleting whatever the project had in them.
#
# THAT IS WHY THIS SECTION EXISTS AND WHY IT IS BUILT THIS WAY. Case C7 applies
# the destructive remedy and asserts it ALSO reports READY. So the capability
# check cannot tell the two remediations apart, and an assertion that only
# checked for READY would pass either way — it could not fail. The sentinel
# assertions in C3–C6 are the ones that can, and C7 is what proves they are
# load-bearing rather than decorative.
#
# No dry-run mode is invented here. The remedies are instructions; this applies
# them exactly as Step 4b and the deploy step write them, to a fixture, and
# looks at what is left.

# A project that owns real content in all three merge-only files and has none of
# the six Work Loop components.
project_with_own_content() { # -> path
  local d; d="$(mktemp -d "$SANDBOX_ROOT/proj.XXXXXX")"
  mkdir -p "$d/.claude/commands" "$d/logs/scripts" "$d/logs/work-loop" "$d/.codex/hooks"
  git -C "$d" init -q
  git -C "$d" config user.email harness@example.invalid
  git -C "$d" config user.name harness
  printf 'Run Claude half of one Work Loop v2 unit.\n' >"$d/.claude/commands/work-loop-v2.md"
  printf '# project rules\nexports/scratch/\n*.local.md\n' >"$d/.gitignore"
  cat >"$d/.claude/shared-manifest.json" <<'EOF'
{
  "commands": { "local": ["run-analysis", "verify-chapter"] },
  "agents": { "local": ["qc-gate"] },
  "skills": { "shared": ["project-only-skill"] }
}
EOF
  printf 'echo project own hook\n' >"$d/.codex/hooks/project-own.sh"
  cat >"$d/.codex/hooks.json" <<'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          { "type": "command", "command": "bash .codex/hooks/project-own.sh", "timeout": 5 }
        ]
      }
    ]
  }
}
EOF
  printf '%s' "$d"
}

# The components that ARE plain file copies. Correct for both remediations. The
# two skills arrive by the same manifest-symlink route, so the Work Loop skill
# and its references land here beside Reorient rather than through the merge-only
# path Part C is about.
copy_the_file_components() { # dir
  cp "$TEMPLATE_DIR/logs/scripts/work-loop-state.sh" "$1/logs/scripts/"
  cp "$TEMPLATE_DIR/logs/scripts/work-loop-owner.sh" "$1/logs/scripts/"
  cp "$TEMPLATE_DIR/.codex/hooks/work-loop-reorient.sh" "$1/.codex/hooks/"
  mkdir -p "$1/.agents/skills/reorient"
  printf -- '---\nname: reorient\n---\n' >"$1/.agents/skills/reorient/SKILL.md"
  install_work_loop_skill "$1"
}

# The documented remedy: append the ignore line, add ONE manifest array entry,
# add ONE SessionStart entry. Exactly what Step 4b's table says.
apply_documented_remedy() { # dir
  local d="$1"
  printf '\n# Work Loop v2 per-checkout ownership declaration — must stay checkout-local.\nlogs/work-loop/.owner\n' >>"$d/.gitignore"
  jq '.skills.shared = ((.skills.shared // []) + ["reorient"] | unique)' \
    "$d/.claude/shared-manifest.json" >"$d/.manifest.tmp" && mv "$d/.manifest.tmp" "$d/.claude/shared-manifest.json"
  jq '.hooks.SessionStart += [{
        "matcher": "compact",
        "hooks": [ { "type": "command", "command": "bash .codex/hooks/work-loop-reorient.sh", "timeout": 5 } ]
      }]' "$d/.codex/hooks.json" >"$d/.hooks.tmp" && mv "$d/.hooks.tmp" "$d/.codex/hooks.json"
}

# The Step 7 remedy applied without the carve-out: overwrite all three.
apply_overwrite_remedy() { # dir
  local d="$1"
  cp "$TEMPLATE_DIR/.gitignore" "$d/.gitignore"
  cp "$TEMPLATE_DIR/.claude/shared-manifest.json" "$d/.claude/shared-manifest.json"
  cat >"$d/.codex/hooks.json" <<'EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [
          { "type": "command", "command": "bash .codex/hooks/work-loop-reorient.sh", "timeout": 5 }
        ]
      }
    ]
  }
}
EOF
}

sentinels_present() { # dir -> 0 if all three project-owned sentinels survive
  grep -q 'exports/scratch/' "$1/.gitignore" || return 1
  jq -e '[.commands.local[]?] | index("run-analysis")' "$1/.claude/shared-manifest.json" >/dev/null 2>&1 || return 1
  jq -e '[.skills.shared[]?] | index("project-only-skill")' "$1/.claude/shared-manifest.json" >/dev/null 2>&1 || return 1
  jq -e '[ (.hooks.SessionStart // [])[] | (.hooks // [])[] | (.command // "") | select(test("project-own"))] | length > 0' \
    "$1/.codex/hooks.json" >/dev/null 2>&1 || return 1
  return 0
}

# --- C1 the starting state --------------------------------------------------
BASE="$(project_with_own_content)"
OUT="$(run_check "$BASE")"; RC=$?
expect_rc 3 "$RC" "C1    the fixture starts INCOMPLETE" "$OUT"
[ "$(printf '%s' "$OUT" | grep -cE '^missing:')" = 6 ] \
  && ok "C1    all six components are named as the proposed additions" \
  || bad "C1    all six components are named as the proposed additions" "$OUT"
sentinels_present "$BASE" && ok "C1    the project's own content is present to begin with" \
  || bad "C1    the project's own content is present to begin with"
GITIGNORE_BEFORE="$(cat "$BASE/.gitignore")"

# --- C2..C6 the documented remedy -------------------------------------------
MERGED="$SANDBOX_ROOT/merged"; cp -R "$BASE" "$MERGED"
copy_the_file_components "$MERGED"
apply_documented_remedy "$MERGED"
OUT="$(run_check "$MERGED" "$TEMPLATE_DIR")"; RC=$?
expect_rc 0 "$RC" "C2    the documented remedy reaches READY" "$OUT"

sentinels_present "$MERGED" \
  && ok "C3    every project-owned sentinel survived the documented remedy" \
  || bad "C3    every project-owned sentinel survived the documented remedy"

# The .gitignore change is additive: nothing that was there was removed.
REMOVED="$(diff <(printf '%s\n' "$GITIGNORE_BEFORE") "$MERGED/.gitignore" | grep -c '^<')"
[ "$REMOVED" = 0 ] && ok "C4    the .gitignore change removed no existing line" \
  || bad "C4    the .gitignore change removed no existing line" "$REMOVED line(s) removed"
grep -q '^logs/work-loop/.owner$' "$MERGED/.gitignore" \
  && ok "C4    and it added exactly the .owner rule" \
  || bad "C4    and it added exactly the .owner rule"

jq -e '([.skills.shared[]?] | index("reorient")) and ([.commands.local[]?] | length == 2)' \
  "$MERGED/.claude/shared-manifest.json" >/dev/null 2>&1 \
  && ok "C5    the manifest gained reorient and kept both local commands" \
  || bad "C5    the manifest gained reorient and kept both local commands"

jq -e '[ (.hooks.SessionStart // [])[] ] | length == 2' "$MERGED/.codex/hooks.json" >/dev/null 2>&1 \
  && ok "C6    hooks.json holds both the project's hook and the compact entry" \
  || bad "C6    hooks.json holds both the project's hook and the compact entry"

# --- C7 the discriminator ---------------------------------------------------
# The destructive remedy reaches the SAME verdict. This is what makes C3-C6
# capable of failing: without them, both remediations look identical.
OVERWRITTEN="$SANDBOX_ROOT/overwritten"; cp -R "$BASE" "$OVERWRITTEN"
copy_the_file_components "$OVERWRITTEN"
apply_overwrite_remedy "$OVERWRITTEN"
OUT="$(run_check "$OVERWRITTEN" "$TEMPLATE_DIR")"; RC=$?
expect_rc 0 "$RC" "C7    the overwrite remedy ALSO reports READY" "$OUT"
if sentinels_present "$OVERWRITTEN"; then
  bad "C7    the overwrite remedy destroys project content (so C3-C6 can fail)" \
      "sentinels survived an overwrite — C3-C6 would pass whatever the remedy did"
else
  ok "C7    the overwrite remedy destroys project content (so C3-C6 can fail)"
fi

printf '\n-----------------------------------------------\n'
printf 'pass=%s fail=%s  (Part B is a mechanical instruction check — interactive enforcement is instruction-borne)\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ] || exit 1
