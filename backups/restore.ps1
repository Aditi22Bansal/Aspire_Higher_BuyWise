[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker is required but was not found on PATH.'
}
if (-not (Test-Path -LiteralPath $InputPath -PathType Leaf)) {
    throw "Backup file not found: $InputPath"
}
if (-not $Force) {
    $confirmation = Read-Host 'This replaces the current BuyWise database. Type RESTORE to continue'
    if ($confirmation -cne 'RESTORE') {
        throw 'Restore cancelled.'
    }
}

docker compose stop n8n | Out-Host
docker compose up -d postgres | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw 'PostgreSQL could not be started.'
}

$containerPath = '/tmp/buywise-restore.dump'
docker cp (Resolve-Path -LiteralPath $InputPath) "buywise-postgres:$containerPath"
if ($LASTEXITCODE -ne 0) {
    throw 'Backup could not be copied into the PostgreSQL container.'
}
docker exec buywise-postgres pg_restore -Fc -U buywise -d buywise --clean --if-exists --no-owner $containerPath
$restoreExitCode = $LASTEXITCODE
docker exec buywise-postgres rm -f $containerPath | Out-Null
if ($restoreExitCode -ne 0) {
    throw 'Database restore failed.'
}

docker compose start n8n | Out-Host
Write-Host "Database restored from $InputPath"