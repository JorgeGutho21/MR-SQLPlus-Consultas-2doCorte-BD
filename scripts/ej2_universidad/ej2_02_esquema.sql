-- ============================================================
-- ej2_02_esquema.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- 02 - Esquema (administrador): tablas, restricciones, usuario de consultas y sus permisos (etapas 3 a 5).
-- Usuario: USR_ADMIN_UNI  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_02_esquema.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_uni@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT Etapa 3 - USR_ADMIN_UNI crea las tablas

-- ------------------------------------------------------------
-- Crear la tabla FACULTAD
CREATE TABLE facultad (
  cod_fac      VARCHAR2(3 CHAR),
  nom_facultad VARCHAR2(30 CHAR) NOT NULL
);

-- Verificacion
DESC facultad

-- ------------------------------------------------------------
-- Crear la tabla CARRERA
CREATE TABLE carrera (
  cod_carrera VARCHAR2(3 CHAR),
  nom_carrera VARCHAR2(30 CHAR) NOT NULL,
  cod_fac     VARCHAR2(3 CHAR) NOT NULL
);

-- Verificacion
DESC carrera

-- ------------------------------------------------------------
-- Crear la tabla BARRIOS
CREATE TABLE barrios (
  id_barrio  NUMBER(3),
  nom_barrio VARCHAR2(30 CHAR) NOT NULL
);

-- Verificacion
DESC barrios

-- ------------------------------------------------------------
-- Crear la tabla ALUMNOS
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
-- Agregar las PRIMARY KEY
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
-- Agregar las FOREIGN KEY
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
-- Agregar CHECK
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
-- Requisito nuevo: agregar fecha_nac con ALTER TABLE
PROMPT Etapa 3 - Cambio de requisitos: fecha de nacimiento
ALTER TABLE alumnos
  ADD fecha_nac DATE;

-- Verificacion
DESC alumnos

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_UNI): crear el usuario de consultas USR_CONSULTAS_UNI
PROMPT Etapa 4 - USR_ADMIN_UNI crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_UNI: ' HIDE
CREATE USER usr_consultas_uni
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_universidad
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_UNI creo el usuario USR_CONSULTAS_UNI

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_UNI';

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_UNI): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_UNI concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_uni;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_UNI): privilegios sobre objetos
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

SPOOL OFF
