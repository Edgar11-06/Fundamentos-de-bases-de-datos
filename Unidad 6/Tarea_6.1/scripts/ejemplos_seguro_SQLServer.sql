/* TAREA 6.1 - Ejemplos seguros de SQL Server (SSMS)
   Solo modifica una tabla temporal local; NO ejecuta DROP/TRUNCATE
   sobre ninguna tabla de la biblioteca académica. */
SET NOCOUNT ON;

-- LDD: CREATE
CREATE TABLE #categoria_demo (
  id_categoria VARCHAR(20) NOT NULL PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  CONSTRAINT CK_categoria_demo_nombre CHECK (LEN(nombre) > 0)
);

-- LDD: ALTER
ALTER TABLE #categoria_demo ADD descripcion VARCHAR(160) NULL;

-- LMD: INSERT
INSERT INTO #categoria_demo (id_categoria,nombre,descripcion)
VALUES ('CAT1','Ciencias','Prueba'), ('CAT2','Literatura','Prueba');

-- LMD: SELECT
SELECT * FROM #categoria_demo ORDER BY id_categoria;

-- LMD: UPDATE con filtro
UPDATE #categoria_demo SET nombre = 'Literatura general'
WHERE id_categoria = 'CAT2';
SELECT * FROM #categoria_demo ORDER BY id_categoria;

-- LMD: DELETE con filtro
DELETE FROM #categoria_demo WHERE id_categoria = 'CAT2';
SELECT COUNT(*) AS filas_despues_delete FROM #categoria_demo;

-- LDD: TRUNCATE en transacción reversible
BEGIN TRANSACTION;
    TRUNCATE TABLE #categoria_demo;
    SELECT COUNT(*) AS filas_dentro_transaccion FROM #categoria_demo;
ROLLBACK TRANSACTION;
SELECT COUNT(*) AS filas_despues_rollback FROM #categoria_demo;

-- LDD: DROP de tabla temporal, no del proyecto real
DROP TABLE #categoria_demo;

-- Demostración adicional opcional: consultar tablas reales sin modificarlas.
IF OBJECT_ID(N'dbo.recurso', N'U') IS NOT NULL
   AND OBJECT_ID(N'dbo.categoria', N'U') IS NOT NULL
BEGIN
  SELECT TOP (5) r.id_recurso, r.titulo, c.nombre AS categoria
  FROM dbo.recurso AS r
  JOIN dbo.categoria AS c ON r.id_categoria = c.id_categoria
  ORDER BY r.titulo;
END;
