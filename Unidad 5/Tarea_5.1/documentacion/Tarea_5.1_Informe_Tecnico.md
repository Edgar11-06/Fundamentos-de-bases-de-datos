# Instituto Tecnológico Superior de Monclova

## Unidad 5 · Tarea 5.1
**Operadores fundamentales y extendidos del álgebra relacional**  
**Materia:** Fundamentos de Bases de Datos  
**Alumno:** Edgar Alejandro Hernández Guajardo  
**Matrícula:** I24050409  
**Docente:** Ing. Ruben Riojas

## 1. Introducción y objetivo
El álgebra relacional es un lenguaje formal y procedimental de consulta que opera sobre relaciones (conjuntos de tuplas) y produce relaciones como resultado. Su propiedad de cierre permite componer expresiones y constituye parte de la base teórica de las consultas SQL. Se estudian operadores unarios y binarios, sus restricciones de aplicación, y extensiones para expresiones calculadas, agrupación y reuniones externas.

## 2. Marco conceptual
Sea R(A₁,…,Aₙ) una relación, con tuplas definidas en los dominios respectivos. La **selección** filtra tuplas; la **proyección** selecciona atributos. El álgebra clásica supone **semántica de conjuntos**: no hay duplicados. En SQL, en cambio, pueden aparecer duplicados sin `DISTINCT` y se usa `NULL`; las reuniones externas y la agregación corresponden a extensiones prácticas.

**Convención:** R y S son relaciones; θ es una condición; L representa una lista de atributos; `γ` indica agrupación y agregación (en algunos textos `G`). Para `∪`, `∩`, `−` los operandos deben ser compatibles para unión: igual número de atributos y dominios compatibles, ajustando nombres cuando sea necesario. La división exige atributos comunes definidos con dominios compatibles.

## 3. Operadores unarios
### 3.1 Selección
**σ_θ(R) = {t ∈ R | θ(t)}.** Escoge filas que satisfacen el predicado θ; no elimina columnas.
Ejemplo: σ_(estatus='ACTIVO')(USUARIO). Resultado: únicamente usuarios activos.

### 3.2 Proyección
**π_L(R) = {t[L] | t ∈ R}.** Escoge columnas especificadas y elimina tuplas duplicadas (conjuntos).
Ejemplo: π_(id_categoria)(RECURSO). Devuelve categorías distintas empleadas por recursos.

## 4. Operadores binarios fundamentales y derivados
### 4.1 Producto cartesiano
**R × S = {(r,s) | r ∈ R ∧ s ∈ S}.** Combina cada fila de R con cada fila de S; su cardinalidad es |R| × |S| y requiere distinguir atributos homónimos.
Ejemplo: AUTOR × CATEGORIA produce todas las parejas autor-categoría, sin exigir relación real.

### 4.2 Unión
**R ∪ S = {t | t ∈ R ∨ t ∈ S}.** Reúne filas de ambas relaciones, sin repeticiones, siempre que sean compatibles para unión.
Ejemplo: π_(id_usuario)(ESTUDIANTE) ∪ π_(id_usuario)(DOCENTE), usuarios que pertenecen a cualquiera de los dos tipos.

### 4.3 Intersección
**R ∩ S = {t | t ∈ R ∧ t ∈ S} = R − (R − S).** Recupera las filas presentes en ambos operandos; requiere compatibilidad para unión.
Ejemplo: conjuntos de identificadores de recursos de dos listas de consulta compatibles. En un modelo de subtipos disjuntos como USUARIO/ESTUDIANTE/DOCENTE, la intersección esperada entre sus identificadores es vacía.

### 4.4 Diferencia
**R − S = {t | t ∈ R ∧ t ∉ S}.** Devuelve lo que aparece en R y no aparece en S; requiere compatibilidad para unión. No es conmutativa.
Ejemplo: π_(id_usuario)(USUARIO) − π_(id_usuario)(PRESTAMO), usuarios que nunca aparecen en préstamos.

### 4.5 División
**R(X,Y) ÷ S(Y) = {x ∈ π_X(R) | ∀ y ∈ S, (x,y) ∈ R}.** Resuelve preguntas universales («todos»).
Ejemplo didáctico: AUTORIA(id_recurso,id_autor) ÷ AUTORES_REQUERIDOS(id_autor) devuelve recursos escritos por **todos** los autores incluidos en el conjunto requerido. Si S es vacío, el resultado incluye los valores X presentes en R.

### 4.6 Reunión o join
**R ⋈_θ S = σ_θ(R × S).** Combina filas relacionadas por una condición. La reunión natural `R ⋈ S` compara atributos de igual nombre y evita duplicarlos en el resultado; exige cuidado con atributos homónimos no destinados a comparación.
Ejemplo: PRESTAMO ⋈_(PRESTAMO.id_usuario=USUARIO.id_usuario) USUARIO vincula préstamos con usuarios.

## 5. Álgebra relacional extendida
### 5.1 Proyección generalizada
**π_(A, expresión→alias,…)(R).** Admite operaciones aritméticas o expresiones calculadas y nombres de salida.
Ejemplo: π_(id_multa, monto, monto×1.16→monto_con_factor)(MULTA). El factor 1.16 es solo un ejemplo matemático, no una tasa aplicable a multas.

### 5.2 Funciones de agregación y agrupación
**γ_(G; f(A)→alias)(R)** o **_{G}𝒢_{f(A)→alias}(R)** según convención del texto. `G` es la lista de atributos por la que se agrupa; f puede ser COUNT, SUM, AVG, MIN o MAX.
Ejemplo: γ_(folio; SUM(monto)→total_multa)(MULTA) suma los importes por préstamo. Para un agregado global, G se omite.

### 5.3 Reuniones externas
**R ⟕_θ S (LEFT OUTER JOIN)** conserva todas las tuplas de R; las que no encuentran correspondencia completan con NULL los atributos de S.
**R ⟖_θ S (RIGHT OUTER JOIN)** conserva todas las tuplas de S; las no relacionadas completan con NULL los atributos de R.
**R ⟗_θ S (FULL OUTER JOIN)** conserva todas las filas de ambos lados; donde no existe pareja se completan campos con NULL.
Ejemplo: USUARIO ⟕_(USUARIO.id_usuario=PRESTAMO.id_usuario) PRESTAMO muestra todos los usuarios, incluidos quienes no tienen préstamos.

## 6. Ejemplos representativos con datos ficticios
Sea USUARIO(id_usuario, nombre): {(U1, Ana), (U2, Luis), (U3, Eva)}; PRESTAMO(folio,id_usuario): {(P1,U1),(P2,U1),(P3,U2)}.
- π_id_usuario(PRESTAMO) = {U1,U2}.
- π_id_usuario(USUARIO) − π_id_usuario(PRESTAMO) = {U3}.
- USUARIO ⟕ PRESTAMO conserva U1 (dos coincidencias), U2 (una), y U3 (con folio NULL).
- γ_id_usuario;COUNT(folio)→n(PRESTAMO) = {(U1,2),(U2,1)}. Para contar también U3 se necesita reunión externa previa y contar un atributo no nulo del lado PRESTAMO.

División: si AUTORIA contiene (R1,A1),(R1,A2),(R2,A1),(R3,A1),(R3,A2) y AUTORES_REQUERIDOS={A1,A2}, el resultado es {R1,R3}.

## 7. Distinción entre álgebra clásica y SQL
La proyección clásica elimina duplicados mientras que `SELECT` sin `DISTINCT` no los elimina. `UNION` y `INTERSECT` SQL suelen aplicar eliminación de duplicados, mientras que `UNION ALL` conserva duplicados. Las reuniones externas introducen NULL y deben tratarse como parte de la extensión práctica, no de la teoría clásica estricta. En SQL Server, división se expresa generalmente con consultas `NOT EXISTS` anidadas.

## 8. Conclusión
Los operadores unarios permiten filtrar filas y elegir columnas; los binarios combinan y comparan relaciones; la división expresa condiciones universales; y las extensiones facilitan cálculos, agregaciones y conservación de registros sin correspondencia. Dominar la notación formal permite razonar y estructurar consultas sobre la base de datos de la biblioteca.

## 9. Referencias
- Brown University, CSCI 1270. (2020). *Relational Algebra* [diapositivas]. https://cs.brown.edu/courses/cs127/website_2020/static/files/slides2020/RelationalAlgebra.pdf
- University of New South Wales. (2023). *Relational Algebra*. https://cgi.cse.unsw.edu.au/~cs3311/23T3/notes/C/notes.html
- Rensselaer Polytechnic Institute. (2025). *Relational Model and Relational Algebra*. https://cs.rpi.edu/~sibel/csci4380/fall2025/course_notes/relational_algebra.html
- OpenStax. (2024). *Introduction to Computer Science, sección 8.3*. https://openstax.org/books/introduction-computer-science/pages/8-3-relational-database-management-systems
