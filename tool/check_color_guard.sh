#!/usr/bin/env bash
set -euo pipefail

# CI guardrails for Kinly color system.
# Rules:
#  A) No raw Color literals outside allowlist.
#  B) No Colors.* usage outside allowlist.
#  C) No brightness branching outside allowlist.
#  D) (Optional STRICT=1) No direct colorScheme access outside allowlist.
#
# Env:
#  MODE=fail|warn (default fail)
#  FULL=1 to scan entire repo (default: changed files vs origin/main...HEAD)
#  STRICT=1 to enable Rule D

MODE="${MODE:-fail}"
FULL="${FULL:-0}"
STRICT="${STRICT:-0}"

root="$(git rev-parse --show-toplevel)"
cd "$root"

allowlist=(
  "lib/core/theme/"
  "lib/**/kinly_palette.dart"
  "lib/**/foundation"
  "lib/**/derived"
  "lib/**/color_tokens.dart"
  "lib/**/control_tokens.dart"
  "tool/check_color_guard.sh"
)

is_allowlisted() {
  local path="$1"
  for pattern in "${allowlist[@]}"; do
    if [[ "$path" == $pattern ]]; then
      return 0
    fi
  done
  return 1
}

if [[ "$FULL" == "1" ]]; then
  mapfile -t files < <(git ls-files '*.dart')
else
  if git rev-parse --verify origin/main >/dev/null 2>&1; then
    mapfile -t files < <(git diff --name-only origin/main...HEAD -- '*.dart')
  else
    mapfile -t files < <(git diff --name-only HEAD -- '*.dart')
  fi
fi

[[ ${#files[@]} -eq 0 ]] && { echo "No Dart files to scan."; exit 0; }

declare -a violations

scan_rule() {
  local rule_name="$1"
  local regex="$2"
  local tip="$3"
  for f in "${files[@]}"; do
    [[ -f "$f" ]] || continue
    if is_allowlisted "$f"; then
      continue
    fi
    if rg --no-heading --line-number --fixed-strings --pcre2 "$regex" "$f" >/tmp/rg_out 2>/dev/null; then
      while IFS= read -r line; do
        violations+=("$rule_name|$f|$line|$tip")
      done < /tmp/rg_out
    fi
  done
}

# Rule A: raw Color literals
scan_rule "Rule A (raw Color literal)" "Color\\s*\\(0x|const\\s+Color\\s*\\(0x|Color\\.fromARGB|Color\\.fromRGBO" \
  "Move the color into the foundation/derived engine."

# Rule B: Colors.* usage
scan_rule "Rule B (Colors.* in UI)" "Colors\\." \
  "Use derived/control tokens instead of Colors.*."

# Rule C: brightness branching
scan_rule "Rule C (brightness check)" "Brightness\\.dark|Brightness\\.light|Theme\\.of\\(.*\\)\\.brightness|platformBrightness|MediaQuery\\.platformBrightnessOf|\\bisDark\\b" \
  "Do not branch on brightness outside the color engine."

# Rule D: direct colorScheme (strict mode)
if [[ "$STRICT" == "1" ]]; then
  scan_rule "Rule D (colorScheme in UI)" "\\.colorScheme" \
    "Use control tokens / derived outputs instead of colorScheme directly."
fi

if [[ ${#violations[@]} -gt 0 ]]; then
  echo "Color guard violations detected:"
  for v in "${violations[@]}"; do
    IFS="|" read -r rule file line tip <<<"$v"
    echo " - $rule :: $file :: $line"
    echo "   $tip"
  done
  if [[ "$MODE" == "warn" ]]; then
    exit 0
  fi
  exit 1
fi

echo "check_color_guard.sh passed (mode=$MODE, strict=$STRICT, full=$FULL)."
