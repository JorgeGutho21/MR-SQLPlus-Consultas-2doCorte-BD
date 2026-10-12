-- ============================================================
-- ej3_01_system_tablespace_admin.sql
-- Ruta practica Oracle - Ejercicio 3: Clientes y pedidos
-- Etapas 1, 2 y 3 (SYSTEM): tablespace, datafile, usuario administrador y sus privilegios del sistema.
-- Usuario: SYSTEM  |  Servicio: localhost:1521/XEPDB1
-- Ejecutar desde SQL*Plus con:  @C:\archivosbd\ej3_01_system_tablespace_admin.sql
-- Las contrasenas NO estan en el archivo: SQL*Plus las pide ocultas.
-- ============================================================
SET VERIFY OFF

CONNECT system@localhost:1521/XEPDB1
SHOW USER
SPOOL C:\archivosbd\evidencia_ej3_pedidos.txt APPEND

-- ------------------------------------------------------------
-- Crear el TABLESPACE y su DATAFILE
CREATE TABLESPACE ts_pedidos
  DATAFILE 'C:\ORACLE_EXE\ORADATA\XE\XEPDB1\TS_PEDIDOS01.DBF'
  SIZE 20M
  AUTOEXTEND ON NEXT 5M
  MAXSIZE 100M;

-- Verificacion
COLUMN tablespace_name FORMAT A15
COLUMN file_name FORMAT A55
SELECT tablespace_name, status, contents
FROM dba_tablespaces
WHERE tablespace_name = 'TS_PEDIDOS';

SELECT file_name, bytes/1024/1024 AS mb, autoextensible
FROM dba_data_files
WHERE tablespace_name = 'TS_PEDIDOS';

-- ------------------------------------------------------------
-- Crear el usuario administrador USR_ADMIN_PED
ACCEPT clave_admin CHAR PROMPT 'Clave para USR_ADMIN_PED: ' HIDE
CREATE USER usr_admin_ped
  IDENTIFIED BY "&clave_admin"
  DEFAULT TABLESPACE ts_pedidos
  TEMPORARY TABLESPACE temp
  QUOTA 20M ON ts_pedidos;
UNDEFINE clave_admin
PROMPT Etapa 2 - SYSTEM creo el usuario administrador USR_ADMIN_PED

-- Verificacion
COLUMN username FORMAT A18
COLUMN default_tablespace FORMAT A16
COLUMN temporary_tablespace FORMAT A10
COLUMN account_status FORMAT A14
SELECT username, default_tablespace, temporary_tablespace, account_status
FROM dba_users
WHERE username = 'USR_ADMIN_PED';

SELECT tablespace_name, max_bytes/1024/1024 AS cuota_mb
FROM dba_ts_quotas
WHERE username = 'USR_ADMIN_PED';

-- ------------------------------------------------------------
-- Etapa 3 (SYSTEM): privilegios del sistema para USR_ADMIN_PED
PROMPT Etapa 3 - SYSTEM otorga privilegios a USR_ADMIN_PED
GRANT CREATE SESSION, CREATE TABLE TO usr_admin_ped;

-- Verificacion
COLUMN grantee FORMAT A18
COLUMN privilege FORMAT A16
SELECT grantee, privilege
FROM dba_sys_privs
WHERE grantee = 'USR_ADMIN_PED'
ORDER BY privilege;

SPOOL OFF
