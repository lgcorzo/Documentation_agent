#!/bin/bash
# install.sh
# Script de instalación y configuración automatizada para Ubuntu / Linux.
# Configura Ollama, uv, code-review-graph, graphify y Git Hooks.

# Colores para salida
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo -e "${CYAN}=== Iniciando Instalación del Ecosistema DeepWiki Documenter (Ubuntu/Linux) ===${NC}"

# 1. Verificar/Instalar 'uv' (herramienta de empaquetado de Python)
echo -e "${YELLOW}Verificando instalación de uv...${NC}"
if ! command -v uv &> /dev/null; then
    echo -e "${CYAN}uv no detectado. Instalando uv automáticamente...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Cargar uv en la sesión actual
    source $HOME/.local/bin/env
else
    echo -e "${GREEN}¡uv ya está instalado!${NC}"
fi

# 2. Instalar herramientas globales de Python utilizando uv
echo -e "${YELLOW}Instalando code-review-graph y graphifyy...${NC}"
uv tool install code-review-graph
uv tool install graphifyy

# Asegurar que el PATH del usuario incluya el directorio de herramientas de uv
export PATH="$HOME/.local/bin:$PATH"

# 3. Verificar/Instalar Ollama
echo -e "${YELLOW}Verificando instalación de Ollama...${NC}"
if ! command -v ollama &> /dev/null; then
    echo -e "${CYAN}Ollama no detectado. Instalando vía script oficial...${NC}"
    curl -fsSL https://ollama.com/install.sh | sh
else
    echo -e "${GREEN}¡Ollama ya está instalado!${NC}"
fi

# Asegurar que Ollama esté corriendo
if ! pgrep -x "ollama" > /dev/null; then
    echo -e "${CYAN}Iniciando servicio de Ollama...${NC}"
    if command -v systemctl &> /dev/null; then
        sudo systemctl start ollama
    else
        nohup ollama serve > /dev/null 2>&1 &
    fi
    sleep 5
fi

# Descargar modelo de embeddings
echo -e "${CYAN}Descargando modelo de embeddings 'nomic-embed-text' en Ollama...${NC}"
ollama pull nomic-embed-text

# 4. Configurar variable de entorno CRG_TOOLS (Optimización de tokens para Copilot)
CRG_TOOLS_VAL="semantic_search_nodes_tool,query_graph_tool,get_impact_radius_tool,get_review_context_tool"
export CRG_TOOLS="$CRG_TOOLS_VAL"

# Persistir la variable de entorno para el usuario
SHELL_RC="$HOME/.bashrc"
[ -n "$ZSH_VERSION" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q "CRG_TOOLS" "$SHELL_RC"; then
    echo -e "\n# Ecosistema DeepWiki Documenter" >> "$SHELL_RC"
    echo "export CRG_TOOLS=\"$CRG_TOOLS_VAL\"" >> "$SHELL_RC"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_RC"
    echo -e "${GREEN}Variable CRG_TOOLS y PATH añadidas a $SHELL_RC.${NC}"
fi

# 5. Registrar herramientas MCP en el entorno local
echo -e "${YELLOW}Registrando herramientas en los editores compatibles...${NC}"
code-review-graph install -y --platform copilot --no-skills --no-hooks --no-instructions

# 6. Verificar archivos de configuración esperados
echo -e "${YELLOW}Verificando archivos ignore en la raíz del repositorio...${NC}"
[ ! -f "./.graphifyignore" ] && echo -e "${YELLOW}ADVERTENCIA: Falta el archivo .graphifyignore en la raíz del repositorio.${NC}"
[ ! -f "./.code-review-graphignore" ] && echo -e "${YELLOW}ADVERTENCIA: Falta el archivo .code-review-graphignore en la raíz del repositorio.${NC}"

# 7. Instalar Git Hooks locales
if [ -d ".git" ]; then
    echo -e "${YELLOW}Instalando Git Hooks para automatizar la wiki...${NC}"
    HOOKS_DIR=".git/hooks"
    mkdir -p "$HOOKS_DIR"
    cp "./hooks/post-commit" "./$HOOKS_DIR/post-commit"
    cp "./hooks/post-checkout" "./$HOOKS_DIR/post-checkout"
    cp "./hooks/update-graph.ps1" "./$HOOKS_DIR/update-graph.ps1"
    cp "./hooks/update-graph-checkout.ps1" "./$HOOKS_DIR/update-graph-checkout.ps1"
    
    # Otorgar permisos de ejecución a los hooks
    chmod +x "./$HOOKS_DIR/post-commit"
    chmod +x "./$HOOKS_DIR/post-checkout"
    echo -e "${GREEN}¡Git Hooks instalados y con permisos de ejecución!${NC}"
else
    echo -e "${YELLOW}ADVERTENCIA: No se detectó un directorio '.git'. Asegúrate de estar en la raíz de un repositorio Git para instalar los hooks.${NC}"
fi

# 8. Construcción del Grafo y Generación de Embeddings iniciales
echo -e "${CYAN}Construyendo el mapa estructural del código (build)...${NC}"
code-review-graph build

echo -e "${CYAN}Generando vectores semánticos con Ollama (embed)...${NC}"
uvx --from "code-review-graph[embeddings]" code-review-graph embed

echo -e "${CYAN}Sincronizando skills de Graphify para evitar desfases de versión...${NC}"
graphify install --platform copilot

echo -e "${CYAN}Actualizando la DeepWiki (graphify)...${NC}"
graphify update

echo -e "${GREEN}=== ¡Instalación Completada con Éxito! ===${NC}"
echo -e "${GREEN}GitHub Copilot ahora cuenta con búsquedas semánticas locales y mantiene tu DeepWiki viva.${NC}"
echo -e "${CYAN}Nota: Por favor, ejecuta 'source $SHELL_RC' en tus terminales abiertas para aplicar los cambios de variables.${NC}"
