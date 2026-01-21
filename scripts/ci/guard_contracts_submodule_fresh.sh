#!/usr/bin/env bash
set -euo pipefail

SUBMODULE_PATH="${SUBMODULE_PATH:-contracts}"
REMOTE_NAME="${REMOTE_NAME:-origin}"
BRANCH="${KINLY_CONTRACTS_BRANCH:-main}"

if [ ! -d "$SUBMODULE_PATH" ]; then
  echo "❌ CI Guard failed: '$SUBMODULE_PATH' directory not found."
  echo "   Fix: git submodule update --init --recursive"
  exit 1
fi

# Submodule .git can be a dir or a file (gitdir pointer)
if [ ! -e "$SUBMODULE_PATH/.git" ]; then
  echo "❌ CI Guard failed: '$SUBMODULE_PATH' is not initialized as a git submodule."
  echo "   Fix: git submodule update --init --recursive"
  exit 1
fi

echo "🔎 Checking contracts submodule freshness…"
echo "   Path:   $SUBMODULE_PATH"
echo "   Remote: $REMOTE_NAME"
echo "   Branch: $BRANCH"

# Fetch latest remote state for the target branch
git -C "$SUBMODULE_PATH" fetch "$REMOTE_NAME" "$BRANCH" --quiet

PINNED_SHA="$(git -C "$SUBMODULE_PATH" rev-parse HEAD)"
REMOTE_SHA="$(git -C "$SUBMODULE_PATH" rev-parse "$REMOTE_NAME/$BRANCH")"

echo "   Pinned: $PINNED_SHA"
echo "   Remote: $REMOTE_SHA"

if [ "$PINNED_SHA" != "$REMOTE_SHA" ]; then
  echo ""
  echo "❌ Contracts are out of date."
  echo "   Your repo pins: $PINNED_SHA"
  echo "   Latest remote:  $REMOTE_SHA"
  echo ""
  echo "✅ Update instructions:"
  echo "   cd $SUBMODULE_PATH"
  echo "   git checkout $BRANCH"
  echo "   git pull $REMOTE_NAME $BRANCH"
  echo "   cd .."
  echo "   git add $SUBMODULE_PATH"
  echo "   git commit -m \"chore(contracts): bump kinly-contracts\""
  echo ""
  exit 2
fi

echo "✅ Contracts submodule is up to date."
