#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

version="$1"

deno upgrade --version "$version"
echo "$version" > .denoversion

# Print the current Deno version to confirm the upgrade
deno --version | head -n 1
