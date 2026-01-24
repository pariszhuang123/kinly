#!/usr/bin/env bash
# Guard to ensure meaningful changes include tests.
# - Flutter/Dart code changes => require test/ or supabase/tests/
# - DB changes (migrations/policies/etc) => require supabase/tests/ (pgTap)
# - Edge Function changes (supabase/functions) => require Deno tests in supabase/functions/** (e.g. *.test.ts)
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

# ------------------------------------------------------------------------------
# Buckets
# ------------------------------------------------------------------------------

# App code (exclude pure i18n / generated)
code_changed=$(
  echo "$CHANGED_FILES" \
    | grep -E '^(lib/|supabase/migrations/)' \
    | grep -Ev '^(lib/l10n/intl_.*\.arb|lib/generated/)' \
    || true
)

tests_changed=$(echo "$CHANGED_FILES" | grep -E '^(test/|supabase/tests/)' || true)

# Edge Functions
functions_changed=$(echo "$CHANGED_FILES" | grep -E '^supabase/functions/' || true)
deno_tests_changed=$(
  echo "$CHANGED_FILES" \
    | grep -E '^supabase/functions/.+\.test\.ts$' \
    || true
)

# DB-related changes that should be covered by pgTap
db_changed=$(
  echo "$CHANGED_FILES" \
    | grep -E '^supabase/(migrations|policies|seed|tests)/' \
    || true
)
pgtap_changed=$(echo "$CHANGED_FILES" | grep -E '^supabase/tests/' || true)

messages=$(git log --format=%B "$BASE_REF"...HEAD || true | tr '[:upper:]' '[:lower:]')
mentions_fix=$(echo "$messages" | grep -E 'fix|bug|regression' || true)

# ------------------------------------------------------------------------------
# Rules
# ------------------------------------------------------------------------------

# 1) App code / migrations should have tests somewhere (Flutter tests or pgTap)
if [[ -n "$code_changed" && -z "$tests_changed" ]]; then
  echo "::error::Code/migrations changed without test updates. Touch test/ or supabase/tests/ or add a justification per docs/contracts/testing_v1.md."
  echo "Changed code:"
  echo "$code_changed"
  exit 1
fi

# 2) If commit message says fix/bug/regression, require tests updated somewhere
if [[ -n "$mentions_fix" && -z "$tests_changed" && -z "$deno_tests_changed" ]]; then
  echo "::error::Commit mentions fix/bug/regression but no tests changed. Add a regression test or document the exception."
  exit 1
fi

# 3) DB changes must include pgTap changes
if [[ -n "$db_changed" && -z "$pgtap_changed" ]]; then
  echo "::error::Database changes detected without pgTap coverage updates in supabase/tests/. Add or update a pgTap test per testing_v1.md."
  echo "DB-related changes:"
  echo "$db_changed"
  exit 1
fi

# 4) Edge Function code changes must include Deno tests
#    (either modify an existing *.test.ts or add a new one)
#    Note: if the only changes under supabase/functions are already *.test.ts, this passes.
if [[ -n "$functions_changed" && -z "$deno_tests_changed" ]]; then
  echo "::error::Supabase Edge Function code changed without Deno test updates. Add or update a *.test.ts under supabase/functions/ per testing_v1.md."
  echo "Changed functions/files:"
  echo "$functions_changed"
  exit 1
fi

echo "Test guard passed (base: $BASE_REF)."
