/*
    Tarea 3.1 - Esquema relacional del sistema de gestion de biblioteca
    Motor: Microsoft SQL Server 2019 o superior
    Conversion del archivo original PostgreSQL a T-SQL.

    Criterios de conversion:
    - Se conservan las 17 tablas, columnas, tipos compatibles, PK, FK,
      UNIQUE, CHECK y reglas ON DELETE CASCADE que aparecen en el original.
    - TEXT se convierte a VARCHAR(MAX), tipo recomendado en SQL Server.
    - SMALLINT, INTEGER, DATE, NUMERIC y VARCHAR se conservan.
    - Las FK sin clausula ON UPDATE/ON DELETE explicita en el original
      mantienen el comportamiento predeterminado de SQL Server: NO ACTION.
    - SQL Server no admite restricciones FK diferibles. Las reglas de
      especializacion total/disjunta y participacion total quedan documentadas
      para validacion mediante triggers o logica transaccional.
*/

-- Si ya existe una base de datos, cambia el nombre de la base en USE.
-- CREATE DATABASE Biblioteca;
-- GO
-- USE Biblioteca;
-- GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE TABLE dbo.categoria (
    id_categoria       VARCHAR(20)  NOT NULL,
    nombre             VARCHAR(120) NOT NULL,
    descripcion        VARCHAR(MAX) NULL,
    CONSTRAINT PK_categoria PRIMARY KEY (id_categoria)
);
GO

CREATE TABLE dbo.usuario (
    id_usuario         VARCHAR(20)  NOT NULL,
    nombre_pila        VARCHAR(80)  NOT NULL,
    apellido_paterno   VARCHAR(80)  NOT NULL,
    apellido_materno   VARCHAR(80)  NULL,
    correo             VARCHAR(160) NULL,
    fecha_registro     DATE         NOT NULL,
    estatus            VARCHAR(20)  NOT NULL,
    CONSTRAINT PK_usuario PRIMARY KEY (id_usuario)
);
GO

-- Especializacion total y disjunta: cada usuario debe pertenecer
-- exactamente a un subtipo. La regla requiere validacion adicional.
CREATE TABLE dbo.estudiante (
    id_usuario         VARCHAR(20) NOT NULL,
    matricula          VARCHAR(30) NOT NULL,
    carrera            VARCHAR(120) NOT NULL,
    semestre           SMALLINT    NOT NULL,
    CONSTRAINT PK_estudiante PRIMARY KEY (id_usuario),
    CONSTRAINT UQ_estudiante_matricula UNIQUE (matricula),
    CONSTRAINT CK_estudiante_semestre CHECK (semestre > 0),
    CONSTRAINT FK_estudiante_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuario(id_usuario) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.docente (
    id_usuario         VARCHAR(20)  NOT NULL,
    num_empleado       VARCHAR(30)  NOT NULL,
    departamento       VARCHAR(120) NOT NULL,
    CONSTRAINT PK_docente PRIMARY KEY (id_usuario),
    CONSTRAINT UQ_docente_num_empleado UNIQUE (num_empleado),
    CONSTRAINT FK_docente_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuario(id_usuario) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.externo (
    id_usuario         VARCHAR(20)  NOT NULL,
    institucion_origen VARCHAR(160) NOT NULL,
    identificacion     VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_externo PRIMARY KEY (id_usuario),
    CONSTRAINT FK_externo_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuario(id_usuario) ON DELETE CASCADE
);
GO

-- Atributo multivalorado telefono de USUARIO.
CREATE TABLE dbo.telefono_usuario (
    id_usuario         VARCHAR(20) NOT NULL,
    telefono           VARCHAR(25) NOT NULL,
    CONSTRAINT PK_telefono_usuario PRIMARY KEY (id_usuario, telefono),
    CONSTRAINT FK_telefono_usuario_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuario(id_usuario) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.recurso (
    id_recurso         VARCHAR(20)  NOT NULL,
    titulo             VARCHAR(200) NOT NULL,
    anio_publicacion   SMALLINT     NULL,
    editorial          VARCHAR(120) NULL,
    idioma             VARCHAR(60)  NULL,
    id_categoria       VARCHAR(20)  NOT NULL,
    CONSTRAINT PK_recurso PRIMARY KEY (id_recurso),
    CONSTRAINT CK_recurso_anio CHECK (anio_publicacion > 0),
    CONSTRAINT FK_recurso_categoria FOREIGN KEY (id_categoria)
        REFERENCES dbo.categoria(id_categoria)
);
GO

-- Especializacion total y disjunta de RECURSO.
CREATE TABLE dbo.libro (
    id_recurso         VARCHAR(20) NOT NULL,
    isbn               VARCHAR(20) NOT NULL,
    edicion            VARCHAR(40) NULL,
    CONSTRAINT PK_libro PRIMARY KEY (id_recurso),
    CONSTRAINT UQ_libro_isbn UNIQUE (isbn),
    CONSTRAINT FK_libro_recurso FOREIGN KEY (id_recurso)
        REFERENCES dbo.recurso(id_recurso) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.revista (
    id_recurso         VARCHAR(20) NOT NULL,
    issn               VARCHAR(20) NOT NULL,
    volumen            VARCHAR(30) NULL,
    numero             VARCHAR(30) NULL,
    CONSTRAINT PK_revista PRIMARY KEY (id_recurso),
    CONSTRAINT FK_revista_recurso FOREIGN KEY (id_recurso)
        REFERENCES dbo.recurso(id_recurso) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.tesis (
    id_recurso         VARCHAR(20)  NOT NULL,
    asesor             VARCHAR(160) NOT NULL,
    grado_academico    VARCHAR(100) NOT NULL,
    CONSTRAINT PK_tesis PRIMARY KEY (id_recurso),
    CONSTRAINT FK_tesis_recurso FOREIGN KEY (id_recurso)
        REFERENCES dbo.recurso(id_recurso) ON DELETE CASCADE
);
GO

-- Atributo multivalorado palabras_clave de RECURSO.
CREATE TABLE dbo.palabra_clave_recurso (
    id_recurso         VARCHAR(20) NOT NULL,
    palabra_clave      VARCHAR(80) NOT NULL,
    CONSTRAINT PK_palabra_clave_recurso PRIMARY KEY (id_recurso, palabra_clave),
    CONSTRAINT FK_palabra_clave_recurso_recurso FOREIGN KEY (id_recurso)
        REFERENCES dbo.recurso(id_recurso) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.autor (
    id_autor           VARCHAR(20)  NOT NULL,
    nombre             VARCHAR(160) NOT NULL,
    nacionalidad       VARCHAR(80)  NULL,
    CONSTRAINT PK_autor PRIMARY KEY (id_autor)
);
GO

-- Resolucion de la relacion M:N ESCRIBE; orden_autoria es atributo de la relacion.
CREATE TABLE dbo.autoria (
    id_recurso         VARCHAR(20) NOT NULL,
    id_autor           VARCHAR(20) NOT NULL,
    orden_autoria      SMALLINT    NOT NULL,
    CONSTRAINT PK_autoria PRIMARY KEY (id_recurso, id_autor),
    CONSTRAINT UQ_autoria_recurso_orden UNIQUE (id_recurso, orden_autoria),
    CONSTRAINT CK_autoria_orden CHECK (orden_autoria > 0),
    CONSTRAINT FK_autoria_recurso FOREIGN KEY (id_recurso)
        REFERENCES dbo.recurso(id_recurso) ON DELETE CASCADE,
    CONSTRAINT FK_autoria_autor FOREIGN KEY (id_autor)
        REFERENCES dbo.autor(id_autor)
);
GO

-- Entidad debil EJEMPLAR: clave parcial num_ejemplar + clave propietaria id_recurso.
CREATE TABLE dbo.ejemplar (
    id_recurso         VARCHAR(20)  NOT NULL,
    num_ejemplar       INT          NOT NULL,
    estado             VARCHAR(25)  NOT NULL,
    ubicacion          VARCHAR(100) NOT NULL,
    fecha_adquisicion  DATE         NOT NULL,
    CONSTRAINT PK_ejemplar PRIMARY KEY (id_recurso, num_ejemplar),
    CONSTRAINT CK_ejemplar_numero CHECK (num_ejemplar > 0),
    CONSTRAINT FK_ejemplar_recurso FOREIGN KEY (id_recurso)
        REFERENCES dbo.recurso(id_recurso) ON DELETE CASCADE
);
GO

CREATE TABLE dbo.bibliotecario (
    id_empleado        VARCHAR(20)  NOT NULL,
    nombre             VARCHAR(160) NOT NULL,
    turno              VARCHAR(40)  NOT NULL,
    CONSTRAINT PK_bibliotecario PRIMARY KEY (id_empleado)
);
GO

-- PRESTAMO materializa la relacion M:N SOLICITA con identificador propio (folio).
CREATE TABLE dbo.prestamo (
    folio              VARCHAR(30) NOT NULL,
    id_usuario         VARCHAR(20) NOT NULL,
    id_recurso         VARCHAR(20) NOT NULL,
    num_ejemplar       INT         NOT NULL,
    id_empleado        VARCHAR(20) NOT NULL,
    fecha_prestamo     DATE        NOT NULL,
    fecha_limite       DATE        NOT NULL,
    fecha_devolucion   DATE        NULL,
    CONSTRAINT PK_prestamo PRIMARY KEY (folio),
    CONSTRAINT FK_prestamo_usuario FOREIGN KEY (id_usuario)
        REFERENCES dbo.usuario(id_usuario),
    CONSTRAINT FK_prestamo_empleado FOREIGN KEY (id_empleado)
        REFERENCES dbo.bibliotecario(id_empleado),
    CONSTRAINT FK_prestamo_ejemplar FOREIGN KEY (id_recurso, num_ejemplar)
        REFERENCES dbo.ejemplar(id_recurso, num_ejemplar),
    CONSTRAINT CK_prestamo_fecha_limite CHECK (fecha_limite >= fecha_prestamo),
    CONSTRAINT CK_prestamo_fecha_devolucion
        CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo)
);
GO

CREATE TABLE dbo.multa (
    id_multa           VARCHAR(20)  NOT NULL,
    folio              VARCHAR(30)  NOT NULL,
    tipo               VARCHAR(30)  NOT NULL,
    monto              NUMERIC(10,2) NOT NULL,
    fecha_generacion   DATE         NOT NULL,
    estatus_pago       VARCHAR(25)  NOT NULL,
    CONSTRAINT PK_multa PRIMARY KEY (id_multa),
    CONSTRAINT CK_multa_monto CHECK (monto >= 0),
    CONSTRAINT FK_multa_prestamo FOREIGN KEY (folio)
        REFERENCES dbo.prestamo(folio) ON DELETE CASCADE
);
GO

/*
    Atributos derivados: no se almacenan en tablas.
    Dias de retraso de un prestamo devuelto:
*/
-- SELECT folio,
--        CASE
--          WHEN fecha_devolucion IS NULL OR fecha_devolucion <= fecha_limite THEN 0
--          ELSE DATEDIFF(DAY, fecha_limite, fecha_devolucion)
--        END AS dias_retraso
-- FROM dbo.prestamo;

-- Adeudo pendiente por usuario:
-- SELECT p.id_usuario, SUM(m.monto) AS adeudo_pendiente
-- FROM dbo.prestamo AS p
-- INNER JOIN dbo.multa AS m ON m.folio = p.folio
-- WHERE m.estatus_pago = 'PENDIENTE' -- confirmar valor de dominio con el negocio
-- GROUP BY p.id_usuario;

/*
    VALIDACIONES ADICIONALES DOCUMENTADAS EN EL SQL ORIGINAL
    Estas reglas no quedan garantizadas solamente con PK/FK/CHECK:
    1. USUARIO debe pertenecer exactamente a un subtipo (estudiante/docente/externo).
    2. RECURSO debe pertenecer exactamente a un subtipo (libro/revista/tesis).
    3. Cada RECURSO debe tener al menos una AUTORIA.
    4. Cada RECURSO debe tener al menos un EJEMPLAR.
    5. Cada USUARIO debe registrar uno o varios TELEFONOS.

    SQL Server no soporta constraints diferibles como PostgreSQL.
    Para hacer cumplir estas reglas se requiere diseñar triggers compatibles
    con operaciones multi-fila o validarlas desde procedimientos/transacciones
    de la aplicacion. No se agregan triggers aqui para no cambiar la semantica
    del modelo original sin definir primero el comportamiento esperado.
*/

-- Consultas de verificacion: deben mostrar 17 tablas.
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- Resumen de restricciones declaradas.
SELECT
    OBJECT_SCHEMA_NAME(parent_object_id) AS esquema,
    OBJECT_NAME(parent_object_id) AS tabla,
    name AS restriccion,
    type_desc AS tipo
FROM sys.objects
WHERE type IN ('PK', 'F', 'UQ', 'C')
  AND OBJECT_SCHEMA_NAME(parent_object_id) = 'dbo'
ORDER BY tabla, tipo, restriccion;
GO
