Param()
$ErrorActionPreference = 'Stop'

Write-Host "Starting local Supabase..."
supabase start
supabase db reset --force

# Wait for PostgREST
Write-Host "Waiting for PostgREST..."
$ok = $false
for ($i=0; $i -lt 60; $i++) {
  try {
    $r = Invoke-WebRequest -UseBasicParsing -Headers @{ 'Accept'='application/openapi+json' } http://127.0.0.1:54321/rest/v1/
    if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 500) { $ok = $true; break }
  } catch { }
  Start-Sleep -Seconds 2
}
if (-not $ok) { throw "PostgREST did not become ready" }

Write-Host "Dumping schema and RLS..."
supabase db dump --local --schema-only > docs/contracts/schema.sql
Select-String -Path docs/contracts/schema.sql -Pattern 'CREATE POLICY|ENABLE ROW LEVEL SECURITY|FORCE ROW LEVEL SECURITY' | ForEach-Object { $_.Line } | Set-Content docs/contracts/rls_policies.sql

Write-Host "Dumping OpenAPI..."
Invoke-WebRequest -UseBasicParsing -Headers @{ 'Accept'='application/openapi+json' } http://127.0.0.1:54321/rest/v1/ -OutFile docs/contracts/openapi.json

Write-Host "Generating DB types..."
supabase gen types typescript --local > docs/contracts/types.generated.ts

Write-Host "Generating edge functions manifest..."
dart tool/generate_edge_manifest.dart

Write-Host "Extracting and validating registry..."
dart tool/contracts_extract.dart
dart tool/validate_registry.dart docs/contracts/registry.json

Write-Host "Done. Review changes under docs/contracts/."

