/* TAREA 5.2: CATÁLOGO DE 15 CONSULTAS PARA MICROSOFT SQL SERVER
   Requiere ejecutar previamente los archivos de insumos:
   1) normalized_schema.sql  (en una base VACÍA)
   2) ejemplos_datos_normalizados.sql
   Seleccionar la base creada en SSMS antes de ejecutar este archivo.
   Las secciones contienen los pasos SQL equivalentes a las relaciones algebraicas.
*/
SET NOCOUNT ON;
GO

-- ========================================================================
-- C01 | Usuarios activos
-- REQUERIMIENTO: Mostrar los identificadores y nombres de usuarios cuyo estatus es ACTIVO.
-- ALGEBRA: T1 = σ_(estatus = «ACTIVO»)(USUARIO) | T2 = π_(id_usuario, nombre_pila, apellido_paterno)(T1)
-- ========================================================================
-- T1: usuarios filtrados
SELECT id_usuario, nombre_pila, apellido_paterno, estatus FROM dbo.usuario WHERE estatus = 'ACTIVO' ORDER BY id_usuario;
GO

-- T2: atributos requeridos
SELECT id_usuario, nombre_pila, apellido_paterno FROM dbo.usuario WHERE estatus = 'ACTIVO' ORDER BY id_usuario;
GO

-- ========================================================================
-- C02 | Catálogo de libros
-- REQUERIMIENTO: Identificar los recursos registrados como libros, con título e ISBN.
-- ALGEBRA: T1 = RECURSO ⋈_(RECURSO.id_recurso = LIBRO.id_recurso) LIBRO | T2 = π_(id_recurso, titulo, isbn)(T1)
-- ========================================================================
-- T1: recursos con subtipo libro
SELECT r.id_recurso, r.titulo, l.isbn, l.edicion FROM dbo.recurso r JOIN dbo.libro l ON r.id_recurso=l.id_recurso ORDER BY r.id_recurso;
GO

-- T2: datos de libros
SELECT r.id_recurso, r.titulo, l.isbn FROM dbo.recurso r JOIN dbo.libro l ON r.id_recurso=l.id_recurso ORDER BY r.id_recurso;
GO

-- ========================================================================
-- C03 | Recursos de Computación
-- REQUERIMIENTO: Listar recursos pertenecientes a la categoría Computacion.
-- ALGEBRA: T1 = σ_(nombre = «Computacion»)(CATEGORIA) | T2 = T1 ⋈_(T1.id_categoria = RECURSO.id_categoria) RECURSO | T3 = π_(id_recurso, titulo)(T2)
-- ========================================================================
-- T1: categoría elegida
SELECT id_categoria, nombre FROM dbo.categoria WHERE nombre='Computacion';
GO

-- T2: unión por clave de categoría
SELECT r.id_recurso,r.titulo,c.nombre AS categoria FROM dbo.recurso r JOIN dbo.categoria c ON r.id_categoria=c.id_categoria WHERE c.nombre='Computacion' ORDER BY r.id_recurso;
GO

-- T3: recurso y título
SELECT r.id_recurso,r.titulo FROM dbo.recurso r JOIN dbo.categoria c ON r.id_categoria=c.id_categoria WHERE c.nombre='Computacion' ORDER BY r.id_recurso;
GO

-- ========================================================================
-- C04 | Usuarios sin préstamos registrados
-- REQUERIMIENTO: Encontrar usuarios cuyo identificador no aparece en la tabla PRESTAMO.
-- ALGEBRA: T1 = π_id_usuario(USUARIO) | T2 = π_id_usuario(PRESTAMO) | T3 = T1 − T2 | T4 = π_(id_usuario, nombre_pila)(USUARIO ⋈_(USUARIO.id_usuario = T3.id_usuario) T3)
-- ========================================================================
-- T1: universo usuarios
SELECT DISTINCT id_usuario FROM dbo.usuario ORDER BY id_usuario;
GO

-- T2: usuarios que prestaron
SELECT DISTINCT id_usuario FROM dbo.prestamo ORDER BY id_usuario;
GO

-- T3: diferencia de conjuntos
SELECT id_usuario FROM dbo.usuario EXCEPT SELECT id_usuario FROM dbo.prestamo;
GO

-- T4: nombres de usuarios sin préstamo
SELECT u.id_usuario,u.nombre_pila FROM dbo.usuario u WHERE NOT EXISTS (SELECT 1 FROM dbo.prestamo p WHERE p.id_usuario=u.id_usuario) ORDER BY u.id_usuario;
GO

-- ========================================================================
-- C05 | Autores de un recurso
-- REQUERIMIENTO: Indicar los autores y orden de autoría del recurso REC001.
-- ALGEBRA: T1 = σ_(id_recurso = «REC001»)(AUTORIA) | T2 = T1 ⋈_(T1.id_autor = AUTOR.id_autor) AUTOR | T3 = π_(nombre, orden_autoria)(T2)
-- ========================================================================
-- T1: autorías de REC001
SELECT id_recurso,id_autor,orden_autoria FROM dbo.autoria WHERE id_recurso='REC001' ORDER BY orden_autoria;
GO

-- T2: autorías con nombre
SELECT a.id_autor,t.nombre,a.orden_autoria FROM dbo.autoria a JOIN dbo.autor t ON a.id_autor=t.id_autor WHERE a.id_recurso='REC001' ORDER BY a.orden_autoria;
GO

-- T3: nombre y orden
SELECT t.nombre,a.orden_autoria FROM dbo.autoria a JOIN dbo.autor t ON a.id_autor=t.id_autor WHERE a.id_recurso='REC001' ORDER BY a.orden_autoria;
GO

-- ========================================================================
-- C06 | Recursos escritos por todos los autores requeridos
-- REQUERIMIENTO: Encontrar recursos en cuya lista de autoría figuran tanto AUT001 como AUT002.
-- ALGEBRA: S = σ_(id_autor = «AUT001» ∨ id_autor = «AUT002»)(AUTOR) | Y = π_id_autor(S) | X = π_(id_recurso, id_autor)(AUTORIA) | T = X ÷ Y | Resultado = π_(id_recurso, titulo)(T ⋈_(T.id_recurso = RECURSO.id_recurso) RECURSO)
-- ========================================================================
-- S: autores requeridos
SELECT id_autor FROM dbo.autor WHERE id_autor IN ('AUT001','AUT002') ORDER BY id_autor;
GO

-- X: pares de autoría
SELECT id_recurso,id_autor FROM dbo.autoria ORDER BY id_recurso,id_autor;
GO

-- T: división universal
SELECT a.id_recurso FROM dbo.autoria a GROUP BY a.id_recurso HAVING COUNT(DISTINCT CASE WHEN a.id_autor IN ('AUT001','AUT002') THEN a.id_autor END) = 2 ORDER BY a.id_recurso;
GO

-- Resultado: recursos y títulos
SELECT r.id_recurso,r.titulo FROM dbo.recurso r WHERE NOT EXISTS (SELECT 1 FROM dbo.autor y WHERE y.id_autor IN ('AUT001','AUT002') AND NOT EXISTS (SELECT 1 FROM dbo.autoria a WHERE a.id_recurso=r.id_recurso AND a.id_autor=y.id_autor)) ORDER BY r.id_recurso;
GO

-- ========================================================================
-- C07 | Préstamos, usuarios y títulos
-- REQUERIMIENTO: Mostrar folio, nombre del usuario y título del material prestado.
-- ALGEBRA: T1 = PRESTAMO ⋈_(PRESTAMO.id_usuario = USUARIO.id_usuario) USUARIO | T2 = T1 ⋈_(T1.id_recurso = RECURSO.id_recurso) RECURSO | T3 = π_(folio, nombre_pila, titulo)(T2)
-- ========================================================================
-- T1: préstamos con usuario
SELECT p.folio,u.nombre_pila FROM dbo.prestamo p JOIN dbo.usuario u ON p.id_usuario=u.id_usuario ORDER BY p.folio;
GO

-- T2: agregar recurso
SELECT p.folio,u.nombre_pila,r.titulo FROM dbo.prestamo p JOIN dbo.usuario u ON p.id_usuario=u.id_usuario JOIN dbo.recurso r ON r.id_recurso=p.id_recurso ORDER BY p.folio;
GO

-- T3: información final
SELECT p.folio,u.nombre_pila,r.titulo FROM dbo.prestamo p JOIN dbo.usuario u ON p.id_usuario=u.id_usuario JOIN dbo.recurso r ON r.id_recurso=p.id_recurso ORDER BY p.folio;
GO

-- ========================================================================
-- C08 | Todos los usuarios con préstamos opcionales
-- REQUERIMIENTO: Mostrar todos los usuarios y sus folios, incluso los que nunca han solicitado un préstamo.
-- ALGEBRA: T1 = USUARIO ⟕_(USUARIO.id_usuario = PRESTAMO.id_usuario) PRESTAMO | T2 = π_(id_usuario, nombre_pila, folio)(T1)
-- ========================================================================
-- T1: reunión externa izquierda
SELECT u.id_usuario,u.nombre_pila,p.folio,p.fecha_prestamo FROM dbo.usuario u LEFT JOIN dbo.prestamo p ON p.id_usuario=u.id_usuario ORDER BY u.id_usuario,p.folio;
GO

-- T2: campos finales
SELECT u.id_usuario,u.nombre_pila,p.folio FROM dbo.usuario u LEFT JOIN dbo.prestamo p ON p.id_usuario=u.id_usuario ORDER BY u.id_usuario,p.folio;
GO

-- ========================================================================
-- C09 | Montos de multa por usuario
-- REQUERIMIENTO: Calcular para cada usuario el total de multas registradas, incluyendo usuarios sin multas.
-- ALGEBRA: T1 = USUARIO ⟕_(USUARIO.id_usuario = PRESTAMO.id_usuario) PRESTAMO | T2 = T1 ⟕_(T1.folio = MULTA.folio) MULTA | T3 = γ_(id_usuario, nombre_pila; SUM(monto)→total_multas)(T2) | T4 = π_(id_usuario, nombre_pila, COALESCE(total_multas,0)→total)(T3)
-- ========================================================================
-- T1: usuarios y folios
SELECT u.id_usuario,u.nombre_pila,p.folio FROM dbo.usuario u LEFT JOIN dbo.prestamo p ON p.id_usuario=u.id_usuario ORDER BY u.id_usuario;
GO

-- T2: multas asociadas
SELECT u.id_usuario,u.nombre_pila,p.folio,m.monto FROM dbo.usuario u LEFT JOIN dbo.prestamo p ON p.id_usuario=u.id_usuario LEFT JOIN dbo.multa m ON m.folio=p.folio ORDER BY u.id_usuario;
GO

-- T3: sumas agrupadas
SELECT u.id_usuario,u.nombre_pila,SUM(m.monto) AS total_multas FROM dbo.usuario u LEFT JOIN dbo.prestamo p ON p.id_usuario=u.id_usuario LEFT JOIN dbo.multa m ON m.folio=p.folio GROUP BY u.id_usuario,u.nombre_pila ORDER BY u.id_usuario;
GO

-- T4: nulos convertidos en cero
SELECT u.id_usuario,u.nombre_pila,COALESCE(SUM(m.monto),0) AS total FROM dbo.usuario u LEFT JOIN dbo.prestamo p ON p.id_usuario=u.id_usuario LEFT JOIN dbo.multa m ON m.folio=p.folio GROUP BY u.id_usuario,u.nombre_pila ORDER BY u.id_usuario;
GO

-- ========================================================================
-- C10 | Ejemplares disponibles y sus categorías
-- REQUERIMIENTO: Listar ejemplares con estado DISPONIBLE, título y categoría.
-- ALGEBRA: T1 = σ_(estado = «DISPONIBLE»)(EJEMPLAR) | T2 = T1 ⋈_(T1.id_recurso = RECURSO.id_recurso) RECURSO | T3 = T2 ⋈_(T2.id_categoria = CATEGORIA.id_categoria) CATEGORIA | T4 = π_(id_recurso, num_ejemplar, titulo, nombre_categoria)(T3)
-- ========================================================================
-- T1: copias disponibles
SELECT id_recurso,num_ejemplar,estado FROM dbo.ejemplar WHERE estado='DISPONIBLE' ORDER BY id_recurso,num_ejemplar;
GO

-- T2: nombres de recursos
SELECT e.id_recurso,e.num_ejemplar,r.titulo FROM dbo.ejemplar e JOIN dbo.recurso r ON e.id_recurso=r.id_recurso WHERE e.estado='DISPONIBLE' ORDER BY e.id_recurso,e.num_ejemplar;
GO

-- T3 y T4: añadir categoría y proyectar
SELECT e.id_recurso,e.num_ejemplar,r.titulo,c.nombre AS categoria FROM dbo.ejemplar e JOIN dbo.recurso r ON e.id_recurso=r.id_recurso JOIN dbo.categoria c ON c.id_categoria=r.id_categoria WHERE e.estado='DISPONIBLE' ORDER BY e.id_recurso,e.num_ejemplar;
GO

-- ========================================================================
-- C11 | Usuarios de tipo estudiante o docente
-- REQUERIMIENTO: Obtener identificadores de usuarios en cualquiera de los dos subtipos ESTUDIANTE o DOCENTE.
-- ALGEBRA: T1 = π_id_usuario(ESTUDIANTE) | T2 = π_id_usuario(DOCENTE) | T3 = T1 ∪ T2
-- ========================================================================
-- T1: estudiantes
SELECT id_usuario FROM dbo.estudiante ORDER BY id_usuario;
GO

-- T2: docentes
SELECT id_usuario FROM dbo.docente ORDER BY id_usuario;
GO

-- T3: unión sin duplicados
SELECT id_usuario FROM dbo.estudiante UNION SELECT id_usuario FROM dbo.docente ORDER BY id_usuario;
GO

-- ========================================================================
-- C12 | Préstamos devueltos fuera de plazo
-- REQUERIMIENTO: Identificar préstamos cuya devolución registrada ocurrió después de la fecha límite.
-- ALGEBRA: T1 = σ_(fecha_devolucion definida ∧ fecha_devolucion > fecha_limite)(PRESTAMO) | T2 = π_(folio, fecha_limite, fecha_devolucion)(T1)
-- ========================================================================
-- T1: préstamos devueltos tarde
SELECT folio,fecha_limite,fecha_devolucion FROM dbo.prestamo WHERE fecha_devolucion IS NOT NULL AND fecha_devolucion > fecha_limite ORDER BY folio;
GO

-- T2: atributos del resultado
SELECT folio,fecha_limite,fecha_devolucion FROM dbo.prestamo WHERE fecha_devolucion IS NOT NULL AND fecha_devolucion > fecha_limite ORDER BY folio;
GO

-- ========================================================================
-- C13 | Recursos nunca prestados
-- REQUERIMIENTO: Identificar recursos cuyo identificador no está en ningún préstamo histórico.
-- ALGEBRA: T1 = π_id_recurso(RECURSO) | T2 = π_id_recurso(PRESTAMO) | T3 = T1 − T2 | T4 = π_(id_recurso, titulo)(T3 ⋈_(T3.id_recurso = RECURSO.id_recurso) RECURSO)
-- ========================================================================
-- T1: todos los recursos
SELECT id_recurso FROM dbo.recurso ORDER BY id_recurso;
GO

-- T2: recursos prestados
SELECT DISTINCT id_recurso FROM dbo.prestamo ORDER BY id_recurso;
GO

-- T3: diferencia
SELECT id_recurso FROM dbo.recurso EXCEPT SELECT id_recurso FROM dbo.prestamo;
GO

-- T4: recursos con título
SELECT r.id_recurso,r.titulo FROM dbo.recurso r WHERE NOT EXISTS (SELECT 1 FROM dbo.prestamo p WHERE p.id_recurso=r.id_recurso) ORDER BY r.id_recurso;
GO

-- ========================================================================
-- C14 | Recursos prestados que cuentan con ejemplares disponibles
-- REQUERIMIENTO: Encontrar recursos que tienen por lo menos un préstamo histórico y al menos un ejemplar actualmente marcado DISPONIBLE.
-- ALGEBRA: T1 = π_id_recurso(PRESTAMO) | T2 = π_id_recurso(σ_(estado = «DISPONIBLE»)(EJEMPLAR)) | T3 = T1 ∩ T2
-- ========================================================================
-- T1: recursos prestados
SELECT DISTINCT id_recurso FROM dbo.prestamo ORDER BY id_recurso;
GO

-- T2: recursos con copias disponibles
SELECT DISTINCT id_recurso FROM dbo.ejemplar WHERE estado='DISPONIBLE' ORDER BY id_recurso;
GO

-- T3: intersección
SELECT id_recurso FROM dbo.prestamo INTERSECT SELECT id_recurso FROM dbo.ejemplar WHERE estado='DISPONIBLE' ORDER BY id_recurso;
GO

-- ========================================================================
-- C15 | Combinaciones hipotéticas de categoría y bibliotecario
-- REQUERIMIENTO: Generar todas las parejas posibles de categoría y bibliotecario para ilustrar el producto cartesiano; no representan asignaciones reales.
-- ALGEBRA: T1 = CATEGORIA × BIBLIOTECARIO | T2 = π_(CATEGORIA.nombre→nombre_categoria, BIBLIOTECARIO.nombre→nombre_bibliotecario)(T1)
-- ========================================================================
-- T1: combinación de identificadores
SELECT c.id_categoria,b.id_empleado FROM dbo.categoria c CROSS JOIN dbo.bibliotecario b ORDER BY c.id_categoria,b.id_empleado;
GO

-- T2: descripción de pares
SELECT c.nombre AS categoria,b.nombre AS bibliotecario FROM dbo.categoria c CROSS JOIN dbo.bibliotecario b ORDER BY c.id_categoria,b.id_empleado;
GO
