#!/usr/bin/env bash
# tests/cli/doctor.test.sh — covers `pageworks doctor`
#
# Scenarios:
#   1. No docs/ folder → silent (exit 0), info-only output
#   2. docs/ exists but no docs.yaml → error
#   3. Fresh init → doctor clean (0 errors, 0 warnings)
#   4. Declared page missing → error
#   5. Orphan page (on disk, not in docs.yaml) → warning
#   6. Page missing required frontmatter → error
#   7. Valid renderers: block → pass entries
#   8. Unknown renderer key under renderers: → warning
#   9. renderers: as scalar → error
#  10. renderers: as list → error
#  11. Page missing type: → info (Diátaxis recommendation)

set -u

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLI="$REPO_ROOT/cli/pageworks"

fail_count=0
pass_count=0

assert_contains() {
  if echo "$1" | grep -qF "$2"; then pass_count=$((pass_count + 1))
  else echo "    ✗ output missing: $2"; fail_count=$((fail_count + 1)); fi
}
assert_not_contains() {
  if ! echo "$1" | grep -qF "$2"; then pass_count=$((pass_count + 1))
  else echo "    ✗ output unexpectedly contains: $2"; fail_count=$((fail_count + 1)); fi
}
assert_exit() {
  local got="$1" want="$2" label="$3"
  if [[ "$got" -eq "$want" ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ $label: exit $got want $want"; fail_count=$((fail_count + 1)); fi
}

run_cli() {
  local dir="$1"; shift
  (cd "$dir" && "$CLI" "$@" 2>&1)
}

setup_docs() {
  local dir="$1"
  rm -rf "$dir" && mkdir -p "$dir"
  run_cli "$dir" init >/dev/null
}

scenario_1_no_docs() {
  echo "Scenario 1: no docs/ folder → silent (exit 0)"
  local dir="/tmp/pageworks-doctor-test-1"
  rm -rf "$dir" && mkdir -p "$dir"

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  assert_exit "$exit_code" 0 "exit 0"
  assert_contains "$output" "no docs/ folder"

  rm -rf "$dir"
}

scenario_2_no_manifest() {
  echo "Scenario 2: docs/ exists but no docs.yaml → error"
  local dir="/tmp/pageworks-doctor-test-2"
  rm -rf "$dir" && mkdir -p "$dir/docs"

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  if [[ $exit_code -ne 0 ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected non-zero exit"; fail_count=$((fail_count + 1)); fi
  assert_contains "$output" "docs.yaml missing"

  rm -rf "$dir"
}

scenario_3_clean() {
  echo "Scenario 3: fresh init → doctor clean"
  local dir="/tmp/pageworks-doctor-test-3"
  setup_docs "$dir"

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  assert_exit "$exit_code" 0 "clean exits 0"
  assert_contains "$output" "0 error(s)"
  assert_contains "$output" "docs.yaml present"

  rm -rf "$dir"
}

scenario_4_declared_missing() {
  echo "Scenario 4: declared page missing → error"
  local dir="/tmp/pageworks-doctor-test-4"
  setup_docs "$dir"

  rm "$dir/docs/getting-started/install.md"

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  if [[ $exit_code -ne 0 ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected non-zero exit"; fail_count=$((fail_count + 1)); fi
  assert_contains "$output" "declared in docs.yaml but file missing"

  rm -rf "$dir"
}

scenario_5_orphan() {
  echo "Scenario 5: orphan page → warning"
  local dir="/tmp/pageworks-doctor-test-5"
  setup_docs "$dir"

  cat > "$dir/docs/guides/orphan-page.md" <<'EOF'
---
title: Orphan
description: Not in docs.yaml.
section: guides
status: draft
updated: 2026-05-23
---
# Orphan
EOF

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "orphan"

  rm -rf "$dir"
}

scenario_6_missing_frontmatter() {
  echo "Scenario 6: page missing required frontmatter → error"
  local dir="/tmp/pageworks-doctor-test-6"
  setup_docs "$dir"

  cat > "$dir/docs/getting-started/install.md" <<'EOF'
---
title: Install
---
# Install
EOF

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  if [[ $exit_code -ne 0 ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected non-zero exit"; fail_count=$((fail_count + 1)); fi
  assert_contains "$output" "missing required frontmatter field"

  rm -rf "$dir"
}

scenario_7_renderers_valid() {
  echo "Scenario 7: valid renderers: block → pass entries"
  local dir="/tmp/pageworks-doctor-test-7"
  setup_docs "$dir"

  cat >> "$dir/docs/docs.yaml" <<'YAML'

renderers:
  mkdocs:
    theme: material
  docusaurus:
    preset: classic
YAML

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "renderers: block present (valid map)"
  assert_contains "$output" "renderers.mkdocs recognized"
  assert_contains "$output" "renderers.docusaurus recognized"

  rm -rf "$dir"
}

scenario_8_renderers_unknown() {
  echo "Scenario 8: unknown renderer key → warning"
  local dir="/tmp/pageworks-doctor-test-8"
  setup_docs "$dir"

  cat >> "$dir/docs/docs.yaml" <<'YAML'

renderers:
  mkdoc:
    theme: material
YAML

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "renderers.mkdoc is not a recognized"

  rm -rf "$dir"
}

scenario_9_renderers_scalar() {
  echo "Scenario 9: renderers: as scalar → error"
  local dir="/tmp/pageworks-doctor-test-9"
  setup_docs "$dir"

  cat > "$dir/docs/docs.yaml" <<'YAML'
site:
  name: scalar-test
sections:
  - id: foo
    title: Foo
    order: 1
    pages: []
renderers: oops
YAML

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "renderers: must be a map, got a scalar"

  rm -rf "$dir"
}

scenario_10_renderers_list() {
  echo "Scenario 10: renderers: as list → error"
  local dir="/tmp/pageworks-doctor-test-10"
  setup_docs "$dir"

  cat > "$dir/docs/docs.yaml" <<'YAML'
site:
  name: list-test
sections:
  - id: foo
    title: Foo
    order: 1
    pages: []
renderers:
  - mkdocs
  - docusaurus
YAML

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "renderers: must be a map, got a list"

  rm -rf "$dir"
}

scenario_11_missing_type_info() {
  echo "Scenario 11: page missing type: → info (Diátaxis recommendation)"
  local dir="/tmp/pageworks-doctor-test-11"
  setup_docs "$dir"

  # Rewrite install.md without type:
  cat > "$dir/docs/getting-started/install.md" <<'EOF'
---
title: Install
description: Install the thing.
section: getting-started
status: draft
updated: 2026-05-23
---
# Install
EOF

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "missing 'type:' frontmatter"

  rm -rf "$dir"
}

echo "=== doctor.test.sh ==="
scenario_1_no_docs
scenario_2_no_manifest
scenario_3_clean
scenario_4_declared_missing
scenario_5_orphan
scenario_6_missing_frontmatter
scenario_7_renderers_valid
scenario_8_renderers_unknown
scenario_9_renderers_scalar
scenario_10_renderers_list
scenario_11_missing_type_info

echo ""
echo "Results: ${pass_count} passed, ${fail_count} failed"
exit $((fail_count > 0))
