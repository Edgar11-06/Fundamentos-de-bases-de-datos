-- Tarea 3.1: Esquema relacional del sistema de gestión de biblioteca
-- Motor propuesto: PostgreSQL
-- Tipos/longitudes y dominios deben validarse con el responsable de la biblioteca.

CREATE TABLE categoria (
    id_categoria       VARCHAR(20) PRIMARY KEY,
    nombre             VARCHAR(120) NOT NULL,
    descripcion        TEXT
);

CREATE TABLE usuario (
    id_usuario         VARCHAR(20) PRIMARY KEY,
    nombre_pila        VARCHAR(80) NOT NULL,
    apellido_paterno   VARCHAR(80) NOT NULL,
    apellido_materno   VARCHAR(80),
    correo             VARCHAR(160),
    fecha_registro     DATE NOT NULL,
    estatus            VARCHAR(20) NOT NULL
);

-- Especialización total y disjunta: cada usuario debe pertenecer a exactamente un subtipo.
CREATE TABLE estudiante (
    id_usuario         VARCHAR(20) PRIMARY KEY REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    matricula          VARCHAR(30) NOT NULL UNIQUE,
    carrera            VARCHAR(120) NOT NULL,
    semestre           SMALLINT NOT NULL CHECK (semestre > 0)
);

CREATE TABLE docente (
    id_usuario         VARCHAR(20) PRIMARY KEY REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    num_empleado       VARCHAR(30) NOT NULL UNIQUE,
    departamento       VARCHAR(120) NOT NULL
);

CREATE TABLE externo (
    id_usuario         VARCHAR(20) PRIMARY KEY REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    institucion_origen VARCHAR(160) NOT NULL,
    identificacion     VARCHAR(50) NOT NULL
);

-- Atributo multivalorado telefono de USUARIO.
CREATE TABLE telefono_usuario (
    id_usuario         VARCHAR(20) NOT NULL REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    telefono           VARCHAR(25) NOT NULL,
    PRIMARY KEY (id_usuario, telefono)
);

CREATE TABLE recurso (
    id_recurso         VARCHAR(20) PRIMARY KEY,
    titulo             VARCHAR(200) NOT NULL,
    anio_publicacion   SMALLINT CHECK (anio_publicacion > 0),
    editorial          VARCHAR(120),
    idioma             VARCHAR(60),
    id_categoria       VARCHAR(20) NOT NULL REFERENCES categoria(id_categoria)
);

-- Especialización total y disjunta de RECURSO.
CREATE TABLE libro (
    id_recurso         VARCHAR(20) PRIMARY KEY REFERENCES recurso(id_recurso) ON DELETE CASCADE,
    isbn               VARCHAR(20) NOT NULL UNIQUE,
    edicion            VARCHAR(40)
);

CREATE TABLE revista (
    id_recurso         VARCHAR(20) PRIMARY KEY REFERENCES recurso(id_recurso) ON DELETE CASCADE,
    issn               VARCHAR(20) NOT NULL,
    volumen            VARCHAR(30),
    numero             VARCHAR(30)
);

CREATE TABLE tesis (
    id_recurso         VARCHAR(20) PRIMARY KEY REFERENCES recurso(id_recurso) ON DELETE CASCADE,
    asesor             VARCHAR(160) NOT NULL,
    grado_academico    VARCHAR(100) NOT NULL
);

-- Atributo multivalorado palabras_clave de RECURSO.
CREATE TABLE palabra_clave_recurso (
    id_recurso         VARCHAR(20) NOT NULL REFERENCES recurso(id_recurso) ON DELETE CASCADE,
    palabra_clave      VARCHAR(80) NOT NULL,
    PRIMARY KEY (id_recurso, palabra_clave)
);

CREATE TABLE autor (
    id_autor           VARCHAR(20) PRIMARY KEY,
    nombre             VARCHAR(160) NOT NULL,
    nacionalidad       VARCHAR(80)
);

-- Resolución de la relación M:N ESCRIBE; orden_autoria es atributo de la relación.
CREATE TABLE autoria (
    id_recurso         VARCHAR(20) NOT NULL REFERENCES recurso(id_recurso) ON DELETE CASCADE,
    id_autor           VARCHAR(20) NOT NULL REFERENCES autor(id_autor),
    orden_autoria      SMALLINT NOT NULL CHECK (orden_autoria > 0),
    PRIMARY KEY (id_recurso, id_autor),
    UNIQUE (id_recurso, orden_autoria)
);

-- Entidad débil EJEMPLAR: clave parcial num_ejemplar + clave propietaria id_recurso.
CREATE TABLE ejemplar (
    id_recurso         VARCHAR(20) NOT NULL REFERENCES recurso(id_recurso) ON DELETE CASCADE,
    num_ejemplar       INTEGER NOT NULL CHECK (num_ejemplar > 0),
    estado             VARCHAR(25) NOT NULL,
    ubicacion          VARCHAR(100) NOT NULL,
    fecha_adquisicion  DATE NOT NULL,
    PRIMARY KEY (id_recurso, num_ejemplar)
);

CREATE TABLE bibliotecario (
    id_empleado        VARCHAR(20) PRIMARY KEY,
    nombre             VARCHAR(160) NOT NULL,
    turno              VARCHAR(40) NOT NULL
);

-- PRESTAMO materializa la relación M:N SOLICITA con identificador propio (folio).
CREATE TABLE prestamo (
    folio              VARCHAR(30) PRIMARY KEY,
    id_usuario         VARCHAR(20) NOT NULL REFERENCES usuario(id_usuario),
    id_recurso         VARCHAR(20) NOT NULL,
    num_ejemplar       INTEGER NOT NULL,
    id_empleado        VARCHAR(20) NOT NULL REFERENCES bibliotecario(id_empleado),
    fecha_prestamo     DATE NOT NULL,
    fecha_limite       DATE NOT NULL,
    fecha_devolucion   DATE,
    CONSTRAINT fk_prestamo_ejemplar
        FOREIGN KEY (id_recurso, num_ejemplar)
        REFERENCES ejemplar(id_recurso, num_ejemplar),
    CHECK (fecha_limite >= fecha_prestamo),
    CHECK (fecha_devolucion IS NULL OR fecha_devolucion >= fecha_prestamo)
);

CREATE TABLE multa (
    id_multa           VARCHAR(20) PRIMARY KEY,
    folio              VARCHAR(30) NOT NULL REFERENCES prestamo(folio) ON DELETE CASCADE,
    tipo               VARCHAR(30) NOT NULL,
    monto              NUMERIC(10,2) NOT NULL CHECK (monto >= 0),
    fecha_generacion   DATE NOT NULL,
    estatus_pago       VARCHAR(25) NOT NULL
);

-- Consultas de atributos derivados (no se almacenan):
-- Días de retraso de un préstamo devuelto:
-- GREATEST(fecha_devolucion - fecha_limite, 0)
-- Adeudo pendiente por usuario:
-- SUM(multa.monto) filtrando multas cuyo estatus_pago represente "pendiente".

-- Validaciones adicionales no expresables con estas FK/CHECK sencillas:
-- 1) La especialización de USUARIO es total y disjunta: exactamente un subtipo por usuario.
-- 2) La especialización de RECURSO es total y disjunta: exactamente un subtipo por recurso.
-- 3) Cada RECURSO debe tener al menos una AUTORIA (participación total).
-- 4) Cada RECURSO debe tener al menos un EJEMPLAR según RN-08.
-- 5) Cada USUARIO debe registrar uno o varios TELEFONOS según RN-03.
-- Se recomienda implementarlas con triggers diferidos o validación transaccional.
