-- ============================================================
-- ej2_00_completo.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Script completo: las seis etapas en orden, con cambios de usuario y evidencia SPOOL.
-- Usuario: SYSTEM -> USR_ADMIN_UNI -> SYSTEM -> USR_ADMIN_UNI -> USR_CONSULTAS_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_00_completo.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
-- Abrir antes:  cd /d C:\archivosbd   y   sqlplus /nolog
SET VERIFY OFF

-- ------------------------------------------------------------
-- [Etapa 1] Conectarte como SYSTEM a XEPDB1
CONNECT system@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 1] Iniciar la evidencia con SPOOL y confirmar la sesion
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt
PROMPT ==== EJERCICIO 2: SISTEMA UNIVERSITARIO ====
PROMPT Etapa 1 - SYSTEM crea el TABLESPACE y su DATAFILE
SHOW USER
SHOW CON_NAME

-- ------------------------------------------------------------
-- [Etapa 1] Crear el TABLESPACE y su DATAFILE
CREATE TABLESPACE ts_universidad
  DATAFILE 'C:\ORACLE_EXE\ORADATA\XE\XEPDB1\TS_UNIVERSIDAD01.DBF'
  SIZE 20M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 100M;

-- Verificacion
COLUMN tablespace_name FORMAT A15
COLUMN file_name FORMAT A55
SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name = 'TS_UNIVERSIDAD';

SELECT file_name, bytes/1024/1024 AS mb, autoextensible
FROM dba_data_files
WHERE tablespace_name = 'TS_UNIVERSIDAD';

-- ------------------------------------------------------------
-- [Etapa 2] Crear el usuario administrador USR_ADMIN_UNI
ACCEPT clave_admin CHAR PROMPT 'Clave para USR_ADMIN_UNI: ' HIDE
CREATE USER usr_admin_uni
  IDENTIFIED BY "&clave_admin"
  DEFAULT TABLESPACE ts_universidad
  TEMPORARY TABLESPACE temp
  QUOTA 20M ON ts_universidad;
UNDEFINE clave_admin
PROMPT Etapa 2 - SYSTEM creo el usuario administrador USR_ADMIN_UNI

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_ADMIN_UNI';

SELECT tablespace_name, max_bytes/1024/1024 AS cuota_mb
FROM dba_ts_quotas
WHERE username = 'USR_ADMIN_UNI';

-- ------------------------------------------------------------
-- [Etapa 3] Etapa 3 (SYSTEM): privilegios del sistema para USR_ADMIN_UNI
PROMPT Etapa 3 - SYSTEM otorga privilegios a USR_ADMIN_UNI
GRANT CREATE SESSION, CREATE TABLE TO usr_admin_uni;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_ADMIN_UNI'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 3] Conectarte como USR_ADMIN_UNI
CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 3 - USR_ADMIN_UNI crea las tablas

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla FACULTAD
CREATE TABLE facultad (
  cod_fac      VARCHAR2(3 CHAR),
  nom_facultad VARCHAR2(30 CHAR) NOT NULL
);

-- Verificacion
DESC facultad

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla CARRERA
CREATE TABLE carrera (
  cod_carrera VARCHAR2(3 CHAR),
  nom_carrera VARCHAR2(30 CHAR) NOT NULL,
  cod_fac     VARCHAR2(3 CHAR) NOT NULL
);

-- Verificacion
DESC carrera

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla BARRIOS
CREATE TABLE barrios (
  id_barrio  NUMBER(3),
  nom_barrio VARCHAR2(30 CHAR) NOT NULL
);

-- Verificacion
DESC barrios

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla ALUMNOS
CREATE TABLE alumnos (
  ced_alumno  VARCHAR2(10 CHAR),
  nombre      VARCHAR2(15 CHAR) NOT NULL,
  apellido    VARCHAR2(20 CHAR) NOT NULL,
  genero      CHAR(1) NOT NULL,
  promedio    NUMBER(2,1),
  cod_carrera VARCHAR2(3 CHAR) NOT NULL,
  id_barrio   NUMBER(3)
);

-- Verificacion
DESC alumnos

-- ------------------------------------------------------------
-- [Etapa 3] Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE facultad
  ADD CONSTRAINT pk_facultad PRIMARY KEY (cod_fac);

ALTER TABLE carrera
  ADD CONSTRAINT pk_carrera PRIMARY KEY (cod_carrera);

ALTER TABLE barrios
  ADD CONSTRAINT pk_barrios PRIMARY KEY (id_barrio);

ALTER TABLE alumnos
  ADD CONSTRAINT pk_alumnos PRIMARY KEY (ced_alumno);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name
FROM user_constraints
WHERE constraint_type = 'P'
ORDER BY table_name;

-- ------------------------------------------------------------
-- [Etapa 3] Agregar las FOREIGN KEY
PROMPT Etapa 3 - FOREIGN KEY
ALTER TABLE carrera
  ADD CONSTRAINT fk_carrera_facultad
  FOREIGN KEY (cod_fac) REFERENCES facultad (cod_fac);

ALTER TABLE alumnos
  ADD CONSTRAINT fk_alumnos_carrera
  FOREIGN KEY (cod_carrera) REFERENCES carrera (cod_carrera);

ALTER TABLE alumnos
  ADD CONSTRAINT fk_alumnos_barrios
  FOREIGN KEY (id_barrio) REFERENCES barrios (id_barrio);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
ORDER BY table_name, constraint_name;

-- ------------------------------------------------------------
-- [Etapa 3] Agregar CHECK
PROMPT Etapa 3 - CHECK
ALTER TABLE alumnos
  ADD CONSTRAINT chk_alumnos_genero CHECK (genero IN ('M', 'F'));

ALTER TABLE alumnos
  ADD CONSTRAINT chk_alumnos_promedio CHECK (promedio BETWEEN 0 AND 5);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

-- ------------------------------------------------------------
-- [Etapa 3] Requisito nuevo: agregar fecha_nac con ALTER TABLE
PROMPT Etapa 3 - Cambio de requisitos: fecha de nacimiento
ALTER TABLE alumnos
  ADD fecha_nac DATE;

-- Verificacion
DESC alumnos

-- ------------------------------------------------------------
-- [Etapa 4] Etapa 4: volver a SYSTEM
CONNECT system@localhost:1521/XEPDB1
PROMPT Etapa 4 - SYSTEM crea el usuario de consultas

-- ------------------------------------------------------------
-- [Etapa 4] Crear el usuario de consultas USR_CONSULTAS_UNI
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_UNI: ' HIDE
CREATE USER usr_consultas_uni
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_universidad
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
PROMPT Etapa 4 - SYSTEM creo el usuario USR_CONSULTAS_UNI

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_CONSULTAS_UNI';

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (SYSTEM): privilegio del sistema CREATE SESSION
PROMPT Etapa 5 - Privilegios del usuario de consultas
GRANT CREATE SESSION TO usr_consultas_uni;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_CONSULTAS_UNI'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 5] Volver a USR_ADMIN_UNI, dueno de las tablas
CONNECT usr_admin_uni@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (USR_ADMIN_UNI): privilegios sobre objetos
GRANT SELECT, INSERT ON facultad TO usr_consultas_uni;
GRANT SELECT, INSERT ON carrera TO usr_consultas_uni;
GRANT SELECT, INSERT ON barrios TO usr_consultas_uni;
GRANT SELECT, INSERT ON alumnos TO usr_consultas_uni;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_UNI'
ORDER BY table_name, privilege;

-- ------------------------------------------------------------
-- [Etapa 6] Etapa 6: conectarte como USR_CONSULTAS_UNI y preparar la pantalla
CONNECT usr_consultas_uni@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 6 - USR_CONSULTAS_UNI inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- [Etapa 6] Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM facultad;

SELECT COUNT(*) FROM usr_admin_uni.facultad;

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en FACULTAD (5 filas)
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
-- [Etapa 6] Insertar en CARRERA (8 filas)
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
-- [Etapa 6] Insertar en BARRIOS (8 filas)
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
-- [Etapa 6] Insertar en ALUMNOS desde un archivo (50 filas)
@C:\archivosbd\ej2_carga_alumnos.sql

-- ------------------------------------------------------------
-- [Etapa 6] Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'FACULTAD' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.facultad
UNION ALL
SELECT 'CARRERA' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.carrera
UNION ALL
SELECT 'BARRIOS' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.barrios
UNION ALL
SELECT 'ALUMNOS' AS tabla, COUNT(*) AS filas FROM usr_admin_uni.alumnos;

-- ------------------------------------------------------------
-- [Etapa 6] Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-02290, ORA-02291, ORA-02290, ORA-00001
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000060', 'Mario', 'Diaz', 'X', 3.5, 'SIS', 1, DATE '2003-02-02');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000061', 'Ana', 'Soto', 'F', 3.0, 'XYZ', 1, DATE '2004-01-01');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000062', 'Luis', 'Paz', 'M', 6, 'SIS', 1, DATE '2003-05-05');

INSERT INTO usr_admin_uni.alumnos (ced_alumno, nombre, apellido, genero, promedio, cod_carrera, id_barrio, fecha_nac)
VALUES ('1000000001', 'Pedro', 'Lozano', 'M', 3.5, 'SIS', 2, DATE '2003-08-08');

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuantos alumnos hay en cada carrera?
SELECT c.cod_carrera, c.nom_carrera, COUNT(a.ced_alumno) AS alumnos
FROM usr_admin_uni.carrera c
LEFT JOIN usr_admin_uni.alumnos a ON a.cod_carrera = c.cod_carrera
GROUP BY c.cod_carrera, c.nom_carrera
ORDER BY alumnos DESC, c.cod_carrera;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuantos alumnos tiene cada facultad?
SELECT f.nom_facultad, COUNT(a.ced_alumno) AS alumnos
FROM usr_admin_uni.facultad f
LEFT JOIN usr_admin_uni.carrera c ON c.cod_fac = f.cod_fac
LEFT JOIN usr_admin_uni.alumnos a ON a.cod_carrera = c.cod_carrera
GROUP BY f.nom_facultad
ORDER BY alumnos DESC, f.nom_facultad;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuantos alumnos viven en cada barrio?
SELECT b.nom_barrio, COUNT(a.ced_alumno) AS alumnos
FROM usr_admin_uni.barrios b
LEFT JOIN usr_admin_uni.alumnos a ON a.id_barrio = b.id_barrio
GROUP BY b.nom_barrio
ORDER BY alumnos DESC, b.nom_barrio;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnos no informaron su barrio?
SELECT ced_alumno, nombre, apellido
FROM usr_admin_uni.alumnos
WHERE id_barrio IS NULL;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cual es el promedio, el minimo y el maximo por carrera?
SELECT c.nom_carrera,
       COUNT(a.promedio) AS con_promedio,
       ROUND(AVG(a.promedio), 2) AS promedio,
       MIN(a.promedio) AS minimo,
       MAX(a.promedio) AS maximo
FROM usr_admin_uni.carrera c
JOIN usr_admin_uni.alumnos a ON a.cod_carrera = c.cod_carrera
GROUP BY c.nom_carrera
ORDER BY promedio DESC;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnas estudian Ingenieria de Sistemas?
SELECT nombre, apellido, promedio
FROM usr_admin_uni.alumnos
WHERE genero = 'F'
  AND cod_carrera = 'SIS'
ORDER BY apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnos todavia no tienen promedio?
SELECT nombre, apellido, cod_carrera
FROM usr_admin_uni.alumnos
WHERE promedio IS NULL
ORDER BY apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnos tienen un apellido que empieza por M?
SELECT nombre, apellido
FROM usr_admin_uni.alumnos
WHERE apellido LIKE 'M%'
ORDER BY apellido, nombre;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnos nacieron en 2004?
SELECT nombre, apellido, TO_CHAR(fecha_nac, 'YYYY-MM-DD') AS nacimiento
FROM usr_admin_uni.alumnos
WHERE fecha_nac BETWEEN DATE '2004-01-01' AND DATE '2004-12-31'
ORDER BY fecha_nac;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que carreras tienen mas de 6 alumnos?
SELECT cod_carrera, COUNT(*) AS alumnos
FROM usr_admin_uni.alumnos
GROUP BY cod_carrera
HAVING COUNT(*) > 6
ORDER BY alumnos DESC, cod_carrera;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnos de Medicina o Enfermeria tienen promedio de 4.0 o mas?
SELECT nombre, apellido, cod_carrera, promedio
FROM usr_admin_uni.alumnos
WHERE cod_carrera IN ('MED', 'ENF')
  AND promedio >= 4
ORDER BY promedio DESC, apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: AND se evalua antes que OR: cuantas filas devuelve cada version?
SELECT COUNT(*) AS sin_parentesis
FROM usr_admin_uni.alumnos
WHERE cod_carrera = 'SIS' OR cod_carrera = 'IND' AND genero = 'F';

SELECT COUNT(*) AS con_parentesis
FROM usr_admin_uni.alumnos
WHERE (cod_carrera = 'SIS' OR cod_carrera = 'IND') AND genero = 'F';

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: En que barrios viven los alumnos de Sistemas? (sin repetir)
SELECT DISTINCT b.nom_barrio
FROM usr_admin_uni.alumnos a
JOIN usr_admin_uni.barrios b ON b.id_barrio = a.id_barrio
WHERE a.cod_carrera = 'SIS'
ORDER BY b.nom_barrio;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que alumnos pertenecen a la facultad de Ciencias de la Salud?
SELECT a.nombre, a.apellido, c.nom_carrera
FROM usr_admin_uni.alumnos a
JOIN usr_admin_uni.carrera c ON c.cod_carrera = a.cod_carrera
JOIN usr_admin_uni.facultad f ON f.cod_fac = c.cod_fac
WHERE f.cod_fac = 'SAL'
ORDER BY c.nom_carrera, a.apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Cerrar la evidencia y revisarla
PROMPT ==== FIN DEL EJERCICIO 2 ====
SPOOL OFF
