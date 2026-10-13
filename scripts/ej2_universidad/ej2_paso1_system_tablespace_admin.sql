-- ============================================================
-- ej2_paso1_system_tablespace_admin.sql
-- Ruta practica Oracle - Ejercicio 2: Sistema universitario
-- Paso 1 de 7. Etapas 1, 2 y 3 (SYSTEM): tablespace, datafile, usuario administrador y sus privilegios del sistema.
-- Usuario: SYSTEM  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej2_paso1_system_tablespace_admin.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT system@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
PROMPT ==== EJERCICIO 2: SISTEMA UNIVERSITARIO ====
PROMPT Etapa 1 - SYSTEM crea el TABLESPACE y su DATAFILE

-- ------------------------------------------------------------
-- Crear el TABLESPACE y su DATAFILE
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
-- Crear el usuario administrador USR_ADMIN_UNI
SPOOL OFF
ACCEPT clave_admin CHAR PROMPT 'Clave para USR_ADMIN_UNI: ' HIDE
CREATE USER usr_admin_uni
  IDENTIFIED BY "&clave_admin"
  DEFAULT TABLESPACE ts_universidad
  TEMPORARY TABLESPACE temp
  QUOTA 20M ON ts_universidad;
UNDEFINE clave_admin
SPOOL C:\archivosbd\evidencia_ej2_universidad.txt APPEND
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
-- Etapa 3 (SYSTEM): privilegios del sistema para USR_ADMIN_UNI
PROMPT Etapa 3 - SYSTEM otorga privilegios a USR_ADMIN_UNI
GRANT CREATE SESSION, CREATE TABLE, CREATE USER TO usr_admin_uni;
GRANT CREATE SESSION TO usr_admin_uni WITH ADMIN OPTION;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege, admin_option
FROM dba_sys_privs
WHERE grantee = 'USR_ADMIN_UNI'
ORDER BY privilege;

SPOOL OFF
