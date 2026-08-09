---
task: axcion-harness-v0-2-p0-f-attended-policy
turn: operator
---

## Outcome

The explicit attended Claude permission policy is implemented and accepted.

Every attended Claude launch built by the Harness v0.2 dispatcher — plain and with one or more
`--claude-deny` rules — now passes the exact argument pair `--permission-mode default`, and the
dispatcher's logged command line says so. The attended child no longer inherits this repository's
`bypassPermissions` setting. `--claude-deny` still composes on top as additive narrowing, and all
supplied rules reach the child verbatim. The Codex launch, the `--unattended` contained profile, the
output formats, the prompts and the run lifecycle are unchanged.

## Decisions that matter

- **Launch-time `--permission-mode default` is the settled attended mechanism.** It is applied at the
  launch, not by editing a settings file in any layer, so the operator's own interactive session
  posture is untouched.
- **It is a permission policy, not containment.** The attended child asks; it is not sandboxed. OS
  containment remains `--unattended`, which is a separate branch and carries no permission mode of
  its own. The dispatcher, the test suite and the README all state the distinction, and the suite
  asserts it in both directions.
- **The Codex and `--unattended` launch policies remain unchanged.** No Codex-side change was needed
  or made.
- **Deferral — the `--unattended` permission mode.** A contained hop's child still inherits
  `bypassPermissions` at the permission layer; its authority is answered by the OS sandbox plus the
  deny set. Not done here: it is a separate decision about the contained profile, not a correction to
  the attended one. Case 32 now pins the current behaviour, so a later change to it will be visible.
- **Deferral — the stale root `rc=137` entry in `logs/improvement-log.md`.** Still recorded
  `open / high` and now stale. Not done here: the root repository was read-only for this unit.
- **No further correction cycle was spent on non-serious cleanup**, by explicit operator direction on
  2026-08-09. No documentation fix and no test rerun followed the assessment.

## Evidence

This commit — `dispatch.sh`, `dispatch.test.sh`, `README.md` and this record, the exact four
authorized paths and nothing else.

- **Red:** `DISPATCH_BIN=<pre-change dispatch.sh> bash dispatch.test.sh` → `pass=370 fail=5`. The
  pre-change dispatcher was proven byte-identical to the committed one at `b13b3f9`
  (sha256 `3a49a19f…a6a9`). The five failures were exactly the new attended assertions; the two new
  controls — no `--dangerously-skip-permissions` on any path, no `--permission-mode` under
  `--unattended` — passed in the red half, which is what makes them controls.
- **Green:** `bash dispatch.test.sh` → `pass=375 fail=0`. `bash -n` clean on both shell files.
- **Literal argv,** captured from the live dispatcher through a fake `claude` binary, for both
  attended shapes: `-p`, the prompt, `--output-format json`, `--permission-mode default`, and — on
  the deny shape — `--disallowedTools Bash(git push:*) WebFetch`. Both logged command lines carry the
  explicit mode.
- **Negative search:** `dangerously-skip-permissions` appears five times across the three artifacts,
  all as comment, assertion-of-absence or prose. No executable invocation.
- **Prior live control:** root record `logs/work-loop/axcion-harness-v0-2-phase0-p0-f.md`, commit
  `7bb3abf` — the fail-capable red/green pair read off the runtime's own `system/init` event
  (`bypassPermissions` before, `default` after).

## Accepted limitations

- **No end-to-end live attended dispatcher hop has yet exercised the new flag.** The accepted
  evidence combines dispatcher argv construction (simulated, this unit) with the prior direct live
  control (root P0-F). The launch policy is proven as *requested* here, not as *effective*.
- **Which individual actions Claude's `default` mode gates was not remeasured.** Treat the attended
  posture as "the child asks", not as "the child cannot".
- **A known documentation defect is left unfixed by operator decision.** The README's parenthetical
  `(exit-code table, 14)` is an inaccurate cross-reference — it points at test case `14`, not at an
  exit code. Non-serious; explicitly accepted rather than corrected.
