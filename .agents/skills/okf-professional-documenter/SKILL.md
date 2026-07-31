# Skill: okf-professional-documenter

## Reglas de Documentación
- **Prohibición Absoluta de Rutas Absolutas:** Exigir exclusivamente rutas relativas desde la raíz del repositorio.
- **Espejo Estructural (1:1):** La jerarquía de carpetas en `./openwiki/` debe reflejar exactamente la estructura de `src/` o `Code/`.
- **Extracción Determinista con Pyreverse:** Utilizar Pyreverse (pylint backend) para extraer clases, jerarquías de herencia, polimorfismo y dependencias de paquetes de forma matemática.
- **Diagramas UML 2.0 en Mermaid.js:** Traducir los datos del AST directamente a diagramas de clases, paquetes y flujos de ejecución normalizados.
- **Metadatos Obligatorios OKF v0.2 (Frontmatter YAML):** Cada archivo `.md` debe incluir:

```yaml
---
type: architecture | module | service | adr
title: "Nombre del Componente"
description: "Resumen técnico de responsabilidades"
generated: "agent:okf-professional-documenter"
verified: "true"
stale_after: "2026-12-31"
sources:
  - path: "src/modulos/ejemplo.py:10-45"
---
```
