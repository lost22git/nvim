$ErrorActionPreference = 'Stop'

$src = "${env:LOCALAPPDATA}\nvim"

$dst = "$PSScriptRoot"

if (Test-Path $src)
{
  (Get-Item $src).Delete()
}

New-Item -ItemType SymbolicLink -Path $src -Value $dst

Write-Host "[ok] new link $((Resolve-Path $src).path) -> $((Resolve-Path $dst).path)" -ForegroundColor Green

# Add mason bin dir to Path
Set-Env -Scope Machine -Name Path -Value "${env:LOCALAPPDATA}\nvim-data\mason\bin" -Oper AppendFirst
