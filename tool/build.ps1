param(
  [ValidateSet('dev','prod')]
  [string]$env = 'prod',
  [ValidateSet('apk','appbundle','ios')]
  [string]$target = 'apk'
)

$file = "env/$env.json"
if (-not (Test-Path $file)) {
  Write-Host "Config $file not found. Copy from env/$env.sample.json" -ForegroundColor Yellow
  exit 1
}

switch ($target) {
  'apk' { flutter build apk --flavor $env --dart-define-from-file=$file }
  'appbundle' { flutter build appbundle --flavor $env --dart-define-from-file=$file }
  'ios' { flutter build ios --no-codesign --flavor $env --dart-define-from-file=$file }
}
