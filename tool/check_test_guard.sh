#!/usr/bin/env bash
# Guard to ensure meaningful changes include tests.
# Fails when lib/ or supabase/migrations/ change without touching test/ or supabase/tests/.
# Also requires tests when commit messages mention fix/bug/regression.

set -euo pipefail

git fetch --no-tags --prune --depth=200 origin +refs/heads/main:refs/remotes/origin/main >/dev/null 2>&1 || true

detect_base_ref() {
  if [[ -n "${GITHUB_BASE_REF:-}" ]]; then
    echo "origin/${GITHUB_BASE_REF}"
  elif [[ "${GITHUB_EVENT_NAME:-}" == "push" && "${GITHUB_REF:-}" == "refs/heads/main" ]]; then
    echo "HEAD~1"
  else
    echo "origin/main"
  fi
}

BASE_REF="${BASE_REF:-$(detect_base_ref)}"

if ! git rev-parse "$BASE_REF" >/dev/null 2>&1; then
  echo "::warning::Base ref $BASE_REF not found; falling back to origin/main"
  BASE_REF="origin/main"
fi

CHANGED_FILES=$(git diff --name-only "$BASE_REF"...HEAD || true)

if [[ -z "$CHANGED_FILES" ]]; then
  echo "No changes detected between $BASE_REF and HEAD."
  exit 0
fi

# Code/migrations that should generally require tests, EXCLUDING pure i18n/text changes.
# We ignore:
# - lib/l10n/intl_*.arb
# - lib/generated/intl/messages_*.dart
code_changed=$(
  echo "$CHANGED_FILES" \
    | grep -E '^(lib/|supabase/migrations/)' \
    | grep -Ev '^(lib/l10n/intl_.*\.arb|lib/generated/)' \
    || true
)

tests_changed=$(echo "$CHANGED_FILES" | grep -E '^(test/|supabase/tests/)' || true)
functions_changed=$(echo "$CHANGED_FILES" | grep -E '^supabase/functions/' || true)
supabase_tests_changed=$(echo "$CHANGED_FILES" | grep -E '^supabase/tests/' || true)

messages=$(git log --format=%B "$BASE_REF"...HEAD || true | tr '[:upper:]' '[:lower:]')
mentions_fix=$(echo "$messages" | grep -E 'fix|bug|regression' || true)

if [[ -n "$code_changed" && -z "$tests_changed" ]]; then
  echo "::error::Code/migrations changed without test updates. Touch test/ or supabase/tests/ or add a justification per docs/contracts/testing_v1.md."
  echo "Changed code:"
  echo "$code_changed"
  exit 1
fi

if [[ -n "$mentions_fix" && -z "$tests_changed" ]]; then
  echo "::error::Commit mentions fix/bug/regression but no tests changed. Add a regression test or document the exception."
  exit 1
fi

if [[ -n "$functions_changed" && -z "$supabase_tests_changed" ]]; then
  echo "::error::Supabase function code changed without pgTap coverage changes in supabase/tests/. Add or update a pgTap test per testing_v1.md."
  echo "Changed functions:"
  echo "$functions_changed"
  exit 1
fi

echo "Test guard passed (base: $BASE_REF)."
