#!/usr/bin/env bash
set -euo pipefail

# Aggregated color checks to avoid duplication:
# 1) check_color_guard.sh  — blocks rogue colors/brightness in UI.
# 2) check_unused_color_tokens.dart — ensures tokens are referenced.

root="$(git rev-parse --show-toplevel)"
cd "$root"

echo "Running color guard..."
bash tool/check_color_guard.sh

echo "Running unused color tokens check..."
dart run tool/check_unused_color_tokens.dart

echo "check_colors.sh passed."
