param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRepoPath
)

$ErrorActionPreference = "Stop"

Write-Host "=== Instalando DeepWiki Documenter en repositorio destino ===" -ForegroundColor Cyan

$sourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$targetRoot = (Resolve-Path -Path $TargetRepoPath).Path

if ($sourceRoot -eq $targetRoot) {
    throw "El repositorio origen y destino son el mismo. Evita instalar sobre el propio repositorio."
}

if (-not (Test-Path (Join-Path $targetRoot ".git"))) {
    throw "La ruta destino no parece ser un repositorio git: $targetRoot"
}

Write-Host "Origen:  $sourceRoot" -ForegroundColor Yellow
Write-Host "Destino: $targetRoot" -ForegroundColor Yellow

$copyItems = @(
    ".agents",
    "hooks",
    ".graphifyignore",
    "install.ps1",
    "skills"
)

foreach ($item in $copyItems) {
    $src = Join-Path $sourceRoot $item
    $dst = Join-Path $targetRoot $item

    if (-not (Test-Path $src)) {
        throw "No se encontró el recurso requerido: $src"
    }

    if ((Get-Item $src) -is [System.IO.DirectoryInfo]) {
        if (-not (Test-Path $dst)) {
            New-Item -ItemType Directory -Path $dst -Force | Out-Null
        }
        Copy-Item -Path (Join-Path $src "*") -Destination $dst -Recurse -Force
    }
    else {
        Copy-Item -Path $src -Destination $dst -Force
    }
}

Write-Host "Archivos del agente copiados. Ejecutando instalador en destino..." -ForegroundColor Cyan
Push-Location $targetRoot
try {
    powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
}
finally {
    Pop-Location
}

Write-Host "Verificando instalación en destino..." -ForegroundColor Yellow

$requiredPaths = @(
    ".git\hooks\post-commit",
    ".git\hooks\post-checkout",
    "graphify-out\GRAPH_REPORT.md"
)

$missing = @()
foreach ($required in $requiredPaths) {
    $fullPath = Join-Path $targetRoot $required
    if (-not (Test-Path $fullPath)) {
        $missing += $required
    }
}

if ($missing.Count -gt 0) {
    throw "La instalación finalizó con faltantes: $($missing -join ', ')"
}

Write-Host "Verificación final completada correctamente." -ForegroundColor Green

Write-Host "=== Instalación completada en: $targetRoot ===" -ForegroundColor Green
