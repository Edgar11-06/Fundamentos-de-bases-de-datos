# Unidad 6 · Tarea 6.1
## Sintaxis y clasificación de sentencias SQL (LDD y LMD)

**Instituto Tecnológico Superior de Monclova**  
**Materia:** Fundamentos de Bases de Datos  
**Alumno:** Edgar Alejandro Hernández Guajardo  
**Matrícula:** I24050409  
**Docente:** Ing. Ruben Riojas  
**Proyecto de referencia:** Sistema de gestión de biblioteca académica  
**Motor de referencia:** Microsoft SQL Server 2019 o posterior · Transact-SQL (T-SQL)

> **Competencia específica:** Aplica los comandos básicos del lenguaje SQL para la definición y manipulación de bases de datos.

## Resumen
El lenguaje SQL permite definir estructuras de almacenamiento, consultar registros y modificar datos en un SGBD. En esta actividad se clasifican ocho sentencias en **LDD/DDL** (`CREATE`, `ALTER`, `DROP`, `TRUNCATE`) y **LMD/DML** (`INSERT`, `UPDATE`, `DELETE`, `SELECT`). Se documenta una sintaxis representativa de **T-SQL**, la función de sus parámetros, restricciones de integridad, variantes avanzadas y precauciones para ejecutar los ejemplos sin alterar la base original del proyecto.

**Alcance:** la sintaxis presentada es una forma simplificada, didáctica y válida de SQL Server, no una transcripción de la gramática completa del fabricante. Los dialectos de PostgreSQL, MySQL y otros SGBD pueden variar. Los ejemplos de mutación se diseñaron para una tabla de laboratorio temporal y no implican ejecución real sobre la base Biblioteca.

## 1. Características generales de SQL

- **Declarativo:** expresa qué datos se necesitan o qué cambio debe aplicarse; el optimizador decide cómo ejecutar consultas.
- **Relacional:** utiliza tablas, columnas, filas, claves y restricciones para preservar la consistencia.
- **Estructural y operativo:** el LDD describe objetos; el LMD lee y modifica filas.
- **Transaccional:** en SQL Server se puede agrupar trabajo mediante `BEGIN TRANSACTION`, `COMMIT` y `ROLLBACK`, según el tipo de operación y el contexto.
- **Estandarizado con dialectos:** se basa en SQL estandarizado, pero T-SQL agrega opciones como `TOP`, `OUTPUT`, `IDENTITY` y `GO` (separador de lotes reconocido por herramientas, **no** sentencia T-SQL del motor).
- **Integridad:** restricciones `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `DEFAULT` y `NOT NULL` protegen las relaciones y valores.

### 1.1 Tabla comparativa y taxonómica

| Clasificación | Sentencia | Objeto de acción | Función principal | ¿Cambia estructura? | ¿Cambia filas? |
|---|---|---|---|---|---|
| **LDD / DDL** | `CREATE` | Tabla u otro objeto | Crear estructuras y restricciones. | Sí | No directamente |
| **LDD / DDL** | `ALTER` | Tabla u otro objeto | Modificar una estructura existente. | Sí | Puede afectar datos indirectamente |
| **LDD / DDL** | `DROP` | Tabla u otro objeto | Eliminar el objeto y sus datos asociados. | Sí | Sí, por eliminación del objeto |
| **LDD / DDL** | `TRUNCATE` | Tabla | Vaciar todas las filas conservando la definición. | No elimina definición | Sí, todas |
| **LMD / DML** | `INSERT` | Filas de una tabla | Agregar registros. | No | Sí |
| **LMD / DML** | `UPDATE` | Filas de una tabla | Cambiar valores de registros. | No | Sí |
| **LMD / DML** | `DELETE` | Filas de una tabla | Eliminar registros seleccionados. | No | Sí |
| **LMD / DML** | `SELECT` | Datos de una o más tablas | Consultar y transformar resultados. | No | No |

**Nota taxonómica:** algunas clasificaciones académicas sitúan `SELECT` en DQL (lenguaje de consulta de datos); **Microsoft Learn lo enumera también entre las sentencias DML**, por lo que en esta tarea se incorpora a LMD conforme a las instrucciones. Aunque `TRUNCATE` borra filas, se clasifica como DDL por su operación estructural de desasignación de páginas y sus características de registro y permisos.

### 1.2 Convenciones de sintaxis

- `PALABRAS EN MAYÚSCULA`: palabras reservadas SQL; el uso de mayúsculas es una convención, no un requisito general.
- `nombre_objeto`, `columna`, `expresión`: parámetros que el desarrollador reemplaza.
- `[ ... ]`: elemento opcional en **la notación explicativa**, no los corchetes para delimitar identificadores.
- `{A | B}`: seleccionar una opción, salvo indicación contraria.
- `...`: puede repetirse la estructura señalada.
- El punto y coma `;` termina la sentencia; `GO` separa lotes en SSMS/sqlcmd y no se envía como instrucción al motor.

## 2. Lenguaje de Definición de Datos (LDD / DDL)

### 2.1 `CREATE` — Crear estructuras (ejemplo: tabla con sus columnas y restricciones).

**Sintaxis formal simplificada (T-SQL):**

```sql
CREATE TABLE [esquema.]tabla (
    columna tipo [NULL | NOT NULL] [DEFAULT expresión],
    ...,
    [CONSTRAINT nombre PRIMARY KEY (columna, ...)],
    [CONSTRAINT nombre FOREIGN KEY (columna, ...)
        REFERENCES tabla_destino (columna, ...)],
    [CONSTRAINT nombre CHECK (condición)]
);
```

**Parámetros y componentes:** `tabla`, `columna` y `tipo` definen el esquema; `NULL/NOT NULL` indican obligatoriedad; `DEFAULT` proporciona un valor cuando se omite la columna; `CONSTRAINT` asigna nombres a reglas.

**Opciones avanzadas:** Admite `IDENTITY(seed,increment)`, `UNIQUE`, `CHECK`, `FOREIGN KEY`, acciones `ON DELETE` / `ON UPDATE`, índices y opciones de almacenamiento; dependen de versión y objeto.

**Restricciones y precauciones:** La clave primaria es única y no nula. Una llave foránea debe referenciar una clave candidata válida (PK/UNIQUE o índice UNIQUE permitido). Verificar tipos compatibles y crear primero las tablas referenciadas.

**Ejemplo aplicado (laboratorio de biblioteca):**

```sql
CREATE TABLE dbo.categoria_demo (
    id_categoria VARCHAR(20) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    CONSTRAINT PK_categoria_demo PRIMARY KEY (id_categoria),
    CONSTRAINT UQ_categoria_demo_nombre UNIQUE (nombre)
);
```

**Fuente oficial:** [CREATE — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql).

### 2.2 `ALTER` — Cambiar tablas existentes conservando su identidad y, cuando la modificación sea válida, sus datos.

**Sintaxis formal simplificada (T-SQL):**

```sql
ALTER TABLE [esquema.]tabla
    { ADD columna tipo [NULL | NOT NULL]
    | ALTER COLUMN columna tipo [NULL | NOT NULL]
    | DROP COLUMN columna
    | ADD CONSTRAINT nombre CHECK (condición)
    | DROP CONSTRAINT nombre };
```

**Parámetros y componentes:** `ADD` incorpora columnas o restricciones; `ALTER COLUMN` cambia la definición de una columna; `DROP COLUMN` y `DROP CONSTRAINT` eliminan componentes.

**Opciones avanzadas:** Admite agregar o quitar restricciones, `WITH CHECK` / `WITH NOCHECK` para validación de algunas restricciones, activación/desactivación de restricciones y cambios de partición.

**Restricciones y precauciones:** Una columna `NOT NULL` agregada a una tabla con datos puede requerir valor inicial o una estrategia de migración. Cambiar tipo o tamaño puede fallar por datos incompatibles y dependencias.

**Ejemplo aplicado (laboratorio de biblioteca):**

```sql
ALTER TABLE dbo.categoria_demo
ADD descripcion VARCHAR(200) NULL;

ALTER TABLE dbo.categoria_demo
ADD CONSTRAINT CK_categoria_demo_nombre
CHECK (LEN(nombre) > 0);
```

**Fuente oficial:** [ALTER — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-table-transact-sql).

### 2.3 `DROP` — Eliminar una tabla u otro objeto del esquema.

**Sintaxis formal simplificada (T-SQL):**

```sql
DROP TABLE [IF EXISTS] [esquema.]tabla;
```

**Parámetros y componentes:** `IF EXISTS` evita error cuando el objeto no existe; `esquema.tabla` identifica el objeto exacto.

**Opciones avanzadas:** También hay `DROP VIEW`, `DROP INDEX`, `DROP PROCEDURE` y otros tipos de objetos; las sintaxis son específicas.

**Restricciones y precauciones:** Elimina definición y registros. Una tabla referenciada por una llave foránea de otra tabla no puede eliminarse directamente sin resolver primero esa dependencia. No usar en Biblioteca sin respaldo.

**Ejemplo aplicado (laboratorio de biblioteca):**

```sql
-- SOLO sobre objetos de laboratorio:
DROP TABLE IF EXISTS dbo.categoria_demo;
```

**Fuente oficial:** [DROP — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/statements/drop-table-transact-sql).

### 2.4 `TRUNCATE` — Quitar todas las filas de una tabla sin eliminar la tabla.

**Sintaxis formal simplificada (T-SQL):**

```sql
TRUNCATE TABLE [esquema.]tabla;
```

**Parámetros y componentes:** Recibe el nombre de tabla; **no tiene cláusula `WHERE`**. En SQL Server puede desasignar páginas con registro reducido.

**Opciones avanzadas:** Permite su reversión dentro de una transacción explícita en SQL Server; reinicia el valor de `IDENTITY` cuando corresponde. No activa triggers `DELETE`.

**Restricciones y precauciones:** No admite tablas referenciadas por otra tabla mediante `FOREIGN KEY` (salvo autorreferencia), ni determinadas tablas con vistas indizadas, replicación o temporales versionadas. Aunque suele ser rápido, es una operación de riesgo.

**Ejemplo aplicado (laboratorio de biblioteca):**

```sql
-- Ejecución en transacción de prueba:
BEGIN TRANSACTION;
TRUNCATE TABLE dbo.categoria_demo;
SELECT COUNT(*) AS filas_restantes
FROM dbo.categoria_demo;
ROLLBACK TRANSACTION;
```

**Fuente oficial:** [TRUNCATE — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/statements/truncate-table-transact-sql).

### 2.5 Distinción crítica entre `DROP`, `TRUNCATE` y `DELETE`

| Criterio | `DROP TABLE` | `TRUNCATE TABLE` | `DELETE` |
|---|---|---|---|
| ¿Conserva la tabla? | No | Sí | Sí |
| ¿Permite `WHERE`? | No | No | Sí |
| Alcance sobre las filas | Elimina objeto completo | Todas las filas | Las que cumplan `WHERE`, o todas sin filtro |
| Triggers `DELETE` | No procede | No los dispara | Sí, si existen y son aplicables |
| Llaves foráneas | Impiden eliminar tablas referenciadas | Impiden truncar tablas referenciadas | La acción depende de FK / cascadas |
| Transacción SQL Server | Puede revertirse dentro de una transacción compatible | Puede revertirse dentro de una transacción explícita | Puede revertirse dentro de una transacción |

**Advertencia:** no se debe enseñar que `TRUNCATE` es irreversible por definición; en SQL Server puede revertirse con `ROLLBACK` si participa en una transacción apropiada. `DELETE` sin `WHERE` puede eliminar todos los registros; `DROP` destruye el objeto. <sup>[4][5][7]</sup>

## 3. Lenguaje de Manipulación de Datos (LMD / DML)

### 3.1 `INSERT` — Agregar nuevas filas a una tabla.

**Sintaxis formal simplificada (T-SQL):**

```sql
INSERT [INTO] [esquema.]tabla (columna1, columna2, ...)
    { VALUES (valor1, valor2, ...)
    | SELECT expresión1, expresión2, ... FROM origen };
```

**Parámetros y componentes:** `INTO` identifica destino, lista de columnas determina asignación y `VALUES` especifica valores; `INSERT ... SELECT` incorpora filas a partir de otra consulta.

**Opciones avanzadas:** Múltiples filas en `VALUES`, `DEFAULT VALUES` cuando existan valores predeterminados adecuados, y cláusula `OUTPUT INSERTED.columna` para observar filas insertadas.

**Restricciones y precauciones:** Cumplir `NOT NULL`, PK, UNIQUE, CHECK, FK, tipos y longitudes. Es preferible indicar las columnas explícitamente.

**Ejemplo aplicado:**

```sql
INSERT INTO dbo.categoria_demo (id_categoria, nombre)
VALUES ('CAT-DEMO', 'Literatura');
```

**Fuente oficial:** [INSERT — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql).

### 3.2 `UPDATE` — Modificar columnas de registros existentes.

**Sintaxis formal simplificada (T-SQL):**

```sql
UPDATE [esquema.]tabla
SET columna1 = expresión1 [, columna2 = expresión2 ...]
[OUTPUT INSERTED.columna, DELETED.columna]
[WHERE condición];
```

**Parámetros y componentes:** `SET` define los nuevos valores; `WHERE` selecciona las filas objetivo. `INSERTED` y `DELETED` representan valores nuevos y previos en la cláusula `OUTPUT`.

**Opciones avanzadas:** Admite `UPDATE ... FROM ... JOIN`, `TOP` bajo restricciones y `OUTPUT` para auditoría; se recomienda condición que identifique inequívocamente la fila.

**Restricciones y precauciones:** Sin `WHERE` se actualizan todas las filas. Las restricciones pueden bloquear valores inválidos y referencias incumplidas.

**Ejemplo aplicado:**

```sql
UPDATE dbo.categoria_demo
SET nombre = 'Literatura general'
WHERE id_categoria = 'CAT-DEMO';
```

**Fuente oficial:** [UPDATE — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/queries/update-transact-sql).

### 3.3 `DELETE` — Eliminar filas, preservando la definición de la tabla.

**Sintaxis formal simplificada (T-SQL):**

```sql
DELETE FROM [esquema.]tabla
[OUTPUT DELETED.columna]
[WHERE condición];
```

**Parámetros y componentes:** `FROM` selecciona el objeto; `WHERE` limita registros; `OUTPUT DELETED.*` puede devolver filas afectadas (sujeto a condiciones del entorno).

**Opciones avanzadas:** Puede utilizar `TOP` y la extensión `DELETE ... FROM ... JOIN`; los triggers DELETE pueden ejecutarse.

**Restricciones y precauciones:** Sin `WHERE` intenta eliminar todas las filas. Las FK pueden impedir la operación o aplicar acciones de cascada definidas.

**Ejemplo aplicado:**

```sql
DELETE FROM dbo.categoria_demo
WHERE id_categoria = 'CAT-DEMO';
```

**Fuente oficial:** [DELETE — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/statements/delete-transact-sql).

### 3.4 `SELECT` — Consultar, filtrar, agrupar y combinar información sin modificar los registros originales.

**Sintaxis formal simplificada (T-SQL):**

```sql
SELECT [DISTINCT] [TOP (n)] columna_o_expresión [AS alias], ...
FROM [esquema.]tabla [AS alias]
[JOIN otra_tabla ON condición]
[WHERE condición]
[GROUP BY columna, ...]
[HAVING condición_agregada]
[ORDER BY columna [ASC | DESC]];
```

**Parámetros y componentes:** `SELECT` define columnas y expresiones; `FROM` es el origen; `JOIN` vincula tablas; `WHERE` filtra filas; `GROUP BY` agrupa; `HAVING` filtra grupos; `ORDER BY` establece el orden.

**Opciones avanzadas:** Incluye `DISTINCT`, `TOP`, funciones agregadas, subconsultas, `CASE`, CTE con `WITH`, ventanas (`OVER`) y paginación `OFFSET ... FETCH`.

**Restricciones y precauciones:** `SELECT` sin `ORDER BY` no garantiza orden. `TOP` debe acompañarse preferentemente de `ORDER BY` para resultados previsibles. Los filtros con NULL requieren `IS NULL` / `IS NOT NULL`.

**Ejemplo aplicado:**

```sql
SELECT TOP (5)
    r.id_recurso,
    r.titulo,
    c.nombre AS categoria
FROM dbo.recurso AS r
INNER JOIN dbo.categoria AS c
    ON r.id_categoria = c.id_categoria
ORDER BY r.titulo ASC;
```

**Fuente oficial:** [SELECT — Microsoft Learn](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql).

## 4. Análisis aplicado al proyecto de biblioteca

El esquema previamente elaborado en las Unidades 3 y 4 contiene 17 tablas relacionadas, entre ellas `usuario`, `categoria`, `recurso`, `ejemplar`, `prestamo`, `multa` y `autoria`. En ese contexto, el **LDD** permitió crear la estructura física de la biblioteca y sus claves; el **LMD** permite insertar y consultar registros, corregir valores, y eliminar datos cuando las reglas de negocio lo autorizan.

**Ejemplos de interpretación:** `CREATE TABLE` declara entidades; `ALTER TABLE` adapta campos cuando cambian requisitos; `DROP TABLE` retira objetos de prueba; `TRUNCATE TABLE` vacía datos de laboratorio sujetos a sus restricciones; `INSERT` registra una nueva categoría; `UPDATE` corrige su nombre; `DELETE` retira el registro de prueba; `SELECT` obtiene obras y categorías usando `JOIN`.

El bloque auxiliar `scripts/ejemplos_seguro_SQLServer.sql` usa una tabla de laboratorio `#categoria_demo` para **no modificar la base Biblioteca real**. Incluye comprobaciones, un `UPDATE`, un `DELETE`, una demostración de `TRUNCATE` bajo transacción con `ROLLBACK`, y una consulta informativa de las tablas reales si se encuentran disponibles.

## 5. Validación técnica propuesta

**Validación estática:** revisar sintaxis de los ocho comandos, distinguir LDD/LMD, asegurar que los ejemplos de datos incluyan columnas necesarias, y explicar los riesgos de `WHERE`, FK y `TRUNCATE`.

**Validación práctica pendiente en SSMS:** crear una sesión en SQL Server, ejecutar `scripts/ejemplos_seguro_SQLServer.sql` y conservar las salidas de las consultas; comprobar que el esquema real `dbo.recurso` y `dbo.categoria` devuelve registros mediante el `JOIN` si existe en la base seleccionada. No se afirma una ejecución real de SQL Server desde este documento.

**Criterios de comprobación:** (a) `INSERT` incrementa el número de registros del laboratorio; (b) `UPDATE` cambia el nombre del registro objetivo; (c) `DELETE` elimina solamente el registro señalado; (d) `ROLLBACK` restaura los registros tras `TRUNCATE` en una transacción; (e) `SELECT` reúne correctamente recursos y categorías si se consulta la base original.

## 6. Buenas prácticas

1. Ejecutar primero un `SELECT` con el filtro que se utilizará en `UPDATE` o `DELETE`.
2. Emplear claves primarias, foráneas y `CHECK`; nombrar restricciones para facilitar mantenimiento.
3. Usar transacciones y respaldo antes de cambios destructivos; distinguir laboratorio de producción.
4. Evitar `DROP` y `TRUNCATE` sobre las 17 tablas reales durante una demostración.
5. No asumir equivalencia literal entre T-SQL y otros dialectos de SQL; consultar la versión documentada.

## 7. Conclusión

El LDD establece la estructura y reglas de integridad, mientras el LMD permite registrar, consultar, modificar y eliminar información. Comprender la sintaxis y las restricciones de `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `INSERT`, `UPDATE`, `DELETE` y `SELECT` ayuda a usar SQL de manera segura sobre un diseño relacional como el de la biblioteca académica.

## 8. Referencias

Las fuentes utilizadas corresponden a documentación oficial de Microsoft Learn para SQL Server / Transact-SQL, consultada en noviembre de 2026:


- **CREATE**: [CREATE (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql).

- **ALTER**: [ALTER (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-table-transact-sql).

- **DROP**: [DROP (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/drop-table-transact-sql).

- **TRUNCATE**: [TRUNCATE (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/truncate-table-transact-sql).

- **INSERT**: [INSERT (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/insert-transact-sql).

- **UPDATE**: [UPDATE (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/queries/update-transact-sql).

- **DELETE**: [DELETE (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/statements/delete-transact-sql).

- **SELECT**: [SELECT (Transact-SQL)](https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql).

- **Clasificación DDL/DML**: [Transact-SQL statements](https://learn.microsoft.com/en-us/sql/t-sql/statements/statements).
