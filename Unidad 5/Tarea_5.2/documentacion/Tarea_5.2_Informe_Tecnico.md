# Instituto Tecnológico Superior de Monclova

# Unidad 5 · Tarea 5.2
**Resolución de consultas sobre el esquema relacional con álgebra formal**

- **Materia:** Fundamentos de Bases de Datos
- **Alumno:** Edgar Alejandro Hernández Guajardo
- **Matrícula:** I24050409
- **Docente:** Ing. Ruben Riojas
- **Caso:** Sistema de gestión de biblioteca académica

## 1. Objetivo y alcance
Resolver mediante álgebra relacional **15 consultas** del esquema de biblioteca, expresando el requerimiento en lenguaje natural, pasos algebraicos, relaciones intermedias, consultas SQL equivalentes y resultados de verificación.

## 2. Esquema y datos de partida
Se reutilizan **sin alteraciones** los archivos `normalized_schema.sql` y `ejemplos_datos_normalizados.sql` de la Tarea 4.2. Las 17 tablas son CATEGORIA, USUARIO, ESTUDIANTE, DOCENTE, EXTERNO, TELEFONO_USUARIO, RECURSO, LIBRO, REVISTA, TESIS, PALABRA_CLAVE_RECURSO, AUTOR, AUTORIA, EJEMPLAR, BIBLIOTECARIO, PRESTAMO y MULTA.

Los datos son **ficticios** y corresponden a los INSERT originales. La validación incluida se efectuó en SQLite en memoria, importando exactamente esos registros, no ejecutando SQL Server; el esquema estructural original es T-SQL para SQL Server. El script `catalogo_consultas_SQLServer.sql` contiene consultas listas para ejecutarse en SSMS una vez importados los datos.

### Total de filas de muestra
| Tabla | Filas |
|---|---:|
| CATEGORIA | 3 |
| USUARIO | 4 |
| ESTUDIANTE | 2 |
| DOCENTE | 1 |
| EXTERNO | 1 |
| TELEFONO_USUARIO | 4 |
| RECURSO | 4 |
| LIBRO | 2 |
| REVISTA | 1 |
| TESIS | 1 |
| PALABRA_CLAVE_RECURSO | 5 |
| AUTOR | 4 |
| AUTORIA | 5 |
| EJEMPLAR | 5 |
| BIBLIOTECARIO | 2 |
| PRESTAMO | 3 |
| MULTA | 1 |

## 3. Convenciones
- σ: selección; π: proyección; ×: producto cartesiano; ∪, ∩, −: operaciones de conjuntos; ÷: división; ⋈: reunión; ⟕: reunión externa izquierda; γ: agrupación y agregación.
- Las relaciones de álgebra clásica son **conjuntos**, sin tuplas duplicadas. SQL sin `DISTINCT` admite duplicados; los resultados se presentan por filas del ejemplo, incluyendo el caso de un usuario con más de un préstamo.
- **Renombrado:** cuando se combina una relación temporal con otra, se asume el nombre calificado de sus atributos, como `USUARIO.id_usuario`.
- La igualdad, ordenación y restricciones de valores NULL se interpretan según el SQL equivalente cuando intervienen operaciones extendidas.
- La división se apoya en el conjunto real de autores requeridos y no en un campo inexistente en el esquema.
- El paso de **T1 a Tn** representa las relaciones intermedias lógicas; el SQL es la implementación equivalente de cada paso, sin crear tablas permanentes.

## 4. Catálogo de consultas

### C01 · Usuarios activos
**Complejidad:** Básica

**Requerimiento:** Mostrar los identificadores y nombres de usuarios cuyo estatus es ACTIVO.

**Expresión algebraica:**

```text
T1 = σ_(estatus = «ACTIVO»)(USUARIO)
T2 = π_(id_usuario, nombre_pila, apellido_paterno)(T1)
```

**Justificación:** Selección σ seguida de proyección π; el resultado omite el estatus.

**T1: usuarios filtrados** — 4 fila(s)

```sql
SELECT id_usuario, nombre_pila, apellido_paterno, estatus FROM usuario WHERE estatus = 'ACTIVO' ORDER BY id_usuario;
```

| id_usuario | nombre_pila | apellido_paterno | estatus |
| --- | --- | --- | --- |
| USR001 | Ana | Lopez | ACTIVO |
| USR002 | Carlos | Ramirez | ACTIVO |
| USR003 | Laura | Torres | ACTIVO |
| USR004 | Miguel | Flores | ACTIVO |

**T2: atributos requeridos** — 4 fila(s)

```sql
SELECT id_usuario, nombre_pila, apellido_paterno FROM usuario WHERE estatus = 'ACTIVO' ORDER BY id_usuario;
```

| id_usuario | nombre_pila | apellido_paterno |
| --- | --- | --- |
| USR001 | Ana | Lopez |
| USR002 | Carlos | Ramirez |
| USR003 | Laura | Torres |
| USR004 | Miguel | Flores |

**Validación:** salida final de **4 filas**, coherente con el conjunto de prueba incluido.

### C02 · Catálogo de libros
**Complejidad:** Básica

**Requerimiento:** Identificar los recursos registrados como libros, con título e ISBN.

**Expresión algebraica:**

```text
T1 = RECURSO ⋈_(RECURSO.id_recurso = LIBRO.id_recurso) LIBRO
T2 = π_(id_recurso, titulo, isbn)(T1)
```

**Justificación:** Reunión interna entre la clase general de recursos y el subtipo LIBRO.

**T1: recursos con subtipo libro** — 2 fila(s)

```sql
SELECT r.id_recurso, r.titulo, l.isbn, l.edicion FROM recurso r JOIN libro l ON r.id_recurso=l.id_recurso ORDER BY r.id_recurso;
```

| id_recurso | titulo | isbn | edicion |
| --- | --- | --- | --- |
| REC001 | Fundamentos de Bases de Datos | 9786070000001 | Segunda |
| REC004 | Programacion y Algoritmos | 9786070000002 | Primera |

**T2: datos de libros** — 2 fila(s)

```sql
SELECT r.id_recurso, r.titulo, l.isbn FROM recurso r JOIN libro l ON r.id_recurso=l.id_recurso ORDER BY r.id_recurso;
```

| id_recurso | titulo | isbn |
| --- | --- | --- |
| REC001 | Fundamentos de Bases de Datos | 9786070000001 |
| REC004 | Programacion y Algoritmos | 9786070000002 |

**Validación:** salida final de **2 filas**, coherente con el conjunto de prueba incluido.

### C03 · Recursos de Computación
**Complejidad:** Intermedia

**Requerimiento:** Listar recursos pertenecientes a la categoría Computacion.

**Expresión algebraica:**

```text
T1 = σ_(nombre = «Computacion»)(CATEGORIA)
T2 = T1 ⋈_(T1.id_categoria = RECURSO.id_categoria) RECURSO
T3 = π_(id_recurso, titulo)(T2)
```

**Justificación:** Primero se filtra la categoría; después se aplica join y proyección.

**T1: categoría elegida** — 1 fila(s)

```sql
SELECT id_categoria, nombre FROM categoria WHERE nombre='Computacion';
```

| id_categoria | nombre |
| --- | --- |
| CAT001 | Computacion |

**T2: unión por clave de categoría** — 2 fila(s)

```sql
SELECT r.id_recurso,r.titulo,c.nombre AS categoria FROM recurso r JOIN categoria c ON r.id_categoria=c.id_categoria WHERE c.nombre='Computacion' ORDER BY r.id_recurso;
```

| id_recurso | titulo | categoria |
| --- | --- | --- |
| REC001 | Fundamentos de Bases de Datos | Computacion |
| REC004 | Programacion y Algoritmos | Computacion |

**T3: recurso y título** — 2 fila(s)

```sql
SELECT r.id_recurso,r.titulo FROM recurso r JOIN categoria c ON r.id_categoria=c.id_categoria WHERE c.nombre='Computacion' ORDER BY r.id_recurso;
```

| id_recurso | titulo |
| --- | --- |
| REC001 | Fundamentos de Bases de Datos |
| REC004 | Programacion y Algoritmos |

**Validación:** salida final de **2 filas**, coherente con el conjunto de prueba incluido.

### C04 · Usuarios sin préstamos registrados
**Complejidad:** Intermedia

**Requerimiento:** Encontrar usuarios cuyo identificador no aparece en la tabla PRESTAMO.

**Expresión algebraica:**

```text
T1 = π_id_usuario(USUARIO)
T2 = π_id_usuario(PRESTAMO)
T3 = T1 − T2
T4 = π_(id_usuario, nombre_pila)(USUARIO ⋈_(USUARIO.id_usuario = T3.id_usuario) T3)
```

**Justificación:** La resta se efectúa sobre relaciones de un único atributo compatible.

**T1: universo usuarios** — 4 fila(s)

```sql
SELECT DISTINCT id_usuario FROM usuario ORDER BY id_usuario;
```

| id_usuario |
| --- |
| USR001 |
| USR002 |
| USR003 |
| USR004 |

**T2: usuarios que prestaron** — 3 fila(s)

```sql
SELECT DISTINCT id_usuario FROM prestamo ORDER BY id_usuario;
```

| id_usuario |
| --- |
| USR001 |
| USR002 |
| USR004 |

**T3: diferencia de conjuntos** — 1 fila(s)

```sql
SELECT id_usuario FROM usuario EXCEPT SELECT id_usuario FROM prestamo;
```

| id_usuario |
| --- |
| USR003 |

**T4: nombres de usuarios sin préstamo** — 1 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila FROM usuario u WHERE NOT EXISTS (SELECT 1 FROM prestamo p WHERE p.id_usuario=u.id_usuario) ORDER BY u.id_usuario;
```

| id_usuario | nombre_pila |
| --- | --- |
| USR003 | Laura |

**Validación:** salida final de **1 filas**, coherente con el conjunto de prueba incluido.

### C05 · Autores de un recurso
**Complejidad:** Intermedia

**Requerimiento:** Indicar los autores y orden de autoría del recurso REC001.

**Expresión algebraica:**

```text
T1 = σ_(id_recurso = «REC001»)(AUTORIA)
T2 = T1 ⋈_(T1.id_autor = AUTOR.id_autor) AUTOR
T3 = π_(nombre, orden_autoria)(T2)
```

**Justificación:** AUTORIA es la relación intermedia N:M entre RECURSO y AUTOR.

**T1: autorías de REC001** — 2 fila(s)

```sql
SELECT id_recurso,id_autor,orden_autoria FROM autoria WHERE id_recurso='REC001' ORDER BY orden_autoria;
```

| id_recurso | id_autor | orden_autoria |
| --- | --- | --- |
| REC001 | AUT001 | 1 |
| REC001 | AUT002 | 2 |

**T2: autorías con nombre** — 2 fila(s)

```sql
SELECT a.id_autor,t.nombre,a.orden_autoria FROM autoria a JOIN autor t ON a.id_autor=t.id_autor WHERE a.id_recurso='REC001' ORDER BY a.orden_autoria;
```

| id_autor | nombre | orden_autoria |
| --- | --- | --- |
| AUT001 | Roberto Mendoza | 1 |
| AUT002 | Sofia Herrera | 2 |

**T3: nombre y orden** — 2 fila(s)

```sql
SELECT t.nombre,a.orden_autoria FROM autoria a JOIN autor t ON a.id_autor=t.id_autor WHERE a.id_recurso='REC001' ORDER BY a.orden_autoria;
```

| nombre | orden_autoria |
| --- | --- |
| Roberto Mendoza | 1 |
| Sofia Herrera | 2 |

**Validación:** salida final de **2 filas**, coherente con el conjunto de prueba incluido.

### C06 · Recursos escritos por todos los autores requeridos
**Complejidad:** Avanzada

**Requerimiento:** Encontrar recursos en cuya lista de autoría figuran tanto AUT001 como AUT002.

**Expresión algebraica:**

```text
S = σ_(id_autor = «AUT001» ∨ id_autor = «AUT002»)(AUTOR)
Y = π_id_autor(S)
X = π_(id_recurso, id_autor)(AUTORIA)
T = X ÷ Y
Resultado = π_(id_recurso, titulo)(T ⋈_(T.id_recurso = RECURSO.id_recurso) RECURSO)
```

**Justificación:** División ÷ expresa el cuantificador «para todos»; el SQL final usa doble NOT EXISTS.

**S: autores requeridos** — 2 fila(s)

```sql
SELECT id_autor FROM autor WHERE id_autor IN ('AUT001','AUT002') ORDER BY id_autor;
```

| id_autor |
| --- |
| AUT001 |
| AUT002 |

**X: pares de autoría** — 5 fila(s)

```sql
SELECT id_recurso,id_autor FROM autoria ORDER BY id_recurso,id_autor;
```

| id_recurso | id_autor |
| --- | --- |
| REC001 | AUT001 |
| REC001 | AUT002 |
| REC002 | AUT003 |
| REC003 | AUT002 |
| REC004 | AUT004 |

**T: división universal** — 1 fila(s)

```sql
SELECT a.id_recurso FROM autoria a GROUP BY a.id_recurso HAVING COUNT(DISTINCT CASE WHEN a.id_autor IN ('AUT001','AUT002') THEN a.id_autor END) = 2 ORDER BY a.id_recurso;
```

| id_recurso |
| --- |
| REC001 |

**Resultado: recursos y títulos** — 1 fila(s)

```sql
SELECT r.id_recurso,r.titulo FROM recurso r WHERE NOT EXISTS (SELECT 1 FROM autor y WHERE y.id_autor IN ('AUT001','AUT002') AND NOT EXISTS (SELECT 1 FROM autoria a WHERE a.id_recurso=r.id_recurso AND a.id_autor=y.id_autor)) ORDER BY r.id_recurso;
```

| id_recurso | titulo |
| --- | --- |
| REC001 | Fundamentos de Bases de Datos |

**Validación:** salida final de **1 filas**, coherente con el conjunto de prueba incluido.

### C07 · Préstamos, usuarios y títulos
**Complejidad:** Intermedia

**Requerimiento:** Mostrar folio, nombre del usuario y título del material prestado.

**Expresión algebraica:**

```text
T1 = PRESTAMO ⋈_(PRESTAMO.id_usuario = USUARIO.id_usuario) USUARIO
T2 = T1 ⋈_(T1.id_recurso = RECURSO.id_recurso) RECURSO
T3 = π_(folio, nombre_pila, titulo)(T2)
```

**Justificación:** Tres relaciones mediante dos joins, con columnas explícitas para evitar confusiones de nombres.

**T1: préstamos con usuario** — 3 fila(s)

```sql
SELECT p.folio,u.nombre_pila FROM prestamo p JOIN usuario u ON p.id_usuario=u.id_usuario ORDER BY p.folio;
```

| folio | nombre_pila |
| --- | --- |
| PRE001 | Ana |
| PRE002 | Carlos |
| PRE003 | Miguel |

**T2: agregar recurso** — 3 fila(s)

```sql
SELECT p.folio,u.nombre_pila,r.titulo FROM prestamo p JOIN usuario u ON p.id_usuario=u.id_usuario JOIN recurso r ON r.id_recurso=p.id_recurso ORDER BY p.folio;
```

| folio | nombre_pila | titulo |
| --- | --- | --- |
| PRE001 | Ana | Fundamentos de Bases de Datos |
| PRE002 | Carlos | Programacion y Algoritmos |
| PRE003 | Miguel | Revista de Tecnologia Aplicada |

**T3: información final** — 3 fila(s)

```sql
SELECT p.folio,u.nombre_pila,r.titulo FROM prestamo p JOIN usuario u ON p.id_usuario=u.id_usuario JOIN recurso r ON r.id_recurso=p.id_recurso ORDER BY p.folio;
```

| folio | nombre_pila | titulo |
| --- | --- | --- |
| PRE001 | Ana | Fundamentos de Bases de Datos |
| PRE002 | Carlos | Programacion y Algoritmos |
| PRE003 | Miguel | Revista de Tecnologia Aplicada |

**Validación:** salida final de **3 filas**, coherente con el conjunto de prueba incluido.

### C08 · Todos los usuarios con préstamos opcionales
**Complejidad:** Avanzada

**Requerimiento:** Mostrar todos los usuarios y sus folios, incluso los que nunca han solicitado un préstamo.

**Expresión algebraica:**

```text
T1 = USUARIO ⟕_(USUARIO.id_usuario = PRESTAMO.id_usuario) PRESTAMO
T2 = π_(id_usuario, nombre_pila, folio)(T1)
```

**Justificación:** El LEFT OUTER JOIN conserva USR003 con folio NULL.

**T1: reunión externa izquierda** — 4 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila,p.folio,p.fecha_prestamo FROM usuario u LEFT JOIN prestamo p ON p.id_usuario=u.id_usuario ORDER BY u.id_usuario,p.folio;
```

| id_usuario | nombre_pila | folio | fecha_prestamo |
| --- | --- | --- | --- |
| USR001 | Ana | PRE001 | 2026-09-01 |
| USR002 | Carlos | PRE002 | 2026-09-03 |
| USR003 | Laura | NULL | NULL |
| USR004 | Miguel | PRE003 | 2026-09-10 |

**T2: campos finales** — 4 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila,p.folio FROM usuario u LEFT JOIN prestamo p ON p.id_usuario=u.id_usuario ORDER BY u.id_usuario,p.folio;
```

| id_usuario | nombre_pila | folio |
| --- | --- | --- |
| USR001 | Ana | PRE001 |
| USR002 | Carlos | PRE002 |
| USR003 | Laura | NULL |
| USR004 | Miguel | PRE003 |

**Validación:** salida final de **4 filas**, coherente con el conjunto de prueba incluido.

### C09 · Montos de multa por usuario
**Complejidad:** Avanzada

**Requerimiento:** Calcular para cada usuario el total de multas registradas, incluyendo usuarios sin multas.

**Expresión algebraica:**

```text
T1 = USUARIO ⟕_(USUARIO.id_usuario = PRESTAMO.id_usuario) PRESTAMO
T2 = T1 ⟕_(T1.folio = MULTA.folio) MULTA
T3 = γ_(id_usuario, nombre_pila; SUM(monto)→total_multas)(T2)
T4 = π_(id_usuario, nombre_pila, COALESCE(total_multas,0)→total)(T3)
```

**Justificación:** Agregación extendida γ y dos reuniones externas. Se suman todas las multas, no solo las pendientes.

**T1: usuarios y folios** — 4 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila,p.folio FROM usuario u LEFT JOIN prestamo p ON p.id_usuario=u.id_usuario ORDER BY u.id_usuario;
```

| id_usuario | nombre_pila | folio |
| --- | --- | --- |
| USR001 | Ana | PRE001 |
| USR002 | Carlos | PRE002 |
| USR003 | Laura | NULL |
| USR004 | Miguel | PRE003 |

**T2: multas asociadas** — 4 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila,p.folio,m.monto FROM usuario u LEFT JOIN prestamo p ON p.id_usuario=u.id_usuario LEFT JOIN multa m ON m.folio=p.folio ORDER BY u.id_usuario;
```

| id_usuario | nombre_pila | folio | monto |
| --- | --- | --- | --- |
| USR001 | Ana | PRE001 | NULL |
| USR002 | Carlos | PRE002 | 45.00 |
| USR003 | Laura | NULL | NULL |
| USR004 | Miguel | PRE003 | NULL |

**T3: sumas agrupadas** — 4 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila,SUM(m.monto) AS total_multas FROM usuario u LEFT JOIN prestamo p ON p.id_usuario=u.id_usuario LEFT JOIN multa m ON m.folio=p.folio GROUP BY u.id_usuario,u.nombre_pila ORDER BY u.id_usuario;
```

| id_usuario | nombre_pila | total_multas |
| --- | --- | --- |
| USR001 | Ana | NULL |
| USR002 | Carlos | 45.0 |
| USR003 | Laura | NULL |
| USR004 | Miguel | NULL |

**T4: nulos convertidos en cero** — 4 fila(s)

```sql
SELECT u.id_usuario,u.nombre_pila,COALESCE(SUM(m.monto),0) AS total FROM usuario u LEFT JOIN prestamo p ON p.id_usuario=u.id_usuario LEFT JOIN multa m ON m.folio=p.folio GROUP BY u.id_usuario,u.nombre_pila ORDER BY u.id_usuario;
```

| id_usuario | nombre_pila | total |
| --- | --- | --- |
| USR001 | Ana | 0 |
| USR002 | Carlos | 45.0 |
| USR003 | Laura | 0 |
| USR004 | Miguel | 0 |

**Validación:** salida final de **4 filas**, coherente con el conjunto de prueba incluido.

### C10 · Ejemplares disponibles y sus categorías
**Complejidad:** Avanzada

**Requerimiento:** Listar ejemplares con estado DISPONIBLE, título y categoría.

**Expresión algebraica:**

```text
T1 = σ_(estado = «DISPONIBLE»)(EJEMPLAR)
T2 = T1 ⋈_(T1.id_recurso = RECURSO.id_recurso) RECURSO
T3 = T2 ⋈_(T2.id_categoria = CATEGORIA.id_categoria) CATEGORIA
T4 = π_(id_recurso, num_ejemplar, titulo, nombre_categoria)(T3)
```

**Justificación:** Aplica selección antes de dos joins; solo ejemplares con estado DISPONIBLE.

**T1: copias disponibles** — 3 fila(s)

```sql
SELECT id_recurso,num_ejemplar,estado FROM ejemplar WHERE estado='DISPONIBLE' ORDER BY id_recurso,num_ejemplar;
```

| id_recurso | num_ejemplar | estado |
| --- | --- | --- |
| REC001 | 1 | DISPONIBLE |
| REC002 | 1 | DISPONIBLE |
| REC003 | 1 | DISPONIBLE |

**T2: nombres de recursos** — 3 fila(s)

```sql
SELECT e.id_recurso,e.num_ejemplar,r.titulo FROM ejemplar e JOIN recurso r ON e.id_recurso=r.id_recurso WHERE e.estado='DISPONIBLE' ORDER BY e.id_recurso,e.num_ejemplar;
```

| id_recurso | num_ejemplar | titulo |
| --- | --- | --- |
| REC001 | 1 | Fundamentos de Bases de Datos |
| REC002 | 1 | Revista de Tecnologia Aplicada |
| REC003 | 1 | Modelo de Gestion Bibliotecaria |

**T3 y T4: añadir categoría y proyectar** — 3 fila(s)

```sql
SELECT e.id_recurso,e.num_ejemplar,r.titulo,c.nombre AS categoria FROM ejemplar e JOIN recurso r ON e.id_recurso=r.id_recurso JOIN categoria c ON c.id_categoria=r.id_categoria WHERE e.estado='DISPONIBLE' ORDER BY e.id_recurso,e.num_ejemplar;
```

| id_recurso | num_ejemplar | titulo | categoria |
| --- | --- | --- | --- |
| REC001 | 1 | Fundamentos de Bases de Datos | Computacion |
| REC002 | 1 | Revista de Tecnologia Aplicada | Ciencias |
| REC003 | 1 | Modelo de Gestion Bibliotecaria | Investigacion |

**Validación:** salida final de **3 filas**, coherente con el conjunto de prueba incluido.

### C11 · Usuarios de tipo estudiante o docente
**Complejidad:** Intermedia

**Requerimiento:** Obtener identificadores de usuarios en cualquiera de los dos subtipos ESTUDIANTE o DOCENTE.

**Expresión algebraica:**

```text
T1 = π_id_usuario(ESTUDIANTE)
T2 = π_id_usuario(DOCENTE)
T3 = T1 ∪ T2
```

**Justificación:** Unión ∪ entre proyecciones con la misma estructura; la especialización es disjunta.

**T1: estudiantes** — 2 fila(s)

```sql
SELECT id_usuario FROM estudiante ORDER BY id_usuario;
```

| id_usuario |
| --- |
| USR001 |
| USR004 |

**T2: docentes** — 1 fila(s)

```sql
SELECT id_usuario FROM docente ORDER BY id_usuario;
```

| id_usuario |
| --- |
| USR002 |

**T3: unión sin duplicados** — 3 fila(s)

```sql
SELECT id_usuario FROM estudiante UNION SELECT id_usuario FROM docente ORDER BY id_usuario;
```

| id_usuario |
| --- |
| USR001 |
| USR002 |
| USR004 |

**Validación:** salida final de **3 filas**, coherente con el conjunto de prueba incluido.

### C12 · Préstamos devueltos fuera de plazo
**Complejidad:** Intermedia

**Requerimiento:** Identificar préstamos cuya devolución registrada ocurrió después de la fecha límite.

**Expresión algebraica:**

```text
T1 = σ_(fecha_devolucion definida ∧ fecha_devolucion > fecha_limite)(PRESTAMO)
T2 = π_(folio, fecha_limite, fecha_devolucion)(T1)
```

**Justificación:** En semántica SQL se verifica IS NOT NULL; comparación temporal con DATE.

**T1: préstamos devueltos tarde** — 1 fila(s)

```sql
SELECT folio,fecha_limite,fecha_devolucion FROM prestamo WHERE fecha_devolucion IS NOT NULL AND fecha_devolucion > fecha_limite ORDER BY folio;
```

| folio | fecha_limite | fecha_devolucion |
| --- | --- | --- |
| PRE002 | 2026-09-17 | 2026-09-20 |

**T2: atributos del resultado** — 1 fila(s)

```sql
SELECT folio,fecha_limite,fecha_devolucion FROM prestamo WHERE fecha_devolucion IS NOT NULL AND fecha_devolucion > fecha_limite ORDER BY folio;
```

| folio | fecha_limite | fecha_devolucion |
| --- | --- | --- |
| PRE002 | 2026-09-17 | 2026-09-20 |

**Validación:** salida final de **1 filas**, coherente con el conjunto de prueba incluido.

### C13 · Recursos nunca prestados
**Complejidad:** Intermedia

**Requerimiento:** Identificar recursos cuyo identificador no está en ningún préstamo histórico.

**Expresión algebraica:**

```text
T1 = π_id_recurso(RECURSO)
T2 = π_id_recurso(PRESTAMO)
T3 = T1 − T2
T4 = π_(id_recurso, titulo)(T3 ⋈_(T3.id_recurso = RECURSO.id_recurso) RECURSO)
```

**Justificación:** Se compara id_recurso, no el ejemplar: responde recursos nunca prestados.

**T1: todos los recursos** — 4 fila(s)

```sql
SELECT id_recurso FROM recurso ORDER BY id_recurso;
```

| id_recurso |
| --- |
| REC001 |
| REC002 |
| REC003 |
| REC004 |

**T2: recursos prestados** — 3 fila(s)

```sql
SELECT DISTINCT id_recurso FROM prestamo ORDER BY id_recurso;
```

| id_recurso |
| --- |
| REC001 |
| REC002 |
| REC004 |

**T3: diferencia** — 1 fila(s)

```sql
SELECT id_recurso FROM recurso EXCEPT SELECT id_recurso FROM prestamo;
```

| id_recurso |
| --- |
| REC003 |

**T4: recursos con título** — 1 fila(s)

```sql
SELECT r.id_recurso,r.titulo FROM recurso r WHERE NOT EXISTS (SELECT 1 FROM prestamo p WHERE p.id_recurso=r.id_recurso) ORDER BY r.id_recurso;
```

| id_recurso | titulo |
| --- | --- |
| REC003 | Modelo de Gestion Bibliotecaria |

**Validación:** salida final de **1 filas**, coherente con el conjunto de prueba incluido.

### C14 · Recursos prestados que cuentan con ejemplares disponibles
**Complejidad:** Avanzada

**Requerimiento:** Encontrar recursos que tienen por lo menos un préstamo histórico y al menos un ejemplar actualmente marcado DISPONIBLE.

**Expresión algebraica:**

```text
T1 = π_id_recurso(PRESTAMO)
T2 = π_id_recurso(σ_(estado = «DISPONIBLE»)(EJEMPLAR))
T3 = T1 ∩ T2
```

**Justificación:** Intersección ∩: historial de préstamos y estado actual son conceptos independientes.

**T1: recursos prestados** — 3 fila(s)

```sql
SELECT DISTINCT id_recurso FROM prestamo ORDER BY id_recurso;
```

| id_recurso |
| --- |
| REC001 |
| REC002 |
| REC004 |

**T2: recursos con copias disponibles** — 3 fila(s)

```sql
SELECT DISTINCT id_recurso FROM ejemplar WHERE estado='DISPONIBLE' ORDER BY id_recurso;
```

| id_recurso |
| --- |
| REC001 |
| REC002 |
| REC003 |

**T3: intersección** — 2 fila(s)

```sql
SELECT id_recurso FROM prestamo INTERSECT SELECT id_recurso FROM ejemplar WHERE estado='DISPONIBLE' ORDER BY id_recurso;
```

| id_recurso |
| --- |
| REC001 |
| REC002 |

**Validación:** salida final de **2 filas**, coherente con el conjunto de prueba incluido.

### C15 · Combinaciones hipotéticas de categoría y bibliotecario
**Complejidad:** Básica

**Requerimiento:** Generar todas las parejas posibles de categoría y bibliotecario para ilustrar el producto cartesiano; no representan asignaciones reales.

**Expresión algebraica:**

```text
T1 = CATEGORIA × BIBLIOTECARIO
T2 = π_(CATEGORIA.nombre→nombre_categoria, BIBLIOTECARIO.nombre→nombre_bibliotecario)(T1)
```

**Justificación:** Producto cartesiano ×: 3 categorías × 2 bibliotecarios = 6 parejas hipotéticas.

**T1: combinación de identificadores** — 6 fila(s)

```sql
SELECT c.id_categoria,b.id_empleado FROM categoria c CROSS JOIN bibliotecario b ORDER BY c.id_categoria,b.id_empleado;
```

| id_categoria | id_empleado |
| --- | --- |
| CAT001 | EMP001 |
| CAT001 | EMP002 |
| CAT002 | EMP001 |
| CAT002 | EMP002 |
| CAT003 | EMP001 |
| CAT003 | EMP002 |

**T2: descripción de pares** — 6 fila(s)

```sql
SELECT c.nombre AS categoria,b.nombre AS bibliotecario FROM categoria c CROSS JOIN bibliotecario b ORDER BY c.id_categoria,b.id_empleado;
```

| categoria | bibliotecario |
| --- | --- |
| Computacion | Mariana Salazar |
| Computacion | Jorge Castillo |
| Ciencias | Mariana Salazar |
| Ciencias | Jorge Castillo |
| Investigacion | Mariana Salazar |
| Investigacion | Jorge Castillo |

**Validación:** salida final de **6 filas**, coherente con el conjunto de prueba incluido.

## 5. Resumen de validación

| Consulta | Tipo | Filas finales |
|---|---|---:|
| C01 · Usuarios activos | Básica | 4 |
| C02 · Catálogo de libros | Básica | 2 |
| C03 · Recursos de Computación | Intermedia | 2 |
| C04 · Usuarios sin préstamos registrados | Intermedia | 1 |
| C05 · Autores de un recurso | Intermedia | 2 |
| C06 · Recursos escritos por todos los autores requeridos | Avanzada | 1 |
| C07 · Préstamos, usuarios y títulos | Intermedia | 3 |
| C08 · Todos los usuarios con préstamos opcionales | Avanzada | 4 |
| C09 · Montos de multa por usuario | Avanzada | 4 |
| C10 · Ejemplares disponibles y sus categorías | Avanzada | 3 |
| C11 · Usuarios de tipo estudiante o docente | Intermedia | 3 |
| C12 · Préstamos devueltos fuera de plazo | Intermedia | 1 |
| C13 · Recursos nunca prestados | Intermedia | 1 |
| C14 · Recursos prestados que cuentan con ejemplares disponibles | Avanzada | 2 |
| C15 · Combinaciones hipotéticas de categoría y bibliotecario | Básica | 6 |

## 6. Consideraciones y limitaciones
- La verificación de los resultados se realizó de manera reproducible con SQLite a partir de los `INSERT` originales. El documento **no afirma** que las 15 consultas se ejecutaron en SQL Server ni que se verificaron en el servicio RelaX.
- SQL Server puede comprobar el catálogo importando los dos archivos de insumo, siguiendo el orden esquema → datos y ejecutando el script de consultas.
- Las consultas C08 y C09 incorporan reuniones externas y la C09 incluye γ; estas expresiones pertenecen al álgebra extendida.
- La consulta C15 construye combinaciones **hipotéticas** para demostrar ×; no implica una relación de negocio existente.
- La consulta C14 combina historial de préstamos con estado de ejemplares registrado en la muestra; no intenta inferir disponibilidad real futura.
- La consulta C12 verifica devoluciones efectivamente registradas fuera de plazo, no todos los préstamos vencidos a una fecha de corte.

## 7. Conclusiones
El catálogo convierte preguntas en lenguaje natural a expresiones formales, etapas intermedias y SQL verificable. A través de consultas de selección, proyección, join, diferencia, intersección, unión, división, producto cartesiano y agregación se demuestra cómo consultar la estructura relacional normalizada de la biblioteca sin duplicar información descriptiva.

## 8. Fuentes
- Esquema de biblioteca y datos ficticios de la Tarea 4.2: `insumos/normalized_schema.sql` y `insumos/ejemplos_datos_normalizados.sql`.
- Tarea 5.1 del mismo proyecto: fundamentos de notación de álgebra relacional.
- Microsoft Learn: [SELECT (Transact-SQL)](https://learn.microsoft.com/sql/t-sql/queries/select-transact-sql).
- Microsoft Learn: [EXCEPT and INTERSECT (Transact-SQL)](https://learn.microsoft.com/sql/t-sql/language-elements/set-operators-except-and-intersect-transact-sql).
