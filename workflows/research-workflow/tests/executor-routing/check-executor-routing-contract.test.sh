#!/usr/bin/env bash
set -u

repo_root="${1:-$(cd "$(dirname "$0")/../../../.." && pwd)}"
failures=0

require_literal() {
  local file="$1"
  local literal="$2"
  local label="$3"

  if ! grep -Fq -- "$literal" "$repo_root/$file"; then
    printf 'FAIL: %s\n' "$label"
    failures=$((failures + 1))
  fi
}

forbid_literal() {
  local file="$1"
  local literal="$2"
  local label="$3"

  if grep -Fq -- "$literal" "$repo_root/$file"; then
    printf 'FAIL: %s\n' "$label"
    failures=$((failures + 1))
  fi
}

config_template="workflows/research-workflow/CLAUDE.md.template"
config_schema="workflows/research-workflow/docs/project-config-schema.md"
manifest_skill="skills/execution-manifest-creator/SKILL.md"
manifest_template="skills/execution-manifest-creator/references/manifest-template.md"
prompt_skill="skills/research-prompt-creator/SKILL.md"
prompt_qc_skill="skills/research-prompt-qc/SKILL.md"
supplementary_qc_skill="skills/supplementary-research-qc/SKILL.md"
supplementary_merge_skill="skills/supplementary-evidence-merger/SKILL.md"
run_execution="workflows/research-workflow/.claude/commands/run-execution.md"
run_analysis="workflows/research-workflow/.claude/commands/run-analysis.md"
stage_instructions="workflows/research-workflow/reference/stage-instructions.md"
setup="workflows/research-workflow/SETUP.md"
deploy_command=".claude/commands/deploy-workflow.md"
supplementary_query_pass1="prompts/supplementary-research/S1-query-brief-pass1.md"
supplementary_query_pass2="prompts/supplementary-research/S1-query-brief-pass2.md"
supplementary_results_qc="prompts/supplementary-research/S3-qc-supplementary-results.md"
supplementary_merge_prompt="prompts/supplementary-research/S4-merge-instructions.md"

for file in \
  "$config_template" \
  "$config_schema" \
  "$manifest_skill" \
  "$manifest_template" \
  "$prompt_skill" \
  "$prompt_qc_skill" \
  "$supplementary_qc_skill" \
  "$supplementary_merge_skill" \
  "$run_execution" \
  "$run_analysis" \
  "$stage_instructions" \
  "$setup" \
  "$deploy_command" \
  "$supplementary_query_pass1" \
  "$supplementary_query_pass2" \
  "$supplementary_results_qc" \
  "$supplementary_merge_prompt"
do
  if [[ ! -f "$repo_root/$file" ]]; then
    printf 'FAIL: missing contract surface %s\n' "$file"
    failures=$((failures + 1))
  fi
done

require_literal "$config_template" '**Evidence executor:** "{{EVIDENCE_EXECUTOR}}"' \
  "project template declares the evidence executor"
require_literal "$config_template" '**Evidence executor capabilities:** [{{EVIDENCE_EXECUTOR_CAPABILITIES}}]' \
  "project template declares executor capabilities"
require_literal "$config_template" '**Supplementary lead provider:** "{{SUPPLEMENTARY_LEAD_PROVIDER}}"' \
  "project template separates supplementary leads"

require_literal "$config_schema" '`Evidence executor`' \
  "config schema documents the evidence executor"
require_literal "$config_schema" '`Evidence executor capabilities`' \
  "config schema documents capability eligibility"
require_literal "$config_schema" '`Supplementary lead provider`' \
  "config schema documents the supplementary role"
require_literal "$config_schema" '`full-source-access`' \
  "config schema defines full-source access"
require_literal "$config_schema" '`lossless-artifact-handoff`' \
  "config schema defines lossless handoff"
require_literal "$config_schema" '`native-language-search`' \
  "config schema defines native-language eligibility"
require_literal "$config_schema" '`audit-log`' \
  "config schema defines audit-log eligibility"
require_literal "$config_schema" '`required-output-schema`' \
  "config schema defines output-schema eligibility"

require_literal "$manifest_skill" 'Project Config executor-routing fields' \
  "manifest consumes the one project routing authority"
require_literal "$manifest_skill" 'No qualifying evidence executor' \
  "manifest fails visibly when no executor qualifies"
require_literal "$manifest_skill" 'Supplementary leads are not evidence of record' \
  "manifest keeps leads separate from evidence"
require_literal "$manifest_template" '| Question ID | Question Short Title | Execution Role | Evidence Executor | Supplementary Leads | Routing Rationale |' \
  "manifest output exposes role, executor, and leads separately"
require_literal "$manifest_template" 'Mechanical / no research' \
  "manifest exposes the no-research mechanical role"
require_literal "$manifest_template" '| Session | Questions | Search Mode | Required Capabilities | Eligibility | Dependencies | Executor |' \
  "manifest output records capability eligibility"

require_literal "$run_execution" 'Read the `## Project Config` executor-routing fields from `CLAUDE.md`' \
  "Stage 2 passes the canonical routing authority into manifest creation"
require_literal "$run_execution" 'STALE MANIFEST — regenerate Step 2.0' \
  "prompt creation refuses a manifest that disagrees with current Project Config"
require_literal "$run_execution" 'This is the sole supplementary evidence input to Step 2.S3.' \
  "supplementary provider output must be verified by the evidence executor"
require_literal "$stage_instructions" 'project-configured evidence executor' \
  "Stage instructions use the project-approved executor"
require_literal "$run_analysis" 'Raw lead-provider output is not an input.' \
  "Stage 3 supplementary QC refuses raw provider output"
require_literal "$run_analysis" 'cluster-NN-executor-verified-pass-N.md' \
  "Stage 3 requires an executor-verified supplementary report"
require_literal "$prompt_skill" 'assigned evidence executor' \
  "prompt creation is executor-neutral"
require_literal "$prompt_qc_skill" 'assigned evidence executor' \
  "prompt QC is executor-neutral"
require_literal "$supplementary_qc_skill" 'Raw lead-provider output is not an input.' \
  "supplementary QC refuses unverified provider output"
require_literal "$supplementary_merge_skill" 'Raw lead-provider output is ineligible.' \
  "supplementary merge refuses unverified provider output"
require_literal "$supplementary_query_pass1" 'configured supplementary lead provider' \
  "pass-1 query brief is provider-configured"
require_literal "$supplementary_query_pass2" 'Pass 1 evidence-executor-verified report' \
  "pass-2 diagnosis uses verified evidence"
require_literal "$supplementary_results_qc" 'Raw lead-provider output is not an input.' \
  "legacy supplementary QC prompt refuses provider-only output"
require_literal "$supplementary_merge_prompt" 'Raw lead-provider output is ineligible for merge.' \
  "legacy supplementary merge prompt refuses provider-only output"
require_literal "$setup" '{{EVIDENCE_EXECUTOR}}' \
  "setup exposes evidence-executor configuration"
require_literal "$setup" '{{EVIDENCE_EXECUTOR_CAPABILITIES}}' \
  "setup exposes executor-capability configuration"
require_literal "$setup" '{{SUPPLEMENTARY_LEAD_PROVIDER}}' \
  "setup exposes supplementary-provider configuration"
require_literal "$deploy_command" '{{EVIDENCE_EXECUTOR}}' \
  "deployment registers evidence-executor configuration"
require_literal "$deploy_command" '{{EVIDENCE_EXECUTOR_CAPABILITIES}}' \
  "deployment registers executor-capability configuration"
require_literal "$deploy_command" '{{SUPPLEMENTARY_LEAD_PROVIDER}}' \
  "deployment registers supplementary-provider configuration"

forbid_literal "$manifest_skill" '### Route to Research GPT when:' \
  "manifest no longer routes by the Research GPT product name"
forbid_literal "$manifest_skill" '### Route to CustomGPT when:' \
  "manifest no longer assumes a CustomGPT lane"
forbid_literal "$manifest_template" '## Research GPT Sessions' \
  "manifest template no longer hard-codes Research GPT sessions"
forbid_literal "$manifest_template" '## CustomGPT Research Queue' \
  "manifest template no longer hard-codes a CustomGPT queue"
forbid_literal "$prompt_skill" 'produce a best-effort prompt using the Research GPT format' \
  "unknown executors do not silently inherit a Research GPT format"
forbid_literal "$prompt_qc_skill" 'uses them in Research GPT' \
  "prompt QC no longer assumes a Research GPT target"
forbid_literal "$run_execution" 'Research execution happens in the Research Execution GPT (primary)' \
  "run-execution no longer declares a contradictory primary"
forbid_literal "$stage_instructions" 'Research Execution GPT or Perplexity' \
  "Stage instructions no longer declare product-specific primary lanes"
forbid_literal "$run_analysis" 'Execute in Perplexity' \
  "Stage 3 no longer hard-codes the supplementary provider"
forbid_literal "$supplementary_results_qc" 'Raw Perplexity output' \
  "legacy supplementary QC prompt no longer accepts raw provider output"
forbid_literal "$supplementary_merge_prompt" 'carry over source name(s) and URL(s) from the Perplexity results' \
  "legacy merge prompt no longer accepts provider citations directly"
forbid_literal "$config_template" 'Research Execution GPT produces evidence (Stage 2)' \
  "project template no longer contradicts its executor config"

if (( failures > 0 )); then
  printf 'Executor-routing contract: FAIL (%d finding(s))\n' "$failures"
  exit 1
fi

printf 'Executor-routing contract: PASS\n'
