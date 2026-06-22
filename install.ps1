# install.ps1
# Script de instalación y configuración automatizada para Windows (Ejecutar en PowerShell).
# Configura Ollama, uv, code-review-graph, graphify y Git Hooks.

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
Write-Host "Instalando code-review-graph y graphifyy..." -ForegroundColor Yellow
uv tool install code-review-graph
uv tool install graphifyy

# 3. Verificar/Instalar Ollama
Write-Host "Verificando instalación de Ollama..." -ForegroundColor Yellow
$ollamaCheck = Get-Command ollama -ErrorAction SilentlyContinue
if (-not $ollamaCheck) {
    Write-Host "Ollama no detectado. Instalando vía winget (puede requerir permisos de Administrador)..." -ForegroundColor Cyan
    winget install Ollama.Ollama --silent --accept-source-agreements --accept-package-agreements
    # Refrescar Path
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Write-Host "¡Ollama ya está instalado!" -ForegroundColor Green
}

# Asegurar que el servicio de Ollama esté ejecutándose
$ollamaProcess = Get-Process -Name "ollama" -ErrorAction SilentlyContinue
if (-not $ollamaProcess) {
    Write-Host "Iniciando la aplicación de Ollama en segundo plano..." -ForegroundColor Cyan
    Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 5
}

# Descargar modelo de embeddings
Write-Host "Descargando modelo de embeddings 'nomic-embed-text' en Ollama..." -ForegroundColor Cyan
ollama pull nomic-embed-text

# 4. Configurar variable de entorno CRG_TOOLS (Optimización de tokens para Copilot)
$crgTools = "semantic_search_nodes_tool,query_graph_tool,get_impact_radius_tool,get_review_context_tool"
[System.Environment]::SetEnvironmentVariable("CRG_TOOLS", $crgTools, [System.EnvironmentVariableTarget]::User)
$env:CRG_TOOLS = $crgTools
Write-Host "Variable de entorno CRG_TOOLS configurada correctamente." -ForegroundColor Green

# 5. Registrar herramientas MCP en el entorno local
Write-Host "Registrando herramientas en los editores compatibles..." -ForegroundColor Yellow
code-review-graph install -y --platform copilot --no-skills --no-hooks --no-instructions

# 6. Verificar archivos de configuración esperados
Write-Host "Verificando archivos ignore en la raíz del repositorio..." -ForegroundColor Yellow
if (-not (Test-Path ".\.graphifyignore")) {
    Write-Host "ADVERTENCIA: Falta el archivo .graphifyignore en la raíz del repositorio." -ForegroundColor Yellow
}
if (-not (Test-Path ".\.code-review-graphignore")) {
    Write-Host "ADVERTENCIA: Falta el archivo .code-review-graphignore en la raíz del repositorio." -ForegroundColor Yellow
}

# 7. Instalar Git Hooks locales
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

# 8. Construcción del Grafo y Generación de Embeddings iniciales
Write-Host "Construyendo el mapa estructural del código (build)..." -ForegroundColor Cyan
code-review-graph build

Write-Host "Generando vectores semánticos con Ollama (embed)..." -ForegroundColor Cyan
uvx --from "code-review-graph[embeddings]" code-review-graph embed

Write-Host "Sincronizando skills de Graphify para evitar desfases de versión..." -ForegroundColor Cyan
graphify install --platform copilot

Write-Host "Actualizando la DeepWiki (graphify)..." -ForegroundColor Cyan
graphify update

Write-Host "=== ¡Instalación Completada con Éxito! ===" -ForegroundColor Green
Write-Host "GitHub Copilot ahora cuenta con búsquedas semánticas locales y mantiene tu DeepWiki viva." -ForegroundColor Green
