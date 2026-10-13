-- ============================================================
-- ej4_02_esquema.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- 02 - Esquema (administrador): tablas, restricciones, usuario de consultas y sus permisos (etapas 3 a 5).
-- Usuario: USR_ADMIN_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_02_esquema.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND
PROMPT Etapa 3 - USR_ADMIN_PAS crea las tablas

-- ------------------------------------------------------------
-- Crear la tabla PAIS
CREATE TABLE pais (
  cod_pais CHAR(3),
  nom_pais VARCHAR2(40 CHAR) NOT NULL
);

-- Verificacion
DESC pais

-- ------------------------------------------------------------
-- Crear la tabla PERSONA
CREATE TABLE persona (
  id_persona VARCHAR2(10 CHAR),
  nombre     VARCHAR2(15 CHAR) NOT NULL,
  apellido   VARCHAR2(20 CHAR) NOT NULL,
  fecha_nac  DATE NOT NULL
);

-- Verificacion
DESC persona

-- ------------------------------------------------------------
-- Crear la tabla PASAPORTE_VIGENTE
CREATE TABLE pasaporte_vigente (
  num_pasaporte     VARCHAR2(9 CHAR),
  id_persona        VARCHAR2(10 CHAR) NOT NULL,
  cod_pais          CHAR(3) NOT NULL,
  fecha_expedicion  DATE NOT NULL,
  fecha_vencimiento DATE NOT NULL
);

-- Verificacion
DESC pasaporte_vigente

-- ------------------------------------------------------------
-- Agregar las PRIMARY KEY
PROMPT Etapa 3 - PRIMARY KEY
ALTER TABLE pais
  ADD CONSTRAINT pk_pais PRIMARY KEY (cod_pais);

ALTER TABLE persona
  ADD CONSTRAINT pk_persona PRIMARY KEY (id_persona);

ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT pk_pasaporte PRIMARY KEY (num_pasaporte);

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
ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT fk_pasaporte_persona
  FOREIGN KEY (id_persona) REFERENCES persona (id_persona);

ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT fk_pasaporte_pais
  FOREIGN KEY (cod_pais) REFERENCES pais (cod_pais);

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
ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT uq_pasaporte_persona UNIQUE (id_persona);

ALTER TABLE pasaporte_vigente
  ADD CONSTRAINT chk_pasaporte_fechas CHECK (fecha_vencimiento > fecha_expedicion);

-- Verificacion
COLUMN constraint_name FORMAT A24
COLUMN table_name FORMAT A18
COLUMN r_constraint_name FORMAT A20
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE constraint_name NOT LIKE 'SYS%'
ORDER BY table_name, constraint_type, constraint_name;

-- ------------------------------------------------------------
-- Etapa 4 (USR_ADMIN_PAS): crear el usuario de consultas USR_CONSULTAS_PAS
PROMPT Etapa 4 - USR_ADMIN_PAS crea el usuario de consultas
SPOOL OFF
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_PAS: ' HIDE
CREATE USER usr_consultas_pas
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_pasaportes
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt APPEND
PROMPT Etapa 4 - USR_ADMIN_PAS creo el usuario USR_CONSULTAS_PAS

-- Verificacion
COLUMN username FORMAT A18
SELECT username, created
FROM all_users
WHERE username = 'USR_CONSULTAS_PAS';

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PAS): conceder CREATE SESSION al usuario de consultas
PROMPT Etapa 5 - USR_ADMIN_PAS concede privilegios al usuario de consultas
GRANT CREATE SESSION TO usr_consultas_pas;

-- Verificacion
COLUMN privilege FORMAT A16
SELECT privilege, admin_option
FROM user_sys_privs
ORDER BY privilege;

-- ------------------------------------------------------------
-- Etapa 5 (USR_ADMIN_PAS): privilegios sobre objetos
GRANT SELECT, INSERT ON pais TO usr_consultas_pas;
GRANT SELECT, INSERT ON persona TO usr_consultas_pas;
GRANT SELECT, INSERT ON pasaporte_vigente TO usr_consultas_pas;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN table_name FORMAT A18
COLUMN privilege FORMAT A10
SELECT grantee, table_name, privilege
FROM user_tab_privs_made
WHERE grantee = 'USR_CONSULTAS_PAS'
ORDER BY table_name, privilege;

SPOOL OFF
