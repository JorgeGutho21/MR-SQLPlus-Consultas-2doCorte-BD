-- ============================================================
-- ej2_paso6_consultas_datos.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Paso 6 de 7. Etapa 6 (consultas): privilegios recibidos, INSERT con ESQUEMA.TABLA, COMMIT, conteos y pruebas de integridad.
-- Usuario: USR_CONSULTAS_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_paso6_consultas_datos.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_consultas_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT Etapa 6 - USR_CONSULTAS_UNI inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- Comprobar que puede hacer USR_CONSULTAS_UNI
COLUMN privilege FORMAT A16
SELECT privilege FROM session_privs;

COLUMN owner FORMAT A16
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT owner, table_name, privilege
FROM user_tab_privs_recd
WHERE owner = 'USR_ADMIN_UNI'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM facultad;

SELECT COUNT(*) FROM usr_admin_uni.facultad;

-- ------------------------------------------------------------
-- Insertar en FACULTAD (5 filas)
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('ING', 'Ingenieria');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('SAL', 'Ciencias de la Salud');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('ECO', 'Ciencias Economicas');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('JUR', 'Ciencias Juridicas');
INSERT INTO usr_admin_uni.facultad (cod_fac, nom_facultad)
VALUES ('HUM', 'Humanidades');

-- ------------------------------------------------------------
-- Insertar en CARRERA (8 filas)
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('SIS', 'Ingenieria de Sistemas', 'ING');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('IND', 'Ingenieria Industrial', 'ING');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('MED', 'Medicina', 'SAL');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('ENF', 'Enfermeria', 'SAL');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('ADM', 'Administracion de Empresas', 'ECO');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('CON', 'Contaduria Publica', 'ECO');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('DER', 'Derecho', 'JUR');
INSERT INTO usr_admin_uni.carrera (cod_carrera, nom_carrera, cod_fac)
VALUES ('PSI', 'Psicologia', 'HUM');

-- ------------------------------------------------------------
-- Insertar en BARRIOS (8 filas)
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (1, 'El Prado');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (2, 'Los Alpes');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (3, 'Centro');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (4, 'La Floresta');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (5, 'El Bosque');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (6, 'San Fernando');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (7, 'Villa Country');
INSERT INTO usr_admin_uni.barrios (id_barrio, nom_barrio)
VALUES (8, 'Las Palmas');

-- ------------------------------------------------------------
-- Insertar en ALUMNOS desde un archivo (50 filas)
-- (requiere ej2_carga_alumnos.sql en C:\archivosbd)
@C:\archivosbd\ej2_carga_alumnos.sql

-- ------------------------------------------------------------
-- Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'FACULTAD' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.facultad
UNION ALL
SELECT 'CARRERA' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.carrera
UNION ALL
SELECT 'BARRIOS' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.barrios
UNION ALL
SELECT 'ALUMNOS' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.alumnos;

-- ------------------------------------------------------------
-- Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-02290, ORA-02291, ORA-02290, ORA-00001
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000060', 'Mario', NULL, 'Diaz', 'Leon', 'X', 3.5, 'SIS', 1, DATE '2003-02-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000061', 'Ana', 'Maria', 'Soto', NULL, 'F', 3.0, 'XYZ', 1, DATE '2004-01-01');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000062', 'Luis', NULL, 'Paz', 'Rios', 'M', 6, 'SIS', 1, DATE '2003-05-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000001', 'Pedro', NULL, 'Lozano', NULL, 'M', 3.5, 'SIS', 2, DATE '2003-08-08');

SPOOL OFF
