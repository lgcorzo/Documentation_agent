#!/bin/bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Uso: ./install-into-repo.sh <ruta_repositorio_destino>"
  exit 1
fi

SOURCE_ROOT="$(cd "$(dirname "$0")" && pwd)"
TARGET_ROOT="$(cd "$1" && pwd)"

echo "=== Instalando DeepWiki Documenter en repositorio destino ==="
echo "Origen:  $SOURCE_ROOT"
echo "Destino: $TARGET_ROOT"

if [ ! -d "$TARGET_ROOT/.git" ]; then
  echo "ERROR: La ruta destino no parece ser un repositorio git: $TARGET_ROOT"
  exit 1
fi

copy_items=(
  ".agentskills"
  "hooks"
  ".graphifyignore"
  ".code-review-graphignore"
  "install.sh"
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

echo "=== Instalación completada en: $TARGET_ROOT ==="
