#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Uso: ./install-into-repo.sh <ruta_repositorio_destino>"
  exit 1
fi

SOURCE_ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET_ROOT="$(cd "$1" && pwd)"

if [ "$SOURCE_ROOT" = "$TARGET_ROOT" ]; then
  echo "ERROR: El repositorio origen y destino son el mismo. Evita instalar sobre el propio repositorio."
  exit 1
fi

echo "=== Instalando DeepWiki Documenter en repositorio destino ==="
echo "Origen:  $SOURCE_ROOT"
echo "Destino: $TARGET_ROOT"

if [ ! -d "$TARGET_ROOT/.git" ]; then
  echo "ERROR: La ruta destino no parece ser un repositorio git: $TARGET_ROOT"
  exit 1
fi

copy_items=(
  ".agents"
  "hooks"
  ".graphifyignore"
  "install.sh"
  "skills"
)

for item in "${copy_items[@]}"; do
  src="$SOURCE_ROOT/$item"
  dst="$TARGET_ROOT/$item"

  if [ ! -e "$src" ]; then
    echo "ERROR: No se encontró el recurso requerido: $src"
    exit 1
  fi

  if [ -d "$src" ]; then
    mkdir -p "$dst"
    cp -R "$src"/. "$dst"/
  else
    cp "$src" "$dst"
  fi
done

echo "Archivos del agente copiados. Ejecutando instalador en destino..."
(
  cd "$TARGET_ROOT"
  chmod +x ./install.sh
  ./install.sh
)

echo "Verificando instalación en destino..."
required_paths=(
  ".git/hooks/post-commit"
  ".git/hooks/post-checkout"
  "graphify-out/GRAPH_REPORT.md"
)

missing=()
for required in "${required_paths[@]}"; do
  if [ ! -e "$TARGET_ROOT/$required" ]; then
    missing+=("$required")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  printf 'ERROR: La instalación finalizó con faltantes: %s\n' "${missing[*]}"
  exit 1
fi

echo "Verificación final completada correctamente."

echo "=== Instalación completada en: $TARGET_ROOT ==="
