# install.ps1
# Script de instalación y configuración automatizada para Windows (Ejecutar en PowerShell).
# Configura uv, graphify y Git Hooks.

$ErrorActionPreference = "Stop"

Write-Host "=== Iniciando Instalación del Ecosistema DeepWiki Documenter (Windows) ===" -ForegroundColor Cyan

# 1. Verificar/Instalar 'uv' (herramienta de empaquetado de Python ultra rápida)
Write-Host "Verificando instalación de uv..." -ForegroundColor Yellow
$uvCheck = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uvCheck) {
    Write-Host "uv no detectado. Instalando uv automáticamente..." -ForegroundColor Cyan
    powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"
    # Refrescar variables de entorno
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "¡uv ya está instalado!" -ForegroundColor Green
}

# 2. Instalar herramientas globales de Python utilizando uv
Write-Host "Instalando graphify..." -ForegroundColor Yellow
# Graphify package naming may vary across releases/channels.
uv tool install graphify
if ($LASTEXITCODE -ne 0) {
    Write-Host "No se pudo instalar 'graphify'. Intentando con 'graphifyy'..." -ForegroundColor Yellow
    uv tool install graphifyy
}

# 3. Verificar archivos de configuración esperados
Write-Host "Verificando archivos ignore en la raíz del repositorio..." -ForegroundColor Yellow
if (-not (Test-Path ".\.graphifyignore")) {
    Write-Host "ADVERTENCIA: Falta el archivo .graphifyignore en la raíz del repositorio." -ForegroundColor Yellow
}

# 4. Instalar Git Hooks locales
if (Test-Path ".git") {
    Write-Host "Instalando Git Hooks para automatizar la wiki..." -ForegroundColor Yellow
    $hooksDir = ".git\hooks"
    if (-not (Test-Path $hooksDir)) {
        New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
    }
    Copy-Item -Path ".\hooks\post-commit" -Destination ".\$hooksDir\post-commit" -Force
    Copy-Item -Path ".\hooks\post-checkout" -Destination ".\$hooksDir\post-checkout" -Force
    Copy-Item -Path ".\hooks\update-graph.ps1" -Destination ".\$hooksDir\update-graph.ps1" -Force
    Copy-Item -Path ".\hooks\update-graph-checkout.ps1" -Destination ".\$hooksDir\update-graph-checkout.ps1" -Force
    Write-Host "¡Git Hooks instalados con éxito!" -ForegroundColor Green
} else {
    Write-Host "ADVERTENCIA: No se detectó un directorio '.git'. Asegúrate de estar en la raíz de un repositorio Git para instalar los hooks." -ForegroundColor Yellow
}

# 5. Sincronizando skills de Graphify para evitar desfases de versión...
Write-Host "Sincronizando skills de Graphify para evitar desfases de versión..." -ForegroundColor Cyan
graphify install --platform copilot

Write-Host "Actualizando la DeepWiki (graphify)..." -ForegroundColor Cyan
graphify update .

Write-Host "Regenerando comunidades del reporte de Graphify..." -ForegroundColor Cyan
graphify cluster-only .

Write-Host "=== ¡Instalación Completada con Éxito! ===" -ForegroundColor Green
Write-Host "GitHub Copilot ahora cuenta con Graphify y mantiene tu DeepWiki viva." -ForegroundColor Green
