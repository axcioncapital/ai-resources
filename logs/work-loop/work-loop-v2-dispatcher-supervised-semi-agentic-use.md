---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Discovery mode. Unit 19 — adjudicate argv and option termination

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 18 is accepted at `c938d99202ddd9f870c93ccef13781a8c0f363a1`. It established that lifecycle handbacks already pass through the canonical validator with no competing trusted reader, raw actor output cannot enter terminal-result framing, and no `eval` or `source` evaluates actor-controlled bytes; building another parser would therefore be ceremony. Its only proof gap concerns line-delimited `stream-json` denial extraction on the explicitly experimental `--unattended` surface, which the approved release excludes, so that proof is deferred until unattended scope is deliberately reopened rather than imported into Gate SA.

The next Change set A clause requires argument arrays and explicit option termination where supported. Current launch sites visibly use quoted argv construction in several places, while other Git and filesystem calls may receive checkout-, task-, evidence- or actor-derived operands; this unit determines whether any such operand can be split or interpreted as an option before proposing edits.

Dominant deliverable: a trust-boundary adjudication of production command argv construction and option termination.
Evidence required in this hop: one compact map of external-command sites receiving non-literal operands, their producer/trust level, argv construction, option-termination behavior, permanent proof and exact verdict; then one earliest genuine target only if a gap exists.
Evidence explicitly deferred: implementation or test changes; the experimental `--unattended` stream-json denial proof; general path canonicalization and root containment; protocol/handback work accepted in Unit 18; `too-many-lines` defence-in-depth proof; Change set B execution budgets; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.

Required outcome:

- Enumerate production external-command invocations in `dispatch.sh` and directly invoked helpers where a non-literal operand can be influenced by operator argv, task state, actor changes, environment, checkout contents or Git output. Group mechanically identical call families; do not produce a line-by-line command inventory.
- For each family, distinguish safe Bash array/quoted-word construction from string evaluation or shell reparsing. Then determine whether an operand that begins with `-` can reach an option-parsing position and whether the invoked tool supports or requires `--` at that location.
- Treat `bash -c "$ACTOR_CMD"` as the explicitly simulated actor-command surface already selected by operator argv, not automatically as injection from data. Report it separately and only classify a gap if untrusted data is interpolated into that command string before evaluation.
- Distinguish option termination from path canonicalization: this unit asks whether a value is misread as syntax, not whether the path is inside an admitted root. Hold the latter for the next plan clause.
- Classify each family `COVERED`, `BEHAVIOR GAP`, `PROOF GAP`, `NOT APPLICABLE`, or `UNKNOWN`. For every non-covered verdict, name the exact unsafe position or missing proof and the smallest hostile operand that would distinguish it, without executing it.
- If current arrays, quoting, fixed grammars and option ordering already cover the clause, say so and identify the next unmet Change set A clause. Do not add `--` where the tool does not support it or where no untrusted operand can occupy an option position.

Check against the repository:

1. Verify Unit 18 commit `c938d99202ddd9f870c93ccef13781a8c0f363a1`, its state-only scope and its accepted actor-handback verdict without rerunning any check.
2. Verify the approved plan's next clause is exactly “Use argument arrays and explicit option termination where supported,” and preserve the release exclusion for unattended/walk-away claims.
3. Inspect complete executable command construction in `dispatch.sh` plus `work-loop-state.sh`, `work-loop-owner.sh`, `work-loop-lease.sh` and `work-loop-capability.sh` only where the dispatcher invokes them. Search arrays, quoted expansions, pipelines, `eval`, `bash -c`, `git`, filesystem tools and option-like operands; current executable code decides the map.
4. Inspect focused committed tests only for the exact command families and hostile operands identified. Do not infer proof from aggregate suite counts or comments.

Required fail-capable evidence:

- Return one compact table: command family, non-literal operand and trust, construction shape, option-termination behavior, smallest hostile discriminator, exact permanent proof, and verdict.
- For every `COVERED`, explain why spaces, glob characters, newlines or a leading `-` cannot change argv structure or option interpretation, and cite the fail-capable test that would read differently where one exists.
- For every gap, name the complete searched surfaces/patterns and one smallest hostile operand; do not execute or implement it.
- Confirm no production, test, plan or documentation file changed and no test suite ran; only this state file may be committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 18 evidence, current dispatcher, the four directly invoked helpers and focused committed tests; inspect necessary accepted history; and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback establishes whether every relevant production command family preserves data as argv and terminates options where materially required, identifies one justified next target or the next Change set A clause without implementing anything, changes only this state file, and returns with `turn: codex`.

Stop and hand back if the clause cannot be adjudicated without expanding into full path containment, if tool-specific option semantics remain load-bearing and unresolved after bounded inspection, or if current behavior conflicts with the approved clause beyond one bounded next target.

## Latest result

Inspected (2026-08-19):

- Packaging lines: HOLDS — `Dominant deliverable:` names exactly one deliverable; `Evidence required in this hop:` and `Evidence explicitly deferred:` are both non-empty; `Primary edit begins after:` is correctly absent for Discovery mode. Mode matches the completion condition, which asks for a committed discovery handback and forbids implementation.
- Claim (1): HOLDS — `git show --stat c938d99202ddd9f870c93ccef13781a8c0f363a1` returns the Unit 18 handback commit, 1 file changed, and that file is `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md` only. Its accepted verdict is read from `## Latest result` above, not rerun.
- Claim (2): HOLDS — searched `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` for the Hostile-input boundary list; line 211 reads exactly `Use argument arrays and explicit option termination where supported.` It sits immediately after line 210 (`one parser`, Unit 18's accepted clause) and immediately before line 212 (`Canonicalize and bound …`, this unit's deferred neighbour). The unattended/walk-away exclusion is intact at lines 4, 25, 125, 134 and 445.
- Claim (3): HOLDS — inspected `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (4595 lines) end-to-end for external-command construction, plus `logs/scripts/work-loop-state.sh`, `work-loop-owner.sh` and `work-loop-lease.sh` at the paths the dispatcher actually enters. 139 lines carry an external command; the map below groups them into twelve families. `logs/scripts/work-loop-capability.sh` is **not invoked by the dispatcher at all** — searched `dispatch.sh` for `work-loop-capability`, 0 matches — so it is out of the map rather than covered by it.
- Claim (4): HOLDS — searched `dispatch.test.sh` (11775 lines) for argv-recording doubles, option/leading-dash fixtures and hostile filenames. Found word-level argv proof for the Claude launch only (cases 31b, 32, 32z, 32z2 via `WL_ARGV_FILE`); found **no** test that records Codex argv and **no** test that plants a worktree path beginning with `-`. Aggregate suite counts were not consulted.

Result: the clause is met in behaviour at every place an **untrusted** operand can reach a command, and the two `--` sites that materially matter are already explicit. Nine families are `COVERED`, one is `NOT APPLICABLE` by the brief's own instruction, two are `PROOF GAP`, and exactly one is a `BEHAVIOR GAP`. No `UNKNOWN` remains.

| # | Command family | Non-literal operand → trust | Construction | Option termination | Smallest hostile discriminator | Permanent proof | Verdict |
|---|---|---|---|---|---|---|---|
| F1 | Live Claude launch, attended + unattended (`dispatch.sh:4044`, `:4065`) | `$TASK` operator argv; `CLAUDE_DENY[@]` operator argv; `$cb`, `$UNATTENDED_SETTINGS` derived | quoted words + Bash array `"${a_deny[@]}"`, forwarded by `run_bounded` as `"$@"`; no string eval | `-p` value always begins with the literal `/work-loop-v2 `, so it can never parse as an option; deny values are variadic after their flag and the CLI has no `--` to give | `--claude-deny '-p'` — occupies a value slot; operator-trusted, and the frozen argv would show it verbatim | test cases 32z / 32z2 / 32 / 31b | COVERED |
| F2 | Live Codex launch (`:3963`) | `$(codex_prompt)` embeds `$TASK`; `$CHECKOUT` | command substitution inside double quotes → one argv word despite newlines | prompt begins with the fixed literal `Use the $work-loop-v2 skill.`, `-C` value is canonical-absolute; no operand can occupy an option position | a fake codex recording `printf '%s\n' "$@"` and asserting exactly one word after `--json` | **none** — `FAKE60HX` only branches on `--version` and writes no argv file | PROOF GAP |
| F3 | Simulated actor (`:3952`) | `$ACTOR_CMD` operator argv, verbatim | `bash -c "$ACTOR_CMD"`; task/checkout/state reach the child as `WL_*` env vars (`:3950–3951`), **not** spliced into the command string | n/a — operator-selected surface, no untrusted data interpolated before evaluation | n/a | n/a | NOT APPLICABLE |
| F4 | Helper invocations (`:3554`, `:4137`) | `$TASK`, `$CHECKOUT` | `--opt value` pairs only | values cannot begin with `-`: `$TASK` is bounded by `^[A-Za-z0-9][A-Za-z0-9._-]*$` and ≤128 chars at exit 12 (`:1513–1548`), `$CHECKOUT` by `cd && pwd -P` (`:1552`); `--` neither supported nor needed | `--task -rf` → refused at 12 before any path is built | case 3 plus the task-id grammar/length cases | COVERED |
| F5 | Git calls taking a **path** operand (`:2901`, `:3744`, `:3067`) | `$p` — a path from `git status --porcelain`, the **only** actor-controlled operand in the map | quoted words | all three already carry `--` | a dirty tracked file named `-n` in an allowlisted directory; without `--`, `git hash-object -n` is a different command | **none** — deleting `--` at `:3067` leaves every current test green | PROOF GAP |
| F6 | Git calls taking rev operands only (`:3725`, `:4464`, `:2911–2912`, `:2962`, `:3005`, `:3371`, `:3756`) | `$before`/`$after` — `rev-parse HEAD` output, 40 hex or empty | quoted words | no path operand exists, so `--` has no useful position; adding it would be cargo-cult | n/a | n/a | COVERED |
| F7 | Run-evidence filesystem writes (`:3184` `mkdir -p`, `:3189` `cd`, `:881` `mv -f`, `:879`/`:2199` `rm -f`, `:3935` `: >`, `:3406` `cat >`) | `$LOG_DIR` — operator `--log-dir`; all other operands are `$LOG_DIR/$RUN_ID…` and `$RUN_ID` is `date`-hash-pid-`$TASK`, fully bounded | quoted words; none of these tools is given `--` although all four support it | a leading-dash `--log-dir` is consumed as options by `mkdir -p` and stops at `STOP [10] cannot create log dir` — a refusal, but an **incidental** one, not a designed check. The one value that is *not* refused is `-`: `mkdir -p -` creates a directory named `-`, and the very next line `cd "$LOG_DIR"` is bash's `cd -` OLDPWD form, so `LOG_DIR_ABS` becomes the previous working directory while `$out`, `$RUN_LOG` and `$final` keep using raw `$LOG_DIR`. The allowlist widening at `:3190–3194` and every "where is the evidence" report then describe a different directory from the one written to. | `--log-dir -` (not executed) | none | **BEHAVIOR GAP** |
| F8 | Reading run / lease / capture files (`:715`, `:1907`, `:1918`, `:2192–2198`, `:2816`, `:2833`, `:2846`, `:2918`, `:2920`, `:3701`, `:2914` `ls -t` glob) | paths under `$CHECKOUT/…`, `$LOG_DIR/…`, `$LOCK_DIR/…`; `$st_last` from a glob | quoted words; every pattern operand is a single-quoted literal | structurally covered rather than terminated: a glob expansion always carries its directory prefix, so no operand can begin with `-` unless its own root does — which is F7's single case and nothing else | `--log-dir -` again | none needed | COVERED (conditional on F7) |
| F9 | Allowlist regex matching (`:2999`, `:3049`, `:3729`) | `$p` actor-controlled; `$re` from `--allow-path` | `printf '%s' "$p" \| grep -qE "$re"` — the actor-controlled value is delivered on **stdin**, never as an operand; that is the load-bearing choice | a `--allow-path` beginning with `-` makes grep exit non-zero on a usage error, so `allowed` stays 0: it can only narrow, never widen. The operator already owns the allowlist outright, so no trust boundary is crossed | `--allow-path -v` → path stays disallowed | n/a | NOT APPLICABLE |
| F10 | Process control (`:1719`, `:2280`, `:2284`, `:2347`, `:2413`, `:2518`, `:2532`, `:3857`, `:2464` `lsof`) | pids/pgids from `ps` and `$!`, numeric | quoted words; `for p in $census` splits a numeric list deliberately | the two operands that genuinely can begin with `-` **already carry `--`**: `kill -TERM -- "-$pgid"` (`:2518`, `:2532`) and `lsof -t -- "$marker"` (`:2464`). This is the clause already applied where it is materially required | n/a | n/a | COVERED |
| F11 | `eval` string construction (`:3835`, `:3850`) | `$marker` | only the literal `9` (`TREE_MARKER_FD`) is interpolated at build time; `$marker` is left as the escaped text `"$marker"` and expands **inside** eval within double quotes | bash does not rescan the result of a parameter expansion, so no byte of `$marker` can become syntax | a `--log-dir` containing `$(id)` — would not be re-expanded | none needed | COVERED |
| F12 | `mktemp "${TMPDIR:-/tmp}/wl2-lsof-err.XXXXXX"` (`:2463`) | `TMPDIR` environment | quoted word; `--` supported and not given | a leading-dash `TMPDIR` makes mktemp fail, `lsof_err` is empty, and `:2473` takes the explicit "no temporary file could be created" branch recording `CENSUS_UNKNOWN` — fails closed by design, not by luck | `TMPDIR=-x` → CENSUS_UNKNOWN | none | COVERED |

One earliest genuine target: **F7**. It is the only family where an admitted run proceeds and misdescribes its own evidence, and the fix is small and local — `--` on the four tools that support it, `cd -- "$LOG_DIR"`, and refusing `-` as an evidence location at admission alongside the existing symlink and writability checks in `check_evidence_location`. F5 and F2 are proof-only and cost one fixture each.

The next unmet Change set A clause is plan line 212, `Canonicalize and bound checkout, state, evidence, capture, and changed-path values.` F7 is exactly the seam where option termination and canonicalization meet — `LOG_DIR` is never replaced by `LOG_DIR_ABS`, so two evidence paths coexist — which is Codex's call to size as one target or two.

Deferrals noticed and not implemented: (a) `p="${line:3}"` at `:2995`/`:3042`/`:3064` strips surrounding quotes without unescaping git's C-quoted porcelain form, so a path containing a quote, backslash or non-ASCII byte yields `oid=UNHASHABLE` rather than a hash — an encoding question, not option termination; (b) the lease library's `git rev-parse --git-common-dir` at `work-loop-lease.sh:170` omits `--path-format=absolute`, so `WL_LEASE_ROOT` can be relative — belongs with the canonicalization clause, not this one; (c) the raw-vs-canonical `LOG_DIR` divergence named above. None is a `--` question and none was changed.

Evidence: this is a discovery unit, so the evidence is the map's fail-capability rather than a passing check. Each `COVERED` row states the specific byte class that cannot change argv structure and names the surface that settles it; each row could have read otherwise, and three did — F7 returned a behaviour gap, F2 and F5 returned proof gaps, which is what distinguishes this inspection from a rubber stamp. Case 32z is a whole-argv frozen diff, not a token-presence grep: `Bash(git push *)` carries a space and `mcp__*` carries a glob, so any loss of quoting or any added, removed or reordered word fails the diff. The two `PROOF GAP` verdicts are stated as the absence of exactly that artifact, with the searched surface named. No production, test, plan or documentation file changed; no test suite ran; only this state file is committed. `logs/friction-log.md` and `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md`'s sibling working file remain unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 19's adjudication. Decide whether the argv/option-termination clause closes on F7 alone, whether F2 and F5 proof fixtures enter Gate SA or are deferred, and whether F7 is sized as its own unit or folded into the canonicalization clause at plan line 212 that it shares a seam with.
