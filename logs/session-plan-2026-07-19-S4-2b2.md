# Session Plan — 2026-07-19 S4-2b2

## Intent

Run three verified-open repo-health fixes in order: (1) `check-foreign-staging.sh` resolves a gated `git add` against the wrong repo inside a nested project repo; (2) mission thread 14 — three hooks that ship looking installed and fire nowhere; (3) delete one falsified sentence from `/prime` Step 3.

Mission: `repo-health-backlog-2026-07`. Serves Goal clause (c) — "the audit tooling that feeds this backlog stops emitting findings that are false, stale, or mis-attributed" — for items 1 and 4; item 6 is Goal clause (a) hygiene.

## Model

**opus** — matches the active session model. Item 4 is a repair-or-delete judgment on a live-looking guard, and item 1's fix has a genuine design uncertainty (below); neither is mechanical.

## Source Material

- `logs/improvement-log.md:1488-1516` — item 1, the wrong-repo staging block. Observed, not inferred: workspace-root session S2-e73, 2026-07-19.
- `logs/missions/repo-health-backlog-2026-07.md:146` — thread 14, merged from three separately-logged items sharing one cause.
- `.claude/commands/prime.md:224` — item 6, the stale sentence.
- `logs/session-notes.md` 2026-07-19 S3-0e6 — prior session routed item 6 to follow-up rather than folding it into an unrelated commit.

## Findings / Items to Address

### Item 1 — staging hook resolves the wrong repo

- `check-foreign-staging.sh:223` reads `project_dir = os.environ.get("CLAUDE_PROJECT_DIR", "") or os.getcwd()`; `:224` derives `repo_root` from it. `CLAUDE_PROJECT_DIR` is the *session's* project dir — the workspace root when the session opened there — not the repo the `git add` actually targets.
- `:228-229` then build `logs_dir` and `repo_name` off that wrong root, so both the exempt-list lookup and the footprint prefix-stripping are computed in the wrong coordinate system.
- Two distinct failure modes, both observed: (a) workspace-root dirty paths reported as "foreign" for a command that could never stage them — two of the six flagged paths do not exist in the target repo at all; (b) a path-string collision — `logs/innovation-registry.md` exists in *both* repos as different files, and repo-relative string comparison reads them as the same file.
- **The prescribed remedy is unreachable for this failure mode.** Routing the file into `Files in scope` / `Required outputs` was applied and the block re-fired identically, because the flagged paths were never going to be staged. A guard whose only escape is a bypass trains the bypass.
- **Open design question, to establish by execution before editing:** the improvement-log proposal says derive the toplevel "from the Bash call's cwd" — but a PreToolUse hook does not obviously receive that cwd. The payload carries `tool_input.command`, not a working directory. Establish first what cwd the hook process actually runs with, and whether the Bash tool's persistent cwd is visible to it. If it is not, the fix shape changes: prefer the soft warn over the hard block whenever the resolved toplevel cannot be confirmed to match the footprint's coordinate system.

### Item 4 — thread 14, three hooks wired to fire nowhere

- **(a) `warn-settings-change.sh`** — lives at workspace-root `.claude/hooks/`, not in ai-resources. `:6` reads `d.get('file_path')` where the PreToolUse payload nests it under `tool_input`, so on a real payload it extracts empty string, matches nothing, and **exits 0 — allows**. Verified registered in **zero** settings files across the workspace (`grep -rl "warn-settings-change" --include="*.json"` → no hits). It is a blocking gate that has never blocked anything.
- **Actively replicating** — it is cited in `audits/risk-checks/2026-07-14-repo-repair-pilot-v1…:13` as "proof the `exit 2` pattern works" and queued to be copied as a reference implementation. Copying it ships the repo's most-repeated defect class (inert safeguard) into a new guard.
- **(b) `check-claim-ids.sh`** — 7 copies on disk (workflow template, 5 project deployments, 1 archive). Confirmed by direct inspection of `workflows/research-workflow/.claude/settings.json`: the template ships the script and registers it **nowhere**. Every project deployed from the template inherits a script that cannot fire.
- **(c) friction-log auto-capture** — ai-resources registers `friction-log-auto.sh` on **both** `PreToolUse|Skill` and `PostToolUse|Bash|Write|Edit|Agent|Skill`. The template registers it on `PreToolUse|Skill` **only**, so the PostToolUse capture branch is dead in the template and in every deployment.
- **Scope boundary, load-bearing:** the mission's non-negotiable forbids reaching into project repos. Actionable here: the workspace-root file (thread 14 names it specifically) and the research-workflow template. The 5 project deployments get surfaced and routed, not edited.

### Item 6 — stale prose in `/prime`

- `prime.md:224` asserts "As of 2026-07-18, 30 of 87 entries carry no `Severity` field at all". Falsified: the 2026-07-18 backfill took the count to 0, and the scan's own third probe prints nothing when the count is zero.
- **Line-number drift corrected:** thread 15 and the prior session's notes both cite `:220`. It is at `:224` after this morning's `4066dc4`. Verified by `grep -n "30 of 87"`.
- `prime.md` has 26 verified consumers by symlink, so even a one-sentence deletion goes through the gate rather than being folded into an unrelated commit — the prior session's stated reason for deferring it.

## Execution Sequence

### Stage 0 — `/risk-check` (all three items, one pass)

Three structural classes: a hook edit with a blast radius across every commit path; a template/wiring change inherited by every future deployment; a 26-consumer command edit. Gate before any edit. On RECONSIDER or NO-GO for an item, that item stops and the verdict is recorded; the other items proceed only if the verdict is item-scoped.

### Stage 1 — Item 1: staging hook repo resolution

1. Establish by execution what cwd the hook process runs with and whether the Bash call's target repo is derivable. This decides the fix shape.
2. Build a fixture: a nested `git init` repo inside a dirty parent, with a same-named `logs/` file in both — reproduce the false BLOCK. **The reproduction must fail before the fix**, or the test proves nothing.
3. Apply the fix: resolve the toplevel from the call's own coordinate system, run the `git` probes with `-C <that toplevel>`, and relativize footprint paths against the same root.
4. Verify both directions: the false block stops firing, **and** a genuine foreign-staging case still blocks. A fix that only removes blocks is indistinguishable from disabling the guard.

### Stage 2 — Item 4: thread 14

1. **(a) Decide repair-or-delete on `warn-settings-change.sh`.** Recommendation: **delete the orphan.** It is registered nowhere, it fails open on the real payload shape, and repairing it means wiring a *blocking* gate into ~70 settings files — a permissions-surface change the operator's standing architecture (`bypassPermissions` floor + model-side rules) points away from. Deleting also removes the reference implementation that is queued to be copied. Record the decision either way; leaving it unranked is the failure mode thread 14 names.
2. **(b)** Wire `check-claim-ids.sh` in the research-workflow template, or remove it from the template if it has no live consumer. Decide on evidence, not by default.
3. **(c)** Bring the template's friction-log registration into line with ai-resources' (add the PostToolUse branch), or record why the template should differ.
4. Route the 5 project-repo copies to a follow-up entry — surfaced, not reached into.

### Stage 3 — Item 6: delete the stale sentence

Delete the falsified clause at `prime.md:224`, leaving the surrounding design rationale intact (the "count, not a content read" argument stands on its own; only the specific stale figure is false).

### Stage 4 — Mission bookkeeping

Record thread 5's shipped evidence in the mission file with the commit sha and file:line citations, so the next session does not re-surface it as open work. Do **not** hand-tick — the mission's own rule treats hand-ticking as the unverified-tick mechanism thread 12 exists to fix. Record the evidence; leave the tick.

### Stage 5 — Commit

Commit per workspace rules. Do not push.

## Scope Alternatives

- **Narrower (if the gate pushes back):** items 6 and 4(a) only — a one-sentence deletion plus one delete-the-orphan decision. Both are small, both are verified, and neither depends on the other. Item 1 is the largest and most uncertain; it can stand alone in its own session.
- **Narrower still:** item 6 alone. It is the one item with zero design content.
- **Wider (rejected):** fixing the 5 project-repo `check-claim-ids.sh` copies. Forbidden by the mission's non-negotiable, and it would convert a template fix into a 5-repo sweep.

## Autonomy Posture

**Gated.** Three structural change classes → `/risk-check` before execution per workspace Autonomy rule #9. Within the gate's verdict, full autonomy on implementation. Operator decisions already taken: bundle approved at the Step 8c.6 gate, including the stated delete-the-orphan recommendation for 4(a).

## Risk

- **Item 1 is the real risk.** `check-foreign-staging.sh` is 668 lines and gates every commit path in the workspace. A wrong fix either re-opens the fail-open the 2026-07-18 work closed, or hard-blocks legitimate commits more broadly than today. Mitigation: the two-direction verification in Stage 1.4 — the guard must still block a genuine foreign stage after the fix.
- **Item 4(a) deletes a file.** Deletion is the recommendation, not a certainty; it is reversible by git, and the file is registered nowhere, so nothing loses protection it currently has.
- **Item 6 touches a 26-consumer file** via atomic symlink propagation. Blast radius is wide but the change is a deletion of a false statement, with no behavioural surface.
- **Known context risk:** this session's own orientation surfaced already-shipped work as open (menu item 2). Every "still open" claim in this plan was re-verified against the live files before being written here — items 1, 4, and 6 each cite a file:line or a command output, not the backlog text.
