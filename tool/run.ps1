param(
  [ValidateSet('dev','prod')]
  [string]$env = 'dev'
)

$file = "env/$env.json"
if (-not (Test-Path $file)) {
  Write-Host "Config $file not found. Copy from env/$env.sample.json" -ForegroundColor Yellow
  exit 1
}

flutter run --flavor $env -t lib/main.dart --dart-define-from-file=$file
