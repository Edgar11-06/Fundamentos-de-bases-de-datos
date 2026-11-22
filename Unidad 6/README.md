# 📁 Unidad 6: Introducción al lenguaje SQL

- **Nombre:** Edgar Alejandro Hernández Guajardo
- **Matrícula:** I24050409
- **Maestro:** Ing. Ruben Riojas
- **Institución:** Instituto Tecnológico Superior de Monclova
- **Materia:** Fundamentos de Bases de Datos

> **Competencia específica:** Aplica los comandos básicos del lenguaje SQL para la definición y manipulación de bases de datos.

---

## 📑 Actividades de la Unidad 6

1. 📁 **[Tarea 6.1: Sintaxis y clasificación de sentencias SQL (LDD y LMD)](Tarea_6.1/)**
   - 📄 **Entregable PDF:** [Tarea 6.1 - Reporte técnico](Tarea_6.1/documentacion/Tarea_6.1_Reporte_Tecnico.pdf)
   - 📝 **Informe técnico editable:** [Tarea_6.1_Informe_Tecnico.md](Tarea_6.1/documentacion/Tarea_6.1_Informe_Tecnico.md)
   - 🗄️ **Script T-SQL de demostración:** [ejemplos_seguro_SQLServer.sql](Tarea_6.1/scripts/ejemplos_seguro_SQLServer.sql)

2. 📁 **[Tarea 6.2: Implementación de script DDL, carga de datos y consultas DML](Tarea_6.2/)**
   - 📄 **Entregable PDF:** [Tarea 6.2 - Reporte técnico](Tarea_6.2/documentacion/Tarea_6.2_Reporte_Tecnico.pdf)
   - 📝 **Informe técnico editable:** [Tarea_6.2_Informe_Tecnico.md](Tarea_6.2/documentacion/Tarea_6.2_Informe_Tecnico.md)
   - 🗄️ **Creación del esquema:** [01_schema_ddl.sql](Tarea_6.2/scripts/01_schema_ddl.sql)
   - 🧪 **Carga de datos de prueba:** [02_data_inserts.sql](Tarea_6.2/scripts/02_data_inserts.sql)
   - 🔎 **Consultas y mantenimiento DML:** [03_queries_dml.sql](Tarea_6.2/scripts/03_queries_dml.sql)
   - 📷 **Guía de evidencias de ejecución:** [GUIA_CAPTURAS_SSMS.md](Tarea_6.2/evidencias/GUIA_CAPTURAS_SSMS.md)

---

## 📚 Temas abordados

- **Fundamentos de SQL:** características generales, clasificación y sintaxis de sentencias SQL en Microsoft SQL Server (T-SQL).
- **Lenguaje de Definición de Datos (LDD / DDL):** `CREATE`, `ALTER`, `DROP` y `TRUNCATE`; creación y mantenimiento de estructuras.
- **Lenguaje de Manipulación de Datos (LMD / DML):** `INSERT`, `UPDATE`, `DELETE` y `SELECT`; consulta y modificación de registros.
- **Restricciones de integridad:** claves primarias (`PRIMARY KEY`), foráneas (`FOREIGN KEY`), `CHECK`, `UNIQUE` y `NOT NULL`.
- **Consultas sobre la biblioteca académica:** `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `INNER JOIN` y `LEFT JOIN`.
- **Implementación práctica:** esquema de **17 tablas**, scripts de inserción de datos ficticios y operaciones de mantenimiento controladas mediante transacciones.

## ▶️ Ejecución de la Tarea 6.2

Utilizar **Microsoft SQL Server 2019 o posterior** y **SQL Server Management Studio (SSMS)**. Desde la carpeta `Tarea_6.2/scripts/`, ejecutar los archivos **en este orden**:

1. `01_schema_ddl.sql` — crea la base de demostración `Biblioteca_T62_Demo`, las tablas y sus restricciones.
2. `02_data_inserts.sql` — inserta los registros ficticios de prueba.
3. `03_queries_dml.sql` — ejecuta las consultas de comprobación y las pruebas de `UPDATE` y `DELETE` controladas.

Consultar las instrucciones completas en el **[README de la Tarea 6.2](Tarea_6.2/README.md)**.

> **Importante:** Los scripts 01 y 02 deben utilizarse sobre una base de demostración vacía, sin alterar la base `Biblioteca` original. Las capturas reales de SSMS solicitadas para Teams **están pendientes de incorporación** al reporte; la guía proporciona los pasos para obtenerlas.

## 🗂️ Organización de la unidad

```text
Unidad 6/
├── README.md
├── Tarea_6.1/
│   ├── README.md
│   ├── documentacion/
│   │   ├── Tarea_6.1_Reporte_Tecnico.pdf
│   │   └── Tarea_6.1_Informe_Tecnico.md
│   └── scripts/
│       └── ejemplos_seguro_SQLServer.sql
└── Tarea_6.2/
    ├── README.md
    ├── documentacion/
    │   ├── Tarea_6.2_Reporte_Tecnico.pdf
    │   └── Tarea_6.2_Informe_Tecnico.md
    ├── scripts/
    │   ├── 01_schema_ddl.sql
    │   ├── 02_data_inserts.sql
    │   └── 03_queries_dml.sql
    └── evidencias/
        └── GUIA_CAPTURAS_SSMS.md
```

> **Nota:** Los enlaces a videos de YouTube pueden agregarse cuando se publiquen, si se solicitan para la entrega.

---

⬅️ [Volver al README Principal](../README.md)
