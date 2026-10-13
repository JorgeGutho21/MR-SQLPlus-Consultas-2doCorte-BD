# Ruta práctica Oracle

Laboratorio universitario interactivo: del **enunciado** al **modelo relacional** y a la **práctica completa en Oracle Database XE 18c con SQL*Plus**.

**Abrir la plataforma:** https://jorgegutho21.github.io/MR-SQLPlus-Consultas-2doCorte-BD/

## Ruta práctica (secuencia del curso)
| Etapa | Quién ejecuta | Qué hace |
|---|---|---|
| 0 | Estudiante | Enunciado → entidades → relaciones → cardinalidades → PK/FK → intersección → modelo relacional final |
| 1 | SYSTEM | `CREATE TABLESPACE` y su `DATAFILE` (Vehículos: `SIZE 10M`, `AUTOEXTEND`, `MAXSIZE`) |
| 2 | SYSTEM | `CREATE USER` administrador con `DEFAULT TABLESPACE` y `QUOTA` |
| 3 | SYSTEM → ADMIN | SYSTEM: `GRANT CREATE SESSION, CREATE TABLE, CREATE USER` y `CREATE SESSION … WITH ADMIN OPTION`. ADMIN: tablas → PK → FK → UNIQUE/CHECK con `ALTER TABLE` |
| 4 | ADMIN | `CREATE USER` del usuario de consultas (ya no lo crea SYSTEM) |
| 5 | ADMIN | `GRANT CREATE SESSION` y `GRANT SELECT, INSERT ON` cada tabla propia |
| 6 | CONSULTAS | `INSERT INTO ESQUEMA.TABLA`, `COMMIT`, conteos y consultas |

No se otorga DBA. `CREATE SEQUENCE` solo haría falta con IDENTITY o secuencias (los cuatro modelos no las usan).

## Claves de los cuatro modelos
La clasificación depende del **origen** del dato según el enunciado, no del nombre `id_…` ni del tipo `NUMBER`. Las columnas conservan sus nombres.

| Ejercicio | PK natural | PK + SK (artificial) | PK compuesta (PK/FK) | UNIQUE (candidata) |
|---|---|---|---|---|
| 1 Vehículos | `PROPIETARIO.id_propietario` (documento), `VEHICULO.placa` | `MARCA.id_marca` | `PROP_VEH (id_propietario, placa)` | `MARCA.nom_marca` |
| 2 Universidad | `FACULTAD.cod_fac`, `CARRERA.cod_carrera`, `ALUMNOS.ced_alumno` | `BARRIOS.id_barrio` | — | — |
| 3 Pedidos | — | `CLIENTE.id_cliente`, `PRODUCTO.id_producto`, `PEDIDO.id_pedido` | `DETALLE_PEDIDO (id_pedido, id_producto)` | `CLIENTE.correo`, `PRODUCTO.nom_producto` |
| 4 Pasaportes | `PAIS.cod_pais` (ISO), `PERSONA.id_persona`, `PASAPORTE_VIGENTE.num_pasaporte` | — | — | `PASAPORTE_VIGENTE.id_persona` (FK + UNIQUE → 1:1) |

`VEHICULO.placa` es PK; `PROP_VEH.placa` es FK hacia VEHICULO y forma la PK compuesta con `id_propietario`. Una SK de adquisición se presenta solo como alternativa para historiales con recompras.

Vehículos, columnas definitivas:

| Tabla | Columnas | Restricciones |
|---|---|---|
| PROPIETARIO | `id_propietario`, `primer_nombre`, `segundo_nombre` (opcional), `primer_apellido`, `segundo_apellido` (opcional), `telefono`, `correo`, `sexo CHAR(1)` | PK natural; `chk_propietario_sexo`: `sexo IN ('M', 'F')` |
| MARCA | `id_marca`, `nom_marca` | PK + SK; UNIQUE `nom_marca` |
| VEHICULO | `placa`, `linea`, `modelo`, `cilindraje NUMBER(5)`, `id_marca` | PK natural; FK → MARCA; `chk_vehiculo_modelo` |
| PROP_VEH | `id_propietario`, `placa`, `fecha_adquisicion` | PK compuesta (id_propietario, placa), cada parte FK |

## Contenido
1. **Fundamentos**: enunciado y reglas de negocio, entidades y atributos, niveles de modelo, relaciones y cardinalidades, claves y restricciones (incluye claves subrogadas, SK), árbol de decisión, normalización hasta 3FN y tipos de datos.
2. **Laboratorio relacional**: cuatro ejercicios con construcción progresiva en cinco vistas, clasificación de términos, predicción de cardinalidades, diagrama, modelo correcto frente a incorrecto, solución razonada y preguntas tipo parcial.
3. **Laboratorio SQL*Plus**: cada ejercicio completo con la ruta anterior; cada paso muestra Usuario actual · Comando · Explicación · Cambio en Oracle · Resultado esperado · Verificación. Incluye el mapa SYSTEM → USR_ADMIN → USR_CONSULTAS y un laboratorio de privilegios (SYSTEM_PRIVILEGE_MAP, roles, ADMIN OPTION frente a GRANT OPTION, GRANT/REVOKE).
4. **Consultas**: SELECT, filtros, JOIN, GROUP BY, HAVING, preguntas tipo parcial y laboratorio con el esquema de ejemplo HR (solo lectura).
5. **Repaso**: sentencias SQL (DDL, DML, DCL, TCL), laboratorio de errores ORA/SP2, retos, glosario, evaluación y descargas.

| Ejercicio | Tema | Esquema |
|---|---|---|
| 1 | Propietarios y vehículos | USR_ADMIN_VEH / USR_CONSULTAS_VEH |
| 2 | Sistema universitario (alumnos) | USR_ADMIN_UNI / USR_CONSULTAS_UNI |
| 3 | Clientes y pedidos | USR_ADMIN_PED / USR_CONSULTAS_PED |
| 4 | Personas y pasaportes vigentes | USR_ADMIN_PAS / USR_CONSULTAS_PAS |

## Scripts SQL
Carpeta [`scripts/`](scripts/), por ejercicio:
- **Recomendado, uno por usuario:** `_01_administracion.sql` (SYSTEM) → `_02_esquema.sql` (administrador: tablas, restricciones, usuario de consultas y permisos) → `_03_datos_consultas.sql` (usuario de consultas).
- `_00_completo.sql`: las seis etapas en un solo archivo.
- `_paso1` a `_paso7`: un bloque por archivo para repetir solo una parte.
- Archivo de carga cuando aplica, `_99_limpieza.sql` (opcional) y `_resumen.txt`.

Los scripts no contienen contraseñas: SQL*Plus las pide ocultas con `ACCEPT … HIDE`, con `SET VERIFY OFF` y con el SPOOL en pausa mientras se piden y se usan.

## Verificación
Revisión del 13 de octubre de 2026 (cilindraje, nombres separados y sexo):

- **Ejecución real en Oracle Database XE 18c (PDB XEPDB1)** con objetos de prueba aislados, contraseñas aleatorias que no se imprimen y limpieza al final. No se tocaron usuarios, tablas ni tablespaces preexistentes.
- Los cuatro ejercicios paso a paso, los 53 archivos descargables (`_00_completo`, `_01`/`_02`/`_03` y `_paso1`…`_paso7`) y los laboratorios de privilegios, sentencias SQL, SK y HR (solo lectura): sin errores inesperados.
- Pruebas intencionales de Vehículos: ORA-02291 (FK), ORA-02290 (modelo), ORA-02290 (sexo), ORA-00001 (UNIQUE) y ORA-01031 (DELETE sin privilegio). Laboratorio de errores: 64 casos reproducen su código ORA esperado.
- Las salidas que muestra la página (consultas, conteos, GROUP BY) son las capturadas en esa ejecución.
- Además: validación estática de modelos y datos y contraste de consultas en SQLite (ver [VALIDACION.md](VALIDACION.md)).

Página estática (HTML, CSS y JavaScript sin dependencias). El progreso se guarda en el navegador.

## Modelo definitivo y ampliaciones
Vehículos conserva PROPIETARIO, MARCA, VEHICULO y PROP_VEH. Todas las tablas de personas de los cuatro ejercicios usan primer_nombre, segundo_nombre opcional, primer_apellido y segundo_apellido opcional. PROPIETARIO agrega sexo M/F; VEHICULO usa cilindraje. Color y país de origen se explican únicamente como ampliaciones y no aparecen en sus scripts principales.

La PK compuesta de PROP_VEH permite una fila por pareja propietario–vehículo. Para recompras se explica una SK de adquisición como alternativa, sin cambiar el modelo del profesor.

## Generar y comprobar
Requiere Node.js y Python 3, sin dependencias adicionales para los modelos.
```shell
node tools/build-scripts.cjs
node tools/validate.cjs models.json
python tools/validate-data.py models.json expected.json
```
El primer comando regenera los 53 archivos desde index.html; validate comprueba su correspondencia exacta, columnas, tipos, claves, relaciones y secuencia. La prueba Python contrasta consultas y rechazos de integridad en una base efímera SQLite; no sustituye una ejecución en Oracle 18c.

Referencias de sintaxis: [CREATE TABLE en Oracle 18c](https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/CREATE-TABLE.html), [restricciones en Oracle 18c](https://docs.oracle.com/en/database/oracle/oracle-database/18/sqlrf/constraint.html).

La interfaz conserva los 39 módulos, almacenamiento local del progreso, modo claro/oscuro, diagramas con selección por teclado y ratón, zoom, evaluación y descargas.
