# 📁 Unidad 6 · Tarea 6.2 — Implementación DDL y consultas DML

**Alumno:** Edgar Alejandro Hernández Guajardo  
**Matrícula:** I24050409  
**Docente:** Ing. Ruben Riojas  
**Institución:** Instituto Tecnológico Superior de Monclova  
**Materia:** Fundamentos de Bases de Datos

> **Competencia específica:** Aplica los comandos básicos del lenguaje SQL para la definición y manipulación de bases de datos.

## Objetivo
Implementar el esquema de la biblioteca académica en Microsoft SQL Server con **17 tablas, 17 PK y 16 FK**, cargar datos ficticios de prueba, ejecutar consultas LMD (`WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `INNER JOIN`, `LEFT JOIN`) y probar operaciones `UPDATE` / `DELETE` preservando la integridad.

## 📑 Entregables

- 📄 [Reporte técnico PDF](documentacion/Tarea_6.2_Reporte_Tecnico.pdf)
- 📝 [Informe técnico editable Markdown](documentacion/Tarea_6.2_Informe_Tecnico.md)
- 🗄️ [01_schema_ddl.sql](scripts/01_schema_ddl.sql)
- 🧪 [02_data_inserts.sql](scripts/02_data_inserts.sql)
- 🔎 [03_queries_dml.sql](scripts/03_queries_dml.sql)
- 📷 [Guía para capturas auténticas](evidencias/GUIA_CAPTURAS_SSMS.md)
- 📋 [Resultados esperados, no ejecutados](evidencias/resultados_esperados_NO_SON_EVIDENCIA.md)

## Requisitos
- SQL Server 2019 o posterior y SQL Server Management Studio (SSMS).
- Permiso para crear bases de datos y tablas.
- Instancia local de pruebas. No utilizar una base productiva ni la base `Biblioteca` de las unidades anteriores.

## Clonar y ejecutar

```bash
git clone https://github.com/TU-USUARIO/TU-REPOSITORIO.git
cd "TU-REPOSITORIO/Unidad 6/Tarea 6.2"
```

El URL `TU-USUARIO/TU-REPOSITORIO` es **un marcador que debes reemplazar** por la dirección real de GitHub.

1. En SSMS, conectarse a la instancia de SQL Server (por ejemplo `localhost\SQLEXPRESS`).
2. Abrir **`scripts/01_schema_ddl.sql`** con **Archivo > Abrir > Archivo**, verificar que la instancia sea la correcta y ejecutar con **F5**. Este archivo crea `Biblioteca_T62_Demo` si no existe, selecciona la base e instala tablas, índices y restricciones.
3. Abrir **`scripts/02_data_inserts.sql`** y ejecutar **una sola vez**. Este archivo carga ejemplos ficticios en una transacción; si hay error, se revierte.
4. Abrir **`scripts/03_queries_dml.sql`**. Ejecutar primero las consultas **Q01–Q14** y después las pruebas controladas **M01–M06**. Todas las mutaciones de prueba se revierten; no se dejan cambios.
5. Capturar cada resultado real en SSMS según [la guía de evidencias](evidencias/GUIA_CAPTURAS_SSMS.md).

**¡Atención!** Los scripts 01 y 02 están diseñados para ejecutarse una sola vez sobre una base vacía. No borrar la base original. Para repetir desde cero, cree una base de demostración distinta y cambie los `USE`/nombre de base en los tres archivos de manera consistente.

## Consultas incluidas

| Tipo | Bloques |
|---|---|
| Filtros, ordenamientos y SELECT básico | Q01–Q03 |
| Agregación, GROUP BY y HAVING | Q04–Q07, Q10 |
| INNER JOIN y LEFT JOIN | Q08–Q09, Q11 |
| DATEDIFF y comprobación del esquema | Q12–Q14 |
| UPDATE / DELETE + ROLLBACK | M01–M02 |
| Rechazos de FK y CHECK | M03–M05 |
| Revisión final | M06 |

## Advertencia sobre evidencia
El reporte contiene **resultados calculados/esperados del conjunto de prueba**, pero todavía **no contiene capturas reales de SQL Server**. La evidencia exigida en Teams deberá adjuntarse después de la ejecución en SSMS; no se afirma que las consultas se hayan ejecutado en una instancia real.

## Fuentes
- [Microsoft Learn - CREATE TABLE (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql)
- [Microsoft Learn - Restricciones PRIMARY KEY y FOREIGN KEY](https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints)
- [Microsoft Learn - TRY...CATCH](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/try-catch-transact-sql)

⬅️ [Volver a Unidad 6](../README.md)
