# 📁 Tarea 6.1 — Sintaxis y clasificación de sentencias SQL (LDD y LMD)

- **Alumno:** Edgar Alejandro Hernández Guajardo
- **Matrícula:** I24050409
- **Materia:** Fundamentos de Bases de Datos
- **Docente:** Ing. Ruben Riojas
- **Institución:** Instituto Tecnológico Superior de Monclova

> **Competencia:** Aplica los comandos básicos del lenguaje SQL para la definición y manipulación de bases de datos.

## 📑 Entregables

- 📄 [Reporte técnico PDF](documentacion/Tarea_6.1_Reporte_Tecnico.pdf)
- 📝 [Archivo fuente Markdown editable](documentacion/Tarea_6.1_Informe_Tecnico.md)
- 🗄️ [Script T-SQL de demostración segura](scripts/ejemplos_seguro_SQLServer.sql)

## 🔍 Tabla taxonómica

| Categoría | Sentencias | Función |
|---|---|---|
| LDD / DDL | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` | Crear, adaptar o retirar estructuras; vaciar tablas |
| LMD / DML | `INSERT`, `UPDATE`, `DELETE`, `SELECT` | Insertar, actualizar, eliminar y consultar filas |

**Nota:** algunos materiales clasifican `SELECT` como DQL; aquí se incluye en LMD como pide la rúbrica y como figura en la documentación oficial de Microsoft. Se emplea la sintaxis de **Microsoft SQL Server (T-SQL)**.

## 🛡️ Ejecución de ejemplo

El script crea `#categoria_demo` como tabla temporal, realiza inserciones, actualizaciones y borrados controlados, demuestra `TRUNCATE` con `ROLLBACK` y limpia los objetos de prueba. No altera las 17 tablas de la biblioteca. Las instrucciones son material didáctico; la ejecución en SSMS debe verificarse localmente.

## 🗂️ Estructura

```text
Tarea 6.1/
├── README.md
├── documentacion/
│   ├── Tarea_6.1_Reporte_Tecnico.pdf
│   └── Tarea_6.1_Informe_Tecnico.md
└── scripts/
    └── ejemplos_seguro_SQLServer.sql
```

## 📚 Referencias

Documentación oficial de Microsoft Learn, enlazada individualmente al final del informe técnico.

⬅️ [Volver al README de la Unidad 6](../README.md)
