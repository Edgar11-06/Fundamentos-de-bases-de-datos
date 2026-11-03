# Tarea 1.2: Clasificación y arquitecturas (ANSI/SPARC y SGBD)

## Datos del alumno

| | |
|---|---|
| **Alumno** | Edgar Alejandro Hernandez Guajardo |
| **Matrícula** | I24050409 |
| **Docente** | Ing. Ruben Riojas |
| **Institución** | Instituto Tecnológico Superior de Monclova |
| **Unidad** | Unidad 1 |
| **Actividad** | Tarea 1.2 |

## Descripción de la tarea

En esta tarea se investiga la clasificación de las bases de datos según distintos criterios (ubicación, variabilidad de los datos, modelo, contenido, número de usuarios y función) y se resume en un cuadro sinóptico. Además, se describe y esquematiza la arquitectura de tres niveles de una base de datos (externo, conceptual e interno) propuesta por ANSI/SPARC, así como la arquitectura funcional interna de un Sistema Gestor de Bases de Datos (SGBD).

## 📄 Documentación

👉 [**Ver documento PDF de la Tarea 1.2**](documentacion/Tarea_1.2_Clasificacion_y_Arquitecturas.pdf)

## Estructura de la carpeta

```
Unidad1/
└── Tarea 1.2/
    ├── Readme.md
    ├── documentacion/
    │   ├── Tarea_1.2_Clasificacion_y_Arquitecturas.docx
    │   └── Tarea_1.2_Clasificacion_y_Arquitecturas.pdf
    └── diagramas/
        ├── 01_cuadro_sinoptico_clasificacion.(mmd|svg|png)
        ├── 02_arquitectura_tres_niveles_ansi_sparc.(mmd|svg|png)
        └── 03_arquitectura_funcional_sgbd.(mmd|svg|png)
```

Los archivos `.mmd` son las **fuentes vectoriales editables** (Mermaid); los `.svg` y `.png` son sus renders.

## 1. Cuadro sinóptico: clasificación de las bases de datos

```mermaid
flowchart LR
    BD["<b>CLASIFICACIÓN DE LAS<br/>BASES DE DATOS</b>"]

    V["Según la variabilidad<br/>de los datos"]
    U["Según la ubicación<br/>(distribución)"]
    M["Según el modelo<br/>de datos"]
    C["Según su contenido"]
    N["Según el número<br/>de usuarios"]
    F["Según su función<br/>o uso"]

    BD --> V
    BD --> U
    BD --> M
    BD --> C
    BD --> N
    BD --> F

    V --> V1["<b>Estáticas</b><br/>Solo lectura; datos históricos"]
    V --> V2["<b>Dinámicas</b><br/>Datos que cambian constantemente"]

    U --> U1["<b>Centralizadas</b><br/>Un solo sitio físico"]
    U --> U2["<b>Distribuidas</b><br/>Varios sitios conectados por red"]
    U2 --> U21["Homogéneas<br/>(mismo SGBD)"]
    U2 --> U22["Heterogéneas<br/>(distintos SGBD)"]

    M --> M1["• Jerárquicas<br/>• De red<br/>• Relacionales<br/>• Orientadas a objetos<br/>• NoSQL (documentos, clave-valor,<br/>   columnas y grafos)"]

    C --> C1["• Bibliográficas<br/>• De texto completo<br/>• Directorios<br/>• Especializadas"]

    N --> N1["<b>Monousuario</b><br/>Un usuario a la vez"]
    N --> N2["<b>Multiusuario</b><br/>Acceso simultáneo"]

    F --> F1["<b>Operacionales (OLTP)</b><br/>Transacciones diarias"]
    F --> F2["<b>Analíticas (OLAP)</b><br/>Almacenes de datos"]

    classDef central fill:#1F3864,stroke:#1F3864,color:#ffffff,stroke-width:2px
    classDef rama fill:#2E75B6,stroke:#1F3864,color:#ffffff
    classDef hoja fill:#DEEAF6,stroke:#2E75B6,color:#1F3864
    class BD central
    class V,U,M,C,N,F rama
    class V1,V2,U1,U2,U21,U22,M1,C1,N1,N2,F1,F2 hoja
```

## 2. Arquitectura de tres niveles (ANSI/SPARC)

| Nivel | Descripción |
|---|---|
| **Externo** | Vistas de usuario: muestran a cada grupo solo la parte de la base de datos que le interesa. |
| **Conceptual** | Esquema lógico global: entidades, atributos, relaciones y restricciones de integridad. |
| **Interno (físico)** | Esquema de almacenamiento: archivos, índices, rutas de acceso y estructuras físicas. |

Las correspondencias entre niveles proporcionan la **independencia lógica** (externo/conceptual) y la **independencia física** (conceptual/interno).

```mermaid
flowchart TB
    subgraph EXT["NIVEL EXTERNO (vistas de usuario)"]
        direction LR
        E1["Vista 1<br/>Control escolar"]
        E2["Vista 2<br/>Docentes"]
        E3["Vista n<br/>Finanzas"]
    end

    MAP1{{"Correspondencia<br/>externo / conceptual<br/><i>(independencia lógica)</i>"}}

    subgraph CON["NIVEL CONCEPTUAL (esquema lógico global)"]
        direction LR
        C1["Entidades, atributos<br/>y relaciones"]
        C2["Restricciones de<br/>integridad y seguridad"]
    end

    MAP2{{"Correspondencia<br/>conceptual / interno<br/><i>(independencia física)</i>"}}

    subgraph INT["NIVEL INTERNO / FÍSICO (esquema de almacenamiento)"]
        direction LR
        I1["Archivos y<br/>estructuras de datos"]
        I2["Índices y<br/>rutas de acceso"]
        I3["Bloques, páginas y<br/>compresión"]
    end

    DISK[("Almacenamiento físico<br/>(discos, SSD, nube)")]

    U1(["Usuarios finales y aplicaciones"])
    U1 --> E1
    U1 --> E2
    U1 --> E3
    E1 --> MAP1
    E2 --> MAP1
    E3 --> MAP1
    MAP1 --> C1
    MAP1 --> C2
    C1 --> MAP2
    C2 --> MAP2
    MAP2 --> I1
    MAP2 --> I2
    MAP2 --> I3
    I1 --> DISK
    I2 --> DISK
    I3 --> DISK

    classDef nodo fill:#DEEAF6,stroke:#2E75B6,color:#1F3864
    classDef map fill:#FFF2CC,stroke:#BF9000,color:#7F6000
    classDef user fill:#1F3864,stroke:#1F3864,color:#ffffff
    classDef disk fill:#E2EFDA,stroke:#548235,color:#375623
    class E1,E2,E3,C1,C2,I1,I2,I3 nodo
    class MAP1,MAP2 map
    class U1 user
    class DISK disk
    style EXT fill:#FFFFFF,stroke:#1F3864,stroke-width:2px
    style CON fill:#FFFFFF,stroke:#1F3864,stroke-width:2px
    style INT fill:#FFFFFF,stroke:#1F3864,stroke-width:2px
```

## 3. Arquitectura funcional interna del SGBD

```mermaid
flowchart TB
    subgraph USR["USUARIOS"]
        direction LR
        US1["Usuarios<br/>ingenuos"]
        US2["Programadores<br/>de aplicaciones"]
        US3["Usuarios<br/>avanzados"]
        US4["Administrador<br/>(DBA)"]
    end

    subgraph INTF["INTERFACES"]
        direction LR
        IF1["Aplicaciones"]
        IF2["Precompilador<br/>DML"]
        IF3["Consultas<br/>interactivas"]
        IF4["Herramientas<br/>administrativas"]
    end

    subgraph QP["PROCESADOR DE CONSULTAS"]
        direction LR
        Q1["Intérprete DDL"]
        Q2["Compilador DML<br/>y optimizador"]
        Q3["Motor de<br/>evaluación"]
    end

    subgraph SM["GESTOR DE ALMACENAMIENTO"]
        direction LR
        S1["Gestor de<br/>autorización e integridad"]
        S2["Gestor de<br/>transacciones"]
        S3["Gestor de<br/>archivos"]
        S4["Gestor de<br/>búfer"]
    end

    subgraph DSK["ALMACENAMIENTO EN DISCO"]
        direction LR
        D1[("Datos")]
        D2[("Diccionario de<br/>datos (catálogo)")]
        D3[("Índices")]
        D4[("Bitácora<br/>(log)")]
    end

    US1 --> IF1
    US2 --> IF2
    US3 --> IF3
    US4 --> IF4
    IF1 --> Q2
    IF2 --> Q2
    IF3 --> Q2
    IF4 --> Q1
    Q1 --> S1
    Q2 --> Q3
    Q3 --> S2
    S1 --> S3
    S2 --> S3
    S3 --> S4
    S4 --> D1
    S4 --> D3
    S3 --> D2
    S2 --> D4

    classDef usr fill:#1F3864,stroke:#1F3864,color:#ffffff
    classDef intf fill:#FFF2CC,stroke:#BF9000,color:#7F6000
    classDef nodo fill:#DEEAF6,stroke:#2E75B6,color:#1F3864
    classDef disk fill:#E2EFDA,stroke:#548235,color:#375623
    class US1,US2,US3,US4 usr
    class IF1,IF2,IF3,IF4 intf
    class Q1,Q2,Q3,S1,S2,S3,S4 nodo
    class D1,D2,D3,D4 disk
    style USR fill:#FFFFFF,stroke:#1F3864,stroke-width:2px
    style INTF fill:#FFFFFF,stroke:#BF9000,stroke-width:2px
    style QP fill:#FFFFFF,stroke:#1F3864,stroke-width:2px
    style SM fill:#FFFFFF,stroke:#1F3864,stroke-width:2px
    style DSK fill:#FFFFFF,stroke:#548235,stroke-width:2px
```

> La explicación detallada de cada componente está en el [documento PDF](documentacion/Tarea_1.2_Clasificacion_y_Arquitecturas.pdf).

## Cómo regenerar los diagramas

```bash
npm install -g @mermaid-js/mermaid-cli
mmdc -i diagramas/01_cuadro_sinoptico_clasificacion.mmd -o diagramas/01_cuadro_sinoptico_clasificacion.svg
```

## Referencias (APA 7)

- Connolly, T., & Begg, C. (2015). *Database systems: A practical approach to design, implementation, and management* (6.ª ed.). Pearson.
- Coronel, C., & Morris, S. (2019). *Database systems: Design, implementation, & management* (13.ª ed.). Cengage Learning.
- Date, C. J. (2004). *An introduction to database systems* (8.ª ed.). Addison-Wesley.
- Elmasri, R., & Navathe, S. B. (2016). *Fundamentals of database systems* (7.ª ed.). Pearson.
- Özsu, M. T., & Valduriez, P. (2020). *Principles of distributed database systems* (4.ª ed.). Springer. https://doi.org/10.1007/978-3-030-26253-2
- Silberschatz, A., Korth, H. F., & Sudarshan, S. (2019). *Database system concepts* (7.ª ed.). McGraw-Hill Education.
- Tsichritzis, D., & Klug, A. (Eds.). (1978). The ANSI/X3/SPARC DBMS framework: Report of the Study Group on Database Management Systems. *Information Systems, 3*(3), 173–191. https://doi.org/10.1016/0306-4379(78)90001-7

## 🎥 Video explicativo

▶️ Explicación de los temas en YouTube: [VIDEO YOUTUBE](https://youtu.be/Ea9HYa_0brs)
