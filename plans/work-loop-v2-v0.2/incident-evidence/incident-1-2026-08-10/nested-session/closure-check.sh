#!/bin/bash
# Bounded closure check for the correction round.
# Question: are findings 1-3 resolved, and did the corrections break the
# previously verified command contracts? Re-runs only the cases the three
# edits could plausibly have broken, against FRESH fixtures carrying the
# corrected command bodies.
S="/private/tmp/claude-501/-Users-patrik-lindeberg-Claude-Code-Axcion-AI-Repo-ai-resources-diagnostics-workflow/053f3b80-6b6e-4b84-9252-0ac7b4b71d12/scratchpad"
FX="$S/fx"; RUNS="$S/runs"

# Refresh the corrected command bodies into the base fixtures.
SRC="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-diagnostics-workflow"
for R in "$FX/A" "$FX/B/ai-resources" "$FX/B/projects/proj"; do
  cp "$SRC/.claude/commands/resolve-incident.md" "$R/.claude/commands/"
  cp "$SRC/.claude/commands/resolve-repo-problem.md" "$R/.claude/commands/"
  git -C "$R" add -A >/dev/null 2>&1
  git -C "$R" -c user.email=f@f -c user.name=f commit -qm corrected >/dev/null 2>&1
done

# Restore the Direct Work fixture fault consumed by the earlier smoke run.
printf '# Fixture doc\n\nStep 4 — see `docs/does-not-exist-anywhere.md` for the routing table.\n' \
  > "$FX/A/docs/fixture-guide.md"
# Re-seed the pending improvement-log entry the transfer case needs.
cp "$SRC/.claude/commands/friday-act.md" "$FX/A/.claude/commands/" 2>/dev/null
cat >> "$FX/A/logs/improvement-log.md" <<'EOF'

### 2026-08-01 — entry-count.sh should read its threshold from the log header

- **Status:** logged (pending)
- **Category:** session-issue
- **Severity:** medium
- **Source:** /resolve-repo-problem 2026-08-01
- **Friction source:** The archival threshold is stated in prose in the log header while the checker hardcodes it; the two can drift apart silently.
- **Proposal:** Parse the threshold from the incident-log header instead of hardcoding it in logs/scripts/entry-count.sh.
- **Target files:** logs/scripts/entry-count.sh, logs/incident-log.md
- **Notes:** audits/working/2026-08-01-resolve-threshold-drift.md
EOF
git -C "$FX/A" add -A >/dev/null 2>&1
git -C "$FX/A" -c user.email=f@f -c user.name=f commit -qm reseed >/dev/null 2>&1

mkcopy() { rm -rf "$FX/$1"; cp -R "$FX/A" "$FX/$1"; }
run() {
  CASE="$1"; DIR="$2"; PROMPT="$3"
  ( cd "$DIR" && claude -p "$PROMPT" --permission-mode bypassPermissions \
      > "$RUNS/$CASE.out" 2> "$RUNS/$CASE.err" ; echo "exit=$? $CASE" >> "$RUNS/exits2.txt" ) &
}
: > "$RUNS/exits2.txt"

# X6  — Direct Work still exits on a genuinely small fix (finding 1's edit sits here).
mkcopy X6
run X6 "$FX/X6" '/resolve-incident "docs/fixture-guide.md line 3 cites docs/does-not-exist-anywhere.md, which does not exist in this repo — the routing table reference is dead and misroutes readers"'

# X6n — a non-small fault still enters the workflow (finding 1 must not widen the exit).
mkcopy X6n
run X6n "$FX/X6n" '/resolve-incident "logs/scripts/entry-count.sh reports the wrong number of incident entries — running it prints 2 but the log actually holds 4 entries, so the archival threshold check is wrong"'

# X4t — transfer still fires, and now validates applicability (finding 3's edit sits here).
mkcopy X4t
run X4t "$FX/X4t" '/resolve-incident "the improvement-log entry from 2026-08-01 about the hardcoded archival threshold in entry-count.sh is still sitting unactioned as logged (pending) — the proposed fix was never applied"'

# X3  — not confirmed still fires (previously verified contract; must not regress).
mkcopy X3
run X3 "$FX/X3" '/resolve-incident "docs/healthy-doc.md has a malformed ## heading that breaks the section parser, so every section after it is silently dropped"'

# Xq  — MANUAL queueing under the corrected Defer contract (finding 2's edit sits here).
mkcopy Xq
run Xq "$FX/Xq" '/resolve-repo-problem "logs/scripts/entry-count.sh reports the wrong number of incident entries — running it prints 2 but the log actually holds 4 entries, so the archival threshold check is wrong"'

wait
cat "$RUNS/exits2.txt"
