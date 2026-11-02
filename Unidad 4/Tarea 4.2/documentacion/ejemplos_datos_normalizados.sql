-- DATOS FICTICIOS | Ejecutar DESPUÉS de normalized_schema.sql.
-- Utiliza la estructura sin cambiar los nombres de tablas de la Tarea 3.2.
/*
    DATOS DE PRUEBA - TAREA 3.2
    Registros ficticios para comprobar relaciones, llaves y consultas.
    Ejecutar en una base de datos nueva, despues de CREATE TABLE.
    Orden de insercion: tablas padre -> tablas dependientes.
    No ejecutar este bloque dos veces sin limpiar los datos.
*/
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO dbo.categoria (id_categoria, nombre, descripcion) VALUES
    ('CAT001', 'Computacion', 'Recursos de informatica y desarrollo de software'),
    ('CAT002', 'Ciencias', 'Material de ciencias aplicadas'),
    ('CAT003', 'Investigacion', 'Trabajos y publicaciones academicas');

    INSERT INTO dbo.usuario
        (id_usuario, nombre_pila, apellido_paterno, apellido_materno, correo, fecha_registro, estatus)
    VALUES
    ('USR001', 'Ana', 'Lopez', 'Garcia', 'ana.lopez@ejemplo.edu', '2026-08-15', 'ACTIVO'),
    ('USR002', 'Carlos', 'Ramirez', 'Soto', 'carlos.ramirez@ejemplo.edu', '2026-08-16', 'ACTIVO'),
    ('USR003', 'Laura', 'Torres', 'Diaz', 'laura.torres@ejemplo.org', '2026-08-17', 'ACTIVO'),
    ('USR004', 'Miguel', 'Flores', 'Ruiz', 'miguel.flores@ejemplo.edu', '2026-08-18', 'ACTIVO');

    INSERT INTO dbo.estudiante (id_usuario, matricula, carrera, semestre) VALUES
    ('USR001', 'EST2026001', 'Ingenieria en Sistemas Computacionales', 3),
    ('USR004', 'EST2026002', 'Ingenieria Industrial', 5);

    INSERT INTO dbo.docente (id_usuario, num_empleado, departamento) VALUES
    ('USR002', 'DOC2026001', 'Sistemas y Computacion');

    INSERT INTO dbo.externo (id_usuario, institucion_origen, identificacion) VALUES
    ('USR003', 'Institucion visitante', 'EXT2026001');

    INSERT INTO dbo.telefono_usuario (id_usuario, telefono) VALUES
    ('USR001', '8661000001'),
    ('USR002', '8661000002'),
    ('USR003', '8661000003'),
    ('USR004', '8661000004');

    INSERT INTO dbo.recurso
        (id_recurso, titulo, anio_publicacion, editorial, idioma, id_categoria)
    VALUES
    ('REC001', 'Fundamentos de Bases de Datos', 2022, 'Editorial Academica', 'Espanol', 'CAT001'),
    ('REC002', 'Revista de Tecnologia Aplicada', 2024, 'Ediciones Ciencia', 'Espanol', 'CAT002'),
    ('REC003', 'Modelo de Gestion Bibliotecaria', 2025, 'Instituto Academico', 'Espanol', 'CAT003'),
    ('REC004', 'Programacion y Algoritmos', 2021, 'Editorial Universitaria', 'Espanol', 'CAT001');

    INSERT INTO dbo.libro (id_recurso, isbn, edicion) VALUES
    ('REC001', '9786070000001', 'Segunda'),
    ('REC004', '9786070000002', 'Primera');

    INSERT INTO dbo.revista (id_recurso, issn, volumen, numero) VALUES
    ('REC002', '1234-5678', '12', '3');

    INSERT INTO dbo.tesis (id_recurso, asesor, grado_academico) VALUES
    ('REC003', 'Dra. Patricia Gomez', 'Licenciatura');

    INSERT INTO dbo.palabra_clave_recurso (id_recurso, palabra_clave) VALUES
    ('REC001', 'Bases de datos'),
    ('REC001', 'SQL'),
    ('REC002', 'Tecnologia'),
    ('REC003', 'Bibliotecas'),
    ('REC004', 'Algoritmos');

    INSERT INTO dbo.autor (id_autor, nombre, nacionalidad) VALUES
    ('AUT001', 'Roberto Mendoza', 'Mexicana'),
    ('AUT002', 'Sofia Herrera', 'Mexicana'),
    ('AUT003', 'Daniel Ortega', 'Mexicana'),
    ('AUT004', 'Elena Navarro', 'Mexicana');

    INSERT INTO dbo.autoria (id_recurso, id_autor, orden_autoria) VALUES
    ('REC001', 'AUT001', 1),
    ('REC001', 'AUT002', 2),
    ('REC002', 'AUT003', 1),
    ('REC003', 'AUT002', 1),
    ('REC004', 'AUT004', 1);

    INSERT INTO dbo.ejemplar
        (id_recurso, num_ejemplar, estado, ubicacion, fecha_adquisicion)
    VALUES
    ('REC001', 1, 'DISPONIBLE', 'Estante A1', '2026-01-15'),
    ('REC001', 2, 'PRESTADO', 'Estante A1', '2026-01-15'),
    ('REC002', 1, 'DISPONIBLE', 'Hemeroteca B1', '2026-02-01'),
    ('REC003', 1, 'DISPONIBLE', 'Tesis C1', '2026-02-10'),
    ('REC004', 1, 'PRESTADO', 'Estante A2', '2026-03-05');

    INSERT INTO dbo.bibliotecario (id_empleado, nombre, turno) VALUES
    ('EMP001', 'Mariana Salazar', 'Matutino'),
    ('EMP002', 'Jorge Castillo', 'Vespertino');

    INSERT INTO dbo.prestamo
        (folio, id_usuario, id_recurso, num_ejemplar, id_empleado,
         fecha_prestamo, fecha_limite, fecha_devolucion)
    VALUES
    ('PRE001', 'USR001', 'REC001', 2, 'EMP001', '2026-09-01', '2026-09-15', NULL),
    ('PRE002', 'USR002', 'REC004', 1, 'EMP002', '2026-09-03', '2026-09-17', '2026-09-20'),
    ('PRE003', 'USR004', 'REC002', 1, 'EMP001', '2026-09-10', '2026-09-24', '2026-09-22');

    INSERT INTO dbo.multa
        (id_multa, folio, tipo, monto, fecha_generacion, estatus_pago)
    VALUES
    ('MUL001', 'PRE002', 'RETRASO', 45.00, '2026-09-20', 'PENDIENTE');

    COMMIT TRANSACTION;
    PRINT 'Datos de prueba insertados correctamente en las 17 tablas.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

-- Consultas de prueba para evidenciar que los registros fueron insertados.
SELECT 'categoria' AS tabla, COUNT(*) AS registros FROM dbo.categoria
UNION ALL SELECT 'usuario', COUNT(*) FROM dbo.usuario
UNION ALL SELECT 'estudiante', COUNT(*) FROM dbo.estudiante
UNION ALL SELECT 'docente', COUNT(*) FROM dbo.docente
UNION ALL SELECT 'externo', COUNT(*) FROM dbo.externo
UNION ALL SELECT 'telefono_usuario', COUNT(*) FROM dbo.telefono_usuario
UNION ALL SELECT 'recurso', COUNT(*) FROM dbo.recurso
UNION ALL SELECT 'libro', COUNT(*) FROM dbo.libro
UNION ALL SELECT 'revista', COUNT(*) FROM dbo.revista
UNION ALL SELECT 'tesis', COUNT(*) FROM dbo.tesis
UNION ALL SELECT 'palabra_clave_recurso', COUNT(*) FROM dbo.palabra_clave_recurso
UNION ALL SELECT 'autor', COUNT(*) FROM dbo.autor
UNION ALL SELECT 'autoria', COUNT(*) FROM dbo.autoria
UNION ALL SELECT 'ejemplar', COUNT(*) FROM dbo.ejemplar
UNION ALL SELECT 'bibliotecario', COUNT(*) FROM dbo.bibliotecario
UNION ALL SELECT 'prestamo', COUNT(*) FROM dbo.prestamo
UNION ALL SELECT 'multa', COUNT(*) FROM dbo.multa;
GO

SELECT p.folio, u.nombre_pila AS usuario, r.titulo AS recurso,
       p.fecha_prestamo, p.fecha_limite, p.fecha_devolucion
FROM dbo.prestamo AS p
INNER JOIN dbo.usuario AS u ON p.id_usuario = u.id_usuario
INNER JOIN dbo.recurso AS r ON p.id_recurso = r.id_recurso
ORDER BY p.folio;
GO

