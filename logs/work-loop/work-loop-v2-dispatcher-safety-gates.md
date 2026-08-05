---
task: work-loop-v2-dispatcher-safety-gates
turn: operator
---

## Outcome

The four remaining single-checkout safety clusters are proven for the throwaway handoff dispatcher,
and the proofs exposed **four real dispatcher defects**, each minimally corrected and
regression-covered.

- **Permission and approval stop.** A live Claude actor **launched by `dispatch.sh`** in a throwaway
  sandbox checkout denying `Bash(git:*)` — the exact authority core § 4 depends on — attempted
  `git add … && git commit …`, was denied at runtime, **refused to retry the command in another
  form**, and exited on its own in 28 s. The dispatcher stopped at `25 UNCOMMITTED_HANDBACK` after
  one actor launch with zero subsequent launches, `HEAD` unmoved, and both permission surfaces
  byte-identical. Run twice, identical post-run state hash. Measured separately, a refused actor does
  not hang: 10 s and 14 s to self-termination.
- **Crash and restart safety.** No retry existed at all. There is now exactly one, gated on the
  repository being *provably* unchanged — state-file `sha256`, `HEAD`, foreign working tree and the
  state file's committed-ness all identical. A crash after any change is never retried.
- **Repository-state safety.** Three conditions were undetected and are now pre-hop gates checked
  before *every* hop, so a restart re-enters them: pre-existing foreign **unstaged** work (`18`),
  which the before/after delta structurally could not see; a held Git `index.lock` (`19`); and an
  in-progress merge, rebase, cherry-pick or revert (`19`). Each stop names the task, the condition
  and a recoverable next action. The expected uncommitted Codex handoff still launches.
- **Operator boundary.** `turn: operator` swallowed the question entirely. It now prints the
  `## Blocker` and `## Next action` sections read-only under an explicit statement that the question
  is UNANSWERED and that neither model nor the controller answered it.

Two further corrections were forced by the work rather than chosen: `--help` printed a fixed line
window and would have silently truncated the new exit codes, and the dispatcher's own `--log-dir`
registered as foreign work when it sat inside the checkout — a guard failing on itself.

## Decisions that matter

- **Exit `25`, not the anticipated `22`, is the correct classification** when a denied actor had
  already changed the state file. `UNCOMMITTED_HANDBACK` is repository truth: the edit exists and is
  uncommitted. A denial arrives as `22` only when the actor changed nothing.
- **No denial-specific exit code was added.** For a throwaway spike that is taxonomy, not safety.
  Instead the `25` message says a refused git permission looks exactly like this and points at the
  hop capture, where `permission_denials` records the refused command precisely.
- **The minimal exit-`25` message correction is accepted as part of the frozen finding**, because it
  supplies the recoverable next action the finding's acceptance condition required. It was raised to
  Codex as a possible broadening rather than absorbed silently.
- **This task authorizes neither worktree/parallel work nor production installation.**
- **Deferral — Codex-side denial behaviour.** Unmeasured; only the Claude actor was exercised live.
  Excluded by the correction's own scope note.
- **Deferral — the `dispatch.sh` line-31 header contradiction** ("0 is the ONLY success"). It still
  disagrees with the lines-48/49 note. No proof in this unit exposed it, and the README documents it.
- **Deferral — the worktree-per-task proof.** A separate future unit, held until these
  single-checkout failures were shown to stop safely. They now are.
- **Nothing was installed or widened.** No hook, daemon, settings file, schema, product installation,
  authentication, dangerous permission bypass, destructive cleanup, or push. Every live denial ran in
  `TMPDIR` sandboxes outside this repository under narrowing `deny` rules only.

## Evidence

Commit `2d55077` carries the unit — the four clusters, the four corrections, and harness cases 14–20.
Commit `180e275` carries the correction round — the live denial through `dispatch.sh`, the exit-`25`
message, and the corrected exit-code claim. The closing record is the commit that follows this file.

- **Red-to-green, same harness, both directions.** Against the pre-change controller extracted from
  `HEAD`: `DISPATCH_BIN=<pre> bash dispatch.test.sh` → exit 1, **`pass=49 fail=20`**. Against the
  corrected controller: `bash dispatch.test.sh` → exit 0, **`pass=69 fail=0`** (was `pass=34`). The
  20 failures map onto the four corrections. Re-run after the correction round: unchanged at
  `pass=69 fail=0` — nothing previously green broke. Case 0 still points the suite at an absent
  dispatcher and asserts it fails, so a green run means something.
- **Live product evidence, kept separate from the simulated suite:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/live-permission-denial-2026-08-05.md`.
  Run C is the denial-through-dispatcher record: checkout, task, policy, binary `claude 2.1.220`,
  denied action, elapsed (child 27.6 s / wall 30 s), child result (`exit 0`, `subtype: success`,
  5 turns), dispatcher exit `25`, state `sha256` `d8863584…` → `83958616…`, `turn:` `claude` →
  `codex`, `HEAD` unmoved, **1 actor launch and zero subsequent**, and byte-identical settings on
  both surfaces. Runs A and B record the product-alone behaviour.
- **Simulated versus live is marked at the source.** Every harness case runs through `--actor-cmd`,
  which forces `mode=simulated` into all run evidence; the suite's own summary line says so.
- **Changed paths across both commits — the complete set, all in scope:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `…/dispatch.test.sh`,
  `…/README.md`, `…/runs/live-permission-denial-2026-08-05.md`, and this state file.
- **Excluded resources verified unchanged** by `git status --short` over the whole repo: the core,
  the proposal, the investigation report, `.claude/` and `.codex/` hooks and settings, and the closed
  prior task record `logs/work-loop/work-loop-v2-handoff-dispatcher.md`.
- **`logs/friction-log.md` is modified and was deliberately never committed by this task.**
  Pre-existing PostToolUse hook telemetry, not this task's work product. Disclosed rather than swept
  into a commit.

## Accepted limitations

- Single task, single checkout, serial. No claim of same-checkout concurrency or multi-worktree
  safety.
- Run C used a **fixture** `/work-loop-v2` command, not the real one, so the sandbox never became a
  partial copy of this repository. It proves the transport and the denial, not that the real command
  behaves identically under denial.
- Only one denied authority was exercised end-to-end: `git` via Bash. A denied file write, or a
  denied `Read` of the state file itself, would land on different codes and were not measured.
- Codex-side denial behaviour is unmeasured.
- Retry is one attempt only, from a provably unchanged repository. No backoff, and no retry on
  timeout — a timeout is not a pre-edit crash, and a retry would only burn a second deadline.
- Repeat reliability is two runs for the denial path and one per product-alone path. Nothing here
  describes a distribution of outcomes.
- Gate `18` will stop any live run in **this** repository until `logs/friction-log.md` is
  allowlisted, because a PostToolUse hook modifies it continuously — and supplying any `--allow-path`
  replaces both defaults, so a live run needs all three patterns. The exact invocation is in the
  spike README.
- The spike depends on the currently installed product binaries (Claude Code `2.1.220`) and was not
  authorised to install, upgrade, authenticate, or widen permissions.
- No hook-driven, daemon-driven, or production deployment behaviour exists.
