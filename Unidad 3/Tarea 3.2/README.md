# Tarea 3.2 — Esquema físico de biblioteca en SQL Server

**Unidad 3: Modelo relacional**  
**Alumno:** Edgar Alejandro Hernández Guajardo · **Matrícula:** I24050409  
**Institución:** Instituto Tecnológico Superior de Monclova  
**Docente:** Ing. Ruben Riojas

## Objetivo

Implementar en Microsoft SQL Server el esquema relacional de biblioteca de la Tarea 3.1 mediante un script DDL con tablas, PK, FK, CHECK, NOT NULL, UNIQUE y acciones referenciales.

## Archivos

- [Reporte técnico PDF](documentacion/Tarea_3.2.pdf)
- [Script SQL Server schema.sql](documentacion/schema.sql)
- [Diagrama real de SSMS (PNG)](diagramas/diagrama_fisico_SQLServer_SSMS.png)
- [Diagrama real de SSMS (SVG con imagen incrustada)](diagramas/diagrama_fisico_SQLServer_SSMS.svg)
- [Diagrama real de SSMS (PDF)](diagramas/diagrama_fisico_SQLServer_SSMS.pdf)
- [Mermaid editable](diagramas/esquema_fisico.mmd)
- [Draw.io editable](diagramas/esquema_fisico.drawio)
- [Guía de evidencias](evidencias/GUIA_EVIDENCIAS_SQLSERVER.md)

## Diagrama físico generado en SQL Server

![Diagrama físico generado en SQL Server Management Studio](diagramas/diagrama_fisico_SQLServer_SSMS.png)

**Figura 1.** Diagrama físico capturado directamente en SQL Server Management Studio (SSMS). La captura muestra las relaciones entre las 17 tablas del esquema `dbo`. La parte inferior de la captura original está recortada; si se requiere mostrar completamente cada campo, conviene exportar una captura más amplia desde SSMS.

## Tablas del esquema

| Tabla | Función |
|---|---|
| categoria | Clasificación de recursos |
| usuario | Personas usuarias |
| estudiante | Subtipo de usuario |
| docente | Subtipo de usuario |
| externo | Subtipo de usuario |
| telefono_usuario | Teléfonos de usuarios |
| recurso | Material bibliográfico |
| libro | Subtipo de recurso |
| revista | Subtipo de recurso |
| tesis | Subtipo de recurso |
| palabra_clave_recurso | Palabras clave |
| autor | Autores |
| autoria | Relación entre autor y recurso |
| ejemplar | Copias de un recurso |
| bibliotecario | Personal responsable |
| prestamo | Historial de préstamos |
| multa | Sanciones relacionadas con préstamos |

El diccionario completo de columnas, tipos y nulabilidad se encuentra en el PDF.

## Datos de prueba

El archivo `documentacion/schema.sql` incluye sentencias `INSERT INTO` con datos ficticios en las **17 tablas**, respetando las llaves foráneas. Incluye consultas `SELECT` para verificar el número de registros y consultar préstamos relacionados con usuarios y recursos. Los datos se insertan en una transacción con `TRY/CATCH` y reversión en caso de error. **Ejecutar sobre una base nueva**, ya que volver a ejecutar el script producirá conflictos por tablas y claves existentes.

## Ejecutar en SQL Server Management Studio

1. Conéctate a SQL Server.
2. Crea una base de datos llamada `Biblioteca`.
3. Selecciona la base de datos `Biblioteca`.
4. Abre `documentacion/schema.sql` y ejecútalo con **F5**.
5. Verifica que existan 17 tablas con la consulta al final del script.
6. Captura la ejecución, las restricciones y el diagrama generado en SSMS.

> Las capturas de ejecución, inserción y listado de tablas fueron proporcionadas por el alumno desde SSMS. La ejecución no se ha reproducido independientemente en este entorno.

## Integridad

El archivo define 17 PK y 16 FK, además de CHECK, UNIQUE y NOT NULL. Usa ON DELETE CASCADE en dependencias correspondientes y NO ACTION para otras relaciones. Las jerarquías total/disjunta necesitan validaciones transaccionales adicionales.

## Referencias

- [CREATE TABLE — Microsoft Learn](https://learn.microsoft.com/sql/t-sql/statements/create-table-transact-sql)
- [Primary and foreign key constraints — Microsoft Learn](https://learn.microsoft.com/sql/relational-databases/tables/primary-and-foreign-key-constraints)

## Evidencias aportadas

- [Ejecución y resultados](evidencias/01_evidencia.png)
- [Código de inserción](evidencias/02_evidencia.png)
- [17 tablas en SSMS](evidencias/03_evidencia.png)

**Diagrama recibido:** [captura del diagrama físico generado en SSMS](evidencias/04_diagrama_generado_en_SSMS.png).

## Estado de evidencias

Las tres capturas previas de ejecución, inserciones y tablas se incluyen en `evidencias/`, junto con `04_diagrama_generado_en_SSMS.png`. El reporte actualizado las organiza en sus secciones correspondientes. Los archivos `.drawio`, `.mmd` y `.dot` son **representaciones editables alternativas**, no exportaciones nativas de SSMS. La captura PNG es la evidencia original; PDF y SVG son conversiones de esa captura, no diagramas editables nativos.
