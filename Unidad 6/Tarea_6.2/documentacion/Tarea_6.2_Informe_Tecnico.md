# Tarea 6.2 — Implementación de script DDL, carga de datos y consultas DML

**Instituto Tecnológico Superior de Monclova**  
**Alumno:** Edgar Alejandro Hernández Guajardo (I24050409)  
**Materia:** Fundamentos de Bases de Datos  
**Docente:** Ing. Ruben Riojas  
**Proyecto:** Sistema de gestión de biblioteca académica

## 1. Objetivo y alcance
Implementar una copia aislada del modelo físico de 17 tablas de la biblioteca en SQL Server. Cargar datos ficticios con integridad referencial; resolver consultas de selección, filtrado, ordenamiento, agrupación y reunión; y efectuar pruebas controladas de UPDATE y DELETE.

## 2. Entorno y método
SGBD: Microsoft SQL Server 2019+; cliente: SQL Server Management Studio (SSMS); base de práctica: `Biblioteca_T62_Demo`, esquema `dbo`. Se parte del esquema SQL Server normalizado de la Tarea 4.2, preservando las 17 tablas, sus PK, FK, CHECK, UNIQUE, NOT NULL y ciertos índices auxiliares.

## 3. Fase LDD: creación y restricciones
El script `01_schema_ddl.sql` crea una base independiente y ejecuta `CREATE TABLE` y `CREATE INDEX`. Las tablas se crean en orden de dependencias: catálogo y usuarios; subtipos; recursos y subtipos; autorías y ejemplares; bibliotecarios, préstamos y multas.

**Integridad:** 17 claves primarias, 16 referencias foráneas, claves compuestas en `ejemplar` y `autoria`, restricciones CHECK sobre semestre, orden de autoría, número de ejemplar, monto y fechas. Algunas FKs usan ON DELETE CASCADE para dependientes; otras NO ACTION. Las jerarquías total/disjunta y participación mínima no quedan completamente garantizadas por PK/FK y requieren lógica adicional.

## 4. Fase LMD: datos de prueba
`02_data_inserts.sql` carga registros ficticios originales con `BEGIN TRY`, `BEGIN TRANSACTION`, `COMMIT`, `ROLLBACK` y `THROW`. Orden de inserción: tablas padre antes de las tablas hijas. Los conteos esperados figuran más abajo. Reejecutar el INSERT sobre los mismos datos produciría conflictos de claves.

## 5. Consultas LMD y resultados esperados
Las consultas Q01 a Q14 usan `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `INNER JOIN`, `LEFT JOIN`, y `DATEDIFF`. En cada caso se especifica un requerimiento verificable y la salida esperada de los registros ficticios.

| Bloque | Consulta | Salida esperada |
|---|---|---|
| Q01 | CAT001, CAT002, CAT003 | 3 categorías |
| Q02 | USR001, USR003, USR004 | 3 usuarios activos filtrados |
| Q03 | REC001/1, REC002/1, REC003/1 | 3 ejemplares disponibles |
| Q04 | COUNT(*)=4; DISTINCT categorías=3 | 4 recursos; 3 categorías |
| Q05 | Computacion=2, Ciencias=1, Investigacion=1 | 3 categorías agrupadas |
| Q06 | REC001=2 ejemplares | 1 recurso |
| Q07 | SUM=AVG=MAX=MIN=45.00 | 1 multa |
| Q08 | PRE001, PRE002, PRE003 | 3 préstamos |
| Q09 | USR003 aparece con folio NULL | 4 usuarios |
| Q10 | PRE002=45.00 | 1 préstamo con multa >=40 |
| Q11 | REC001 dos autores; REC002, REC003, REC004 uno | 5 autorías |
| Q12 | PRE002, 3 días | 1 retraso |
| Q13 | Conteos según lote 02 | 17 tablas |
| Q14 | 17 tablas, 17 PK, 16 FK | 17 PK y 16 FK |


## 6. Pruebas de mantenimiento e integridad
`M01` ejecuta UPDATE de `USR001` en una transacción y usa ROLLBACK para recuperar su estado original. `M02` elimina un teléfono existente y revierte el cambio. `M03` intenta crear un préstamo asociado a un usuario inexistente: la FK debe rechazarlo. `M04` intenta asignar una multa negativa: CHECK debe rechazarla. `M05` intenta borrar una categoría aún referenciada por recursos: la FK debe rechazarlo. `M06` verifica los conteos originales después de estas pruebas. Las pruebas con errores se manejan con TRY/CATCH y rollback; la base de trabajo no debe quedar alterada.

## 7. Matriz de evidencias por capturar en SSMS
Se necesita capturar: ejecución del esquema (tablas), carga de datos (mensaje de confirmación), Q01–Q14 (consulta y cuadrícula Resultados), M01–M06 (pruebas y rollback). **El archivo actual no contiene capturas reales**; las salidas son expectativas razonadas sobre el conjunto de datos de prueba, no evidencia de una ejecución en servidor SQL. La guía está en `evidencias/GUIA_CAPTURAS_SSMS.md`.

## 8. Conclusiones
La secuencia LDD → inserciones LMD → consultas → mantenimiento controlado integra teoría y práctica del lenguaje SQL. Las claves foráneas y restricciones evitan registros inconsistentes, mientras que las transacciones ofrecen un entorno seguro para probar cambios sin alterar permanentemente los datos del proyecto.

## Referencias
- Microsoft Learn. CREATE TABLE (Transact-SQL). https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql
- Microsoft Learn. Primary and foreign key constraints. https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints
- Microsoft Learn. TRY...CATCH. https://learn.microsoft.com/en-us/sql/t-sql/language-elements/try-catch-transact-sql
