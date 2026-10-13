-- ============================================================
-- ej1_02_esquema.sql
-- Ruta practica Oracle - Ejercicio 1: Propietarios y vehiculos
-- 02 - Esquema (administrador): tablas, restricciones, usuario de consultas y sus permisos (etapas 3 a 5).
-- Usuario: USR_ADMIN_VEH  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej1_02_esquema.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_veh@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND
PROMPT Etapa 3 - USR_ADMIN_VEH crea las tablas

-- ------------------------------------------------------------
-- Crear la tabla PROPIETARIO
CREATE TABLE propietario (
  id_propietario   VARCHAR2(10 CHAR),
  primer_nombre    VARCHAR2(15 CHAR) NOT NULL,
  segundo_nombre   VARCHAR2(15 CHAR),
  primer_apellido  VARCHAR2(20 CHAR) NOT NULL,
  segundo_apellido VARCHAR2(20 CHAR),
  telefono         VARCHAR2(10 CHAR),
  correo           VARCHAR2(100 CHAR),
  sexo             CHAR(1) NOT NULL
);

-- Verificacion
DESC propietario

-- ------------------------------------------------------------
-- Crear la tabla MARCA
CREATE TABLE marca (
  id_marca  NUMBER(3),
  nom_marca VARCHAR2(20 CHAR) NOT NULL
);

-- Verificacion
DESC marca

-- ------------------------------------------------------------
-- Crear la tabla VEHICULO
CREATE TABLE vehiculo (
  placa      VARCHAR2(6 CHAR),
  linea      VARCHAR2(20 CHAR) NOT NULL,
  modelo     NUMBER(4) NOT NULL,
  cilindraje NUMBER(5) NOT NULL,
  id_marca   NUMBER(3) NOT NULL
);

-- Verificacion
DESC vehiculo

-- ------------------------------------------------------------
-- Crear la tabla PROP_VEH
CREATE TABLE prop_veh (
  id_propietario    VARCHAR2(10 CHAR),
  placa             VARCHAR2(6 CHAR),
  fecha_adquisicion DATE NOT NULL
);

-- Verificacion
DESC prop_veh

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE propietario
  ADD CONSTRAINT pk_propietario PRIMARY KEY (id_propietario);

ALTER TABLE marca
  ADD CONSTRAINT pk_marca PRIMARY KEY (id_marca);

ALTER TABLE vehiculo
  ADD CONSTRAINT pk_vehiculo PRIMARY KEY (placa);

ALTER TABLE prop_veh
  ADD CONSTRAINT pk_prop_veh PRIMARY KEY (id_propietario, placa);

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
ALTER TABLE vehiculo
  ADD CONSTRAINT fk_vehiculo_marca
  FOREIGN KEY (id_marca) REFERENCES marca (id_marca);

ALTER TABLE prop_veh
  ADD CONSTRAINT fk_propveh_propietario
  FOREIGN KEY (id_propietario) REFERENCES propietario (id_propietario);

ALTER TABLE prop_veh
  ADD CONSTRAINT fk_propveh_vehiculo
  FOREIGN KEY (placa) REFERENCES vehiculo (placa);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, table_name, r_constraint_name
FROM user_constraints
WHERE constraint_type = 'R'
ORDER BY table_name, constraint_name;

-- ------------------------------------------------------------
-- Agregar UNIQUE y CHECK
PROMPT Etapa 3 - UNIQUE y CHECK
ALTER TABLE marca
  ADD CONSTRAINT uq_marca_nombre UNIQUE (nom_marca);

ALTER TABLE vehiculo
  ADD CONSTRAINT chk_vehiculo_modelo CHECK (modelo >= 1950);

ALTER TABLE propietario
  ADD CONSTRAINT chk_propietario_sexo CHECK (sexo IN ('M', 'F'));

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_VEH): crear el usuario de consultas USR_CONSULTAS_VEH
PROMPT Etapa 4 - USR_ADMIN_VEH crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_VEH: ' HIDE
CREATE USER usr_consultas_veh
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_vehiculos
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej1_vehiculos.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_VEH creo el usuario USR_CONSULTAS_VEH

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_VEH';

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_VEH): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_VEH concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_veh;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_VEH): privilegios sobre objetos
GRANT SELECT, INSERT ON propietario TO usr_consultas_veh;
GRANT SELECT, INSERT ON marca TO usr_consultas_veh;
GRANT SELECT, INSERT ON vehiculo TO usr_consultas_veh;
GRANT SELECT, INSERT ON prop_veh TO usr_consultas_veh;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_VEH'
ORDER BY table_name, privilege;

SPOOL OFF
