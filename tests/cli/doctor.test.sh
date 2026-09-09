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
#  12. Page not reviewed in > 180 days → warning (stale)
#  13. Broken internal markdown link → error
#  14. Directory nesting > 3 levels deep → error
#  15. Recognized 6 Core Classes pass clean

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
assert_file_contains() {
  if [[ -f "$1" ]] && grep -qF "$2" "$1"; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected '$1' to contain '$2'"; fail_count=$((fail_count + 1)); fi
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
updated: 2026-08-22
---
# Install
EOF

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "missing 'type:' frontmatter"

  rm -rf "$dir"
}

scenario_12_stale_content_warning() {
  echo "Scenario 12: page not reviewed in > 180 days → warning (stale)"
  local dir="/tmp/pageworks-doctor-test-12"
  setup_docs "$dir"

  cat > "$dir/docs/getting-started/install.md" <<'EOF'
---
title: Install
description: Install the thing.
section: getting-started
type: tutorial
status: stable
owner: "@platform-core"
last_reviewed: 2025-01-01
updated: 2025-01-01
---
# Install
EOF

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "not been reviewed in > 180 days"

  rm -rf "$dir"
}

scenario_13_broken_internal_link() {
  echo "Scenario 13: broken internal markdown link → error"
  local dir="/tmp/pageworks-doctor-test-13"
  setup_docs "$dir"

  cat >> "$dir/docs/getting-started/install.md" <<'EOF'

See [Missing Guide](nonexistent-guide.md) for details.
EOF

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  if [[ $exit_code -ne 0 ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected non-zero exit"; fail_count=$((fail_count + 1)); fi
  assert_contains "$output" "broken internal link to 'nonexistent-guide.md'"

  rm -rf "$dir"
}

scenario_14_deep_nesting_error() {
  echo "Scenario 14: directory nesting > 3 levels deep → error"
  local dir="/tmp/pageworks-doctor-test-14"
  setup_docs "$dir"

  mkdir -p "$dir/docs/services/sub/nested"
  cat > "$dir/docs/services/sub/nested/deep.md" <<'EOF'
---
title: Deep Page
description: Nested too deep.
section: services
type: reference
status: draft
updated: 2026-08-22
---
# Deep
EOF

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi

  if [[ $exit_code -ne 0 ]]; then pass_count=$((pass_count + 1))
  else echo "    ✗ expected non-zero exit"; fail_count=$((fail_count + 1)); fi
  assert_contains "$output" "depth exceeds 3 levels"

  rm -rf "$dir"
}

scenario_15_six_core_classes_valid() {
  echo "Scenario 15: recognized 6 Core Classes pass clean"
  local dir="/tmp/pageworks-doctor-test-15"
  setup_docs "$dir"

  for class_name in adr service-catalog runbook postmortem; do
    cat > "$dir/docs/getting-started/quickstart.md" <<EOF
---
title: Quickstart
description: Quickstart guide.
section: getting-started
type: ${class_name}
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---
# Quickstart
EOF
    local output
    output=$(run_cli "$dir" doctor 2>&1)
    assert_not_contains "$output" "unrecognized type"
  done

  rm -rf "$dir"
}

scenario_16_doctor_fix_repairs() {
  echo "Scenario 16: doctor --fix mechanically repairs missing frontmatter"
  local dir="/tmp/pageworks-doctor-test-16"
  setup_docs "$dir"

  # Page missing frontmatter completely
  echo "# Completely Bare Page" > "$dir/docs/getting-started/install.md"

  local output exit_code=0
  if output=$(run_cli "$dir" doctor --fix 2>&1); then exit_code=0; else exit_code=$?; fi

  assert_exit "$exit_code" 0 "doctor --fix exits 0"
  assert_contains "$output" "injected missing frontmatter block"
  assert_file_contains "$dir/docs/getting-started/install.md" "title: Completely Bare Page"
  assert_file_contains "$dir/docs/getting-started/install.md" "owner: \"@platform-core\""

  rm -rf "$dir"
}

scenario_17_extended_classes_valid() {
  echo "Scenario 17: extended classes pass clean without warnings"
  local dir="/tmp/pageworks-doctor-test-17"
  setup_docs "$dir"

  for class_name in migration troubleshooting cookbook design-spec guide spec overview; do
    cat > "$dir/docs/getting-started/quickstart.md" <<EOF
---
title: Quickstart
description: Quickstart guide.
section: getting-started
type: ${class_name}
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---
# Quickstart
EOF
    local output
    output=$(run_cli "$dir" doctor 2>&1)
    assert_not_contains "$output" "unrecognized type"
    assert_contains "$output" "0 error(s)"
  done

  rm -rf "$dir"
}

scenario_18_custom_page_type_info() {
  echo "Scenario 18: custom user-defined type emits info rather than warning"
  local dir="/tmp/pageworks-doctor-test-18"
  setup_docs "$dir"

  cat > "$dir/docs/getting-started/quickstart.md" <<EOF
---
title: Quickstart
description: Custom quickstart.
section: getting-started
type: interactive-lab
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---
# Quickstart
EOF

  local output
  output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$output" "custom page type 'interactive-lab' declared"
  assert_not_contains "$output" "unrecognized type"
  assert_contains "$output" "0 warning(s)"

  rm -rf "$dir"
}

scenario_19_synced_from_mechanical_drift() {
  echo "Scenario 19: synced_from target validation and git drift detection"
  local dir="/tmp/pageworks-doctor-test-19"
  setup_docs "$dir"

  # Part A: Missing target emits error
  cat > "$dir/docs/getting-started/quickstart.md" <<EOF
---
title: Quickstart
description: Quickstart.
section: getting-started
type: tutorial
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
synced_from: ../../missing/spec.md
---
# Quickstart
EOF

  local output exit_code=0
  if output=$(run_cli "$dir" doctor 2>&1); then exit_code=0; else exit_code=$?; fi
  assert_exit "$exit_code" 1 "missing synced_from target exits 1"
  assert_contains "$output" "synced_from target '../../missing/spec.md' does not exist on disk"

  # Part B: Existing target in a real git repo with drift
  (
    cd "$dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test Runner"
    mkdir -p specs
    echo "spec content" > specs/api.yaml
    git add .
    git commit -q -m "initial commit"
  )

  cat > "$dir/docs/getting-started/quickstart.md" <<EOF
---
title: Quickstart
description: Quickstart.
section: getting-started
type: tutorial
status: stable
owner: "@platform-core"
last_reviewed: 2020-01-01
updated: 2020-01-01
synced_from: ../../specs/api.yaml
---
# Quickstart
EOF

  local drift_output
  drift_output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$drift_output" "upstream source '../../specs/api.yaml' modified in git since last review"

  rm -rf "$dir"
}

scenario_20_touch_acknowledges_freshness() {
  echo "Scenario 20: pageworks touch updates last_reviewed timestamp to today"
  local dir="/tmp/pageworks-doctor-test-20"
  setup_docs "$dir"

  # Create a stale page (reviewed in 2020)
  cat > "$dir/docs/getting-started/quickstart.md" <<EOF
---
title: Quickstart
description: Quickstart.
section: getting-started
type: tutorial
status: stable
owner: "@platform-core"
last_reviewed: 2020-01-01
updated: 2020-01-01
---
# Quickstart
EOF

  local stale_output
  stale_output=$(run_cli "$dir" doctor 2>&1)
  assert_contains "$stale_output" "content has not been reviewed in > 180 days"

  # Run pageworks touch to acknowledge freshness
  local touch_output exit_code=0
  if touch_output=$(run_cli "$dir" touch getting-started/quickstart 2>&1); then exit_code=0; else exit_code=$?; fi
  assert_exit "$exit_code" 0 "touch exits 0"
  assert_contains "$touch_output" "Touched review timestamp"

  # Verify doctor is now clean (staleness cleared)
  local clean_output
  clean_output=$(run_cli "$dir" doctor 2>&1)
  assert_not_contains "$clean_output" "content has not been reviewed in > 180 days"
  assert_contains "$clean_output" "0 warning(s)"

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
scenario_12_stale_content_warning
scenario_13_broken_internal_link
scenario_14_deep_nesting_error
scenario_15_six_core_classes_valid
scenario_16_doctor_fix_repairs
scenario_17_extended_classes_valid
scenario_18_custom_page_type_info
scenario_19_synced_from_mechanical_drift
scenario_20_touch_acknowledges_freshness

echo ""
echo "Results: ${pass_count} passed, ${fail_count} failed"
exit $((fail_count > 0))


