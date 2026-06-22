

Basado en la arquitectura estilo "DeepWiki" y el estándar de **Agent Skills** vamos a orquestar un sistema donde el conocimiento se extrae usando grafos locales (AST) y Hooks de Git (Git Hooks), permitiendo que el agente trabaje en segundo plano manteniendo una carpeta `wiki` perfectamente sincronizada.


---

### Arquitectura General del Sistema

El sistema consta de 3 pilares:

1. **Motores de Grafo Locales:** `Graphify` y `code-review-graph` (CRG) para indexar el código de forma ultrarrápida sin gastar tokens de LLM.
2. **Agent Skills (`SKILL.md`):** El "cerebro" que instruye a Copilot sobre sus reglas estrictas de documentación.
3. **Automatización (Git Hooks):** Scripts que se disparan de forma invisible tras cada commit para mantener el grafo y la wiki al día.

---

### Paso 1: Preparación del Entorno (Motores Locales)

Para que Copilot pueda leer todo el repositorio sin saturar su ventana de contexto, necesitamos motores locales.

1. **Instala el gestor de paquetes `uv`:** Es la forma más rápida de aislar dependencias de Python.
2. **Instala las herramientas de Grafo:** Abre tu terminal y ejecuta:
```bash
uv tool install code-review-graph
uv tool install graphifyy

```


3. *(Opcional pero recomendado)* **Motor Semántico Local:** Si quieres búsquedas semánticas gratuitas y privadas, instala Ollama y descarga el modelo especializado en embeddings: `ollama run nomic-embed-text`.

### Paso 2: Configurar el Agent Skill para Copilot

Vamos a empaquetar el comportamiento de tu agente usando el estándar abierto que Copilot soporta de forma nativa.

1. En la raíz de tu repositorio `lgcorzo/Documentation_agent`, crea la siguiente estructura:
```text
.agentskills/
└── deepwiki_documenter/
    └── SKILL.md

```


2. **Edita el archivo `SKILL.md**` con las instrucciones exactas:
```markdown
---
name: deepwiki-documenter
description: Agente autónomo que genera y actualiza documentación técnica fidedigna en la carpeta /wiki basándose en los cambios del código fuente.
---

# DeepWiki Documenter

## Rol
Eres el arquitecto de documentación principal del repositorio `lgcorzo/Documentation_agent`. Tu objetivo es mantener la carpeta `/wiki` como una fuente de verdad técnica 100% fidedigna y actualizada.

## Instrucciones de Ejecución
1. **Análisis Inicial:** Si la carpeta `/wiki` está vacía o no existe, debes utilizar la herramienta `query_graph_tool` (CRG) y `Graphify` para mapear todo el Árbol de Sintaxis Abstracta (AST) del proyecto. Genera una estructura base que incluya: Arquitectura general, Módulos principales y Guía de inicio.
2. **Actualización Incremental:** Cuando analices un cambio o commit, evalúa el radio de impacto usando `get_impact_radius_tool`.
3. **Redacción:** Refleja los cambios detectados actualizando o creando nuevos archivos Markdown (`.md`) dentro de la carpeta `/wiki`.
4. **Regla de Oro:** NO alucines implementaciones. Si un fragmento de código es ambiguo, documéntalo exactamente como está estructurado lógicamente y marca la ambigüedad.

```



### Paso 3: Optimización Estricta de Tokens (Filtro CRG)

`code-review-graph` inyecta unas 25 herramientas MCP por defecto. Para que Copilot no se ahogue en contexto innecesario, debes filtrar las herramientas.

En el entorno de tu proyecto (o en tu script de instalación inicial), configura la siguiente variable de entorno:

```bash
export CRG_TOOLS="semantic_search_nodes_tool,query_graph_tool,get_impact_radius_tool"

```

*(En Windows usa `$env:CRG_TOOLS="..."` si usas PowerShell).*

### Paso 4: Automatización Invisible (Git Hooks)

Para que el agente sepa qué ha cambiado sin que tú tengas que decírselo, configuraremos un gancho de Git.

1. Crea un script en la ruta `.git/hooks/post-commit` (o configúralo vía Husky si usas Node):
```bash
#!/bin/bash
# Actualiza la base de datos local SQLite de CRG en segundo plano
uvx code-review-graph update --skip-flows &

# Opcional: Aquí puedes añadir un trigger para que Copilot revise los diffs 
# y proponga los cambios de la carpeta /wiki en una nueva rama.

```


2. Dale permisos de ejecución: `chmod +x .git/hooks/post-commit`.

### Paso 5: El `.gitignore` del Repositorio `lgcorzo/Documentation_agent`

El conocimiento debe distribuirse a través del código y las instrucciones, *no* subiendo bases de datos masivas. Añade esto a tu `.gitignore`:

```text
# Ignorar bases de datos de grafos locales
.code-review-graph/
ai-vault/

# Lo que SÍ debes asegurarte que se suba:
# !.agentskills/
# !install.ps1 (o install.sh)
# !.gitignore

```

### Paso 6: Despliegue de la Documentación Inicial (Día 0)

Dado que has mencionado que si no hay documentación previa debe crearla de forma fidedigna:

1. Abre tu IDE (VS Code, etc.) con Copilot activado.
2. Abre el chat de Copilot y haz referencia a tu habilidad: `@workspace Usa la habilidad de deepwiki-documenter para analizar todo el código actual usando CRG y genera la línea base de la documentación en la carpeta /wiki`.
3. El agente utilizará el modelo de relaciones para leer la arquitectura y comenzará a generar los archivos estructurados en la carpeta `wiki/` de tu máquina.

Con esta arquitectura instalada en `lgcorzo/Documentation_agent`, cada vez que tú o tu equipo hagan un nuevo commit, el grafo local mutará en milisegundos. Cuando pidas a Copilot documentar los cambios, tendrá un mapa perfecto del radio de impacto para redactar archivos Wiki sin margen de error.