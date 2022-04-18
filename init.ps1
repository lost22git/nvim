$ErrorActionPreference = 'Stop'

$src = "${env:LOCALAPPDATA}\nvim"

$dst = "$PSScriptRoot"

if (Test-Path $src)
{
  (Get-Item $src).Delete()
}

New-Item -ItemType SymbolicLink -Path $src -Value $dst

Write-Host "[ok] new link $((Resolve-Path $src).path) -> $((Resolve-Path $dst).path)" -ForegroundColor Green
