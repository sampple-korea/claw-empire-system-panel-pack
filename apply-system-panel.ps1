Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$PatchUrl = "https://raw.githubusercontent.com/sampple-korea/claw-empire-system-panel-pack/main/patches/system-panel-live.patch"
$PatchFile = Join-Path $env:TEMP "system-panel-live.patch"

if (-not (Test-Path ".\package.json") -or -not (Test-Path ".\src") -or -not (Test-Path ".\server")) {
  throw "Run this script from a Claw-Empire repository root."
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  throw "Missing required command: git"
}
if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
  throw "Missing required command: pnpm"
}

Invoke-WebRequest -UseBasicParsing -Uri $PatchUrl -OutFile $PatchFile

$reverseCheck = & git apply --reverse --check $PatchFile 2>$null
if ($LASTEXITCODE -eq 0) {
  Write-Host "Patch appears already applied in this repository. Skipping."
  exit 0
}

& git apply --index $PatchFile
if ($LASTEXITCODE -ne 0) {
  throw "git apply failed."
}

& pnpm build
if ($LASTEXITCODE -ne 0) {
  throw "pnpm build failed."
}

Write-Host "Patch applied and build completed."
Write-Host "Restart your service/process to load the new build."
