[CmdletBinding()]
param(
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker is required but was not found on PATH.'
}
if (-not (Test-Path '.env')) {
    throw 'Missing .env. Copy .env.example to .env and configure PostgreSQL first.'
}

if (-not $OutputPath) {
    $OutputPath = Join-Path $PSScriptRoot ('buywise-{0}.dump' -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
} elseif (-not [System.IO.Path]::IsPathRooted($OutputPath)) {
    $OutputPath = Join-Path $root $OutputPath
}

$outputDirectory = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

docker compose up -d postgres | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw 'PostgreSQL could not be started.'
}

docker exec buywise-postgres pg_isready -U buywise -d buywise | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw 'PostgreSQL is not ready.'
}

$containerPath = '/tmp/buywise-backup.dump'
docker exec buywise-postgres pg_dump -Fc -U buywise -d buywise -f $containerPath
if ($LASTEXITCODE -ne 0) {
    throw 'Database backup failed.'
}
docker cp "buywise-postgres:$containerPath" $OutputPath
docker exec buywise-postgres rm -f $containerPath | Out-Null
if ($LASTEXITCODE -ne 0) {
    Remove-Item -Force -ErrorAction SilentlyContinue $OutputPath
    throw 'Database backup could not be copied from the container.'
}

Write-Host "Backup written to $OutputPath"