#!/usr/bin/env bash
# tests/cli/init.test.sh — covers `pageworks init`
#
# Scenarios:
#   1. Default init scaffolds docs.yaml + index.md + 3 sections + placeholder pages
#   2. --minimal scaffolds only docs.yaml + index.md
#   3. Repeat init is non-destructive (idempotent)
#   4. --name <slug> overrides project name in docs.yaml
#   5. Default init populates Diátaxis type: in placeholder page frontmatter
#   6. docs.yaml includes commented renderers: example
#   7. Empty docs/ folder is filled with manifest + sections
#   8. init --help shows usage
#   9. --preset platform scaffolds 6 Main Topic Categories

set -u

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLI="$REPO_ROOT/cli/pageworks"

fail_count=0
pass_count=0

assert_file_exists() {
  if [[ -f "$1" ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected file: $1"; fail_count=$((fail_count + 1)); fi
}
assert_dir_exists() {
  if [[ -d "$1" ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected dir: $1"; fail_count=$((fail_count + 1)); fi
}
assert_file_absent() {
  if [[ ! -e "$1" ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected absent: $1"; fail_count=$((fail_count + 1)); fi
}
assert_file_contains() {
  if [[ -f "$1" ]] && grep -qF "$2" "$1"; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected '$1' to contain '$2'"; fail_count=$((fail_count + 1)); fi
}
assert_contains() {
  if echo "$1" | grep -qF "$2"; then pass_count=$((pass_count + 1))
  else echo "    ✗ output missing: $2"; fail_count=$((fail_count + 1)); fi
}

run_cli() {
  local dir="$1"; shift
  (cd "$dir" && "$CLI" "$@" 2>&1)
}

scenario_1_default_init() {
  echo "Scenario 1: default init scaffolds docs/ + manifest + index + 3 sections"
  local dir="/tmp/pageworks-init-test-1"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init >/dev/null

  assert_dir_exists "$dir/docs"
  assert_file_exists "$dir/docs/docs.yaml"
  assert_file_exists "$dir/docs/index.md"
  assert_dir_exists "$dir/docs/getting-started"
  assert_file_exists "$dir/docs/getting-started/install.md"
  assert_file_exists "$dir/docs/getting-started/quickstart.md"
  assert_file_exists "$dir/docs/getting-started/concepts.md"
  assert_dir_exists "$dir/docs/guides"
  assert_dir_exists "$dir/docs/reference"

  rm -rf "$dir"
}

scenario_2_minimal() {
  echo "Scenario 2: --minimal scaffolds only manifest + index"
  local dir="/tmp/pageworks-init-test-2"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init --minimal >/dev/null

  assert_file_exists "$dir/docs/docs.yaml"
  assert_file_exists "$dir/docs/index.md"
  assert_file_absent "$dir/docs/getting-started"
  assert_file_absent "$dir/docs/getting-started/install.md"

  rm -rf "$dir"
}

scenario_3_idempotent() {
  echo "Scenario 3: repeat init is non-destructive"
  local dir="/tmp/pageworks-init-test-3"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init >/dev/null
  echo "USER_EDIT" > "$dir/docs/index.md"

  local output
  output=$(run_cli "$dir" init)

  assert_file_contains "$dir/docs/index.md" "USER_EDIT"
  assert_contains "$output" "docs.yaml"

  rm -rf "$dir"
}

scenario_4_name_override() {
  echo "Scenario 4: --name overrides project name in docs.yaml"
  local dir="/tmp/pageworks-init-test-4"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init --name my-custom-name >/dev/null

  assert_file_contains "$dir/docs/docs.yaml" "name: my-custom-name"
  assert_file_contains "$dir/docs/index.md" "title: my-custom-name"

  rm -rf "$dir"
}

scenario_5_diataxis_type_in_pages() {
  echo "Scenario 5: placeholder pages get Diátaxis type: in frontmatter"
  local dir="/tmp/pageworks-init-test-5"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init >/dev/null

  assert_file_contains "$dir/docs/getting-started/install.md" "type: tutorial"
  assert_file_contains "$dir/docs/getting-started/quickstart.md" "type: tutorial"
  assert_file_contains "$dir/docs/getting-started/concepts.md" "type: explanation"

  rm -rf "$dir"
}

scenario_6_renderers_example_in_manifest() {
  echo "Scenario 6: docs.yaml includes commented renderers: example"
  local dir="/tmp/pageworks-init-test-6"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init >/dev/null

  assert_file_contains "$dir/docs/docs.yaml" "# renderers:"
  assert_file_contains "$dir/docs/docs.yaml" "#   mkdocs:"
  assert_file_contains "$dir/docs/docs.yaml" "#   docusaurus:"

  rm -rf "$dir"
}

scenario_7_existing_empty_docs() {
  echo "Scenario 7: pre-existing empty docs/ is filled, not failed"
  local dir="/tmp/pageworks-init-test-7"
  rm -rf "$dir" && mkdir -p "$dir/docs"

  run_cli "$dir" init >/dev/null

  assert_file_exists "$dir/docs/docs.yaml"
  assert_file_exists "$dir/docs/index.md"

  rm -rf "$dir"
}

scenario_8_help() {
  echo "Scenario 8: init --help shows usage"
  local output
  output=$("$CLI" init --help 2>&1)
  assert_contains "$output" "pageworks"
  assert_contains "$output" "init"
}

scenario_9_preset_platform() {
  echo "Scenario 9: --preset platform scaffolds 6 Main Topic Categories"
  local dir="/tmp/pageworks-init-test-9"
  rm -rf "$dir" && mkdir -p "$dir"

  run_cli "$dir" init --preset platform >/dev/null

  assert_dir_exists "$dir/docs/getting-started"
  assert_dir_exists "$dir/docs/architecture"
  assert_dir_exists "$dir/docs/services"
  assert_dir_exists "$dir/docs/operations"
  assert_dir_exists "$dir/docs/reference"
  assert_dir_exists "$dir/docs/standards"
  assert_file_contains "$dir/docs/docs.yaml" "id: architecture"
  assert_file_contains "$dir/docs/docs.yaml" "id: services"
  assert_file_contains "$dir/docs/docs.yaml" "id: operations"
  assert_file_contains "$dir/docs/docs.yaml" "id: standards"

  rm -rf "$dir"
}

echo "=== init.test.sh ==="
scenario_1_default_init
scenario_2_minimal
scenario_3_idempotent
scenario_4_name_override
scenario_5_diataxis_type_in_pages
scenario_6_renderers_example_in_manifest
scenario_7_existing_empty_docs
scenario_8_help
scenario_9_preset_platform

echo ""
echo "Results: ${pass_count} passed, ${fail_count} failed"
exit $((fail_count > 0))
