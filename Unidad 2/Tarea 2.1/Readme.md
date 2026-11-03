# Tarea 2.1: Modelado conceptual E-R y E-R Extendido de un caso real

## Datos del alumno

| | |
|---|---|
| **Alumno** | Edgar Alejandro Hernandez Guajardo |
| **Matrícula** | I24050409 |
| **Docente** | Ing. Ruben Riojas |
| **Institución** | Instituto Tecnológico Superior de Monclova |
| **Unidad** | Unidad 2: Diseño de bases de datos con el modelo E-R |
| **Actividad** | Tarea 2.1 |

## Descripción de la tarea

**Competencia específica de la unidad:** conocer y aplicar el modelo E-R para el diseño conceptual de bases de datos, con el fin de organizar la información y atender necesidades del entorno.

**Caso de estudio:** sistema de gestión de la **biblioteca** de una institución educativa de nivel superior. La biblioteca presta a la comunidad un acervo de libros, revistas y tesis; cuando el control se lleva en cuadernos u hojas de cálculo aisladas, se pierde el historial de préstamos, no se sabe qué ejemplares están disponibles, los adeudos no se calculan de forma confiable y no hay certeza de quién autorizó cada movimiento.

**Objetivo:** representar mediante un diagrama E-R extendido las entidades, atributos, relaciones y restricciones necesarias para gestionar usuarios, acervo, ejemplares, préstamos y multas, como base para el diseño lógico y físico posterior.

**Alcance del trabajo:**

1. Redacción del planteamiento del problema y extracción de **16 reglas de negocio** (RN-01 a RN-16).
2. Identificación de **entidades** (14), **atributos** (claves, compuestos, derivados y multivalorados) y **relaciones** con sus **cardinalidades** y **restricciones de participación**.
3. Aplicación del **modelo E-R extendido**: especialización/generalización, jerarquías y agregación.
4. Diseño del diagrama formal con la herramienta CASE **draw.io (diagrams.net)**, usando la notación de Chen.
5. Reporte técnico en PDF con la justificación de las decisiones de diseño.

> Las reglas de negocio se establecieron a partir del funcionamiento general de una biblioteca universitaria.

## Estructura de la carpeta

```
Unidad2/
└── Tarea 2.1/
    ├── Readme.md
    ├── documentacion/
    │   └── Tarea_2.1_Modelado_ER.pdf
    └── diagramas/
        ├── modelo_er_biblioteca_itsm.drawio   (fuente editable)
        ├── modelo_er_biblioteca_itsm.png
        ├── modelo_er_biblioteca_itsm.svg
        └── modelo_er_biblioteca_itsm.pdf
```

## 📄 Documentación y archivos

- 👉 [**Reporte técnico en PDF**](documentacion/Tarea_2.1_Modelado_ER.pdf)
- 🧩 [Archivo fuente del diagrama (`.drawio`)](diagramas/modelo_er_biblioteca_itsm.drawio): ábrelo en [app.diagrams.net](https://app.diagrams.net/)
- 🖼️ Exportaciones: [PNG](diagramas/modelo_er_biblioteca_itsm.png) · [SVG](diagramas/modelo_er_biblioteca_itsm.svg) · [PDF](diagramas/modelo_er_biblioteca_itsm.pdf)

## Diagrama E-R extendido

![Diagrama E-R extendido del sistema de biblioteca](diagramas/modelo_er_biblioteca_itsm.png)

## Reglas de negocio

| Clave | Regla |
|---|---|
| RN-01 | Todo usuario se identifica con un `id_usuario` único y es, obligatoriamente, estudiante, docente o usuario externo (solo uno de los tres). |
| RN-02 | Estudiante: matrícula, carrera y semestre. Docente: número de empleado y departamento. Externo: institución de origen e identificación. |
| RN-03 | El nombre del usuario se compone de nombre de pila, apellido paterno y materno. Un usuario puede registrar uno o varios teléfonos. |
| RN-04 | El adeudo total del usuario no se captura: se calcula sumando sus multas pendientes. |
| RN-05 | Todo recurso (libro, revista o tesis) se identifica con `id_recurso`, pertenece a una categoría y puede tener varias palabras clave. |
| RN-06 | Una categoría agrupa muchos recursos; cada recurso pertenece a una sola categoría. |
| RN-07 | Todo recurso es escrito por uno o más autores y un autor puede escribir varios recursos. Se registra el orden de autoría. |
| RN-08 | De cada recurso existen uno o más ejemplares físicos, identificados por un número de ejemplar dentro de su recurso. Un ejemplar no existe sin su recurso. |
| RN-09 | Cada ejemplar tiene estado (disponible, prestado, en reparación o extraviado), ubicación y fecha de adquisición. |
| RN-10 | Un usuario puede solicitar en préstamo varios ejemplares y un ejemplar puede prestarse a distintos usuarios en distintos momentos. Cada préstamo tiene folio, fecha de préstamo, fecha límite y fecha de devolución. |
| RN-11 | Si el ejemplar se devuelve después de la fecha límite, los días de retraso se calculan como fecha de devolución menos fecha límite. |
| RN-12 | Todo préstamo debe ser autorizado por exactamente un bibliotecario; un bibliotecario puede autorizar muchos préstamos. |
| RN-13 | Un préstamo puede generar cero o más multas (retraso, daño o extravío); toda multa corresponde a un único préstamo. |
| RN-14 | Cada multa registra tipo, monto, fecha de generación y estatus de pago. |
| RN-15 | Libros: ISBN y edición. Revistas: ISSN, volumen y número. Tesis: asesor y grado académico. |
| RN-16 | Cada bibliotecario se identifica con `id_empleado` y registra nombre y turno. |

## Entidades y atributos

| Entidad | Tipo | Atributos |
|---|---|---|
| **USUARIO** | Fuerte; supertipo | `id_usuario` (clave), `nombre` (compuesto: nombre_pila, apellido_paterno, apellido_materno), `correo`, `telefono` (multivalorado), `fecha_registro`, `estatus`, `adeudo_total` (derivado) |
| **ESTUDIANTE** | Subtipo de USUARIO | `matricula`, `carrera`, `semestre` |
| **DOCENTE** | Subtipo de USUARIO | `num_empleado`, `departamento` |
| **EXTERNO** | Subtipo de USUARIO | `institucion_origen`, `identificacion` |
| **RECURSO** | Fuerte; supertipo | `id_recurso` (clave), `titulo`, `anio_publicacion`, `editorial`, `idioma`, `palabras_clave` (multivalorado) |
| **LIBRO** | Subtipo de RECURSO | `isbn`, `edicion` |
| **REVISTA** | Subtipo de RECURSO | `issn`, `volumen`, `numero` |
| **TESIS** | Subtipo de RECURSO | `asesor`, `grado_academico` |
| **EJEMPLAR** | **Débil** (depende de RECURSO) | `num_ejemplar` (clave parcial), `estado`, `ubicacion`, `fecha_adquisicion` |
| **AUTOR** | Fuerte | `id_autor` (clave), `nombre`, `nacionalidad` |
| **CATEGORIA** | Fuerte | `id_categoria` (clave), `nombre`, `descripcion` |
| **BIBLIOTECARIO** | Fuerte | `id_empleado` (clave), `nombre`, `turno` |
| **MULTA** | Fuerte | `id_multa` (clave), `tipo`, `monto`, `fecha_generacion`, `estatus_pago` |

## Relaciones, cardinalidades y participación

La participación es **total** cuando toda ocurrencia de la entidad debe estar relacionada (línea doble en el diagrama) y **parcial** cuando puede no estarlo (línea simple).

| Relación | Entidades | Cardinalidad | Participación | Atributos de la relación |
|---|---|---|---|---|
| **SOLICITA** (agregada como PRÉSTAMO) | USUARIO – EJEMPLAR | **M : N** | USUARIO: parcial · EJEMPLAR: parcial | `folio` (clave), `fecha_prestamo`, `fecha_limite`, `fecha_devolucion`, `dias_retraso` (derivado) |
| **AUTORIZA** | BIBLIOTECARIO – PRÉSTAMO (agregación) | **1 : N** | BIBLIOTECARIO: parcial · PRÉSTAMO: total | — |
| **GENERA** | PRÉSTAMO (agregación) – MULTA | **1 : N** | PRÉSTAMO: parcial · MULTA: total | — |
| **TIENE** (identificadora) | RECURSO – EJEMPLAR | **1 : N** | RECURSO: parcial · EJEMPLAR: total | — |
| **ESCRIBE** | RECURSO – AUTOR | **M : N** | RECURSO: total · AUTOR: total | `orden_autoria` |
| **PERTENECE** | RECURSO – CATEGORIA | **N : 1** | RECURSO: total · CATEGORIA: parcial | — |
| **ES** (especialización) | USUARIO → ESTUDIANTE, DOCENTE, EXTERNO | Jerarquía | Total, disjunta | — |
| **ES** (especialización) | RECURSO → LIBRO, REVISTA, TESIS | Jerarquía | Total, disjunta | — |

### Lectura de las cardinalidades

- **SOLICITA (M:N):** un usuario puede solicitar muchos ejemplares y un ejemplar puede ser prestado a muchos usuarios a lo largo del tiempo.
- **AUTORIZA (1:N):** un bibliotecario autoriza muchos préstamos; cada préstamo es autorizado por exactamente un bibliotecario.
- **GENERA (1:N):** un préstamo puede generar cero o más multas; cada multa proviene de un solo préstamo.
- **TIENE (1:N):** un recurso tiene uno o más ejemplares; cada ejemplar pertenece a un solo recurso.
- **ESCRIBE (M:N):** un recurso tiene uno o más autores; un autor puede escribir varios recursos.
- **PERTENECE (N:1):** muchos recursos pertenecen a una categoría; cada recurso tiene una sola categoría.

## Conceptos del modelo E-R extendido aplicados

| Concepto | Aplicación en el modelo |
|---|---|
| **Especialización / generalización** | USUARIO → ESTUDIANTE, DOCENTE y EXTERNO; RECURSO → LIBRO, REVISTA y TESIS (ambas totales y disjuntas). |
| **Jerarquía** | Dos jerarquías de un nivel; cada subtipo hereda la clave y los atributos del supertipo. |
| **Agregación** | La relación SOLICITA se trata como la entidad abstracta PRÉSTAMO, que participa en AUTORIZA con BIBLIOTECARIO y en GENERA con MULTA. |
| **Entidad débil** | EJEMPLAR se identifica por `num_ejemplar` junto con la clave de su RECURSO, mediante la relación identificadora TIENE. |

## Simbología del diagrama

| Símbolo | Significado |
|---|---|
| Rectángulo / rectángulo doble | Entidad / entidad débil |
| Rombo / rombo doble | Relación / relación identificadora |
| Elipse con nombre subrayado | Atributo clave |
| Elipse con subrayado punteado | Clave parcial |
| Elipse doble | Atributo multivalorado |
| Elipse punteada | Atributo derivado |
| Elipse con atributos conectados | Atributo compuesto |
| Línea doble / línea simple | Participación total / parcial |
| Triángulo con “d” | Especialización disjunta |
| Rectángulo punteado | Agregación |
| 1, M, N (en rojo) | Cardinalidad |

## Referencias (APA 7)

- Chen, P. P.-S. (1976). The entity-relationship model—Toward a unified view of data. *ACM Transactions on Database Systems, 1*(1), 9–36. https://doi.org/10.1145/320434.320440
- Connolly, T., & Begg, C. (2015). *Database systems: A practical approach to design, implementation, and management* (6.ª ed.). Pearson.
- Coronel, C., & Morris, S. (2019). *Database systems: Design, implementation, & management* (13.ª ed.). Cengage Learning.
- Elmasri, R., & Navathe, S. B. (2016). *Fundamentals of database systems* (7.ª ed.). Pearson.
- JGraph Ltd. (s. f.). *draw.io (diagrams.net)* [Software]. https://www.drawio.com/
- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2019). *Database system concepts* (7.ª ed.). McGraw-Hill Education.
- Teorey, T., Lightstone, S., Nadeau, T., & Jagadish, H. V. (2011). *Database modeling and design: Logical design* (5.ª ed.). Morgan Kaufmann.

## 🎥 Video explicativo

▶️ Explicación de los temas en YouTube: [VIDEO YOUTUBE](https://youtu.be/v0oePEeWKZY)
