---
task: work-loop-v2-contained-unattended-profile
turn: operator
---

## Objective and scope
Clear Phase 1 item 1d by completing and proving the operator-settled contained profile for unattended Claude hops.

Scope: the handoff dispatcher, its simulated regression suite, one attended and bounded live effective-policy probe through the dispatcher, the probe evidence, and the narrow plan/README/Work Loop documentation reconciliation that becomes necessary only if the live proof passes.

Excluded by Codex framing: escaped-descendant termination (1a), branch/worktree isolation proof (1f), any Phase 2 walk-away pilot, managed-settings or MDM changes, production installation or graduation of the spike, push, deployment, and unrelated Work Loop changes. These exclusions keep this unit on one of the three current blockers and preserve every later phase gate.

## Lane and unit
Standard. Implementation mode. Unit 1 — finish the contained unattended profile integration and prove its effective behavior.

Named reason for the loop: this changes the authority of an unattended process and its fail-closed safety behavior, so the result needs bounded implementation evidence and independent Codex assessment before it can count as complete.

## Brief
This unit addresses the contained-profile blocker because its policy and required behavior are settled, while repository inspection indicates that implementation work is present but effective live evidence and documentation reconciliation are not yet complete. The unit does not clear 1d merely because a settings file or child arguments exist: it must establish the effective policy from inside a real child launched through the dispatcher. Phase 2 remains blocked throughout.

Required outcome:

1. The dispatcher has one explicit unattended mode that applies the settled profile on every Claude hop through CLI `--settings`, not through repository settings.
2. The mode fails closed before launch when the required Claude version or sandbox capability cannot be established.
3. Attended and courier launches without the mode retain their existing behavior.
4. A real Claude child launched through the dispatcher demonstrates the effective restrictions from inside the child.
5. The simulated suite, live evidence, plan status, README, and the narrow unattended guidance in `.agents/skills/work-loop-v2/SKILL.md` agree about what is built, what is proven, and what remains blocked.

Governing sources:

- Current operator direction: advance the ongoing Work Loop v2 unattended-operation work through this bounded unit.
- `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, especially the status block, Phase 1d, Phase 2 gate, and reopened 3c/3d documentation duties. The settled profile is governing; factual status statements are verify-first because implementation may have moved ahead of the document.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-contained-authority-2026-08-07.md`, including both silent-failure constraints in its verification addendum.
- `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-unattended-authority-2026-08-07.md` is non-governing background where superseded. Its negative finding that tool denial alone leaves `curl` reachable remains relevant; its conclusion that OS-backed containment is unavailable does not.
- `AGENTS.md`, `CLAUDE.md`, the governing parent `CLAUDE.md`, `.agents/skills/work-loop-v2/SKILL.md`, and `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`.

Check against the live repository before acting:

1. Inspect the complete current `dispatch.sh` and `dispatch.test.sh`. Verify whether `--unattended`, its generated profile, fail-closed version/platform gate, child arguments, additive deny behavior, and case 32 coverage are partial work, complete work, or have changed again. Do not overwrite concurrent work or assume the present draft is correct.
2. Search the whole spike `runs/` tree for `unattended-effective-policy`. The present Codex inspection found references to `runs/probes/unattended-effective-policy.sh` but no such file or live record. Bound any contrary conclusion to the exact paths searched.
3. Inspect the current plan, README, and `.agents/skills/work-loop-v2/SKILL.md`. The present Codex inspection found that they still describe 1d as unbuilt and do not yet provide the proven contained launch guidance. Treat this as a claim to verify, not permission to change the documents before live proof.
4. Verify the installed Claude binary and the effective CLI/settings behavior against the contained-authority record. If a required key or flag differs, hand back the evidence instead of approximating the policy.

Required implementation constraints:

- Preserve the exact settled profile: sandboxed Bash plus `Skill`; strict empty Bash network allowlist; no MCP, in-process web, hooks, connectors, remote control, subagents, built-in file tools, push, credential inheritance into subprocesses, or unsandboxed-command escape.
- Deliver `strictAllowlist` through CLI `--settings` on every Claude hop. Evidence that a profile file exists or was passed is not evidence that the effective child policy held.
- Treat array merging across settings scopes as an unresolved residual limitation unless effective behavior proves the tested restriction on this machine. Do not claim managed-setting guarantees the dispatcher cannot provide.
- Keep the live proof attended, bounded, fixture-scoped, and harmless. It is a Phase 1 safety check, not the Phase 2 walk-away pilot.
- Do not weaken, delete, or bypass an existing safety guard to make the proof pass.
- Do not mark 1d complete or reduce the blocker count until the effective live checks pass.

Required evidence:

1. A simulated regression run with its exact pass/fail count. The new cases must be capable of failing and must cover every settings, CLI, environment, delivery-scope, fail-closed, additive-deny, unchanged-attended, and incompatible-mode claim made by the implementation.
2. A reproducible live probe script in `runs/probes/` plus a dated evidence record and raw capture. It must launch a real Claude child through `dispatch.sh --unattended`, not invoke a profile directly around the dispatcher.
3. From inside that child, observed checks that can independently fail: local shell work succeeds; a non-allowlisted network request is refused; a write outside the checkout is refused; a denied home read is refused; push is denied before execution; only the intended tools are exposed; MCP and hooks are absent; and harmless sentinel credential variables supplied only for the probe do not reach a subprocess. If any check cannot be established safely, report that gap and hand back rather than substituting a model claim.
4. The dispatcher log showing the requested restrictions and CLI delivery scope, kept separate from the inside-child proof of effective restrictions.
5. Cleanup evidence: no probe process, lock, temporary checkout, sentinel credential, or outside-checkout marker remains.
6. If and only if the live proof passes, reconcile the plan and operational documentation so they state that 1d is complete, reduce the current Phase 2 blocker count from three to two, retain 1a and 1f as blockers, keep Phase 2 forbidden, and distinguish requested policy from effective behavior and residual settings-scope risk.
7. One commit containing the completed unit and this state file, followed by `turn: codex`. Report the commit identifier and the evidence paths in `## Latest result`.

Completion condition:

The repository contains a fail-closed unattended mode whose requested policy is covered by the simulated suite and whose effective restrictions are demonstrated from inside a real dispatcher-launched Claude child; the resulting evidence and documentation make no stronger claim than those observations support. Claude has committed the unit, recorded the result here, and handed it to Codex for assessment.

Stop and hand back to Codex if any verify-first claim is false, concurrent edits make ownership unsafe, the effective live policy differs from the settled profile, required evidence cannot be produced, or completing the unit would cross an exclusion. Stop for the operator if proceeding would require weakening or changing the settled profile or any phase gate.

## Latest result
Inspected (2026-08-07):

- **Claim (1): HOLDS, and the answer is "partial work" — but the concurrent work is THIS SESSION'S.**
  Read `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` and `dispatch.test.sh` in full.
  `--unattended` exists with its generated profile, the Darwin + `>= 2.1.219` + readable-version gate
  (exit `31`), the contained child argv, additive `--claude-deny`, and cases 32–32l. All of it is
  **uncommitted work made in this same session before this brief was read** — `git status --porcelain`
  shows `M dispatch.sh`, `M dispatch.test.sh`, `M README.md`, `?? runs/probes/unattended-effective-policy.sh`.
  This matters for the brief's "do not overwrite concurrent work" instruction: there is no third party
  to protect. Treating it as unknown concurrent work would have been the false statement.
  The work was complete for required outcomes 1–3 and absent for outcome 4 (live proof) at inspection.
- **Claim (2): FALSE NOW, TRUE WHEN CODEX MADE IT.** Searched
  `plans/work-loop-v2-v0.2/` for `unattended-effective-policy`: four files reference it
  (`dispatch.sh`, `dispatch.test.sh`, `README.md`, and the script itself), and
  `runs/probes/unattended-effective-policy.sh` **exists**, created by this session at 13:12 today —
  after Codex's inspection and because of it, not independently of it. Searched
  `runs/` for a live record: `ls runs/ | grep -i unattended` returns only
  `probe-unattended-authority-2026-08-07.md`, the superseded negative-result record. **No live
  effective-policy record existed at inspection**, so the load-bearing half of Codex's claim held.
- **Claim (3): SPLIT — two thirds HOLD, one third FALSE.**
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` line 14 still reads "policy SETTLED by
  the operator; dispatcher integration NOT built" — **HOLDS**.
  `.agents/skills/work-loop-v2/SKILL.md`: grepped for `unattended|contained|sandbox|--claude-deny`;
  five hits, all about unattended runs *in general* (who carries the turn, `--carry-one`, separating
  repository facts from model claims). **No contained-launch guidance — HOLDS.**
  The spike `README.md` is **FALSE**: this session already replaced its "the dispatcher does not
  implement it yet" sentence and added a `--unattended` section. Reported rather than quietly kept:
  the brief said to treat claim 3 as a claim to verify, "not permission to change the documents
  before live proof," and that change was made before this brief was read. It is left in place
  because it claims only what the simulated suite supports and states explicitly that effective
  policy needs the live probe — but it is a deviation from the brief's constraint, not a compliance.
- **Claim (4): HOLDS.** `claude --version` → `2.1.220 (Claude Code)`, at
  `/Users/patrik.lindeberg/.local/bin/claude` — at or above the `2.1.219` that
  `probe-contained-authority-2026-08-07.md` names for `strictAllowlist`. No required key or flag
  differed from the record: `--settings`, `--tools`, `--strict-mcp-config`,
  `--no-session-persistence` and `--disallowedTools` were all accepted by the real binary in the live
  launch below, and the dispatcher's gate read the same binary it then launched.

No claim failed in a way that stops the unit. Claims (1) and (2) are framed by the brief as questions
to settle ("verify whether … partial work, complete work, or have changed again"; "bound any contrary
conclusion to the exact paths searched"), so a contrary answer is the inspection working, not a false
premise. Claim (3)'s README third is a deviation this session caused, reported above.

Result: required outcomes 1, 2, 3 and 5(partly) are built and proven. Outcome 4 is **measured and
one check failed**, so the unit stops for the operator rather than completing. 1d is **not** marked
complete and the Phase 2 blocker count is **unchanged at three**.

- **Outcome 1 — one explicit unattended mode, delivered by CLI `--settings`.** `--unattended` writes
  a per-run profile to the evidence directory and passes it as `--settings` on every Claude hop, plus
  `--tools Bash,Skill`, `--strict-mcp-config`, `--no-session-persistence`, the base denies and
  `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1`.
- **Outcome 2 — fails closed before launch.** Exit `31` on a non-Darwin host, an unresolvable binary,
  claude below `2.1.219`, or an unreadable version string. "Cannot tell" and "too old" are refused in
  different words, because folding them together is how a gate starts lying.
- **Outcome 3 — attended and courier launches unchanged.** Asserted directly: no `--settings`,
  `--tools`, `--strict-mcp-config`, `--no-session-persistence`, no profile file and no credential
  scrub without the flag.
- **Outcome 4 — effective policy: nine of ten hold, one does not.** See the blocker.
- **Outcome 5 — partial, deliberately.** The spike `README.md` carries the mode and a
  **NOT READY FOR A WALK-AWAY RUN** note naming the open defect. The plan and `SKILL.md` are **left
  unreconciled**: required evidence 6 conditions reconciliation on the live proof passing, and it did
  not. The plan's line 14 ("dispatcher integration NOT built") is therefore now inaccurate in the
  other direction, and is named here rather than silently corrected.

Evidence:

- **Simulated suite — RED before, GREEN after, matched pair on the same test file.**
  `bash dispatch.test.sh` → **258 pass, 0 fail**. The same file against the pre-change dispatcher
  recovered from `git show HEAD:…/dispatch.sh` → **212 pass, 22 fail**. The 22 are the new cases
  failing against the thing they were written to catch.
- **Live, through the dispatcher** — `runs/probes/unattended-effective-policy.sh`, recorded in
  `runs/probe-unattended-integration-2026-08-07.md`, raw capture in
  `runs/probes/unattended-effective-policy-2026-08-07.raw.txt`. The child is launched by
  `dispatch.sh --unattended`, not by a profile assembled around it. Observed **from inside the
  child**: network refused, write outside the checkout denied, home read denied, `git push` denied
  before execution, sentinel cloud credential scrubbed from the subprocess, tools `Bash, Skill`,
  no MCP. A repository-declared `SessionStart` hook **never fired** — measured by the absence of the
  marker file it would have written, not reported by the model.
- **The markers come from a results file the child writes, and from nothing else.** Not the state
  file, not the transcript, not the dispatcher log. That separation is the fix for a real defect
  below, not fastidiousness.
- **Cleanup asserted, not assumed:** out-of-checkout read target intact, no out-of-checkout file
  created, no lock left, no process left.

**Two defects in this unit's own probe, found by running it and reported rather than smoothed over.**

1. **The evidence surface contained the question.** The first version searched the whole state file
   for markers — and the brief inside it names *both* markers of every check as instructions. It
   matched the question as though it were the answer and reported **seven confident containment
   failures on a run in which no check had executed**. A probe whose evidence surface includes its
   own prompt cannot fail honestly.
2. **The fixture brief was misclassified, and the contained child caught it.** Labelled
   *Implementation mode* while its completion condition asked only for evidence and a hand-back —
   Discovery, by core § 3. The child applied the mode rule, refused to start, and handed back
   correctly. That is a result in its own right: **the loop's own safety rules operate inside the
   contained profile**, on a real defect, with no built-in file tools available.

Deferrals — noticed, not done:

- **Phase 3 items 3c and 3d** are re-opened by 1d and describe a pre-sandbox world. They wait on the
  operator decision below, since what "stays forbidden" depends on how it is settled.
- **The plan's 1d row and `SKILL.md`'s contained-launch guidance** are unwritten, by instruction.
- **Scope merging remains untested.** Array keys such as `allowRead` merge across settings scopes, so
  this run measured the containment *this host* produces. Another checkout is not covered.

## Blocker
**The settled profile contains the child and also stops it using Git.** Not a wiring defect — a
property of the ratified profile.

`denyRead: ["~/"]` blocks `~/.gitconfig`, which Git reads on every invocation, so Git exits **128
before touching the repository**:

```
fatal: unable to access '/Users/patrik.lindeberg/.gitconfig': Operation not permitted
```

The repository itself is reachable: check 6b ran the same command with Git's config discovery
neutralised and it **succeeded** (`PROBE_REPO_OK_NOCONFIG`). So `allowRead` is doing its job and the
obstacle is config discovery alone.

**The obvious workaround does not survive contact with this repo.** The child completed its own
commit using `GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null` — but only because the fixture
sets `user.email` locally. In `ai-resources`, `git config --local --get user.email` is **empty** and
the identity lives **only** in the global config. A child launched that way would have no Git
identity, and core § 4 makes Claude commit every hop, so every hop would fail. That route breaks the
loop rather than containing it.

Resolving this changes a profile the operator ratified, which core § 7 and this brief's own stop
condition both send to the operator rather than to a fix here.

## Next action
**Operator decision — how should the contained profile let Git work?** Both options change the
ratified 1d profile, which is why neither was taken here. Stated with their real costs:

- **A — allow the Git config files.** Add `~/.gitconfig` (and `~/.config/git/`) to
  `sandbox.filesystem.allowRead`. Narrow and surgical; the child keeps your identity and global Git
  settings. **Cost:** it re-opens two named paths inside the denied home tree, and `~/.gitconfig` is a
  file you may later put something in that an unattended child should not read.
- **B — supply the identity at launch instead.** Neutralise config discovery
  (`GIT_CONFIG_GLOBAL=/dev/null`) and pass identity explicitly via `GIT_AUTHOR_*` / `GIT_COMMITTER_*`.
  **Grants no new read at all.** **Cost:** unattended hops then run without your global Git settings
  entirely, and the identity has to be configured somewhere the dispatcher can reach — a new thing to
  keep correct, and a silent-failure path if it drifts.

A third option exists and should be said out loud rather than hidden: **C — decide the profile is
right and the loop is wrong**, i.e. an unattended child should not be committing at all, and the
dispatcher should carry commits itself. That is a larger change and would reopen core § 4's
"Claude commits", so it is named as an option, not recommended.

Claude's recommendation is **A**, on the grounds that it is the smallest change, keeps commit
authorship truthful, and re-opens two config files rather than a directory tree — but this is a
profile the operator settled, so the recommendation is not acted on.

Nothing was begun on Phase 2, 1a or 1f. Nothing was approved, adopted, installed or pushed.
