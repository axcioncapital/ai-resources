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

Standard. Discovery mode. Unit 21 — adjudicate the remaining path trust boundaries

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 20 is accepted through implementation commit `1ea4047eec62c31eb6e99cb56f71eda5c537bfff` and correction commit `28dc7a3f80d72d314c3bc27034c11304cc4e46fc`. The correction resolved its sole frozen finding: the evidence directory is now selected as one canonical absolute value read-only during pre-admission, before run identity, directory creation, either lease or any evidence write. Its refusal of unresolved `.` or `..` below a nonexistent tail is accepted because the approved hostile-input boundary explicitly requires traversal rejection; existing paths with resolvable traversal remain accepted. Canonical operator-facing evidence paths are the intended consequence of one trusted value.

The next unmet Change set A clause is to canonicalize and bound checkout, state, capture and changed-path values. Evidence location is closed and must not be reopened. This discovery unit determines which remaining path classes already satisfy the approved boundary and identifies the earliest real gap without implementing a general path framework.

Dominant deliverable: a trust-boundary adjudication of checkout, state-file, capture and Git changed-path values.
Evidence required in this hop: one compact per-path-class map of producer, trust, canonical form, admitted root, symlink and encoding treatment, consumers, permanent proof and exact verdict; then one earliest genuine target only if a gap exists.
Evidence explicitly deferred: implementation or test changes; evidence-location behavior accepted in Unit 20; the newly recorded lack of a committed default-evidence-location end-to-end case, which belongs to the final focused regression/hostile-input proof rather than this map; the experimental `--unattended` stream-json denial proof; `too-many-lines` defence-in-depth proof; Change set B execution budgets; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.

Required outcome:

- Trace only four production path classes through `dispatch.sh` and the canonical helpers it directly invokes: canonical checkout; derived task-state file; actor capture/result paths; and Git-reported changed or dirty paths.
- For each class, establish the original producer and trust level, every transformation before trusted use, the root it is required to remain within, symlink behavior, control/newline and encoding behavior, and the downstream decision it can affect.
- Distinguish three separate questions: canonical identity, containment within an admitted root, and lossless decoding of a path reported by Git. Do not treat one as proof of the others.
- Revisit the two Unit 19 deferrals only where they land in these four classes: Git porcelain C-quoted path handling and the lease helper's possibly relative `--git-common-dir`. Determine whether each can alter a trusted path or routing decision; do not implement it.
- Classify each path class `COVERED`, `BEHAVIOR GAP`, `PROOF GAP`, `NOT APPLICABLE`, or `UNKNOWN`. For every non-covered verdict, name the exact unsafe transformation or missing proof and one smallest hostile discriminator without executing it.
- Identify one earliest genuine implementation target, or state that the clause is behaviorally covered and name the next unmet hostile-input requirement. Prefer removal or a standard Git/shell interface over a new parser or path-policy helper.

Check against the repository:

1. Verify Unit 20's implementation and correction commits, bounded file scope and accepted evidence-path ordering without rerunning its tests.
2. Verify the approved plan's remaining path clause and the adjacent traversal/control/newline/symlink/outside-root/malformed-encoding requirements; preserve the supervised release exclusions.
3. Inspect the current executable producer-to-consumer flows for `CHECKOUT`, `STATE_FILE`, `LAST_CAPTURE`/terminal-result paths, and paths emitted by Git status/diff commands. Follow into `work-loop-state.sh`, `work-loop-owner.sh` and `work-loop-lease.sh` only where the dispatcher passes one of these values.
4. Inspect focused committed tests only for exact path invariants or hostile discriminators found. Aggregate counts and comments are not proof.

Required fail-capable evidence:

- Return one compact table: path class, producer/trust, normalization, required root, symlink/byte handling, trusted consumer, smallest hostile discriminator, exact permanent proof, verdict.
- For every `COVERED`, state the concrete invariant that prevents aliasing, escape or mis-decoding and cite the check that would read differently if it failed where one exists.
- For every gap, name the searched files/patterns, the exact decision that can become wrong, and one smallest hostile value. Do not execute or fix it.
- State explicitly whether the current Git porcelain reader is lossless for spaces, quotes, backslashes, non-ASCII bytes and newlines, and whether any failure is conservative-only or can hide/misroute an actor effect.
- Confirm no production, test, plan or documentation file changed and no test suite ran; only this state file may be committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 20 evidence, current dispatcher, directly invoked path helpers and focused committed tests; inspect necessary accepted history; and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback establishes which remaining path classes satisfy canonicalization, containment and lossless-decoding requirements, identifies one justified next target or next plan clause without implementing anything, changes only this state file, and returns with `turn: codex`.

Stop and hand back if the path classes cannot be adjudicated without designing a new path framework, if an admitted-root policy is not determined by the approved plan/current dispatcher, or if more than one independent behavior gap prevents naming a bounded next target.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS — `git show --stat` on `1ea4047e` and `28dc7a3f`; both exist, both bounded to exactly three files (this state file, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `.../dispatch.test.sh`); no test rerun. Accepted evidence-path ordering re-read at `dispatch.sh:1613` (`check_evidence_location`, pre-admission) and `dispatch.sh:3297` (creation only).
- Claim (2): HOLDS — searched the approved plan for the remaining clause; `plan:212` reads "Canonicalize and bound checkout, state, evidence, capture, and changed-path values", `plan:213` carries traversal/control/newline/symlink/outside-root/malformed-encoding, `plan:222` bounds adversarial path fixtures to admitted roots. Supervised release exclusions at plan §§ 4 and 7 unchanged and preserved.
- Claim (3): HOLDS — traced all four flows in `dispatch.sh`: `CHECKOUT` (301, 1450, 1556–1559), `STATE_FILE` (1577–1586), capture/result (`launch_actor` 4046–4052; `consume_terminal_result` 2274–2283; `validate_terminal_result_path` 1031–1080), Git-reported paths (`foreign_worktree` 3085, `staged_paths` 3098, `allowlisted_dirty` 3132, `allowlisted_dirty_snapshot` 3153, `committed_foreign` 3837, `state_dirty` 3856). Followed into `work-loop-state.sh` (116–143), `work-loop-owner.sh` (126, 336–382) and `work-loop-lease.sh` (166–178) only where the dispatcher passes one of these values.
- Claim (4): HOLDS — searched `dispatch.test.sh` (12003 lines) for `quotePath`, `\NNN` octal, `non-ascii`, `C-quot`, `porcelain -z`, `--name-only -z`, `backslash`: **no match**. Symlink/canonicalization path invariants do have focused cases with mutants (52b/52d M12, 53a M15 at 7666–7995). `git config --get core.quotePath` is unset in this checkout, so Git's default quoting (true) applies.

### Path-class adjudication

| Path class | Producer / trust | Normalization | Required root | Symlink / byte handling | Trusted consumer | Smallest hostile discriminator | Permanent proof | Verdict |
|---|---|---|---|---|---|---|---|---|
| Canonical checkout | operator argv, untrusted | `[ -d ]` then `cd && pwd -P` then `rev-parse --git-dir` (1556–1559), before any path is built from it | itself; it *is* the admitted root every other class is measured against | `pwd -P` resolves every link, so two spellings of one checkout collapse to one string; feeds the lease key `sha256(canonical)` so aliasing cannot split a lease | `STATE_DIR`, `DEFAULT_LOG_DIR`, `LEASE_LIB`, `OWNER_HELPER`, every `git -C` | n/a — no unresolved form survives line 1557 | 52d/M12-class symlink mutants plus `carry-turn.sh` canonicalization cases (test 233, 5121–5123, 7613) | **COVERED** |
| Derived task-state file | derived: canonical checkout + grammar-checked task id | id refused for `/`, `\`, `.`, `..`, any `..`, non-`[A-Za-z0-9._-]`, and >128 chars **before** any join (1518–1554); path then built, never accepted | `$CHECKOUT/logs/work-loop/` | dispatcher re-resolves the parent and requires string equality (1582–1586); validator additionally refuses `-L` on the file itself before `-f`, then canonicalizes the directory (`work-loop-state.sh:134–143`) | validator, `state_dirty`, hop gates, actor prompts | n/a — id grammar admits only single-byte ASCII, so no quoting or encoding question can arise | `work-loop-state.sh` exit 13 classes; dispatcher 1585 | **COVERED** |
| Actor capture / terminal-result | fully derived: `LOG_DIR` (canonical, admitted) + `RUN_ID` + fixed suffix | `LOG_DIR`, `LOG_DIR_ABS` and `LOG_DIR_SELECTED` are one value since Unit 20 (1730–1731); `RUN_ID` = timestamp + `sha256(checkout\|task)` + pid + validated task | `LOG_DIR_ABS` exactly — `real_dir` must equal `real_root` | promised path is **derived and compared literally** (1062–1063); `-L` on the artifact refused before opening (1068); root and dirname each re-resolved with `pwd -P` (1072–1075); `-*`, `*..*`, `*[[:cntrl:]]*` refused on the artifact **and** on all four caller expectations (1048–1054) | `consume_terminal_result`, path/identity validators, `LAST_CAPTURE` readers | n/a — no untrusted component reaches the path | 52b/52d (M12), 53a (M15) mutation-controlled | **COVERED** |
| Git-reported changed / dirty paths | `git status --porcelain` and `git diff --name-only`, **line-based**, C-quoted by Git | outer `"` stripped by `${p%\"}`/`${p#\"}` (3089, 3136, 3158) — **the escapes inside are never decoded**; `committed_foreign` (3837) strips nothing at all | allowlist regexes, anchored `^` | not lossless: see below | `foreign_worktree` → die 18; `committed_foreign` → die 30; `allowlisted_dirty_snapshot` → PARTIAL FILE EFFECTS and the `changed_paths_since_launch` result field | create `logs/work-loop/tåsk.md` (or any name containing `"`, `\`, or a control byte) inside the allowlist and edit it across a hop | **none** — claim (4) found no case in 12003 lines | **BEHAVIOR GAP** |

### Is the porcelain reader lossless? Explicitly, per byte class

| Byte class | Git emits | Reader yields | Lossless |
|---|---|---|---|
| space | unquoted, `?? a b.md` | `a b.md` | **yes** |
| `"` | `"a\"b"` | `a\"b` | no |
| `\` | `"a\\b"` | `a\\b` | no |
| non-ASCII | `"t\303\245sk.md"` (default `core.quotePath=true`) | `t\303\245sk.md` | no |
| newline | `"a\nb"` — **one line**, two characters | `a\nb` | no, but **not** a splitting hazard |

**Newline injection is closed, and not by this reader.** Git always C-quotes a path containing a control byte regardless of `core.quotePath`, so `while IFS= read -r line` can never be handed a split path. That is a real invariant and it holds — but it is Git's, borrowed, and nothing in this repository states or tests it.

**The failure is not conservative-only. It splits three ways, and one direction hides an actor effect:**

1. **Classification stays correct** in `foreign_worktree` and `allowlisted_dirty`. The allowlist regexes are `^`-anchored on all-ASCII leading components (`^logs/work-loop/`, `^plans/work-loop-v2-v0\.2/handoff-automation-spike/`), and C-quoting only ever *adds* backslashes further right, so the matched prefix is untouched. Both also print `$line`, Git's own form, so the operator sees a faithful path. No misrouting here.
2. **`committed_foreign` false-stops.** It never strips the outer quotes, so a quoted in-allowlist path arrives as `"logs/work-loop/…"` — leading `"` defeats `^logs/work-loop/`, the path is reported as committed-foreign, and the run dies 30 on legitimate allowed work. Fail-closed, so safe, but it is a false stop *and* it disagrees with reader (1) about the same path: one admits it, the other refuses it.
3. **`allowlisted_dirty_snapshot` hides the effect.** This is the real gap. `[ -e "$CHECKOUT/$p" ]` is tested against the still-escaped `p`, which does not exist, so `oid="ABSENT"` (3159–3163). Baseline and post-hop both record `ABSENT` against a byte-identical status line, `comm -13` finds no delta, and the actor's edit appears in neither the PARTIAL FILE EFFECTS block nor the `changed_paths_since_launch` field of the terminal result. The oid pairing exists precisely because a status line alone cannot show a second edit to an already-dirty file (comment 3148–3152) — C-quoting defeats the mechanism at the exact case it was built for. The operator is told work was left on the floor by name for every ASCII path and told nothing for this one.

**Not affected:** `staged_paths` (3098) is tested only for emptiness (4446–4448), and `state_dirty` (3856) passes a fixed pathspec and reads only whether output is empty. Quoting cannot change either answer. Both **NOT APPLICABLE** rather than covered.

### The two Unit 19 deferrals, revisited only where they land here

- **Git porcelain C-quoted path handling** — lands squarely in class 4 and *is* the gap above. No longer deferrable as cosmetic: direction 3 hides an actor effect.
- **Lease helper's possibly relative `--git-common-dir`** — **COVERED**, and closed in code, not by argument. `work-loop-lease.sh:172` re-anchors a relative value against the checkout (`case "$wl_g" in /*) ;; *) wl_g="$wl_c/$wl_g" ;; esac`) and `:173` canonicalizes with `cd && pwd -P`, returning 2 if that fails; `dispatch.sh:1888–1889` maps both returns to exit 11. The checkout it anchors against was canonicalized at `dispatch.sh:1557` before `wl_lease_init` is called at 1885. It cannot alter a trusted path or a routing decision.

### The three questions kept separate

- **Canonical identity** — settled for checkout, state file and evidence/capture by `pwd -P` plus literal equality. Not at issue for Git-reported paths, which are relative and never canonicalized.
- **Containment in an admitted root** — settled by derivation (state file, capture, result) or by anchored allowlist regex (Git-reported). Class 4's containment decision is *correct*; it is the reporting that is wrong. These are not the same question and the passing one does not cover the failing one.
- **Lossless decoding** — an independent property that only class 4 has, and the only one of the three that is unmet.

### Earliest genuine implementation target

**Replace line-based reading of Git path output with Git's NUL-delimited output, and delete the hand-rolled quote strip.** `git status --porcelain -z` and `git diff --name-only -z` emit raw, unquoted, unescaped bytes with a `NUL` terminator; read them with `IFS= read -r -d ''`. This is removal plus a standard Git interface, not a new parser or a path-policy helper — the brief's stated preference. It touches five call sites (3087, 3098, 3134, 3155 via `allowlisted_dirty`, 3837), removes the three `${p%\"}`/`${p#\"}` pairs, and closes directions 2 and 3 together with one mechanism. `-z` also changes rename lines to two separate NUL-terminated fields, which must be handled at 3087/3134 rather than left as `orig -> dest`.

That target is bounded to one implementation unit with a mutation-controlled hostile-path case, and it does not require designing a path framework. Only one behavior gap was found across the four classes, so a bounded next target is nameable and the brief's stop conditions did not fire.

### Bounded-scope confirmation

No production, test, plan or documentation file changed and no test suite ran. `git status --porcelain` shows only this state file staged; `logs/friction-log.md` and `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md`'s sibling working-tree entries were left unstaged.

## Blocker

None.

## Next action

Codex: assess Unit 21's adjudication — three classes COVERED, two NOT APPLICABLE, one BEHAVIOR GAP in the Git-reported changed/dirty path class, with the lease `--git-common-dir` deferral closed as covered. Decide whether to open the named `-z` implementation unit, or to reframe.
