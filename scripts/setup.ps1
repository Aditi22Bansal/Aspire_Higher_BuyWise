[CmdletBinding()]
param(
    [switch]$WithOllama,
    [switch]$PullModel
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker is required but was not found on PATH.'
}
if (-not (Test-Path '.env')) {
    Copy-Item '.env.example' '.env'
    Write-Host 'Created .env from .env.example. Fill POSTGRES_PASSWORD and N8N_ENCRYPTION_KEY before continuing.'
    throw 'Setup paused because .env requires local secrets.'
}

docker compose config | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw 'docker compose configuration is invalid. Check .env.'
}

$services = @('postgres', 'n8n')
if ($WithOllama) {
    $services += 'ollama'
}
docker compose up -d $services | Out-Host
if ($LASTEXITCODE -ne 0) {
    throw 'Docker services could not be started.'
}

if ($WithOllama -and $PullModel) {
    $model = if ($env:OLLAMA_MODEL) { $env:OLLAMA_MODEL } else { 'llama3.1:8b' }
    docker exec buywise-ollama ollama pull $model | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "Could not pull Ollama model: $model"
    }
}

Write-Host 'BuyWise services are running.'
Write-Host 'n8n: http://localhost:5678'