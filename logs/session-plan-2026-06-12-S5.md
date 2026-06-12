# Session Plan — 2026-06-12 S5 (permissions friday-act plan)

## Intent
Apply the 3 settings.json fixes in the permissions friday-act plan end-to-end, each `/risk-check`-gated before edit, committing each fix separately in its own repo, and verifying with `/permission-sweep --dry-run`.

## Model
Opus 4.8 (`claude-opus-4-8[1m]`) — match. Item 3 (deny-glob shadowing) carries a real decision; the three `/risk-check` gates are judgment work. Mechanical settings edits dominate the rest, but the decision + risk gating justify Opus.

## Source Material
- `audits/friday-plans/2026-06-12-permissions.md` — the 3-item plan (source of truth)
- `audits/friday-checkup-2026-06-12.md` — originating weekly-tier checkup report
- `docs/permission-template.md` — canonical settings-layer shapes (reference for correct keys)
- Targets:
  - `projects/interpersonal-communication/knowledge-base/.claude/settings.json` (item 1)
  - `knowledge-bases/strategic-os/.claude/settings.json` (item 2)
  - `knowledge-bases/marketing-communication/.claude/settings.json` (item 2)
  - `projects/axcion-brand-book/.claude/settings.json` (item 3)

## Findings / Items to Address

### Item 1 — [high] Stale Daniel-machine path in interpersonal-communication KB settings
`additionalDirectories` points at `/Users/danielniklander/...`, which does not exist on this machine → the ai-resources symlinks fail for this nested KB. Replace with the correct machine-relative / portable path. Risk-check required (change class: settings.json).

### Item 2 — [med] Missing bypassPermissions + additionalDirectories on two KB settings
`knowledge-bases/strategic-os` and `knowledge-bases/marketing-communication` settings lack `defaultMode: bypassPermissions` and `additionalDirectories` → permission prompts fire and ai-resources symlinks won't resolve in KB sessions. Add both keys per `docs/permission-template.md`. Auditor rated ADVISORY; findings-extractor flagged HIGH on operational impact (do-soon). Risk-check required.

### Item 3 — [med] Brand-book deny-glob shadows explicit allows
Deny glob `0[1-8]_*.md` silently overrides explicit allow entries for `02_color.md` / `03_typography.md`. Decision: narrow the deny glob, or drop the conflicting allows. Edit settings.json accordingly. Risk-check required.

## Execution Sequence
1. **Item 1 (high) first.** Read the target settings.json + `docs/permission-template.md`. Run `/risk-check` on the path fix. On GO, derive the correct portable/machine-relative path (confirm by checking the actual ai-resources location), edit, verify by reading back, commit in the KB's repo.
2. **Item 2.** Read both KB settings + the canonical template. Run `/risk-check` (the two edits are one change class; one risk-check covers both). On GO, add `defaultMode: bypassPermissions` + `additionalDirectories` to each, verify, commit each separately.
3. **Item 3.** Read the brand-book settings. Run `/risk-check`. Decide deny-narrow vs allow-drop (default lean: narrow the deny glob to exclude the explicitly-allowed files, preserving the broad deny intent). Edit, verify, commit.
4. **Verify.** Run `/permission-sweep --dry-run` across the layers to confirm clean. Report residual findings if any.
5. Leave commits unpushed (push is gated to `/wrap-session`).

## Scope Alternatives
- **Full plan (all 3 items)** — chosen. Coherent unit; the [high] item is the priority but the two [med] items are cheap same-class edits done in the same gated pass.
- **High-item only** — defer the 2 [med] items. Available fallback if any risk-check returns RECONSIDER/NO-GO or context tightens; the [high] Daniel-path fix is the must-do.
- **Defer all** — rejected; the operator explicitly picked this plan.

## Autonomy Posture
Gated. All 3 items are settings.json/permission changes — a structural change class under workspace Autonomy Rule #9. Each item runs `/risk-check` before its edit. On RECONSIDER/NO-GO for any item, pause and surface; mandate + plan retained on disk.

## Risk
- **Structural risk: true** (permission-surface changes ×3).
- Item 1 portable-path derivation must be verified against the actual on-disk ai-resources location, or the symlink stays broken (different failure, same symptom).
- Cross-repo commits: each target lives in a separate KB/project git repo → commit in the correct repo, not ai-resources.
- Concurrent session live in this checkout; none of the 4 targets overlap the foreign-dirty `improvement-log.md` — no collision. Mission WIP in the working tree left untouched.
