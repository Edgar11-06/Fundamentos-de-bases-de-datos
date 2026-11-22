/* TAREA 6.2 — FASE 03: CONSULTAS LMD Y PRUEBAS SEGURAS
   Ejecutar tras 01_schema_ddl.sql y 02_data_inserts.sql.
   Se permiten ejecuciones repetidas: las mutaciones se revierten.
   Cada SELECT devuelve un conjunto de resultados capturable en SSMS.
*/
USE Biblioteca_T62_Demo;
GO
SET NOCOUNT ON;

-- Q01 | SELECT básico: catálogo de categorías
SELECT id_categoria, nombre, descripcion FROM dbo.categoria ORDER BY id_categoria;

-- Q02 | WHERE con condiciones (AND / IN)
SELECT id_usuario, nombre_pila, apellido_paterno, estatus
FROM dbo.usuario WHERE estatus = 'ACTIVO' AND id_usuario IN ('USR001','USR003','USR004')
ORDER BY apellido_paterno, nombre_pila;

-- Q03 | ORDER BY y filtros: ejemplares disponibles
SELECT id_recurso, num_ejemplar, estado, ubicacion
FROM dbo.ejemplar WHERE estado='DISPONIBLE'
ORDER BY id_recurso ASC, num_ejemplar DESC;

-- Q04 | COUNT global y DISTINCT
SELECT COUNT(*) AS total_recursos, COUNT(DISTINCT id_categoria) AS categorias_utilizadas
FROM dbo.recurso;

-- Q05 | COUNT y GROUP BY: recursos por categoría
SELECT c.id_categoria, c.nombre, COUNT(r.id_recurso) AS total_recursos
FROM dbo.categoria AS c LEFT JOIN dbo.recurso AS r ON r.id_categoria=c.id_categoria
GROUP BY c.id_categoria, c.nombre ORDER BY total_recursos DESC,c.nombre;

-- Q06 | HAVING después de GROUP BY: recursos con 2 o más ejemplares
SELECT e.id_recurso, COUNT(*) AS ejemplares
FROM dbo.ejemplar AS e GROUP BY e.id_recurso HAVING COUNT(*)>=2;

-- Q07 | SUM, AVG, MAX, MIN de las multas
SELECT COUNT(*) AS cantidad, SUM(monto) AS total, AVG(monto) AS promedio,
MAX(monto) AS monto_maximo, MIN(monto) AS monto_minimo FROM dbo.multa;

-- Q08 | INNER JOIN: préstamos, usuarios y recursos
SELECT p.folio,u.nombre_pila,u.apellido_paterno,r.titulo,p.fecha_prestamo,p.fecha_limite
FROM dbo.prestamo AS p
INNER JOIN dbo.usuario AS u ON u.id_usuario=p.id_usuario
INNER JOIN dbo.recurso AS r ON r.id_recurso=p.id_recurso
ORDER BY p.folio;

-- Q09 | LEFT JOIN: mostrar usuarios incluso si no registraron préstamos
SELECT u.id_usuario,u.nombre_pila,p.folio,p.fecha_prestamo
FROM dbo.usuario AS u LEFT JOIN dbo.prestamo AS p ON p.id_usuario=u.id_usuario
ORDER BY u.id_usuario,p.folio;

-- Q10 | GROUP BY + HAVING + SUM: préstamos con multas de al menos 40
SELECT p.folio,SUM(m.monto) AS total_multa
FROM dbo.prestamo AS p INNER JOIN dbo.multa AS m ON m.folio=p.folio
GROUP BY p.folio HAVING SUM(m.monto)>=40 ORDER BY total_multa DESC;

-- Q11 | INNER JOIN: recursos y sus autores
SELECT r.id_recurso,r.titulo,a.nombre AS autor,au.orden_autoria
FROM dbo.recurso AS r INNER JOIN dbo.autoria AS au ON au.id_recurso=r.id_recurso
INNER JOIN dbo.autor AS a ON a.id_autor=au.id_autor
ORDER BY r.id_recurso,au.orden_autoria;

-- Q12 | SQL Server: fecha de devolución y condición de retraso
SELECT folio,fecha_limite,fecha_devolucion,
DATEDIFF(DAY,fecha_limite,fecha_devolucion) AS dias_retraso
FROM dbo.prestamo
WHERE fecha_devolucion>fecha_limite ORDER BY folio;

-- Q13 | Contar filas en todas las 17 tablas
SELECT t.name AS tabla,SUM(p.rows) AS registros
FROM sys.tables t JOIN sys.partitions p ON t.object_id=p.object_id AND p.index_id IN (0,1)
WHERE t.schema_id=SCHEMA_ID('dbo') GROUP BY t.name ORDER BY t.name;

-- Q14 | Validar físicamente PK y FK existentes
SELECT (SELECT COUNT(*) FROM sys.tables WHERE schema_id=SCHEMA_ID('dbo')) AS tablas,
 (SELECT COUNT(*) FROM sys.key_constraints WHERE type='PK' AND schema_id=SCHEMA_ID('dbo')) AS claves_primarias,
 (SELECT COUNT(*) FROM sys.foreign_keys WHERE schema_id=SCHEMA_ID('dbo')) AS claves_foraneas;
GO

/* PRUEBAS CONTROLADAS: TODAS LAS MUTACIONES CONFIRMADAS SE REVIERTEN.
   En las pruebas de errores, XACT_ABORT OFF permite que TRY/CATCH documente
   el rechazo sin cancelar el resto del lote. Nunca ejecutar sobre producción. */
SET XACT_ABORT OFF;
GO
-- M01 | UPDATE válido: cambiar estatus en una transacción y ROLLBACK
BEGIN TRANSACTION;
UPDATE dbo.usuario SET estatus='INACTIVO' WHERE id_usuario='USR001';
SELECT 'M01 dentro de transaccion' AS prueba,id_usuario,estatus FROM dbo.usuario WHERE id_usuario='USR001';
ROLLBACK TRANSACTION;
SELECT 'M01 despues de ROLLBACK' AS prueba,id_usuario,estatus FROM dbo.usuario WHERE id_usuario='USR001';
GO

-- M02 | DELETE válido: fila hija sin historial asociado; se revierte
BEGIN TRANSACTION;
DELETE FROM dbo.telefono_usuario WHERE id_usuario='USR003' AND telefono='8661000003';
SELECT 'M02 dentro de transaccion' AS prueba,COUNT(*) AS telefonos
FROM dbo.telefono_usuario WHERE id_usuario='USR003';
ROLLBACK TRANSACTION;
SELECT 'M02 despues de ROLLBACK' AS prueba,COUNT(*) AS telefonos
FROM dbo.telefono_usuario WHERE id_usuario='USR003';
GO

-- M03 | FOREIGN KEY: INSERT de préstamo con usuario inexistente, debe rechazarse
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT INTO dbo.prestamo
    (folio,id_usuario,id_recurso,num_ejemplar,id_empleado,fecha_prestamo,fecha_limite,fecha_devolucion)
    VALUES ('PRE_ERR_T62','USR_INEXISTENTE','REC001',1,'EMP001','2026-11-01','2026-11-15',NULL);
    SELECT 'M03 ADVERTENCIA: FK no rechazo insercion' AS resultado;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    SELECT 'M03 rechazo esperado por FOREIGN KEY' AS resultado,ERROR_NUMBER() AS error_numero,ERROR_MESSAGE() AS detalle;
END CATCH;
GO

-- M04 | CHECK: monto negativo, debe rechazarse
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.multa SET monto=-5 WHERE id_multa='MUL001';
    SELECT 'M04 ADVERTENCIA: CHECK no rechazo' AS resultado;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    SELECT 'M04 rechazo esperado por CHECK' AS resultado,ERROR_NUMBER() AS error_numero,ERROR_MESSAGE() AS detalle;
END CATCH;
GO

-- M05 | Integridad referencial: eliminar categoría padre con recursos, debe rechazarse
BEGIN TRY
    BEGIN TRANSACTION;
    DELETE FROM dbo.categoria WHERE id_categoria='CAT001';
    SELECT 'M05 ADVERTENCIA: FK no rechazo DELETE' AS resultado;
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRANSACTION;
    SELECT 'M05 rechazo esperado por FOREIGN KEY' AS resultado,ERROR_NUMBER() AS error_numero,ERROR_MESSAGE() AS detalle;
END CATCH;
GO

-- M06 | Verificación final de conservación de registros
SELECT (SELECT COUNT(*) FROM dbo.usuario) AS usuarios,
       (SELECT COUNT(*) FROM dbo.prestamo) AS prestamos,
       (SELECT COUNT(*) FROM dbo.multa) AS multas,
       (SELECT COUNT(*) FROM dbo.telefono_usuario) AS telefonos;
GO
