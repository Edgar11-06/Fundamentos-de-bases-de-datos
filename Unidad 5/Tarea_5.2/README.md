# 📁 Tarea 5.2: Resolución de consultas con álgebra relacional

- **Alumno:** Edgar Alejandro Hernández Guajardo
- **Matrícula:** I24050409
- **Docente:** Ing. Ruben Riojas
- **Institución:** Instituto Tecnológico Superior de Monclova
- **Materia:** Fundamentos de Bases de Datos

> **Objetivo:** Plantear y resolver formalmente al menos diez consultas del esquema de biblioteca académica, con requisitos en lenguaje natural, expresiones de álgebra relacional, relaciones intermedias y validaciones.

## 📑 Entregables

- 📄 [Reporte técnico PDF](documentacion/Tarea_5.2_Reporte_Tecnico.pdf)
- 📝 [Fuente del informe (Markdown)](documentacion/Tarea_5.2_Informe_Tecnico.md)
- 🗄️ [Catálogo de consultas T-SQL para SSMS](scripts/catalogo_consultas_SQLServer.sql)
- 🧪 [Validador reproducible en Python](scripts/validar_consultas.py)
- 📊 [Resultados de validación con relaciones intermedias (JSON)](validacion/resultados_simulador.json)
- 📂 [Esquema físico original, Tarea 4.2](insumos/normalized_schema.sql)
- 📂 [Datos de prueba originales, Tarea 4.2](insumos/ejemplos_datos_normalizados.sql)

## 🔎 Catálogo de 15 consultas

| Código | Consulta | Nivel | Operación dominante |
|---|---|---|---|
| C01 | Usuarios activos | Básica | σ y π |
| C02 | Catálogo de libros | Básica | ⋈ |
| C03 | Recursos de Computación | Intermedia | σ y ⋈ |
| C04 | Usuarios sin préstamos registrados | Intermedia | − |
| C05 | Autores de un recurso | Intermedia | ⋈ |
| C06 | Recursos escritos por todos los autores requeridos | Avanzada | ÷ |
| C07 | Préstamos, usuarios y títulos | Intermedia | ⋈ encadenado |
| C08 | Todos los usuarios con préstamos opcionales | Avanzada | ⟕ |
| C09 | Montos de multa por usuario | Avanzada | γ, ⟕ |
| C10 | Ejemplares disponibles y sus categorías | Avanzada | σ, ⋈ |
| C11 | Usuarios de tipo estudiante o docente | Intermedia | ∪ |
| C12 | Préstamos devueltos fuera de plazo | Intermedia | σ |
| C13 | Recursos nunca prestados | Intermedia | − |
| C14 | Recursos prestados que cuentan con ejemplares disponibles | Avanzada | ∩ |
| C15 | Combinaciones hipotéticas de categoría y bibliotecario | Básica | × |

## 🛠️ Reproducción

### En Microsoft SQL Server / SSMS
1. Crear una **base vacía** y seleccionarla en SSMS.
2. Ejecutar `insumos/normalized_schema.sql` (crea las 17 tablas).
3. Ejecutar `insumos/ejemplos_datos_normalizados.sql` (inserta el conjunto de ejemplo).
4. Ejecutar `scripts/catalogo_consultas_SQLServer.sql` para mostrar cada relación intermedia y resultado.

> Los resultados incluidos se verificaron en **SQLite en memoria** a partir de los mismos INSERT; no se afirma que el catálogo completo se haya ejecutado en SQL Server. La ejecución en SSMS queda disponible como comprobación adicional.

### Validador local sin dependencias externas

```bash
python scripts/validar_consultas.py
```

El programa reconstruye las tablas de muestra a partir de las sentencias INSERT, ejecuta cada consulta intermedia y compara todas sus salidas con `validacion/resultados_simulador.json`. **No modifica la base SQL Server.**

## 📂 Estructura

```text
Tarea 5.2/
├── README.md
├── documentacion/
│   ├── Tarea_5.2_Reporte_Tecnico.pdf
│   └── Tarea_5.2_Informe_Tecnico.md
├── scripts/
│   ├── catalogo_consultas_SQLServer.sql
│   └── validar_consultas.py
├── insumos/
│   ├── normalized_schema.sql
│   └── ejemplos_datos_normalizados.sql
└── validacion/
    └── resultados_simulador.json
```

## Notas metodológicas

- Los registros son ficticios y derivan de la Tarea 4.2.
- Las operaciones de conjuntos tratan resultados sin duplicados; las consultas de SQL se diseñan conforme a su semántica correspondiente.
- Outer join y agrupación son operadores extendidos. El producto cartesiano de C15 solo genera pares **hipotéticos**.
- La división C06 formula un requerimiento universal («todos los autores requeridos»).

⬅️ [Volver a Unidad 5](../README.md)
