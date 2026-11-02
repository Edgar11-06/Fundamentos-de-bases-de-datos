# Tarea 3.1 – Modelo relacional del sistema de biblioteca

## Proyecto
Transformación del modelo E-R extendido de las tareas 2.1 y 2.2 a un esquema relacional para un sistema de gestión de una biblioteca académica.

## Estructura
- `documentacion/Tarea_3.1_Reporte_Tecnico.pdf`: reporte técnico de la actividad.
- `documentacion/esquema_relacional.sql`: propuesta de implementación en PostgreSQL.
- `diagramas/esquema_relacional.mmd`: código fuente Mermaid editable.
- `diagramas/esquema_relacional.drawio`: diagrama editable en diagrams.net (draw.io).
- `diagramas/esquema_relacional.svg` y `.png`: exportaciones del diagrama.
- `diagramas/esquema_relacional.pdf`: versión PDF del diagrama.

## Cómo visualizar o editar
1. Para Mermaid, abre https://mermaid.live/ y pega el contenido de `esquema_relacional.mmd`.
2. Para draw.io, abre https://app.diagrams.net/ y selecciona **Archivo > Importar desde > Dispositivo**. Elige `esquema_relacional.drawio`.
3. El SQL está escrito para PostgreSQL. Revísalo y ajusta tipos, longitudes y dominios de acuerdo con las reglas definitivas de la biblioteca antes de ejecutarlo en producción.

## Decisiones de transformación
- Se conserva una tabla para cada supertipo y subtipo: `USUARIO` con `ESTUDIANTE`, `DOCENTE` y `EXTERNO`; `RECURSO` con `LIBRO`, `REVISTA` y `TESIS`.
- Los subtipos reutilizan la clave del supertipo como PK y FK.
- `EJEMPLAR` se identifica con `(id_recurso, num_ejemplar)`, porque es una entidad débil.
- `TELEFONO_USUARIO` y `PALABRA_CLAVE_RECURSO` resuelven atributos multivalorados.
- `AUTORIA` resuelve la relación M:N entre `RECURSO` y `AUTOR`.
- `PRESTAMO` representa la relación M:N histórica `SOLICITA`, identificada por `folio` y con sus atributos propios.
- `adeudo_total` y `dias_retraso` son derivados; no se almacenan como columnas.

## Reglas de integridad relevantes
- Integridad de entidad: PK únicas y no nulas.
- Integridad referencial: FKs hacia las tablas relacionadas.
- Integridad de dominio: tipos, obligatoriedad, valores no negativos y dominios controlados.
- Las reglas de participación total de una jerarquía o la exigencia de que cada recurso tenga al menos un autor requieren validación adicional (por ejemplo, triggers o lógica transaccional); una FK por sí sola no garantiza la existencia de al menos una fila hija.

## Alcance y supuestos
Los documentos de las tareas anteriores no especifican todos los dominios permitidos ni las longitudes exactas de los campos. El SQL propone tipos y restricciones iniciales; los valores cerrados de `estado`, `tipo` y `estatus_pago` deben confirmarse con el responsable de la biblioteca. No se identifica una relación 1:1 explícita en el modelo E-R de origen, por lo que no se inventa una.
