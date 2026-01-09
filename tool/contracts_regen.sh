#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# contracts_regen.sh
#
# Regenerate all DB → contracts artifacts and the Dart registry so they match CI:
# - docs/contracts/schema.sql
# - docs/contracts/rls_policies.sql
# - docs/contracts/openapi.json
# - docs/contracts/types.generated.ts
# - docs/contracts/edge_functions.json
# - docs/contracts/registry.json
#
# Usage:
#   ./tool/contracts_regen.sh         # does NOT reset DB (keeps local data)
#   ./tool/contracts_regen.sh --reset # FULL match with CI (DESTROYS local DB)
# ------------------------------------------------------------------------------

RESET_DB=false
if [[ "${1:-}" == "--reset" || "${1:-}" == "-r" ]]; then
  RESET_DB=true
fi

# ---------------------------
# Helpers
# ---------------------------
read_toml_port() {
  # read_toml_port <section> <key> <fallback>
  local section="$1"
  local key="$2"
  local fallback="$3"

  if [[ ! -f supabase/config.toml ]]; then
    echo "$fallback"
    return
  fi

  local v
  v=$(awk -F'=' -v section="[$section]" -v key="$key" '
    $0 ~ "^\\"section"\\" {in_sec=1; next}
    $0 ~ "^\\[" {in_sec=0}
    in_sec && $1 ~ "^[[:space:]]*"key"[[:space:]]*$" {
      val=$2
      gsub(/[[:space:]]/,"",val)
      print val
      exit
    }
  ' supabase/config.toml)

  echo "${v:-$fallback}"
}

# Prefer explicit env override (nice for CI), else read TOML, else default
API_PORT="${SUPABASE_LOCAL_API_PORT:-$(read_toml_port api port 54321)}"
REST_URL="http://127.0.0.1:${API_PORT}/rest/v1/"

echo "👉 Checking that Docker is available..."
if ! command -v docker >/dev/null 2>&1; then
  echo "❌ docker CLI not found on PATH. Install Docker Desktop first."
  exit 1
fi

if ! docker ps >/dev/null 2>&1; then
  echo "❌ Cannot talk to Docker. Make sure Docker Desktop is installed and running."
  echo "   Open Docker Desktop, wait until 'Docker Engine is running', then retry."
  exit 1
fi

# Ensure docs/contracts exists
mkdir -p docs/contracts

echo "👉 Starting Supabase local stack (if not already running)..."
supabase start >/dev/null 2>&1 || supabase start

if "$RESET_DB"; then
  echo "⚠️  RESET MODE ENABLED: running 'supabase db reset --yes' (this will WIPE local DB data)."
  supabase db reset --yes
else
  echo "ℹ️  Skipping 'supabase db reset'."
  echo "    If you want a CLEAN DB matching CI exactly, re-run with: ./tool/contracts_regen.sh --reset"
fi

echo "👉 Dumping schema.sql (DDL only) via 'supabase db dump --local'..."
supabase db dump --local -f docs/contracts/schema.sql

echo "👉 Extracting RLS policies into docs/contracts/rls_policies.sql..."
awk '/CREATE POLICY|ENABLE ROW LEVEL SECURITY|FORCE ROW LEVEL SECURITY/ {print}' \
  docs/contracts/schema.sql > docs/contracts/rls_policies.sql

echo "👉 Waiting for PostgREST/OpenAPI endpoint on ${REST_URL} ..."
for i in {1..60}; do
  if curl -fsS -H 'Accept: application/openapi+json' "${REST_URL}" >/dev/null 2>&1; then
    echo "✅ PostgREST is reachable (api.port=${API_PORT})"
    break
  fi
  sleep 2
done

# Hard fail with diagnostics if still not reachable
if ! curl -fsS -H 'Accept: application/openapi+json' "${REST_URL}" >/dev/null 2>&1; then
  echo "❌ PostgREST not reachable at ${REST_URL}"
  echo "---- supabase status ----"
  supabase status || true
  echo "---- docker ps ----"
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" || true
  exit 7
fi

echo "👉 Dumping OpenAPI from PostgREST to docs/contracts/openapi.json..."
curl -fsS -H 'Accept: application/openapi+json' \
  "${REST_URL}" > docs/contracts/openapi.json

echo "👉 Generating TypeScript DB types to docs/contracts/types.generated.ts..."
supabase gen types typescript --local > docs/contracts/types.generated.ts

echo "👉 Generating Edge Functions manifest docs/contracts/edge_functions.json..."
python3 - <<'PY'
import os, json
base = 'supabase/functions'
manifest = {'functions': {}}
if os.path.isdir(base):
    for name in sorted(
        d for d in os.listdir(base)
        if os.path.isdir(os.path.join(base, d))
    ):
        manifest['functions'][name] = {
            'path': os.path.join(base, name).replace('\\\\', '/')
        }
os.makedirs('docs/contracts', exist_ok=True)
with open('docs/contracts/edge_functions.json', 'w') as f:
    json.dump(manifest, f, indent=2)
print('Wrote docs/contracts/edge_functions.json')
PY

echo "👉 Running Dart contracts extractor..."
dart tool/contracts_extract.dart

echo "👉 Validating registry structure..."
dart tool/validate_registry.dart docs/contracts/registry.json

echo
echo "✅ Done. The following files may have changed:"
echo "   - docs/contracts/schema.sql"
echo "   - docs/contracts/rls_policies.sql"
echo "   - docs/contracts/openapi.json"
echo "   - docs/contracts/types.generated.ts"
echo "   - docs/contracts/edge_functions.json"
echo "   - docs/contracts/registry.json"
echo
echo "Next steps:"
echo "   git status"
echo "   git diff docs/contracts/"
echo "   git add docs/contracts/*"
echo "   git commit -m \"Update contract snapshots and registry\""
