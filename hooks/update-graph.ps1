# .git/hooks/update-graph.ps1
# Script de PowerShell para actualizar el grafo de CRG y la wiki de Graphify en Windows.
# Se ejecuta en segundo plano con ventana oculta.

# 1. Guardia de Procesos: Evitar superposiciones si el usuario realiza commits rápidos
$crgProcess = Get-Process -Name "code-review-graph" -ErrorAction SilentlyContinue
$graphifyProcess = Get-Process -Name "graphify" -ErrorAction SilentlyContinue

if ($crgProcess -or $graphifyProcess) {
    exit 0
}

# 2. Asegurar que Ollama está activo
$ollamaProcess = Get-Process -Name "ollama" -ErrorAction SilentlyContinue
if (-not $ollamaProcess) {
    $ollamaCheck = Get-Command ollama -ErrorAction SilentlyContinue
    if ($ollamaCheck) {
        $ollamaInfo = New-Object System.Diagnostics.ProcessStartInfo
        $ollamaInfo.FileName = "ollama"
        $ollamaInfo.Arguments = "serve"
        $ollamaInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
        $ollamaInfo.CreateNoWindow = $true
        [System.Diagnostics.Process]::Start($ollamaInfo) | Out-Null
        Start-Sleep -Seconds 3
    }
}

# Función para iniciar procesos de forma silenciosa y en segundo plano
function Start-BgProcess {
    param (
        [string]$FileName,
        [string]$Arguments
    )
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $FileName
    $psi.Arguments = $Arguments
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $psi.CreateNoWindow = $true
    $psi.UseShellExecute = $false
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        # Omitir errores de inicio silencioso
    }
}

# 3. Lanzar actualización de Code Review Graph (CRG)
# Si está instalado de forma global con 'uv tool install', se llama directamente, si no, se usa uvx
$crgGlobal = Get-Command code-review-graph -ErrorAction SilentlyContinue
if ($crgGlobal) {
    Start-BgProcess -FileName "code-review-graph" -Arguments "update"
} else {
    $uvCheck = Get-Command uv -ErrorAction SilentlyContinue
    if ($uvCheck) {
        Start-BgProcess -FileName "uvx" -Arguments "code-review-graph update"
    }
}

# 4. Lanzar actualización de Graphify
$graphifyGlobal = Get-Command graphify -ErrorAction SilentlyContinue
if ($graphifyGlobal) {
    Start-BgProcess -FileName "graphify" -Arguments "update"
} else {
    $uvCheck = Get-Command uv -ErrorAction SilentlyContinue
    if ($uvCheck) {
        Start-BgProcess -FileName "uvx" -Arguments "--from graphifyy graphify update"
    }
}
