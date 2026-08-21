#!/usr/bin/env bash
# tests/integration/dogfood.test.sh — covers real-world dogfood verification of pageworks
#
# Scenarios:
#   1. Repository root docs/ passes pageworks doctor with 0 errors and 0 warnings
#   2. All 6 Main Topic Categories are present in docs/docs.yaml and on disk
#   3. Every page in docs/ has valid owner and last_reviewed frontmatter
#   4. mkdocs.yml exists, is valid YAML, and contains all active sections
#   5. .github/workflows/docs.yml exists and targets GitHub Pages deploy

set -u

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLI="$REPO_ROOT/cli/pageworks"

fail_count=0
pass_count=0

assert_file_exists() {
  if [[ -f "$1" ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected file: $1"; fail_count=$((fail_count + 1)); fi
}
assert_file_contains() {
  if [[ -f "$1" ]] && grep -qF "$2" "$1"; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected '$1' to contain '$2'"; fail_count=$((fail_count + 1)); fi
}
assert_exit() {
  local got="$1" want="$2" label="$3"
  if [[ "$got" -eq "$want" ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ $label: exit $got want $want"; fail_count=$((fail_count + 1)); fi
}
assert_contains() {
  if echo "$1" | grep -qF "$2"; then pass_count=$((pass_count + 1))
  else echo "    ✗ output missing: $2"; fail_count=$((fail_count + 1)); fi
}

scenario_1_repo_doctor_clean() {
  echo "Scenario 1: repository root docs/ passes doctor clean"
  local output exit_code=0
  if output=$(cd "$REPO_ROOT" && "$CLI" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  assert_exit "$exit_code" 0 "doctor exits 0"
  assert_contains "$output" "0 error(s), 0 warning(s), 0 info"
}

scenario_2_six_categories_present() {
  echo "Scenario 2: all 6 Main Topic Categories are present in manifest & disk"
  local manifest="$REPO_ROOT/docs/docs.yaml"
  assert_file_exists "$manifest"

  for sec in getting-started architecture services operations reference standards; do
    assert_file_contains "$manifest" "id: ${sec}"
    if [[ -d "$REPO_ROOT/docs/${sec}" ]]; then pass_count=$((pass_count + 1))
    else echo "    ✗ missing category directory: docs/${sec}"; fail_count=$((fail_count + 1)); fi
  done
}

scenario_3_frontmatter_governance() {
  echo "Scenario 3: all docs have owner and last_reviewed frontmatter"
  shopt -s nullglob
  for page in "$REPO_ROOT/docs"/*.md "$REPO_ROOT/docs"/*/*.md; do
    [[ -f "$page" ]] || continue
    assert_file_contains "$page" "owner:"
    assert_file_contains "$page" "last_reviewed:"
  done
  shopt -u nullglob
}

scenario_4_mkdocs_config_valid() {
  echo "Scenario 4: mkdocs.yml exists and contains all active sections"
  local mkfile="$REPO_ROOT/mkdocs.yml"
  assert_file_exists "$mkfile"
  assert_file_contains "$mkfile" "site_name: pageworks"
  assert_file_contains "$mkfile" "name: material"
  assert_file_contains "$mkfile" "Getting Started & Onboarding:"
  assert_file_contains "$mkfile" "Architecture & System Design:"
  assert_file_contains "$mkfile" "Services & Components:"
  assert_file_contains "$mkfile" "Operations & Reliability:"
  assert_file_contains "$mkfile" "API & Data Reference:"
  assert_file_contains "$mkfile" "Standards & Governance:"
}

scenario_5_github_actions_workflow() {
  echo "Scenario 5: .github/workflows/docs.yml exists and targets GitHub Pages"
  local wffile="$REPO_ROOT/.github/workflows/docs.yml"
  assert_file_exists "$wffile"
  assert_file_contains "$wffile" "Deploy docs"
  assert_file_contains "$wffile" "deploy-pages"
}

echo "=== dogfood.test.sh ==="
scenario_1_repo_doctor_clean
scenario_2_six_categories_present
scenario_3_frontmatter_governance
scenario_4_mkdocs_config_valid
scenario_5_github_actions_workflow

echo ""
echo "Results: ${pass_count} passed, ${fail_count} failed"
exit $((fail_count > 0))
