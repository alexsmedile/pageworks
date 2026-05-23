#!/usr/bin/env bash
# Test harness for Pageworks.
# Discovers tests/**/*.test.sh, runs each, reports pass/fail.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TESTS_DIR="$REPO_ROOT/tests"

FILTER="${1:-}"

test_files=()
while IFS= read -r line; do
  test_files+=("$line")
done < <(find "$TESTS_DIR" -name "*.test.sh" -type f | sort)

if [[ ${#test_files[@]} -eq 0 ]]; then
  echo "No tests found under $TESTS_DIR"
  exit 1
fi

if [[ -n "$FILTER" ]]; then
  filtered=()
  for f in "${test_files[@]}"; do
    if [[ "$f" == *"/$FILTER/"* ]]; then
      filtered+=("$f")
    fi
  done
  if [[ ${#filtered[@]} -gt 0 ]]; then
    test_files=("${filtered[@]}")
  else
    test_files=()
  fi
fi

echo "Running ${#test_files[@]} test file(s)..."
echo ""

passed=0
failed=0
failures=()

for test_file in "${test_files[@]}"; do
  rel="${test_file#$REPO_ROOT/}"
  echo "── $rel ──────────────────────────────────────────────"
  if bash "$test_file"; then
    passed=$((passed + 1))
    echo "  ✓ $rel"
  else
    failed=$((failed + 1))
    failures+=("$rel")
    echo "  ✗ $rel"
  fi
  echo ""
done

echo "═══════════════════════════════════════════════════════"
echo "Results: $passed passed, $failed failed"
if [[ $failed -gt 0 ]]; then
  echo "Failed:"
  for f in "${failures[@]}"; do
    echo "  - $f"
  done
  exit 1
fi
exit 0
