#!/usr/bin/env bash
set -euo pipefail

echo "Starting local Supabase..."
supabase start
supabase db reset --force

echo "Waiting for PostgREST..."
for i in {1..60}; do
  if curl -s -H 'Accept: application/openapi+json' http://127.0.0.1:54321/rest/v1/ >/dev/null; then
    echo "PostgREST is up"; break; fi; sleep 2; done

echo "Dumping schema and RLS..."
supabase db dump --local --schema-only > docs/contracts/schema.sql
grep -E 'CREATE POLICY|ENABLE ROW LEVEL SECURITY|FORCE ROW LEVEL SECURITY' docs/contracts/schema.sql > docs/contracts/rls_policies.sql || true

echo "Dumping OpenAPI..."
curl -s -H 'Accept: application/openapi+json' http://127.0.0.1:54321/rest/v1/ > docs/contracts/openapi.json

echo "Generating DB types..."
supabase gen types typescript --local > docs/contracts/types.generated.ts

echo "Generating edge functions manifest..."
dart tool/generate_edge_manifest.dart

echo "Extracting and validating registry..."
dart tool/contracts_extract.dart
dart tool/validate_registry.dart docs/contracts/registry.json

echo "Done. Review changes under docs/contracts/."

