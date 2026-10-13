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
Todos los scripts (completos, agrupados, por paso y paso a paso) se ejecutaron en Oracle Database XE 18c (servicio XEPDB1) con usuarios y tablespaces de prueba que luego se eliminaron. Las salidas que la página marca como «salida real» son las obtenidas en esa ejecución; las consultas HR se leyeron sin modificar el esquema.

Página estática (HTML, CSS y JavaScript sin dependencias). El progreso se guarda en el navegador.
