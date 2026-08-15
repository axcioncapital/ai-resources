# T7 corrected exact candidate — fresh risk-aware review

Date: 2026-08-15  
Candidate source: `logs/work-loop/autonomy-authority-capability.md` at commit `5f0617bc5be988fea1bf35197a11db6f959ce438`  
Governing contract: re-frozen implementation plan §3.5 and T7  
Review mode: isolated, read-only/static; no implementation target changed and no actor launched

## Verdict

**REVISE. Do not implement this exact candidate.**

The corrected candidate resolves most of the first review, but it still has two
load-bearing defects: its proposed test does not bind to the machine-wide file
that T7 actually installs, and its pre-write collision guard permits a dangling
target symlink. Two smaller mechanical/test robustness issues should be removed
in the same tightly bounded repair.

## Material findings

### 1. High — the proposed test does not bind to the installed external rules file

The new section 5b(h) says it tests “The external rules file this policy depends
on,” but it actually creates a separate scratch file:

```bash
T7RULES="$TMPROOT/t7.rules"
printf 'prefix_rule(pattern=["claude"], decision="prompt")\nprefix_rule(pattern=["codex"], decision="prompt")\n' >"$T7RULES"
```

It never opens `/Users/patrik.lindeberg/.codex/rules/axcion-nested-actor.rules`,
never checks its recorded sha256 `b0f8b79c…`, and does not use its complete
381-byte candidate content. Consequently, the suite can pass when the installed
file is absent, placed at the wrong path, malformed, or different from the
reviewed candidate. The scratch file proves the grammar works for duplicated
rules, not that T7's machine-wide configuration was delivered.

This fails the frozen requirement to bind the external rules direct positive to
the file the implementation depends on. The rule-absent negative may remain a
scratch empty file. The positive and wrapper/absolute-path checks should use the
physical installed target after verifying that it is a regular non-symlink file
with the reviewed sha256. If the host file is absent or wrong after T7 install,
the T7 verification must fail rather than skip or silently substitute a copy.

### 2. High — fail-closed pre-write handling misses a dangling target symlink

The proposed pre-write collision check is only:

```bash
[ -e "$TARGET" ] && { echo "REFUSE: target already exists"; exit 1; }
```

For a dangling symlink, `-e` is false while `-L` is true. A static scratch probe
reproduced exactly that state: the proposed `-e` guard passed and the target was
confirmed as a dangling symlink. A later write could follow the link and create
or overwrite its referent outside the resolved rules directory.

The pre-write gate must refuse `-L "$TARGET"` independently of `-e`, before any
write. It should also require `default.rules` to remain a regular, non-symlink
file with the recorded hash, rather than accepting a same-content symlink.

### 3. Medium — new static negatives are brittle to harmless carrier stderr

The candidate's `xp()` merges stderr into stdout and five negative/wrapper
assertions require the whole output to equal exactly `{"matchedRules":[]}`.
Under this Codex review sandbox, the verified carrier binary first emitted:

```text
WARNING: proceeding, even though we could not create PATH aliases: Operation not permitted (os error 1)
```

and then the expected JSON. All five new exact-equality assertions failed even
though the policy result was correct. The same positive checks passed because
they use containment assertions. Existing process-observation tests also fail
under this sandbox, so the full-suite total is not used as a regression verdict;
the five new failures are isolated to the new `xp()` output handling.

Normalize the command's JSON result (or assert the exact empty-result JSON is
present and that no decision/matched rule is present) while separately checking
the command status. This keeps the negative fail-capable without treating an
irrelevant warning as a policy match.

### 4. Low — both mechanically regenerated patches carry the wrong mode metadata

Both targets are tracked as executable mode `100755`. Each proposed patch says
`index ... 100644`. `git apply --check` exits zero but warns that the target has
type `100755`, expected `100644`. The hunks are text-applicable and applying them
in the fixture preserved executable mode, but the result is not warning-clean or
mechanically exact as claimed. Regenerate or correct the patch metadata to
`100755` and require warning-free `git apply --check`.

## Rollback review

- Target symlink: rollback refuses it before hashing — pass.
- Target absent: the hash comparison refuses removal — pass, though the error is
  indirect because `shasum | cut` masks the read failure.
- Target content changed: the recorded installed hash guard refuses removal — pass.
- Repository rollback: restoring the recorded pre-T7 blobs, modes, identities,
  and baseline is the correct shape — pass.
- `default.rules`: the candidate verifies its content hash after deleting the T7
  file, but does not require the recorded regular-file type and does not check
  the hash before mutation. In the bounded repair, check regular/non-symlink type
  and hash before removal, then recheck after removal. This makes unexpected
  prior-state movement fail before the rollback mutates anything.
- The final `ls -1` is a human instruction, not a fail-capable assertion. It need
  not delete unrelated later files, but it should explicitly report/refuse if the
  observed directory identity no longer matches the rollback premise.

## Dimensions that pass

- **Scope:** only the approved machine-wide file, Codex carrier branch/header
  truthfulness update, and carrier tests are proposed. No Claude branch, skill,
  command, core, dispatcher, plan, proposal, or state contract is changed.
- **Truthfulness:** the candidate consistently says requested/unverified and no
  longer claims refusal, prevention, containment, rules loading, or sandbox
  self-edit resistance.
- **Carrier provenance:** `/Applications/ChatGPT.app/Contents/Resources/codex`
  independently reports `codex-cli 0.147.0-alpha.6.5`, matching the carrier and
  the plan. The PATH CLI is not used as evidence.
- **Argv precision:** `-c` is adjacent to `approval_policy=never`; exactly one
  `-c` is asserted; `--ignore-rules` is forbidden; M19 is a real mutation that
  removes the policy from the actual launch line and makes both argv assertions
  fail.
- **Claude path:** neither patch touches the Claude branch; its four mandatory
  rules remain asserted and the one-off branch identity comparison is credible.
- **Known limitations:** wrapper and absolute-path evasion are evidenced and
  clearly retained, not solved.
- **Operator boundary:** the `codex --version` allow-to-prompt interaction is
  bounded to Codex-mediated execution, ordinary Terminal is correctly excluded,
  and reversibility is stated. No broader risk acceptance is inferred.
- **Auto-load premise:** the actual carrier's `exec --help` independently states
  that `--ignore-rules` disables loading user/project `.rules` files. Treating
  default loading as documented/requested but unobserved is accurate.

## Applicability and untouched-target evidence

- `git apply --check` exits zero for each proposed patch against current blobs
  `45f52ab4…` and `7e4af793…`; both produce the mode warnings described above.
- Applying both patches to an isolated fixture succeeded and preserved executable
  modes. No candidate patch was applied to the repository targets.
- Repository targets still hash to `45f52ab4e343925f14bcba4fc940ac3fd692b284`
  and `7e4af79364d1e6f5a996c592bca31e3c495f96b6`, with no path-scoped diff.
- The external candidate target is absent (including no symlink). The rules
  directory is a physical directory; `default.rules` is a regular file at
  sha256 `47532190bb60b4266ed7e82f1669a03f9893860f3b13c0279c4d731bafce09e2`.
- No `codex exec`, Claude actor, or Codex actor was launched. Static calls were
  limited to `--version`, `exec --help`, and the candidate fixture's existing
  `execpolicy check` tests.

## Minimum bounded revision

1. Bind section 5b(h)'s positive and evasion checks to the actual installed
   physical target and its reviewed sha256; retain the scratch empty file only
   for the rule-absent negative.
2. Add an independent `-L "$TARGET"` refusal to the pre-write gate, and require
   regular/non-symlink identity for `default.rules`.
3. Normalize harmless carrier stderr before exact JSON negatives while retaining
   fail-capable status/result checks.
4. Make both diff headers mode-correct (`100755`) and prove warning-free
   applicability.
5. Check `default.rules` identity before and after external rollback, with the
   installed target identity still checked before removal.

No operator decision is required for these findings; they are technical defects
inside the already approved T7 direction. Because the prior Work Loop correction
round has already been used, Codex must apply the executable core's post-review
menu rather than silently opening another correction.
