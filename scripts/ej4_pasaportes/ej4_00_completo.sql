-- ============================================================
-- ej4_00_completo.sql
-- Ruta practica Oracle - Ejercicio 4: Personas y pasaportes vigentes
-- Script completo: las seis etapas en orden, con cambios de usuario y evidencia SPOOL.
-- Usuario: SYSTEM -> USR_ADMIN_PAS -> SYSTEM -> USR_ADMIN_PAS -> USR_CONSULTAS_PAS  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej4_00_completo.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
-- Abrir antes:  cd /d C:\archivosbd   y   sqlplus /nolog
SET VERIFY OFF

-- ------------------------------------------------------------
-- [Etapa 1] Conectarte como SYSTEM a XEPDB1
CONNECT system@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 1] Iniciar la evidencia con SPOOL y confirmar la sesion
SPOOL C:\archivosbd\evidencia_ej4_pasaportes.txt
PROMPT ==== EJERCICIO 4: PERSONAS Y PASAPORTES VIGENTES ====
PROMPT Etapa 1 - SYSTEM crea el TABLESPACE y su DATAFILE
SHOW USER
SHOW CON_NAME

-- ------------------------------------------------------------
-- [Etapa 1] Crear el TABLESPACE y su DATAFILE
CREATE TABLESPACE ts_pasaportes
  DATAFILE 'C:\ORACLE_EXE\ORADATA\XE\XEPDB1\TS_PASAPORTES01.DBF'
  SIZE 20M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 100M;

-- Verificacion
COLUMN tablespace_name FORMAT A15
COLUMN file_name FORMAT A55
SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name = 'TS_PASAPORTES';

SELECT file_name, bytes/1024/1024 AS mb, autoextensible
FROM dba_data_files
WHERE tablespace_name = 'TS_PASAPORTES';

-- ------------------------------------------------------------
-- [Etapa 2] Crear el usuario administrador USR_ADMIN_PAS
ACCEPT clave_admin CHAR PROMPT 'Clave para USR_ADMIN_PAS: ' HIDE
CREATE USER usr_admin_pas
  IDENTIFIED BY "&clave_admin"
  DEFAULT TABLESPACE ts_pasaportes
  TEMPORARY TABLESPACE temp
  QUOTA 20M ON ts_pasaportes;
UNDEFINE clave_admin
PROMPT Etapa 2 - SYSTEM creo el usuario administrador USR_ADMIN_PAS

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_ADMIN_PAS';

SELECT tablespace_name, max_bytes/1024/1024 AS cuota_mb
FROM dba_ts_quotas
WHERE username = 'USR_ADMIN_PAS';

-- ------------------------------------------------------------
-- [Etapa 3] Etapa 3 (SYSTEM): privilegios del sistema para USR_ADMIN_PAS
PROMPT Etapa 3 - SYSTEM otorga privilegios a USR_ADMIN_PAS
GRANT CREATE SESSION, CREATE TABLE TO usr_admin_pas;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_ADMIN_PAS'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 3] Conectarte como USR_ADMIN_PAS
CONNECT usr_admin_pas@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 3 - USR_ADMIN_PAS crea las tablas

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla PAIS
CREATE TABLE pais (
  cod_pais CHAR(3),
  nom_pais VARCHAR2(40 CHAR) NOT NULL
);

-- Verificacion
DESC pais

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla PERSONA
CREATE TABLE persona (
  id_persona VARCHAR2(10 CHAR),
  nombre     VARCHAR2(15 CHAR) NOT NULL,
  apellido   VARCHAR2(20 CHAR) NOT NULL,
  fecha_nac  DATE NOT NULL
);

-- Verificacion
DESC persona

-- ------------------------------------------------------------
-- [Etapa 3] Crear la tabla PASAPORTE_VIGENTE
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
-- [Etapa 3] Agregar las PRIMARY KEY
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
-- [Etapa 3] Agregar las FOREIGN KEY
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
-- [Etapa 3] Agregar UNIQUE y CHECK
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
-- [Etapa 4] Etapa 4: volver a SYSTEM
CONNECT system@localhost:1521/XEPDB1
PROMPT Etapa 4 - SYSTEM crea el usuario de consultas

-- ------------------------------------------------------------
-- [Etapa 4] Crear el usuario de consultas USR_CONSULTAS_PAS
ACCEPT clave_cons CHAR PROMPT 'Clave para USR_CONSULTAS_PAS: ' HIDE
CREATE USER usr_consultas_pas
  IDENTIFIED BY "&clave_cons"
  DEFAULT TABLESPACE ts_pasaportes
  TEMPORARY TABLESPACE temp;
UNDEFINE clave_cons
PROMPT Etapa 4 - SYSTEM creo el usuario USR_CONSULTAS_PAS

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_CONSULTAS_PAS';

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (SYSTEM): privilegio del sistema CREATE SESSION
PROMPT Etapa 5 - Privilegios del usuario de consultas
GRANT CREATE SESSION TO usr_consultas_pas;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_CONSULTAS_PAS'
ORDER BY privilege;

-- ------------------------------------------------------------
-- [Etapa 5] Volver a USR_ADMIN_PAS, dueno de las tablas
CONNECT usr_admin_pas@localhost:1521/XEPDB1

-- ------------------------------------------------------------
-- [Etapa 5] Etapa 5 (USR_ADMIN_PAS): privilegios sobre objetos
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

-- ------------------------------------------------------------
-- [Etapa 6] Etapa 6: conectarte como USR_CONSULTAS_PAS y preparar la pantalla
CONNECT usr_consultas_pas@localhost:1521/XEPDB1
SHOW USER
PROMPT Etapa 6 - USR_CONSULTAS_PAS inserta, confirma y consulta
SET LINESIZE 200
SET PAGESIZE 100

-- ------------------------------------------------------------
-- [Etapa 6] Comprobar por que hace falta ESQUEMA.TABLA
-- ERRORES ESPERADOS (prueba intencional): ORA-00942
SELECT COUNT(*) FROM pais;

SELECT COUNT(*) FROM usr_admin_pas.pais;

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en PAIS (5 filas)
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('COL', 'Colombia');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('ECU', 'Ecuador');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('PER', 'Peru');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('MEX', 'Mexico');
INSERT INTO usr_admin_pas.pais (cod_pais, nom_pais)
VALUES ('ESP', 'Espana');

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en PERSONA (8 filas)
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('52123456', 'Camila', 'Ruiz', DATE '1995-04-18');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('79234567', 'Andres', 'Salazar', DATE '1988-11-02');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1010345678', 'Lucia', 'Mejia', DATE '2001-07-25');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1020456789', 'Mateo', 'Cardenas', DATE '1999-01-09');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1030567890', 'Isabel', 'Torres', DATE '1992-09-30');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1040678901', 'Santiago', 'Rincon', DATE '2003-03-14');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1050789012', 'Valentina', 'Ospina', DATE '1997-12-05');
INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1060890123', 'Diego', 'Navarro', DATE '1985-06-21');

-- ------------------------------------------------------------
-- [Etapa 6] Insertar en PASAPORTE_VIGENTE (5 filas)
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AT1234567', '52123456', 'COL', DATE '2022-02-10', DATE '2032-02-09');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AU2345678', '79234567', 'COL', DATE '2019-08-15', DATE '2029-08-14');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('A45678901', '1020456789', 'ECU', DATE '2021-05-03', DATE '2027-05-02');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('PE7654321', '1030567890', 'PER', DATE '2024-10-20', DATE '2029-10-19');
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('G12345678', '1060890123', 'MEX', DATE '2023-01-12', DATE '2029-01-11');

-- ------------------------------------------------------------
-- [Etapa 6] Confirmar con COMMIT y contar las filas
COMMIT;

SELECT 'PAIS' AS tabla, COUNT(*) AS filas FROM usr_admin_pas.pais
UNION ALL
SELECT 'PERSONA' AS tabla, COUNT(*) AS filas FROM usr_admin_pas.persona
UNION ALL
SELECT 'PASAPORTE_VIGENTE' AS tabla, COUNT(*) AS filas FROM usr_admin_pas.pasaporte_vigente;

-- ------------------------------------------------------------
-- [Etapa 6] Pruebas de integridad: errores esperados
-- ERRORES ESPERADOS (prueba intencional): ORA-00001, ORA-02290, ORA-02291, ORA-01400
PROMPT Pruebas intencionales: cada sentencia debe fallar
INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AT9999999', '52123456', 'COL', DATE '2025-01-10', DATE '2035-01-09');

INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('AX1111111', '1010345678', 'COL', DATE '2025-03-01', DATE '2024-03-01');

INSERT INTO usr_admin_pas.pasaporte_vigente (num_pasaporte, id_persona, cod_pais, fecha_expedicion, fecha_vencimiento)
VALUES ('ZZ2222222', '1040678901', 'XXX', DATE '2025-03-01', DATE '2035-03-01');

INSERT INTO usr_admin_pas.persona (id_persona, nombre, apellido, fecha_nac)
VALUES ('1070901234', NULL, 'Prieto', DATE '2000-02-02');

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que pasaporte tiene cada persona?
SELECT pe.nombre, pe.apellido, pa.num_pasaporte, pa.cod_pais
FROM usr_admin_pas.persona pe
LEFT JOIN usr_admin_pas.pasaporte_vigente pa ON pa.id_persona = pe.id_persona
ORDER BY pe.apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que personas no tienen pasaporte vigente?
SELECT pe.id_persona, pe.nombre, pe.apellido
FROM usr_admin_pas.persona pe
LEFT JOIN usr_admin_pas.pasaporte_vigente pa ON pa.id_persona = pe.id_persona
WHERE pa.num_pasaporte IS NULL
ORDER BY pe.apellido;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Cuantos pasaportes registrados expidio cada pais?
SELECT pi.cod_pais, pi.nom_pais, COUNT(pa.num_pasaporte) AS pasaportes
FROM usr_admin_pas.pais pi
LEFT JOIN usr_admin_pas.pasaporte_vigente pa ON pa.cod_pais = pi.cod_pais
GROUP BY pi.cod_pais, pi.nom_pais
ORDER BY pasaportes DESC, pi.cod_pais;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que pasaportes vencen antes de 2030?
SELECT pa.num_pasaporte, pe.nombre, pe.apellido,
       TO_CHAR(pa.fecha_vencimiento, 'YYYY-MM-DD') AS vence
FROM usr_admin_pas.pasaporte_vigente pa
JOIN usr_admin_pas.persona pe ON pe.id_persona = pa.id_persona
WHERE pa.fecha_vencimiento < DATE '2030-01-01'
ORDER BY pa.fecha_vencimiento;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Que personas nacidas antes de 1995 tienen pasaporte?
SELECT pe.nombre, pe.apellido, TO_CHAR(pe.fecha_nac, 'YYYY-MM-DD') AS nacimiento, pa.cod_pais
FROM usr_admin_pas.persona pe
JOIN usr_admin_pas.pasaporte_vigente pa ON pa.id_persona = pe.id_persona
WHERE pe.fecha_nac < DATE '1995-01-01'
ORDER BY pe.fecha_nac;

-- ------------------------------------------------------------
-- [Etapa 6] Consulta: Alguien tiene mas de un pasaporte vigente?
SELECT id_persona, COUNT(*) AS pasaportes
FROM usr_admin_pas.pasaporte_vigente
GROUP BY id_persona
HAVING COUNT(*) > 1;

-- ------------------------------------------------------------
-- [Etapa 6] Cerrar la evidencia y revisarla
PROMPT ==== FIN DEL EJERCICIO 4 ====
SPOOL OFF
